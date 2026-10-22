"use client";

import Link from "next/link";
import { useCallback, useMemo, useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft, Check, Copy, Crown, Dice5, FileText, RefreshCw, Search, Shield, StickyNote, Swords, Trash2, UserPlus, UsersRound, X, Network } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { useToast } from "@/components/ui/Toast";
import { createClient } from "@/lib/supabase/client";
import type { CampaignHub as HubData, CombatRow, NoteRow, PartyRow, PublicCombatant, ReportRow, RevealedClue, RollRow } from "@/lib/campaign-types";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { ORIGIN_BY_ID } from "@/rules/data/origins.ts";
import { HudTabs } from "@/components/campaign/HudTabs";
import { CombatView } from "@/components/campaign/CombatView";
import { DicePanel } from "@/components/campaign/DicePanel";
import { useRealtime, liveLabel } from "@/components/campaign/useRealtime";
import { regenerateInvite } from "../../actions";
import { linkCharacter, removeMember, reviewCharacter, setInviteActive, setMasterCanEdit, unlinkCharacter, updateCampaign } from "../actions";

type Tab = "geral" | "combate" | "investigacoes" | "relatorios" | "dados" | "anotacoes";

export function CampaignHub({ data }: { data: HubData }) {
  const router = useRouter();
  const sb = useMemo(() => createClient(), []);
  const { campaign } = data;
  const isMaster = data.role === "master";
  const [party, setParty] = useState(data.party);
  const [myLinks, setMyLinks] = useState(data.myLinks);
  const [combat, setCombat] = useState<CombatRow | null>(data.combat);
  const [combatants, setCombatants] = useState<PublicCombatant[]>(data.combatants);
  const [clues, setClues] = useState<RevealedClue[]>(data.clues);
  const [reports, setReports] = useState<ReportRow[]>(data.reports);
  const [notes, setNotes] = useState<NoteRow[]>(data.notes);
  const [rolls, setRolls] = useState<RollRow[]>(data.rolls);
  const [invite, setInvite] = useState(data.invite);

  const refetchCombat = useCallback(async () => {
    const { data: cbs } = await sb.from("combats").select("id, name, status, round, turn_index, version, initiative_mode, started_at, ended_at, created_at").eq("campaign_id", campaign.id).neq("status", "ended").order("created_at", { ascending: false }).limit(1);
    const cb = ((cbs ?? []) as CombatRow[])[0] ?? null;
    setCombat(cb);
    if (cb) {
      const { data: list } = await sb.from("combatants_public").select("*").eq("combat_id", cb.id);
      setCombatants((list ?? []) as PublicCombatant[]);
    } else setCombatants([]);
  }, [sb, campaign.id]);
  const refetchClues = useCallback(async () => {
    const { data: c } = await sb.rpc("revealed_clues", { p_campaign: campaign.id });
    setClues((c ?? []) as RevealedClue[]);
  }, [sb, campaign.id]);
  const refetchParty = useCallback(async () => {
    const { data: p } = await sb.rpc("campaign_party", { p_campaign: campaign.id });
    setParty((p ?? []) as PartyRow[]);
    const { data: l } = await sb.from("campaign_characters").select("character_id, status, master_can_edit, characters!inner(owner_id)").eq("campaign_id", campaign.id).eq("characters.owner_id", data.userId);
    setMyLinks(((l ?? []) as { character_id: string; status: "pending" | "accepted"; master_can_edit: boolean }[]).map(({ character_id, status, master_can_edit }) => ({ character_id, status, master_can_edit })));
  }, [sb, campaign.id, data.userId]);
  const refetchDocs = useCallback(async () => {
    const [r, n] = await Promise.all([
      sb.from("reports").select("id, title, report_date, description, participants, events, conclusions, attachments, is_private, created_at").eq("campaign_id", campaign.id).eq("is_private", false).order("report_date", { ascending: false }),
      sb.from("campaign_notes").select("id, title, category, content, is_private, updated_at").eq("campaign_id", campaign.id).eq("is_private", false).order("updated_at", { ascending: false }),
    ]);
    setReports((r.data ?? []) as ReportRow[]);
    setNotes((n.data ?? []) as NoteRow[]);
  }, [sb, campaign.id]);

  const subs = useMemo(
    () => [
      { table: "combats", filter: `campaign_id=eq.${campaign.id}` },
      { table: "clues" },
      { table: "roll_log", filter: `campaign_id=eq.${campaign.id}`, event: "INSERT" as const },
      { table: "campaign_characters", filter: `campaign_id=eq.${campaign.id}` },
      { table: "reports", filter: `campaign_id=eq.${campaign.id}` },
      { table: "campaign_notes", filter: `campaign_id=eq.${campaign.id}` },
    ],
    [campaign.id],
  );
  const live = useRealtime(
    `campaign:${campaign.id}`,
    subs,
    (ch) => {
      if (ch.table === "combats") void refetchCombat();
      else if (ch.table === "clues") void refetchClues();
      else if (ch.table === "roll_log") {
        const r = ch.new as unknown as RollRow;
        setRolls((list) => (list.some((x) => x.id === r.id) ? list : [r, ...list].slice(0, 80)));
      } else if (ch.table === "campaign_characters") void refetchParty();
      else void refetchDocs();
    },
    () => {
      void refetchCombat();
      void refetchClues();
      void refetchParty();
      void refetchDocs();
      router.refresh();
    },
  );

  const pending = party.filter((p) => p.status === "pending");
  const tabs = [
    { id: "geral" as Tab, label: "Visão geral", icon: UsersRound, badge: isMaster ? pending.length : 0 },
    { id: "combate" as Tab, label: "Combate", icon: Swords, badge: combat && combat.status === "active" ? 1 : 0 },
    { id: "investigacoes" as Tab, label: "Investigações", icon: Network, badge: 0 },
    { id: "relatorios" as Tab, label: "Relatórios", icon: FileText },
    { id: "dados" as Tab, label: "Dados", icon: Dice5 },
    { id: "anotacoes" as Tab, label: "Anotações", icon: StickyNote },
  ];

  const myAccepted = data.myCharacters.filter((c) => myLinks.some((l) => l.character_id === c.id && l.status === "accepted"));
  const ll = liveLabel(live);

  return (
    <div className="space-y-6 pb-24">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Link href="/painel?aba=campanhas" className="inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
          <ArrowLeft className="h-4 w-4" aria-hidden /> Campanhas
        </Link>
        <div className="flex items-center gap-3">
          <span className={`font-mono text-[0.58rem] tracking-[0.2em] uppercase ${ll.cls}`}>● {ll.text}</span>
          {isMaster && (
            <Link
              href={`/campanhas/${campaign.id}/escudo`}
              className="chamfer inline-flex items-center gap-2 border border-holo/60 bg-gradient-to-r from-primary-deep to-primary/80 px-4 py-2 font-mono text-xs tracking-[0.18em] text-fg uppercase hover:from-primary/90 hover:to-holo/90"
            >
              <Shield className="h-4 w-4" aria-hidden /> Abrir Escudo do Mestre
            </Link>
          )}
        </div>
      </div>

      <header className="hud-panel overflow-hidden">
        {campaign.cover_url && (
          // eslint-disable-next-line @next/next/no-img-element
          <img src={campaign.cover_url} alt="" className="h-40 w-full object-cover opacity-70" referrerPolicy="no-referrer" />
        )}
        <div className="space-y-2 p-5 pt-8">
          <span className="hud-tag">{isMaster ? "Você é o Mestre" : "Você é Jogador"}</span>
          <h1 className="text-3xl tracking-[0.06em] text-fg uppercase text-glow">{campaign.name}</h1>
          {campaign.description && <p className="max-w-3xl text-sm whitespace-pre-line text-fg-dim">{campaign.description}</p>}
        </div>
      </header>

      <HudTabs<Tab>
        tabs={tabs}
        storageKey={`france:campaign-tab:${campaign.id}`}
        render={(id) => {
          switch (id) {
            case "geral":
              return <Overview data={data} party={party} myLinks={myLinks} invite={invite} setInvite={setInvite} onChanged={refetchParty} />;
            case "combate":
              return <CombatView combat={combat} combatants={combatants} />;
            case "investigacoes":
              return <CluesList clues={clues} />;
            case "relatorios":
              return <ReportsList reports={reports} />;
            case "dados":
              return (
                <DicePanel
                  campaignId={campaign.id}
                  rolls={rolls}
                  members={data.members}
                  myCharacters={myAccepted}
                  isMaster={isMaster}
                  onRolled={(r) => setRolls((list) => [r, ...list.filter((x) => x.id !== r.id)].slice(0, 80))}
                />
              );
            case "anotacoes":
              return <SharedNotes notes={notes} />;
          }
        }}
      />
    </div>
  );
}

