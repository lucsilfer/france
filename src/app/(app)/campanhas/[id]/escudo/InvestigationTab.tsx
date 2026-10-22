"use client";

import { useRef, useState } from "react";
import { Eye, EyeOff, Link2, MapPin, Pencil, Plus, Trash2, UserRound, StickyNote } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import type { ClueRow, InvestigationRow, LinkRow, NodeRow, ShieldData } from "@/lib/campaign-types";
import {
  addBoardLink,
  addBoardNode,
  deleteBoardLink,
  deleteBoardNode,
  deleteClue,
  deleteInvestigation,
  moveBoardItem,
  saveClue,
  saveInvestigation,
  setClueRevealed,
  type ClueInput,
  type InvestigationInput,
} from "../../shield-actions";
import { Empty, SectionTitle, lines, useAct } from "./kit";

const STATUS: Record<InvestigationRow["status"], string> = { aberta: "Aberta", em_andamento: "Em andamento", resolvida: "Resolvida", arquivada: "Arquivada" };

export function InvestigationTab({ campaignId, initial }: { campaignId: string; initial: ShieldData }) {
  const [invs, setInvs] = useState<InvestigationRow[]>(initial.investigations);
  const [clues, setClues] = useState<ClueRow[]>(initial.clues);
  const [nodes, setNodes] = useState<NodeRow[]>(initial.nodes);
  const [links, setLinks] = useState<LinkRow[]>(initial.links);
  const [selected, setSelected] = useState<string | "new" | null>(initial.investigations[0]?.id ?? null);
  const [view, setView] = useState<"pistas" | "quadro">("pistas");
  const inv = invs.find((i) => i.id === selected) ?? null;
  const charNames = initial.party.filter((p) => p.status === "accepted").map((p) => p.name);

  return (
    <div className="grid gap-4 lg:grid-cols-[16rem_1fr]">
      <aside className="space-y-2">
        <SectionTitle>Investigações</SectionTitle>
        <Button size="sm" className="w-full" onClick={() => setSelected("new")}>
          <Plus className="h-3.5 w-3.5" aria-hidden /> Nova investigação
        </Button>
        <ul className="space-y-1">
          {invs.map((i) => {
            const n = clues.filter((c) => c.investigation_id === i.id);
            return (
              <li key={i.id}>
                <button
                  type="button"
                  onClick={() => setSelected(i.id)}
                  className={`w-full border px-3 py-2 text-left text-sm ${i.id === selected ? "border-cyan bg-cyan/10 text-fg" : "border-line/60 text-fg-dim hover:border-line-strong"}`}
                >
                  <span className="block truncate">{i.title}</span>
                  <span className="font-mono text-[0.58rem] tracking-[0.12em] text-fg-muted uppercase">
                    {STATUS[i.status]} · {n.filter((c) => c.revealed).length}/{n.length} pistas reveladas{!i.visible_to_players && " · sigilosa"}
                  </span>
                </button>
              </li>
            );
          })}
        </ul>
      </aside>

      <section className="min-w-0 space-y-5">
        {selected === "new" ? (
          <InvestigationForm
            campaignId={campaignId}
            inv={null}
            charNames={charNames}
            onSaved={(row) => {
              setInvs((l) => [row, ...l]);
              setSelected(row.id);
            }}
          />
        ) : !inv ? (
          <Empty>Crie uma investigação para registrar casos, pistas e o quadro de conexões.</Empty>
        ) : (
          <>
            <InvestigationForm
              key={inv.id}
              campaignId={campaignId}
              inv={inv}
              charNames={charNames}
              onSaved={(row) => setInvs((l) => l.map((x) => (x.id === row.id ? row : x)))}
              onDeleted={() => {
                setInvs((l) => l.filter((x) => x.id !== inv.id));
                setClues((l) => l.filter((c) => c.investigation_id !== inv.id));
                setSelected(null);
              }}
            />
            <div className="flex gap-2 border-b border-line">
              {(["pistas", "quadro"] as const).map((v) => (
                <button
                  key={v}
                  type="button"
                  onClick={() => setView(v)}
                  className={`px-3 py-2 font-mono text-[0.62rem] tracking-[0.18em] uppercase ${view === v ? "border-b-2 border-cyan text-fg" : "text-fg-muted"}`}
                >
                  {v === "pistas" ? "Pistas" : "Quadro de conexões"}
                </button>
              ))}
            </div>
            {view === "pistas" ? (
              <CluesPanel campaignId={campaignId} inv={inv} clues={clues.filter((c) => c.investigation_id === inv.id)} setClues={setClues} charNames={charNames} />
            ) : (
              <Board
                campaignId={campaignId}
                inv={inv}
                clues={clues.filter((c) => c.investigation_id === inv.id)}
                setClues={setClues}
                nodes={nodes.filter((n) => n.investigation_id === inv.id)}
                setNodes={setNodes}
                links={links.filter((l) => l.investigation_id === inv.id)}
                setLinks={setLinks}
              />
            )}
          </>
        )}
      </section>
    </div>
  );
}

