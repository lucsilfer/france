"use client";

import { useState } from "react";
import { ArrowDown, ArrowUp, Lock, Pencil, Plus, Search, Trash2 } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import type { AgentRow, ReportRow } from "@/lib/campaign-types";
import { deleteReport, saveReport, type ReportInput } from "../../actions";
import { Empty, SectionTitle, lines, useAct } from "./kit";

const today = () => new Date().toISOString().slice(0, 10);

export function ReportsTab({ campaignId, initial, agents }: { campaignId: string; initial: ReportRow[]; agents: AgentRow[] }) {
  const { act, busy } = useAct();
  const [reports, setReports] = useState(initial);
  const [editing, setEditing] = useState<ReportRow | "new" | null>(null);
  const [q, setQ] = useState("");
  const [from, setFrom] = useState("");
  const [to, setTo] = useState("");
  const [asc, setAsc] = useState(false);
  const [confirm, setConfirm] = useState<ReportRow | null>(null);

  const list = reports
    .filter((r) => (!from || r.report_date >= from) && (!to || r.report_date <= to))
    .filter((r) => !q || `${r.title} ${r.description} ${r.conclusions} ${r.events.join(" ")} ${r.participants.join(" ")}`.toLowerCase().includes(q.toLowerCase()))
    .sort((a, b) => (asc ? 1 : -1) * (a.report_date.localeCompare(b.report_date) || a.created_at.localeCompare(b.created_at)));

  return (
    <div className="space-y-4">
      <SectionTitle
        right={
          <Button size="sm" onClick={() => setEditing("new")}>
            <Plus className="h-3.5 w-3.5" aria-hidden /> Novo relatório
          </Button>
        }
      >
        Relatórios de sessão ({reports.length})
      </SectionTitle>
      <div className="flex flex-wrap items-end gap-2">
        <label className="relative min-w-48 flex-1">
          <Search className="pointer-events-none absolute top-1/2 left-2.5 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
          <input className="field-input pl-8 text-sm" placeholder="Buscar…" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Buscar relatórios" />
        </label>
        <label className="text-xs text-fg-muted">
          De
          <input type="date" className="field-input text-sm" value={from} onChange={(e) => setFrom(e.target.value)} />
        </label>
        <label className="text-xs text-fg-muted">
          Até
          <input type="date" className="field-input text-sm" value={to} onChange={(e) => setTo(e.target.value)} />
        </label>
        <Button size="sm" variant="ghost" onClick={() => setAsc(!asc)}>
          {asc ? <ArrowUp className="h-3.5 w-3.5" aria-hidden /> : <ArrowDown className="h-3.5 w-3.5" aria-hidden />} {asc ? "Mais antigos primeiro" : "Mais recentes primeiro"}
        </Button>
      </div>

      {editing && (
        <ReportForm
          campaignId={campaignId}
          report={editing === "new" ? null : editing}
          agents={agents}
          onClose={() => setEditing(null)}
          onSaved={(r) => {
            setReports((l) => (l.some((x) => x.id === r.id) ? l.map((x) => (x.id === r.id ? r : x)) : [r, ...l]));
            setEditing(null);
          }}
        />
      )}

      {list.length === 0 ? (
        <Empty>{reports.length ? "Nenhum relatório neste filtro." : "Registre o que aconteceu em cada sessão."}</Empty>
      ) : (
        <ol className="relative space-y-3 border-l border-line pl-5">
          {list.map((r) => (
            <li key={r.id} className="relative border border-line/70 bg-panel-2/40 p-4">
              <span className="absolute top-5 -left-[1.6rem] h-2.5 w-2.5 rotate-45 border border-cyan bg-void" aria-hidden />
              <div className="flex flex-wrap items-start justify-between gap-2">
                <div>
                  <p className="font-mono text-[0.62rem] tracking-[0.15em] text-fg-muted">
                    {new Date(r.report_date + "T12:00:00").toLocaleDateString("pt-BR")}
                    {r.is_private ? (
                      <span className="ml-2 text-alert">
                        <Lock className="mr-0.5 inline h-2.5 w-2.5" aria-hidden />
                        PRIVADO
                      </span>
                    ) : (
                      <span className="ml-2 text-ok">VISÍVEL AOS JOGADORES</span>
                    )}
                  </p>
                  <h3 className="text-lg text-fg">{r.title}</h3>
                </div>
                <div className="flex gap-1">
                  <button type="button" className="p-1 text-fg-muted hover:text-cyan" onClick={() => setEditing(r)} aria-label="Editar">
                    <Pencil className="h-4 w-4" />
                  </button>
                  <button type="button" className="p-1 text-fg-muted hover:text-alert" onClick={() => setConfirm(r)} aria-label="Excluir">
                    <Trash2 className="h-4 w-4" />
                  </button>
                </div>
              </div>
              {r.participants.length > 0 && <p className="text-xs text-fg-dim">Personagens: {r.participants.join(", ")}</p>}
              {r.description && <p className="mt-2 text-sm whitespace-pre-line text-fg-dim">{r.description}</p>}
              {r.events.length > 0 && (
                <ul className="mt-2 list-disc pl-5 text-sm text-fg-dim">
                  {r.events.map((e, i) => (
                    <li key={i}>{e}</li>
                  ))}
                </ul>
              )}
              {r.conclusions && <p className="mt-2 text-sm text-fg">Conclusões: {r.conclusions}</p>}
              {r.attachments.length > 0 && (
                <p className="mt-2 flex flex-wrap gap-2 text-xs">
                  {r.attachments.map((a, i) => (
                    <a key={i} href={a} target="_blank" rel="noreferrer noopener" className="text-cyan underline">
                      Anexo {i + 1}
                    </a>
                  ))}
                </p>
              )}
            </li>
          ))}
        </ol>
      )}
      <ConfirmDialog
        open={!!confirm}
        title={`Excluir “${confirm?.title ?? ""}”?`}
        description="O relatório some também para os jogadores. Esta ação não pode ser desfeita."
        confirmLabel="Excluir"
        loading={busy}
        onCancel={() => setConfirm(null)}
        onConfirm={() =>
          confirm &&
          act(
            () => deleteReport(campaignId, confirm.id),
            () => {
              setReports((l) => l.filter((x) => x.id !== confirm.id));
              setConfirm(null);
            },
          )
        }
      />
    </div>
  );
}