function charLine(p: { class_id: string | null; origin_id: string | null; level: number }) {
  return [CLASS_BY_ID[p.class_id ?? ""]?.name, ORIGIN_BY_ID[p.origin_id ?? ""]?.name, `nível ${p.level}`].filter(Boolean).join(" · ");
}

function Overview({
  data,
  party,
  myLinks,
  invite,
  setInvite,
  onChanged,
}: {
  data: HubData;
  party: PartyRow[];
  myLinks: HubData["myLinks"];
  invite: HubData["invite"];
  setInvite: (i: HubData["invite"]) => void;
  onChanged: () => void;
}) {
  const toast = useToast();
  const [busy, start] = useTransition();
  const isMaster = data.role === "master";
  const c = data.campaign;
  const linkable = data.myCharacters.filter((ch) => !myLinks.some((l) => l.character_id === ch.id));
  const [pick, setPick] = useState(linkable[0]?.id ?? "");

  function act(fn: () => Promise<{ ok: boolean; error?: string; message?: string }>) {
    start(async () => {
      const r = await fn();
      if (!r.ok) return toast(r.error ?? "Erro.", "error");
      if (r.message) toast(r.message);
      onChanged();
    });
  }

  return (
    <div className="grid gap-6 lg:grid-cols-2">
      <section className="space-y-3">
        <p className="label-mono">Personagens na campanha</p>
        {party.length === 0 ? (
          <p className="border border-dashed border-line p-4 text-sm text-fg-muted">Nenhum personagem vinculado ainda.</p>
        ) : (
          <ul className="space-y-2">
            {party.map((p) => {
              const link = myLinks.find((l) => l.character_id === p.character_id);
              return (
                <li key={p.character_id} className={`border p-3 ${p.status === "pending" ? "border-alert/50" : "border-line/70"} bg-panel-2/40`}>
                  <div className="flex flex-wrap items-center justify-between gap-2">
                    <div className="min-w-0">
                      <p className="truncate text-fg">
                        {p.name}
                        {p.active_form === "lenda" && <span className="ml-2 font-mono text-[0.58rem] text-alert">FORMA LENDA</span>}
                      </p>
                      <p className="text-xs text-fg-dim">
                        {charLine(p)} · jogador {p.owner_username ?? "—"}
                      </p>
                    </div>
                    <span className={`font-mono text-[0.6rem] tracking-[0.15em] uppercase ${p.status === "pending" ? "text-alert" : "text-ok"}`}>{p.status === "pending" ? "Aguardando o Mestre" : "Aceito"}</span>
                  </div>
                  <div className="mt-2 flex flex-wrap gap-2">
                    {(p.is_mine || isMaster) && p.status === "accepted" && (
                      <Link href={`/personagens/${p.character_id}`} className="font-mono text-[0.62rem] tracking-[0.15em] text-cyan uppercase hover:underline">
                        Abrir ficha
                      </Link>
                    )}
                    {isMaster && p.status === "pending" && (
                      <>
                        <Button size="sm" onClick={() => act(() => reviewCharacter(c.id, p.character_id, true))} loading={busy}>
                          <Check className="h-3.5 w-3.5" aria-hidden /> Aceitar
                        </Button>
                        <Button size="sm" variant="danger" onClick={() => act(() => reviewCharacter(c.id, p.character_id, false))}>
                          <X className="h-3.5 w-3.5" aria-hidden /> Recusar
                        </Button>
                      </>
                    )}
                    {p.is_mine && link && (
                      <label className="flex items-center gap-1.5 text-xs text-fg-dim">
                        <input type="checkbox" className="accent-[var(--color-holo)]" checked={link.master_can_edit} onChange={(e) => act(() => setMasterCanEdit(c.id, p.character_id, e.target.checked))} />
                        Mestre pode editar PV/PC/condições
                      </label>
                    )}
                    {(p.is_mine || (isMaster && p.status === "accepted")) && (
                      <Button size="sm" variant="ghost" onClick={() => act(() => unlinkCharacter(c.id, p.character_id))}>
                        <Trash2 className="h-3.5 w-3.5" aria-hidden /> Remover da campanha
                      </Button>
                    )}
                  </div>
                </li>
              );
            })}
          </ul>
        )}
        {linkable.length > 0 ? (
          <div className="flex flex-wrap items-end gap-2 border border-line/70 p-3">
            <label className="min-w-40 flex-1 text-sm">
              <span className="label-mono mb-1 block text-holo">Adicionar meu personagem</span>
              <select className="field-input" value={pick} onChange={(e) => setPick(e.target.value)}>
                {linkable.map((ch) => (
                  <option key={ch.id} value={ch.id}>
                    {ch.name} — {charLine(ch)}
                  </option>
                ))}
              </select>
            </label>
            <Button onClick={() => pick && act(() => linkCharacter(c.id, pick))} loading={busy}>
              <UserPlus className="h-4 w-4" aria-hidden /> Vincular
            </Button>
            {!isMaster && <p className="basis-full text-xs text-fg-muted">A ficha continua sua; o Mestre passa a visualizá-la quando aceitar.</p>}
          </div>
        ) : (
          data.myCharacters.length === 0 && <p className="text-xs text-fg-muted">Finalize um personagem no painel para vinculá-lo.</p>
        )}
      </section>

      <section className="space-y-4">
        <div>
          <p className="label-mono mb-2">Participantes ({data.members.length})</p>
          <ul className="space-y-1.5">
            {data.members.map((m) => (
              <li key={m.user_id} className="flex items-center justify-between gap-2 border-b border-line/50 pb-1.5 text-sm">
                <span className="flex items-center gap-2 text-fg">
                  {m.role === "master" && <Crown className="h-3.5 w-3.5 text-cyan" aria-label="Mestre" />}
                  {m.display_name || m.username}
                  {m.user_id === data.userId && <span className="text-xs text-fg-muted">(você)</span>}
                </span>
                {isMaster && m.role === "player" && (
                  <button onClick={() => act(() => removeMember(c.id, m.user_id))} className="font-mono text-[0.6rem] tracking-[0.15em] text-fg-muted uppercase hover:text-alert">
                    Remover
                  </button>
                )}
              </li>
            ))}
          </ul>
        </div>
        {isMaster && <InvitePanel campaignId={c.id} invite={invite} setInvite={setInvite} />}
        {isMaster && <SettingsPanel data={data} />}
      </section>
    </div>
  );
}

