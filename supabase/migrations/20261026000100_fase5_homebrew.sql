-- =====================================================================
-- F.R.A.N.C.E — FASE 5: Homebrew completo, monstros em combate, imagens
-- Incremental sobre a Fase 4. Não apaga tabelas nem dados; pode ser reaplicada.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. Ajudantes
-- ---------------------------------------------------------------------
create or replace function public.try_uuid(p text) returns uuid
language sql immutable as $$
  select case when p ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then p::uuid end
$$;

-- Caminho de imagem válido dentro do bucket: <pasta>/<id>/<arquivo>.(webp|png|jpg|jpeg)
create or replace function public.is_media_path(p text, p_folder text, p_owner text) returns boolean
language sql immutable as $$
  select p is null or (
    split_part(p, '/', 1) = p_folder
    and split_part(p, '/', 2) = p_owner
    and split_part(p, '/', 3) ~ '^[A-Za-z0-9_-]{1,80}\.(webp|png|jpg|jpeg)$'
    and split_part(p, '/', 4) = ''
  )
$$;

-- ---------------------------------------------------------------------
-- 1. HOMEBREW: categorias, imagem, tamanho
-- ---------------------------------------------------------------------
alter table public.homebrew drop constraint if exists homebrew_kind_check;
alter table public.homebrew add constraint homebrew_kind_check
  check (kind in ('item', 'arma', 'modificador', 'monstro', 'npc', 'item_especial', 'outro'));
alter table public.homebrew add column if not exists image_path text;
alter table public.homebrew drop constraint if exists homebrew_data_size;
alter table public.homebrew add constraint homebrew_data_size check (pg_column_size(data) <= 262144);
create index if not exists homebrew_owner_updated_idx on public.homebrew (owner_id, updated_at desc);

create or replace function public.guard_homebrew() returns trigger
language plpgsql as $$
begin
  if not public.is_media_path(new.image_path, 'homebrew', new.owner_id::text) then
    raise exception 'Imagem inválida para este conteúdo.';
  end if;
  if tg_op = 'UPDATE' and new.owner_id <> old.owner_id then
    raise exception 'O autor de um conteúdo não muda.';
  end if;
  return new;
end $$;
drop trigger if exists homebrew_guard on public.homebrew;
create trigger homebrew_guard before insert or update on public.homebrew
  for each row execute function public.guard_homebrew();

-- ---------------------------------------------------------------------
-- 2. COMPARTILHAMENTO com campanhas (o modelo continua do autor)
-- ---------------------------------------------------------------------
create table if not exists public.homebrew_shares (
  homebrew_id uuid not null references public.homebrew (id) on delete cascade,
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  shared_by uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (homebrew_id, campaign_id)
);
create index if not exists homebrew_shares_campaign_idx on public.homebrew_shares (campaign_id);
alter table public.homebrew_shares enable row level security;

-- Só conteúdos de equipamento podem ser compartilhados (fichas de monstros/NPCs têm segredos do Mestre).
create or replace function public.guard_homebrew_share() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  hb public.homebrew;
begin
  select * into hb from public.homebrew where id = new.homebrew_id;
  if hb.id is null or hb.owner_id <> auth.uid() then
    raise exception 'Só o autor compartilha o conteúdo.';
  end if;
  if hb.kind not in ('item', 'arma', 'modificador', 'item_especial', 'outro') then
    raise exception 'Monstros e NPCs não são compartilhados com jogadores (use-os pelo Escudo do Mestre).';
  end if;
  if not public.is_campaign_master(new.campaign_id) then
    raise exception 'Só o Mestre da campanha disponibiliza conteúdos nela.';
  end if;
  new.shared_by := auth.uid();
  return new;
end $$;
drop trigger if exists homebrew_shares_guard on public.homebrew_shares;
create trigger homebrew_shares_guard before insert or update on public.homebrew_shares
  for each row execute function public.guard_homebrew_share();

