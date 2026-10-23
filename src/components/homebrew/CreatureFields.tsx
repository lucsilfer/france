"use client";

import { Download } from "lucide-react";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { SKILLS } from "@/rules/data/skills.ts";
import { DAMAGE_TYPE_LABEL } from "@/rules/data/equipment.ts";
import { thresholds } from "@/rules/d100.ts";
import { isValidDice } from "@/rules/dice.ts";
import { normalizeCreature, testValue, usesLabel } from "@/rules/creatures.ts";
import { CONDITION_SUGGESTIONS } from "@/components/campaign/ConditionChips";
import type { AbilityValue, AttackValue, CreatureFormValue } from "@/lib/homebrew";
import type { HomebrewEntry } from "@/lib/types";
import { AddButton, L, NumInput, RowCard, Section, TagsInput, rid } from "./kit";

function Th({ value }: { value: number | null | undefined }) {
  if (value == null) return <span className="font-mono text-[0.6rem] text-fg-muted">— / — / —</span>;
  const t = thresholds(value);
  return (
    <span className="font-mono text-[0.6rem] text-fg-dim tabular-nums" title="Acerto normal / bom / extremo (d100: menor ou igual)">
      <span className="text-fg">{t.normal}</span> / {t.good} / <span className="text-cyan">{t.extreme}</span>
    </span>
  );
}

/** Opções de teste (perícias e atributos da própria criatura). */
function UsesSelect({ value, onChange, sheet, allowNone }: { value: string | undefined; onChange: (v: string | undefined) => void; sheet: CreatureFormValue; allowNone?: boolean }) {
  return (
    <select className="field-input" value={value ?? ""} onChange={(e) => onChange(e.target.value || undefined)} aria-label="Teste usado">
      {allowNone && <option value="">Sem teste (só efeito)</option>}
      <option value="valor">Valor fixo</option>
      {sheet.skills.length > 0 && (
        <optgroup label="Perícias da criatura">
          {sheet.skills.map((s) => (
            <option key={s.id} value={`skill:${s.id}`}>
              {usesLabel(`skill:${s.id}`, normalizeCreature(sheet))} ({s.value})
            </option>
          ))}
        </optgroup>
      )}
      <optgroup label="Atributos">
        {ATTRIBUTES.map((a) => (
          <option key={a.id} value={`attr:${a.id}`}>
            {a.name} ({sheet.attributes[a.id] ?? "—"})
          </option>
        ))}
      </optgroup>
    </select>
  );
}

function ConditionsEditor({ list, onChange }: { list: { name: string; turns: number | null }[]; onChange: (l: { name: string; turns: number | null }[]) => void }) {
  return (
    <div className="space-y-2">
      {list.map((c, i) => (
        <div key={i} className="grid grid-cols-[1fr_6rem_auto] gap-2">
          <input className="field-input" list="hb-conditions" value={c.name} maxLength={80} placeholder="Condição" aria-label="Condição" onChange={(e) => onChange(list.map((x, j) => (j === i ? { ...x, name: e.target.value } : x)))} />
          <NumInput value={c.turns} onChange={(v) => onChange(list.map((x, j) => (j === i ? { ...x, turns: v } : x)))} min={1} max={100} placeholder="turnos" ariaLabel="Duração em turnos" />
          <button type="button" className="px-2 text-xs text-fg-muted hover:text-alert" onClick={() => onChange(list.filter((_, j) => j !== i))} aria-label="Remover condição">
            ✕
          </button>
        </div>
      ))}
      {list.length < 5 && <AddButton onClick={() => onChange([...list, { name: "", turns: null }])}>Condição</AddButton>}
    </div>
  );
}

export interface CreatureFieldsProps<T extends CreatureFormValue> {
  value: T;
  onChange: (v: T) => void;
  /** NPC em modo simplificado: esconde atributos, perícias e inventário. */
  simple?: boolean;
  /** Armas e itens do Homebrew para importar como ataque / inventário. */
  library?: HomebrewEntry[];
  showInventory?: boolean;
}

