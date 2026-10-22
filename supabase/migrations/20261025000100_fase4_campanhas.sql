-- =====================================================================
-- F.R.A.N.C.E — Fase 4: Técnicas do Arsenal, campanhas, Escudo do Mestre
-- (Agentes, Combates, Investigação, Relatórios, Dados, Anotações).
-- INCREMENTAL: só adiciona tabelas/colunas/funções e redefine políticas.
-- Não apaga tabelas nem dados. Depende de 20261025000000_rules_sync_fase4.sql.
-- =====================================================================

-- =====================================================================
-- 1. TÉCNICAS DO ARSENAL
-- =====================================================================
create table if not exists public.character_techniques (
  id uuid primary key default gen_random_uuid(),
  character_id uuid not null references public.characters (id) on delete cascade,
  technique_id text not null,
  learned_level int not null check (learned_level between 1 and 20),
  created_at timestamptz not null default now(),
  unique (character_id, technique_id)
);

-- Contadores de cena / sessão / turno do personagem (limites de uso das técnicas).
create table if not exists public.character_trackers (
  character_id uuid primary key references public.characters (id) on delete cascade,
  scene int not null default 1 check (scene >= 1),
  session int not null default 1 check (session >= 1),
  turn int not null default 1 check (turn >= 1),
  updated_at timestamptz not null default now()
);

create table if not exists public.technique_uses (
  id bigint generated always as identity primary key,
  character_id uuid not null references public.characters (id) on delete cascade,
  technique_id text not null,
  scene int not null,
  session int not null,
  turn int not null,
  request_id uuid unique,
  data jsonb not null default '{}'::jsonb,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now()
);
create index if not exists technique_uses_char_idx on public.technique_uses (character_id, session, scene);

alter table public.character_techniques enable row level security;
alter table public.character_trackers enable row level security;
alter table public.technique_uses enable row level security;
drop policy if exists techniques_select on public.character_techniques;
create policy techniques_select on public.character_techniques for select to authenticated using (public.can_view_character(character_id));
drop policy if exists trackers_select on public.character_trackers;
create policy trackers_select on public.character_trackers for select to authenticated using (public.can_view_character(character_id));
drop policy if exists tuses_select on public.technique_uses;
create policy tuses_select on public.technique_uses for select to authenticated using (public.can_view_character(character_id));
-- Escrita só pelas funções abaixo (validam requisitos, vagas e limites de uso).

create or replace function public.ensure_tracker(p_character uuid) returns public.character_trackers
language plpgsql security definer set search_path = public as $$
declare
  t public.character_trackers;
begin
  insert into public.character_trackers (character_id) values (p_character) on conflict do nothing;
  select * into t from public.character_trackers where character_id = p_character for update;
  return t;
end $$;
revoke execute on function public.ensure_tracker(uuid) from public, anon, authenticated;

-- Atributo permanente da forma principal (base + outros + bônus de classe; sem temporário).
create or replace function public.permanent_attribute(p_character uuid, p_attr text) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(fa.base_value, 0) + fa.other_bonus
       + coalesce((public.rules_config() -> 'classes' -> c.class_id -> 'attributeBonus' ->> p_attr)::int, 0)
  from public.characters c
  join public.character_forms cf on cf.character_id = c.id and cf.kind = 'base'
  join public.form_attributes fa on fa.form_id = cf.id and fa.attribute = p_attr
  where c.id = p_character;
$$;

