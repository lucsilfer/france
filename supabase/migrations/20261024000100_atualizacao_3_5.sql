-- =====================================================================
-- F.R.A.N.C.E — Atualização 3.5
-- PV (FOR + CON) ÷ 3, vagas de habilidades e bloqueio de evolução,
-- equipamento inicial das classes, Prodígio sem PC, velocidade das rolagens.
-- INCREMENTAL: só adiciona colunas/funções e ajusta dados com registro.
-- Não apaga personagens, contas, poderes nem inventários.
-- Depende de 20261024000000_rules_sync_3_5.sql (rules_config 3.5, form_pv_max, ability_status).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Configuração do usuário: velocidade das rolagens
-- ---------------------------------------------------------------------
alter table public.profiles add column if not exists roll_speed text not null default 'fast';
alter table public.profiles drop constraint if exists profiles_roll_speed_check;
alter table public.profiles add constraint profiles_roll_speed_check check (roll_speed in ('instant', 'fast', 'normal'));

-- ---------------------------------------------------------------------
-- 2. Equipamento inicial das classes
--    starting_kit: escolhas feitas na criação ({"vaga": "opção"}).
--    items.kit_ref: "kit:<classe>:<vaga>" — uma vaga nunca é entregue duas vezes.
-- ---------------------------------------------------------------------
alter table public.characters add column if not exists starting_kit jsonb not null default '{}'::jsonb;
alter table public.items add column if not exists kit_ref text;
alter table public.items drop constraint if exists items_kit_ref_unique;
alter table public.items add constraint items_kit_ref_unique unique (character_id, kit_ref);
alter table public.items drop constraint if exists items_kit_ref_format;
alter table public.items add constraint items_kit_ref_format check (kit_ref is null or kit_ref ~ '^kit:[a-z_]+:[a-z_]+$');

-- Trocar de classe apaga as escolhas anteriores (os itens só são entregues ao finalizar).
create or replace function public.reset_kit_on_class_change() returns trigger
language plpgsql as $$
begin
  if new.class_id is distinct from old.class_id then
    new.starting_kit := '{}'::jsonb;
  end if;
  return new;
end $$;
drop trigger if exists characters_reset_kit on public.characters;
create trigger characters_reset_kit before update of class_id on public.characters
  for each row execute function public.reset_kit_on_class_change();

-- ---------------------------------------------------------------------
-- 3. Poderes: custo com a regra do Prodígio (sem PC, sem limites)
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
  -- Prodígio (Atualização 3.5): sem custo de PC, sem limites, pode não ter efeito de dados.
  pp jsonb := case when p_origin = 'prodigio' then public.rules_config() -> 'prodigioPowers' else '{}'::jsonb end;
  limited boolean := not coalesce((pp ->> 'noLimits')::boolean, false);
begin
  if p_components is null or jsonb_typeof(p_components) <> 'array' then
    errors := array_append(errors, 'Adicione pelo menos um efeito.');
  elsif jsonb_array_length(p_components) = 0 then
    if not coalesce((pp ->> 'allowNoEffects')::boolean, false) then
      errors := array_append(errors, 'Adicione pelo menos um efeito.');
    end if;
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
  if coalesce((pp ->> 'noPcCost')::boolean, false) then
    initial := 0;
    per_turn_final := 0;
  end if;
  limit_cost := (case when cursed and not (cfg ->> 'amaldicoadoLimitUsesFullCost')::boolean then initial else full_initial end)
              + (case when (cfg ->> 'perTurnCountsTowardLimit')::boolean then per_turn else 0 end);
  if limited and limit_cost > max_pc then
    errors := array_append(errors, format('Custo de %s PC acima do limite de %s PC no nível %s.', limit_cost, max_pc, p_level));
  end if;
  if limited and extra > max_extra then
    errors := array_append(errors, format('%s dados extras acima do máximo de +%s no nível %s.', extra, max_extra, p_level));
  end if;
  return jsonb_build_object('full_initial', full_initial, 'initial', initial, 'per_turn', per_turn_final, 'extra_dice', extra,
                            'max_pc', max_pc, 'max_extra_dice', max_extra, 'unlimited', not limited, 'valid', cardinality(errors) = 0, 'errors', to_jsonb(errors));
