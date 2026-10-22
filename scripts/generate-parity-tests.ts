/**
 * Gera supabase/tests/04_power_parity_tests.sql: confere que o custo de poderes
 * calculado pelo BANCO é idêntico ao do MOTOR para centenas de combinações.
 * Uso: node scripts/generate-parity-tests.ts
 */
import { writeFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { computePowerCost, type PowerComponent } from "../src/rules/powers.ts";
import { BUFFS, CONDITIONS, DAMAGE_AREA_SIZES, SHIELD_DURATION } from "../src/rules/data/powerTables.ts";

const areas = ["alvo", ...DAMAGE_AREA_SIZES.map((a) => a.id)] as const;
const singles: PowerComponent[] = [];
for (let tier = 0; tier < 5; tier++) {
  for (const extraDice of [0, 1, 2, 3]) {
    for (const area of areas) {
      singles.push({ type: "damage", tier, extraDice, area });
      singles.push({ type: "heal", tier, extraDice, area });
    }
    for (const d of SHIELD_DURATION) singles.push({ type: "shield", tier, extraDice, duration: d.id });
  }
  singles.push({ type: "heal_continuous", tier });
}
for (const c of CONDITIONS) singles.push({ type: "condition", intensity: c.id });
for (const b of BUFFS) singles.push({ type: "buff", buff: b.id });

const cases: { components: PowerComponent[]; level: number; origin: string | null }[] = [];
for (const c of singles) for (const level of [1, 3, 6, 12, 20]) cases.push({ components: [c], level, origin: level === 6 ? "amaldicoado" : null });
for (let i = 0; i + 1 < singles.length; i += 7) cases.push({ components: [singles[i], singles[i + 1]], level: 10, origin: i % 2 ? "amaldicoado" : null });
// Atualização 3.5: Prodígio sem custo e sem limites; registro sem efeito de dados.
for (const c of singles) cases.push({ components: [c], level: 1, origin: "prodigio" });
for (let i = 0; i + 2 < singles.length; i += 11) cases.push({ components: [singles[i], singles[i + 1], singles[i + 2]], level: 1, origin: "prodigio" });
cases.push({ components: [], level: 1, origin: "prodigio" }, { components: [], level: 5, origin: null }, { components: [], level: 5, origin: "amaldicoado" });

const lines = cases.map((c) => {
  const e = computePowerCost(c.components, c.level, c.origin);
  const json = JSON.stringify(c.components).replace(/'/g, "''");
  return `  r := public.compute_power_cost('${json}'::jsonb, ${c.level}, ${c.origin ? `'${c.origin}'` : "null"});
  if (r->>'initial')::int <> ${e.initial} or (r->>'per_turn')::int <> ${e.perTurn} or (r->>'valid')::boolean <> ${e.valid} then
    raise exception 'divergência: % nível % → banco % / motor ${e.initial}+${e.perTurn} ${e.valid}', '${json}', ${c.level}, r;
  end if;`;
});

const sql = `-- GERADO por scripts/generate-parity-tests.ts — ${cases.length} casos.
-- Custo de poderes: banco (compute_power_cost) = motor (computePowerCost).
\\set ON_ERROR_STOP on
do $$
declare r jsonb;
begin
${lines.join("\n")}
end $$;
select 'PARIDADE BANCO x MOTOR: ${cases.length} CASOS OK' as resultado;
`;
writeFileSync(fileURLToPath(new URL("../supabase/tests/04_power_parity_tests.sql", import.meta.url)), sql);
console.log(`${cases.length} casos gerados`);