create or replace function public.learn_technique(p_character uuid, p_technique text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'techniques' -> p_technique;
  ch public.characters;
  st jsonb;
  a record;
  req text;
  new_id uuid;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  select * into ch from public.characters where id = p_character for update;
  if ch.origin_id is distinct from 'prodigio' or ch.origin_path_id is distinct from 'arsenal' then
    raise exception 'Só o Prodígio do Caminho do Arsenal aprende técnicas da lista.';
  end if;
  if cfg is null then
    raise exception 'Técnica desconhecida.';
  end if;
  if exists (select 1 from public.character_techniques where character_id = p_character and technique_id = p_technique) then
    raise exception 'Técnica já aprendida.';
  end if;
  for a in select key, value from jsonb_each_text(coalesce(cfg -> 'requires' -> 'attributes', '{}'::jsonb)) loop
    if coalesce(public.permanent_attribute(p_character, a.key), 0) < a.value::int then
      raise exception 'Requisito não atendido: % %+.', a.key, a.value;
    end if;
  end loop;
  for req in select jsonb_array_elements_text(coalesce(cfg -> 'requires' -> 'techniques', '[]'::jsonb)) loop
    if not exists (select 1 from public.character_techniques where character_id = p_character and technique_id = req) then
      raise exception 'Requisito não atendido: técnica %.', public.rules_config() -> 'techniques' -> req ->> 'name';
    end if;
  end loop;
  st := public.ability_status(p_character);
  if (st ->> 'created')::int >= (st ->> 'granted')::int then
    raise exception 'Nenhuma técnica disponível neste nível (uma a cada nível par).';
  end if;
  insert into public.character_techniques (character_id, technique_id, learned_level)
  values (p_character, p_technique, ch.level) returning id into new_id;
  return new_id;
end $$;

create or replace function public.forget_technique(p_character uuid, p_technique text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  if exists (
    select 1 from public.character_techniques ct
    where ct.character_id = p_character and ct.technique_id <> p_technique
      and (public.rules_config() -> 'techniques' -> ct.technique_id -> 'requires' -> 'techniques') ? p_technique
  ) then
    raise exception 'Outra técnica aprendida depende desta.';
  end if;
  delete from public.character_techniques where character_id = p_character and technique_id = p_technique;
end $$;

-- Avança o contador (turno / cena / sessão). Nova sessão também começa uma cena nova.
create or replace function public.advance_tracker(p_character uuid, p_kind text) returns public.character_trackers
language plpgsql security definer set search_path = public as $$
declare
  t public.character_trackers;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  t := public.ensure_tracker(p_character);
  if p_kind = 'turn' then
    update public.character_trackers set turn = turn + 1, updated_at = now() where character_id = p_character returning * into t;
  elsif p_kind = 'scene' then
    update public.character_trackers set scene = scene + 1, turn = 1, updated_at = now() where character_id = p_character returning * into t;
  elsif p_kind = 'session' then
    update public.character_trackers set session = session + 1, scene = scene + 1, turn = 1, updated_at = now() where character_id = p_character returning * into t;
  else
    raise exception 'Contador inválido.';
  end if;
  return t;
end $$;

-- Usa uma técnica: confere aprendizado, suspensão por nível e limite de uso; aplica efeitos especiais.
create or replace function public.use_technique(p_character uuid, p_technique text, p_request uuid, p_data jsonb default '{}'::jsonb)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'techniques' -> p_technique;
  usage jsonb := cfg -> 'usage';
  ch public.characters;
  ct public.character_techniques;
  t public.character_trackers;
  n int;
  last_turn int;
  last_adr bigint;
  fm public.character_forms;
  heal int;
  result jsonb := '{}'::jsonb;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  if exists (select 1 from public.technique_uses where request_id = p_request) then
    return jsonb_build_object('duplicate', true);
  end if;
  select * into ch from public.characters where id = p_character;
  select * into ct from public.character_techniques where character_id = p_character and technique_id = p_technique;
  if ct.id is null or cfg is null then
    raise exception 'Técnica não aprendida.';
  end if;
  if ct.learned_level > ch.level then
    raise exception 'Técnica suspensa: foi aprendida no nível %, acima do nível atual.', ct.learned_level;
  end if;
  t := public.ensure_tracker(p_character);
  if usage ->> 'kind' = 'passiva' then
    raise exception 'Técnica passiva: sempre ativa, não precisa ser usada.';
  elsif usage ->> 'kind' = 'por_cena' then
    select coalesce(max(u.id), 0) into last_adr from public.technique_uses u
    where u.character_id = p_character and u.scene = t.scene and u.session = t.session
      and public.rules_config() -> 'techniques' -> u.technique_id ->> 'special' = 'recarregar_cena';
    select count(*) into n from public.technique_uses
    where character_id = p_character and technique_id = p_technique and scene = t.scene and session = t.session and id > last_adr;
    if n >= (usage ->> 'times')::int then
      raise exception 'Já usada nesta cena.';
    end if;
  elsif usage ->> 'kind' = 'por_sessao' then
    select count(*) into n from public.technique_uses where character_id = p_character and technique_id = p_technique and session = t.session;
    if n >= (usage ->> 'times')::int then
      raise exception 'Já usada nesta sessão.';
    end if;
  elsif usage ->> 'kind' = 'a_cada_turnos' then
    select max(turn) into last_turn from public.technique_uses
    where character_id = p_character and technique_id = p_technique and scene = t.scene and session = t.session;
    if last_turn is not null and t.turn - last_turn < (usage ->> 'turns')::int then
      raise exception 'Disponível de novo no turno %.', last_turn + (usage ->> 'turns')::int;
    end if;
  end if;

  -- Recobrar-se: cura metade do dano do ataque, ou volta com 1 PV (na forma ativa).
  if cfg ->> 'special' = 'recobrar' then
    select * into fm from public.character_forms
    where character_id = p_character and kind = case when ch.active_form = 'lenda' then 'lenda' else 'base' end and setup_complete
    for update;
    if fm.id is null then
      select * into fm from public.character_forms where character_id = p_character and kind = 'base' for update;
    end if;
    if p_data ->> 'mode' = 'revive' then
      update public.character_forms set pv_current = greatest(pv_current, 1) where id = fm.id returning * into fm;
      result := jsonb_build_object('pv_current', fm.pv_current, 'healed', 0, 'form_id', fm.id);
    else
      heal := greatest(0, floor(coalesce((p_data ->> 'damage')::numeric, 0) / 2)::int);
      if heal > 10000 then raise exception 'Valor inválido.'; end if;
      update public.character_forms set pv_current = least(pv_current + heal, public.form_pv_max(fm.id)) where id = fm.id returning * into fm;
      result := jsonb_build_object('pv_current', fm.pv_current, 'healed', heal, 'form_id', fm.id);
    end if;
  end if;

  insert into public.technique_uses (character_id, technique_id, scene, session, turn, request_id, data)
  values (p_character, p_technique, t.scene, t.session, t.turn, p_request, coalesce(p_data, '{}'::jsonb));
  return result || jsonb_build_object('duplicate', false, 'scene', t.scene, 'session', t.session, 'turn', t.turn);
end $$;

-- Evolução: técnicas oficiais e poderes ocupam as mesmas vagas (ability_status conta os dois).
create or replace function public.set_character_level(p_character uuid, p_level int) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  ch public.characters;
  dice jsonb;
  f record;
  l int;
  pv jsonb;
  pc jsonb;
  created jsonb := '[]'::jsonb;
  n_created int;
  needed int;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar o nível.';
  end if;
  if p_level < (cfg -> 'levels' ->> 'min')::int or p_level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  select * into ch from public.characters where id = p_character for update;
  if ch.status <> 'active' then
    raise exception 'Finalize o personagem antes de mudar o nível.';
  end if;

  if p_level > ch.level and coalesce((cfg -> 'abilities' ->> 'blockLevelUpWhenPending')::boolean, false)
     and coalesce(cfg -> 'abilities' -> 'originModes' ->> ch.origin_id, 'standard') = 'standard' then
    n_created := (select count(*) from public.powers where character_id = p_character)
               + (select count(*) from public.character_techniques where character_id = p_character);
    for l in ch.level..(p_level - 1) loop
      needed := public.ability_granted(ch.origin_id, ch.origin_path_id, l);
      if n_created < needed then
        raise exception 'EVOLUÇÃO BLOQUEADA: você ainda possui habilidades disponíveis para criar (nível %: % de %). Finalize suas habilidades antes de avançar para o próximo nível.', l, n_created, needed;
      end if;
    end loop;
  end if;

  if ch.origin_id is not null and cfg -> 'progressionOverrides' ? ch.origin_id then
    dice := cfg -> 'progressionOverrides' -> ch.origin_id;
  elsif ch.class_id is not null then
    dice := cfg -> 'classes' -> ch.class_id;
  else
    raise exception 'Personagem sem classe.';
  end if;

  for f in select id from public.character_forms where character_id = p_character and setup_complete loop
    for l in 2..p_level loop
      if not exists (select 1 from public.level_progressions where form_id = f.id and level = l) then
        pv := public.roll_simple_dice(dice -> 'pvDice');
        pc := public.roll_simple_dice(dice -> 'pcDice');
        insert into public.level_progressions (form_id, level, pv_dice, pc_dice, pv_roll, pc_roll, pv_gain, pc_gain)
        values (f.id, l, dice ->> 'pv', dice ->> 'pc', pv, pc, (pv ->> 'total')::int, coalesce((pc ->> 'total')::int, 0))
        on conflict (form_id, level) do nothing;
        if found then
          created := created || jsonb_build_array(jsonb_build_object('form_id', f.id, 'level', l));
        end if;
      end if;
    end loop;
  end loop;

  update public.characters set level = p_level where id = p_character;
  update public.character_forms cf
  set pv_current = least(cf.pv_current, public.form_pv_max(cf.id))
  where cf.character_id = p_character and cf.setup_complete and cf.pv_current > public.form_pv_max(cf.id);

  return jsonb_build_object(
    'level', p_level,
    'created', created,
    'rows', coalesce((
      select jsonb_agg(jsonb_build_object('form_id', lp.form_id, 'kind', cf.kind, 'level', lp.level, 'pv_gain', lp.pv_gain, 'pc_gain', lp.pc_gain,
                                          'pv_roll', lp.pv_roll, 'pc_roll', lp.pc_roll, 'pv_dice', lp.pv_dice, 'pc_dice', lp.pc_dice) order by cf.kind, lp.level)
      from public.level_progressions lp join public.character_forms cf on cf.id = lp.form_id
      where cf.character_id = p_character and lp.level <= p_level), '[]'::jsonb)
  );
end $$;

-- =====================================================================
-- 2. CAMPANHAS: configurações, convites, vínculo de personagens
-- =====================================================================
alter table public.campaigns add column if not exists settings jsonb not null default '{"players_see_party": true}'::jsonb;
alter table public.campaigns drop constraint if exists campaigns_settings_object;
alter table public.campaigns add constraint campaigns_settings_object check (jsonb_typeof(settings) = 'object');

alter table public.campaign_invites add column if not exists active boolean not null default true;

-- Entrar pelo convite: só convites ativos; nunca duplica; convite não dá permissão de Mestre.
create or replace function public.join_campaign(p_code text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  cid uuid;
begin
  if auth.uid() is null then
    raise exception 'É preciso estar autenticado.';
  end if;
  select campaign_id into cid from public.campaign_invites where code = p_code and active;
  if cid is null then
    raise exception 'Convite inválido ou desativado.';
  end if;
  insert into public.campaign_members (campaign_id, user_id, role)
  values (cid, auth.uid(), 'player')
  on conflict (campaign_id, user_id) do nothing;
  return cid;
end $$;

create or replace function public.campaign_invite_preview(p_code text)
returns table (id uuid, name text, description text, master_username text, already_member boolean)
language sql stable security definer set search_path = public as $$
  select c.id, c.name, c.description, p.username::text,
         exists (select 1 from public.campaign_members m where m.campaign_id = c.id and m.user_id = auth.uid())
  from public.campaign_invites i
  join public.campaigns c on c.id = i.campaign_id
  join public.profiles p on p.id = c.owner_id
  where i.code = p_code and i.active and auth.uid() is not null;
$$;

create or replace function public.regenerate_invite(p_campaign uuid) returns text
language plpgsql security definer set search_path = public, extensions as $$
declare
  code_new text := encode(extensions.gen_random_bytes(9), 'hex');
begin
  if not public.is_campaign_master(p_campaign) then
    raise exception 'Apenas o Mestre pode gerar convites.';
  end if;
  update public.campaign_invites set code = code_new, active = true, created_at = now() where campaign_id = p_campaign;
  return code_new;
end $$;

create or replace function public.set_invite_active(p_campaign uuid, p_active boolean) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_campaign_master(p_campaign) then
    raise exception 'Apenas o Mestre pode alterar o convite.';
  end if;
  update public.campaign_invites set active = p_active where campaign_id = p_campaign;
end $$;

-- Personagens: o jogador vincula (pendente) e o Mestre aceita. Vínculos antigos continuam aceitos.
alter table public.campaign_characters add column if not exists status text not null default 'accepted';
alter table public.campaign_characters drop constraint if exists campaign_characters_status_check;
alter table public.campaign_characters add constraint campaign_characters_status_check check (status in ('pending', 'accepted'));

create or replace function public.character_is_active(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.characters where id = p_character and status = 'active');
$$;
revoke execute on function public.character_is_active(uuid) from public, anon;
grant execute on function public.character_is_active(uuid) to authenticated;

create or replace function public.guard_campaign_character() returns trigger
language plpgsql as $$
begin
  if tg_op = 'INSERT' then
    if public.owns_character(new.character_id) and not public.character_is_active(new.character_id) then
      raise exception 'Finalize o personagem antes de vinculá-lo a uma campanha.';
    end if;
    new.status := case when public.is_campaign_master(new.campaign_id) then 'accepted' else 'pending' end;
  elsif new.status is distinct from old.status and not public.is_campaign_master(new.campaign_id)
        and current_user in ('authenticated', 'anon') then
    raise exception 'Só o Mestre aceita personagens na campanha.';
  end if;
  return new;
end $$;
drop trigger if exists campaign_characters_guard on public.campaign_characters;
create trigger campaign_characters_guard before insert or update on public.campaign_characters
  for each row execute function public.guard_campaign_character();

create or replace function public.review_campaign_character(p_campaign uuid, p_character uuid, p_accept boolean) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_campaign_master(p_campaign) then
    raise exception 'Apenas o Mestre pode aceitar ou remover personagens.';
  end if;
  if p_accept then
    update public.campaign_characters set status = 'accepted' where campaign_id = p_campaign and character_id = p_character;
  else
    delete from public.campaign_characters where campaign_id = p_campaign and character_id = p_character;
  end if;
end $$;

-- O Mestre só vê/edita fichas ACEITAS na campanha (e, para editar, com a autorização do jogador).
create or replace function public.can_view_character(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.owns_character(p_character)
      or exists (
        select 1 from public.campaign_characters cc
        join public.campaign_members m on m.campaign_id = cc.campaign_id
        where cc.character_id = p_character and cc.status = 'accepted' and m.user_id = auth.uid() and m.role = 'master');
$$;

create or replace function public.can_edit_character(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.owns_character(p_character)
      or exists (
        select 1 from public.campaign_characters cc
        join public.campaign_members m on m.campaign_id = cc.campaign_id
        where cc.character_id = p_character and cc.status = 'accepted' and cc.master_can_edit
          and m.user_id = auth.uid() and m.role = 'master');
$$;

-- Grupo da campanha (informação pública para membros; sem atributos nem recursos).
create or replace function public.campaign_party(p_campaign uuid)
returns table (character_id uuid, name text, class_id text, origin_id text, origin_path_id text, level int,
               owner_id uuid, owner_username text, status text, is_mine boolean, active_form text)
language sql stable security definer set search_path = public as $$
  select c.id, c.name, c.class_id, c.origin_id, c.origin_path_id, c.level, c.owner_id, p.username::text, cc.status,
         c.owner_id = auth.uid(), c.active_form
  from public.campaign_characters cc
  join public.characters c on c.id = cc.character_id
  left join public.profiles p on p.id = c.owner_id
  where cc.campaign_id = p_campaign
    and public.is_campaign_member(p_campaign)
    and (
      public.is_campaign_master(p_campaign)
      or c.owner_id = auth.uid()
      or (cc.status = 'accepted' and coalesce((select (settings ->> 'players_see_party')::boolean from public.campaigns where id = p_campaign), true))
    )
  order by cc.linked_at;
$$;

-- =====================================================================
-- 3. CONDIÇÕES (fichas, NPCs e combatentes)
-- Formato: [{"id": "...", "name": "Atordoado", "turns": 2 | null, "note": ""}]
-- =====================================================================
alter table public.character_forms add column if not exists conditions jsonb not null default '[]'::jsonb;
alter table public.character_forms drop constraint if exists character_forms_conditions_array;
alter table public.character_forms add constraint character_forms_conditions_array check (jsonb_typeof(conditions) = 'array');

create or replace function public.condition_add(p_list jsonb, p_name text, p_turns int, p_note text) returns jsonb
language plpgsql volatile as $$
begin
  if p_name is null or char_length(trim(p_name)) = 0 or char_length(p_name) > 80 then
    raise exception 'Nome da condição inválido.';
  end if;
  if p_turns is not null and (p_turns < 1 or p_turns > 100) then
    raise exception 'Duração inválida (1–100 turnos).';
  end if;
  if jsonb_array_length(coalesce(p_list, '[]'::jsonb)) >= 30 then
    raise exception 'Condições demais.';
  end if;
  return coalesce(p_list, '[]'::jsonb) || jsonb_build_array(jsonb_build_object(
    'id', md5(random()::text || clock_timestamp()::text), 'name', trim(p_name), 'turns', p_turns, 'note', left(coalesce(p_note, ''), 200)));
end $$;

create or replace function public.condition_remove(p_list jsonb, p_id text) returns jsonb
language sql immutable as $$
  select coalesce(jsonb_agg(c), '[]'::jsonb) from jsonb_array_elements(coalesce(p_list, '[]'::jsonb)) c where c ->> 'id' <> p_id;
$$;

-- Diminui as durações; devolve a lista nova e os nomes que expiraram.
create or replace function public.condition_tick(p_list jsonb, out list jsonb, out expired text[])
language plpgsql immutable as $$
declare
  c jsonb;
begin
  list := '[]'::jsonb;
  expired := '{}';
  for c in select * from jsonb_array_elements(coalesce(p_list, '[]'::jsonb)) loop
    if c ->> 'turns' is null then
      list := list || jsonb_build_array(c);
    elsif (c ->> 'turns')::int <= 1 then
      expired := array_append(expired, c ->> 'name');
    else
      list := list || jsonb_build_array(jsonb_set(c, '{turns}', to_jsonb((c ->> 'turns')::int - 1)));
    end if;
  end loop;
end $$;

create or replace function public.form_condition(p_form uuid, p_action text, p_name text default null, p_turns int default null, p_id text default null, p_note text default null)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  f public.character_forms;
begin
  select * into f from public.character_forms where id = p_form for update;
  if f.id is null or not public.can_edit_character(f.character_id) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  if p_action = 'add' then
    update public.character_forms set conditions = public.condition_add(conditions, p_name, p_turns, p_note) where id = p_form returning * into f;
  elsif p_action = 'remove' then
    update public.character_forms set conditions = public.condition_remove(conditions, p_id) where id = p_form returning * into f;
  else
    raise exception 'Ação inválida.';
  end if;
  return f.conditions;
end $$;

-- =====================================================================
-- 4. NPCs e monstros (instâncias da campanha; modelos do Homebrew preservados)
-- =====================================================================
alter table public.npcs drop constraint if exists npcs_conditions_array;
alter table public.npcs add constraint npcs_conditions_array check (jsonb_typeof(conditions) = 'array');
alter table public.npcs drop constraint if exists npcs_name_len;
alter table public.npcs add constraint npcs_name_len check (char_length(name) between 1 and 120);

-- =====================================================================
-- 5. COMBATES
-- =====================================================================
alter table public.combats add column if not exists version int not null default 0;
alter table public.combats add column if not exists started_at timestamptz;
alter table public.combats add column if not exists ended_at timestamptz;
alter table public.combats add column if not exists initiative_mode text not null default 'manual';
alter table public.combats drop constraint if exists combats_initiative_mode_check;
alter table public.combats add constraint combats_initiative_mode_check check (initiative_mode in ('manual', 'reflexo', 'd20'));

alter table public.combatants add column if not exists form_id uuid references public.character_forms (id) on delete set null;
alter table public.combatants add column if not exists kind text not null default 'other';
alter table public.combatants drop constraint if exists combatants_kind_check;
alter table public.combatants add constraint combatants_kind_check check (kind in ('character', 'npc', 'monstro', 'other'));
alter table public.combatants add column if not exists notes text not null default '';
alter table public.combatants drop constraint if exists combatants_conditions_array;
alter table public.combatants add constraint combatants_conditions_array check (jsonb_typeof(conditions) = 'array');

create table if not exists public.combat_log (
  id bigint generated always as identity primary key,
  combat_id uuid not null references public.combats (id) on delete cascade,
  round int not null,
  turn_index int not null,
  kind text not null,
  message text not null,
  data jsonb not null default '{}'::jsonb,
  public boolean not null default true,
  request_id uuid unique,
  actor uuid default auth.uid(),
  created_at timestamptz not null default now()
);
create index if not exists combat_log_combat_idx on public.combat_log (combat_id, id desc);
alter table public.combat_log enable row level security;
drop policy if exists combat_log_master on public.combat_log;
create policy combat_log_master on public.combat_log for select to authenticated
  using (exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_master(c.campaign_id)));
drop policy if exists combat_log_players on public.combat_log;
create policy combat_log_players on public.combat_log for select to authenticated
  using (public and exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_member(c.campaign_id)));

-- Combatente-personagem precisa estar ACEITO na campanha; a forma usada é a ativa (se não informada).
create or replace function public.guard_combatant() returns trigger
language plpgsql as $$
declare
  camp uuid;
begin
  select campaign_id into camp from public.combats where id = new.combat_id;
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
  elsif new.npc_id is not null then
    if not exists (select 1 from public.npcs where id = new.npc_id and campaign_id = camp) then
      raise exception 'NPC de outra campanha.';
    end if;
    if new.kind not in ('npc', 'monstro') then
      select kind into new.kind from public.npcs where id = new.npc_id;
    end if;
  end if;
  if new.pv_max is not null and new.pv_current is not null then
    new.pv_current := least(greatest(new.pv_current, 0), new.pv_max);
  end if;
  if new.pc_max is not null and new.pc_current is not null then
    new.pc_current := least(greatest(new.pc_current, 0), new.pc_max);
  end if;
  return new;
end $$;
drop trigger if exists combatants_guard on public.combatants;
create trigger combatants_guard before insert or update on public.combatants
  for each row execute function public.guard_combatant();

-- Toda mudança em combatentes avança a versão do combate (jogadores recebem pelo Realtime e recarregam).
create or replace function public.bump_combat_version() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  update public.combats set version = version + 1, updated_at = now() where id = coalesce(new.combat_id, old.combat_id);
  return coalesce(new, old);
end $$;
drop trigger if exists combatants_bump on public.combatants;
create trigger combatants_bump after insert or update or delete on public.combatants
  for each row execute function public.bump_combat_version();

create or replace function public.combat_log_add(p_combat uuid, p_kind text, p_message text, p_data jsonb default '{}'::jsonb,
                                                 p_public boolean default true, p_request uuid default null)
returns void
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
begin
  select * into cb from public.combats where id = p_combat;
  insert into public.combat_log (combat_id, round, turn_index, kind, message, data, public, request_id)
  values (p_combat, cb.round, cb.turn_index, p_kind, left(p_message, 500), coalesce(p_data, '{}'::jsonb), p_public, p_request);
end $$;
revoke execute on function public.combat_log_add(uuid, text, text, jsonb, boolean, uuid) from public, anon, authenticated;

-- Ordem dos turnos: sort_order (o Mestre define; a iniciativa só sugere).
create or replace function public.combat_order(p_combat uuid) returns uuid[]
language sql stable security definer set search_path = public as $$
  select coalesce(array_agg(id order by sort_order, initiative desc nulls last, name), '{}') from public.combatants where combat_id = p_combat;
$$;

-- Cobra a manutenção dos efeitos contínuos do personagem no início do turno dele (uma vez por turno/rodada).
create or replace function public.combat_charge_effects(p_combat uuid, p_combatant public.combatants) returns void
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
  ef public.active_effects;
  fm public.character_forms;
  req uuid;
begin
  if p_combatant.character_id is null then
    return;
  end if;
  select * into cb from public.combats where id = p_combat;
  for ef in select * from public.active_effects where character_id = p_combatant.character_id and active
            and (form_id is null or form_id = p_combatant.form_id) for update loop
    req := md5(p_combat::text || ':' || cb.round || ':' || cb.turn_index || ':' || ef.id::text)::uuid;
    continue when exists (select 1 from public.pc_transactions where request_id = req);
    select * into fm from public.character_forms where id = coalesce(ef.form_id, p_combatant.form_id) for update;
    if fm.pc_current < ef.per_turn_cost then
      update public.active_effects set active = false, ended_at = now() where id = ef.id;
      perform public.combat_log_add(p_combat, 'efeito', format('%s: %s encerrado (PC insuficiente para manter).', p_combatant.name, ef.label));
      continue;
    end if;
    if ef.per_turn_cost > 0 then
      update public.character_forms set pc_current = pc_current - ef.per_turn_cost where id = fm.id;
    end if;
    insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
    values (req, fm.id, -ef.per_turn_cost, 'Manutenção (combate): ' || ef.label, auth.uid());
    update public.active_effects
    set turns_paid = turns_paid + 1,
        active = (turns_total = 0 or turns_paid + 1 < turns_total),
        ended_at = case when turns_total > 0 and turns_paid + 1 >= turns_total then now() end
    where id = ef.id;
    perform public.combat_log_add(p_combat, 'efeito',
      format('%s mantém %s (−%s PC).', p_combatant.name, ef.label, ef.per_turn_cost));
  end loop;
end $$;
revoke execute on function public.combat_charge_effects(uuid, public.combatants) from public, anon, authenticated;

-- Fim do turno de um combatente: condições com duração diminuem; as que acabam saem (com registro).
create or replace function public.combat_tick_conditions(p_combat uuid, p_combatant public.combatants) returns void
language plpgsql security definer set search_path = public as $$
declare
  r record;
  hidden boolean := p_combatant.hidden;
begin
  if p_combatant.character_id is not null and p_combatant.form_id is not null then
    select * into r from public.condition_tick((select conditions from public.character_forms where id = p_combatant.form_id));
    update public.character_forms set conditions = r.list where id = p_combatant.form_id;
  else
    select * into r from public.condition_tick(p_combatant.conditions);
    update public.combatants set conditions = r.list where id = p_combatant.id;
  end if;
  if cardinality(r.expired) > 0 then
    perform public.combat_log_add(p_combat, 'condicao', format('%s: terminou %s.', p_combatant.name, array_to_string(r.expired, ', ')), '{}'::jsonb, not hidden);
  end if;
end $$;
revoke execute on function public.combat_tick_conditions(uuid, public.combatants) from public, anon, authenticated;

-- Iniciar / turnos / rodadas / encerrar. p_version evita que dois cliques (ou dois aparelhos) avancem duas vezes.
create or replace function public.combat_control(p_combat uuid, p_action text, p_version int) returns public.combats
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
  ids uuid[];
  n int;
  cur public.combatants;
  nxt public.combatants;
  c record;
begin
  select * into cb from public.combats where id = p_combat for update;
  if cb.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre controla o combate.';
  end if;
  if p_version is distinct from cb.version then
    raise exception 'O combate foi alterado por outra ação. Os dados foram recarregados — confira e tente de novo.';
  end if;
  if cb.status = 'ended' and p_action <> 'reopen' then
    raise exception 'Combate encerrado.';
  end if;
  ids := public.combat_order(p_combat);
  n := coalesce(array_length(ids, 1), 0);

  if p_action = 'start' then
    if n = 0 then raise exception 'Adicione participantes antes de iniciar.'; end if;
    update public.combats set status = 'active', round = 1, turn_index = 0, started_at = coalesce(started_at, now()) where id = p_combat;
    -- Combate começa uma cena nova para cada personagem (limites de técnicas "por cena").
    for c in select distinct character_id from public.combatants where combat_id = p_combat and character_id is not null loop
      perform public.ensure_tracker(c.character_id);
      update public.character_trackers set scene = scene + 1, turn = 1, updated_at = now() where character_id = c.character_id;
    end loop;
    perform public.combat_log_add(p_combat, 'inicio', format('Combate iniciado com %s participante(s).', n));
    select * into nxt from public.combatants where id = ids[1];
    perform public.combat_charge_effects(p_combat, nxt);
  elsif p_action = 'next' then
    if n = 0 then raise exception 'Sem participantes.'; end if;
    select * into cur from public.combatants where id = ids[least(cb.turn_index, n - 1) + 1];
    if cur.id is not null then
      perform public.combat_tick_conditions(p_combat, cur);
    end if;
    if cb.turn_index + 1 >= n then
      update public.combats set round = round + 1, turn_index = 0 where id = p_combat returning * into cb;
      perform public.combat_log_add(p_combat, 'rodada', format('Rodada %s.', cb.round));
    else
      update public.combats set turn_index = turn_index + 1 where id = p_combat returning * into cb;
    end if;
    select * into nxt from public.combatants where id = ids[cb.turn_index + 1];
    if nxt.character_id is not null then
      perform public.ensure_tracker(nxt.character_id);
      update public.character_trackers set turn = turn + 1, updated_at = now() where character_id = nxt.character_id;
    end if;
    perform public.combat_charge_effects(p_combat, nxt);
    perform public.combat_log_add(p_combat, 'turno', format('Turno de %s.', nxt.name), '{}'::jsonb, not nxt.hidden);
  elsif p_action = 'prev' then
    if cb.turn_index > 0 then
      update public.combats set turn_index = turn_index - 1 where id = p_combat;
    elsif cb.round > 1 then
      update public.combats set round = round - 1, turn_index = greatest(n - 1, 0) where id = p_combat;
    else
      raise exception 'Já está no primeiro turno.';
    end if;
    perform public.combat_log_add(p_combat, 'turno', 'Turno voltou (sem desfazer efeitos já aplicados).');
  elsif p_action = 'new_round' then
    update public.combats set round = round + 1, turn_index = 0 where id = p_combat returning * into cb;
    perform public.combat_log_add(p_combat, 'rodada', format('Rodada %s (nova rodada).', cb.round));
  elsif p_action = 'pause' then
    update public.combats set status = 'paused' where id = p_combat;
  elsif p_action = 'end' then
    update public.combats set status = 'ended', ended_at = now() where id = p_combat;
    perform public.combat_log_add(p_combat, 'fim', 'Combate encerrado.');
  elsif p_action = 'reopen' then
    update public.combats set status = 'active', ended_at = null where id = p_combat;
  else
    raise exception 'Ação inválida.';
  end if;

  update public.combats set version = version + 1, updated_at = now() where id = p_combat returning * into cb;
  return cb;
end $$;

-- Dano, cura e recursos de um participante. Atômico e idempotente (p_request).
create or replace function public.combat_apply(p_combatant uuid, p_kind text, p_amount int, p_request uuid, p_note text default '')
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
  fm public.character_forms;
  before int;
  after int;
  label text;
  hidden boolean;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica efeitos no combate.';
  end if;
  if exists (select 1 from public.combat_log where request_id = p_request) then
    return jsonb_build_object('duplicate', true);
  end if;
  if p_amount is null or p_amount < 0 or p_amount > 100000 then
    raise exception 'Valor inválido.';
  end if;
  hidden := cbt.hidden or cbt.hide_stats;
  if cbt.character_id is not null then
    if not public.can_edit_character(cbt.character_id) then
      raise exception 'O jogador não autorizou o Mestre a editar esta ficha.';
    end if;
    select * into fm from public.character_forms where id = cbt.form_id for update;
    if p_kind in ('damage', 'heal') then
      before := fm.pv_current;
      after := case when p_kind = 'damage' then greatest(before - p_amount, 0) else least(before + p_amount, public.form_pv_max(fm.id)) end;
      update public.character_forms set pv_current = after where id = fm.id;
    elsif p_kind in ('pc_spend', 'pc_gain') then
      before := fm.pc_current;
      after := case when p_kind = 'pc_spend' then greatest(before - p_amount, 0) else least(before + p_amount, public.form_pc_max(fm.id)) end;
      update public.character_forms set pc_current = after where id = fm.id;
    else
      raise exception 'Ação inválida.';
    end if;
  else
    if p_kind in ('damage', 'heal') then
      before := coalesce(cbt.pv_current, 0);
      after := case when p_kind = 'damage' then greatest(before - p_amount, 0) else least(before + p_amount, coalesce(cbt.pv_max, before + p_amount)) end;
      update public.combatants set pv_current = after where id = cbt.id;
    elsif p_kind in ('pc_spend', 'pc_gain') then
      before := coalesce(cbt.pc_current, 0);
      after := case when p_kind = 'pc_spend' then greatest(before - p_amount, 0) else least(before + p_amount, coalesce(cbt.pc_max, before + p_amount)) end;
      update public.combatants set pc_current = after where id = cbt.id;
    else
      raise exception 'Ação inválida.';
    end if;
  end if;
  label := case p_kind when 'damage' then 'sofreu %s de dano' when 'heal' then 'recuperou %s PV' when 'pc_spend' then 'gastou %s PC' else 'recuperou %s PC' end;
  perform public.combat_log_add(cb.id, p_kind,
    format('%s ' || label || '%s', cbt.name, p_amount, case when coalesce(p_note, '') <> '' then ' — ' || left(p_note, 200) else '' end)
      || case when hidden then '' else format(' (%s → %s).', before, after) end,
    jsonb_build_object('combatant', cbt.id, 'before', before, 'after', after, 'amount', p_amount), not cbt.hidden, p_request);
  update public.combats set version = version + 1, updated_at = now() where id = cb.id;
  return jsonb_build_object('duplicate', false, 'before', before, 'after', after);
end $$;

create or replace function public.combat_condition(p_combatant uuid, p_action text, p_name text default null, p_turns int default null, p_id text default null)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
  list jsonb;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica condições no combate.';
  end if;
  if cbt.character_id is not null then
    list := public.form_condition(cbt.form_id, p_action, p_name, p_turns, p_id);
  else
    if p_action = 'add' then
      update public.combatants set conditions = public.condition_add(conditions, p_name, p_turns, null) where id = cbt.id returning conditions into list;
    elsif p_action = 'remove' then
      update public.combatants set conditions = public.condition_remove(conditions, p_id) where id = cbt.id returning conditions into list;
    else
      raise exception 'Ação inválida.';
    end if;
  end if;
  perform public.combat_log_add(cb.id, 'condicao',
    case when p_action = 'add' then format('%s: %s%s.', cbt.name, p_name, case when p_turns is null then '' else format(' (%s turno(s))', p_turns) end)
         else format('%s: condição removida.', cbt.name) end, '{}'::jsonb, not cbt.hidden);
  update public.combats set version = version + 1, updated_at = now() where id = cb.id;
  return list;
end $$;

-- Registro livre (ataque de NPC, uso de poder, efeito narrativo).
create or replace function public.combat_note(p_combat uuid, p_kind text, p_message text, p_data jsonb default '{}'::jsonb, p_public boolean default true, p_request uuid default null)
returns void
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
begin
  select * into cb from public.combats where id = p_combat;
  if cb.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre registra eventos do combate.';
  end if;
  if p_kind not in ('ataque', 'poder', 'efeito', 'nota') then
    raise exception 'Tipo inválido.';
  end if;
  if p_request is not null and exists (select 1 from public.combat_log where request_id = p_request) then
    return;
  end if;
  perform public.combat_log_add(p_combat, p_kind, p_message, p_data, p_public, p_request);
end $$;

-- Visão dos combatentes para jogadores: personagens mostram os PV vivos da ficha; ocultos não aparecem.
drop view if exists public.combatants_public;
create view public.combatants_public with (security_barrier = true) as
select cb.id, cb.combat_id, cb.character_id, cb.npc_id, cb.kind, cb.form_id, cb.name, cb.initiative, cb.sort_order,
  case when cb.hide_stats then null when cb.character_id is not null then cf.pv_current else cb.pv_current end as pv_current,
  case when cb.hide_stats then null when cb.character_id is not null then public.form_pv_max(cf.id) else cb.pv_max end as pv_max,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then cf.pc_current else cb.pc_current end as pc_current,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then public.form_pc_max(cf.id) else cb.pc_max end as pc_max,
  case when cb.character_id is not null then cf.conditions else cb.conditions end as conditions,
  cb.hidden
from public.combatants cb
join public.combats c on c.id = cb.combat_id
left join public.character_forms cf on cf.id = cb.form_id
left join public.characters ch on ch.id = cb.character_id
where public.is_campaign_member(c.campaign_id)
  and (not cb.hidden or public.is_campaign_master(c.campaign_id));
revoke all on public.combatants_public from anon;
grant select on public.combatants_public to authenticated;

-- =====================================================================
-- 6. INVESTIGAÇÃO
-- =====================================================================
alter table public.investigations add column if not exists location text not null default '';
alter table public.investigations add column if not exists status text not null default 'aberta';
alter table public.investigations drop constraint if exists investigations_status_check;
alter table public.investigations add constraint investigations_status_check check (status in ('aberta', 'em_andamento', 'resolvida', 'arquivada'));
alter table public.investigations add column if not exists characters jsonb not null default '[]'::jsonb;

alter table public.clues add column if not exists location text not null default '';
alter table public.clues add column if not exists characters jsonb not null default '[]'::jsonb;
alter table public.clues add column if not exists image_url text;
alter table public.clues drop constraint if exists clues_image_url_https;
alter table public.clues add constraint clues_image_url_https check (image_url is null or image_url ~ '^https://');
alter table public.clues add column if not exists revealed_at timestamptz;
alter table public.clues add column if not exists board_x real;
alter table public.clues add column if not exists board_y real;

create or replace function public.stamp_clue_reveal() returns trigger
language plpgsql as $$
begin
  if new.revealed and (tg_op = 'INSERT' or not old.revealed) then
    new.revealed_at := now();
  elsif not new.revealed then
    new.revealed_at := null;
  end if;
  return new;
end $$;
drop trigger if exists clues_reveal_stamp on public.clues;
create trigger clues_reveal_stamp before insert or update on public.clues
  for each row execute function public.stamp_clue_reveal();

-- Pista revelada é visível aos jogadores mesmo que o caso esteja oculto (a política antiga dependia
-- de o jogador conseguir ler a investigação, o que escondia pistas reveladas de casos sigilosos).
create or replace function public.investigation_campaign(p_investigation uuid) returns uuid
language sql stable security definer set search_path = public as $$
  select campaign_id from public.investigations where id = p_investigation;
$$;
grant execute on function public.investigation_campaign(uuid) to authenticated;
drop policy if exists clues_players on public.clues;
create policy clues_players on public.clues for select to authenticated
  using (revealed and public.is_campaign_member(public.investigation_campaign(investigation_id)));

-- Quadro de investigação (opcional): nós (lugares, personagens, notas) e ligações. Só o Mestre.
create table if not exists public.investigation_nodes (
  id uuid primary key default gen_random_uuid(),
  investigation_id uuid not null references public.investigations (id) on delete cascade,
  kind text not null check (kind in ('place', 'character', 'note')),
  label text not null check (char_length(label) between 1 and 120),
  x real not null default 0,
  y real not null default 0,
  created_at timestamptz not null default now()
);
create table if not exists public.investigation_links (
  id uuid primary key default gen_random_uuid(),
  investigation_id uuid not null references public.investigations (id) on delete cascade,
  from_id uuid not null,
  to_id uuid not null,
  label text not null default '' check (char_length(label) <= 80),
  created_at timestamptz not null default now(),
  unique (investigation_id, from_id, to_id),
  check (from_id <> to_id)
);
alter table public.investigation_nodes enable row level security;
alter table public.investigation_links enable row level security;
drop policy if exists invnodes_master on public.investigation_nodes;
create policy invnodes_master on public.investigation_nodes for all to authenticated
  using (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)))
  with check (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)));
