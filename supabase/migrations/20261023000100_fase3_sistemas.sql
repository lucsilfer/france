-- =====================================================================
-- F.R.A.N.C.E — Fase 3: inventário, modificadores, poderes, evolução de nível
-- e ficha secundária do Artificial.
-- INCREMENTAL: só adiciona colunas/funções/regras; não apaga nem recria tabelas.
-- Depende de 20261023000000_rules_sync_fase3.sql (rules_config v3).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Formas (ficha secundária do Artificial)
-- ---------------------------------------------------------------------
alter table public.character_forms
  add column if not exists setup_complete boolean not null default true;

-- Atributo-base só vem da rolagem enquanto o personagem OU a forma estão em criação.
create or replace function public.guard_draft_attributes() returns trigger
language plpgsql as $$
declare
  st text;
  ready boolean;
begin
  select c.status, f.setup_complete into st, ready
  from public.characters c join public.character_forms f on f.character_id = c.id
  where f.id = new.form_id;
  if (st = 'draft' or ready = false) and current_user in ('authenticated', 'anon')
     and (tg_op = 'INSERT' or new.base_value is distinct from old.base_value) then
    raise exception 'Durante a criação, os atributos vêm apenas das rolagens.';
  end if;
  return new;
end $$;

-- Forma ativa só pode ser "lenda" se a ficha da Lenda estiver pronta.
create or replace function public.validate_active_form() returns trigger
language plpgsql as $$
begin
  if new.active_form = 'lenda' and not exists (
    select 1 from public.character_forms f where f.character_id = new.id and f.kind = 'lenda' and f.setup_complete
  ) then
    raise exception 'A ficha da Lenda ainda não foi criada.';
  end if;
  return new;
end $$;
drop trigger if exists characters_active_form on public.characters;
create trigger characters_active_form before update of active_form on public.characters
  for each row execute function public.validate_active_form();

create or replace function public.create_lenda_form(p_character uuid, p_name text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  fid uuid;
begin
  if not public.owns_character(p_character) then
    raise exception 'Apenas o dono pode criar a ficha da Lenda.';
  end if;
  if not exists (select 1 from public.characters where id = p_character and origin_id = 'artificial' and status = 'active') then
    raise exception 'Somente personagens Artificiais finalizados têm a forma Lenda.';
  end if;
  select id into fid from public.character_forms where character_id = p_character and kind = 'lenda';
  if fid is not null then
    return fid;
  end if;
  insert into public.character_forms (character_id, kind, name, setup_complete)
  values (p_character, 'lenda', left(coalesce(nullif(trim(p_name), ''), 'Lenda'), 120), false)
  returning id into fid;
  return fid;
end $$;

-- Conclui a criação da Lenda. PV/PC iniciais são calculados pelo motor no servidor.
create or replace function public.complete_lenda_form(p_form uuid, p_pv int, p_pc int) returns void
language plpgsql security definer set search_path = public as $$
declare
  f public.character_forms;
begin
  select * into f from public.character_forms where id = p_form for update;
  if not found or f.kind <> 'lenda' or not public.owns_character(f.character_id) then
    raise exception 'Ficha da Lenda não encontrada.';
  end if;
  if f.setup_complete then
    return;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null) < 8 then
    raise exception 'Defina os oito atributos da Lenda.';
  end if;
  if trim(f.name) = '' then
    raise exception 'Dê um nome à Lenda.';
  end if;
  update public.character_forms
  set setup_complete = true, pv_current = greatest(p_pv, 0), pc_current = greatest(p_pc, 0)
  where id = p_form;
end $$;

-- ---------------------------------------------------------------------
-- 2. Evolução de nível (rolagens no servidor, uma vez por nível e forma)
-- ---------------------------------------------------------------------
create or replace function public.roll_simple_dice(p_dice jsonb) returns jsonb
language plpgsql volatile set search_path = public as $$
declare
  faces int[] := '{}';
  i int;
  total int := 0;
begin
  if p_dice is null or p_dice = 'null'::jsonb then
    return null;
  end if;
  for i in 1..(p_dice ->> 'count')::int loop
    faces := faces || public.roll_die((p_dice ->> 'sides')::int);
    total := total + faces[i];
  end loop;
  total := total + coalesce((p_dice ->> 'bonus')::int, 0);
  return jsonb_build_object('faces', to_jsonb(faces), 'bonus', coalesce((p_dice ->> 'bonus')::int, 0), 'total', total);
end $$;

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