function InvitePanel({ campaignId, invite, setInvite }: { campaignId: string; invite: HubData["invite"]; setInvite: (i: HubData["invite"]) => void }) {
  const toast = useToast();
  const [busy, start] = useTransition();
  if (!invite) return null;
  const url = typeof window !== "undefined" ? `${window.location.origin}/convite/${invite.code}` : `/convite/${invite.code}`;
  return (
    <div className="space-y-2 border border-line/70 bg-void/40 p-3">
      <p className="label-mono flex items-center justify-between">
        Convite
        <span className={invite.active ? "text-ok" : "text-alert"}>{invite.active ? "ATIVO" : "DESATIVADO"}</span>
      </p>
      <p className="truncate font-mono text-xs text-fg-dim">{url}</p>
      <div className="flex flex-wrap gap-2">
        <Button
          size="sm"
          variant="secondary"
          disabled={!invite.active}
          onClick={async () => {
            try {
              await navigator.clipboard.writeText(url);
              toast("Link copiado.");
            } catch {
              toast("Não foi possível copiar.", "error");
            }
          }}
        >
          <Copy className="h-3.5 w-3.5" aria-hidden /> Copiar
        </Button>
        <Button
          size="sm"
          variant="ghost"
          loading={busy}
          onClick={() =>
            start(async () => {
              const r = await setInviteActive(campaignId, !invite.active);
              if (!r.ok) return toast(r.error, "error");
              setInvite({ ...invite, active: !invite.active });
              toast(r.message ?? "Ok.");
            })
          }
        >
          {invite.active ? "Desativar" : "Ativar"}
        </Button>
        <Button
          size="sm"
          variant="ghost"
          onClick={() =>
            start(async () => {
              const r = await regenerateInvite(campaignId);
              if (!r.ok) return toast(r.error, "error");
              setInvite({ code: r.data!.code, active: true });
              toast(r.message ?? "Novo link.");
            })
          }
        >
          <RefreshCw className="h-3.5 w-3.5" aria-hidden /> Renovar
        </Button>
      </div>
      <p className="text-xs text-fg-muted">Entrar pelo convite torna a pessoa jogadora — nunca Mestre.</p>
    </div>
  );
}

