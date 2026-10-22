/**
 * CONFIGURAÇÃO DO MOTOR DE REGRAS — F.R.A.N.C.E (Tríade das Lendas)
 *
 * Toda decisão de regra que o Livro do Jogador deixa ambígua, incompleta ou
 * que foi definida pelo autor do site (e não pelo livro) fica concentrada aqui.
 * Cada chave tem um comentário com a origem da decisão. Ver também
 * docs/REGRAS-E-PENDENCIAS.md.
 */

export type RoundingMode = "floor" | "round" | "ceil" | "none";

export const RULES_VERSION = "livro-1.0+site-2026.10-3.5";

export const RULES_CONFIG = {
  /** Geração de atributos: ficha → "rolar 3 dados de 3d6*5 e pegar o melhor". */
  attributeRoll: {
    dicePerRoll: 3,
    sides: 6,
    multiplier: 5,
    rollsPerSet: 3,
  },

  /** Limiares de teste: normal / bom (÷2) / extremo (÷5). Pedido do site: arredondar para baixo. */
  thresholds: {
    goodDivisor: 2,
    extremeDivisor: 5,
    rounding: "floor" as RoundingMode,
  },

  /**
   * PV inicial. Ficha: "FOR + CON / 3".
   * CORREÇÃO (autor, Atualização 3.5): PV = (FOR + CON) ÷ 3 — soma ANTES da divisão, arredondado para baixo.
   * Bônus de classe (ex.: Tank +20) e ganhos de nível são somados depois.
   * A fórmula antiga "FOR + (CON ÷ 3)" estava errada; fica disponível só para comparação.
   */
  pvFormula: "sum_div3" as "for_plus_con_div3" | "sum_div3",
  pcFormula: "vig_div3" as const,
  resourceRounding: "floor" as RoundingMode,

  /**
   * Perícias — ficha: "150 pontos para distribuir em 4 perícias com máximo de 75".
   * CORREÇÃO (autor, Fase 3): 75 é o VALOR TOTAL da perícia
   *   (base + pontos distribuídos + bônus de classe + outros bônus permanentes), não o máximo de pontos.
   * Detalhista: total 95. Bônus TEMPORÁRIOS (efeitos de combate) não contam para o limite.
   */
  skillDistribution: {
    skillsToChoose: 4,
    totalPoints: 150,
    /** Limite do VALOR TOTAL de cada perícia. */
    maxSkillTotal: 75,
    /** Bônus de classe "de graça" (Atirador/Rato) NÃO contam entre as 4 escolhidas. Decisão do site. */
    classFreeSkillCountsAsChoice: false,
  },

  /**
   * Conhecimento Bélico. Ficha: "(1/INT)" — notação ambígua.
   * Decisão do site: metade de INT (divisor 2).
   */
  conhecimentoBelicoDivisor: 2,

  /**
   * Limite de PC por habilidade.
   * "linear" (decisão do autor, 21/10/2026): 15 + 3 × (nível − 1) — reproduz exatamente todos os pontos da tabela do livro.
   * "step": mantém o último patamar da tabela.
   * O limite de DADOS EXTRAS continua seguindo a tabela do livro (patamares).
   */
  powerLimitMode: "linear" as "step" | "linear",
  /** O custo por turno conta para o limite de PC por habilidade? Livro não diz. Decisão: não. */
  perTurnCostCountsTowardLimit: false,

  /**
   * Ataque: perícia por tipo de arma (decisão do autor, 21/10/2026).
   * Corpo a corpo → Luta; armas de fogo → Arma de Fogo; demais armas de longa distância → Pontaria.
   */
  attackSkill: {
    melee: "luta",
    ranged: "pontaria",
    firearm: "arma_de_fogo",
  } as Record<"melee" | "ranged" | "firearm", string>,

  /** Multiplicadores de dano (livro, p. 5). */
  damageMultiplier: {
    extreme: 1.5,
    critical: 2,
  },
  /** Arredondamento do dano final. "none" mantém decimais (ex.: 10,5). */
  damageRounding: "none" as RoundingMode,

  /** Modificações por arma (livro: "Cada arma suporta naturalmente até 2 modificações"). */
  maxWeaponModifiers: 2,

  /**
   * "Vantagem" genérica não tem mecânica definida no livro.
   * Decisão provisória: rolar 2d100 e manter o menor (menor é melhor).
   */
  advantageMode: "roll_twice_keep_lowest" as "roll_twice_keep_lowest" | "minus_15",

  /** Progressão: Prodígio (regra do site, não está no livro) → PV 1d12+2, sem rolagem de PC. */
  prodigioProgression: { pv: "1d12+2", pc: null as string | null },

  /** Amaldiçoado "A dívida a pagar": custo de PC reduzido pela metade (arredondamento). */
  amaldicoadoCostRounding: "ceil" as RoundingMode,
  /** O limite por nível é checado contra o custo cheio (antes da redução)? Decisão: sim. */
  amaldicoadoLimitUsesFullCost: true,

  levels: { min: 1, max: 20 },

  /**
   * Vagas de habilidades (Atualização 3.5, regra do autor):
   * nível 1 = 2 habilidades; +1 a cada nível par. Disponíveis = adquiridas − criadas.
   * Com habilidades pendentes o personagem não sobe de nível.
   */
  abilities: {
    base: 2,
    perEvenLevel: 1,
    blockLevelUpWhenPending: true,
    /**
     * Exceções por origem:
     *  - "none": não usa o sistema convencional (Muto — Mutação Adaptativa). Sem vagas, sem pendências, sem bloqueio.
     *  - "free": cria quando quiser, sem limite de vagas e sem bloqueio (Elo).
     */
    originModes: { muto: "none", elo: "free" } as Record<string, "none" | "free">,
    /**
     * Prodígio: quantidade definida pelo Caminho quando o livro é diferente da regra geral.
     *  - Arsenal: "a cada nível par, aprende uma técnica" → 0 + 1 por nível par.
     *  - Engrenagem: o instrumento + "a cada nível par, cria uma habilidade ligada a ele" → 1 + 1 por nível par.
     *  - Pacto: o livro não dá quantidade → regra geral.
     * [decisão do site — confirmar com o autor]
     */
    pathOverrides: {
      "prodigio:arsenal": { base: 0, perEvenLevel: 1 },
      "prodigio:engrenagem": { base: 1, perEvenLevel: 1 },
    } as Record<string, { base: number; perEvenLevel: number }>,
  },

  /**
   * Prodígio (Atualização 3.5): não usa PC.
   * Sem barra de PC, sem custo ao usar, sem limite de PC por habilidade nem de dados extras,
   * e pode registrar técnicas/aparatos/objetos sem efeito de dados.
   */
  prodigioPowers: { noPcCost: true, noLimits: true, allowNoEffects: true },

  /** Velocidade das rolagens (configuração do usuário). Duração da animação em ms. */
  rollSpeeds: { instant: 0, fast: 300, normal: 800 } as Record<"instant" | "fast" | "normal", number>,
  defaultRollSpeed: "fast" as "instant" | "fast" | "normal",
} as const;

export function applyRounding(value: number, mode: RoundingMode): number {
  switch (mode) {
    case "floor":
      return Math.floor(value);
    case "ceil":
      return Math.ceil(value);
    case "round":
      return Math.round(value);
    case "none":
      return value;
  }
}
