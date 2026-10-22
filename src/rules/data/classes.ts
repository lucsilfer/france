import type { AttributeId } from "./attributes.ts";

/** Capítulo IV — Classes (Livro do Jogador, pp. 15–17). */
export interface ClassDef {
  id: string;
  name: string;
  description: string;
  benefit: { name: string; text: string };
  startingEquipment: string[];
  /** Bônus automáticos e reversíveis. */
  attributeBonus: Partial<Record<AttributeId, number>>;
  skillBonus: Record<string, number>;
  /** Perícias concedidas "de graça" (não contam entre as 4 escolhidas). */
  freeSkills: string[];
  skillPointsBonus: number;
  maxPerSkillOverride: number | null;
  pvBonusAtLevel1: number;
  progression: { pv: string; pc: string };
  /** Efeitos situacionais (não alteram números da ficha automaticamente). */
  situational: string[];
}

export const CLASSES: ClassDef[] = [
  {
    id: "brawler",
    name: "Brawler",
    description:
      "A personificação da fúria direta, da força bruta e da resistência teimosa. Num mundo em que lendas manipulam mentes e distorcem a realidade, o Brawler responde com o que há de mais instintivo: porrada.",
    benefit: { name: "Porrada forte", text: "+4 de força e +1d4 de dano com armas físicas (não acumula com a habilidade do Prodígio)." },
    startingEquipment: ["Uma arma corpo a corpo refinada", "Uma arma simples", "Uma armadura simples com redução de 5 de dano físico"],
    attributeBonus: { FOR: 4 },
    skillBonus: {},
    freeSkills: [],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d10", pc: "1d6" },
    situational: ["+1d4 de dano com armas físicas (não acumula com Combatente de Guerra do Prodígio)"],
  },
  {
    id: "demolidor",
    name: "Demolidor",
    description:
      "O caos encarnado: especialista em destruição, ruído e impacto. Enquanto outros enfrentam lendas com precisão ou músculo, o Demolidor responde com fogo, pólvora e explosões calculadas.",
    benefit: { name: "Proficiente em explosivos", text: "+4 de destreza e vantagem em testes de luta com arremesso." },
    startingEquipment: [
      "Cinco granadas à escolha do jogador",
      "Uma arma de longa distância que não seja de fogo (exceto para Prodígios)",
      "Sabe montar granadas: com um teste de inteligência bem-sucedido, monta uma — limite de 5",
    ],
    attributeBonus: { DEX: 4 },
    skillBonus: {},
    freeSkills: [],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d10", pc: "1d6" },
    situational: ["Vantagem em testes de luta com arremesso", "Montar granadas (teste de INT, limite 5)"],
  },
  {
    id: "detalhista",
    name: "Detalhista",
    description:
      "Não é o mais forte nem o mais rápido — é o mais perigoso. Enquanto todos olham para o óbvio, ele vê o que os outros ignoram.",
    benefit: { name: "Perspicaz", text: "+4 de percepção, limite de pontos por perícia elevado a 95 e mais 50 pontos no total." },
    startingEquipment: [
      "Uma arma refinada que não seja de fogo",
      "Um item de perícia, que concede vantagem no teste da perícia escolhida (nenhuma da seção luta)",
    ],
    attributeBonus: { PER: 4 },
    skillBonus: {},
    freeSkills: [],
    skillPointsBonus: 50,
    maxPerSkillOverride: 95,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d8", pc: "1d8" },
    situational: [],
  },
  {
    id: "esoterico",
    name: "Esotérico",
    description:
      "Estudioso dedicado às lendas, aos mitos e ao que não deveria existir. Ao contrário de quem encara o oculto com força ou instinto, o Esotérico quer entender antes de agir.",
    benefit: { name: "Ligação oculta", text: "+4 de misticismo e +1d6 de dano em todas as armas e poderes quando o alvo é uma lenda." },
    startingEquipment: [
      "Uma arma refinada que não seja de fogo",
      "Um talismã de energia que possibilita o uso de uma habilidade sem custo de PC por luta",
    ],
    attributeBonus: { MIT: 4 },
    skillBonus: {},
    freeSkills: [],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d6", pc: "1d12" },
    situational: ["+1d6 de dano em armas e poderes contra lendas", "Talismã: 1 habilidade sem custo de PC por luta"],
  },
  {
    id: "atirador",
    name: "Atirador",
    description:
      "Domina o combate à distância com precisão, paciência e posicionamento. Observa o campo, escolhe alvos estratégicos e age no momento exato — muitas vezes decidindo o confronto antes da reação do inimigo.",
    benefit: { name: "Certeiro", text: "Recebe a perícia de armas de fogo e mais 25 pontos nela." },
    startingEquipment: ["Uma arma de fogo", "Uma mira para ela: ao gastar a ação para mirar, ganha 2 vantagens"],
    attributeBonus: {},
    skillBonus: { arma_de_fogo: 25 },
    freeSkills: ["arma_de_fogo"],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d8", pc: "1d8" },
    situational: ["Mira: ao gastar a ação para mirar, ganha 2 vantagens"],
  },
  {
    id: "rato",
    name: "Rato",
    description:
      "Sobrevive onde ninguém mais consegue. Especialista em furtividade, roubo e movimentação rápida, evita o confronto direto e prefere vencer antes de a luta começar. Informação, oportunidade e fuga valem tanto quanto qualquer arma.",
    benefit: { name: "Esgueirar-se", text: "Recebe a perícia de furtividade de graça e mais 25 pontos nela." },
    startingEquipment: ["Uma arma leve", "Uma roupa de furtividade que dobra o dano contra qualquer alvo enquanto estiver furtivo"],
    attributeBonus: {},
    skillBonus: { furtividade: 25 },
    freeSkills: ["furtividade"],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d8", pc: "1d8" },
    situational: ["Roupa de furtividade: dano dobrado enquanto furtivo"],
  },
  {
    id: "healer",
    name: "Healer",
    description:
      "Especialista em manter seus aliados vivos quando tudo dá errado. Enquanto outros focam em causar danos ou enfrentar o perigo diretamente, o Healer usa suas habilidades para curar e proteger seus aliados.",
    benefit: { name: "Heróis não morrem", text: "−15 em dados para levantar alguém e +1d6 de cura nas habilidades de cura." },
    startingEquipment: ["Uma arma simples", "Um kit de medicina que permite reviver uma pessoa por sessão"],
    attributeBonus: {},
    skillBonus: {},
    freeSkills: [],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d6", pc: "1d10" },
    situational: ["−15 no dado para levantar alguém", "+1d6 de cura em habilidades de cura"],
  },
  {
    id: "tank",
    name: "Tank",
    description:
      "Especialista em resistir ao que derrubaria qualquer outro. Enquanto seus aliados evitam os golpes, o Tank enfrenta o perigo de frente, protegendo o grupo e permanecendo de pé mesmo nas piores situações.",
    benefit: { name: "Muro", text: "+20 de vida no nível 1 e vantagem em teste de constituição." },
    startingEquipment: ["Uma arma refinada que não seja de fogo", "Uma armadura de +7 de defesa"],
    attributeBonus: {},
    skillBonus: {},
    freeSkills: [],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 20,
    progression: { pv: "1d12", pc: "1d6" },
    situational: ["Vantagem em testes de constituição"],
  },
  {
    id: "lider",
    name: "Líder",
    description:
      "Especialista em coordenar seus aliados e manter o controle da situação. Enquanto outros confiam apenas em suas próprias capacidades, o Líder guia o grupo, cria oportunidades e faz com que todos lutem melhor juntos.",
    benefit: { name: "Motivação", text: "Uma vez por cena você pode dar um buff de −15 no dado de todos os jogadores." },
    startingEquipment: ["Uma arma refinada que não seja de fogo", "Uma armadura de +2 de defesa"],
    attributeBonus: {},
    skillBonus: {},
    freeSkills: [],
    skillPointsBonus: 0,
    maxPerSkillOverride: null,
    pvBonusAtLevel1: 0,
    progression: { pv: "1d8", pc: "1d8" },
    situational: ["1×/cena: −15 no dado de todos os jogadores"],
  },
];

export const CLASS_BY_ID: Record<string, ClassDef> = Object.fromEntries(CLASSES.map((c) => [c.id, c]));