function SettingsPanel({ data }: { data: HubData }) {
  const toast = useToast();
  const router = useRouter();
  const c = data.campaign;
  const [open, setOpen] = useState(false);
  const [v, setV] = useState({ name: c.name, description: c.description, cover_url: c.cover_url ?? "", players_see_party: c.settings?.players_see_party !== false });
  const [busy, start] = useTransition();
  if (!open)
    return (
      <Button size="sm" variant="ghost" onClick={() => setOpen(true)}>
        Configurações da campanha
      </Button>
    );
  return (
    <form
      className="space-y-3 border border-line/70 p-3"
      onSubmit={(e) => {
        e.preventDefault();
        start(async () => {
          const r = await updateCampaign(c.id, v);
          if (!r.ok) return toast(r.error, "error");
          toast(r.message ?? "Salvo.");
          setOpen(false);
          router.refresh();
        });
      }}
    >
      <Field label="Nome">
        <input className="field-input" value={v.name} maxLength={120} onChange={(e) => setV({ ...v, name: e.target.value })} />
      </Field>
      <Field label="Descrição">
        <textarea rows={3} className="field-input" value={v.description} maxLength={5000} onChange={(e) => setV({ ...v, description: e.target.value })} />
      </Field>
      <Field label="Capa (https://)">
        <input className="field-input" value={v.cover_url} onChange={(e) => setV({ ...v, cover_url: e.target.value })} />
      </Field>
      <label className="flex items-center gap-2 text-sm text-fg-dim">
        <input type="checkbox" className="accent-[var(--color-holo)]" checked={v.players_see_party} onChange={(e) => setV({ ...v, players_see_party: e.target.checked })} />
        Jogadores veem o grupo
      </label>
      <div className="flex justify-end gap-2">
        <Button type="button" variant="ghost" onClick={() => setOpen(false)}>
          Cancelar
        </Button>
        <Button type="submit" loading={busy}>
          Salvar
        </Button>
      </div>
    </form>
  );
}