function ReportForm({ campaignId, report, agents, onClose, onSaved }: { campaignId: string; report: ReportRow | null; agents: AgentRow[]; onClose: () => void; onSaved: (r: ReportRow) => void }) {
  const { act, busy } = useAct();
  const [v, setV] = useState({
    title: report?.title ?? "",
    report_date: report?.report_date ?? today(),
    description: report?.description ?? "",
    participants: report?.participants ?? agents.map((a) => a.character.name),
    events: (report?.events ?? []).join("\n"),
    conclusions: report?.conclusions ?? "",
    attachments: (report?.attachments ?? []).join("\n"),
    is_private: report?.is_private ?? true,
  });
  const names = Array.from(new Set([...agents.map((a) => a.character.name), ...v.participants]));
  return (
    <form
      className="space-y-3 border border-holo/50 bg-panel-2/60 p-4"
      onSubmit={(e) => {
        e.preventDefault();
        const input: ReportInput = { ...v, events: lines(v.events), attachments: lines(v.attachments) };
        act(() => saveReport(campaignId, input, report?.id), (r) => r && onSaved(r));
      }}
    >
      <div className="grid gap-3 sm:grid-cols-[1fr_11rem]">
        <Field label="Título">
          <input className="field-input" required maxLength={160} value={v.title} onChange={(e) => setV({ ...v, title: e.target.value })} />
        </Field>
        <Field label="Data da sessão">
          <input type="date" className="field-input" required value={v.report_date} onChange={(e) => setV({ ...v, report_date: e.target.value })} />
        </Field>
      </div>
      <Field label="Descrição">
        <textarea className="field-input" rows={4} value={v.description} onChange={(e) => setV({ ...v, description: e.target.value })} />
      </Field>
      {names.length > 0 && (
        <fieldset>
          <legend className="label-mono mb-1">Personagens participantes</legend>
          <div className="flex flex-wrap gap-3 text-sm text-fg-dim">
            {names.map((n) => (
              <label key={n} className="flex items-center gap-1.5">
                <input
                  type="checkbox"
                  className="accent-[var(--color-holo)]"
                  checked={v.participants.includes(n)}
                  onChange={(e) => setV({ ...v, participants: e.target.checked ? [...v.participants, n] : v.participants.filter((x) => x !== n) })}
                />
                {n}
              </label>
            ))}
          </div>
        </fieldset>
      )}
      <Field label="Eventos importantes (um por linha)">
        <textarea className="field-input" rows={4} value={v.events} onChange={(e) => setV({ ...v, events: e.target.value })} />
      </Field>
      <Field label="Conclusões">
        <textarea className="field-input" rows={2} value={v.conclusions} onChange={(e) => setV({ ...v, conclusions: e.target.value })} />
      </Field>
      <Field label="Anexos (links https://, um por linha)">
        <textarea className="field-input" rows={2} value={v.attachments} onChange={(e) => setV({ ...v, attachments: e.target.value })} />
      </Field>
      <label className="flex items-center gap-2 text-sm text-fg-dim">
        <input type="checkbox" className="accent-[var(--color-holo)]" checked={!v.is_private} onChange={(e) => setV({ ...v, is_private: !e.target.checked })} />
        Visível para os jogadores
      </label>
      <div className="flex justify-end gap-2">
        <Button type="button" variant="ghost" onClick={onClose}>
          Cancelar
        </Button>
        <Button type="submit" loading={busy}>
          Salvar relatório
        </Button>
      </div>
    </form>
  );
}
