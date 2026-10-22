/**
 * Vagas de habilidades e bloqueio de evolução (Atualização 3.5).
 * Regra geral: 2 no nível 1, +1 a cada nível par. Exceções por origem/Caminho em RULES_CONFIG.abilities.
 */
import { RULES_CONFIG } from "./config.ts";

export type AbilityMode = "standard" | "free" | "none";

export interface AbilityRule {
  mode: AbilityMode;
  base: number;
  perEvenLevel: number;
  /** De onde veio a regra (para exibir). */
  source: string;
}

export function abilityRule(originId: string | null, pathId: string | null): AbilityRule {
  const cfg = RULES_CONFIG.abilities;
  const originMode = originId ? cfg.originModes[originId] : undefined;
  if (originMode === "none") return { mode: "none", base: 0, perEvenLevel: 0, source: "Mutação Adaptativa (Muto)" };
  if (originMode === "free") return { mode: "free", base: 0, perEvenLevel: 0, source: "Criação livre (Elo)" };
  const override = originId && pathId ? cfg.pathOverrides[`${originId}:${pathId}`] : undefined;
  if (override) return { mode: "standard", ...override, source: "Regra do Caminho" };
  return { mode: "standard", base: cfg.base, perEvenLevel: cfg.perEvenLevel, source: "Regra geral" };
}

/** Habilidades adquiridas até o nível (só no modo "standard"). */
export function abilitiesGranted(level: number, rule: AbilityRule): number {
  if (rule.mode !== "standard") return 0;
  return rule.base + rule.perEvenLevel * Math.floor(Math.max(1, level) / 2);
}

export interface AbilityStatus {
  mode: AbilityMode;
  rule: AbilityRule;
  granted: number;
  created: number;
  /** Vagas ainda livres (nunca negativo). */
  available: number;
  /** Pode criar uma habilidade nova agora? */
  canCreate: boolean;
  /** Maior nível que pode ser escolhido agora (respeitando a validação nível a nível). */
  maxLevel: number;
  /** Subir de nível está bloqueado por habilidades pendentes? */
  blocked: boolean;
}

export function abilityStatus(input: { level: number; originId: string | null; pathId: string | null; created: number }): AbilityStatus {
  const rule = abilityRule(input.originId, input.pathId);
  const { min, max } = RULES_CONFIG.levels;
  const granted = abilitiesGranted(input.level, rule);
  const available = rule.mode === "standard" ? Math.max(0, granted - input.created) : 0;
  let maxLevel: number = max;
  if (rule.mode === "standard" && RULES_CONFIG.abilities.blockLevelUpWhenPending) {
    // Para chegar ao nível L é preciso ter criado todas as habilidades de cada nível anterior (L−1, L−2, …).
    maxLevel = Math.max(input.level, min);
    while (maxLevel < max && abilitiesGranted(maxLevel, rule) <= input.created) maxLevel++;
  }
  return {
    mode: rule.mode,
    rule,
    granted,
    created: input.created,
    available,
    canCreate: rule.mode !== "standard" || available > 0,
    maxLevel,
    blocked: maxLevel <= input.level && input.level < max,
  };
}

/** Validação de mudança de nível (a mesma conta roda no banco). */
export function checkLevelChange(status: AbilityStatus, from: number, to: number): string | null {
  if (to <= from) return null;
  if (to > status.maxLevel) {
    return "Evolução bloqueada: você ainda possui habilidades disponíveis para criar. Finalize suas habilidades antes de avançar para o próximo nível.";
  }
  return null;
}

/** Nome e textos da aba de poderes conforme a origem/Caminho (Prodígio personaliza). */
export interface PowersTabInfo {
  theme: "default" | "arsenal" | "engrenagem" | "pacto";
  label: string;
  singular: string;
  plural: string;
  newLabel: string;
  description: string;
}

export function powersTabInfo(originId: string | null, pathId: string | null): PowersTabInfo {
  if (originId === "prodigio") {
    if (pathId === "arsenal")
      return {
        theme: "arsenal",
        label: "Técnicas de Arsenal",
        singular: "técnica",
        plural: "técnicas",
        newLabel: "Técnica personalizada",
        description: "Técnicas de combate e armamentos. A cada nível par o Arsenal aprende uma técnica da lista do livro (ou uma técnica personalizada combinada com o Mestre). Técnicas e criações dividem as mesmas vagas. Sem custo de PC.",
      };
    if (pathId === "engrenagem")
      return {
        theme: "engrenagem",
        label: "Aparatos Tecnológicos",
        singular: "aparato",
        plural: "aparatos",
        newLabel: "Novo aparato",
        description: "O instrumento tecnológico de luta e as criações ligadas a ele (uma nova a cada nível par). Sem custo de PC.",
      };
    if (pathId === "pacto")
      return {
        theme: "pacto",
        label: "Inventário Místico",
        singular: "objeto místico",
        plural: "objetos místicos",
        newLabel: "Novo objeto místico",
        description: "Objetos de pacto, vínculos sobrenaturais e selos. Sem custo de PC.",
      };
  }
  return {
    theme: "default",
    label: "Poderes Próprios",
    singular: "habilidade",
    plural: "habilidades",
    newLabel: "Criar habilidade",
    description: "O criador calcula o custo em PC com as tabelas do livro e respeita os limites do seu nível.",
  };
}
