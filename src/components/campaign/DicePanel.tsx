"use client";

import { useEffect, useMemo, useState } from "react";
import { Dice5, Eye, EyeOff, Lock } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { usePrefs } from "@/components/Providers";
import type { MemberRow, RollRow } from "@/lib/campaign-types";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { SKILLS } from "@/rules/data/skills.ts";
import { RULES_CONFIG } from "@/rules/config.ts";
import { isValidDice } from "@/rules/dice.ts";
import { rollDice, rollSheetTest } from "@/app/(app)/campanhas/actions";

const QUICK = ["1d4", "1d6", "1d8", "1d10", "1d12", "1d20", "1d100"];

const VIS_LABEL: Record<RollRow["visibility"], string> = {
  public: "Pública",
  master: "Privada (você e o Mestre)",
  self: "Secreta (só você)",
};

type Terms = { sign: number; count: number; sides: number; rolls?: number[]; value?: number }[];

function rollSummary(r: RollRow): { main: string; detail: string; tone: string; type: string } {
  const res = r.result as Record<string, unknown>;
  const kind = (res.kind as string) ?? "test";
  if (kind === "dice") {
    const terms = (res.terms as Terms) ?? [];
    const detail = terms
      .map((t) => (t.count ? `${t.sign < 0 ? "−" : ""}${t.count}d${t.sides} [${(t.rolls ?? []).join(", ")}]` : `${t.sign < 0 ? "−" : "+"}${t.value}`))
      .join(" ");
    return { main: String(res.total), detail, tone: "text-cyan", type: "Dados" };
  }
  if (kind === "attack") {
    const hit = res.hit as boolean;
    return {
      main: String(res.natural).padStart(2, "0"),
      detail: `${res.outcomeLabel as string}${hit ? ` · ${res.finalDamage as number} de dano` : " · sem dano"}`,
      tone: hit ? "text-cyan" : "text-fg-dim",
      type: "Ataque",
    };
  }
  if (kind === "power") return { main: "—", detail: ((res.notes as string[]) ?? []).join(" ") || (res.power as string), tone: "text-holo", type: "Poder/Técnica" };
  const outcome = res.outcome as string | undefined;
  const tone = outcome === "critical_success" || outcome === "extreme" ? "text-cyan" : outcome === "critical_failure" ? "text-alert" : outcome === "failure" ? "text-fg-dim" : "text-fg";
  return { main: String(res.natural ?? "").padStart(2, "0"), detail: `${res.outcomeLabel as string} (valor ${res.value as number})`, tone, type: "Teste de ficha" };
}

/** Uma linha do histórico de rolagens da campanha. */
export function RollLine({ r, who, fresh, speed }: { r: RollRow; who: string; fresh?: boolean; speed: number }) {
  const s = rollSummary(r);
  const [done, setDone] = useState(!fresh || speed === 0);
  const [noise, setNoise] = useState("00");
  useEffect(() => {
    if (done) return;
    const t1 = setInterval(() => setNoise(String(Math.floor(Math.random() * 100)).padStart(2, "0")), 45);
    const t2 = setTimeout(() => setDone(true), speed);
    return () => {
      clearInterval(t1);
      clearTimeout(t2);
    };
  }, [done, speed]);
  const time = new Date(r.created_at).toLocaleTimeString("pt-BR", { hour: "2-digit", minute: "2-digit" });
  return (
    <li className="grid grid-cols-[3.2rem_1fr] items-center gap-3 border-b border-line/50 py-2">
      <span className={`text-center font-display text-2xl leading-none tabular-nums ${done ? s.tone : "text-fg-muted"}`}>{done ? s.main : noise}</span>
      <span className="min-w-0">
        <span className="block truncate text-sm text-fg" title={r.label}>
          {r.label}
        </span>
        <span className="block font-mono text-[0.62rem] break-words text-fg-dim">{done ? `${r.expression} · ${s.detail}` : "rolando…"}</span>
        <span className="flex flex-wrap gap-x-2 font-mono text-[0.56rem] tracking-[0.12em] text-fg-muted uppercase">
          <span>{who}</span>
          <span>{time}</span>
          <span>{s.type}</span>
          {r.visibility !== "public" && (
            <span className="text-alert">
              <Lock className="mr-0.5 inline h-2.5 w-2.5" aria-hidden />
              {r.visibility === "master" ? "privada" : "secreta"}
            </span>
          )}
        </span>
      </span>
    </li>
  );
}