-- ---------------------------------------------------------------------
-- 3. Inventário e modificadores de armas
-- ---------------------------------------------------------------------
alter table public.items add column if not exists damage_type text;
alter table public.items add column if not exists skill_override text;
alter table public.items add column if not exists tier text;
alter table public.items drop constraint if exists items_effect_kind_check;
alter table public.items add constraint items_effect_kind_check
  check (effect_kind is null or effect_kind in ('dano', 'cura', 'condicao', 'utilidade', 'personalizado', 'outro'));

create or replace function public.is_valid_dice(p text) returns boolean
language sql immutable as $$
  select p is null or regexp_replace(lower(p), '\s', '', 'g') ~ '^(\d{0,3}d\d{1,4}|\d{1,5})([+-](\d{0,3}d\d{1,4}|\d{1,5})){0,19}$';
$$;

create or replace function public.validate_item() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  t text;
begin
  if not public.is_valid_dice(new.effect_dice) then
    raise exception 'Expressão de dados inválida: %', new.effect_dice;
  end if;
  if new.skill_override is not null and not (cfg -> 'skills') ? new.skill_override then
    raise exception 'Perícia inválida para a arma.';
  end if;
  foreach t in array new.tags loop
    if not exists (select 1 from jsonb_each_text(cfg -> 'weaponModifiers') m where m.value = t) then
      raise exception 'Categoria de arma inválida: %', t;
    end if;
  end loop;
  return new;
end $$;
drop trigger if exists items_validate on public.items;
create trigger items_validate before insert or update on public.items
  for each row execute function public.validate_item();

-- Só modificadores compatíveis; até 2 permanentes; 1 temporário só para Prodígio do Arsenal.
create or replace function public.validate_item_modifier() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  req text := cfg -> 'weaponModifiers' ->> new.modifier_id;
  it record;
  n int;
begin
  if req is null then
    raise exception 'Modificador desconhecido.';
  end if;
  select i.tags, i.attack_kind, c.origin_id, c.origin_path_id into it
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
    if n >= (cfg ->> 'maxWeaponModifiers')::int then
      raise exception 'Cada arma suporta até % modificações.', cfg ->> 'maxWeaponModifiers';
    end if;
  end if;
  return new;
end $$;
drop trigger if exists item_modifiers_validate on public.item_modifiers;
create trigger item_modifiers_validate before insert or update on public.item_modifiers
  for each row execute function public.validate_item_modifier();

-- ---------------------------------------------------------------------
-- 4. Poderes: custo calculado NO BANCO com as tabelas do motor
-- ---------------------------------------------------------------------
create or replace function public.compute_power_cost(p_components jsonb, p_level int, p_origin text) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'powers';
  c jsonb;
  t text;
  tier int;
  ex int;
  base_cost int;
  area_cost int;
  full_initial int := 0;
  per_turn int := 0;
  extra int := 0;
  max_pc int;
  max_extra int := 1;
  row jsonb;
  initial int;
  per_turn_final int;
  limit_cost int;
  errors text[] := '{}';
  cursed boolean := p_origin = 'amaldicoado';
