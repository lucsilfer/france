"use client";

import { useMemo } from "react";
import { DAMAGE_TYPE_LABEL, WEAPON_MODIFIERS, WEAPON_TAG_LABEL, type WeaponTag } from "@/rules/data/equipment.ts";
import { SKILLS } from "@/rules/data/skills.ts";
import { RULES_CONFIG } from "@/rules/config.ts";
import { isValidDice } from "@/rules/dice.ts";
import { customModifierCompatible, modifierSlotsUsed, weaponPreview } from "@/rules/combat.ts";
import { CONDITION_SUGGESTIONS } from "@/components/campaign/ConditionChips";
import { ITEM_KINDS, WEAPON_TAGS, defaultData, toCustomModifier, weaponFromData, type ItemFormValue, type ModifierFormValue, type OtherFormValue, type WeaponFormValue } from "@/lib/homebrew";
import type { HomebrewEntry } from "@/lib/types";
import { L, NumInput, Section } from "./kit";

// ===================================================================== Arma

export function WeaponFields({ value: v, onChange, name, library = [] }: { value: WeaponFormValue; onChange: (v: WeaponFormValue) => void; name: string; library?: HomebrewEntry[] }) {
  const set = (p: Partial<WeaponFormValue>) => onChange({ ...v, ...p });
  const customs = library.filter((e) => e.kind === "modificador");
  const valid = isValidDice(v.effect_dice);
  const preview = useMemo(() => (valid ? weaponPreview(weaponFromData(name || "Arma", v)) : null), [v, name, valid]);
  const used = modifierSlotsUsed(v.modifiers.length, v.custom_modifiers.map((m) => ({ ignoreLimit: m.data.ignore_limit })));
  const full = used >= RULES_CONFIG.maxWeaponModifiers;

  return (
    <div className="space-y-3">
      <Section title="Dados da arma" defaultOpen>
        <div className="grid gap-3 sm:grid-cols-3">
          <L label="Dado de dano">
            <input className="field-input font-mono" maxLength={60} value={v.effect_dice} aria-invalid={v.effect_dice !== "" && !valid ? true : undefined} onChange={(e) => set({ effect_dice: e.target.value })} placeholder="1d8+2" />
          </L>
          <L label="Tipo de dano">
            <select className="field-input" value={v.damage_type ?? ""} onChange={(e) => set({ damage_type: (e.target.value || null) as WeaponFormValue["damage_type"] })}>
              <option value="">—</option>
              {Object.entries(DAMAGE_TYPE_LABEL).map(([k, l]) => (
                <option key={k} value={k}>
                  {l}
                </option>
              ))}
            </select>
          </L>
          <L label="Alcance">
            <input className="field-input" maxLength={60} value={v.range} onChange={(e) => set({ range: e.target.value })} placeholder="Corpo a corpo, 30 m…" />
          </L>
          <L label="Tipo de ataque">
            <select className="field-input" value={v.attack_kind} onChange={(e) => set({ attack_kind: e.target.value as WeaponFormValue["attack_kind"] })}>
              <option value="melee">Corpo a corpo (Luta)</option>
              <option value="ranged">Distância (Pontaria)</option>
              <option value="firearm">Arma de fogo</option>
            </select>
          </L>
          <L label="Perícia utilizada">
            <select className="field-input" value={v.skill_override ?? ""} onChange={(e) => set({ skill_override: e.target.value || null })}>
              <option value="">Padrão do tipo de ataque</option>
              {SKILLS.map((s) => (
                <option key={s.id} value={s.id}>
                  {s.name}
                </option>
              ))}
            </select>
          </L>
          <L label="Categoria">
            <input className="field-input" maxLength={60} value={v.category} onChange={(e) => set({ category: e.target.value })} placeholder="Refinada, artefato…" />
          </L>
        </div>
        <fieldset>
          <legend className="label-mono mb-1">Categorias (compatibilidade com modificadores)</legend>
          <div className="flex flex-wrap gap-3 text-sm text-fg-dim">
            {WEAPON_TAGS.map((t) => (
              <label key={t} className="flex items-center gap-1.5">
                <input
                  type="checkbox"
                  className="accent-[var(--color-holo)]"
                  checked={v.tags.includes(t)}
                  onChange={(e) => {
                    const tags = e.target.checked ? [...v.tags, t] : v.tags.filter((x) => x !== t);
                    // Modificadores que deixam de ser compatíveis saem junto.
                    set({
                      tags,
                      modifiers: v.modifiers.filter((m) => tags.includes(WEAPON_MODIFIERS.find((w) => w.id === m)!.requires)),
                      custom_modifiers: v.custom_modifiers.filter((m) => customModifierCompatible({ requires: m.data.requires as WeaponTag | "qualquer" }, tags)),
                    });
                  }}
                />
                {WEAPON_TAG_LABEL[t]}
              </label>
            ))}
          </div>
        </fieldset>
        <L label="Efeitos especiais">
          <textarea className="field-input" rows={3} value={v.special_rules} onChange={(e) => set({ special_rules: e.target.value })} />
        </L>
      </Section>

      <Section title="Modificadores" hint={`Até ${RULES_CONFIG.maxWeaponModifiers} por arma (modificadores com regra especial podem não ocupar vaga). Só aparecem os compatíveis com as categorias marcadas.`} badge={`${used}/${RULES_CONFIG.maxWeaponModifiers}`} defaultOpen>
        <div className="grid gap-2 sm:grid-cols-2">
          {WEAPON_MODIFIERS.filter((m) => v.tags.includes(m.requires)).map((m) => {
            const on = v.modifiers.includes(m.id);
            return (
              <label key={m.id} className={`flex items-start gap-2 border p-2 text-sm ${on ? "border-cyan/60 bg-cyan/5" : "border-line/60"}`}>
                <input
                  type="checkbox"
                  className="mt-1 accent-[var(--color-holo)]"
                  checked={on}
                  disabled={!on && full}
                  onChange={(e) => set({ modifiers: e.target.checked ? [...v.modifiers, m.id] : v.modifiers.filter((x) => x !== m.id) })}
                />
                <span>
                  <span className="text-fg">{m.name}</span> <span className="font-mono text-[0.58rem] text-fg-muted uppercase">oficial · {m.classLabel}</span>
                  <span className="block text-xs text-fg-dim">{m.text}</span>
                </span>
              </label>
            );
          })}
          {customs.map((c) => {
            const d = defaultData("modificador", c.data) as unknown as ModifierFormValue;
            const compatible = customModifierCompatible({ requires: d.requires as WeaponTag | "qualquer" }, v.tags);
            const on = v.custom_modifiers.some((m) => m.source_id === c.id);
            if (!compatible && !on) return null;
            return (
              <label key={c.id} className={`flex items-start gap-2 border p-2 text-sm ${on ? "border-holo/70 bg-holo/5" : "border-line/60"}`}>
                <input
                  type="checkbox"
                  className="mt-1 accent-[var(--color-holo)]"
                  checked={on}
                  disabled={!on && full && !d.ignore_limit}
                  onChange={(e) =>
                    set({
                      custom_modifiers: e.target.checked ? [...v.custom_modifiers, { source_id: c.id, name: c.name, text: c.description, data: d }] : v.custom_modifiers.filter((m) => m.source_id !== c.id),
                    })
                  }
                />
                <span>
                  <span className="text-fg">{c.name}</span> <span className="font-mono text-[0.58rem] text-holo uppercase">homebrew{d.ignore_limit ? " · não ocupa vaga" : ""}</span>
                  <span className="block text-xs text-fg-dim">{c.description || toCustomModifier(c.id, c.name, d).condition}</span>
                </span>
              </label>
            );
          })}
        </div>
        {v.tags.length === 0 && <p className="text-xs text-alert">Marque ao menos uma categoria para ver os modificadores compatíveis.</p>}
        {preview && (
          <div className="border border-cyan/40 bg-cyan/5 p-3 text-sm">
            <p className="label-mono mb-1 text-cyan">Efeito calculado (sem bônus de classe/origem)</p>
            <p className="text-fg">
              Dano <span className="font-mono">{preview.damage}</span> · crítico <span className="font-mono">{preview.critical}</span>
              {preview.attackBonus !== 0 && (
                <>
                  {" "}
                  · {preview.attackBonus > 0 ? "+" : ""}
                  {preview.attackBonus} no ataque
                </>
              )}
            </p>
            {preview.conditions.length > 0 && (
              <ul className="mt-1 list-disc pl-5 text-xs text-fg-dim">
                {preview.conditions.map((c) => (
                  <li key={c}>{c}</li>
                ))}
              </ul>
            )}
          </div>
        )}
      </Section>
    </div>
  );
}

