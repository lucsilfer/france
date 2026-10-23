import { describe, it } from "node:test";
import assert from "node:assert/strict";
import {
  creatureSummary,
  customModifierCompatible,
  modifierSlotsUsed,
  normalizeCreature,
  planAttack,
  rollCreatureAbility,
  rollCreatureAttack,
  testValue,
  thresholds,
  usesLabel,
  weaponPreview,
  type CustomModifier,
  type Rng,
  type WeaponLike,
} from "../index.ts";

/** Dado viciado: devolve a sequência dada (e repete o último). */
function seq(...values: number[]): Rng {
  let i = 0;
  return (sides) => Math.min(sides, values[Math.min(i++, values.length - 1)]);
}

const leshy = normalizeCreature({
  attributes: { FOR: 80, CON: 90, XYZ: 5 },
  skills: [{ id: "luta", value: 85 }, { id: "custom:Camuflagem", name: "Camuflagem", value: 95 }],
  pv_max: 150,
  pc_max: 20,
  attacks: [
    { id: "a1", name: "Galhos", uses: "skill:luta", damage: "2d8+4", conditions: [{ name: "Imobilizado", turns: 1 }] },
    { id: "a2", name: "Esmagar", uses: "attr:FOR", damage: "1d10" },
    { id: "a3", name: "Sem dano", uses: "valor", value: 40, damage: "" },
  ],
  abilities: [
    { id: "h1", name: "Raízes", pc_cost: 5, damage: "3d6", condition: { name: "Lentidão", turns: 2 } },
    { id: "h2", name: "Canto", manual: true, heal: "2d6" },
  ],
});

describe("monstros e NPCs (Fase 5)", () => {
  it("normaliza a ficha: atributos válidos, perícias livres (acima de 75), ataques com dano", () => {
    assert.deepEqual(leshy.attributes, { FOR: 80, CON: 90 });
    assert.equal(leshy.skills.find((s) => s.id === "custom:Camuflagem")?.value, 95);
    assert.equal(leshy.attacks.length, 2, "ataque sem dano é descartado");
    assert.equal(leshy.pv_max, 150);
  });

  it("valores de teste vêm da perícia, do atributo ou do valor fixo — com normal / bom / extremo", () => {
    assert.equal(testValue(leshy, "skill:luta"), 85);
    assert.equal(testValue(leshy, "attr:FOR"), 80);
    assert.equal(testValue(leshy, "valor", 33), 33);
    assert.deepEqual(thresholds(85), { normal: 85, good: 42, extreme: 17 });
    assert.equal(usesLabel("skill:custom:Camuflagem", leshy), "Camuflagem");
  });

  it("aceita o formato antigo da Fase 4 (ataque com `skill` numérico, habilidades em texto)", () => {
    const old = normalizeCreature({ attacks: [{ name: "Garras", skill: 60, damage: "1d6" }], abilities: "Regenera 5 PV", pv: 30 });
    assert.equal(old.attacks[0].uses, "valor");
    assert.equal(old.attacks[0].value, 60);
    assert.equal(old.abilities[0].manual, true);
    assert.equal(old.pv_max, 30);
  });

  it("ataque: acerto extremo multiplica o dano (×1,5) e devolve as condições", () => {
    // d100 = 10 (≤ 17 extremo), dano 2d8+4 = 5+3+4 = 12 → 18
    const r = rollCreatureAttack(leshy, leshy.attacks[0], seq(10, 5, 3));
    assert.equal(r.hit, true);
    assert.equal(r.outcomeLabel, "Acerto extremo");
    assert.equal(r.damage?.total, 12);
    assert.equal(r.finalDamage, 18);
    assert.deepEqual(r.conditions, [{ name: "Imobilizado", turns: 1 }]);
  });

  it("ataque: falha não rola dano", () => {
    const r = rollCreatureAttack(leshy, leshy.attacks[0], seq(90));
    assert.equal(r.hit, false);
    assert.equal(r.damage, null);
    assert.equal(r.finalDamage, 0);
  });

  it("habilidade: custo de PC informado, dano e condição; efeito manual não rola", () => {
    const r = rollCreatureAbility(leshy, leshy.abilities[0], seq(4, 4, 4));
    assert.equal(r.pcCost, 5);
    assert.equal(r.damage?.total, 12);
    assert.deepEqual(r.condition, { name: "Lentidão", turns: 2 });
    const m = rollCreatureAbility(leshy, leshy.abilities[1]);
    assert.equal(m.manual, true);
    assert.equal(m.heal, null);
  });

  it("cópias independentes: a mesma ficha gera instâncias que não compartilham estado", () => {
    const copies = [1, 2, 3].map((n) => ({ name: `Leshy ${n}`, pv: leshy.pv_max!, sheet: leshy }));
    copies[0].pv -= 50;
    assert.deepEqual(copies.map((c) => c.pv), [100, 150, 150]);
    assert.match(creatureSummary(leshy), /PV 150/);
  });
});

describe("modificadores personalizados (Fase 5)", () => {
  const lanca: WeaponLike = { name: "Lança", damage: "1d10", attackKind: "melee", tags: ["corpo_a_corpo", "perfurantes_projeteis"], modifiers: ["equilibrada"] };
  const bento: CustomModifier = { id: "hb:1", name: "Bento", requires: "perfurantes_projeteis", always: { extraDamage: "1d4", attackBonus: 5 }, condition: "Fere criaturas das trevas" };
  const runa: CustomModifier = { id: "hb:2", name: "Runa", requires: "laminas", always: { extraDamage: "1d6" } };

  it("compatibilidade pela categoria (ou qualquer arma)", () => {
    assert.equal(customModifierCompatible(bento, lanca.tags), true);
    assert.equal(customModifierCompatible(runa, lanca.tags), false);
    assert.equal(customModifierCompatible({ requires: "qualquer" }, []), true);
  });

  it("efeitos entram no cálculo do ataque; incompatíveis são ignorados", () => {
    const p = planAttack({ ...lanca, customModifiers: [bento, runa] }, { classId: null, originId: null, pathId: null, level: 1, skillValues: { luta: 50 } });
    assert.equal(p.damageExpr, "1d10+1d4");
    assert.equal(p.rollModifier, -10, "Equilibrada (+5) + Bento (+5)");
    assert.ok(p.applied.includes("Bento"));
    assert.ok(!p.applied.includes("Runa"));
    assert.ok(p.conditions.some((c) => c.includes("Fere criaturas")));
  });

  it("limite de vagas: oficiais + personalizados; regra especial não ocupa vaga", () => {
    assert.equal(modifierSlotsUsed(1, [bento]), 2);
    assert.equal(modifierSlotsUsed(1, [{ ...bento, ignoreLimit: true }]), 1);
  });

  it("prévia da arma recalcula dano e crítico", () => {
    const pv = weaponPreview({ ...lanca, customModifiers: [{ ...bento, onCritical: { extraWeaponDice: 1 } }] });
    assert.equal(pv.damage, "1d10+1d4");
    assert.equal(pv.critical, "2d10+1d4");
    assert.equal(pv.attackBonus, 10);
  });
});
