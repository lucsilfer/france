import { describe, it } from "node:test";
import assert from "node:assert/strict";
import {
  abilitiesGranted,
  abilityRule,
  abilityStatus,
  baseResources,
  buildSheet,
  checkCreation,
  checkLevelChange,
  computePowerCost,
  kitGrants,
  startingKit,
  validateKitChoices,
  weaponOptions,
  skillOptions,
  type KitSlot,
  type StoredForm,
} from "../index.ts";

const attrs = (vals: Record<string, number>) => Object.entries(vals).map(([attribute, base_value]) => ({ attribute, base_value, other_bonus: 0, temp_bonus: 0 }));
const BASE = { FOR: 60, DEX: 50, INT: 60, CON: 45, MIT: 30, PER: 55, CAR: 40, VIG: 70 };
const form = (over: Partial<StoredForm> = {}): StoredForm => ({
  kind: "base",
  pv_current: 0,
  pc_current: 0,
  pv_other_bonus: 0,
  pc_other_bonus: 0,
  attributes: attrs(BASE),
  skills: [],
  progressions: [],
  ...over,
});

describe("PV = (FOR + CON) ÷ 3", () => {
  it("exemplo do autor: FOR 60 + CON 45 → 35", () => {
    assert.equal(baseResources({ ...BASE }, null).pv, 35);
  });
  it("arredonda para baixo: (61 + 45) ÷ 3 = 35,33 → 35", () => {
    assert.equal(baseResources({ ...BASE, FOR: 61 }, null).pv, 35);
  });
  it("bônus de classe entra depois do cálculo base (Tank +20)", () => {
    assert.equal(baseResources({ ...BASE }, "tank").pv, 55);
  });
  it("bônus de atributo da classe entra antes da divisão (Brawler +4 FOR)", () => {
    const s = buildSheet({ classId: "brawler", originId: "muto", level: 1, form: form() });
    assert.equal(s.resources.pvMax, Math.floor((64 + 45) / 3));
  });
  it("ganhos de nível e outros bônus são preservados", () => {
    const f = form({ progressions: [{ level: 2, pv_gain: 9, pc_gain: 0 }, { level: 3, pv_gain: 4, pc_gain: 0 }], pv_other_bonus: 2 });
    assert.equal(buildSheet({ classId: "tank", originId: "muto", level: 3, form: f }).resources.pvMax, 35 + 20 + 9 + 4 + 2);
  });
  it("forma Lenda usa a mesma fórmula, sem classe", () => {
    assert.equal(buildSheet({ classId: "tank", originId: "artificial", level: 1, form: form({ kind: "lenda" }) }).resources.pvMax, 35);
  });
});

describe("vagas de habilidades", () => {
  const std = abilityRule("amaldicoado", null);
  it("2 no nível 1 e +1 a cada nível par (tabela do autor)", () => {
    const table: [number, number][] = [[1, 2], [2, 3], [3, 3], [4, 4], [5, 4], [6, 5], [8, 6], [10, 7], [20, 12]];
    for (const [lvl, n] of table) assert.equal(abilitiesGranted(lvl, std), n, `nível ${lvl}`);
  });
  it("disponíveis = adquiridas − criadas", () => {
    const s = abilityStatus({ level: 4, originId: "receptaculo", pathId: null, created: 1 });
    assert.equal(s.granted, 4);
    assert.equal(s.available, 3);
    assert.equal(s.canCreate, true);
    assert.equal(abilityStatus({ level: 4, originId: "receptaculo", pathId: null, created: 4 }).canCreate, false);
  });
  it("nível 1 com 1 de 2 criada: evolução bloqueada", () => {
    const s = abilityStatus({ level: 1, originId: "amaldicoado", pathId: null, created: 1 });
    assert.equal(s.blocked, true);
    assert.equal(s.maxLevel, 1);
    assert.ok(checkLevelChange(s, 1, 2));
  });
  it("criando a segunda libera o nível 2, e o nível 2 exige a terceira para ir ao 3", () => {
    const s = abilityStatus({ level: 1, originId: "amaldicoado", pathId: null, created: 2 });
    assert.equal(s.maxLevel, 2);
    assert.equal(checkLevelChange(s, 1, 2), null);
    assert.ok(checkLevelChange(s, 1, 3), "salto 1→3 também é bloqueado");
    assert.equal(abilityStatus({ level: 2, originId: "amaldicoado", pathId: null, created: 3 }).maxLevel, 4);
  });
  it("descer de nível nunca é bloqueado", () => {
    const s = abilityStatus({ level: 6, originId: "amaldicoado", pathId: null, created: 0 });
    assert.equal(checkLevelChange(s, 6, 3), null);
  });
  it("Muto não usa o sistema: sem vagas, sem pendências, sem bloqueio", () => {
    const s = abilityStatus({ level: 1, originId: "muto", pathId: null, created: 0 });
    assert.equal(s.mode, "none");
    assert.equal(s.available, 0);
    assert.equal(s.blocked, false);
    assert.equal(s.maxLevel, 20);
  });
  it("Elo cria livremente e não tem bloqueio", () => {
    const s = abilityStatus({ level: 1, originId: "elo", pathId: null, created: 9 });
    assert.equal(s.mode, "free");
    assert.equal(s.canCreate, true);
    assert.equal(s.maxLevel, 20);
  });
  it("Prodígio segue o Caminho: Arsenal 1 técnica por nível par; Engrenagem instrumento + 1 por nível par; Pacto regra geral", () => {
    assert.equal(abilityStatus({ level: 1, originId: "prodigio", pathId: "arsenal", created: 0 }).granted, 0);
    assert.equal(abilityStatus({ level: 4, originId: "prodigio", pathId: "arsenal", created: 0 }).granted, 2);
    assert.equal(abilityStatus({ level: 1, originId: "prodigio", pathId: "engrenagem", created: 0 }).granted, 1);
    assert.equal(abilityStatus({ level: 4, originId: "prodigio", pathId: "engrenagem", created: 0 }).granted, 3);
    assert.equal(abilityStatus({ level: 1, originId: "prodigio", pathId: "pacto", created: 0 }).granted, 2);
    assert.equal(abilityStatus({ level: 1, originId: "prodigio", pathId: "arsenal", created: 0 }).maxLevel, 2);
  });
  it("personagens antigos com mais poderes que vagas: nada é apagado, disponíveis = 0", () => {
    const s = abilityStatus({ level: 1, originId: "amaldicoado", pathId: null, created: 5 });
    assert.equal(s.available, 0);
    assert.equal(s.blocked, false);
  });
});