begin
  if p_components is null or jsonb_typeof(p_components) <> 'array' or jsonb_array_length(p_components) = 0 then
    errors := array_append(errors, 'Adicione pelo menos um efeito.');
  elsif jsonb_array_length(p_components) > 10 then
    errors := array_append(errors, 'Efeitos demais.');
  else
    for c in select * from jsonb_array_elements(p_components) loop
      begin
        t := c ->> 'type';
        tier := (c ->> 'tier')::int;
        ex := coalesce((c ->> 'extraDice')::int, 0);
        if ex < 0 or (t in ('damage', 'heal', 'heal_continuous', 'shield') and (tier is null or tier < 0)) then
          raise exception 'faixa';
        end if;
        if t = 'damage' then
          if c ->> 'area' = 'alvo' then
            base_cost := (cfg -> 'damageSingle' ->> tier)::int;
            area_cost := 0;
          else
            base_cost := (cfg -> 'damageArea' ->> tier)::int;
            area_cost := (cfg -> 'areaSizes' ->> (c ->> 'area'))::int;
          end if;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'heal' then
          base_cost := (cfg -> 'heal' ->> tier)::int;
          area_cost := (cfg -> 'healArea' ->> (c ->> 'area'))::int;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'heal_continuous' then
          base_cost := (cfg -> 'healContinuous' ->> tier)::int;
          if base_cost is null then raise exception 'x'; end if;
          per_turn := per_turn + base_cost;
        elsif t = 'shield' then
          base_cost := (cfg -> 'shield' ->> tier)::int;
          area_cost := (cfg -> 'shieldDuration' ->> (c ->> 'duration'))::int;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'condition' then
          row := cfg -> 'conditions' -> (c ->> 'intensity');
          if row is null then raise exception 'x'; end if;
          full_initial := full_initial + (row ->> 'initial')::int;
          per_turn := per_turn + (row ->> 'perTurn')::int;
        elsif t = 'buff' then
          row := cfg -> 'buffs' -> (c ->> 'buff');
          if row is null then raise exception 'x'; end if;
          full_initial := full_initial + (row ->> 'initial')::int;
          per_turn := per_turn + (row ->> 'perTurn')::int;
        else
          raise exception 'x';
        end if;
      exception when others then
        errors := array_append(errors, 'Efeito inválido.');
      end;
    end loop;
  end if;

  for row in select * from jsonb_array_elements(cfg -> 'levelTable') loop
    if (row ->> 'level')::int <= p_level then
      max_extra := (row ->> 'maxExtraDice')::int;
      max_pc := (row ->> 'maxPc')::int;
    end if;
  end loop;
  if cfg ->> 'limitMode' = 'linear' then
    max_pc := 15 + 3 * (p_level - 1);
  end if;

  initial := case when cursed then
      case cfg ->> 'amaldicoadoRounding' when 'ceil' then ceil(full_initial / 2.0) when 'round' then round(full_initial / 2.0) else floor(full_initial / 2.0) end
    else full_initial end;
  per_turn_final := case when cursed then
      case cfg ->> 'amaldicoadoRounding' when 'ceil' then ceil(per_turn / 2.0) when 'round' then round(per_turn / 2.0) else floor(per_turn / 2.0) end
    else per_turn end;
  limit_cost := (case when cursed and not (cfg ->> 'amaldicoadoLimitUsesFullCost')::boolean then initial else full_initial end)
              + (case when (cfg ->> 'perTurnCountsTowardLimit')::boolean then per_turn else 0 end);
  if limit_cost > max_pc then
    errors := array_append(errors, format('Custo de %s PC acima do limite de %s PC no nível %s.', limit_cost, max_pc, p_level));
  end if;
  if extra > max_extra then
    errors := array_append(errors, format('%s dados extras acima do máximo de +%s no nível %s.', extra, max_extra, p_level));
  end if;
  return jsonb_build_object('full_initial', full_initial, 'initial', initial, 'per_turn', per_turn_final, 'extra_dice', extra,
                            'max_pc', max_pc, 'max_extra_dice', max_extra, 'valid', cardinality(errors) = 0, 'errors', to_jsonb(errors));
end $$;

create or replace function public.validate_power() returns trigger
language plpgsql as $$
declare
  ch record;
  cost jsonb;
begin
  if tg_op = 'UPDATE' and new.components = old.components and new.character_id = old.character_id then
    -- Componentes iguais: custo gravado continua o mesmo (mudar nome, favorito etc.).
    new.initial_cost := old.initial_cost;
    new.per_turn_cost := old.per_turn_cost;
    return new;
  end if;
  select level, origin_id into ch from public.characters where id = new.character_id;
  cost := public.compute_power_cost(new.components, ch.level, ch.origin_id);
  if not (cost ->> 'valid')::boolean then
    raise exception 'Poder inválido: %', array_to_string(array(select jsonb_array_elements_text(cost -> 'errors')), ' ');
  end if;
  -- O banco grava o custo calculado por ele mesmo (o valor enviado pelo navegador é ignorado).
  new.initial_cost := (cost ->> 'initial')::int;
  new.per_turn_cost := (cost ->> 'per_turn')::int;
  return new;
end $$;
drop trigger if exists powers_validate on public.powers;
create trigger powers_validate before insert or update on public.powers
  for each row execute function public.validate_power();

-- ---------------------------------------------------------------------
-- 5. Uso de poderes e efeitos contínuos (débito atômico e idempotente)
-- ---------------------------------------------------------------------
alter table public.active_effects add column if not exists turns_total int not null default 0;
alter table public.active_effects add column if not exists activation_request uuid unique;
alter table public.active_effects add column if not exists ended_at timestamptz;

-- Efeitos só mudam pelas funções abaixo (leitura continua liberada a quem vê a ficha).
drop policy if exists effects_write on public.active_effects;

create or replace function public.use_power(p_power uuid, p_form uuid, p_request uuid, p_turns int default 0) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  pw public.powers;
  fm public.character_forms;
  eff uuid;