drop policy if exists hb_shares_owner on public.homebrew_shares;
create policy hb_shares_owner on public.homebrew_shares for all to authenticated
  using (shared_by = auth.uid()) with check (shared_by = auth.uid());
drop policy if exists hb_shares_members on public.homebrew_shares;
create policy hb_shares_members on public.homebrew_shares for select to authenticated
  using (public.is_campaign_member(campaign_id));

-- Leitura (nunca escrita) de conteúdos compartilhados com campanhas de que participo.
create or replace function public.homebrew_shared_with_me(p_homebrew uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.homebrew_shares s
    join public.campaign_members m on m.campaign_id = s.campaign_id and m.user_id = auth.uid()
    where s.homebrew_id = p_homebrew
  )
$$;
grant execute on function public.homebrew_shared_with_me(uuid) to authenticated;
drop policy if exists homebrew_shared_select on public.homebrew;
create policy homebrew_shared_select on public.homebrew for select to authenticated
  using (public.homebrew_shared_with_me(id));

-- ---------------------------------------------------------------------
-- 3. FOTOS DOS PERSONAGENS (uma por forma: humana e Lenda são independentes)
-- ---------------------------------------------------------------------
alter table public.character_forms add column if not exists portrait_path text;

create or replace function public.guard_form_portrait() returns trigger
language plpgsql as $$
begin
  if new.portrait_path is distinct from (case when tg_op = 'UPDATE' then old.portrait_path end) then
    if not public.is_media_path(new.portrait_path, 'characters', new.character_id::text) then
      raise exception 'Foto inválida para este personagem.';
    end if;
    if auth.uid() is not null and not public.owns_character(new.character_id) then
      raise exception 'Só o dono do personagem troca a foto.';
    end if;
  end if;
  return new;
end $$;
drop trigger if exists character_forms_portrait on public.character_forms;
create trigger character_forms_portrait before insert or update on public.character_forms
  for each row execute function public.guard_form_portrait();

-- ---------------------------------------------------------------------
-- 4. INVENTÁRIO: imagem, usos e modificadores personalizados (cópia na arma)
-- ---------------------------------------------------------------------
alter table public.items add column if not exists image_path text;
alter table public.items add column if not exists custom_modifiers jsonb not null default '[]'::jsonb;
alter table public.items add column if not exists uses_max int;
alter table public.items add column if not exists uses_left int;
alter table public.items drop constraint if exists items_uses_check;
alter table public.items add constraint items_uses_check
  check ((uses_max is null and uses_left is null) or (uses_max between 1 and 9999 and uses_left between 0 and uses_max));
alter table public.items drop constraint if exists items_custom_modifiers_array;
alter table public.items add constraint items_custom_modifiers_array check (jsonb_typeof(custom_modifiers) = 'array' and jsonb_array_length(custom_modifiers) <= 6);

create or replace function public.validate_item() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  t text;
  m jsonb;
  req text;
  counted int := 0;
  official int := 0;
