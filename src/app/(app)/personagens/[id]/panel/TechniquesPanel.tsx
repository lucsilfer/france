"use client";

import { useMemo, useState } from "react";
import { BookOpen, ChevronDown, Clock, Eye, Footprints, Plus, Search, Swords, Trash2, Zap } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { Modal } from "@/components/ui/Modal";
import { useToast } from "@/components/ui/Toast";
import { TECHNIQUES, TECHNIQUE_BY_ID, type TechniqueDef } from "@/rules/data/equipment.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { activeTechniqueEffects, isSuspended, learnErrors, techniqueAvailability, usageLabel } from "@/rules/techniques.ts";
import { advanceTracker, forgetTechnique, learnTechnique, useTechnique } from "../../technique-actions";
import type { SheetState } from "../Sheet";
import { makeRequestId } from "./actions-ui";

function permanentAttributes(state: SheetState) {
  const attrs: Record<string, number> = Object.fromEntries(state.base.attributes.map((a) => [a.attribute, (a.base_value ?? 0) + a.other_bonus]));
  for (const [k, v] of Object.entries(CLASS_BY_ID[state.character.class_id ?? ""]?.attributeBonus ?? {})) attrs[k] = (attrs[k] ?? 0) + (v as number);
  return attrs;
}

/** Técnicas oficiais do Caminho do Arsenal: aprendidas, catálogo do livro e controle de uso. */
export function TechniquesPanel({ state }: { state: SheetState }) {
  const toast = useToast();
  const [catalog, setCatalog] = useState(false);
  const { character: c, tracker, techniques, techniqueUses: uses, abilities: ab } = state;
  const active = activeTechniqueEffects(uses, tracker);

  async function tick(kind: "turn" | "scene" | "session") {
    const res = await advanceTracker(c.id, kind);
    if (!res.ok) return toast(res.error, "error");
    state.setTracker(res.data!);
    toast(kind === "turn" ? `Turno ${res.data!.turn}.` : kind === "scene" ? "Nova cena: técnicas de uso por cena liberadas." : "Nova sessão: técnicas por sessão liberadas.");
  }

  return (
    <section className="space-y-3" aria-label="Técnicas do Arsenal">
      <div className="flex flex-wrap items-center justify-between gap-2 border border-line/60 px-3 py-2">
        <p className="flex items-center gap-2 font-mono text-[0.64rem] tracking-[0.15em] text-fg-dim uppercase">
          <Clock className="h-3.5 w-3.5 text-holo" aria-hidden />
          Sessão <span className="text-fg">{tracker.session}</span> · Cena <span className="text-fg">{tracker.scene}</span> · Turno <span className="text-fg">{tracker.turn}</span>
        </p>
        {state.canEdit && (
          <div className="flex flex-wrap gap-1.5">
            <Button size="sm" variant="ghost" onClick={() => tick("turn")}>
              Próximo turno
            </Button>
            <Button size="sm" variant="ghost" onClick={() => tick("scene")}>
              Nova cena
            </Button>
            <Button size="sm" variant="ghost" onClick={() => tick("session")}>
              Nova sessão
            </Button>
          </div>
        )}
      </div>
      <p className="text-[0.7rem] text-fg-muted">Em combates da campanha, o Escudo do Mestre avança turno e cena automaticamente.</p>

      {active.map((e) => (
        <p key={e.technique_id} className="flex items-center gap-2 border border-cyan/50 bg-cyan/10 px-3 py-2 text-sm text-cyan" role="status">
          <Eye className="h-4 w-4" aria-hidden /> {e.label}
        </p>
      ))}

      <div className="flex items-center justify-between gap-2">
        <p className="label-mono">
          Técnicas aprendidas <span className="text-fg">({techniques.length})</span>
        </p>
        {state.canEdit && (
          <Button size="sm" onClick={() => setCatalog(true)} disabled={ab.available <= 0} title={ab.available > 0 ? undefined : "Uma técnica nova a cada nível par"}>
            <Plus className="h-3.5 w-3.5" aria-hidden /> Aprender técnica
          </Button>
        )}
      </div>
      {techniques.length === 0 ? (
        <p className="border border-dashed border-line p-4 text-center text-sm text-fg-muted">
          Nenhuma técnica aprendida. O Arsenal aprende uma técnica da lista a cada nível par{ab.available > 0 ? " — você tem uma disponível agora." : "."}
        </p>
      ) : (
        <ul className="space-y-2">
          {techniques.map((t) => {
            const def = TECHNIQUE_BY_ID[t.technique_id];
            return def ? <LearnedCard key={t.id} state={state} def={def} learnedLevel={t.learned_level} /> : null;
          })}
        </ul>
      )}
      {catalog && <CatalogModal state={state} onClose={() => setCatalog(false)} />}
    </section>
  );
}

