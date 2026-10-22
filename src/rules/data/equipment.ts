/** Capítulo "Armas" (Livro do Jogador, pp. 22–24). */

export type WeaponTag =
  | "corpo_a_corpo"
  | "distancia"
  | "laminas"
  | "perfurantes_projeteis"
  | "pesadas"
  | "contundentes"
  | "foices_correntes"
  | "arma_de_fogo";

export type DamageType = "cort" | "cont" | "perf" | "bal" | "var";
export type AttackKind = "melee" | "ranged" | "firearm";

export interface WeaponDef {
  id: string;
  name: string;
  tier: "simples" | "refinada";
  damage: string;
  damageType: DamageType;
  range: string;
  attackKind: AttackKind;
  /**
   * Categorias para compatibilidade com modificadores.
   * O LIVRO NÃO ATRIBUI CATEGORIAS ÀS ARMAS — estas foram inferidas pelo tipo de
   * dano e alcance e devem ser revisadas pelo autor (ver REGRAS-E-PENDENCIAS.md).
   */
  tags: WeaponTag[];
  note?: string;
}

export const DAMAGE_TYPE_LABEL: Record<DamageType, string> = {
  cort: "Cortante",
  cont: "Contundente",
  perf: "Perfurante",
  bal: "Balístico",
  var: "Variável",
};

export const WEAPONS: WeaponDef[] = [
  // Armas simples
  { id: "faca", name: "Faca", tier: "simples", damage: "1d4", damageType: "cort", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "laminas"] },
  { id: "taco_madeira", name: "Taco de madeira", tier: "simples", damage: "1d6", damageType: "cont", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "contundentes"] },
  { id: "foice_pequena", name: "Foice pequena", tier: "simples", damage: "1d6", damageType: "cort", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "laminas", "foices_correntes"] },
  { id: "corrente", name: "Corrente", tier: "simples", damage: "1d4", damageType: "var", range: "6 m / corpo", attackKind: "melee", tags: ["corpo_a_corpo", "foices_correntes"] },
  { id: "pa", name: "Pá", tier: "simples", damage: "1d8", damageType: "cont", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "contundentes"] },
  { id: "estilingue", name: "Estilingue", tier: "simples", damage: "1d6", damageType: "cont", range: "Médio (12 m)", attackKind: "ranged", tags: ["distancia", "perfurantes_projeteis"] },
  { id: "dardo", name: "Dardo", tier: "simples", damage: "1d4", damageType: "perf", range: "Médio (12 m)", attackKind: "ranged", tags: ["distancia", "perfurantes_projeteis"] },
  { id: "funda", name: "Funda", tier: "simples", damage: "1d6", damageType: "cont", range: "Longo (20 m)", attackKind: "ranged", tags: ["distancia", "perfurantes_projeteis"] },
  { id: "arco_amador", name: "Arco amador", tier: "simples", damage: "1d8", damageType: "perf", range: "Longo (20 m)", attackKind: "ranged", tags: ["distancia", "perfurantes_projeteis"] },
  // Armas refinadas
  { id: "espada_curta", name: "Espada curta", tier: "refinada", damage: "1d10", damageType: "cort", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "laminas"] },
  { id: "espada_grande", name: "Espada grande", tier: "refinada", damage: "2d8", damageType: "cort", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "laminas", "pesadas"] },
  { id: "foice_grande", name: "Foice grande", tier: "refinada", damage: "1d10+1d6", damageType: "cort", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "laminas", "foices_correntes", "pesadas"] },
  {
    id: "chicote",
    name: "Chicote",
    tier: "refinada",
    damage: "1d18",
    damageType: "cort",
    range: "12 m / corpo",
    attackKind: "melee",
    tags: ["corpo_a_corpo"],
    note: "O livro indica 1d18 (dado incomum — possivelmente 1d8 ou 1d10+1d8). Mantido como está até confirmação.",
  },
  { id: "taco_metal", name: "Taco de metal", tier: "refinada", damage: "2d6", damageType: "cont", range: "Corpo a corpo", attackKind: "melee", tags: ["corpo_a_corpo", "contundentes", "pesadas"] },
  { id: "balestra", name: "Balestra", tier: "refinada", damage: "1d12", damageType: "perf", range: "Longo (20 m)", attackKind: "ranged", tags: ["distancia", "perfurantes_projeteis"] },
  { id: "arco_esportivo", name: "Arco esportivo", tier: "refinada", damage: "1d10+1d6", damageType: "perf", range: "Longo (25 m)", attackKind: "ranged", tags: ["distancia", "perfurantes_projeteis"] },
  { id: "revolver", name: "Revólver", tier: "refinada", damage: "1d12+1d6", damageType: "bal", range: "Longo (25 m)", attackKind: "firearm", tags: ["arma_de_fogo", "distancia"] },
  { id: "fuzil_assalto", name: "Fuzil de assalto", tier: "refinada", damage: "2d10", damageType: "bal", range: "Longo (30 m)", attackKind: "firearm", tags: ["arma_de_fogo", "distancia"] },
  { id: "submetralhadora", name: "Submetralhadora", tier: "refinada", damage: "2d8", damageType: "bal", range: "Médio (15 m)", attackKind: "firearm", tags: ["arma_de_fogo", "distancia"] },
  { id: "espingarda", name: "Espingarda", tier: "refinada", damage: "2d12", damageType: "bal", range: "Médio (12 m)", attackKind: "firearm", tags: ["arma_de_fogo", "distancia"] },
  { id: "fuzil_precisao", name: "Fuzil de precisão", tier: "refinada", damage: "2d12", damageType: "bal", range: "Extremo (100 m)", attackKind: "firearm", tags: ["arma_de_fogo", "distancia"] },
];