function InvestigationForm({
  campaignId,
  inv,
  charNames,
  onSaved,
  onDeleted,
}: {
  campaignId: string;
  inv: InvestigationRow | null;
  charNames: string[];
  onSaved: (r: InvestigationRow) => void;
  onDeleted?: () => void;
}) {
  const { act, busy } = useAct();
  const [open, setOpen] = useState(!inv);
  const [confirm, setConfirm] = useState(false);
  const [v, setV] = useState({
    title: inv?.title ?? "",
    description: inv?.description ?? "",
    location: inv?.location ?? "",
    status: inv?.status ?? ("aberta" as InvestigationRow["status"]),
    characters: (inv?.characters ?? []).join("\n"),
    visible_to_players: inv?.visible_to_players ?? true,
    secret: inv?.secret ?? "",
  });

  if (inv && !open)
    return (
      <div className="hud-panel space-y-2 p-4">
        <div className="flex flex-wrap items-start justify-between gap-2">
          <div>
            <h2 className="text-xl text-fg">{inv.title}</h2>
            <p className="font-mono text-[0.6rem] tracking-[0.15em] text-fg-muted uppercase">
              {STATUS[inv.status]}
              {inv.location && ` · ${inv.location}`}
              {inv.visible_to_players ? " · visível aos jogadores" : " · sigilosa"}
            </p>
          </div>
          <Button size="sm" variant="ghost" onClick={() => setOpen(true)}>
            <Pencil className="h-3.5 w-3.5" aria-hidden /> Editar
          </Button>
        </div>
        {inv.description && <p className="text-sm whitespace-pre-line text-fg-dim">{inv.description}</p>}
        {inv.characters.length > 0 && <p className="text-xs text-fg-dim">Envolvidos: {inv.characters.join(", ")}</p>}
        {inv.secret && (
          <p className="border-l-2 border-alert/70 bg-alert/5 px-3 py-2 text-sm whitespace-pre-line text-fg">
            <span className="label-mono mb-1 block text-alert">Informação secreta (só o Mestre)</span>
            {inv.secret}
          </p>
        )}
      </div>
    );

  return (
    <form
      className="hud-panel space-y-3 p-4"
      onSubmit={(e) => {
        e.preventDefault();
        const input: InvestigationInput = { ...v, characters: lines(v.characters) };
        act(
          () => saveInvestigation(campaignId, input, inv?.id),
          (row) => {
            if (!row) return;
            onSaved({ ...row, secret: v.secret });
            setOpen(false);
          },
        );
      }}
    >
      <div className="grid gap-3 sm:grid-cols-2">
        <Field label="Nome">
          <input className="field-input" required maxLength={160} value={v.title} onChange={(e) => setV({ ...v, title: e.target.value })} />
        </Field>
        <Field label="Local">
          <input className="field-input" maxLength={160} value={v.location} onChange={(e) => setV({ ...v, location: e.target.value })} />
        </Field>
      </div>
      <Field label="Descrição (o que os jogadores sabem)">
        <textarea className="field-input" rows={3} value={v.description} onChange={(e) => setV({ ...v, description: e.target.value })} />
      </Field>
      <div className="grid gap-3 sm:grid-cols-2">
        <Field label="Personagens envolvidos (um por linha)">
          <textarea className="field-input" rows={3} value={v.characters} onChange={(e) => setV({ ...v, characters: e.target.value })} placeholder={charNames.join("\n")} />
        </Field>
        <div className="space-y-3">
          <Field label="Status">
            <select className="field-input" value={v.status} onChange={(e) => setV({ ...v, status: e.target.value as InvestigationRow["status"] })}>
              {Object.entries(STATUS).map(([k, l]) => (
                <option key={k} value={k}>
                  {l}
                </option>
              ))}
            </select>
          </Field>
          <label className="flex items-center gap-2 text-sm text-fg-dim">
            <input type="checkbox" className="accent-[var(--color-holo)]" checked={v.visible_to_players} onChange={(e) => setV({ ...v, visible_to_players: e.target.checked })} />
            Os jogadores sabem que este caso existe
          </label>
        </div>
      </div>
      <Field label="Informação secreta (nunca enviada aos jogadores)">
        <textarea className="field-input border-alert/40" rows={3} value={v.secret} onChange={(e) => setV({ ...v, secret: e.target.value })} />
      </Field>
      <div className="flex flex-wrap justify-between gap-2">
        {inv && onDeleted ? (
          <Button type="button" variant="ghost" onClick={() => setConfirm(true)}>
            <Trash2 className="h-3.5 w-3.5" aria-hidden /> Excluir
          </Button>
        ) : (
          <span />
        )}
        <div className="flex gap-2">
          {inv && (
            <Button type="button" variant="ghost" onClick={() => setOpen(false)}>
              Cancelar
            </Button>
          )}
          <Button type="submit" loading={busy}>
            Salvar
          </Button>
        </div>
      </div>
      {inv && onDeleted && (
        <ConfirmDialog
          open={confirm}
          title={`Excluir “${inv.title}”?`}
          description="Remove a investigação, as pistas e o quadro."
          confirmLabel="Excluir"
          loading={busy}
          onCancel={() => setConfirm(false)}
          onConfirm={() => act(() => deleteInvestigation(campaignId, inv.id), () => (setConfirm(false), onDeleted()))}
        />
      )}
    </form>
  );
}

