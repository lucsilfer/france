"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import { Crosshair, ExternalLink, Gift, Lock, Pencil, Plus, Skull, Trash2, UserRound } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Modal } from "@/components/ui/Modal";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { useToast } from "@/components/ui/Toast";
import { ConditionChips } from "@/components/campaign/ConditionChips";
import type { AgentForm, AgentRow, NpcRow, PartyRow, ShieldHomebrew } from "@/lib/campaign-types";
import { buildSheet, type StoredForm } from "@/rules/sheet.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { ORIGIN_BY_ID } from "@/rules/data/origins.ts";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { CATALOG } from "@/rules/catalog.ts";
import { isValidDice } from "@/rules/dice.ts";
import { agentAdjust, agentCondition, deleteNpc, giveItem, npcAdjust, npcAttack, npcCondition, npcFromHomebrew, saveNpc, type NpcInput } from "../../shield-actions";
import { Adjuster, Empty, Meter, SectionTitle, useAct } from "./kit";

export function toStored(f: AgentForm): StoredForm {
  return {
    kind: f.kind,
    pv_current: f.pv_current,
    pc_current: f.pc_current,
    pv_other_bonus: f.pv_other_bonus,
    pc_other_bonus: f.pc_other_bonus,
    attributes: f.form_attributes ?? [],
    skills: f.form_skills ?? [],
    progressions: f.level_progressions ?? [],
  };
}

/** PV/PC máximos calculados pelo motor de regras (o mesmo usado na ficha e no banco). */
export function formMax(a: AgentRow, f: AgentForm) {
  const s = buildSheet({ classId: a.character.class_id, originId: a.character.origin_id, level: a.character.level, form: toStored(f) });
  return { pv: s.resources.pvMax, pc: s.resources.pcMax };
}

export function AgentsTab({
  campaignId,
  agents,
  setAgents,
  npcs,
  setNpcs,
  party,
  homebrew,
}: {
  campaignId: string;
  agents: AgentRow[];
  setAgents: (f: (a: AgentRow[]) => AgentRow[]) => void;
  npcs: NpcRow[];
  setNpcs: (f: (n: NpcRow[]) => NpcRow[]) => void;
  party: PartyRow[];
  homebrew: ShieldHomebrew[];
}) {
  const pending = party.filter((p) => p.status === "pending");
  return (
    <div className="space-y-8">
      <section>
        <SectionTitle>Agentes ({agents.length})</SectionTitle>
        {pending.length > 0 && (
          <p className="mb-3 border border-alert/50 bg-alert/10 px-3 py-2 text-sm text-fg">
            {pending.length} personagem(ns) aguardando aprovação —{" "}
            <Link className="text-cyan underline" href={`/campanhas/${campaignId}`}>
              revisar na visão geral
            </Link>
            .
          </p>
        )}
        {agents.length === 0 ? (
          <Empty>Nenhum agente aceito. Compartilhe o convite e aprove os personagens dos jogadores.</Empty>
        ) : (
          <div className="grid gap-4 xl:grid-cols-2">
            {agents.map((a) => (
              <AgentCard key={a.character.id} campaignId={campaignId} agent={a} setAgents={setAgents} party={party} homebrew={homebrew} />
            ))}
          </div>
        )}
      </section>
      <NpcSection campaignId={campaignId} npcs={npcs} setNpcs={setNpcs} homebrew={homebrew} />
    </div>
  );
}