function CluesList({ clues }: { clues: RevealedClue[] }) {
  if (clues.length === 0) return <p className="border border-dashed border-line p-6 text-center text-sm text-fg-muted">Nenhuma pista revelada ainda.</p>;
  const groups = new Map<string, RevealedClue[]>();
  for (const c of clues) groups.set(c.investigation_title, [...(groups.get(c.investigation_title) ?? []), c]);
  return (
    <div className="space-y-5">
      {[...groups.entries()].map(([title, list]) => (
        <section key={title}>
          <p className="label-mono mb-2 text-holo">{title}</p>
          <ul className="grid gap-3 sm:grid-cols-2">
            {list.map((c) => (
              <li key={c.id} className="border border-line/70 bg-panel-2/40 p-3">
                {c.image_url && (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img src={c.image_url} alt="" className="mb-2 max-h-48 w-full object-cover" referrerPolicy="no-referrer" loading="lazy" />
                )}
                <p className="text-fg">{c.title}</p>
                {c.location && <p className="text-xs text-fg-muted">Local: {c.location}</p>}
                <p className="mt-1 text-sm whitespace-pre-line text-fg-dim">{c.content}</p>
                {c.attachments?.length > 0 && (
                  <p className="mt-1 flex flex-wrap gap-2 text-xs">
                    {c.attachments.map((a, i) => (
                      <a key={i} href={a} target="_blank" rel="noreferrer noopener" className="text-cyan underline">
                        Anexo {i + 1}
                      </a>
                    ))}
                  </p>
                )}
              </li>
            ))}
          </ul>
        </section>
      ))}
    </div>
  );
}