function UsageIcon({ def }: { def: TechniqueDef }) {
  const Icon = def.usage.kind === "passiva" ? Footprints : def.attack ? Swords : Zap;
  return <Icon className="h-4 w-4 shrink-0 text-holo" aria-hidden />;
}

function LearnedCard({ state, def, learnedLevel }: { state: SheetState; def: TechniqueDef; learnedLevel: number }) {
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [confirm, setConfirm] = useState(false);
  const [recover, setRecover] = useState(false);
  const [busy, setBusy] = useState(false);
  const suspended = isSuspended({ technique_id: def.id, learned_level: learnedLevel }, state.character.level);
  const av = techniqueAvailability(def, state.techniqueUses, state.tracker);
  const c = state.character;

  async function use(data: { mode?: "half" | "revive"; damage?: number } = {}) {
    setBusy(true);
    const res = await useTechnique(c.id, def.id, await makeRequestId(), data);
    setBusy(false);
    if (!res.ok) return toast(res.error, "error");
    const d = res.data!;
    state.setTechniqueUses((list) => [d.use, ...list]);
    if (d.form_id && d.pv_current !== undefined) state.patchForm(d.form_id, { pv_current: d.pv_current });
    toast(d.message);
    setRecover(false);
  }

  async function forget() {
    setBusy(true);
    const res = await forgetTechnique(c.id, def.id);
    setBusy(false);
    setConfirm(false);
    if (!res.ok) return toast(res.error, "error");
    state.setTechniques((list) => list.filter((t) => t.technique_id !== def.id));
    toast(res.message ?? "Removida.");
  }

  return (
    <li className={`border bg-panel-2/40 ${suspended ? "border-line/40 opacity-60" : open ? "border-holo/60" : "border-line/70"}`}>
      <div className="flex items-center gap-2 px-3 py-2">
        <UsageIcon def={def} />
        <button onClick={() => setOpen((o) => !o)} aria-expanded={open} className="flex min-w-0 flex-1 items-center gap-2 text-left">
          <span className="truncate text-sm text-fg">{def.name}</span>
          <span className="shrink-0 font-mono text-[0.58rem] tracking-[0.12em] text-fg-muted uppercase">{usageLabel(def.usage)}</span>
          <span className={`hidden shrink-0 font-mono text-[0.58rem] sm:inline ${suspended ? "text-alert" : av.usable || def.usage.kind === "passiva" ? "text-cyan" : "text-fg-muted"}`}>
            {suspended ? `SUSPENSA (nível ${learnedLevel})` : av.status.toUpperCase()}
          </span>
          <ChevronDown className={`ml-auto h-4 w-4 shrink-0 text-fg-muted transition-transform ${open ? "rotate-180" : ""}`} aria-hidden />
        </button>
        {state.canEdit && !suspended && def.usage.kind !== "passiva" && (
          <Button size="sm" onClick={() => (def.special === "recobrar" ? setRecover(true) : use())} disabled={!av.usable} loading={busy} title={av.reason ?? undefined}>
            Usar
          </Button>
        )}
      </div>
      {open && (
        <div className="space-y-2 border-t border-line/60 px-3 py-3 text-sm">
          <p className="text-fg-dim">{def.text}</p>
          <dl className="grid gap-2 text-xs sm:grid-cols-3">
            <div>
              <dt className="label-mono">Efeito</dt>
              <dd className="text-fg">{def.effect}</dd>
            </div>
            <div>
              <dt className="label-mono">Limite</dt>
              <dd className="text-fg">{usageLabel(def.usage)}</dd>
            </div>
            <div>
              <dt className="label-mono">Requisitos</dt>
              <dd className="text-fg">{def.requirements ?? "—"}</dd>
            </div>
          </dl>
          {def.attack && <p className="text-xs text-cyan-dim">Aparece como opção no ataque com armas{def.usage.kind === "passiva" ? " (sempre disponível)" : " e consome o uso"}.</p>}
          {suspended && <p className="text-xs text-alert">Aprendida no nível {learnedLevel}: efeitos suspensos enquanto o personagem estiver abaixo desse nível. A escolha continua salva.</p>}
          {state.canEdit && (
            <div className="flex justify-end">
              <Button size="sm" variant="danger" onClick={() => setConfirm(true)}>
                <Trash2 className="h-3.5 w-3.5" aria-hidden /> Esquecer
              </Button>
            </div>
          )}
        </div>
      )}
      <ConfirmDialog
        open={confirm}
        title="Esquecer técnica"
        description={`Remover “${def.name}”? A vaga volta a ficar disponível para outra técnica.`}
        confirmLabel="Esquecer"
        loading={busy}
        onCancel={() => setConfirm(false)}
        onConfirm={forget}
      />
      {recover && <RecoverDialog busy={busy} onClose={() => setRecover(false)} onUse={use} />}
    </li>
  );
}