export const WEAPON_BY_ID: Record<string, WeaponDef> = Object.fromEntries(WEAPONS.map((w) => [w.id, w]));

/** Efeito numérico aplicado na rolagem. `attackBonus` positivo ajuda (vira −N no d100). */
export interface RollEffect {
  attackBonus?: number;
  extraDamage?: string;
  /** Dados extras do MESMO tipo do dado principal da arma (pode ser negativo). */
  extraWeaponDice?: number;
  advantage?: number;
}

export interface SituationalOption extends RollEffect {
  id: string;
  label: string;
}

export interface WeaponModifierDef {
  id: string;
  name: string;
  /** Categoria exigida (como no livro). */
  requires: WeaponTag;
  classLabel: string;
  text: string;
  /** Sempre aplicado. */
  always?: RollEffect;
  /** Aplicado só em acerto crítico. */
  onCritical?: RollEffect;
  /** Situações que o jogador marca na hora do ataque. */
  options?: SituationalOption[];
  /** Condição/efeito descritivo exibido no item (o Mestre aplica). */
  condition?: string;
}

export const WEAPON_MODIFIERS: WeaponModifierDef[] = [
  { id: "afiada", name: "Afiada", requires: "laminas", classLabel: "Lâminas", text: "Ao acertar um ataque, você pode fazer um teste de Luta contra Constituição do alvo. Se vencer, causa 1d4 de Sangramento por 2 turnos. O efeito não acumula.", condition: "Sangramento: 1d4 por 2 turnos (teste de Luta × Constituição do alvo; não acumula)" },
  { id: "perfurante", name: "Perfurante", requires: "perfurantes_projeteis", classLabel: "Perfurantes/Projéteis", text: "Seus ataques ignoram a resistência/armadura do alvo.", condition: "Ignora resistência/armadura do alvo" },
  { id: "serrilhada", name: "Serrilhada", requires: "laminas", classLabel: "Lâminas", text: "Contra um alvo que já esteja Sangrando, causa +1d4 de dano.", options: [{ id: "sangrando", label: "Alvo já está sangrando (+1d4)", extraDamage: "1d4" }] },
  { id: "precisa", name: "Precisa", requires: "distancia", classLabel: "Distância", text: "Recebe +10 no teste de ataque ao realizar um disparo cuidadosamente mirado.", options: [{ id: "mirado", label: "Disparo cuidadosamente mirado (+10)", attackBonus: 10 }] },
  { id: "equilibrada", name: "Equilibrada", requires: "corpo_a_corpo", classLabel: "Corpo a corpo", text: "Recebe +5 em testes de ataque com esta arma.", always: { attackBonus: 5 } },
  { id: "pesada", name: "Pesada", requires: "pesadas", classLabel: "Pesadas", text: "Sofre −10 no ataque, mas causa +1d6 de dano.", always: { attackBonus: -10, extraDamage: "1d6" } },
  { id: "brutal", name: "Brutal", requires: "pesadas", classLabel: "Pesadas", text: "Em um acerto crítico, adiciona +1 dado de dano da arma.", onCritical: { extraWeaponDice: 1 } },
  { id: "concussiva", name: "Concussiva", requires: "contundentes", classLabel: "Contundentes", text: "Em um crítico, o alvo sofre −10 em seu próximo teste.", condition: "Em crítico: alvo sofre −10 no próximo teste" },
  { id: "gancho", name: "Gancho", requires: "foices_correntes", classLabel: "Foices/Correntes", text: "Após acertar, dispute Luta contra Luta. Se vencer, puxa o alvo em até 2 m.", condition: "Após acertar: Luta × Luta para puxar o alvo até 2 m" },
  { id: "executora", name: "Executora", requires: "corpo_a_corpo", classLabel: "Corpo a corpo", text: "Caso tenha acertado 3 ataques seguidos, causa +1d6 de dano no próximo ataque.", options: [{ id: "tres_acertos", label: "Acertou 3 ataques seguidos (+1d6)", extraDamage: "1d6" }] },
  // Armas de fogo
  { id: "rajada", name: "Rajada", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "Sofra −10 no ataque para causar +1 dado de dano.", options: [{ id: "rajada", label: "Disparar em rajada (−10, +1 dado)", attackBonus: -10, extraWeaponDice: 1 }] },
  { id: "automatica", name: "Automática", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "Permite distribuir os disparos entre até 2 alvos próximos, realizando um teste separado para cada um.", condition: "Pode dividir os disparos entre até 2 alvos próximos (um teste para cada)" },
  { id: "curto_alcance", name: "Curto Alcance", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "Recebe +10 no ataque contra alvos a até 6 m, mas −10 além do alcance médio.", options: [{ id: "ate6", label: "Alvo a até 6 m (+10)", attackBonus: 10 }, { id: "longe", label: "Alvo além do alcance médio (−10)", attackBonus: -10 }] },
  { id: "mira_precisao", name: "Mira de Precisão", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "Se passar um turno mirando sem atacar, recebe +20 no próximo disparo contra aquele alvo.", options: [{ id: "mirou", label: "Passou um turno mirando (+20)", attackBonus: 20 }] },
  { id: "recuo_pesado", name: "Recuo Pesado", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "Causa +1d6 de dano, mas exige um teste de Constituição para estabilizar a arma; se falhar, −20 de desvantagem no próximo tiro.", always: { extraDamage: "1d6" }, options: [{ id: "instavel", label: "Falhou em estabilizar no tiro anterior (−20)", attackBonus: -20 }], condition: "Após atirar: teste de Constituição; se falhar, −20 no próximo tiro" },
  { id: "dispersao", name: "Dispersão", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "A até 4 m, causa +1 dado de dano; além de 8 m, causa −1 dado de dano.", options: [{ id: "perto", label: "Alvo a até 4 m (+1 dado)", extraWeaponDice: 1 }, { id: "longe", label: "Alvo além de 8 m (−1 dado)", extraWeaponDice: -1 }] },
  { id: "penetrante", name: "Penetrante", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "Metade do dano vai para a pessoa que está atrás do alvo.", condition: "Metade do dano atinge quem estiver atrás do alvo" },
  { id: "confiavel", name: "Confiável", requires: "arma_de_fogo", classLabel: "Arma de fogo", text: "Uma vez por cena, pode rerrolar um teste de ataque feito com esta arma.", condition: "1×/cena: pode rerrolar um teste de ataque" },
];