// ===================================================================== Equipamento / item especial

export function ItemFields({ value: v, onChange }: { value: ItemFormValue; onChange: (v: ItemFormValue) => void }) {
  const set = (p: Partial<ItemFormValue>) => onChange({ ...v, ...p });
  const valid = v.effect_dice === "" || isValidDice(v.effect_dice);
  return (
    <div className="space-y-3">
      <Section title="Tipo e quantidade" defaultOpen>
        <div className="grid gap-3 sm:grid-cols-3">
          <L label="Tipo">
            <select
              className="field-input"
              value={v.item_type}
              onChange={(e) => {
                const t = e.target.value as ItemFormValue["item_type"];
                set({ item_type: t, effect_kind: t === "cura" ? "cura" : v.effect_kind });
              }}
            >
              {ITEM_KINDS.map((k) => (
                <option key={k.id} value={k.id}>
                  {k.label}
                </option>
              ))}
            </select>
          </L>
          <L label="Quantidade">
            <NumInput value={v.quantity} onChange={(n) => set({ quantity: n ?? 1 })} max={9999} />
          </L>
          <L label="Usos disponíveis">
            <NumInput value={v.uses_max} onChange={(n) => set({ uses_max: n && n > 0 ? n : null })} min={1} max={9999} placeholder="ilimitado" />
          </L>
          <L label="Categoria">
            <input className="field-input" maxLength={60} value={v.category} onChange={(e) => set({ category: e.target.value })} />
          </L>
          <L label="Alcance">
            <input className="field-input" maxLength={60} value={v.range} onChange={(e) => set({ range: e.target.value })} />
          </L>
        </div>
        <p className="text-xs text-fg-muted">Ao usar na ficha: consumíveis perdem 1 unidade; itens com usos perdem 1 uso; itens de cura rolam e curam a forma ativa.</p>
      </Section>
      <Section title="Efeito" defaultOpen>
        <div className="grid gap-3 sm:grid-cols-2">
          <L label="Tipo de efeito">
            <select className="field-input" value={v.effect_kind ?? ""} onChange={(e) => set({ effect_kind: (e.target.value || null) as ItemFormValue["effect_kind"] })}>
              <option value="">Nenhum</option>
              <option value="cura">Cura</option>
              <option value="dano">Dano</option>
              <option value="condicao">Condição</option>
              <option value="utilidade">Utilidade</option>
              <option value="personalizado">Personalizado</option>
            </select>
          </L>
          <L label="Expressão de dados">
            <input className="field-input font-mono" maxLength={60} value={v.effect_dice} aria-invalid={!valid ? true : undefined} onChange={(e) => set({ effect_dice: e.target.value })} placeholder="2d6+2" />
          </L>
        </div>
        <L label="Efeito e condições especiais">
          <textarea className="field-input" rows={3} value={v.special_rules} onChange={(e) => set({ special_rules: e.target.value })} />
        </L>
      </Section>
      <Section title="Habilidade concedida (objeto místico)" badge={v.ability?.name ? 1 : undefined}>
        <L label="Nome da habilidade">
          <input className="field-input" maxLength={120} value={v.ability?.name ?? ""} onChange={(e) => set({ ability: e.target.value || v.ability?.description ? { name: e.target.value, description: v.ability?.description ?? "" } : null })} />
        </L>
        <L label="O que ela faz">
          <textarea className="field-input" rows={3} value={v.ability?.description ?? ""} onChange={(e) => set({ ability: { name: v.ability?.name ?? "", description: e.target.value } })} />
        </L>
        <p className="text-xs text-fg-muted">Aparece no item da ficha. Efeitos que o motor não automatiza são aplicados pelo Mestre.</p>
      </Section>
      <datalist id="hb-conditions">
        {CONDITION_SUGGESTIONS.map((c) => (
          <option key={c} value={c} />
        ))}
      </datalist>
    </div>
  );
}

