"use client";

import { useState } from "react";
import { motion, AnimatePresence } from "motion/react";
import { BookOpenText, Swords, UsersRound } from "lucide-react";
import type { CampaignSummary, CharacterSummary, HomebrewEntry, Profile } from "@/lib/types";
import { SYSTEM_NAME } from "@/components/brand/Logo";
import { CharactersPanel } from "./CharactersPanel";
import { CampaignsPanel } from "./CampaignsPanel";
import { HomebrewPanel } from "./HomebrewPanel";

type Tab = "personagens" | "campanhas" | "homebrew";

const TABS: { id: Tab; label: string; icon: typeof Swords }[] = [
  { id: "personagens", label: "Personagens", icon: Swords },
  { id: "campanhas", label: "Campanhas", icon: UsersRound },
  { id: "homebrew", label: "Homebrew", icon: BookOpenText },
];

interface Props {
  profile: Profile;
  characters: CharacterSummary[];
  campaigns: CampaignSummary[];
  homebrew: HomebrewEntry[];
  loadError: string | null;
  initialTab: Tab;
}

export function Dashboard({ profile, characters, campaigns, homebrew, loadError, initialTab }: Props) {
  const [tab, setTab] = useState<Tab>(initialTab);

  function select(t: Tab) {
    setTab(t);
    const url = new URL(window.location.href);
    url.searchParams.set("aba", t);
    window.history.replaceState(null, "", url);
  }

  function onKey(e: React.KeyboardEvent, i: number) {
    if (e.key !== "ArrowRight" && e.key !== "ArrowLeft") return;
    e.preventDefault();
    const next = TABS[(i + (e.key === "ArrowRight" ? 1 : TABS.length - 1)) % TABS.length];
    select(next.id);
    document.getElementById(`tab-${next.id}`)?.focus();
  }

  const counts: Record<Tab, number> = { personagens: characters.length, campanhas: campaigns.length, homebrew: homebrew.length };

  return (
    <div className="space-y-10">
      <header className="flex flex-wrap items-end justify-between gap-4">
        <div className="space-y-2">
          <p className="label-mono">{SYSTEM_NAME} {"//"} Central de controle</p>
          <h1 className="text-3xl tracking-[0.06em] text-fg uppercase sm:text-4xl">
            Bem-vindo, <span className="text-holo text-glow">{profile.display_name || profile.username}</span>
          </h1>
        </div>
        <div className="flex gap-5 font-mono text-[0.62rem] tracking-[0.2em] text-fg-muted uppercase">
          {TABS.map((t) => (
            <span key={t.id}>
              <span className="block text-2xl tracking-normal text-fg tabular-nums">{String(counts[t.id]).padStart(2, "0")}</span>
              {t.label}
            </span>
          ))}
        </div>
      </header>

      {loadError && (
        <p role="alert" className="border border-alert/50 bg-alert/10 px-4 py-3 text-sm text-alert">
          {loadError}
        </p>
      )}

      <div role="tablist" aria-label="Módulos do sistema" className="grid grid-cols-3 gap-2 sm:gap-3">
        {TABS.map((t, i) => {
          const active = tab === t.id;
          const Icon = t.icon;
          return (
            <button
              key={t.id}
              id={`tab-${t.id}`}
              role="tab"
              aria-selected={active}
              aria-controls={`panel-${t.id}`}
              tabIndex={active ? 0 : -1}
              onClick={() => select(t.id)}
              onKeyDown={(e) => onKey(e, i)}
              className={`hud-panel hud-card relative flex flex-col items-start gap-1 px-3 py-3 text-left transition-colors sm:px-4 ${
                active ? "border-holo/80 bg-primary/10 shadow-[var(--shadow-glow)]" : "opacity-80 hover:opacity-100"
              }`}
            >
              <span className="font-mono text-[0.58rem] tracking-[0.25em] text-fg-muted">MOD.{String(i + 1).padStart(2, "0")}</span>
              <span className={`flex items-center gap-2 font-head text-sm font-semibold tracking-[0.18em] uppercase sm:text-base ${active ? "text-fg" : "text-fg-dim"}`}>
                <Icon className={`h-4 w-4 ${active ? "text-cyan" : "text-holo/70"}`} aria-hidden />
                {t.label}
              </span>
              {active && <motion.span layoutId="module-active" className="absolute inset-x-3 bottom-0 h-0.5 bg-cyan shadow-[0_0_8px_var(--color-cyan)]" />}
            </button>
          );
        })}
      </div>

      <AnimatePresence mode="wait">
        <motion.section
          key={tab}
          id={`panel-${tab}`}
          role="tabpanel"
          aria-labelledby={`tab-${tab}`}
          initial={{ opacity: 0, x: 12, filter: "blur(2px)" }}
          animate={{ opacity: 1, x: 0, filter: "blur(0px)" }}
          exit={{ opacity: 0, x: -12 }}
          transition={{ duration: 0.2 }}
        >
          {tab === "personagens" && <CharactersPanel characters={characters} />}
          {tab === "campanhas" && <CampaignsPanel campaigns={campaigns} />}
          {tab === "homebrew" && <HomebrewPanel entries={homebrew} />}
        </motion.section>
      </AnimatePresence>
    </div>
  );
}