const emptyClue = (): ClueInput => ({ title: "", content: "", location: "", characters: [], image_url: "", attachments: [], revealed: false });

function CluesPanel({ campaignId, inv, clues, setClues, charNames }: { campaignId: string; inv: InvestigationRow; clues: ClueRow[]; setClues: (f: (c: ClueRow[]) => ClueRow[]) => void; charNames: string[] }) {
  const { act, busy } = useAct();
  const [editing, setEditing] = useState<ClueRow | "new" | null>(null);
  const upsert = (c?: ClueRow) => c && setClues((l) => (l.some((x) => x.id === c.id) ? l.map((x) => (x.id === c.id ? c : x)) : [...l, c]));
  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <p className="text-xs text-fg-muted">Revelar uma pista envia-a na hora para a aba Investigações dos jogadores{!inv.visible_to_players && " (o caso aparece como “Caso sigiloso”)"}.</p>
        <Button size="sm" onClick={() => setEditing("new")}>
          <Plus className="h-3.5 w-3.5" aria-hidden /> Nova pista
        </Button>
      </div>
      {editing && (
        <ClueForm
          campaignId={campaignId}
          invId={inv.id}
          clue={editing === "new" ? null : editing}
          charNames={charNames}
          onClose={() => setEditing(null)}
          onSaved={(c) => {
            upsert(c);
            setEditing(null);
          }}
        />
      )}
      {clues.length === 0 ? (
        <Empty>Nenhuma pista ainda.</Empty>
      ) : (
        <ul className="grid gap-3 md:grid-cols-2">
          {clues.map((c) => (
            <li key={c.id} className={`border p-3 ${c.revealed ? "border-cyan/60 bg-cyan/5" : "border-line/70 bg-panel-2/40"}`}>
              <div className="mb-1 flex items-start justify-between gap-2">
                <p className="text-fg">{c.title}</p>
                <span className={`shrink-0 font-mono text-[0.58rem] tracking-[0.15em] uppercase ${c.revealed ? "text-cyan" : "text-alert"}`}>{c.revealed ? "Revelada" : "Secreta"}</span>
              </div>
              {c.image_url && (
                // eslint-disable-next-line @next/next/no-img-element
                <img src={c.image_url} alt="" className="mb-2 max-h-40 w-full object-cover" referrerPolicy="no-referrer" loading="lazy" />
              )}
              {c.location && <p className="text-xs text-fg-muted">Local: {c.location}</p>}
              {c.characters.length > 0 && <p className="text-xs text-fg-muted">Envolvidos: {c.characters.join(", ")}</p>}
              <p className="mt-1 text-sm whitespace-pre-line text-fg-dim">{c.content}</p>
              {c.attachments.length > 0 && (
                <p className="mt-1 flex flex-wrap gap-2 text-xs">
                  {c.attachments.map((a, i) => (
                    <a key={i} href={a} target="_blank" rel="noreferrer noopener" className="text-cyan underline">
                      Arquivo {i + 1}
                    </a>
                  ))}
                </p>
              )}
              <div className="mt-2 flex flex-wrap gap-2">
                <Button size="sm" variant={c.revealed ? "ghost" : "primary"} loading={busy} onClick={() => act(() => setClueRevealed(campaignId, c.id, !c.revealed), upsert)}>
                  {c.revealed ? <EyeOff className="h-3.5 w-3.5" aria-hidden /> : <Eye className="h-3.5 w-3.5" aria-hidden />}
                  {c.revealed ? "Ocultar de novo" : "Revelar aos jogadores"}
                </Button>
                <Button size="sm" variant="ghost" onClick={() => setEditing(c)}>
                  <Pencil className="h-3.5 w-3.5" aria-hidden /> Editar
                </Button>
                <Button size="sm" variant="ghost" onClick={() => act(() => deleteClue(campaignId, c.id), () => setClues((l) => l.filter((x) => x.id !== c.id)))}>
                  <Trash2 className="h-3.5 w-3.5" aria-hidden />
                </Button>
              </div>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

function ClueForm({ campaignId, invId, clue, charNames, onClose, onSaved }: { campaignId: string; invId: string; clue: ClueRow | null; charNames: string[]; onClose: () => void; onSaved: (c: ClueRow) => void }) {
  const { act, busy } = useAct();
  const base = clue ? { ...clue, image_url: clue.image_url ?? "" } : emptyClue();
  const [v, setV] = useState({ ...base, characters: base.characters.join("\n"), attachments: base.attachments.join("\n") });
  return (
    <form
      className="space-y-3 border border-holo/50 bg-panel-2/60 p-4"
      onSubmit={(e) => {
        e.preventDefault();
        const input: ClueInput = {
          title: v.title,
          content: v.content,
          location: v.location,
          characters: lines(v.characters),
          image_url: v.image_url.trim(),
          attachments: lines(v.attachments),
          revealed: v.revealed,
        };
        act(() => saveClue(campaignId, invId, input, clue?.id), (c) => c && onSaved(c));
      }}
    >
      <div className="grid gap-3 sm:grid-cols-2">
        <Field label="Nome da pista">
          <input className="field-input" required maxLength={160} value={v.title} onChange={(e) => setV({ ...v, title: e.target.value })} />
        </Field>
        <Field label="Local">
          <input className="field-input" maxLength={160} value={v.location} onChange={(e) => setV({ ...v, location: e.target.value })} />
        </Field>
      </div>
      <Field label="Descrição">
        <textarea className="field-input" rows={3} value={v.content} onChange={(e) => setV({ ...v, content: e.target.value })} />
      </Field>
      <div className="grid gap-3 sm:grid-cols-2">
        <Field label="Personagens envolvidos (um por linha)">
          <textarea className="field-input" rows={2} value={v.characters} onChange={(e) => setV({ ...v, characters: e.target.value })} placeholder={charNames.slice(0, 3).join("\n")} />
        </Field>
        <div className="space-y-3">
          <Field label="Imagem (link https://, opcional)">
            <input className="field-input" value={v.image_url} onChange={(e) => setV({ ...v, image_url: e.target.value })} />
          </Field>
          <Field label="Arquivos (links https://, um por linha)">
            <textarea className="field-input" rows={2} value={v.attachments} onChange={(e) => setV({ ...v, attachments: e.target.value })} />
          </Field>
        </div>
      </div>
      <fieldset className="flex flex-wrap gap-4 text-sm text-fg-dim">
        <legend className="label-mono mb-1">Visibilidade</legend>
        <label className="flex items-center gap-1.5">
          <input type="radio" className="accent-[var(--color-holo)]" checked={!v.revealed} onChange={() => setV({ ...v, revealed: false })} /> Secreta
        </label>
        <label className="flex items-center gap-1.5">
          <input type="radio" className="accent-[var(--color-holo)]" checked={v.revealed} onChange={() => setV({ ...v, revealed: true })} /> Revelada
        </label>
      </fieldset>
      <div className="flex justify-end gap-2">
        <Button type="button" variant="ghost" onClick={onClose}>
          Cancelar
        </Button>
        <Button type="submit" loading={busy}>
          Salvar pista
        </Button>
      </div>
    </form>
  );
}

// ===================================================================== Quadro (SVG com itens arrastáveis)

const W = 1000;
const H = 600;
type Item = { id: string; kind: "clue" | "node"; sub: string; label: string; x: number; y: number; revealed?: boolean };

function Board({
  campaignId,
  inv,
  clues,
  setClues,
  nodes,
  setNodes,
  links,
  setLinks,
}: {
  campaignId: string;
  inv: InvestigationRow;
  clues: ClueRow[];
  setClues: (f: (c: ClueRow[]) => ClueRow[]) => void;
  nodes: NodeRow[];
  setNodes: (f: (n: NodeRow[]) => NodeRow[]) => void;
  links: LinkRow[];
  setLinks: (f: (l: LinkRow[]) => LinkRow[]) => void;
}) {
  const { act, busy } = useAct();
  const svg = useRef<SVGSVGElement | null>(null);
  const [drag, setDrag] = useState<{ id: string; kind: "clue" | "node"; dx: number; dy: number } | null>(null);
  const [linkFrom, setLinkFrom] = useState<string | null>(null);
  const [linkMode, setLinkMode] = useState(false);
  const [newKind, setNewKind] = useState<NodeRow["kind"]>("character");
  const [newLabel, setNewLabel] = useState("");

  const items: Item[] = [
    ...clues.map((c, i) => ({ id: c.id, kind: "clue" as const, sub: "pista", label: c.title, x: c.board_x ?? 80 + (i % 5) * 180, y: c.board_y ?? 80 + Math.floor(i / 5) * 110, revealed: c.revealed })),
    ...nodes.map((n) => ({ id: n.id, kind: "node" as const, sub: n.kind, label: n.label, x: n.x, y: n.y })),
  ];
  const byId = new Map(items.map((i) => [i.id, i]));

  function point(e: React.PointerEvent) {
    const r = svg.current!.getBoundingClientRect();
    return { x: ((e.clientX - r.left) / r.width) * W, y: ((e.clientY - r.top) / r.height) * H };
  }
  function setPos(id: string, kind: "clue" | "node", x: number, y: number) {
    if (kind === "clue") setClues((l) => l.map((c) => (c.id === id ? { ...c, board_x: x, board_y: y } : c)));
    else setNodes((l) => l.map((n) => (n.id === id ? { ...n, x, y } : n)));
  }

  function onItemDown(e: React.PointerEvent, it: Item) {
    e.stopPropagation();
    if (linkMode) {
      if (!linkFrom) setLinkFrom(it.id);
      else if (linkFrom !== it.id) {
        const from = linkFrom;
        setLinkFrom(null);
        act(() => addBoardLink(campaignId, inv.id, from, it.id), (l) => l && setLinks((ls) => [...ls, l]), true);
      }
      return;
    }
    const p = point(e);
    (e.target as Element).setPointerCapture?.(e.pointerId);
    setDrag({ id: it.id, kind: it.kind, dx: p.x - it.x, dy: p.y - it.y });
  }
  function onMove(e: React.PointerEvent) {
    if (!drag) return;
    const p = point(e);
    setPos(drag.id, drag.kind, Math.round(Math.max(60, Math.min(W - 60, p.x - drag.dx))), Math.round(Math.max(24, Math.min(H - 24, p.y - drag.dy))));
  }
  function onUp() {
    if (!drag) return;
    const it = byId.get(drag.id);
    setDrag(null);
    if (it) act(() => moveBoardItem(campaignId, drag.kind, drag.id, it.x, it.y), undefined, true);
  }

  const ICON = { pista: "◆", place: "⌖", character: "◉", note: "✎" } as Record<string, string>;

  return (
    <div className="space-y-3">
      <div className="flex flex-wrap items-end gap-2">
        <select className="field-input w-auto text-sm" value={newKind} onChange={(e) => setNewKind(e.target.value as NodeRow["kind"])} aria-label="Tipo do item">
          <option value="character">Personagem</option>
          <option value="place">Local</option>
          <option value="note">Nota</option>
        </select>
        <input className="field-input w-48 text-sm" maxLength={120} value={newLabel} onChange={(e) => setNewLabel(e.target.value)} placeholder="Rótulo" aria-label="Rótulo" />
        <Button
          size="sm"
          disabled={!newLabel.trim()}
          loading={busy}
          onClick={() =>
            act(
              () => addBoardNode(campaignId, inv.id, newKind, newLabel.trim(), 120 + Math.round(Math.random() * 700), 120 + Math.round(Math.random() * 360)),
              (n) => {
                if (n) setNodes((l) => [...l, n]);
                setNewLabel("");
              },
              true,
            )
          }
        >
          <Plus className="h-3.5 w-3.5" aria-hidden /> Item
        </Button>
        <Button size="sm" variant={linkMode ? "primary" : "secondary"} onClick={() => (setLinkMode(!linkMode), setLinkFrom(null))}>
          <Link2 className="h-3.5 w-3.5" aria-hidden /> {linkMode ? (linkFrom ? "Escolha o 2º item…" : "Escolha o 1º item…") : "Ligar itens"}
        </Button>
        <span className="text-xs text-fg-muted">Arraste para organizar · clique numa linha para desfazer a ligação · só o Mestre vê o quadro.</span>
      </div>
      <div className="overflow-x-auto border border-line bg-void/60">
        <svg
          ref={svg}
          viewBox={`0 0 ${W} ${H}`}
          className="block h-auto w-full min-w-[640px] touch-none select-none"
          onPointerMove={onMove}
          onPointerUp={onUp}
          onPointerLeave={onUp}
          role="img"
          aria-label={`Quadro de conexões de ${inv.title}`}
        >
          <defs>
            <pattern id="grid" width="40" height="40" patternUnits="userSpaceOnUse">
              <path d="M 40 0 L 0 0 0 40" fill="none" stroke="var(--color-line)" strokeWidth="0.5" opacity="0.5" />
            </pattern>
          </defs>
          <rect width={W} height={H} fill="url(#grid)" />
          {links.map((l) => {
            const a = byId.get(l.from_id);
            const b = byId.get(l.to_id);
            if (!a || !b) return null;
            return (
              <g key={l.id} className="cursor-pointer" onClick={() => act(() => deleteBoardLink(campaignId, l.id), () => setLinks((ls) => ls.filter((x) => x.id !== l.id)), true)}>
                <line x1={a.x} y1={a.y} x2={b.x} y2={b.y} stroke="transparent" strokeWidth="14" />
                <line x1={a.x} y1={a.y} x2={b.x} y2={b.y} stroke="var(--color-alert)" strokeWidth="1.5" strokeDasharray="6 4" opacity="0.8" />
              </g>
            );
          })}
          {items.map((it) => {
            const sel = linkFrom === it.id;
            const w = Math.min(200, 40 + it.label.length * 7.2);
            return (
              <g key={it.id} transform={`translate(${it.x},${it.y})`} onPointerDown={(e) => onItemDown(e, it)} className={linkMode ? "cursor-crosshair" : "cursor-grab"}>
                <rect
                  x={-w / 2}
                  y={-18}
                  width={w}
                  height={36}
                  fill="var(--color-panel-2)"
                  stroke={sel ? "var(--color-cyan)" : it.kind === "clue" ? (it.revealed ? "var(--color-cyan)" : "var(--color-holo)") : "var(--color-line-strong)"}
                  strokeWidth={sel ? 2.5 : 1.2}
                  opacity="0.95"
                />
                <text x={-w / 2 + 10} y={5} fontSize="13" fill="var(--color-fg)" style={{ pointerEvents: "none" }}>
                  <tspan fill="var(--color-holo)">{ICON[it.sub] ?? "•"} </tspan>
                  {it.label.length > 24 ? it.label.slice(0, 23) + "…" : it.label}
                </text>
              </g>
            );
          })}
        </svg>
      </div>
      {nodes.length > 0 && (
        <ul className="flex flex-wrap gap-2">
          {nodes.map((n) => (
            <li key={n.id} className="flex items-center gap-1 border border-line/60 px-2 py-0.5 text-xs text-fg-dim">
              {n.kind === "place" ? <MapPin className="h-3 w-3" aria-hidden /> : n.kind === "character" ? <UserRound className="h-3 w-3" aria-hidden /> : <StickyNote className="h-3 w-3" aria-hidden />}
              {n.label}
              <button
                type="button"
                className="text-fg-muted hover:text-alert"
                aria-label={`Remover ${n.label}`}
                onClick={() =>
                  act(
                    () => deleteBoardNode(campaignId, n.id),
                    () => {
                      setNodes((l) => l.filter((x) => x.id !== n.id));
                      setLinks((l) => l.filter((x) => x.from_id !== n.id && x.to_id !== n.id));
                    },
                    true,
                  )
                }
              >
                <Trash2 className="h-3 w-3" />
              </button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