function AgentCard({
  campaignId,
  agent,
  setAgents,
  party,
  homebrew,
}: {
  campaignId: string;
  agent: AgentRow;
  setAgents: (f: (a: AgentRow[]) => AgentRow[]) => void;
  party: PartyRow[];
  homebrew: ShieldHomebrew[];
}) {
  const { act, busy } = useAct();
  const c = agent.character;
  const prodigio = c.origin_id === "prodigio";
  const forms = agent.forms.filter((f) => f.kind === "base" || f.setup_complete).sort((x, y) => (x.kind === y.kind ? 0 : x.kind === "base" ? -1 : 1));
  const player = party.find((p) => p.character_id === c.id)?.owner_username ?? c.player_name;
  const [give, setGive] = useState(false);
  const locked = !agent.masterCanEdit;

  function patchForm(formId: string, patch: Partial<AgentForm>) {
    setAgents((list) => list.map((a) => (a.character.id !== c.id ? a : { ...a, forms: a.forms.map((f) => (f.id === formId ? { ...f, ...patch } : f)) })));
  }

  return (
    <article className="chamfer border border-line-strong bg-panel-2/50 p-4">
      <header className="mb-3 flex flex-wrap items-start justify-between gap-2">
        <div className="min-w-0">
          <h3 className="truncate text-lg text-fg">{c.name}</h3>
          <p className="text-xs text-fg-dim">
            {[CLASS_BY_ID[c.class_id ?? ""]?.name, ORIGIN_BY_ID[c.origin_id ?? ""]?.name, `nível ${c.level}`].filter(Boolean).join(" · ")}
          </p>
          <p className="flex items-center gap-1 text-xs text-fg-muted">
            <UserRound className="h-3 w-3" aria-hidden /> {player || "—"}
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          <Link href={`/personagens/${c.id}`} className="inline-flex items-center gap-1 border border-line-strong px-2 py-1 font-mono text-[0.6rem] tracking-[0.15em] text-cyan uppercase hover:border-cyan">
            <ExternalLink className="h-3 w-3" aria-hidden /> Abrir ficha
          </Link>
          <button
            type="button"
            disabled={locked}
            onClick={() => setGive(true)}
            className="inline-flex items-center gap-1 border border-line-strong px-2 py-1 font-mono text-[0.6rem] tracking-[0.15em] text-fg-dim uppercase hover:border-holo disabled:opacity-40"
          >
            <Gift className="h-3 w-3" aria-hidden /> Dar item
          </button>
        </div>
      </header>
      {locked && (
        <p className="mb-3 flex items-center gap-1.5 text-xs text-alert">
          <Lock className="h-3 w-3" aria-hidden /> O jogador não autorizou o Mestre a editar esta ficha (só visualização).
        </p>
      )}
      <div className={`grid gap-3 ${forms.length > 1 ? "sm:grid-cols-2" : ""}`}>
        {forms.map((f) => {
          const max = formMax(agent, f);
          const active = (c.active_form ?? "base") === f.kind;
          return (
            <div key={f.id} className={`space-y-2 border p-3 ${active ? "border-cyan/70 bg-cyan/5" : "border-line/60 opacity-80"}`}>
              {forms.length > 1 && (
                <p className="flex items-center justify-between font-mono text-[0.6rem] tracking-[0.15em] uppercase">
                  <span className="text-fg-dim">{f.name || (f.kind === "base" ? "Forma base" : "Forma lenda")}</span>
                  {active && <span className="text-cyan">● Ativa</span>}
                </p>
              )}
              <Meter label="PV" cur={f.pv_current} max={max.pv} />
              <Adjuster
                disabled={locked || busy}
                minusLabel="Dano"
                plusLabel="Cura"
                onApply={(d) => act(() => agentAdjust(campaignId, c.id, f.id, "pv", d), (r) => r && patchForm(f.id, { pv_current: r.value }), true)}
              />
              {!prodigio && (
                <>
                  <Meter label="PC" cur={f.pc_current} max={max.pc} tone="pc" />
                  <Adjuster
                    disabled={locked || busy}
                    minusLabel="Gastar"
                    plusLabel="Recup."
                    onApply={(d) => act(() => agentAdjust(campaignId, c.id, f.id, "pc", d), (r) => r && patchForm(f.id, { pc_current: r.value }), true)}
                  />
                </>
              )}
              <ConditionChips
                conditions={f.conditions}
                busy={busy}
                size="sm"
                onAdd={locked ? undefined : (name, turns) => act(() => agentCondition(campaignId, f.id, "add", { name, turns }), (list) => list && patchForm(f.id, { conditions: list }), true)}
                onRemove={locked ? undefined : (id) => act(() => agentCondition(campaignId, f.id, "remove", { id }), (list) => list && patchForm(f.id, { conditions: list }), true)}
              />
            </div>
          );
        })}
      </div>
      <GiveItemModal open={give} onClose={() => setGive(false)} campaignId={campaignId} characterId={c.id} name={c.name} homebrew={homebrew} />
    </article>
  );
}