begin
  select * into pw from public.powers where id = p_power;
  select * into fm from public.character_forms where id = p_form for update;
  if pw.id is null or fm.id is null or pw.character_id <> fm.character_id then
    raise exception 'Poder ou forma inválidos.';
  end if;
  if not public.can_edit_character(pw.character_id) then
    raise exception 'Sem permissão.';
  end if;
  if exists (select 1 from public.pc_transactions where request_id = p_request) then
    select id into eff from public.active_effects where activation_request = p_request;
    return jsonb_build_object('pc_current', fm.pc_current, 'effect_id', eff, 'duplicate', true, 'cost', pw.initial_cost);
  end if;
  if fm.pc_current < pw.initial_cost then
    raise exception 'PC insuficiente (atual: %, necessário: %).', fm.pc_current, pw.initial_cost;
  end if;
  update public.character_forms set pc_current = pc_current - pw.initial_cost where id = p_form returning * into fm;
  insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
  values (p_request, p_form, -pw.initial_cost, 'Poder: ' || pw.name, auth.uid());
  if pw.per_turn_cost > 0 and coalesce(p_turns, 0) > 0 then
    insert into public.active_effects (character_id, form_id, power_id, label, per_turn_cost, turns_total, activation_request)
    values (pw.character_id, p_form, pw.id, pw.name, pw.per_turn_cost, least(p_turns, 100), p_request)
    returning id into eff;
  end if;
  return jsonb_build_object('pc_current', fm.pc_current, 'effect_id', eff, 'duplicate', false, 'cost', pw.initial_cost);
end $$;

create or replace function public.advance_effect(p_effect uuid, p_request uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  ef public.active_effects;
  fm public.character_forms;
begin
  select * into ef from public.active_effects where id = p_effect for update;
  if ef.id is null or not public.can_edit_character(ef.character_id) then
    raise exception 'Efeito não encontrado.';
  end if;
  select * into fm from public.character_forms where id = ef.form_id for update;
  if exists (select 1 from public.pc_transactions where request_id = p_request) then
    return jsonb_build_object('pc_current', fm.pc_current, 'turns_paid', ef.turns_paid, 'turns_total', ef.turns_total, 'active', ef.active, 'duplicate', true);
  end if;
  if not ef.active then
    raise exception 'Este efeito já foi encerrado.';
  end if;
  if fm.pc_current < ef.per_turn_cost then
    raise exception 'PC insuficiente para manter o efeito (atual: %, necessário: %).', fm.pc_current, ef.per_turn_cost;
  end if;
  update public.character_forms set pc_current = pc_current - ef.per_turn_cost where id = fm.id returning * into fm;
  insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
  values (p_request, fm.id, -ef.per_turn_cost, 'Manutenção: ' || ef.label, auth.uid());
  update public.active_effects
  set turns_paid = turns_paid + 1,
      active = (turns_total = 0 or turns_paid + 1 < turns_total),
      ended_at = case when turns_total > 0 and turns_paid + 1 >= turns_total then now() end
  where id = ef.id returning * into ef;
  return jsonb_build_object('pc_current', fm.pc_current, 'turns_paid', ef.turns_paid, 'turns_total', ef.turns_total, 'active', ef.active, 'duplicate', false);
end $$;

create or replace function public.end_effect(p_effect uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  ef public.active_effects;
begin
  select * into ef from public.active_effects where id = p_effect;
  if ef.id is null or not public.can_edit_character(ef.character_id) then
    raise exception 'Efeito não encontrado.';
  end if;
  update public.active_effects set active = false, ended_at = coalesce(ended_at, now()) where id = p_effect;
end $$;

-- spend_pc (Fase 1) recebia o valor do navegador; agora só ajustes manuais passam
-- por adjust_form_resource e poderes passam por use_power.
revoke execute on function public.spend_pc(uuid, int, uuid, text) from authenticated;

-- ---------------------------------------------------------------------
-- 6. Permissões de execução
-- ---------------------------------------------------------------------
revoke execute on function public.roll_simple_dice(jsonb) from public, anon, authenticated;
grant execute on function
  public.create_lenda_form(uuid, text),
  public.complete_lenda_form(uuid, int, int),
  public.set_character_level(uuid, int),
  public.compute_power_cost(jsonb, int, text),
  public.is_valid_dice(text),
  public.use_power(uuid, uuid, uuid, int),
  public.advance_effect(uuid, uuid),
  public.end_effect(uuid)
  to authenticated;