begin
  if not public.is_valid_dice(new.effect_dice) then
    raise exception 'Expressão de dados inválida: %', new.effect_dice;
  end if;
  if new.skill_override is not null and not (cfg -> 'skills') ? new.skill_override then
    raise exception 'Perícia inválida para a arma.';
  end if;
  foreach t in array new.tags loop
    if not exists (select 1 from jsonb_each_text(cfg -> 'weaponModifiers') x where x.value = t) then
      raise exception 'Categoria de arma inválida: %', t;
    end if;
  end loop;
  -- Imagem: só a de um modelo do Homebrew que quem grava consegue ler (próprio ou compartilhado com sua campanha).
  -- Sem isso, alguém poderia apontar para a imagem privada de outra pessoa e ganhar acesso a ela.
  if new.image_path is not null and auth.uid() is not null
     and (tg_op = 'INSERT' or new.image_path is distinct from old.image_path)
     and not exists (select 1 from public.homebrew h where h.image_path = new.image_path) then
    raise exception 'Imagem inválida.';
  end if;
  if jsonb_array_length(coalesce(new.custom_modifiers, '[]'::jsonb)) > 0 then
    if new.attack_kind is null then
      raise exception 'Modificadores só podem ser aplicados a armas.';
    end if;
    for m in select * from jsonb_array_elements(new.custom_modifiers) loop
      req := m ->> 'requires';
      if coalesce(m ->> 'name', '') = '' or req is null then
        raise exception 'Modificador personalizado incompleto.';
      end if;
      if req <> 'qualquer' and not (req = any (new.tags)) then
        raise exception 'Modificador "%" incompatível com esta arma.', m ->> 'name';
      end if;
      if not coalesce((m ->> 'ignoreLimit')::boolean, false) then
        counted := counted + 1;
      end if;
    end loop;
    if new.id is not null then
      select count(*) into official from public.item_modifiers where item_id = new.id and not is_temporary;
    end if;
    if official + counted > (cfg ->> 'maxWeaponModifiers')::int then
      raise exception 'Cada arma suporta até % modificações.', cfg ->> 'maxWeaponModifiers';
    end if;
  end if;
  return new;
end $$;

create or replace function public.validate_item_modifier() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  req text := cfg -> 'weaponModifiers' ->> new.modifier_id;
  it record;
  n int;
  custom int;
begin
  if req is null then
    raise exception 'Modificador desconhecido.';
  end if;
  select i.tags, i.attack_kind, i.custom_modifiers, c.origin_id, c.origin_path_id into it
  from public.items i join public.characters c on c.id = i.character_id where i.id = new.item_id;
  if it.attack_kind is null then
    raise exception 'Modificadores só podem ser aplicados a armas.';
  end if;
  if not (req = any (it.tags)) then
    raise exception 'Modificador incompatível com esta arma.';
  end if;
  if new.is_temporary then
    if not (it.origin_id = 'prodigio' and it.origin_path_id = 'arsenal') then
      raise exception 'Modificadores temporários são exclusivos do Caminho do Arsenal.';
    end if;
    select count(*) into n from public.item_modifiers where item_id = new.item_id and is_temporary and id <> new.id;
    if n >= 1 then
      raise exception 'Apenas um modificador temporário por vez.';
    end if;
  else
    select count(*) into n from public.item_modifiers where item_id = new.item_id and not is_temporary and id <> new.id;
    select count(*) into custom from jsonb_array_elements(coalesce(it.custom_modifiers, '[]'::jsonb)) x
      where not coalesce((x ->> 'ignoreLimit')::boolean, false);
    if n + custom >= (cfg ->> 'maxWeaponModifiers')::int then
      raise exception 'Cada arma suporta até % modificações.', cfg ->> 'maxWeaponModifiers';
    end if;
  end if;
  return new;
end $$;