function GiveItemModal({ open, onClose, campaignId, characterId, name, homebrew }: { open: boolean; onClose: () => void; campaignId: string; characterId: string; name: string; homebrew: ShieldHomebrew[] }) {
  const { act, busy } = useAct();
  const [pick, setPick] = useState("");
  const own = homebrew.filter((h) => h.kind === "item" || h.kind === "arma");
  return (
    <Modal open={open} onClose={onClose} title={`Dar item a ${name}`} size="md">
      <div className="space-y-4">
        <select className="field-input" value={pick} onChange={(e) => setPick(e.target.value)} aria-label="Item">
          <option value="">Escolha…</option>
          {own.length > 0 && (
            <optgroup label="Meu Homebrew">
              {own.map((h) => (
                <option key={h.id} value={`hb:${h.id}`}>
                  {h.name} ({h.kind})
                </option>
              ))}
            </optgroup>
          )}
          <optgroup label="Catálogo do sistema">
            {CATALOG.map((c) => (
              <option key={c.id} value={`cat:${c.id}`}>
                {c.name}
              </option>
            ))}
          </optgroup>
        </select>
        <p className="text-xs text-fg-muted">Cria uma cópia independente no inventário do personagem — o modelo não muda.</p>
        <div className="flex justify-end gap-2">
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button
            loading={busy}
            disabled={!pick}
            onClick={() => {
              const [k, id] = pick.split(":");
              act(() => giveItem(campaignId, characterId, k === "hb" ? { homebrewId: id } : { catalogId: id }), () => {
                setPick("");
                onClose();
              });
            }}
          >
            Entregar
          </Button>
        </div>
      </div>
    </Modal>
  );
}

// ===================================================================== NPCs

function NpcSection({ campaignId, npcs, setNpcs, homebrew }: { campaignId: string; npcs: NpcRow[]; setNpcs: (f: (n: NpcRow[]) => NpcRow[]) => void; homebrew: ShieldHomebrew[] }) {
  const { act, busy } = useAct();
  const [editing, setEditing] = useState<NpcRow | "new" | null>(null);
  const [hb, setHb] = useState("");
  const models = homebrew.filter((h) => h.kind === "npc" || h.kind === "monstro");
  const upsert = (n?: NpcRow) => n && setNpcs((list) => (list.some((x) => x.id === n.id) ? list.map((x) => (x.id === n.id ? n : x)) : [...list, n]));

  return (
    <section>
      <SectionTitle
        right={
          <div className="flex flex-wrap items-center gap-2">
            {models.length > 0 && (
              <>
                <select className="field-input w-auto py-1 text-xs" value={hb} onChange={(e) => setHb(e.target.value)} aria-label="Modelo do Homebrew">
                  <option value="">Do Homebrew…</option>
                  {models.map((m) => (
                    <option key={m.id} value={m.id}>
                      {m.name} ({m.kind})
                    </option>
                  ))}
                </select>
                <Button size="sm" variant="secondary" disabled={!hb} loading={busy} onClick={() => act(() => npcFromHomebrew(campaignId, hb), (n) => (upsert(n), setHb("")))}>
                  Usar modelo
                </Button>
              </>
            )}
            <Button size="sm" onClick={() => setEditing("new")}>
              <Plus className="h-3.5 w-3.5" aria-hidden /> Novo NPC / monstro
            </Button>
          </div>
        }
      >
        NPCs e monstros ({npcs.length})
      </SectionTitle>
      {npcs.length === 0 ? (
        <Empty>Crie NPCs e monstros desta campanha ou instancie um modelo do seu Homebrew.</Empty>
      ) : (
        <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
          {npcs.map((n) => (
            <NpcCard key={n.id} campaignId={campaignId} npc={n} onChange={upsert} onEdit={() => setEditing(n)} onDeleted={() => setNpcs((l) => l.filter((x) => x.id !== n.id))} />
          ))}
        </div>
      )}
      {editing && <NpcEditor campaignId={campaignId} npc={editing === "new" ? null : editing} onClose={() => setEditing(null)} onSaved={(n) => (upsert(n), setEditing(null))} />}
    </section>
  );
}