drop policy if exists invlinks_master on public.investigation_links;
create policy invlinks_master on public.investigation_links for all to authenticated
  using (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)))
  with check (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)));

-- Pista revelada: jogadores veem o título da investigação mesmo se o caso estiver oculto? Não — só o da pista.
create or replace function public.revealed_clues(p_campaign uuid)
returns table (id uuid, investigation_id uuid, investigation_title text, title text, content text, location text,
               image_url text, attachments jsonb, revealed_at timestamptz)
language sql stable security definer set search_path = public as $$
  select cl.id, cl.investigation_id,
         case when i.visible_to_players or public.is_campaign_master(p_campaign) then i.title else 'Caso sigiloso' end,
         cl.title, cl.content, cl.location, cl.image_url, cl.attachments, cl.revealed_at
  from public.clues cl join public.investigations i on i.id = cl.investigation_id
  where i.campaign_id = p_campaign and cl.revealed and public.is_campaign_member(p_campaign)
  order by cl.revealed_at desc nulls last;
$$;

-- =====================================================================
-- 7. RELATÓRIOS (privados ou visíveis aos jogadores)
-- =====================================================================
alter table public.reports add column if not exists is_private boolean not null default false;
alter table public.reports add column if not exists conclusions text not null default '';
drop policy if exists reports_players on public.reports;
create policy reports_players on public.reports for select to authenticated
  using (not is_private and public.is_campaign_member(campaign_id));

