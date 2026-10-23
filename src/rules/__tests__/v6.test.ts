import { describe, it } from "node:test";
import assert from "node:assert/strict";
import {
  CATALOG_BY_ID,
  CLASS_BY_ID,
  GRENADES,
  GRENADE_BY_ID,
  RULES_CONFIG,
  buildSheet,
  confrontOutcome,
  defaultReaction,
  kitGrants,
  parseGrenadeMix,
  performConfrontation,
  slotReceived,
  validateKitChoices,
  type Rng,
  type StoredForm,
} from "../index.ts";

function seq(...values: number[]): Rng {
  let i = 0;
  return (sides) => Math.min(sides, values[Math.min(i++, values.length - 1)]);
}
const P = (skillValue: number) => ({ name: "Jogador", isPlayer: true, skillValue });
const N = (skillValue: number) => ({ name: "NPC", isPlayer: false, skillValue });

describe("combate por rolagens opostas (v6)", () => {
  it("vence quem tirar o MAIOR d100 (configurável)", () => {
    assert.equal(RULES_CONFIG.opposed.winner, "higher");
    assert.equal(confrontOutcome(80, 20, N(50), N(50)).winner, "attacker");
    assert.equal(confrontOutcome(20, 80, N(50), N(50)).winner, "defender");
  });

  it("separa o vencedor da qualidade da rolagem (menor é melhor contra a perícia)", () => {
    const o = confrontOutcome(80, 20, N(50), N(50));
    assert.equal(o.winner, "attacker");
    assert.equal(o.quality, "failure");
    assert.equal(o.multiplier, 1, "venceu o confronto: dano padrão");
    const g = confrontOutcome(20, 10, N(50), N(50));
    assert.equal(g.quality, "good");
    assert.equal(g.multiplier, 1, "acerto bom: dano padrão");
  });

  it("extremo ×1,5 e resultado 1 ×2, só para quem vence e sem acumular", () => {
    assert.equal(confrontOutcome(9, 3, N(50), N(50)).multiplier, 1.5);
    assert.equal(confrontOutcome(9, 50, N(50), N(50)).multiplier, 0);
    const crit = confrontOutcome(1, 1, P(50), N(50));
    assert.equal(crit.quality, "critical_success");
    assert.equal(crit.multiplier, 2);
  });

  it("empate jogador × NPC/monstro: o jogador vence atacando ou defendendo", () => {
    const a = confrontOutcome(40, 40, P(10), N(90));
    assert.deepEqual([a.winner, a.tieBreak], ["attacker", "player"]);
    const d = confrontOutcome(40, 40, N(90), P(10));
    assert.deepEqual([d.winner, d.tieBreak], ["defender", "player"]);
  });

  it("empate PvP e NPC × NPC: maior perícia; igual → nova rolagem", () => {
    assert.deepEqual(Object.values(confrontOutcome(40, 40, P(60), P(55))).slice(0, 2), ["attacker", "skill"]);
    assert.deepEqual(Object.values(confrontOutcome(40, 40, N(30), N(45))).slice(0, 2), ["defender", "skill"]);
    assert.equal(confrontOutcome(40, 40, N(50), N(50)).winner, "reroll");
  });

  it("confronto completo: repete no empate total, rola o dano e aplica o multiplicador", () => {
    // 1ª rodada 40×40 (mesma perícia) → nova rolagem; 2ª: 9×5 (extremo) → dano 2d6 = 3+4 = 7 ×1,5 = 10,5
    const r = performConfrontation(N(50), N(50), { expr: "2d6" }, { rng: seq(40, 40, 9, 5, 3, 4) });
    assert.equal(r.rounds.length, 2);
    assert.equal(r.hit, true);
    assert.equal(r.finalDamage, 10.5);
    assert.equal(r.appliedDamage, 10, "PV recebe inteiro (arredondado para baixo)");
    const miss = performConfrontation(N(50), N(50), { expr: "2d6" }, { rng: seq(10, 90) });
    assert.equal(miss.hit, false);
    assert.equal(miss.damageRoll, null);
  });

  it("perícias de combate: corpo a corpo → Luta; distância/fogo → Reflexo como reação; ataque por tipo", () => {
    assert.equal(defaultReaction("melee"), "luta");
    assert.equal(defaultReaction("ranged"), "reflexo");
    assert.equal(defaultReaction("firearm"), "reflexo");
    assert.deepEqual(RULES_CONFIG.attackSkill, { melee: "luta", ranged: "pontaria", firearm: "arma_de_fogo" });
  });
});

