"use client";

import { useMemo, useState } from "react";
import { BookOpenText, Crosshair, Search, Skull, Sparkles, UserRound, UsersRound, Zap } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Modal } from "@/components/ui/Modal";
import { useToast } from "@/components/ui/Toast";
import { HoloFrame } from "@/components/media/ImageField";
import { useMediaUrl } from "@/components/media/media-client";
import type { AgentRow, CombatantRow, CombatRow, NpcRow, ShieldHomebrew } from "@/lib/campaign-types";
import { creatureSummary, normalizeCreature, testValue, usesLabel, type CreatureCondition } from "@/rules/creatures.ts";
import { thresholds } from "@/rules/d100.ts";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { addCombatant, combatApply, combatCondition, combatantAbility, combatantAttack } from "../../shield-actions";
import { NumInput as NumberField } from "@/components/homebrew/kit";
import { newId, useAct } from "./kit";

const th = (v: number) => {
  const t = thresholds(v);
  return `${t.normal}/${t.good}/${t.extreme}`;
};

/** Miniatura de um combatente (foto do agente ou imagem do monstro/NPC). */
export function CombatAvatar({ path, name, kind, className = "w-10" }: { path: string | null | undefined; name: string; kind: CombatantRow["kind"]; className?: string }) {
  const url = useMediaUrl(path ?? null);
  return (
    <div className={`shrink-0 ${className}`}>
      <HoloFrame url={url} alt={name} aspect="square" fallback={kind === "monstro" ? <Skull className="h-1/2 w-1/2" /> : <UserRound className="h-1/2 w-1/2" />} />
    </div>
  );
}

// ===================================================================== Adicionar combatente

type Tab = "agentes" | "npcs" | "monstros" | "avulso";

function PickCard({ name, path, kind, summary, children }: { name: string; path?: string | null; kind: CombatantRow["kind"]; summary: string; children: React.ReactNode }) {
  return (
    <li className="flex items-center gap-3 border border-line/70 bg-panel-2/40 p-2">
      <CombatAvatar path={path} name={name} kind={kind} className="w-12" />
      <div className="min-w-0 flex-1">
        <p className="truncate text-sm text-fg">{name}</p>
        <p className="truncate font-mono text-[0.6rem] text-fg-dim">{summary || "—"}</p>
      </div>
      {children}
    </li>
  );
}