end $$;

-- Valida e grava o custo calculado pelo banco.
--  * Inserção: confere vagas de habilidades (regra geral; Elo e Muto livres).
--  * Edição dos efeitos: precisa caber nos limites do nível atual.
--  * Edição só de nome/favorito: aceita poderes antigos fora do limite (nada é apagado).
create or replace function public.validate_power() returns trigger
language plpgsql as $$
declare
  ch record;
  cost jsonb;
  st jsonb;
  effects_changed boolean := true;
begin
  if tg_op = 'UPDATE' then
    effects_changed := new.components is distinct from old.components or new.character_id <> old.character_id;
  end if;
  select level, origin_id into ch from public.characters where id = new.character_id;
  cost := public.compute_power_cost(new.components, ch.level, ch.origin_id);
  if effects_changed and not (cost ->> 'valid')::boolean then
    raise exception 'Poder inválido: %', array_to_string(array(select jsonb_array_elements_text(cost -> 'errors')), ' ');
  end if;
  if tg_op = 'INSERT' then
    st := public.ability_status(new.character_id);
    if st ->> 'mode' = 'standard' and (st ->> 'created')::int >= (st ->> 'granted')::int then
      raise exception 'Sem habilidades disponíveis: % de % já criadas neste nível.', st ->> 'created', st ->> 'granted';
    end if;
  end if;
  -- O banco grava o custo calculado por ele mesmo (o valor enviado pelo navegador é ignorado).
  new.initial_cost := coalesce((cost ->> 'initial')::int, 0);
  new.per_turn_cost := coalesce((cost ->> 'per_turn')::int, 0);
  return new;
end $$;
drop trigger if exists powers_validate on public.powers;
create trigger powers_validate before insert or update on public.powers
  for each row execute function public.validate_power();

-- Uso de poder: efeito contínuo depende dos EFEITOS (não do custo), para o Prodígio também ter estado ativo.
create or replace function public.use_power(p_power uuid, p_form uuid, p_request uuid, p_turns int default 0) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  pw public.powers;
  fm public.character_forms;
  eff uuid;
  continuous boolean;
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
  if pw.initial_cost > 0 then
    update public.character_forms set pc_current = pc_current - pw.initial_cost where id = p_form returning * into fm;
  end if;
  insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
  values (p_request, p_form, -pw.initial_cost, 'Poder: ' || pw.name, auth.uid());
  continuous := pw.per_turn_cost > 0 or exists (
    select 1 from jsonb_array_elements(pw.components) c where c ->> 'type' in ('heal_continuous', 'condition', 'buff'));
  if continuous and coalesce(p_turns, 0) > 0 then
    insert into public.active_effects (character_id, form_id, power_id, label, per_turn_cost, turns_total, activation_request)
    values (pw.character_id, p_form, pw.id, pw.name, pw.per_turn_cost, least(p_turns, 100), p_request)
    returning id into eff;
  end if;
  return jsonb_build_object('pc_current', fm.pc_current, 'effect_id', eff, 'duplicate', false, 'cost', pw.initial_cost);
end $$;

-- ---------------------------------------------------------------------
-- 4. Evolução: bloqueada enquanto houver habilidades pendentes
--    Para chegar ao nível L é preciso ter criado as habilidades de L−1 (validado nível a nível).
-- ---------------------------------------------------------------------
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
  n_powers int;
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
    select count(*) into n_powers from public.powers where character_id = p_character;
    for l in ch.level..(p_level - 1) loop
      needed := public.ability_granted(ch.origin_id, ch.origin_path_id, l);
      if n_powers < needed then
        raise exception 'EVOLUÇÃO BLOQUEADA: você ainda possui habilidades disponíveis para criar (nível %: % de %). Finalize suas habilidades antes de avançar para o próximo nível.', l, n_powers, needed;
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

  -- PV/PC atuais nunca ficam acima do novo máximo (descer de nível suspende ganhos).
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