function NpcCard({ campaignId, npc, onChange, onEdit, onDeleted }: { campaignId: string; npc: NpcRow; onChange: (n?: NpcRow) => void; onEdit: () => void; onDeleted: () => void }) {
  const { act, busy } = useAct();
  const toast = useToast();
  const [confirm, setConfirm] = useState(false);
  const [publicLog, setPublicLog] = useState(false);
  const down = npc.pv_current === 0;
  return (
    <article className={`border p-3 ${npc.kind === "monstro" ? "border-alert/40" : "border-line-strong"} bg-panel-2/40`}>
      <header className="mb-2 flex items-start justify-between gap-2">
        <div className="min-w-0">
          <h4 className={`truncate ${down ? "text-fg-muted line-through" : "text-fg"}`}>
            {down && <Skull className="mr-1 inline h-3.5 w-3.5 text-alert" aria-hidden />}
            {npc.name}
          </h4>
          <p className="font-mono text-[0.58rem] tracking-[0.15em] text-fg-muted uppercase">
            {npc.kind === "monstro" ? "Monstro" : "NPC"}
            {npc.source_homebrew_id && " · Homebrew"}
            {npc.visible_to_players && " · visível"}
          </p>
        </div>
        <div className="flex gap-1">
          <button type="button" onClick={onEdit} className="p-1 text-fg-muted hover:text-cyan" aria-label="Editar">
            <Pencil className="h-3.5 w-3.5" />
          </button>
          <button type="button" onClick={() => setConfirm(true)} className="p-1 text-fg-muted hover:text-alert" aria-label="Excluir">
            <Trash2 className="h-3.5 w-3.5" />
          </button>
        </div>
      </header>
      <div className="space-y-2">
        {npc.pv_max != null && (
          <>
            <Meter label="PV" cur={npc.pv_current} max={npc.pv_max} />
            <Adjuster disabled={busy} minusLabel="Dano" plusLabel="Cura" onApply={(d) => act(() => npcAdjust(campaignId, npc.id, "pv", d), onChange, true)} />
          </>
        )}
        {npc.pc_max != null && (
          <>
            <Meter label="PC" cur={npc.pc_current} max={npc.pc_max} tone="pc" />
            <Adjuster disabled={busy} minusLabel="Gastar" plusLabel="Recup." onApply={(d) => act(() => npcAdjust(campaignId, npc.id, "pc", d), onChange, true)} />
          </>
        )}
        <ConditionChips
          conditions={npc.conditions ?? []}
          size="sm"
          busy={busy}
          onAdd={(name, turns) => act(() => npcCondition(campaignId, npc.id, "add", { name, turns }), onChange, true)}
          onRemove={(id) => act(() => npcCondition(campaignId, npc.id, "remove", { id }), onChange, true)}
        />
        {(npc.data.attacks?.length ?? 0) > 0 && (
          <div className="space-y-1 border-t border-line/50 pt-2">
            <div className="flex items-center justify-between">
              <p className="label-mono">Ataques</p>
              <label className="flex items-center gap-1 text-[0.65rem] text-fg-muted">
                <input type="checkbox" className="accent-[var(--color-holo)]" checked={publicLog} onChange={(e) => setPublicLog(e.target.checked)} /> rolagem pública
              </label>
            </div>
            {npc.data.attacks!.map((a, i) => (
              <button
                key={i}
                type="button"
                disabled={busy}
                onClick={() =>
                  act(
                    () => npcAttack(campaignId, npc.name, a, null, publicLog),
                    (r) => {
                      const res = (r as { result?: { natural?: number; outcomeLabel?: string; hit?: boolean; finalDamage?: number } } | undefined)?.result;
                      if (res) toast(`${a.name}: ${res.natural} — ${res.outcomeLabel}${res.hit ? ` · ${res.finalDamage} de dano` : ""}`);
                    },
                    true,
                  )
                }
                className="flex w-full items-center justify-between gap-2 border border-line/60 px-2 py-1 text-left text-xs hover:border-cyan disabled:opacity-50"
              >
                <span className="flex items-center gap-1.5 text-fg">
                  <Crosshair className="h-3 w-3 text-cyan" aria-hidden /> {a.name}
                </span>
                <span className="font-mono text-fg-dim">
                  {a.skill}% · {a.damage}
                </span>
              </button>
            ))}
          </div>
        )}
        {npc.data.abilities && <p className="text-xs whitespace-pre-line text-fg-dim">{npc.data.abilities}</p>}
      </div>
      <ConfirmDialog
        open={confirm}
        title={`Excluir ${npc.name}?`}
        description="Os participantes de combate criados a partir dele continuam no histórico."
        confirmLabel="Excluir"
        loading={busy}
        onCancel={() => setConfirm(false)}
        onConfirm={() => act(() => deleteNpc(campaignId, npc.id), () => (setConfirm(false), onDeleted()))}
      />
    </article>
  );
}