export const WEAPON_MODIFIER_BY_ID: Record<string, WeaponModifierDef> = Object.fromEntries(WEAPON_MODIFIERS.map((m) => [m.id, m]));

export const WEAPON_TAG_LABEL: Record<WeaponTag, string> = {
  corpo_a_corpo: "Corpo a corpo",
  distancia: "Distância",
  laminas: "Lâminas",
  perfurantes_projeteis: "Perfurantes/Projéteis",
  pesadas: "Pesadas",
  contundentes: "Contundentes",
  foices_correntes: "Foices/Correntes",
  arma_de_fogo: "Arma de fogo",
};

/** Equipamentos citados no Livro do Jogador (equipamento inicial das classes). Sem números inventados. */
export interface GearDef {
  id: string;
  name: string;
  type: "armadura" | "equipamento" | "consumivel";
  description: string;
  effect: string;
}

export const GEAR: GearDef[] = [
  { id: "armadura_simples", name: "Armadura simples", type: "armadura", description: "Equipamento inicial do Brawler.", effect: "Redução de 5 de dano físico" },
  { id: "armadura_7", name: "Armadura (+7 de defesa)", type: "armadura", description: "Equipamento inicial do Tank.", effect: "+7 de defesa" },
  { id: "armadura_2", name: "Armadura (+2 de defesa)", type: "armadura", description: "Equipamento inicial do Líder.", effect: "+2 de defesa" },
  { id: "granada", name: "Granada", type: "consumivel", description: "Equipamento inicial do Demolidor (cinco, à escolha do jogador). O Demolidor monta uma com teste de INT bem-sucedido (limite de 5).", effect: "Tipo e dano à escolha do jogador/Mestre — o livro não fixa valores" },
  { id: "kit_medicina", name: "Kit de medicina", type: "equipamento", description: "Equipamento inicial do Healer.", effect: "Permite reviver uma pessoa por sessão" },
  { id: "talisma_energia", name: "Talismã de energia", type: "equipamento", description: "Equipamento inicial do Esotérico.", effect: "Permite usar uma habilidade sem custo de PC por luta" },
  { id: "roupa_furtividade", name: "Roupa de furtividade", type: "equipamento", description: "Equipamento inicial do Rato.", effect: "Dobra o dano contra qualquer alvo enquanto estiver furtivo" },
  { id: "mira", name: "Mira", type: "equipamento", description: "Equipamento inicial do Atirador, acoplada à arma de fogo.", effect: "Ao gastar a ação para mirar, ganha 2 vantagens" },
  { id: "item_pericia", name: "Item de perícia", type: "equipamento", description: "Equipamento inicial do Detalhista. Escolha uma perícia (nenhuma da seção Lutar).", effect: "Vantagem nos testes da perícia escolhida" },
];