-- Ajuste atômico de PV/PC: para PV o banco usa o próprio máximo (form_pv_max), sem confiar no valor enviado.
create or replace function public.adjust_form_resource(p_form uuid, p_resource text, p_delta int, p_max int)
returns int
language plpgsql security definer set search_path = public as $$
declare
  v int;
  cap int;
begin
  if not public.can_edit_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  if p_resource not in ('pv', 'pc') then
    raise exception 'Recurso inválido.';
  end if;
  if p_max < 0 or abs(p_delta) > 100000 then
    raise exception 'Valor inválido.';
  end if;
  if p_resource = 'pv' then
    cap := least(p_max, coalesce(public.form_pv_max(p_form), p_max));
    update public.character_forms set pv_current = least(greatest(pv_current + p_delta, 0), cap)
    where id = p_form returning pv_current into v;
  else
    update public.character_forms set pc_current = least(greatest(pc_current + p_delta, 0), p_max)
    where id = p_form returning pc_current into v;
  end if;
  return v;
end $$;

-- ---------------------------------------------------------------------
-- 5. Ajuste seguro dos dados existentes (idempotente, com registro)
-- ---------------------------------------------------------------------
-- 5.1 PV: o máximo passa a ser (FOR + CON) ÷ 3 (+ classe, + níveis, + outros). Ele é sempre
--     recalculado a partir dos atributos — nada derivado é apagado. Só o PV ATUAL acima do novo
--     máximo é reduzido, e cada mudança fica registrada em pv_formula_fix_log.
create table if not exists public.pv_formula_fix_log (
  id bigserial primary key,
  form_id uuid not null,
  character_id uuid not null,
  old_pv_current int not null,
  new_pv_current int not null,
  new_pv_max int not null,
  fixed_at timestamptz not null default now()
);
alter table public.pv_formula_fix_log enable row level security;
-- Sem políticas: só administradores (SQL Editor) leem o registro.

-- Rotina reaplicável: só mexe em quem está acima do novo máximo. Retorna quantas formas foram ajustadas.
create or replace function public.fix_pv_after_formula_change() returns int
language plpgsql security definer set search_path = public as $$
declare
  n int;
begin
  with fix as (
    select cf.id, cf.character_id, cf.pv_current, public.form_pv_max(cf.id) as pv_max
    from public.character_forms cf
    join public.characters c on c.id = cf.character_id
    where c.status = 'active' and cf.setup_complete
  ), changed as (
    update public.character_forms cf
    set pv_current = fix.pv_max
    from fix
    where cf.id = fix.id and fix.pv_current > fix.pv_max
    returning cf.id, fix.character_id, fix.pv_current as old_pv, fix.pv_max
  ), logged as (
    insert into public.pv_formula_fix_log (form_id, character_id, old_pv_current, new_pv_current, new_pv_max)
    select id, character_id, old_pv, pv_max, pv_max from changed
    returning 1
  )
  select count(*) into n from logged;
  return n;
end $$;
revoke execute on function public.fix_pv_after_formula_change() from public, anon, authenticated;

select public.fix_pv_after_formula_change() as formas_com_pv_ajustado;

-- 5.2 Poderes de Prodígios criados antes desta versão passam a custar 0 PC (recalculado pelo trigger).
update public.powers p set initial_cost = p.initial_cost
from public.characters c
where c.id = p.character_id and c.origin_id = 'prodigio' and (p.initial_cost <> 0 or p.per_turn_cost <> 0);

-- ---------------------------------------------------------------------
-- 6. Permissões
-- ---------------------------------------------------------------------
grant execute on function
  public.compute_power_cost(jsonb, int, text),
  public.use_power(uuid, uuid, uuid, int),
  public.set_character_level(uuid, int)
  to authenticated;