export function CreatureFields<T extends CreatureFormValue>({ value: v, onChange, simple, library = [], showInventory }: CreatureFieldsProps<T>) {
  const set = (patch: Partial<CreatureFormValue>) => onChange({ ...v, ...patch } as T);
  const weapons = library.filter((e) => e.kind === "arma");
  const items = library.filter((e) => e.kind === "item" || e.kind === "item_especial" || e.kind === "outro");
  const usedSkills = new Set(v.skills.map((s) => s.id));
  const setAttack = (i: number, patch: Partial<AttackValue>) => set({ attacks: v.attacks.map((a, j) => (j === i ? { ...a, ...patch } : a)) });
  const setAbility = (i: number, patch: Partial<AbilityValue>) => set({ abilities: v.abilities.map((a, j) => (j === i ? { ...a, ...patch } : a)) });

  return (
    <div className="space-y-3">
      <datalist id="hb-conditions">
        {CONDITION_SUGGESTIONS.map((c) => (
          <option key={c} value={c} />
        ))}
      </datalist>

      {!simple && (
        <Section title="Atributos" hint="Valores definidos diretamente pelo Mestre (sem rolagem de criação). Ao lado: acerto normal / bom / extremo no d100." defaultOpen badge={Object.keys(v.attributes).length || undefined}>
          <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
            {ATTRIBUTES.map((a) => (
              <div key={a.id} className="space-y-1 border border-line/60 p-2">
                <span className="label-mono flex justify-between text-holo/90">
                  {a.id} <span className="text-fg-muted normal-case">{a.name}</span>
                </span>
                <NumInput
                  value={v.attributes[a.id] ?? null}
                  onChange={(n) => {
                    const attributes = { ...v.attributes };
                    if (n == null) delete attributes[a.id];
                    else attributes[a.id] = n;
                    set({ attributes });
                  }}
                  max={999}
                  ariaLabel={a.name}
                />
                <Th value={v.attributes[a.id]} />
              </div>
            ))}
          </div>
        </Section>
      )}

      <Section title="Recursos e defesas" hint="PV e PC livres: monstros e NPCs não seguem a fórmula dos jogadores. Deixe o atual vazio para começar cheio." defaultOpen>
        <div className="grid grid-cols-2 gap-3 sm:grid-cols-4">
          <L label="PV máximo">
            <NumInput value={v.pv_max} onChange={(n) => set({ pv_max: n })} />
          </L>
          <L label="PV atual">
            <NumInput value={v.pv_current} onChange={(n) => set({ pv_current: n })} placeholder={v.pv_max != null ? String(v.pv_max) : ""} />
          </L>
          <L label="PC máximo">
            <NumInput value={v.pc_max} onChange={(n) => set({ pc_max: n })} />
          </L>
          <L label="PC atual">
            <NumInput value={v.pc_current} onChange={(n) => set({ pc_current: n })} placeholder={v.pc_max != null ? String(v.pc_max) : ""} />
          </L>
          <L label="Defesa">
            <input className="field-input" maxLength={60} value={v.defense} onChange={(e) => set({ defense: e.target.value })} placeholder="Ex.: 15 ou Armadura natural" />
          </L>
          <L label="Deslocamento">
            <input className="field-input" maxLength={60} value={v.movement} onChange={(e) => set({ movement: e.target.value })} placeholder="Ex.: 9 m, voo 12 m" />
          </L>
        </div>
        <div className="grid gap-3 sm:grid-cols-3">
          <L label="Resistências">
            <TagsInput value={v.resistances} onChange={(l) => set({ resistances: l })} placeholder="Cortante, Fogo" />
          </L>
          <L label="Vulnerabilidades">
            <TagsInput value={v.vulnerabilities} onChange={(l) => set({ vulnerabilities: l })} placeholder="Prata, Luz" />
          </L>
          <L label="Imunidades">
            <TagsInput value={v.immunities} onChange={(l) => set({ immunities: l })} placeholder="Veneno" />
          </L>
        </div>
      </Section>

      {!simple && (
        <Section title="Perícias" hint="Sem o limite de 75 dos jogadores. Use as perícias da ficha ou crie perícias próprias." badge={v.skills.length || undefined}>
          {v.skills.map((s, i) => {
            const custom = s.id.startsWith("custom:");
            return (
              <div key={i} className="grid grid-cols-[1fr_5.5rem_auto] items-center gap-2 sm:grid-cols-[1fr_6rem_9rem_auto]">
                {custom ? (
                  <input
                    className="field-input"
                    value={s.id.slice(7)}
                    maxLength={60}
                    aria-label="Nome da perícia"
                    onChange={(e) => set({ skills: v.skills.map((x, j) => (j === i ? { ...x, id: `custom:${e.target.value.slice(0, 60)}`, name: e.target.value.slice(0, 60) } : x)) })}
                  />
                ) : (
                  <select className="field-input" value={s.id} aria-label="Perícia" onChange={(e) => set({ skills: v.skills.map((x, j) => (j === i ? { ...x, id: e.target.value } : x)) })}>
                    {SKILLS.filter((k) => k.id === s.id || !usedSkills.has(k.id)).map((k) => (
                      <option key={k.id} value={k.id}>
                        {k.name}
                      </option>
                    ))}
                  </select>
                )}
                <NumInput value={s.value} onChange={(n) => set({ skills: v.skills.map((x, j) => (j === i ? { ...x, value: n ?? 0 } : x)) })} max={999} ariaLabel="Valor" />
                <span className="hidden sm:block">
                  <Th value={s.value} />
                </span>
                <button type="button" className="px-2 text-xs text-fg-muted hover:text-alert" onClick={() => set({ skills: v.skills.filter((_, j) => j !== i) })} aria-label="Remover perícia">
                  ✕
                </button>
              </div>
            );
          })}
          <div className="flex flex-wrap gap-2">
            <AddButton
              disabled={v.skills.length >= 60}
              onClick={() => {
                const free = SKILLS.find((k) => !usedSkills.has(k.id));
                if (free) set({ skills: [...v.skills, { id: free.id, value: 50 }] });
              }}
            >
              Perícia da ficha
            </AddButton>
            <AddButton disabled={v.skills.length >= 60} onClick={() => set({ skills: [...v.skills, { id: `custom:Nova perícia ${v.skills.length + 1}`, name: `Nova perícia ${v.skills.length + 1}`, value: 50 }] })}>
              Perícia própria
            </AddButton>
          </div>
        </Section>
      )}

      <Section title="Ataques" hint="Teste d100 contra o valor escolhido; se acertar, o dano é rolado (extremo ×1,5, crítico ×2)." badge={v.attacks.length || undefined} defaultOpen={simple}>
        {v.attacks.map((a, i) => {
          const val = testValue(normalizeCreature(v), a.uses, a.value);
          return (
            <RowCard key={a.id} title={`${a.name || "Ataque sem nome"} · ${a.damage || "—"}`} onRemove={() => set({ attacks: v.attacks.filter((_, j) => j !== i) })} open={!a.name}>
              <div className="grid gap-3 sm:grid-cols-2">
                <L label="Nome">
                  <input className="field-input" maxLength={80} value={a.name} onChange={(e) => setAttack(i, { name: e.target.value })} />
                </L>
                <L label="Dano (expressão)">
                  <input
                    className="field-input font-mono"
                    maxLength={60}
                    value={a.damage}
                    aria-invalid={a.damage !== "" && !isValidDice(a.damage) ? true : undefined}
                    onChange={(e) => setAttack(i, { damage: e.target.value })}
                    placeholder="2d6+3"
                  />
                </L>
                <L label="Perícia ou atributo">
                  <UsesSelect value={a.uses} onChange={(u) => setAttack(i, { uses: u ?? "valor" })} sheet={v} />
                </L>
                {a.uses === "valor" ? (
                  <L label="Valor do teste">
                    <NumInput value={a.value ?? null} onChange={(n) => setAttack(i, { value: n })} max={999} />
                  </L>
                ) : (
                  <div className="flex items-end pb-2 text-xs text-fg-dim">
                    Valor atual: <span className="ml-1 text-fg">{val}</span>
                  </div>
                )}
                <div className="sm:col-span-2">
                  <span className="label-mono">Acerto normal / bom / extremo: </span>
                  <Th value={val} />
                </div>
                <L label="Tipo de dano">
                  <input className="field-input" list="hb-damage-types" maxLength={40} value={a.damage_type ?? ""} onChange={(e) => setAttack(i, { damage_type: e.target.value })} />
                </L>
                <L label="Alcance">
                  <input className="field-input" maxLength={60} value={a.range ?? ""} onChange={(e) => setAttack(i, { range: e.target.value })} placeholder="Corpo a corpo, 12 m…" />
                </L>
              </div>
              <L label="Descrição">
                <textarea className="field-input" rows={2} value={a.description ?? ""} onChange={(e) => setAttack(i, { description: e.target.value })} />
              </L>
              <L label="Efeitos adicionais">
                <textarea className="field-input" rows={2} value={a.effects ?? ""} onChange={(e) => setAttack(i, { effects: e.target.value })} />
              </L>
              <div>
                <span className="label-mono mb-1 block">Condições aplicadas ao acertar</span>
                <ConditionsEditor list={a.conditions ?? []} onChange={(l) => setAttack(i, { conditions: l })} />
              </div>
            </RowCard>
          );
        })}
        <datalist id="hb-damage-types">
          {Object.values(DAMAGE_TYPE_LABEL).map((d) => (
            <option key={d} value={d} />
          ))}
        </datalist>
        <div className="flex flex-wrap items-center gap-2">
          <AddButton disabled={v.attacks.length >= 20} onClick={() => set({ attacks: [...v.attacks, { id: rid(), name: "", uses: "valor", value: 50, damage: "1d6", conditions: [] }] })}>
            Ataque
          </AddButton>
          {weapons.length > 0 && (
            <label className="flex items-center gap-1.5 text-xs text-fg-dim">
              <Download className="h-3.5 w-3.5" aria-hidden />
              <select
                className="field-input w-auto py-1 text-xs"
                value=""
                aria-label="Usar arma do Homebrew"
                onChange={(e) => {
                  const w = weapons.find((x) => x.id === e.target.value);
                  if (!w) return;
                  const d = w.data as Record<string, string>;
                  const skill = d.skill_override || (d.attack_kind === "ranged" ? "pontaria" : d.attack_kind === "firearm" ? "arma_de_fogo" : "luta");
                  const hasSkill = v.skills.some((s) => s.id === skill);
                  set({
                    attacks: [
                      ...v.attacks,
                      {
                        id: rid(),
                        name: w.name,
                        description: w.description,
                        uses: hasSkill ? `skill:${skill}` : "valor",
                        value: hasSkill ? null : 50,
                        damage: d.effect_dice || "1d6",
                        damage_type: DAMAGE_TYPE_LABEL[d.damage_type as keyof typeof DAMAGE_TYPE_LABEL] ?? "",
                        range: d.range ?? "",
                        effects: d.special_rules ?? "",
                        conditions: [],
                      },
                    ],
                  });
                }}
              >
                <option value="">Usar arma do Homebrew…</option>
                {weapons.map((w) => (
                  <option key={w.id} value={w.id}>
                    {w.name}
                  </option>
                ))}
              </select>
            </label>
          )}
        </div>
      </Section>

      <Section title={simple ? "Habilidades e poderes" : "Habilidades"} hint="Sem as restrições de criação dos jogadores. Marque “efeito manual” para algo que o sistema só registra e você aplica." badge={v.abilities.length || undefined}>
        {v.abilities.map((a, i) => (
          <RowCard key={a.id} title={`${a.name || "Habilidade sem nome"}${a.pc_cost ? ` · ${a.pc_cost} PC` : ""}`} onRemove={() => set({ abilities: v.abilities.filter((_, j) => j !== i) })} open={!a.name}>
            <div className="grid gap-3 sm:grid-cols-3">
              <L label="Nome" className="sm:col-span-2">
                <input className="field-input" maxLength={80} value={a.name} onChange={(e) => setAbility(i, { name: e.target.value })} />
              </L>
              <L label="Tipo">
                <input className="field-input" list="hb-ability-types" maxLength={40} value={a.type ?? ""} onChange={(e) => setAbility(i, { type: e.target.value })} />
              </L>
              <L label="Dano">
                <input className="field-input font-mono" maxLength={60} value={a.damage ?? ""} aria-invalid={a.damage && !isValidDice(a.damage) ? true : undefined} onChange={(e) => setAbility(i, { damage: e.target.value })} placeholder="3d6" />
              </L>
              <L label="Cura">
                <input className="field-input font-mono" maxLength={60} value={a.heal ?? ""} aria-invalid={a.heal && !isValidDice(a.heal) ? true : undefined} onChange={(e) => setAbility(i, { heal: e.target.value })} placeholder="2d8" />
              </L>
              <L label="Custo de PC">
                <NumInput value={a.pc_cost ?? null} onChange={(n) => setAbility(i, { pc_cost: n ?? 0 })} max={9999} />
              </L>
              <L label="Área">
                <input className="field-input" maxLength={60} value={a.area ?? ""} onChange={(e) => setAbility(i, { area: e.target.value })} placeholder="Raio de 6 m" />
              </L>
              <L label="Duração">
                <input className="field-input" maxLength={60} value={a.duration ?? ""} onChange={(e) => setAbility(i, { duration: e.target.value })} placeholder="3 turnos" />
              </L>
              <L label="Teste (opcional)">
                <UsesSelect value={a.uses} onChange={(u) => setAbility(i, { uses: u })} sheet={v} allowNone />
              </L>
              {a.uses === "valor" && (
                <L label="Valor do teste">
                  <NumInput value={a.value ?? null} onChange={(n) => setAbility(i, { value: n })} max={999} />
                </L>
              )}
            </div>
            <div className="grid gap-3 sm:grid-cols-[1fr_7rem]">
              <L label="Condição aplicada">
                <input className="field-input" list="hb-conditions" maxLength={80} value={a.condition?.name ?? ""} onChange={(e) => setAbility(i, { condition: e.target.value ? { name: e.target.value, turns: a.condition?.turns ?? null } : null })} />
              </L>
              <L label="Turnos">
                <NumInput value={a.condition?.turns ?? null} onChange={(n) => a.condition && setAbility(i, { condition: { ...a.condition, turns: n } })} min={1} max={100} />
              </L>
            </div>
            <L label="Descrição">
              <textarea className="field-input" rows={2} value={a.description ?? ""} onChange={(e) => setAbility(i, { description: e.target.value })} />
            </L>
            <L label="Regras especiais">
              <textarea className="field-input" rows={2} value={a.special ?? ""} onChange={(e) => setAbility(i, { special: e.target.value })} />
            </L>
            <label className="flex items-center gap-2 text-sm text-fg-dim">
              <input type="checkbox" className="accent-[var(--color-holo)]" checked={Boolean(a.manual)} onChange={(e) => setAbility(i, { manual: e.target.checked })} />
              Efeito manual (o sistema registra o uso e cobra o PC; o Mestre aplica o resto)
            </label>
          </RowCard>
        ))}
        <datalist id="hb-ability-types">
          {["Ataque especial", "Cura", "Controle", "Aura", "Passiva", "Reação", "Invocação", "Movimento"].map((d) => (
            <option key={d} value={d} />
          ))}
        </datalist>
        <AddButton disabled={v.abilities.length >= 30} onClick={() => set({ abilities: [...v.abilities, { id: rid(), name: "", pc_cost: 0, condition: null }] })}>
          Habilidade
        </AddButton>
      </Section>

      {showInventory && !simple && (
        <Section title="Inventário" badge={v.inventory.length || undefined}>
          {v.inventory.map((it, i) => (
            <div key={i} className="grid grid-cols-[1fr_5rem_auto] gap-2 sm:grid-cols-[1fr_5rem_1fr_auto]">
              <input className="field-input" maxLength={120} value={it.name} aria-label="Item" onChange={(e) => set({ inventory: v.inventory.map((x, j) => (j === i ? { ...x, name: e.target.value } : x)) })} />
              <NumInput value={it.quantity ?? 1} onChange={(n) => set({ inventory: v.inventory.map((x, j) => (j === i ? { ...x, quantity: n ?? 1 } : x)) })} max={9999} ariaLabel="Quantidade" />
              <input className="field-input hidden sm:block" maxLength={500} value={it.notes ?? ""} placeholder="Notas" aria-label="Notas" onChange={(e) => set({ inventory: v.inventory.map((x, j) => (j === i ? { ...x, notes: e.target.value } : x)) })} />
              <button type="button" className="px-2 text-xs text-fg-muted hover:text-alert" onClick={() => set({ inventory: v.inventory.filter((_, j) => j !== i) })} aria-label="Remover item">
                ✕
              </button>
            </div>
          ))}
          <div className="flex flex-wrap items-center gap-2">
            <AddButton disabled={v.inventory.length >= 60} onClick={() => set({ inventory: [...v.inventory, { name: "", quantity: 1 }] })}>
              Item
            </AddButton>
            {items.length + weapons.length > 0 && (
              <select
                className="field-input w-auto py-1 text-xs"
                value=""
                aria-label="Adicionar item do Homebrew"
                onChange={(e) => {
                  const it = library.find((x) => x.id === e.target.value);
                  if (it) set({ inventory: [...v.inventory, { name: it.name, quantity: 1, notes: it.description.slice(0, 500) }] });
                }}
              >
                <option value="">Adicionar do Homebrew…</option>
                {[...weapons, ...items].map((x) => (
                  <option key={x.id} value={x.id}>
                    {x.name}
                  </option>
                ))}
              </select>
            )}
          </div>
        </Section>
      )}

      <Section title="Condições iniciais" badge={v.conditions.length || undefined}>
        <ConditionsEditor list={v.conditions} onChange={(l) => set({ conditions: l })} />
      </Section>
    </div>
  );
}
