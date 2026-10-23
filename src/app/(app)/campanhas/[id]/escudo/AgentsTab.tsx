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
import { CATALOG } from "@/rules/catalog.ts";
import { creatureSummary, normalizeCreature, testValue } from "@/rules/creatures.ts";
import { HoloFrame, ImageField } from "@/components/media/ImageField";
import { uploadMedia, useMediaUrl } from "@/components/media/media-client";
import { CreatureFields } from "@/components/homebrew/CreatureFields";
import { campaignNpcDefaults, type CampaignNpcFormValue } from "@/lib/homebrew";
import { mediaPath } from "@/lib/media-shared";
import type { HomebrewEntry } from "@/lib/types";
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
        <AgentPortrait agent={agent} />
        <div className="min-w-0 flex-1">
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

function AgentPortrait({ agent }: { agent: AgentRow }) {
  const active = agent.forms.find((f) => f.kind === (agent.character.active_form ?? "base") && (f.kind === "base" || f.setup_complete)) ?? agent.forms.find((f) => f.kind === "base");
  const url = useMediaUrl(active?.portrait_path ?? null);
  return (
    <div className="w-14 shrink-0">
      <HoloFrame url={url} alt={`Foto de ${agent.character.name}`} variant={active?.kind === "lenda" ? "corrupted" : "holo"} />
    </div>
  );
}

function GiveItemModal({ open, onClose, campaignId, characterId, name, homebrew }: { open: boolean; onClose: () => void; campaignId: string; characterId: string; name: string; homebrew: ShieldHomebrew[] }) {
  const { act, busy } = useAct();
  const [pick, setPick] = useState("");
  const own = homebrew.filter((h) => h.kind === "item" || h.kind === "arma" || h.kind === "item_especial" || h.kind === "outro");
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
                  Adicionar à campanha
                </Button>
              </>
            )}
            <Button size="sm" onClick={() => setEditing("new")}>
              <Plus className="h-3.5 w-3.5" aria-hidden /> Novo NPC / monstro
            </Button>
          </div>
        }
      >
        NPCs e monstros da campanha ({npcs.length})
      </SectionTitle>
      {npcs.length === 0 ? (
        <Empty>Crie NPCs e monstros desta campanha ou adicione um modelo do seu Homebrew (cópia independente).</Empty>
      ) : (
        <div className="grid gap-3 md:grid-cols-2 xl:grid-cols-3">
          {npcs.map((n) => (
            <NpcCard key={n.id} campaignId={campaignId} npc={n} onChange={upsert} onEdit={() => setEditing(n)} onDeleted={() => setNpcs((l) => l.filter((x) => x.id !== n.id))} />
          ))}
        </div>
      )}
      {editing && <NpcEditor campaignId={campaignId} npc={editing === "new" ? null : editing} library={homebrew} onClose={() => setEditing(null)} onSaved={(n) => (upsert(n), setEditing(null))} />}
    </section>
  );
}

