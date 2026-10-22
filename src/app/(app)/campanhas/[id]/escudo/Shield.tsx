"use client";

import Link from "next/link";
import { useCallback, useMemo, useState } from "react";
import { useRouter } from "next/navigation";
import { ArrowLeft, Dice5, FileText, Network, Shield as ShieldIcon, StickyNote, Swords, UsersRound } from "lucide-react";
import type { AgentRow, NpcRow, RollRow, ShieldData } from "@/lib/campaign-types";
import { HudTabs } from "@/components/campaign/HudTabs";
import { DicePanel } from "@/components/campaign/DicePanel";
import { useRealtime, liveLabel } from "@/components/campaign/useRealtime";
import { createClient } from "@/lib/supabase/client";
import { AgentsTab } from "./AgentsTab";
import { CombatTab } from "./CombatTab";
import { InvestigationTab } from "./InvestigationTab";
import { ReportsTab } from "./ReportsTab";
import { NotesTab } from "./NotesTab";

type Tab = "agentes" | "combates" | "investigacao" | "relatorios" | "dados" | "anotacoes";

/** Escudo do Mestre: central de comando da campanha (só o Mestre chega aqui; o servidor e o RLS garantem). */
export function Shield({ data }: { data: ShieldData }) {
  const router = useRouter();
  const sb = useMemo(() => createClient(), []);
  const cid = data.campaign.id;
  const [agents, setAgents] = useState<AgentRow[]>(data.agents);
  const [npcs, setNpcs] = useState<NpcRow[]>(data.npcs);
  const [rolls, setRolls] = useState<RollRow[]>(data.rolls);
  const [combatTick, setCombatTick] = useState(0);

  const charIds = useMemo(() => agents.map((a) => a.character.id).sort(), [agents]);
  const refetchNpcs = useCallback(async () => {
    const { data: n } = await sb.from("npcs").select("id, kind, name, data, pv_current, pv_max, pc_current, pc_max, conditions, visible_to_players, source_homebrew_id, created_at").eq("campaign_id", cid).order("created_at");
    if (n) setNpcs(n as NpcRow[]);
  }, [sb, cid]);

  const subs = useMemo(
    () => [
      { table: "combats", filter: `campaign_id=eq.${cid}` },
      { table: "npcs", filter: `campaign_id=eq.${cid}` },
      { table: "roll_log", filter: `campaign_id=eq.${cid}`, event: "INSERT" as const },
      { table: "campaign_characters", filter: `campaign_id=eq.${cid}` },
      ...(charIds.length ? [{ table: "character_forms", filter: `character_id=in.(${charIds.join(",")})`, event: "UPDATE" as const }] : []),
      ...(charIds.length ? [{ table: "characters", filter: `id=in.(${charIds.join(",")})`, event: "UPDATE" as const }] : []),
    ],
    [cid, charIds],
  );
  const live = useRealtime(
    `shield:${cid}`,
    subs,
    (ch) => {
      if (ch.table === "combats") setCombatTick((t) => t + 1);
      else if (ch.table === "npcs") void refetchNpcs();
      else if (ch.table === "roll_log") {
        const r = ch.new as unknown as RollRow;
        setRolls((list) => (list.some((x) => x.id === r.id) ? list : [r, ...list].slice(0, 80)));
      } else if (ch.table === "character_forms") {
        const f = ch.new as { id: string; pv_current?: number; pc_current?: number; conditions?: AgentRow["forms"][number]["conditions"]; pv_other_bonus?: number; pc_other_bonus?: number };
        setAgents((list) =>
          list.map((a) => ({
            ...a,
            forms: a.forms.map((x) =>
              x.id === f.id
                ? {
                    ...x,
                    pv_current: f.pv_current ?? x.pv_current,
                    pc_current: f.pc_current ?? x.pc_current,
                    pv_other_bonus: f.pv_other_bonus ?? x.pv_other_bonus,
                    pc_other_bonus: f.pc_other_bonus ?? x.pc_other_bonus,
                    conditions: f.conditions ?? x.conditions,
                  }
                : x,
            ),
          })),
        );
      } else router.refresh(); // vínculos, nível, troca de forma: recarrega do servidor
    },
    () => {
      void refetchNpcs();
      setCombatTick((t) => t + 1);
      router.refresh();
    },
  );
  // Quando o servidor manda dados novos (router.refresh), adota-os.
  const [seen, setSeen] = useState(data);
  if (seen !== data) {
    setSeen(data);
    setAgents(data.agents);
    setNpcs(data.npcs);
  }

  const ll = liveLabel(live);
  const tabs = [
    { id: "agentes" as Tab, label: "Agentes", icon: UsersRound, badge: data.party.filter((p) => p.status === "pending").length },
    { id: "combates" as Tab, label: "Combates", icon: Swords, badge: data.combats.filter((c) => c.status === "active").length },
    { id: "investigacao" as Tab, label: "Investigação", icon: Network },
    { id: "relatorios" as Tab, label: "Relatórios", icon: FileText },
    { id: "dados" as Tab, label: "Dados", icon: Dice5 },
    { id: "anotacoes" as Tab, label: "Anotações", icon: StickyNote },
  ];

  return (
    <div className="space-y-5 pb-24">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Link href={`/campanhas/${cid}`} className="inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
          <ArrowLeft className="h-4 w-4" aria-hidden /> Visão da campanha
        </Link>
        <span className={`font-mono text-[0.58rem] tracking-[0.2em] uppercase ${ll.cls}`}>● {ll.text}</span>
      </div>

      <header className="hud-panel relative overflow-hidden p-5">
        <div className="pointer-events-none absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,color-mix(in_oklab,var(--color-holo)_18%,transparent),transparent_60%)]" aria-hidden />
        <div className="relative flex flex-wrap items-end justify-between gap-4">
          <div>
            <p className="flex items-center gap-2 font-mono text-[0.62rem] tracking-[0.35em] text-holo uppercase">
              <ShieldIcon className="h-3.5 w-3.5" aria-hidden /> Escudo do Mestre · acesso restrito
            </p>
            <h1 className="mt-1 text-3xl tracking-[0.06em] text-fg uppercase text-glow">{data.campaign.name}</h1>
          </div>
          <dl className="grid grid-cols-3 gap-4 font-mono text-[0.6rem] tracking-[0.18em] text-fg-muted uppercase">
            <div>
              <dt>Agentes</dt>
              <dd className="text-xl text-cyan tabular-nums">{agents.length}</dd>
            </div>
            <div>
              <dt>NPCs</dt>
              <dd className="text-xl text-cyan tabular-nums">{npcs.length}</dd>
            </div>
            <div>
              <dt>Jogadores</dt>
              <dd className="text-xl text-cyan tabular-nums">{data.members.filter((m) => m.role === "player").length}</dd>
            </div>
          </dl>
        </div>
      </header>

      <HudTabs<Tab>
        tabs={tabs}
        storageKey={`france:shield-tab:${cid}`}
        render={(id) => {
          switch (id) {
            case "agentes":
              return <AgentsTab campaignId={cid} agents={agents} setAgents={setAgents} npcs={npcs} setNpcs={setNpcs} party={data.party} homebrew={data.homebrew} />;
            case "combates":
              return <CombatTab campaignId={cid} initialCombats={data.combats} initialCombatants={data.combatants} initialLog={data.combatLog} agents={agents} npcs={npcs} tick={combatTick} />;
            case "investigacao":
              return <InvestigationTab campaignId={cid} initial={data} />;
            case "relatorios":
              return <ReportsTab campaignId={cid} initial={data.reports} agents={agents} />;
            case "dados":
              return (
                <DicePanel
                  campaignId={cid}
                  rolls={rolls}
                  members={data.members}
                  myCharacters={agents.filter((a) => a.masterCanEdit).map((a) => ({ id: a.character.id, name: a.character.name }))}
                  isMaster
                  onRolled={(r) => setRolls((list) => [r, ...list.filter((x) => x.id !== r.id)].slice(0, 80))}
                />
              );
            case "anotacoes":
              return <NotesTab campaignId={cid} initial={data.notes} />;
          }
        }}
      />
    </div>
  );
}