function RecoverDialog({ busy, onClose, onUse }: { busy: boolean; onClose: () => void; onUse: (d: { mode: "half" | "revive"; damage?: number }) => void }) {
  const [mode, setMode] = useState<"half" | "revive">("half");
  const [damage, setDamage] = useState(0);
  return (
    <Modal
      open
      onClose={onClose}
      title="Recobrar-se"
      tag="1× por sessão"
      size="md"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button onClick={() => onUse(mode === "half" ? { mode, damage } : { mode })} loading={busy} disabled={mode === "half" && damage <= 0}>
            Usar
          </Button>
        </>
      }
    >
      <fieldset className="space-y-3 text-sm">
        <label className="flex items-start gap-2">
          <input type="radio" checked={mode === "half"} onChange={() => setMode("half")} className="mt-1 accent-[var(--color-holo)]" />
          <span>
            O ataque não me matou: curar metade do dano recebido.
            {mode === "half" && (
              <span className="mt-2 flex items-center gap-2">
                <span className="text-xs text-fg-dim">Dano do ataque</span>
                <input type="number" min={0} max={10000} value={damage} onChange={(e) => setDamage(Math.max(0, Math.floor(Number(e.target.value) || 0)))} className="field-input w-24 py-1 font-mono" />
                <span className="font-mono text-xs text-cyan">→ +{Math.floor(damage / 2)} PV</span>
              </span>
            )}
          </span>
        </label>
        <label className="flex items-start gap-2">
          <input type="radio" checked={mode === "revive"} onChange={() => setMode("revive")} className="mt-1 accent-[var(--color-holo)]" />
          <span>O ataque me matou: voltar com 1 de vida.</span>
        </label>
      </fieldset>
    </Modal>
  );
}