function NpcCard({ campaignId, npc, onChange, onEdit, onDeleted }: { campaignId: string; npc: NpcRow; onChange: (n?: NpcRow) => void; onEdit: () => void; onDeleted: () => void }) {
  const { act, busy } = useAct();
  const toast = useToast();
  const [confirm, setConfirm] = useState(false);
  const [publicLog, setPublicLog] = useState(false);
  const url = useMediaUrl(npc.image_path);
  const sheet = useMemo(() => normalizeCreature(npc.data), [npc.data]);
  const down = npc.pv_current === 0;
  return (
    <article className={`border p-3 ${npc.kind === "monstro" ? "border-alert/40" : "border-line-strong"} bg-panel-2/40`}>
      <header className="mb-2 flex items-start gap-3">
        <div className="w-14 shrink-0">
          <HoloFrame url={url} alt={npc.name} fallback={npc.kind === "monstro" ? <Skull className="h-1/3 w-1/3" /> : undefined} />
        </div>
        <div className="min-w-0 flex-1">
          <h4 className={`truncate ${down ? "text-fg-muted line-through" : "text-fg"}`}>
            {down && <Skull className="mr-1 inline h-3.5 w-3.5 text-alert" aria-hidden />}
            {npc.name}
          </h4>
          <p className="font-mono text-[0.58rem] tracking-[0.15em] text-fg-muted uppercase">
            {npc.kind === "monstro" ? "Monstro" : "NPC"}
            {npc.source_homebrew_id && " · Homebrew"}
            {npc.visible_to_players ? " · visível" : " · secreto"}
          </p>
          <p className="truncate text-[0.65rem] text-fg-dim">{creatureSummary(sheet)}</p>
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
        {sheet.attacks.length > 0 && (
          <div className="space-y-1 border-t border-line/50 pt-2">
            <div className="flex items-center justify-between">
              <p className="label-mono">Ataques</p>
              <label className="flex items-center gap-1 text-[0.65rem] text-fg-muted">
                <input type="checkbox" className="accent-[var(--color-holo)]" checked={publicLog} onChange={(e) => setPublicLog(e.target.checked)} /> rolagem pública
              </label>
            </div>
            {sheet.attacks.map((a) => {
              const value = testValue(sheet, a.uses, a.value);
              return (
                <button
                  key={a.id}
                  type="button"
                  disabled={busy}
                  onClick={() =>
                    act(
                      () => npcAttack(campaignId, npc.name, { name: a.name, skill: value, damage: a.damage }, null, publicLog),
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
                    {value}% · {a.damage}
                  </span>
                </button>
              );
            })}
          </div>
        )}
        {sheet.abilities.length > 0 && <p className="text-xs text-fg-dim">Habilidades: {sheet.abilities.map((a) => a.name).join(", ")} — use-as no combate.</p>}
      </div>
      <ConfirmDialog
        open={confirm}
        title={`Excluir ${npc.name}?`}
        description="As instâncias deste NPC em combates continuam com o estado que têm."
        confirmLabel="Excluir"
        loading={busy}
        onCancel={() => setConfirm(false)}
        onConfirm={() => act(() => deleteNpc(campaignId, npc.id), () => (setConfirm(false), onDeleted()))}
      />
    </article>
  );
}

/** Editor do NPC/monstro DA CAMPANHA (instância): mesma ficha de criatura do Homebrew. */
function NpcEditor({ campaignId, npc, library, onClose, onSaved }: { campaignId: string; npc: NpcRow | null; library: ShieldHomebrew[]; onClose: () => void; onSaved: (n: NpcRow) => void }) {
  const { act, busy } = useAct();
  const toast = useToast();
  const [kind, setKind] = useState<NpcRow["kind"]>(npc?.kind ?? "npc");
  const [name, setName] = useState(npc?.name ?? "");
  const [visible, setVisible] = useState(npc?.visible_to_players ?? false);
  const [image, setImage] = useState<string | null>(npc?.image_path ?? null);
  const url = useMediaUrl(image);
  const [data, setData] = useState<CampaignNpcFormValue>(() => {
    const d = campaignNpcDefaults(npc?.data);
    // O PV/PC atuais da campanha ficam nas colunas do NPC.
    return npc ? { ...d, pv_max: npc.pv_max, pc_max: npc.pc_max, pv_current: npc.pv_current, pc_current: npc.pc_current } : d;
  });

  function submit(e: React.FormEvent) {
    e.preventDefault();
    const input: NpcInput = { kind, name, visible_to_players: visible, image_path: image, data };
    act(() => saveNpc(campaignId, input, npc?.id), (n) => n && onSaved(n));
  }

  return (
    <Modal open onClose={onClose} title={npc ? `Editar ${npc.name}` : "Novo NPC / monstro"} size="xl">
      <form onSubmit={submit} className="space-y-4">
        <div className="grid gap-4 sm:grid-cols-[9rem_1fr]">
          <ImageField
            url={url}
            label="Imagem"
            onUpload={async (blob, ext) => {
              const path = mediaPath("npcs", campaignId, kind, ext);
              const up = await uploadMedia(path, blob);
              if (!up.ok) {
                toast(up.error, "error");
                return false;
              }
              setImage(path);
              return true;
            }}
            onRemove={() => setImage(null)}
          />
          <div className="space-y-3">
            <div className="grid gap-3 sm:grid-cols-[auto_1fr]">
              <select className="field-input" value={kind} onChange={(e) => setKind(e.target.value as NpcRow["kind"])} aria-label="Tipo">
                <option value="npc">NPC</option>
                <option value="monstro">Monstro</option>
              </select>
              <input className="field-input" required maxLength={120} value={name} onChange={(e) => setName(e.target.value)} placeholder="Nome" aria-label="Nome" />
            </div>
            <textarea className="field-input" rows={2} value={data.description} onChange={(e) => setData({ ...data, description: e.target.value })} placeholder="Descrição (os jogadores veem se o NPC estiver visível)" aria-label="Descrição" />
            <textarea className="field-input" rows={2} value={data.appearance} onChange={(e) => setData({ ...data, appearance: e.target.value })} placeholder="Aparência (visível)" aria-label="Aparência" />
            <textarea className="field-input border-alert/40" rows={2} value={data.master_notes} onChange={(e) => setData({ ...data, master_notes: e.target.value })} placeholder="Segredos do Mestre (nunca vão para os jogadores)" aria-label="Segredos" />
            <label className="flex items-center gap-2 text-sm text-fg-dim">
              <input type="checkbox" className="accent-[var(--color-holo)]" checked={visible} onChange={(e) => setVisible(e.target.checked)} /> Visível para os jogadores (nome, imagem, descrição e aparência)
            </label>
          </div>
        </div>
        <CreatureFields value={data} onChange={setData} library={library as unknown as HomebrewEntry[]} showInventory />
        <div className="flex justify-end gap-2">
          <Button type="button" variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button type="submit" loading={busy} disabled={!name.trim()}>
            Salvar
          </Button>
        </div>
      </form>
    </Modal>
  );
}