describe("granadas (v6)", () => {
  it("tabela do autor no catálogo oficial", () => {
    const table = Object.fromEntries(GRENADES.map((g) => [g.key, g.damage]));
    assert.deepEqual(table, { fragmentacao: "3d8", incendiaria: "2d6", concussao: "2d6", explosiva_pesada: "5d8", fumaca: null });
    assert.equal(GRENADE_BY_ID.granada_incendiaria.condition?.dot, "1d6");
    assert.equal(GRENADE_BY_ID.granada_incendiaria.condition?.turns, 2);
    assert.equal(GRENADE_BY_ID.granada_concussao.condition?.automatic, false, "atordoado: o Mestre decide");
    assert.equal(GRENADE_BY_ID.granada_fumaca.condition?.turns, 3);
    assert.equal(GRENADE_BY_ID.granada_explosiva_pesada.rare, true);
    for (const g of GRENADES) assert.ok(CATALOG_BY_ID[g.id], g.id);
  });

  it("Demolidor: cinco granadas combinando tipos, uma linha por tipo", () => {
    const mix = "fragmentacao:2,incendiaria:1,concussao:1,fumaca:1";
    assert.deepEqual(parseGrenadeMix(mix), { fragmentacao: 2, incendiaria: 1, concussao: 1, fumaca: 1 });
    assert.equal(validateKitChoices("demolidor", null, { arma_distancia: "balestra", granadas: mix }).length, 0);
    assert.equal(validateKitChoices("demolidor", null, { arma_distancia: "balestra", granadas: "fragmentacao:4" }).length, 1, "precisa somar 5");
    assert.equal(validateKitChoices("demolidor", null, { arma_distancia: "balestra", granadas: "explosiva_pesada:5" }).length, 1, "rara não entra no kit");
    const g = kitGrants("demolidor", null, { arma_distancia: "balestra", granadas: mix }).filter((x) => x.slotId === "granadas");
    assert.deepEqual(
      g.map((x) => [x.kitRef, x.quantity]),
      [
        ["kit:demolidor:granadas.fragmentacao", 2],
        ["kit:demolidor:granadas.incendiaria", 1],
        ["kit:demolidor:granadas.concussao", 1],
        ["kit:demolidor:granadas.fumaca", 1],
      ],
    );
  });

  it("vaga recebida não é entregue de novo (inclusive a granada genérica das versões anteriores)", () => {
    assert.equal(slotReceived("demolidor", "granadas", ["kit:demolidor:granadas.fumaca"]), true);
    assert.equal(slotReceived("demolidor", "granadas", ["kit:demolidor:granadas"]), true);
    assert.equal(slotReceived("demolidor", "granadas", ["kit:demolidor:arma_distancia"]), false);
  });
});

describe("revisão das regras (v6)", () => {
  const form = (attrs: Record<string, number>): StoredForm => ({
    kind: "base",
    pv_current: 0,
    pc_current: 0,
    pv_other_bonus: 0,
    pc_other_bonus: 0,
    attributes: Object.entries(attrs).map(([attribute, base_value]) => ({ attribute, base_value, other_bonus: 0, temp_bonus: 0 })),
    skills: [],
    progressions: [],
  });
  const attrs = { FOR: 60, DEX: 50, INT: 50, CON: 45, MIT: 40, PER: 50, CAR: 40, VIG: 66 };

  it("PV = (FOR + CON) ÷ 3 e PC = VIG ÷ 3", () => {
    const s = buildSheet({ classId: null, originId: "muto", level: 1, form: form(attrs) });
    assert.equal(s.resources.pvMax, Math.floor((60 + 45) / 3));
    assert.equal(s.resources.pcMax, Math.floor(66 / 3));
  });

  it("limite de perícia 75 (Detalhista 95)", () => {
    assert.equal(RULES_CONFIG.skillDistribution.maxSkillTotal, 75);
    assert.equal((CLASS_BY_ID.detalhista as { maxPerSkillOverride?: number }).maxPerSkillOverride, 95);
  });
});