export function DicePanel({
  campaignId,
  rolls,
  members,
  myCharacters,
  isMaster,
  onRolled,
}: {
  campaignId: string;
  rolls: RollRow[];
  members: MemberRow[];
  myCharacters: { id: string; name: string }[];
  isMaster: boolean;
  onRolled: (r: RollRow) => void;
}) {
  const toast = useToast();
  const prefs = usePrefs();
  const speed = prefs.reduceMotion ? 0 : RULES_CONFIG.rollSpeeds[prefs.rollSpeed];
  const [expr, setExpr] = useState("1d20");
  const [label, setLabel] = useState("");
  const [vis, setVis] = useState<RollRow["visibility"]>("public");
  const [busy, setBusy] = useState(false);
  const [freshId, setFreshId] = useState<string | null>(null);
  const [charId, setCharId] = useState(myCharacters[0]?.id ?? "");
  const [test, setTest] = useState("skill:luta");
  const names = useMemo(() => new Map(members.map((m) => [m.user_id, m.display_name || m.username || "Jogador"])), [members]);
  const valid = isValidDice(expr.trim());

  async function roll(e?: string) {
    const ex = (e ?? expr).trim();
    if (!isValidDice(ex)) return toast("Expressão inválida (ex.: 2d6+3).", "error");
    setBusy(true);
    const res = await rollDice(campaignId, ex, vis, label);
    setBusy(false);
    if (!res.ok) return toast(res.error, "error");
    setFreshId(res.data!.id);
    onRolled(res.data!);
  }

  async function sheetTest() {
    if (!charId) return;
    const [kind, id] = test.split(":") as ["attribute" | "skill", string];
    setBusy(true);
    const res = await rollSheetTest(campaignId, charId, kind, id, vis);
    setBusy(false);
    if (!res.ok) return toast(res.error, "error");
    setFreshId(res.data!.id);
    onRolled(res.data!);
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[minmax(0,5fr)_minmax(0,6fr)]">
      <div className="space-y-4">
        <section className="space-y-3 border border-line/70 bg-panel-2/40 p-4">
          <p className="label-mono flex items-center gap-1.5 text-holo">
            <Dice5 className="h-3.5 w-3.5" aria-hidden /> Rolagem livre
          </p>
          <div className="flex flex-wrap gap-1.5">
            {QUICK.map((q) => (
              <button
                key={q}
                type="button"
                onClick={() => {
                  setExpr(q);
                  void roll(q);
                }}
                disabled={busy}
                className="chamfer border border-line-strong bg-panel/80 px-2.5 py-1.5 font-mono text-xs text-fg hover:border-holo hover:text-cyan disabled:opacity-50"
              >
                {q.replace("1d", "d")}
              </button>
            ))}
          </div>
          <form
            className="flex flex-wrap gap-2"
            onSubmit={(e) => {
              e.preventDefault();
              void roll();
            }}
          >
            <input className="field-input w-36 font-mono" value={expr} onChange={(e) => setExpr(e.target.value)} aria-label="Expressão de dados" aria-invalid={!valid || undefined} placeholder="2d6+3" />
            <input className="field-input min-w-32 flex-1" value={label} maxLength={120} onChange={(e) => setLabel(e.target.value)} placeholder="Motivo (opcional)" aria-label="Motivo da rolagem" />
            <Button type="submit" loading={busy} disabled={!valid}>
              Rolar
            </Button>
          </form>
          <p className="text-xs text-fg-muted">Aceita expressões como 2d6+3, 3d8, 1d100, 2d12+1d6. O resultado é sorteado no servidor.</p>
        </section>

        {myCharacters.length > 0 && (
          <section className="space-y-3 border border-line/70 bg-panel-2/40 p-4">
            <p className="label-mono text-holo">Teste de ficha (d100)</p>
            <div className="flex flex-wrap gap-2">
              <select className="field-input w-auto" value={charId} onChange={(e) => setCharId(e.target.value)} aria-label="Personagem">
                {myCharacters.map((c) => (
                  <option key={c.id} value={c.id}>
                    {c.name}
                  </option>
                ))}
              </select>
              <select className="field-input w-auto" value={test} onChange={(e) => setTest(e.target.value)} aria-label="Atributo ou perícia">
                <optgroup label="Perícias">
                  {SKILLS.map((s) => (
                    <option key={s.id} value={`skill:${s.id}`}>
                      {s.name}
                    </option>
                  ))}
                </optgroup>
                <optgroup label="Atributos">
                  {ATTRIBUTES.map((a) => (
                    <option key={a.id} value={`attribute:${a.id}`}>
                      {a.name}
                    </option>
                  ))}
                </optgroup>
              </select>
              <Button variant="secondary" onClick={sheetTest} loading={busy}>
                Testar
              </Button>
            </div>
            <p className="text-xs text-fg-muted">Usa os valores atuais da ficha (forma ativa) e a classificação normal / bom / extremo.</p>
          </section>
        )}

        <fieldset className="space-y-1.5 border border-line/70 p-4 text-sm">
          <legend className="label-mono px-1 text-holo">Quem vê</legend>
          {(["public", "master", "self"] as const)
            .filter((v) => !(isMaster && v === "master"))
            .map((v) => (
              <label key={v} className="flex items-center gap-2 text-fg-dim">
                <input type="radio" name="roll-vis" checked={vis === v} onChange={() => setVis(v)} className="accent-[var(--color-holo)]" />
                {v === "public" ? <Eye className="h-3.5 w-3.5" aria-hidden /> : <EyeOff className="h-3.5 w-3.5" aria-hidden />}
                {isMaster && v === "self" ? "Secreta (só o Mestre)" : VIS_LABEL[v]}
              </label>
            ))}
        </fieldset>
      </div>

      <section aria-live="polite">
        <p className="label-mono mb-2">Histórico da campanha</p>
        {rolls.length === 0 ? (
          <p className="border border-dashed border-line p-6 text-center text-sm text-fg-muted">Nenhuma rolagem ainda.</p>
        ) : (
          <ul>
            {rolls.map((r) => (
              <RollLine key={r.id} r={r} who={names.get(r.user_id) ?? "—"} fresh={r.id === freshId} speed={speed} />
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}
