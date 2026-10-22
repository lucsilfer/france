import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import type { ClassDef } from "@/rules/data/classes.ts";

const ATTR_NAME = Object.fromEntries(ATTRIBUTES.map((a) => [a.id, a.name])) as Record<string, string>;

/** Bloco com todos os dados de uma classe (usado na criação e na ficha). */
export function ClassDetails({ cls }: { cls: ClassDef }) {
  const attrBonus = Object.entries(cls.attributeBonus);
  const skillBonus = Object.entries(cls.skillBonus);
  return (
    <div className="space-y-4 text-sm">
      <p className="leading-relaxed text-fg-dim">{cls.description}</p>
      <div>
        <p className="label-mono text-holo">Benefício</p>
        <p className="mt-1 text-fg">
          <strong className="font-semibold">{cls.benefit.name}:</strong> <span className="text-fg-dim">{cls.benefit.text}</span>
        </p>
      </div>
      <div>
        <p className="label-mono text-holo">Equipamento inicial</p>
        <ul className="mt-1 list-inside list-disc space-y-0.5 text-fg-dim marker:text-primary-deep">
          {cls.startingEquipment.map((e) => (
            <li key={e}>{e}</li>
          ))}
        </ul>
      </div>
      <dl className="grid grid-cols-2 gap-3 rounded-sm border border-line bg-void/40 p-3">
        <div>
          <dt className="label-mono">Bônus automáticos</dt>
          <dd className="mt-1 space-y-0.5 text-fg">
            {attrBonus.length === 0 && skillBonus.length === 0 && cls.pvBonusAtLevel1 === 0 && cls.skillPointsBonus === 0 && <span className="text-fg-muted">—</span>}
            {attrBonus.map(([k, v]) => (
              <span key={k} className="block">
                +{v} {ATTR_NAME[k]} ({k})
              </span>
            ))}
            {skillBonus.map(([k, v]) => (
              <span key={k} className="block">
                +{v} {SKILL_BY_ID[k]?.name}
              </span>
            ))}
            {cls.pvBonusAtLevel1 > 0 && <span className="block">+{cls.pvBonusAtLevel1} PV no nível 1</span>}
            {cls.skillPointsBonus > 0 && (
              <span className="block">
                +{cls.skillPointsBonus} pontos de perícia{cls.maxPerSkillOverride ? `, total máx. ${cls.maxPerSkillOverride} por perícia` : ""}
              </span>
            )}
          </dd>
        </div>
        <div>
          <dt className="label-mono">Evolução por nível</dt>
          <dd className="mt-1 font-mono text-fg">
            {cls.progression.pv} PV · {cls.progression.pc} PC
          </dd>
        </div>
      </dl>
      {cls.situational.length > 0 && (
        <div>
          <p className="label-mono">Regras especiais (aplicadas conforme a situação)</p>
          <ul className="mt-1 list-inside list-disc space-y-0.5 text-fg-dim marker:text-primary-deep">
            {cls.situational.map((s) => (
              <li key={s}>{s}</li>
            ))}
          </ul>
        </div>
      )}
    </div>
  );
}