function ReportsList({ reports }: { reports: ReportRow[] }) {
  const [q, setQ] = useState("");
  const list = reports.filter((r) => !q || `${r.title} ${r.description} ${r.conclusions}`.toLowerCase().includes(q.toLowerCase()));
  return (
    <div className="space-y-3">
      <label className="relative block max-w-sm">
        <Search className="pointer-events-none absolute top-1/2 left-2.5 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
        <input className="field-input pl-8" placeholder="Buscar relatório…" value={q} onChange={(e) => setQ(e.target.value)} />
      </label>
      {list.length === 0 ? (
        <p className="border border-dashed border-line p-6 text-center text-sm text-fg-muted">Nenhum relatório publicado.</p>
      ) : (
        <ol className="space-y-3">
          {list.map((r) => (
            <li key={r.id} className="border border-line/70 bg-panel-2/40 p-4">
              <p className="font-mono text-[0.62rem] tracking-[0.15em] text-fg-muted">{new Date(r.report_date + "T12:00:00").toLocaleDateString("pt-BR")}</p>
              <h3 className="text-lg text-fg">{r.title}</h3>
              {r.participants?.length > 0 && <p className="text-xs text-fg-dim">Personagens: {r.participants.join(", ")}</p>}
              {r.description && <p className="mt-2 text-sm whitespace-pre-line text-fg-dim">{r.description}</p>}
              {r.events?.length > 0 && (
                <ul className="mt-2 list-disc pl-5 text-sm text-fg-dim">
                  {r.events.map((e, i) => (
                    <li key={i}>{e}</li>
                  ))}
                </ul>
              )}
              {r.conclusions && <p className="mt-2 text-sm text-fg">Conclusões: {r.conclusions}</p>}
            </li>
          ))}
        </ol>
      )}
    </div>
  );
}

function SharedNotes({ notes }: { notes: NoteRow[] }) {
  if (notes.length === 0) return <p className="border border-dashed border-line p-6 text-center text-sm text-fg-muted">O Mestre ainda não compartilhou anotações.</p>;
  return (
    <ul className="grid gap-3 sm:grid-cols-2">
      {notes.map((n) => (
        <li key={n.id} className="border border-line/70 bg-panel-2/40 p-4">
          {n.category && <p className="label-mono text-holo">{n.category}</p>}
          <h3 className="text-fg">{n.title}</h3>
          <p className="mt-1 text-sm whitespace-pre-line text-fg-dim">{n.content}</p>
        </li>
      ))}
    </ul>
  );
}
