"use client";

import { useCallback, useEffect, useMemo, useState } from "react";
import { ArrowDown, ArrowUp, ChevronLeft, ChevronRight, Crosshair, Dice5, Eye, EyeOff, Flag, Play, Plus, RotateCcw, Skull, Swords, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { useToast } from "@/components/ui/Toast";
import { ConditionChips } from "@/components/campaign/ConditionChips";
import type { AgentRow, CombatantRow, CombatLogRow, CombatRow, NpcRow } from "@/lib/campaign-types";
import {
  addCombatant,
  combatApply,
  combatCondition,
  combatControl,
  combatNote,
  createCombat,
  deleteCombat,
  fetchCombat,
  npcAttack,
  removeCombatant,
  rollInitiative,
  setCombatOrder,
  updateCombatant,
} from "../../shield-actions";
import { formMax } from "./AgentsTab";
import { Adjuster, Empty, Meter, SectionTitle, newId, useAct } from "./kit";

const MODE_LABEL: Record<CombatRow["initiative_mode"], string> = {
  manual: "Manual (o Mestre define)",
  reflexo: "Perícia Reflexo (regra da mesa)",
  d20: "1d20 por participante (regra da mesa)",
};
const STATUS_LABEL: Record<CombatRow["status"], string> = { paused: "Em preparação", active: "Em andamento", ended: "Encerrado" };

const orderOf = (list: CombatantRow[]) =>
  [...list].sort((a, b) => a.sort_order - b.sort_order || (b.initiative ?? -1e9) - (a.initiative ?? -1e9) || a.name.localeCompare(b.name));

export function CombatTab({
  campaignId,
  initialCombats,
  initialCombatants,
  initialLog,
  agents,
  npcs,
  tick,
}: {
  campaignId: string;
  initialCombats: CombatRow[];
  initialCombatants: CombatantRow[];
  initialLog: CombatLogRow[];
  agents: AgentRow[];
  npcs: NpcRow[];
  tick: number;
}) {
  const toast = useToast();
  const { act, busy } = useAct();
  const [combats, setCombats] = useState(initialCombats);
  const [combatants, setCombatants] = useState(initialCombatants);
  const [log, setLog] = useState(initialLog);
  const [selected, setSelected] = useState<string | null>(initialCombats.find((c) => c.status !== "ended")?.id ?? initialCombats[0]?.id ?? null);
  const [newName, setNewName] = useState("");
  const [newMode, setNewMode] = useState<CombatRow["initiative_mode"]>("manual");
  const [confirmEnd, setConfirmEnd] = useState(false);
  const [confirmDelete, setConfirmDelete] = useState(false);

  const combat = combats.find((c) => c.id === selected) ?? null;
  const list = useMemo(() => orderOf(combatants.filter((c) => c.combat_id === selected)), [combatants, selected]);
  const current = combat?.status === "active" ? list[Math.min(combat.turn_index, list.length - 1)] : undefined;
  const entries = log.filter((l) => l.combat_id === selected).sort((a, b) => b.id - a.id);

  const reload = useCallback(
    async (id = selected) => {
      if (!id) return;
      const r = await fetchCombat(campaignId, id);
      if (!r.ok || !r.data) return;
      const d = r.data;
      setCombats((cs) => (cs.some((c) => c.id === d.combat.id) ? cs.map((c) => (c.id === d.combat.id ? d.combat : c)) : [d.combat, ...cs]));
      setCombatants((cs) => [...cs.filter((c) => c.combat_id !== id), ...d.combatants]);
      setLog((ls) => [...ls.filter((l) => l.combat_id !== id), ...(d.log as CombatLogRow[])]);
    },
    [campaignId, selected],
  );
  // Mudança vinda do Realtime (outro aparelho, jogador agindo, reconexão): recarrega o estado salvo.
  useEffect(() => {
    if (tick > 0) void reload();
  }, [tick, reload]);

  function control(action: Parameters<typeof combatControl>[2]) {
    if (!combat) return;
    act(
      () => combatControl(campaignId, combat.id, action, combat.version),
      () => void reload(),
      true,
    );
  }

  // PV/PC dos personagens vêm da ficha (forma usada no combate), sempre atualizados.
  function liveStats(c: CombatantRow) {
    const own = { pv: c.pv_current, pvMax: c.pv_max, pc: c.pc_current, pcMax: c.pc_max, prodigio: false, conditions: c.conditions ?? [] };
    if (!c.character_id) return own;
    const a = agents.find((x) => x.character.id === c.character_id);
    const f = a?.forms.find((x) => x.id === c.form_id) ?? a?.forms.find((x) => x.kind === (a?.character.active_form ?? "base"));
    if (!a || !f) return own;
    const m = formMax(a, f);
    // Condições de agentes ficam na ficha (forma), não no participante.
    return { pv: f.pv_current, pvMax: m.pv, pc: f.pc_current, pcMax: m.pc, prodigio: a.character.origin_id === "prodigio", conditions: f.conditions ?? [] };
  }

  return (
    <div className="space-y-6">
      <div className="grid gap-4 lg:grid-cols-[16rem_1fr]">
        <aside className="space-y-3">
          <SectionTitle>Combates</SectionTitle>
          <form
            className="space-y-2 border border-line/70 p-3"
            onSubmit={(e) => {
              e.preventDefault();
              act(
                () => createCombat(campaignId, newName || "Combate", newMode),
                (cb) => {
                  if (!cb) return;
                  setCombats((cs) => [cb, ...cs]);
                  setSelected(cb.id);
                  setNewName("");
                },
              );
            }}
          >
            <input className="field-input text-sm" maxLength={120} value={newName} onChange={(e) => setNewName(e.target.value)} placeholder="Nome do combate" aria-label="Nome do combate" />
            <select className="field-input text-xs" value={newMode} onChange={(e) => setNewMode(e.target.value as CombatRow["initiative_mode"])} aria-label="Iniciativa">
              {Object.entries(MODE_LABEL).map(([k, v]) => (
                <option key={k} value={k}>
                  {v}
                </option>
              ))}
            </select>
            <Button type="submit" size="sm" loading={busy} className="w-full">
              <Plus className="h-3.5 w-3.5" aria-hidden /> Criar combate
            </Button>
            <p className="text-[0.65rem] text-fg-muted">O livro não define iniciativa: os modos automáticos são regras da mesa e a ordem sempre pode ser ajustada.</p>
          </form>
          <ul className="space-y-1">
            {combats.map((c) => (
              <li key={c.id}>
                <button
                  type="button"
                  onClick={() => {
                    setSelected(c.id);
                    void reload(c.id);
                  }}
                  className={`w-full border px-3 py-2 text-left text-sm ${c.id === selected ? "border-cyan bg-cyan/10 text-fg" : "border-line/60 text-fg-dim hover:border-line-strong"}`}
                >
                  <span className="block truncate">{c.name}</span>
                  <span className={`font-mono text-[0.58rem] tracking-[0.15em] uppercase ${c.status === "active" ? "text-ok" : "text-fg-muted"}`}>
                    {STATUS_LABEL[c.status]}
                    {c.status === "active" && ` · R${c.round}`}
                  </span>
                </button>
              </li>
            ))}
          </ul>
        </aside>

        {!combat ? (
          <Empty>Crie um combate para começar.</Empty>
        ) : (
          <section className="space-y-4">
            <div className="hud-panel space-y-3 p-4">
              <div className="flex flex-wrap items-center justify-between gap-3">
                <div>
                  <h2 className="flex items-center gap-2 text-xl tracking-[0.06em] text-fg uppercase">
                    <Swords className="h-5 w-5 text-holo" aria-hidden /> {combat.name}
                  </h2>
                  <p className="font-mono text-[0.6rem] tracking-[0.15em] text-fg-muted uppercase">
                    {STATUS_LABEL[combat.status]} · Iniciativa: {MODE_LABEL[combat.initiative_mode]}
                  </p>
                </div>
                <div className="flex items-center gap-4 font-mono uppercase">
                  <div className="text-center">
                    <p className="text-[0.55rem] tracking-[0.2em] text-fg-muted">Rodada</p>
                    <p className="text-3xl leading-none text-cyan tabular-nums text-glow">{combat.status === "paused" ? "—" : combat.round}</p>
                  </div>
                  <div className="min-w-32 text-center">
                    <p className="text-[0.55rem] tracking-[0.2em] text-fg-muted">Turno de</p>
                    <p className="truncate text-sm text-fg">{current?.name ?? "—"}</p>
                  </div>
                </div>
              </div>
              <div className="flex flex-wrap gap-2">
                {combat.status === "paused" && (
                  <Button onClick={() => control("start")} loading={busy} disabled={list.length === 0}>
                    <Play className="h-4 w-4" aria-hidden /> Iniciar combate
                  </Button>
                )}
                {combat.status === "active" && (
                  <>
                    <Button variant="secondary" onClick={() => control("prev")} disabled={busy}>
                      <ChevronLeft className="h-4 w-4" aria-hidden /> Voltar turno
                    </Button>
                    <Button onClick={() => control("next")} disabled={busy}>
                      Próximo turno <ChevronRight className="h-4 w-4" aria-hidden />
                    </Button>
                    <Button variant="secondary" onClick={() => control("new_round")} disabled={busy}>
                      <RotateCcw className="h-4 w-4" aria-hidden /> Nova rodada
                    </Button>
                    <Button variant="danger" onClick={() => setConfirmEnd(true)} disabled={busy}>
                      <Flag className="h-4 w-4" aria-hidden /> Encerrar combate
                    </Button>
                  </>
                )}
                {combat.status === "ended" && (
                  <>
                    <Button variant="secondary" onClick={() => control("reopen")} loading={busy}>
                      Reabrir
                    </Button>
                    <Button variant="ghost" onClick={() => setConfirmDelete(true)}>
                      <Trash2 className="h-4 w-4" aria-hidden /> Excluir
                    </Button>
                  </>
                )}
                {combat.status !== "ended" && (
                  <Button variant="ghost" onClick={() => act(() => rollInitiative(campaignId, combat.id), () => void reload())} disabled={busy || list.length === 0}>
                    <Dice5 className="h-4 w-4" aria-hidden /> {combat.initiative_mode === "manual" ? "Ordenar pela iniciativa" : "Rolar iniciativa"}
                  </Button>
                )}
              </div>
              <p className="text-[0.65rem] text-fg-muted">
                No início do turno de cada personagem o sistema cobra a manutenção dos poderes contínuos ativos; condições com duração perdem 1 turno ao fim do turno de quem as tem.
              </p>
            </div>

            {list.length === 0 ? (
              <Empty>Adicione participantes abaixo.</Empty>
            ) : (
              <ol className="space-y-2">
                {list.map((c, i) => (
                  <CombatantCard
                    key={c.id}
                    campaignId={campaignId}
                    combat={combat}
                    c={c}
                    index={i}
                    total={list.length}
                    active={current?.id === c.id}
                    stats={liveStats(c)}
                    npc={c.npc_id ? npcs.find((n) => n.id === c.npc_id) : undefined}
                    onMove={(dir) => {
                      const ids = list.map((x) => x.id);
                      const j = i + dir;
                      [ids[i], ids[j]] = [ids[j], ids[i]];
                      setCombatants((cs) => cs.map((x) => (ids.includes(x.id) ? { ...x, sort_order: ids.indexOf(x.id) } : x)));
                      act(() => setCombatOrder(campaignId, combat.id, ids), () => void reload(), true);
                    }}
                    onChanged={(patch) => {
                      if (patch) setCombatants((cs) => cs.map((x) => (x.id === c.id ? { ...x, ...patch } : x)));
                      void reload();
                    }}
                    onRemoved={() => {
                      setCombatants((cs) => cs.filter((x) => x.id !== c.id));
                      void reload();
                    }}
                  />
                ))}
              </ol>
            )}

            {combat.status !== "ended" && <AddParticipant campaignId={campaignId} combat={combat} agents={agents} npcs={npcs} present={list} onAdded={() => void reload()} />}

            <div className="grid gap-4 lg:grid-cols-2">
              <NoteBox campaignId={campaignId} combatId={combat.id} onDone={() => void reload()} />
              <section>
                <SectionTitle>Histórico do combate</SectionTitle>
                {entries.length === 0 ? (
                  <Empty>Nada registrado ainda.</Empty>
                ) : (
                  <ol className="max-h-96 space-y-1 overflow-y-auto pr-1">
                    {entries.map((l) => (
                      <li key={l.id} className="grid grid-cols-[3.2rem_1fr] gap-2 border-b border-line/40 py-1 text-xs">
                        <span className="font-mono text-[0.6rem] text-fg-muted">R{l.round}·{l.turn_index + 1}</span>
                        <span className="text-fg-dim">
                          {!l.public && <EyeOff className="mr-1 inline h-3 w-3 text-alert" aria-label="só o Mestre" />}
                          {l.message}
                        </span>
                      </li>
                    ))}
                  </ol>
                )}
              </section>
            </div>
          </section>
        )}
      </div>

      <ConfirmDialog
        open={confirmEnd}
        title="Encerrar combate?"
        description="As condições continuam nas fichas. O combate fica no histórico e pode ser reaberto."
        confirmLabel="Encerrar"
        loading={busy}
        onCancel={() => setConfirmEnd(false)}
        onConfirm={() => {
          setConfirmEnd(false);
          control("end");
        }}
      />
      <ConfirmDialog
        open={confirmDelete}
        title="Excluir combate?"
        description="Remove o combate, os participantes e o histórico. As fichas não mudam."
        confirmLabel="Excluir"
        loading={busy}
        onCancel={() => setConfirmDelete(false)}
        onConfirm={() =>
          combat &&
          act(
            () => deleteCombat(campaignId, combat.id),
            () => {
              setConfirmDelete(false);
              setCombats((cs) => cs.filter((c) => c.id !== combat.id));
              setSelected(null);
              toast("Combate excluído.");
            },
            true,
          )
        }
      />
    </div>
  );
}

function CombatantCard({
  campaignId,
  combat,
  c,
  index,
  total,
  active,
  stats,
  npc,
  onMove,
  onChanged,
  onRemoved,
}: {
  campaignId: string;
  combat: CombatRow;
  c: CombatantRow;
  index: number;
  total: number;
  active: boolean;
  stats: { pv: number | null; pvMax: number | null; pc: number | null; pcMax: number | null; prodigio: boolean; conditions: CombatantRow["conditions"] };
  npc?: NpcRow;
  onMove: (dir: -1 | 1) => void;
  onChanged: (patch?: Partial<CombatantRow>) => void;
  onRemoved: () => void;
}) {
  const { act, busy } = useAct();
  const toast = useToast();
  const [ini, setIni] = useState(c.initiative?.toString() ?? "");
  const [publicRoll, setPublicRoll] = useState(false);
  const down = stats.pv === 0;
  const ended = combat.status === "ended";
  const kindLabel = c.character_id ? "Agente" : c.kind === "monstro" ? "Monstro" : c.kind === "npc" ? "NPC" : "Outro";

  function apply(kind: "damage" | "heal" | "pc_spend" | "pc_gain", amount: number) {
    // Um id por clique: se a rede repetir o pedido, o servidor não aplica duas vezes.
    act(() => combatApply(campaignId, c.id, kind, amount, newId()), () => onChanged(), true);
  }

  return (
    <li
      className={`border p-3 transition-colors ${active ? "border-cyan bg-cyan/10 shadow-[0_0_28px_-12px_var(--color-cyan)]" : "border-line/60 bg-panel-2/40"} ${c.hidden ? "border-dashed" : ""}`}
      aria-current={active ? "true" : undefined}
    >
      <div className="flex flex-wrap items-center gap-3">
        <div className="flex flex-col">
          <button type="button" className="text-fg-muted hover:text-cyan disabled:opacity-30" disabled={index === 0 || busy} onClick={() => onMove(-1)} aria-label="Subir na ordem">
            <ArrowUp className="h-3.5 w-3.5" />
          </button>
          <button type="button" className="text-fg-muted hover:text-cyan disabled:opacity-30" disabled={index === total - 1 || busy} onClick={() => onMove(1)} aria-label="Descer na ordem">
            <ArrowDown className="h-3.5 w-3.5" />
          </button>
        </div>
        <span className="font-mono text-sm text-fg-muted tabular-nums">{String(index + 1).padStart(2, "0")}</span>
        <div className="min-w-36 flex-1">
          <p className={`truncate ${down ? "text-fg-muted line-through" : "text-fg"}`}>
            {down && <Skull className="mr-1 inline h-3.5 w-3.5 text-alert" aria-label="caído" />}
            {c.name}
            {active && <span className="ml-2 font-mono text-[0.58rem] tracking-[0.15em] text-cyan uppercase">● agindo</span>}
          </p>
          <p className="font-mono text-[0.58rem] tracking-[0.15em] text-fg-muted uppercase">
            {kindLabel}
            {c.hidden && " · oculto dos jogadores"}
            {c.hide_stats && " · números ocultos"}
          </p>
        </div>
        <label className="flex items-center gap-1 font-mono text-[0.6rem] text-fg-muted uppercase">
          INI
          <input
            className="field-input w-14 px-1 py-0.5 text-center text-xs"
            inputMode="numeric"
            value={ini}
            onChange={(e) => setIni(e.target.value.replace(/[^\d-]/g, "").slice(0, 5))}
            onBlur={() => {
              const v = ini.trim() === "" ? null : Number.parseInt(ini, 10);
              if (v === c.initiative || (v !== null && !Number.isInteger(v))) return;
              act(() => updateCombatant(campaignId, c.id, { initiative: v }), (row) => onChanged(row), true);
            }}
          />
        </label>
        <div className="flex gap-1">
          <button
            type="button"
            className="p-1 text-fg-muted hover:text-cyan"
            onClick={() => act(() => updateCombatant(campaignId, c.id, { hidden: !c.hidden }), (row) => onChanged(row), true)}
            aria-label={c.hidden ? "Mostrar aos jogadores" : "Ocultar dos jogadores"}
            title={c.hidden ? "Mostrar aos jogadores" : "Ocultar dos jogadores"}
          >
            {c.hidden ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
          </button>
          {!c.character_id && (
            <button
              type="button"
              className={`p-1 font-mono text-[0.6rem] ${c.hide_stats ? "text-alert" : "text-fg-muted"} hover:text-cyan`}
              onClick={() => act(() => updateCombatant(campaignId, c.id, { hide_stats: !c.hide_stats }), (row) => onChanged(row), true)}
              title="Ocultar PV/PC dos jogadores"
            >
              #
            </button>
          )}
          <button type="button" className="p-1 text-fg-muted hover:text-alert" onClick={() => act(() => removeCombatant(campaignId, c.id), onRemoved, true)} aria-label="Remover do combate">
            <Trash2 className="h-4 w-4" />
          </button>
        </div>
      </div>

      <div className="mt-2 grid gap-3 md:grid-cols-2">
        <div className="space-y-1.5">
          {stats.pv != null && (
            <>
              <Meter label="PV" cur={stats.pv} max={stats.pvMax} />
              <Adjuster disabled={busy || ended} minusLabel="Dano" plusLabel="Cura" onApply={(d) => apply(d < 0 ? "damage" : "heal", Math.abs(d))} />
            </>
          )}
        </div>
        <div className="space-y-1.5">
          {stats.pc != null && !stats.prodigio && (
            <>
              <Meter label="PC" cur={stats.pc} max={stats.pcMax} tone="pc" />
              <Adjuster disabled={busy || ended} minusLabel="Gastar" plusLabel="Recup." onApply={(d) => apply(d < 0 ? "pc_spend" : "pc_gain", Math.abs(d))} />
            </>
          )}
        </div>
      </div>
      <div className="mt-2">
        <ConditionChips
          conditions={stats.conditions}
          size="sm"
          busy={busy}
          onAdd={ended ? undefined : (name, turns) => act(() => combatCondition(campaignId, c.id, "add", { name, turns }), (conds) => onChanged(conds && !c.character_id ? { conditions: conds } : undefined), true)}
          onRemove={ended ? undefined : (id) => act(() => combatCondition(campaignId, c.id, "remove", { id }), (conds) => onChanged(conds && !c.character_id ? { conditions: conds } : undefined), true)}
        />
      </div>
      {npc && (npc.data.attacks?.length ?? 0) > 0 && !ended && (
        <div className="mt-2 flex flex-wrap items-center gap-1.5 border-t border-line/40 pt-2">
          {npc.data.attacks!.map((a, i) => (
            <button
              key={i}
              type="button"
              disabled={busy}
              onClick={() =>
                act(
                  () => npcAttack(campaignId, c.name, a, combat.id, publicRoll),
                  (r) => {
                    const res = (r as { result?: { natural?: number; outcomeLabel?: string; hit?: boolean; finalDamage?: number } } | undefined)?.result;
                    if (res) toast(`${c.name} — ${a.name}: ${res.natural} (${res.outcomeLabel})${res.hit ? ` · ${res.finalDamage} de dano` : ""}`);
                    onChanged();
                  },
                  true,
                )
              }
              className="inline-flex items-center gap-1 border border-line-strong px-2 py-1 font-mono text-[0.62rem] text-fg hover:border-cyan disabled:opacity-50"
            >
              <Crosshair className="h-3 w-3 text-cyan" aria-hidden /> {a.name} ({a.skill}% · {a.damage})
            </button>
          ))}
          <label className="ml-auto flex items-center gap-1 text-[0.65rem] text-fg-muted">
            <input type="checkbox" className="accent-[var(--color-holo)]" checked={publicRoll} onChange={(e) => setPublicRoll(e.target.checked)} /> rolagem pública
          </label>
        </div>
      )}
      {c.character_id && <p className="mt-1 text-[0.65rem] text-fg-muted">Ataques e poderes do agente são rolados pelo jogador na ficha; o PC é cobrado lá, uma única vez.</p>}
    </li>
  );
}

function AddParticipant({ campaignId, combat, agents, npcs, present, onAdded }: { campaignId: string; combat: CombatRow; agents: AgentRow[]; npcs: NpcRow[]; present: CombatantRow[]; onAdded: () => void }) {
  const { act, busy } = useAct();
  const [pick, setPick] = useState("");
  const [name, setName] = useState("");
  const [pv, setPv] = useState("");
  const [pc, setPc] = useState("");
  const [ini, setIni] = useState("");
  const freeAgents = agents.filter((a) => !present.some((p) => p.character_id === a.character.id));
  const initiative = ini.trim() === "" ? null : Number.parseInt(ini, 10);

  function add() {
    const [k, id] = pick.split(":");
    const who = k === "char" ? { characterId: id } : k === "npc" ? { npcId: id } : { name, pv: pv ? Number(pv) : null, pc: pc ? Number(pc) : null };
    act(
      () => addCombatant(campaignId, combat.id, who, initiative),
      () => {
        setName("");
        setPv("");
        setPc("");
        setIni("");
        if (k === "char") setPick("");
        onAdded();
      },
      true,
    );
  }

  return (
    <section className="space-y-2 border border-line/70 p-3">
      <p className="label-mono text-holo">Adicionar participante</p>
      <div className="flex flex-wrap items-end gap-2">
        <select className="field-input w-auto min-w-48 text-sm" value={pick} onChange={(e) => setPick(e.target.value)} aria-label="Participante">
          <option value="">Avulso (digitar nome)</option>
          {freeAgents.length > 0 && (
            <optgroup label="Agentes">
              {freeAgents.map((a) => (
                <option key={a.character.id} value={`char:${a.character.id}`}>
                  {a.character.name}
                </option>
              ))}
            </optgroup>
          )}
          {npcs.length > 0 && (
            <optgroup label="NPCs e monstros (cada inclusão é uma cópia)">
              {npcs.map((n) => (
                <option key={n.id} value={`npc:${n.id}`}>
                  {n.name}
                </option>
              ))}
            </optgroup>
          )}
        </select>
        {!pick && (
          <>
            <input className="field-input w-40 text-sm" value={name} maxLength={120} onChange={(e) => setName(e.target.value)} placeholder="Nome" aria-label="Nome" />
            <input className="field-input w-20 text-sm" inputMode="numeric" value={pv} onChange={(e) => setPv(e.target.value.replace(/\D/g, ""))} placeholder="PV" aria-label="PV" />
            <input className="field-input w-20 text-sm" inputMode="numeric" value={pc} onChange={(e) => setPc(e.target.value.replace(/\D/g, ""))} placeholder="PC" aria-label="PC" />
          </>
        )}
        <input className="field-input w-20 text-sm" inputMode="numeric" value={ini} onChange={(e) => setIni(e.target.value.replace(/[^\d-]/g, ""))} placeholder="Inic." aria-label="Iniciativa" />
        <Button size="sm" onClick={add} loading={busy} disabled={!pick && !name.trim()}>
          <Plus className="h-3.5 w-3.5" aria-hidden /> Adicionar
        </Button>
      </div>
    </section>
  );
}

function NoteBox({ campaignId, combatId, onDone }: { campaignId: string; combatId: string; onDone: () => void }) {
  const { act, busy } = useAct();
  const [kind, setKind] = useState<"ataque" | "poder" | "efeito" | "nota">("efeito");
  const [text, setText] = useState("");
  const [pub, setPub] = useState(true);
  return (
    <form
      className="space-y-2"
      onSubmit={(e) => {
        e.preventDefault();
        if (!text.trim()) return;
        act(
          () => combatNote(campaignId, combatId, kind, text.trim(), pub),
          () => {
            setText("");
            onDone();
          },
          true,
        );
      }}
    >
      <SectionTitle>Registrar ação / efeito</SectionTitle>
      <div className="flex flex-wrap gap-2">
        <select className="field-input w-auto text-sm" value={kind} onChange={(e) => setKind(e.target.value as typeof kind)} aria-label="Tipo">
          <option value="ataque">Ataque</option>
          <option value="poder">Poder</option>
          <option value="efeito">Efeito</option>
          <option value="nota">Nota</option>
        </select>
        <label className="flex items-center gap-1 text-xs text-fg-dim">
          <input type="checkbox" className="accent-[var(--color-holo)]" checked={pub} onChange={(e) => setPub(e.target.checked)} /> visível aos jogadores
        </label>
      </div>
      <textarea className="field-input text-sm" rows={2} maxLength={500} value={text} onChange={(e) => setText(e.target.value)} placeholder="Ex.: a criatura solta um rugido — todos fazem teste de Vontade." aria-label="Descrição" />
      <Button type="submit" size="sm" loading={busy} disabled={!text.trim()}>
        Registrar
      </Button>
    </form>
  );
}