export interface TechniqueDef {
  id: string;
  name: string;
  text: string;
  requirements?: string;
}

/** Técnicas (Livro do Jogador, p. 25). "Recobrar-se" aparece duplicada no livro — mantida uma vez. */
export const TECHNIQUES: TechniqueDef[] = [
  { id: "arte_desarme", name: "Arte do Desarme", text: "Uma vez por cena, desfere um golpe de desarme: além de causar 1 dado extra de dano, o alvo precisa rolar um teste contra você para não ficar desarmado." },
  { id: "arte_contra_ataque", name: "Arte do Contra-ataque", text: "Uma vez por cena, garante 100% de chance de acertar um contra-ataque. Quem sofre o golpe não pode fazer nada para impedi-lo." },
  { id: "provocacao", name: "Provocação", text: "Uma vez por cena, provoca um inimigo para que ele ataque você. Todos os ataques dele contra você têm −10 de desvantagem." },
  { id: "multiplos_alvos", name: "Múltiplos Alvos", text: "Uma vez por cena, ataca todos os alvos adjacentes a você — aliados incluídos." },
  { id: "multiplos_golpes", name: "Múltiplos Golpes", text: "Uma vez a cada 2 turnos, ataca duas vezes o mesmo alvo, que pode reagir aos dois golpes." },
  { id: "adrenalina", name: "Adrenalina", text: "Ação de movimento: todas as suas habilidades por cena são recarregadas." },
  { id: "metavisao", name: "Metavisão", text: "Tudo fica lento e você enxerga cada passo dos inimigos. Uma vez por cena, ganha vantagem em todas as esquivas até o fim da rodada." },
  { id: "recobrar_se", name: "Recobrar-se", text: "Uma vez por sessão, caso o ataque não te mate, você pode curar metade do dano recebido por ele; caso o ataque o mate, você pode voltar com 1 de vida." },
  { id: "passos_leves", name: "Passos Leves", text: "Passiva que permite que você se mova livremente sem tomar ataques de oportunidade e aumenta o deslocamento para 12 m." },
  { id: "ataque_furtivo", name: "Ataque Furtivo", text: "Enquanto estiver furtivo, seu ataque dá +1d8 de dano; esse dano extra ignora escudos e armaduras comuns." },
  { id: "furtividade_rapida", name: "Furtividade Rápida", text: "Uma vez por cena você pode ficar instantaneamente furtivo e ninguém pode naturalmente saber onde você está.", requirements: "DEX 70+ e técnica Passos Leves" },
];

export function compatibleModifiers(tags: WeaponTag[]): WeaponModifierDef[] {
  return WEAPON_MODIFIERS.filter((m) => tags.includes(m.requires));
}