function CatalogModal({ state, onClose }: { state: SheetState; onClose: () => void }) {
  const toast = useToast();
  const [q, setQ] = useState("");
  const [onlyAvailable, setOnlyAvailable] = useState(false);
  const [busy, setBusy] = useState<string | null>(null);
  const [open, setOpen] = useState<string | null>(null);
  const c = state.character;
  const learned = state.techniques.map((t) => t.technique_id);
  const attrs = useMemo(() => permanentAttributes(state), [state]);
  const norm = (s: string) => s.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();
  const rows = TECHNIQUES.map((def) => ({ def, errors: learnErrors({ def, originId: c.origin_id, pathId: c.origin_path_id, learned, attributes: attrs, slotsAvailable: state.abilities.available }) }))
    .filter((r) => !q || norm(`${r.def.name} ${r.def.text}`).includes(norm(q)))
    .filter((r) => !onlyAvailable || r.errors.length === 0);

  async function select(def: TechniqueDef) {
    setBusy(def.id);
    const res = await learnTechnique(c.id, def.id);
    setBusy(null);
    if (!res.ok) return toast(res.error, "error");
    state.setTechniques((list) => [...list, res.data!]);
    toast(res.message ?? "Aprendida.");
    onClose();
  }

  return (
    <Modal
      open
      onClose={onClose}
      title="Aprender técnica"
      tag={`Disponíveis: ${state.abilities.available}`}
      size="lg"
      header={
        <div className="flex flex-wrap items-center gap-3">
          <label className="relative min-w-48 flex-1">
            <Search className="pointer-events-none absolute top-1/2 left-2.5 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
            <input className="field-input pl-8" placeholder="Buscar técnica…" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Buscar técnica" />
          </label>
          <label className="flex items-center gap-2 text-sm text-fg-dim">
            <input type="checkbox" className="accent-[var(--color-holo)]" checked={onlyAvailable} onChange={(e) => setOnlyAvailable(e.target.checked)} />
            Só as que posso aprender agora
          </label>
        </div>
      }
    >
      <p className="mb-3 flex items-center gap-1.5 text-xs text-fg-muted">
        <BookOpen className="h-3.5 w-3.5" aria-hidden /> Livro do Jogador, Cap. VI — Técnicas. Uma técnica nova a cada nível par.
      </p>
      <ul className="space-y-2">
        {rows.length === 0 && <p className="text-sm text-fg-muted">Nenhuma técnica com esse filtro.</p>}
        {rows.map(({ def, errors }) => {
          const isOpen = open === def.id;
          const already = learned.includes(def.id);
          return (
            <li key={def.id} className={`border ${errors.length === 0 ? "border-holo/50" : "border-line/60"} bg-panel-2/40`}>
              <div className="flex items-center gap-2 px-3 py-2">
                <UsageIcon def={def} />
                <button onClick={() => setOpen(isOpen ? null : def.id)} aria-expanded={isOpen} className="flex min-w-0 flex-1 items-center gap-2 text-left">
                  <span className="truncate text-sm text-fg">{def.name}</span>
                  <span className="shrink-0 font-mono text-[0.58rem] tracking-[0.12em] text-fg-muted uppercase">{usageLabel(def.usage)}</span>
                  <ChevronDown className={`ml-auto h-4 w-4 shrink-0 text-fg-muted transition-transform ${isOpen ? "rotate-180" : ""}`} aria-hidden />
                </button>
                <Button size="sm" onClick={() => select(def)} disabled={errors.length > 0} loading={busy === def.id} title={errors[0]}>
                  {already ? "Aprendida" : "Selecionar"}
                </Button>
              </div>
              {isOpen && (
                <div className="space-y-2 border-t border-line/60 px-3 py-3 text-sm">
                  <p className="text-fg-dim">{def.text}</p>
                  <dl className="grid gap-2 text-xs sm:grid-cols-3">
                    <div>
                      <dt className="label-mono">Efeito</dt>
                      <dd className="text-fg">{def.effect}</dd>
                    </div>
                    <div>
                      <dt className="label-mono">Limite</dt>
                      <dd className="text-fg">{usageLabel(def.usage)}</dd>
                    </div>
                    <div>
                      <dt className="label-mono">Requisitos</dt>
                      <dd className="text-fg">{def.requirements ?? "—"}</dd>
                    </div>
                  </dl>
                </div>
              )}
              {errors.length > 0 && !already && <p className="px-3 pb-2 text-xs text-fg-muted">{errors[0]}</p>}
            </li>
          );
        })}
      </ul>
    </Modal>
  );
}

/** Inventário Rápido: técnicas aprendidas (ativas com "Usar"; passivas só como lembrete). */
export function QuickTechniques({ state }: { state: SheetState }) {
  const learned = state.techniques.filter((t) => !isSuspended(t, state.character.level));
  if (learned.length === 0) return null;
  const active = activeTechniqueEffects(state.techniqueUses, state.tracker);
  const passives = learned.map((t) => TECHNIQUE_BY_ID[t.technique_id]).filter((d) => d?.usage.kind === "passiva");
  return (
    <section>
      <p className="label-mono mb-2">Técnicas de Arsenal</p>
      {active.map((e) => (
        <p key={e.technique_id} className="mb-2 flex items-center gap-2 border border-cyan/50 bg-cyan/10 px-3 py-2 text-sm text-cyan" role="status">
          <Eye className="h-4 w-4" aria-hidden /> {e.label}
        </p>
      ))}
      <ul className="space-y-2">
        {learned
          .filter((t) => TECHNIQUE_BY_ID[t.technique_id]?.usage.kind !== "passiva")
          .map((t) => (
            <LearnedCard key={t.id} state={state} def={TECHNIQUE_BY_ID[t.technique_id]} learnedLevel={t.learned_level} />
          ))}
      </ul>
      {passives.length > 0 && (
        <p className="mt-2 text-xs text-fg-dim">
          <span className="label-mono mr-1">Passivas ativas:</span>
          {passives.map((d) => `${d!.name} (${d!.effect})`).join(" · ")}
        </p>
      )}
    </section>
  );
}