describe("Prodígio: poderes sem PC e sem limites", () => {
  const big = [{ type: "damage" as const, tier: 4, extraDice: 6, area: "enorme" as const }];
  it("demais origens continuam limitadas", () => {
    const c = computePowerCost(big, 1, "muto");
    assert.equal(c.valid, false);
    assert.equal(c.errors.length, 2);
  });
  it("Prodígio: válido em qualquer nível, custo 0 de PC", () => {
    const c = computePowerCost(big, 1, "prodigio");
    assert.equal(c.valid, true, c.errors.join());
    assert.equal(c.initial, 0);
    assert.equal(c.perTurn, 0);
    assert.equal(c.unlimited, true);
    assert.ok(c.fullInitial > 0, "custo cheio fica só como referência");
  });
  it("Prodígio pode registrar técnica/aparato sem efeito de dados", () => {
    assert.equal(computePowerCost([], 1, "prodigio").valid, true);
    assert.equal(computePowerCost([], 1, "muto").valid, false);
  });
  it("Prodígio não rola PC na evolução e só ganha PV", () => {
    const f = form({ progressions: [{ level: 2, pv_gain: 10, pc_gain: 0 }] });
    const s = buildSheet({ classId: "tank", originId: "prodigio", level: 2, form: f });
    assert.equal(s.resources.breakdown.levelPc, 0);
  });
});

describe("equipamento inicial", () => {
  it("toda classe tem kit", () => {
    for (const id of ["brawler", "demolidor", "detalhista", "esoterico", "atirador", "rato", "healer", "tank", "lider"]) assert.ok(startingKit(id).length >= 2, id);
  });
  it("Brawler: refinada corpo a corpo + simples + armadura", () => {
    const slot = startingKit("brawler")[0] as Extract<KitSlot, { kind: "weapon" }>;
    assert.ok(weaponOptions(slot, null).every((w) => w.tier === "refinada" && w.attackKind === "melee"));
    const g = kitGrants("brawler", null, { arma_refinada: "espada_grande", arma_simples: "faca" });
    assert.deepEqual(g.map((x) => x.item.id), ["espada_grande", "faca", "armadura_simples"]);
    assert.deepEqual(g.map((x) => x.kitRef), ["kit:brawler:arma_refinada", "kit:brawler:arma_simples", "kit:brawler:armadura"]);
  });
  it("escolhas obrigatórias e restrições da classe", () => {
    assert.equal(validateKitChoices("brawler", null, {}).length, 2);
    assert.equal(validateKitChoices("brawler", null, { arma_refinada: "revolver", arma_simples: "faca" }).length, 1, "arma de fogo não é corpo a corpo");
    assert.equal(validateKitChoices("tank", null, { arma_refinada: "fuzil_assalto" }).length, 1, "Tank: refinada que não seja de fogo");
  });
  it("Demolidor: arma de fogo só para Prodígio", () => {
    assert.equal(validateKitChoices("demolidor", "muto", { arma_distancia: "revolver" }).length, 1);
    assert.equal(validateKitChoices("demolidor", "prodigio", { arma_distancia: "revolver" }).length, 0);
    const g = kitGrants("demolidor", "muto", { arma_distancia: "balestra" });
    assert.equal(g.find((x) => x.item.id === "granada")!.quantity, 5);
  });
  it("Detalhista: item de perícia fora da seção Lutar", () => {
    const slot = startingKit("detalhista")[1] as Extract<KitSlot, { kind: "skill_item" }>;
    assert.ok(skillOptions(slot).every((s) => s.group !== "lutar"));
    assert.equal(validateKitChoices("detalhista", null, { arma_refinada: "espada_curta", item_pericia: "luta" }).length, 1);
    const g = kitGrants("detalhista", null, { arma_refinada: "espada_curta", item_pericia: "investigacao" });
    assert.match(g[1].item.name, /Investigação/);
  });
  it("trocar de classe usa só as vagas da nova classe", () => {
    const g = kitGrants("healer", null, { arma_refinada: "espada_curta", arma_simples: "pa" });
    assert.deepEqual(g.map((x) => x.kitRef), ["kit:healer:arma_simples", "kit:healer:kit_medicina"]);
  });
  it("criação exige as escolhas do kit na etapa da classe", () => {
    const base = { classId: "healer", originId: "muto", originPathId: null, name: "A", playerName: "B", form: form() };
    assert.equal(checkCreation(base)[2].complete, false);
    assert.equal(checkCreation({ ...base, kitChoices: { arma_simples: "pa" } })[2].complete, true);
  });
});
