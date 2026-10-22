/**
 * Gera a migração de regras do banco a partir do motor (src/rules).
 * O banco nunca tem números de regra escritos à mão: tudo vem do motor.
 *
 * Arquivos já aplicados nunca são reescritos. Cada nova versão das regras gera
 * um NOVO arquivo (RULES_SQL_PATH). Todos os comandos são "create or replace",
 * então reaplicar é seguro.
 *
 * Uso: npm run rules:sql   (o teste rules-sql-sync.test.ts falha se o arquivo estiver desatualizado)
 */
import { writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { RULES_CONFIG, RULES_VERSION } from "../src/rules/config.ts";
import { ATTRIBUTE_IDS } from "../src/rules/data/attributes.ts";
import { CLASSES } from "../src/rules/data/classes.ts";
import { TECHNIQUES, WEAPON_MODIFIERS } from "../src/rules/data/equipment.ts";
import { ORIGINS } from "../src/rules/data/origins.ts";
import {
  BUFFS,
  CONDITIONS,
  DAMAGE_AREA,
  DAMAGE_AREA_SIZES,
  DAMAGE_SINGLE,
  EXTRA_DIE_COST,
  HEAL_AREA_MODIFIER,
  HEAL_CONTINUOUS,
  HEAL_SINGLE,
  LEVEL_POWER_TABLE,
  SHIELD,
  SHIELD_DURATION,
} from "../src/rules/data/powerTables.ts";
import { SKILLS } from "../src/rules/data/skills.ts";
import { parseDice } from "../src/rules/dice.ts";

/** Versão atual. As anteriores (rules_sync, rules_sync_fase3, rules_sync_3_5) ficam congeladas — já foram aplicadas. */
export const RULES_SQL_PATH = fileURLToPath(new URL("../supabase/migrations/20261025000000_rules_sync_fase4.sql", import.meta.url));

/** "1d12+2" → { count: 1, sides: 12, bonus: 2 } (só o formato usado na evolução). */
function simpleDice(expr: string | null) {
  if (!expr) return null;
  const terms = parseDice(expr).terms;
  const dice = terms.filter((t) => t.sides > 0);
  if (dice.length !== 1 || dice[0].sign !== 1) throw new Error(`Dado de evolução não suportado no banco: ${expr}`);
  const bonus = terms.filter((t) => t.sides === 0).reduce((a, t) => a + t.sign * (t.value ?? 0), 0);
  return { count: dice[0].count, sides: dice[0].sides, bonus };
}

export function rulesSnapshot() {
  const d = RULES_CONFIG.skillDistribution;
  return {
    version: RULES_VERSION,
    attributeRoll: RULES_CONFIG.attributeRoll,
    pvFormula: RULES_CONFIG.pvFormula,
    abilities: RULES_CONFIG.abilities,
    prodigioPowers: RULES_CONFIG.prodigioPowers,
    levels: RULES_CONFIG.levels,
    attributes: ATTRIBUTE_IDS,
    skills: SKILLS.map((s) => s.id),
    skillDefs: Object.fromEntries(
      SKILLS.map((s) => [
        s.id,
        s.base.kind === "fixed"
          ? { kind: "fixed", value: s.base.value }
          : {
              kind: "attribute",
              attribute: s.base.attribute,
              divisor: s.base.divisor === "config:conhecimentoBelico" ? RULES_CONFIG.conhecimentoBelicoDivisor : s.base.divisor,
            },
      ]),
    ),
    skillDistribution: { skillsToChoose: d.skillsToChoose, totalPoints: d.totalPoints, maxSkillTotal: d.maxSkillTotal },
    classes: Object.fromEntries(
      CLASSES.map((c) => [
        c.id,
        {
          pv: c.progression.pv,
          pc: c.progression.pc,
          pvDice: simpleDice(c.progression.pv),
          pcDice: simpleDice(c.progression.pc),
          attributeBonus: c.attributeBonus,
          skillBonus: c.skillBonus,
          maxSkillTotal: c.maxPerSkillOverride,
          skillPointsBonus: c.skillPointsBonus,
          pvBonusAtLevel1: c.pvBonusAtLevel1,
        },
      ]),
    ),
    origins: Object.fromEntries(
      ORIGINS.map((o) => [o.id, { paths: (o.paths ?? []).map((p) => p.id), secondarySheet: Boolean(o.secondarySheet) }]),
    ),
    progressionOverrides: {
      prodigio: {
        pv: RULES_CONFIG.prodigioProgression.pv,
        pc: RULES_CONFIG.prodigioProgression.pc,
        pvDice: simpleDice(RULES_CONFIG.prodigioProgression.pv),
        pcDice: simpleDice(RULES_CONFIG.prodigioProgression.pc),
      },
    },
    weaponModifiers: Object.fromEntries(WEAPON_MODIFIERS.map((m) => [m.id, m.requires])),
    techniques: Object.fromEntries(
      TECHNIQUES.map((t) => [t.id, { name: t.name, usage: t.usage, requires: t.requires ?? {}, special: t.special ?? null }]),
    ),
    maxWeaponModifiers: RULES_CONFIG.maxWeaponModifiers,
    powers: {
      damageSingle: DAMAGE_SINGLE.map((t) => t.cost),
      damageArea: DAMAGE_AREA.map((t) => t.cost),
      areaSizes: Object.fromEntries(DAMAGE_AREA_SIZES.map((a) => [a.id, a.damageCost])),
      extraDieCost: EXTRA_DIE_COST,
      heal: HEAL_SINGLE.map((t) => t.cost),
      healArea: HEAL_AREA_MODIFIER,
      healContinuous: HEAL_CONTINUOUS.map((t) => t.perTurn),
      shield: SHIELD.map((t) => t.cost),
      shieldDuration: Object.fromEntries(SHIELD_DURATION.map((t) => [t.id, t.cost])),
      conditions: Object.fromEntries(CONDITIONS.map((t) => [t.id, { initial: t.initial, perTurn: t.perTurn }])),
      buffs: Object.fromEntries(BUFFS.map((t) => [t.id, { initial: t.initial, perTurn: t.perTurn }])),
      levelTable: LEVEL_POWER_TABLE.map((r) => ({ level: r.level, maxPc: r.maxPc, maxExtraDice: r.maxExtraDice })),
      limitMode: RULES_CONFIG.powerLimitMode,
      perTurnCountsTowardLimit: RULES_CONFIG.perTurnCostCountsTowardLimit,
      amaldicoadoRounding: RULES_CONFIG.amaldicoadoCostRounding,
      amaldicoadoLimitUsesFullCost: RULES_CONFIG.amaldicoadoLimitUsesFullCost,
    },
  };
}

function sqlString(s: string) {
  return `'${s.replace(/'/g, "''")}'`;
}

export function generateRulesSql(): string {
  const json = JSON.stringify(rulesSnapshot(), null, 2);
  return `-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão ${RULES_VERSION}) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select ${sqlString(json)}::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

-- ---------------------------------------------------------------------
-- PV máximo da forma — mesma conta do motor (buildSheet):
-- (FOR + CON) ÷ 3 para baixo + bônus de classe + ganhos de nível ativos + outros bônus.
-- ---------------------------------------------------------------------
create or replace function public.form_pv_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  str int;
  con int;
  base int;
  gains int;
begin
  select cf.id, cf.kind, cf.pv_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into str
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'FOR';
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into con
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'CON';
  str := coalesce(str, 0) + coalesce((cls -> 'attributeBonus' ->> 'FOR')::int, 0);
  con := coalesce(con, 0) + coalesce((cls -> 'attributeBonus' ->> 'CON')::int, 0);
  if cfg ->> 'pvFormula' = 'sum_div3' then
    base := floor((str + con)::numeric / 3)::int;
  else
    base := str + floor(con::numeric / 3)::int;
  end if;
  base := base + coalesce((cls ->> 'pvBonusAtLevel1')::int, 0);
  select coalesce(sum(lp.pv_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, base + gains + f.pv_other_bonus);
end $$;

-- PC máximo da forma — mesma conta do motor: VIG ÷ 3 para baixo + ganhos de nível ativos + outros bônus.
create or replace function public.form_pc_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  vig int;
  gains int;
begin
  select cf.id, cf.kind, cf.pc_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into vig
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'VIG';
  vig := coalesce(vig, 0) + coalesce((cls -> 'attributeBonus' ->> 'VIG')::int, 0);
  select coalesce(sum(lp.pc_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, floor(vig::numeric / 3)::int + gains + f.pc_other_bonus);
end $$;

-- ---------------------------------------------------------------------
-- Vagas de habilidades — mesma conta do motor (abilities.ts).
-- mode: standard | free (Elo) | none (Muto). Executa com as permissões de quem chama.
-- ---------------------------------------------------------------------
create or replace function public.ability_granted(p_origin text, p_path text, p_level int) returns int
language plpgsql immutable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ov jsonb := cfg -> 'pathOverrides' -> (p_origin || ':' || p_path);
begin
  if coalesce(cfg -> 'originModes' ->> p_origin, 'standard') <> 'standard' then
    return 0;
  end if;
  return coalesce((ov ->> 'base')::int, (cfg ->> 'base')::int)
       + coalesce((ov ->> 'perEvenLevel')::int, (cfg ->> 'perEvenLevel')::int) * (greatest(p_level, 1) / 2);
end $$;

create or replace function public.ability_status(p_character uuid) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ch record;
  created int;
begin
  select level, origin_id, origin_path_id into ch from public.characters where id = p_character;
  -- Técnicas oficiais do Arsenal e poderes criados ocupam o mesmo conjunto de vagas (sem consumo duplicado).
  select (select count(*) from public.powers where character_id = p_character)
       + (select count(*) from public.character_techniques where character_id = p_character)
    into created;
  return jsonb_build_object(
    'mode', coalesce(cfg -> 'originModes' ->> ch.origin_id, 'standard'),
    'granted', public.ability_granted(ch.origin_id, ch.origin_path_id, ch.level),
    'created', created,
    'level', ch.level);
end $$;

grant execute on function public.rules_config() to authenticated;
grant execute on function public.form_pv_max(uuid), public.form_pc_max(uuid), public.ability_granted(text, text, int), public.ability_status(uuid) to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;
`;
}

if (process.argv[1] && fileURLToPath(import.meta.url) === process.argv[1]) {
  writeFileSync(RULES_SQL_PATH, generateRulesSql());
  console.log(`Gerado: ${RULES_SQL_PATH}`);
}