-- =====================================================================
-- 8. ROLAGENS (públicas e privadas) — dados rolados NO BANCO
-- visibility: public (todos da campanha) · master (quem rolou + Mestre) · self (só quem rolou)
-- =====================================================================
drop policy if exists rolls_insert on public.roll_log;
create policy rolls_insert on public.roll_log for insert to authenticated
  with check (
    user_id = auth.uid()
    and (campaign_id is null or public.is_campaign_member(campaign_id))
    and (character_id is null or public.can_edit_character(character_id))
    and (visibility <> 'master' or (campaign_id is not null and public.is_campaign_member(campaign_id)))
  );

create or replace function public.roll_expression(p_expr text) returns jsonb
language plpgsql volatile set search_path = public as $$
declare
  e text := regexp_replace(lower(coalesce(p_expr, '')), '\s', '', 'g');
  m text[];
  terms jsonb := '[]'::jsonb;
  total int := 0;
  sign int;
  cnt int;
  sides int;
  rolls int[];
  i int;
  s int;
  dice_total int := 0;
  n_terms int := 0;
begin
  if e = '' or e !~ '^[+-]?(\d{0,3}d\d{1,4}|\d{1,5})([+-](\d{0,3}d\d{1,4}|\d{1,5}))*$' then
    raise exception 'Expressão de dados inválida (ex.: 2d6+3, 1d100, 2d12+1d6).';
  end if;
  for m in select regexp_matches(e, '([+-]?)(\d{0,3}d\d{1,4}|\d{1,5})', 'g') loop
    n_terms := n_terms + 1;
    if n_terms > 20 then raise exception 'Termos demais.'; end if;
    sign := case when m[1] = '-' then -1 else 1 end;
    if position('d' in m[2]) > 0 then
      cnt := coalesce(nullif(split_part(m[2], 'd', 1), '')::int, 1);
      sides := split_part(m[2], 'd', 2)::int;
      if cnt < 1 or cnt > 100 or sides < 2 or sides > 1000 then raise exception 'Dados fora do limite (até 100 dados de até 1000 lados).'; end if;
      dice_total := dice_total + cnt;
      if dice_total > 100 then raise exception 'Dados demais (máximo 100).'; end if;
      rolls := '{}';
      s := 0;
      for i in 1..cnt loop
        rolls := rolls || public.roll_die(sides);
        s := s + rolls[i];
      end loop;
      total := total + sign * s;
      terms := terms || jsonb_build_array(jsonb_build_object('sign', sign, 'count', cnt, 'sides', sides, 'rolls', to_jsonb(rolls), 'subtotal', sign * s));
    else
      total := total + sign * m[2]::int;
      terms := terms || jsonb_build_array(jsonb_build_object('sign', sign, 'count', 0, 'sides', 0, 'value', m[2]::int, 'subtotal', sign * m[2]::int));
    end if;
  end loop;
  return jsonb_build_object('expression', e, 'terms', terms, 'total', total);