export function AddCombatantModal({
  open,
  onClose,
  campaignId,
  combat,
  agents,
  npcs,
  homebrew,
  present,
  onAdded,
}: {
  open: boolean;
  onClose: () => void;
  campaignId: string;
  combat: CombatRow;
  agents: AgentRow[];
  npcs: NpcRow[];
  homebrew: ShieldHomebrew[];
  present: CombatantRow[];
  onAdded: () => void;
}) {
  const { act, busy } = useAct();
  const [tab, setTab] = useState<Tab>("monstros");
  const [q, setQ] = useState("");
  const [qty, setQty] = useState<Record<string, number>>({});
  const [ini, setIni] = useState<number | null>(null);
  const [adhoc, setAdhoc] = useState({ name: "", pv: null as number | null, pc: null as number | null });
  const norm = (s: string) => s.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();
  const match = (s: string) => !q.trim() || norm(s).includes(norm(q.trim()));
  const monsters = homebrew.filter((h) => (h.kind === "monstro" || h.kind === "npc") && match(h.name));
  const freeAgents = agents.filter((a) => !present.some((p) => p.character_id === a.character.id) && match(a.character.name));
  const campNpcs = npcs.filter((n) => match(n.name));
  const tabs: { id: Tab; label: string; icon: React.ComponentType<{ className?: string }>; n: number }[] = [
    { id: "monstros", label: "Monstros do Homebrew", icon: BookOpenText, n: homebrew.filter((h) => h.kind === "monstro" || h.kind === "npc").length },
    { id: "npcs", label: "NPCs da campanha", icon: UsersRound, n: npcs.length },
    { id: "agentes", label: "Personagens", icon: UserRound, n: agents.length },
    { id: "avulso", label: "Avulso", icon: Sparkles, n: 0 },
  ];

  function add(who: Parameters<typeof addCombatant>[2], quantity = 1) {
    act(() => addCombatant(campaignId, combat.id, who, ini, quantity), () => onAdded());
  }
  const Qty = ({ id }: { id: string }) => (
    <NumberField value={qty[id] ?? 1} onChange={(n) => setQty({ ...qty, [id]: Math.max(1, Math.min(20, n ?? 1)) })} min={1} max={20} ariaLabel="Quantidade" className="w-14 px-1 py-1 text-center text-xs" />
  );

  return (
    <Modal open={open} onClose={onClose} title="Adicionar combatente" tag={combat.name} size="xl">
      <div className="space-y-4">
        <div role="tablist" className="flex flex-wrap gap-1.5">
          {tabs.map((t) => (
            <button
              key={t.id}
              role="tab"
              aria-selected={tab === t.id}
              onClick={() => setTab(t.id)}
              className={`inline-flex items-center gap-1.5 border px-3 py-1.5 font-mono text-[0.62rem] tracking-[0.15em] uppercase ${tab === t.id ? "border-cyan bg-cyan/10 text-fg" : "border-line text-fg-muted"}`}
            >
              <t.icon className="h-3.5 w-3.5" /> {t.label}
              {t.n > 0 && <span className="text-holo">{t.n}</span>}
            </button>
          ))}
        </div>
        <div className="flex flex-wrap items-center gap-2">
          {tab !== "avulso" && (
            <label className="relative min-w-48 flex-1">
              <Search className="pointer-events-none absolute top-1/2 left-2.5 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
              <input className="field-input pl-8 text-sm" placeholder="Pesquisar por nome" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Pesquisar" />
            </label>
          )}
          <label className="flex items-center gap-1.5 font-mono text-[0.6rem] text-fg-muted uppercase">
            Iniciativa
            <NumberField value={ini} onChange={setIni} min={-10000} max={10000} allowNegative ariaLabel="Iniciativa" className="w-20 px-2 py-1 text-xs" />
          </label>
        </div>

        <div className="max-h-[55dvh] overflow-y-auto pr-1">
          {tab === "monstros" &&
            (monsters.length === 0 ? (
              <p className="py-6 text-center text-sm text-fg-muted">Nenhum monstro no seu Homebrew{q ? " com esse nome" : ""}. Crie em Painel → Homebrew → Criar Monstro.</p>
            ) : (
              <ul className="grid gap-2 md:grid-cols-2">
                {monsters.map((m) => (
                  <PickCard key={m.id} name={m.name} path={m.image_path} kind={m.kind === "monstro" ? "monstro" : "npc"} summary={creatureSummary(normalizeCreature(m.data))}>
                    <Qty id={m.id} />
                    <Button size="sm" loading={busy} onClick={() => add({ homebrewId: m.id }, qty[m.id] ?? 1)}>
                      Adicionar
                    </Button>
                  </PickCard>
                ))}
              </ul>
            ))}
          {tab === "npcs" &&
            (campNpcs.length === 0 ? (
              <p className="py-6 text-center text-sm text-fg-muted">Nenhum NPC na campanha. Crie na aba Agentes.</p>
            ) : (
              <ul className="grid gap-2 md:grid-cols-2">
                {campNpcs.map((n) => (
                  <PickCard key={n.id} name={n.name} path={n.image_path} kind={n.kind} summary={creatureSummary(normalizeCreature({ ...n.data, pv_max: n.pv_max, pc_max: n.pc_max }))}>
                    <Qty id={n.id} />
                    <Button size="sm" loading={busy} onClick={() => add({ npcId: n.id }, qty[n.id] ?? 1)}>
                      Adicionar
                    </Button>
                  </PickCard>
                ))}
              </ul>
            ))}
          {tab === "agentes" &&
            (freeAgents.length === 0 ? (
              <p className="py-6 text-center text-sm text-fg-muted">Todos os agentes aceitos já estão no combate.</p>
            ) : (
              <ul className="grid gap-2 md:grid-cols-2">
                {freeAgents.map((a) => {
                  const f = a.forms.find((x) => x.kind === (a.character.active_form ?? "base")) ?? a.forms[0];
                  return (
                    <PickCard key={a.character.id} name={a.character.name} path={f?.portrait_path} kind="character" summary={`Nível ${a.character.level}`}>
                      <Button size="sm" loading={busy} onClick={() => add({ characterId: a.character.id })}>
                        Adicionar
                      </Button>
                    </PickCard>
                  );
                })}
              </ul>
            ))}
          {tab === "avulso" && (
            <div className="grid gap-2 sm:grid-cols-[1fr_6rem_6rem_auto]">
              <input className="field-input" maxLength={120} placeholder="Nome" value={adhoc.name} onChange={(e) => setAdhoc({ ...adhoc, name: e.target.value })} aria-label="Nome" />
              <NumberField value={adhoc.pv} onChange={(n) => setAdhoc({ ...adhoc, pv: n })} placeholder="PV" ariaLabel="PV" />
              <NumberField value={adhoc.pc} onChange={(n) => setAdhoc({ ...adhoc, pc: n })} placeholder="PC" ariaLabel="PC" />
              <Button loading={busy} disabled={!adhoc.name.trim()} onClick={() => (add({ name: adhoc.name, pv: adhoc.pv, pc: adhoc.pc }), setAdhoc({ name: "", pv: null, pc: null }))}>
                Adicionar
              </Button>
            </div>
          )}
        </div>
        <p className="text-xs text-fg-muted">Cada monstro/NPC adicionado vira uma instância independente: PV, PC, condições e iniciativa próprios. Editar o modelo depois não altera combates existentes.</p>
      </div>
    </Modal>
  );
}

