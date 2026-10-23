/**
 * Gera supabase/tests/08_confront_parity_tests.sql: confere que o BANCO decide os confrontos
 * (classify_d100, confront_outcome) e calcula as perícias (form_skill_value) exatamente como o MOTOR.
 * Uso: node scripts/generate-confront-parity.ts   (também roda em `npm run rules:sql`)
 */
import { writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { classifyD100 } from "../src/rules/d100.ts";
import { confrontOutcome } from "../src/rules/opposed.ts";
import { buildSheet, type StoredForm } from "../src/rules/sheet.ts";
import { CLASSES } from "../src/rules/data/classes.ts";
import { SKILLS } from "../src/rules/data/skills.ts";
import { ATTRIBUTE_IDS } from "../src/rules/data/attributes.ts";

const lines: string[] = [];
let count = 0;

// 1. Classificação do d100 (menor é melhor).
for (const value of [0, 1, 4, 5, 10, 33, 50, 60, 75, 95, 120]) {
  for (const natural of [1, 2, 3, 5, 9, 10, 11, 12, 16, 17, 25, 30, 37, 38, 49, 50, 51, 60, 74, 75, 76, 95, 99, 100]) {
    for (const mod of [0, -10, 15]) {
      const e = classifyD100(natural, value, mod);
      lines.push(`  if public.classify_d100(${natural}, ${value}, ${mod}) <> '${e}' then raise exception 'classify % % %: banco % / motor ${e}', ${natural}, ${value}, ${mod}, public.classify_d100(${natural}, ${value}, ${mod}); end if;`);
      count++;
    }
  }
}

// 2. Confrontos: rolagens, perícias, jogador/NPC, modificador.
const rolls = [1, 2, 9, 17, 34, 50, 51, 75, 99, 100];
const skills = [0, 40, 50, 85];
for (const a of rolls) {
  for (const d of rolls) {
    for (const [as, ds] of [
      [50, 50],
      [85, 40],
      [40, 85],
    ]) {
      for (const [ap, dp] of [
        [true, false],
        [false, true],
        [true, true],
        [false, false],
      ] as [boolean, boolean][]) {
        const o = confrontOutcome(a, d, { name: "A", isPlayer: ap, skillValue: as }, { name: "D", isPlayer: dp, skillValue: ds }, 0);
        lines.push(
          `  r := public.confront_outcome(${a}, ${d}, ${as}, ${ds}, ${ap}, ${dp}, 0);
  if r->>'winner' <> '${o.winner}' or r->>'tie_break' <> '${o.tieBreak}' or r->>'quality' <> '${o.quality}' or r->>'defender_quality' <> '${o.defenderQuality}' or (r->>'multiplier')::numeric <> ${o.multiplier} then
    raise exception 'confronto ${a}×${d} ${as}/${ds} ${ap}/${dp}: banco % / motor ${o.winner} ${o.tieBreak} ${o.quality} ${o.multiplier}', r;
  end if;`,
        );
        count++;
      }
    }
  }
}
for (const s of skills) {
  const o = confrontOutcome(60, 40, { name: "A", isPlayer: false, skillValue: s }, { name: "D", isPlayer: false, skillValue: 50 }, -15);
  lines.push(`  r := public.confront_outcome(60, 40, ${s}, 50, false, false, -15);
  if r->>'quality' <> '${o.quality}' or (r->>'multiplier')::numeric <> ${o.multiplier} then raise exception 'modificador ${s}: banco %', r; end if;`);
  count++;
}

// 3. Perícias calculadas no banco = motor (forma base com classe; forma sem classe).
const attrs: Record<string, number> = { FOR: 62, DEX: 47, INT: 55, CON: 41, MIT: 38, PER: 66, CAR: 29, VIG: 53 };
const skillRows = [
  { skill_id: "luta", points: 10, other_bonus: 2, temp_bonus: 5 },
  { skill_id: "reflexo", points: 7, other_bonus: 0, temp_bonus: -3 },
  { skill_id: "pontaria", points: 4, other_bonus: 1, temp_bonus: 0 },
];
const setup: string[] = [];
const checks: string[] = [];
CLASSES.forEach((cls, i) => {
  const id = `60000000-0000-0000-0000-${String(i + 1).padStart(12, "0")}`;
  const form: StoredForm = {
    kind: "base",
    pv_current: 1,
    pc_current: 1,
    pv_other_bonus: 0,
    pc_other_bonus: 0,
    attributes: ATTRIBUTE_IDS.map((a) => ({ attribute: a, base_value: attrs[a], other_bonus: a === "DEX" ? 3 : 0, temp_bonus: a === "FOR" ? 4 : 0 })),
    skills: skillRows,
    progressions: [],
  };
  const sheet = buildSheet({ classId: cls.id, originId: "muto", level: 1, form });
  setup.push(`insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('${id}', '00000000-0000-0000-0000-00000000000a', 'Paridade ${cls.id}', 'active', '${cls.id}', 'muto', 1);`);
  setup.push(
    `insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ${ATTRIBUTE_IDS.map((a) => `('${a}', ${attrs[a]}, ${a === "DEX" ? 3 : 0}, ${a === "FOR" ? 4 : 0})`).join(", ")}) as a(attr, v, o, t) where cf.character_id = '${id}' and cf.kind = 'base';`,
  );
  setup.push(
    `insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ${skillRows.map((s) => `('${s.skill_id}', ${s.points}, ${s.other_bonus}, ${s.temp_bonus})`).join(", ")}) as s(k, p, o, t) where cf.character_id = '${id}' and cf.kind = 'base';`,
  );
  for (const sk of SKILLS) {
    const e = sheet.skills.find((x) => x.id === sk.id)!.final;
    checks.push(
      `  v := public.form_skill_value((select id from public.character_forms where character_id = '${id}' and kind = 'base'), '${sk.id}');
  if v <> ${e} then raise exception 'perícia ${cls.id}/${sk.id}: banco % / motor ${e}', v; end if;`,
    );
    count++;
  }
});

const sql = `-- GERADO por scripts/generate-confront-parity.ts — ${count} casos.
-- Combate por rolagens opostas e perícias: banco = motor.
\\set ON_ERROR_STOP on
reset role;
${setup.join("\n")}
do $$
declare r jsonb; v int;
begin
${lines.join("\n")}
${checks.join("\n")}
end $$;
delete from public.characters where id::text like '60000000-%';
select 'PARIDADE DE CONFRONTOS E PERÍCIAS: ${count} CASOS OK' as resultado;
`;
writeFileSync(fileURLToPath(new URL("../supabase/tests/08_confront_parity_tests.sql", import.meta.url)), sql);
console.log(`${count} casos gerados`);