end $$;

-- Rolagem livre da aba Dados. O resultado é gerado aqui (ninguém consegue escolher o número).
create or replace function public.roll_dice(p_campaign uuid, p_expression text, p_visibility text, p_label text default '')
returns public.roll_log
language plpgsql security definer set search_path = public as $$
declare
  r jsonb;
  row public.roll_log;
begin
  if not public.is_campaign_member(p_campaign) then
    raise exception 'Você não participa desta campanha.';
  end if;
  if p_visibility not in ('public', 'master', 'self') then
    raise exception 'Visibilidade inválida.';
  end if;
  r := public.roll_expression(p_expression);
  insert into public.roll_log (user_id, campaign_id, label, expression, result, visibility)
  values (auth.uid(), p_campaign, left(coalesce(nullif(trim(p_label), ''), 'Rolagem'), 120), r ->> 'expression',
          r || jsonb_build_object('kind', 'dice'), p_visibility)
  returning * into row;
  return row;
end $$;

-- Quem rolou (nome) — para o histórico da campanha.
create or replace function public.campaign_member_names(p_campaign uuid)
returns table (user_id uuid, username text, display_name text, role text)
language sql stable security definer set search_path = public as $$
  select m.user_id, p.username::text, p.display_name, m.role
  from public.campaign_members m left join public.profiles p on p.id = m.user_id
  where m.campaign_id = p_campaign and public.is_campaign_member(p_campaign);