type AttackDraft = { name: string; skill: string; damage: string };

function NpcEditor({ campaignId, npc, onClose, onSaved }: { campaignId: string; npc: NpcRow | null; onClose: () => void; onSaved: (n: NpcRow) => void }) {
  const { act, busy } = useAct();
  const [kind, setKind] = useState<NpcRow["kind"]>(npc?.kind ?? "npc");
  const [name, setName] = useState(npc?.name ?? "");
  const [pv, setPv] = useState(npc?.pv_max?.toString() ?? "");
  const [pc, setPc] = useState(npc?.pc_max?.toString() ?? "");
  const [visible, setVisible] = useState(npc?.visible_to_players ?? false);
  const [description, setDescription] = useState(npc?.data.description ?? "");
  const [abilities, setAbilities] = useState(npc?.data.abilities ?? "");
  const [notes, setNotes] = useState(npc?.data.notes ?? "");
  const [attrs, setAttrs] = useState<Record<string, string>>(() => Object.fromEntries(Object.entries(npc?.data.attributes ?? {}).map(([k, v]) => [k, String(v ?? "")])));
  const [attacks, setAttacks] = useState<AttackDraft[]>(() => (npc?.data.attacks ?? []).map((a) => ({ name: a.name, skill: String(a.skill), damage: a.damage })));
  const num = (s: string) => (s.trim() === "" ? null : Number.parseInt(s, 10));
  const badAttack = useMemo(() => attacks.some((a) => !a.name.trim() || !Number.isInteger(Number(a.skill)) || !isValidDice(a.damage.trim())), [attacks]);

  function submit(e: React.FormEvent) {
    e.preventDefault();
    const attributes: Record<string, number> = {};
    for (const [k, v] of Object.entries(attrs)) if (v.trim() !== "" && Number.isInteger(Number(v))) attributes[k] = Number(v);
    const input: NpcInput = {
      kind,
      name,
      pv_max: num(pv),
      pc_max: num(pc),
      visible_to_players: visible,
      data: {
        description,
        abilities,
        notes,
        attributes,
        attacks: attacks.map((a) => ({ name: a.name.trim(), skill: Number(a.skill), damage: a.damage.trim() })),
      },
    };
    act(() => saveNpc(campaignId, input, npc?.id), (n) => n && onSaved(n));
  }

  return (
    <Modal open onClose={onClose} title={npc ? `Editar ${npc.name}` : "Novo NPC / monstro"} size="xl">
      <form onSubmit={submit} className="space-y-4">
        <div className="grid gap-3 sm:grid-cols-[auto_1fr_6rem_6rem]">
          <select className="field-input" value={kind} onChange={(e) => setKind(e.target.value as NpcRow["kind"])} aria-label="Tipo">
            <option value="npc">NPC</option>
            <option value="monstro">Monstro</option>
          </select>
          <input className="field-input" required maxLength={120} value={name} onChange={(e) => setName(e.target.value)} placeholder="Nome" aria-label="Nome" />
          <input className="field-input" inputMode="numeric" value={pv} onChange={(e) => setPv(e.target.value.replace(/\D/g, ""))} placeholder="PV máx." aria-label="PV máximo" />
          <input className="field-input" inputMode="numeric" value={pc} onChange={(e) => setPc(e.target.value.replace(/\D/g, ""))} placeholder="PC máx." aria-label="PC máximo" />
        </div>
        <textarea className="field-input" rows={2} value={description} onChange={(e) => setDescription(e.target.value)} placeholder="Descrição" aria-label="Descrição" />
        <fieldset>
          <legend className="label-mono mb-1">Atributos (opcional)</legend>
          <div className="grid grid-cols-4 gap-2 sm:grid-cols-8">
            {ATTRIBUTES.map((a) => (
              <label key={a.id} className="text-center text-[0.6rem] text-fg-muted uppercase">
                {a.id}
                <input className="field-input px-1 text-center text-xs" inputMode="numeric" value={attrs[a.id] ?? ""} onChange={(e) => setAttrs({ ...attrs, [a.id]: e.target.value.replace(/\D/g, "").slice(0, 3) })} />
              </label>
            ))}
          </div>
        </fieldset>
        <fieldset className="space-y-2">
          <legend className="label-mono mb-1">Ataques (valor do teste d100 e dano)</legend>
          {attacks.map((a, i) => (
            <div key={i} className="grid grid-cols-[1fr_5rem_7rem_auto] gap-2">
              <input className="field-input text-sm" value={a.name} placeholder="Garras" onChange={(e) => setAttacks(attacks.map((x, j) => (j === i ? { ...x, name: e.target.value } : x)))} aria-label="Nome do ataque" />
              <input className="field-input text-sm" inputMode="numeric" value={a.skill} placeholder="%" onChange={(e) => setAttacks(attacks.map((x, j) => (j === i ? { ...x, skill: e.target.value.replace(/\D/g, "").slice(0, 3) } : x)))} aria-label="Valor" />
              <input
                className="field-input font-mono text-sm"
                value={a.damage}
                placeholder="1d8+2"
                aria-invalid={a.damage !== "" && !isValidDice(a.damage.trim()) ? true : undefined}
                onChange={(e) => setAttacks(attacks.map((x, j) => (j === i ? { ...x, damage: e.target.value } : x)))}
                aria-label="Dano"
              />
              <button type="button" className="px-2 text-fg-muted hover:text-alert" onClick={() => setAttacks(attacks.filter((_, j) => j !== i))} aria-label="Remover ataque">
                <Trash2 className="h-4 w-4" />
              </button>
            </div>
          ))}
          {attacks.length < 12 && (
            <Button type="button" size="sm" variant="ghost" onClick={() => setAttacks([...attacks, { name: "", skill: "50", damage: "1d6" }])}>
              <Plus className="h-3.5 w-3.5" aria-hidden /> Ataque
            </Button>
          )}
        </fieldset>
        <textarea className="field-input" rows={3} value={abilities} onChange={(e) => setAbilities(e.target.value)} placeholder="Habilidades e poderes" aria-label="Habilidades" />
        <textarea className="field-input" rows={2} value={notes} onChange={(e) => setNotes(e.target.value)} placeholder="Notas do Mestre" aria-label="Notas" />
        <label className="flex items-center gap-2 text-sm text-fg-dim">
          <input type="checkbox" className="accent-[var(--color-holo)]" checked={visible} onChange={(e) => setVisible(e.target.checked)} /> Visível para os jogadores
        </label>
        <div className="flex justify-end gap-2">
          <Button type="button" variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button type="submit" loading={busy} disabled={badAttack || !name.trim()}>
            Salvar
          </Button>
        </div>
      </form>
    </Modal>
  );
}
