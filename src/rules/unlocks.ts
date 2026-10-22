/**
 * Desbloqueios por nível de origem/caminho, calculados a partir do texto do livro.
 * Onde o livro é vago, a interpretação está escrita em `basis` e em REGRAS-E-PENDENCIAS.md.
 */
import { prodigioExtraWeaponDice } from "./data/origins.ts";

export interface Unlock {
  label: string;
  value: string;
  basis: string;
}

const evenLevels = (level: number) => Math.floor(level / 2);
/** Níveis ímpares alcançados (1, 3, 5…). */
const oddLevels = (level: number) => Math.ceil(level / 2);

export function levelUnlocks(originId: string | null, pathId: string | null, level: number): Unlock[] {
  const out: Unlock[] = [];
  switch (originId) {
    case "prodigio":
      out.push({ label: "Combatente de Guerra", value: `+${prodigioExtraWeaponDice(level)} dado(s) de dano com armas`, basis: "+1 no nível 1 e +1 a cada 5 níveis" });
      if (pathId === "arsenal") out.push({ label: "Técnicas Avançadas", value: `${evenLevels(level)} técnica(s) aprendida(s)`, basis: "1 a cada nível par" });
      if (pathId === "engrenagem") out.push({ label: "Tecnologia Perfeita", value: `${evenLevels(level)} habilidade(s) do instrumento`, basis: "1 a cada nível par" });
      if (pathId === "pacto") out.push({ label: "Xamã", value: `${1 + Math.floor((oddLevels(level) - 1) / 2)} uso(s) duplo(s) por turno`, basis: "1 por turno, +1 a cada dois níveis ímpares após o 1º (interpretação)" });
      break;
    case "receptaculo":
      out.push({ label: "Pacto de Força", value: `${evenLevels(level)} habilidade(s) criada(s) além do poder inicial`, basis: "1 a cada nível par" });
      break;
    case "muto":
      out.push({ label: "Mutação Adaptativa", value: `até ${2 * evenLevels(level)} parte(s) roubada(s)`, basis: "2 partes por nível par" });
      out.push({ label: "Evolução de Partes", value: `${Math.floor(level / 5)} evolução(ões) de até 4 partes`, basis: "a cada 5 níveis" });
      break;
    case "remanescente": {
      out.push({ label: "Legado — habilidades", value: `${evenLevels(level)} habilidade(s) criada(s)`, basis: "1 a cada nível par" });
      out.push({ label: "Legado — buffs", value: `+${Math.floor((oddLevels(level) - 1) / 2)} dado/turno em todas as habilidades`, basis: "+1 a cada dois níveis ímpares após o 1º (interpretação)" });
      out.push({ label: "Meu ou Dele", value: level >= 7 ? "3 habilidades com 2 buffs extras" : "libera no nível 7", basis: "nível 7" });
      break;
    }
    case "amaldicoado":
      out.push({ label: "A Dívida a Pagar", value: "custo de PC pela metade; +1d6 de dano a cada 2 dados", basis: "aplicado automaticamente no criador de poderes" });
      break;
  }
  return out;
}