$$;

-- =====================================================================
-- 9. REALTIME (Supabase): mudanças relevantes chegam aos navegadores conectados.
-- O Realtime respeita o RLS: cada um só recebe o que pode ler.
-- =====================================================================
do $$
declare
  t text;
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array['character_forms', 'combats', 'clues', 'roll_log', 'campaign_characters', 'npcs',
                             'character_trackers', 'technique_uses', 'campaign_notes', 'reports', 'characters'] loop
      if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
        execute format('alter publication supabase_realtime add table public.%I', t);
      end if;
    end loop;
  end if;
end $$;

-- =====================================================================
-- 10. PERMISSÕES DE EXECUÇÃO
-- =====================================================================
grant execute on function
  public.learn_technique(uuid, text),
  public.forget_technique(uuid, text),
  public.advance_tracker(uuid, text),
  public.use_technique(uuid, text, uuid, jsonb),
  public.set_character_level(uuid, int),
  public.join_campaign(text),
  public.campaign_invite_preview(text),
  public.regenerate_invite(uuid),
  public.set_invite_active(uuid, boolean),
  public.review_campaign_character(uuid, uuid, boolean),
  public.campaign_party(uuid),
  public.form_condition(uuid, text, text, int, text, text),
  public.combat_control(uuid, text, int),
  public.combat_apply(uuid, text, int, uuid, text),
  public.combat_condition(uuid, text, text, int, text),
  public.combat_note(uuid, text, text, jsonb, boolean, uuid),
  public.revealed_clues(uuid),
  public.roll_dice(uuid, text, text, text),
  public.campaign_member_names(uuid)
  to authenticated;
revoke execute on function public.roll_expression(text) from public, anon, authenticated;
revoke execute on function public.permanent_attribute(uuid, text) from public, anon, authenticated;
revoke execute on function public.combat_order(uuid) from public, anon, authenticated;