-- Uso de item (consumível / cura / usos limitados): desconta de forma atômica.
create or replace function public.consume_item(p_item uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  it public.items;
begin
  select * into it from public.items where id = p_item for update;
  if it.id is null or not public.can_edit_character(it.character_id) then
    raise exception 'Sem permissão para usar este item.';
  end if;
  if it.uses_max is not null then
    if it.uses_left <= 0 then
      raise exception 'Este item não tem mais usos.';
    end if;
    update public.items set uses_left = uses_left - 1 where id = it.id returning * into it;
  elsif it.item_type = 'consumivel' then
    if it.quantity <= 0 then
      raise exception 'Quantidade esgotada.';
    end if;
    update public.items set quantity = quantity - 1 where id = it.id returning * into it;
  end if;
  return jsonb_build_object('quantity', it.quantity, 'uses_left', it.uses_left);
end $$;
revoke execute on function public.consume_item(uuid) from public, anon;
grant execute on function public.consume_item(uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 5. NPCs DA CAMPANHA: imagem e informações secretas
-- ---------------------------------------------------------------------
alter table public.npcs add column if not exists image_path text;

create or replace function public.guard_npc_image() returns trigger
language plpgsql as $$
declare
  master uuid;
begin
  select owner_id into master from public.campaigns where id = new.campaign_id;
  if new.image_path is not null and not (
       public.is_media_path(new.image_path, 'npcs', new.campaign_id::text)
       or public.is_media_path(new.image_path, 'homebrew', master::text)) then
    raise exception 'Imagem inválida para o NPC.';
  end if;
  return new;
end $$;
drop trigger if exists npcs_image on public.npcs;
create trigger npcs_image before insert or update on public.npcs
  for each row execute function public.guard_npc_image();

-- Antes os jogadores liam a linha inteira de NPCs visíveis (incluindo notas do Mestre).
-- Agora leem só a visão pública: nome, tipo, imagem, descrição e aparência.
drop policy if exists npcs_players on public.npcs;
drop view if exists public.npcs_public;
create view public.npcs_public with (security_barrier = true) as
select n.id, n.campaign_id, n.kind, n.name, n.image_path,
  coalesce(n.data ->> 'description', '') as description,
  coalesce(n.data ->> 'appearance', '') as appearance,
  n.conditions
from public.npcs n
where n.visible_to_players and public.is_campaign_member(n.campaign_id);
revoke all on public.npcs_public from anon;
grant select on public.npcs_public to authenticated;

-- ---------------------------------------------------------------------
-- 6. COMBATENTES: instâncias independentes de monstros/NPCs
-- ---------------------------------------------------------------------
alter table public.combatants add column if not exists data jsonb not null default '{}'::jsonb;
alter table public.combatants add column if not exists image_path text;
alter table public.combatants add column if not exists homebrew_id uuid references public.homebrew (id) on delete set null;
alter table public.combatants drop constraint if exists combatants_data_size;
alter table public.combatants add constraint combatants_data_size check (pg_column_size(data) <= 131072);

create or replace function public.guard_combatant() returns trigger
language plpgsql as $$
declare
  camp uuid;
  master uuid;
begin
  select c.campaign_id, k.owner_id into camp, master from public.combats c join public.campaigns k on k.id = c.campaign_id where c.id = new.combat_id;
  if new.character_id is not null then
    if not exists (select 1 from public.campaign_characters where campaign_id = camp and character_id = new.character_id and status = 'accepted') then
      raise exception 'Personagem não está aceito nesta campanha.';
    end if;
    new.kind := 'character';
    if new.form_id is null or not exists (select 1 from public.character_forms where id = new.form_id and character_id = new.character_id) then
      select cf.id into new.form_id from public.characters c
      join public.character_forms cf on cf.character_id = c.id
        and cf.kind = case when c.active_form = 'lenda' then 'lenda' else 'base' end and cf.setup_complete
      where c.id = new.character_id;
      if new.form_id is null then
        select id into new.form_id from public.character_forms where character_id = new.character_id and kind = 'base';
      end if;
    end if;
    new.pv_current := null; new.pv_max := null; new.pc_current := null; new.pc_max := null; -- valores vivos vêm da ficha
    new.data := '{}'::jsonb; new.homebrew_id := null; new.image_path := null;
  elsif new.npc_id is not null then
    if not exists (select 1 from public.npcs where id = new.npc_id and campaign_id = camp) then
      raise exception 'NPC de outra campanha.';
    end if;
    if new.kind not in ('npc', 'monstro') then
      select kind into new.kind from public.npcs where id = new.npc_id;
    end if;
  end if;
  -- Modelo do Homebrew: só do Mestre desta campanha (a instância é uma cópia; o modelo nunca muda).
  if new.homebrew_id is not null and (tg_op = 'INSERT' or new.homebrew_id is distinct from old.homebrew_id) then
    if not exists (select 1 from public.homebrew where id = new.homebrew_id and owner_id = master and kind in ('monstro', 'npc')) then
      raise exception 'Modelo do Homebrew inválido para esta campanha.';
    end if;
  end if;
  if new.image_path is not null and not (
       public.is_media_path(new.image_path, 'npcs', camp::text)
       or public.is_media_path(new.image_path, 'homebrew', master::text)) then
    raise exception 'Imagem inválida para o combatente.';
  end if;
  if new.pv_max is not null and new.pv_current is not null then
    new.pv_current := least(greatest(new.pv_current, 0), new.pv_max);
  end if;
  if new.pc_max is not null and new.pc_current is not null then
    new.pc_current := least(greatest(new.pc_current, 0), new.pc_max);
  end if;
  return new;
end $$;

-- Visão dos jogadores ganha a imagem (combatentes ocultos continuam fora).
drop view if exists public.combatants_public;
create view public.combatants_public with (security_barrier = true) as
select cb.id, cb.combat_id, cb.character_id, cb.npc_id, cb.kind, cb.form_id, cb.name, cb.initiative, cb.sort_order,
  case when cb.hide_stats then null when cb.character_id is not null then cf.pv_current else cb.pv_current end as pv_current,
  case when cb.hide_stats then null when cb.character_id is not null then public.form_pv_max(cf.id) else cb.pv_max end as pv_max,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then cf.pc_current else cb.pc_current end as pc_current,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then public.form_pc_max(cf.id) else cb.pc_max end as pc_max,
  case when cb.character_id is not null then cf.conditions else cb.conditions end as conditions,
  cb.hidden,
  case when cb.character_id is not null then cf.portrait_path else cb.image_path end as image_path
from public.combatants cb
join public.combats c on c.id = cb.combat_id
left join public.character_forms cf on cf.id = cb.form_id
left join public.characters ch on ch.id = cb.character_id
where public.is_campaign_member(c.campaign_id)
  and (not cb.hidden or public.is_campaign_master(c.campaign_id));
revoke all on public.combatants_public from anon;
grant select on public.combatants_public to authenticated;

-- Gasto de PC de habilidade de monstro: recusa se não houver PC suficiente (combat_apply só limita a 0).
create or replace function public.combatant_spend_pc(p_combatant uuid, p_amount int, p_request uuid, p_note text default '')
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre usa habilidades de criaturas.';
  end if;
  if cbt.character_id is not null then
    raise exception 'Personagens gastam PC pela própria ficha.';
  end if;
  if p_amount is null or p_amount < 0 or p_amount > 99999 then
    raise exception 'Custo inválido.';
  end if;
  if p_amount = 0 then
    return jsonb_build_object('before', cbt.pc_current, 'after', cbt.pc_current);
  end if;
  if coalesce(cbt.pc_current, 0) < p_amount then
    raise exception 'PC insuficiente (% de %).', coalesce(cbt.pc_current, 0), p_amount;
  end if;
  return public.combat_apply(p_combatant, 'pc_spend', p_amount, p_request, p_note);
end $$;
revoke execute on function public.combatant_spend_pc(uuid, int, uuid, text) from public, anon;
grant execute on function public.combatant_spend_pc(uuid, int, uuid, text) to authenticated;

-- ---------------------------------------------------------------------
-- 7. STORAGE: bucket privado + políticas (nada de base64 no banco)
-- ---------------------------------------------------------------------
-- Quem pode LER um arquivo:
--   characters/<personagem>/…  → quem pode ver a ficha (dono e Mestre de campanha com vínculo aceito)
--   homebrew/<autor>/…          → o autor; membros de campanha com o conteúdo compartilhado;
--                                 jogadores, quando a imagem está num NPC visível ou combatente não oculto
--   npcs/<campanha>/…           → o Mestre; jogadores, se o NPC estiver visível ou o combatente não oculto
create or replace function public.can_read_media(p_name text) returns boolean
language plpgsql stable security definer set search_path = public as $$
declare
  folder text := split_part(p_name, '/', 1);
  owner_id uuid := public.try_uuid(split_part(p_name, '/', 2));
begin
  if auth.uid() is null or owner_id is null then
    return false;
  end if;
  if folder = 'characters' then
    return public.can_view_character(owner_id);
  elsif folder = 'homebrew' then
    if owner_id = auth.uid() then
      return true;
    end if;
    if exists (select 1 from public.homebrew h where h.image_path = p_name and public.homebrew_shared_with_me(h.id)) then
      return true;
    end if;
  elsif folder = 'npcs' then
    if public.is_campaign_master(owner_id) then
      return true;
    end if;
  else
    return false;
  end if;
  return exists (select 1 from public.npcs n where n.image_path = p_name and n.visible_to_players and public.is_campaign_member(n.campaign_id))
      or exists (select 1 from public.combatants cb join public.combats c on c.id = cb.combat_id
                 where cb.image_path = p_name and not cb.hidden and public.is_campaign_member(c.campaign_id))
      or exists (select 1 from public.items i where i.image_path = p_name and public.can_view_character(i.character_id));
end $$;

-- Quem pode ENVIAR/TROCAR/APAGAR: só o dono da pasta.
create or replace function public.can_write_media(p_name text) returns boolean
language plpgsql stable security definer set search_path = public as $$
declare
  folder text := split_part(p_name, '/', 1);
  owner_id uuid := public.try_uuid(split_part(p_name, '/', 2));
begin
  if auth.uid() is null or owner_id is null or split_part(p_name, '/', 3) !~ '^[A-Za-z0-9_-]{1,80}\.(webp|png|jpg|jpeg)$' or split_part(p_name, '/', 4) <> '' then
    return false;
  end if;
  return case folder
    when 'characters' then public.owns_character(owner_id)
    when 'homebrew' then owner_id = auth.uid()
    when 'npcs' then public.is_campaign_master(owner_id)
    else false
  end;
end $$;
grant execute on function public.can_read_media(text), public.can_write_media(text) to authenticated;

do $$
begin
  if exists (select 1 from pg_namespace where nspname = 'storage')
     and exists (select 1 from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'storage' and c.relname = 'objects') then
    insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    values ('france-media', 'france-media', false, 2097152, array['image/webp', 'image/png', 'image/jpeg'])
    on conflict (id) do update set public = false, file_size_limit = 2097152, allowed_mime_types = array['image/webp', 'image/png', 'image/jpeg'];

    execute 'drop policy if exists france_media_read on storage.objects';
    execute 'drop policy if exists france_media_insert on storage.objects';
    execute 'drop policy if exists france_media_update on storage.objects';
    execute 'drop policy if exists france_media_delete on storage.objects';
    execute $p$create policy france_media_read on storage.objects for select to authenticated
             using (bucket_id = 'france-media' and public.can_read_media(name))$p$;
    execute $p$create policy france_media_insert on storage.objects for insert to authenticated
             with check (bucket_id = 'france-media' and public.can_write_media(name))$p$;
    execute $p$create policy france_media_update on storage.objects for update to authenticated
             using (bucket_id = 'france-media' and public.can_write_media(name))
             with check (bucket_id = 'france-media' and public.can_write_media(name))$p$;
    execute $p$create policy france_media_delete on storage.objects for delete to authenticated
             using (bucket_id = 'france-media' and public.can_write_media(name))$p$;
  end if;
end $$;

-- ---------------------------------------------------------------------
-- 8. Realtime (fotos e instâncias de combate)
-- ---------------------------------------------------------------------
do $$
declare
  t text;
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array['homebrew_shares'] loop
      if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
        execute format('alter publication supabase_realtime add table public.%I', t);
      end if;
    end loop;
  end if;
end $$;

grant select, insert, update, delete on public.homebrew_shares to authenticated;