// ===================================================================== Ações da criatura no combate

type AttackResult = { attack: string; value: number; natural: number; outcomeLabel: string; hit: boolean; damage: { expression: string; rolls: number[]; total: number } | null; multiplier: number; finalDamage: number; conditions: CreatureCondition[] };
type AbilityResult = {
  ability: string;
  success: boolean;
  outcomeLabel: string | null;
  natural: number | null;
  damage: { expression: string; total: number } | null;
  heal: { expression: string; total: number } | null;
  condition: CreatureCondition | null;
  manual: boolean;
  pcCost: number;
  text: string;
};

/** Ataques e habilidades da instância: rolar, aplicar dano/cura/condição no alvo, consumir PC. */
export function CreatureActions({
  campaignId,
  combatant,
  npc,
  targets,
  disabled,
  onChanged,
}: {
  campaignId: string;
  combatant: CombatantRow;
  npc?: NpcRow;
  targets: { id: string; name: string }[];
  disabled?: boolean;
  onChanged: () => void;
}) {
  const toast = useToast();
  const { act, busy } = useAct();
  const sheet = useMemo(() => {
    const own = normalizeCreature(combatant.data ?? {});
    return own.attacks.length || own.abilities.length || !npc ? own : normalizeCreature(npc.data);
  }, [combatant.data, npc]);
  const [target, setTarget] = useState<string>(targets[0]?.id ?? "");
  const [pub, setPub] = useState(false);
  const [last, setLast] = useState<{ type: "attack"; r: AttackResult } | { type: "ability"; r: AbilityResult } | null>(null);
  const [applied, setApplied] = useState<Set<string>>(new Set());
  const [details, setDetails] = useState(false);
  if (sheet.attacks.length === 0 && sheet.abilities.length === 0 && !Object.keys(sheet.attributes).length) return null;
  const targetName = targets.find((t) => t.id === target)?.name ?? "alvo";

  function apply(key: string, fn: () => Promise<{ ok: boolean; error?: string; message?: string }>, label: string) {
    act(
      fn as () => Promise<never>,
      () => {
        setApplied((s) => new Set(s).add(key));
        toast(label);
        onChanged();
      },
      true,
    );
  }

  return (
    <div className="mt-2 space-y-2 border-t border-line/40 pt-2">
      <div className="flex flex-wrap items-center gap-2">
        <span className="label-mono">Alvo</span>
        <select className="field-input w-auto py-1 text-xs" value={target} onChange={(e) => setTarget(e.target.value)} aria-label="Alvo">
          <option value="">— nenhum —</option>
          {targets.map((t) => (
            <option key={t.id} value={t.id}>
              {t.name}
            </option>
          ))}
        </select>
        <label className="flex items-center gap-1 text-[0.65rem] text-fg-muted">
          <input type="checkbox" className="accent-[var(--color-holo)]" checked={pub} onChange={(e) => setPub(e.target.checked)} /> rolagem pública
        </label>
        <button type="button" className="ml-auto font-mono text-[0.6rem] tracking-[0.15em] text-cyan uppercase hover:underline" onClick={() => setDetails(!details)}>
          {details ? "Ocultar ficha" : "Ver ficha"}
        </button>
      </div>

      <div className="flex flex-wrap gap-1.5">
        {sheet.attacks.map((a) => (
          <button
            key={a.id}
            type="button"
            disabled={busy || disabled}
            title={[a.description, a.effects].filter(Boolean).join("\n") || undefined}
            onClick={() =>
              act(
                () => combatantAttack(campaignId, combatant.id, a.id, pub),
                (r) => {
                  if (!r) return;
                  setApplied(new Set());
                  setLast({ type: "attack", r: r as AttackResult });
                  onChanged();
                },
                true,
              )
            }
            className="inline-flex items-center gap-1 border border-line-strong px-2 py-1 font-mono text-[0.62rem] text-fg hover:border-cyan disabled:opacity-50"
          >
            <Crosshair className="h-3 w-3 text-cyan" aria-hidden /> {a.name} ({testValue(sheet, a.uses, a.value)} · {a.damage})
          </button>
        ))}
        {sheet.abilities.map((a) => (
          <button
            key={a.id}
            type="button"
            disabled={busy || disabled || (a.pc_cost ? (combatant.pc_current ?? 0) < a.pc_cost : false)}
            title={[a.description, a.special].filter(Boolean).join("\n") || undefined}
            onClick={() =>
              act(
                () => combatantAbility(campaignId, combatant.id, a.id, newId(), pub),
                (r) => {
                  if (!r) return;
                  setApplied(new Set());
                  setLast({ type: "ability", r: r as AbilityResult });
                  onChanged();
                },
                true,
              )
            }
            className="inline-flex items-center gap-1 border border-holo/50 px-2 py-1 font-mono text-[0.62rem] text-fg hover:border-holo disabled:opacity-40"
          >
            <Zap className="h-3 w-3 text-holo" aria-hidden /> {a.name}
            {a.pc_cost ? ` (${a.pc_cost} PC)` : ""}
          </button>
        ))}
      </div>

      {last && (
        <div className="space-y-2 border border-cyan/40 bg-cyan/5 p-2 text-xs" role="status">
          {last.type === "attack" ? (
            <>
              <p className="text-fg">
                <strong>{last.r.attack}</strong>: d100 <span className="font-mono text-cyan">{last.r.natural}</span> contra {last.r.value} — {last.r.outcomeLabel}
                {last.r.hit && last.r.damage && (
                  <>
                    {" "}
                    · dano <span className="font-mono">{last.r.damage.expression}</span> = {last.r.damage.total}
                    {last.r.multiplier > 1 && ` ×${last.r.multiplier}`} → <strong className="text-cyan">{last.r.finalDamage}</strong>
                  </>
                )}
              </p>
              {last.r.hit && (
                <div className="flex flex-wrap gap-1.5">
                  <Button
                    size="sm"
                    disabled={!target || applied.has("dmg") || busy}
                    onClick={() => apply("dmg", () => combatApply(campaignId, target, "damage", last.r.finalDamage, newId(), `${combatant.name}: ${last.r.attack}`), `${last.r.finalDamage} de dano em ${targetName}.`)}
                  >
                    Aplicar {last.r.finalDamage} de dano em {targetName}
                  </Button>
                  {last.r.conditions.map((cd, i) => (
                    <Button
                      key={i}
                      size="sm"
                      variant="secondary"
                      disabled={!target || applied.has(`c${i}`) || busy}
                      onClick={() => apply(`c${i}`, () => combatCondition(campaignId, target, "add", { name: cd.name, turns: cd.turns }), `${cd.name} aplicado em ${targetName}.`)}
                    >
                      Aplicar {cd.name}
                      {cd.turns ? ` (${cd.turns}t)` : ""}
                    </Button>
                  ))}
                </div>
              )}
            </>
          ) : (
            <>
              <p className="text-fg">
                <strong>{last.r.ability}</strong>
                {last.r.natural != null && (
                  <>
                    : d100 <span className="font-mono text-cyan">{last.r.natural}</span> — {last.r.outcomeLabel}
                  </>
                )}
                {last.r.pcCost > 0 && <span className="text-holo"> · −{last.r.pcCost} PC</span>}
                {last.r.damage && ` · dano ${last.r.damage.expression} = ${last.r.damage.total}`}
                {last.r.heal && ` · cura ${last.r.heal.expression} = ${last.r.heal.total}`}
                {last.r.manual && " · efeito manual"}
              </p>
              {last.r.text && <p className="whitespace-pre-line text-fg-dim">{last.r.text}</p>}
              <div className="flex flex-wrap gap-1.5">
                {last.r.damage && (
                  <Button size="sm" disabled={!target || applied.has("dmg") || busy} onClick={() => apply("dmg", () => combatApply(campaignId, target, "damage", last.r.damage!.total, newId(), `${combatant.name}: ${last.r.ability}`), `${last.r.damage!.total} de dano em ${targetName}.`)}>
                    Aplicar {last.r.damage.total} de dano em {targetName}
                  </Button>
                )}
                {last.r.heal && (
                  <>
                    <Button size="sm" variant="secondary" disabled={applied.has("healself") || busy} onClick={() => apply("healself", () => combatApply(campaignId, combatant.id, "heal", last.r.heal!.total, newId(), last.r.ability), `${combatant.name} recupera ${last.r.heal!.total} PV.`)}>
                      Curar a si ({last.r.heal.total})
                    </Button>
                    <Button size="sm" variant="secondary" disabled={!target || applied.has("heal") || busy} onClick={() => apply("heal", () => combatApply(campaignId, target, "heal", last.r.heal!.total, newId(), last.r.ability), `${targetName} recupera ${last.r.heal!.total} PV.`)}>
                      Curar {targetName}
                    </Button>
                  </>
                )}
                {last.r.condition && (
                  <Button
                    size="sm"
                    variant="secondary"
                    disabled={!target || applied.has("cond") || busy}
                    onClick={() => apply("cond", () => combatCondition(campaignId, target, "add", { name: last.r.condition!.name, turns: last.r.condition!.turns }), `${last.r.condition!.name} aplicado em ${targetName}.`)}
                  >
                    Aplicar {last.r.condition.name}
                    {last.r.condition.turns ? ` (${last.r.condition.turns}t)` : ""}
                  </Button>
                )}
              </div>
            </>
          )}
        </div>
      )}

      {details && (
        <div className="grid gap-2 border border-line/50 bg-void/40 p-2 text-xs sm:grid-cols-2">
          {Object.keys(sheet.attributes).length > 0 && (
            <div>
              <p className="label-mono">Atributos (normal/bom/extremo)</p>
              <p className="font-mono text-fg-dim">
                {ATTRIBUTES.filter((a) => sheet.attributes[a.id] != null)
                  .map((a) => `${a.id} ${th(sheet.attributes[a.id]!)}`)
                  .join(" · ")}
              </p>
            </div>
          )}
          {sheet.skills.length > 0 && (
            <div>
              <p className="label-mono">Perícias</p>
              <p className="font-mono text-fg-dim">{sheet.skills.map((s) => `${SKILL_BY_ID[s.id]?.name ?? s.name ?? s.id.replace(/^custom:/, "")} ${th(s.value)}`).join(" · ")}</p>
            </div>
          )}
          {(sheet.defense || sheet.movement) && (
            <p className="text-fg-dim">
              {sheet.defense && `Defesa ${sheet.defense}`} {sheet.movement && `· Deslocamento ${sheet.movement}`}
            </p>
          )}
          {(sheet.resistances.length > 0 || sheet.vulnerabilities.length > 0 || sheet.immunities.length > 0) && (
            <p className="text-fg-dim">
              {sheet.resistances.length > 0 && `Resiste: ${sheet.resistances.join(", ")}. `}
              {sheet.vulnerabilities.length > 0 && `Vulnerável: ${sheet.vulnerabilities.join(", ")}. `}
              {sheet.immunities.length > 0 && `Imune: ${sheet.immunities.join(", ")}.`}
            </p>
          )}
          {sheet.attacks.map((a) => (
            <p key={a.id} className="text-fg-dim">
              <span className="text-fg">{a.name}</span> — {usesLabel(a.uses, sheet)} {th(testValue(sheet, a.uses, a.value))}, {a.damage}
              {a.damage_type && ` ${a.damage_type}`}
              {a.range && `, ${a.range}`}
              {a.effects && `. ${a.effects}`}
            </p>
          ))}
          {sheet.abilities.map((a) => (
            <p key={a.id} className="text-fg-dim">
              <span className="text-fg">{a.name}</span>
              {a.type && ` (${a.type})`} — {[a.area, a.duration, a.description].filter(Boolean).join(" · ")}
            </p>
          ))}
        </div>
      )}
    </div>
  );
}