// ===================================================================== Modificador

export function ModifierFields({ value: v, onChange }: { value: ModifierFormValue; onChange: (v: ModifierFormValue) => void }) {
  const set = (p: Partial<ModifierFormValue>) => onChange({ ...v, ...p });
  return (
    <div className="space-y-3">
      <Section title="Compatibilidade" defaultOpen>
        <L label="Categoria compatível">
          <select className="field-input" value={v.requires} onChange={(e) => set({ requires: e.target.value })}>
            <option value="qualquer">Qualquer arma</option>
            {WEAPON_TAGS.map((t) => (
              <option key={t} value={t}>
                {WEAPON_TAG_LABEL[t]}
              </option>
            ))}
          </select>
        </L>
        <L label="Requisitos">
          <textarea className="field-input" rows={2} value={v.requirements} onChange={(e) => set({ requirements: e.target.value })} placeholder="Ex.: só armas refinadas, exige oficina…" />
        </L>
        <label className="flex items-center gap-2 text-sm text-fg-dim">
          <input type="checkbox" className="accent-[var(--color-holo)]" checked={v.ignore_limit} onChange={(e) => set({ ignore_limit: e.target.checked })} />
          Regra especial: não ocupa vaga do limite de {RULES_CONFIG.maxWeaponModifiers} modificadores
        </label>
      </Section>
      <Section title="Bônus e penalidades (automáticos)" defaultOpen hint="Valores negativos são penalidades. Entram no cálculo do ataque sempre que a arma for usada.">
        <div className="grid gap-3 sm:grid-cols-3">
          <L label="Ajuste no ataque">
            <NumInput value={v.attack_bonus} onChange={(n) => set({ attack_bonus: n ?? 0 })} min={-100} max={100} allowNegative />
          </L>
          <L label="Dano adicional">
            <input className="field-input font-mono" maxLength={60} value={v.extra_damage} aria-invalid={v.extra_damage && !isValidDice(v.extra_damage) ? true : undefined} onChange={(e) => set({ extra_damage: e.target.value })} placeholder="1d6" />
          </L>
          <L label="Dados da arma (±)">
            <NumInput value={v.extra_weapon_dice} onChange={(n) => set({ extra_weapon_dice: n ?? 0 })} min={-5} max={5} allowNegative />
          </L>
          <L label="Crítico: dano adicional">
            <input className="field-input font-mono" maxLength={60} value={v.crit_extra_damage} aria-invalid={v.crit_extra_damage && !isValidDice(v.crit_extra_damage) ? true : undefined} onChange={(e) => set({ crit_extra_damage: e.target.value })} />
          </L>
          <L label="Crítico: dados da arma">
            <NumInput value={v.crit_extra_weapon_dice} onChange={(n) => set({ crit_extra_weapon_dice: n ?? 0 })} max={5} />
          </L>
        </div>
      </Section>
      <Section title="Condições e penalidades descritas">
        <L label="Condição / efeito (o Mestre aplica)">
          <input className="field-input" list="hb-conditions" maxLength={500} value={v.condition} onChange={(e) => set({ condition: e.target.value })} placeholder="Ex.: em crítico, alvo fica Atordoado por 1 turno" />
        </L>
        <L label="Penalidades">
          <textarea className="field-input" rows={2} value={v.penalties} onChange={(e) => set({ penalties: e.target.value })} />
        </L>
        <datalist id="hb-conditions">
          {CONDITION_SUGGESTIONS.map((c) => (
            <option key={c} value={c} />
          ))}
        </datalist>
      </Section>
    </div>
  );
}

// ===================================================================== Outro

export function OtherFields({ value: v, onChange }: { value: OtherFormValue; onChange: (v: OtherFormValue) => void }) {
  const set = (p: Partial<OtherFormValue>) => onChange({ ...v, ...p });
  return (
    <Section title="Conteúdo" defaultOpen>
      <div className="grid gap-3 sm:grid-cols-2">
        <L label="Categoria">
          <input className="field-input" maxLength={60} value={v.category} onChange={(e) => set({ category: e.target.value })} placeholder="Local, facção, regra da mesa…" />
        </L>
        <L label="Expressão de dados (opcional)">
          <input className="field-input font-mono" maxLength={60} value={v.effect_dice} aria-invalid={v.effect_dice && !isValidDice(v.effect_dice) ? true : undefined} onChange={(e) => set({ effect_dice: e.target.value })} />
        </L>
      </div>
      <L label="Texto">
        <textarea className="field-input" rows={10} value={v.content} onChange={(e) => set({ content: e.target.value })} />
      </L>
    </Section>
  );
}
