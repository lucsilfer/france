"use client";

import { useEffect, useState } from "react";

export interface HudTab<T extends string> {
  id: T;
  label: string;
  badge?: number;
  icon?: React.ComponentType<{ className?: string }>;
}

/** Abas da central (mantém montadas as já abertas: trocar de aba é instantâneo e não perde o que estava aberto). */
export function HudTabs<T extends string>({
  tabs,
  storageKey,
  render,
  initial,
}: {
  tabs: HudTab<T>[];
  storageKey?: string;
  render: (id: T) => React.ReactNode;
  initial?: T;
}) {
  const [tab, setTab] = useState<T>(initial ?? tabs[0].id);
  const [visited, setVisited] = useState<ReadonlySet<T>>(() => new Set([initial ?? tabs[0].id]));
  useEffect(() => {
    if (!storageKey) return;
    try {
      const saved = window.localStorage.getItem(storageKey) as T | null;
      if (saved && tabs.some((t) => t.id === saved)) setTab(saved);
    } catch {
      // sem armazenamento: começa na primeira aba
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [storageKey]);
  useEffect(() => setVisited((v) => (v.has(tab) ? v : new Set(v).add(tab))), [tab]);

  function choose(t: T) {
    setTab(t);
    if (storageKey)
      try {
        window.localStorage.setItem(storageKey, t);
      } catch {
        // ignora
      }
  }
  function onKey(e: React.KeyboardEvent) {
    if (e.key !== "ArrowRight" && e.key !== "ArrowLeft") return;
    e.preventDefault();
    const i = tabs.findIndex((t) => t.id === tab);
    const next = tabs[(i + (e.key === "ArrowRight" ? 1 : tabs.length - 1)) % tabs.length];
    choose(next.id);
    document.getElementById(`hudtab-${next.id}`)?.focus();
  }

  return (
    <div className="hud-panel">
      <div role="tablist" className="flex overflow-x-auto border-b border-line">
        {tabs.map((t) => {
          const active = t.id === tab;
          const Icon = t.icon;
          return (
            <button
              key={t.id}
              id={`hudtab-${t.id}`}
              role="tab"
              aria-selected={active}
              aria-controls={`hudpanel-${t.id}`}
              tabIndex={active ? 0 : -1}
              onClick={() => choose(t.id)}
              onKeyDown={onKey}
              className={`relative flex shrink-0 items-center gap-1.5 px-4 py-3 font-mono text-[0.66rem] tracking-[0.18em] uppercase transition-colors ${active ? "text-fg" : "text-fg-muted hover:text-fg-dim"}`}
            >
              {Icon && <Icon className="h-3.5 w-3.5" />}
              {t.label}
              {!!t.badge && <span className="rounded-full bg-primary px-1.5 text-[0.58rem] text-fg">{t.badge}</span>}
              {active && <span className="absolute inset-x-2 -bottom-px h-0.5 bg-cyan shadow-[0_0_8px_var(--color-cyan)]" />}
            </button>
          );
        })}
      </div>
      {tabs
        .filter((t) => visited.has(t.id) || t.id === tab)
        .map((t) => (
          <div key={t.id} id={`hudpanel-${t.id}`} role="tabpanel" aria-labelledby={`hudtab-${t.id}`} hidden={t.id !== tab} className="p-4 sm:p-5">
            {render(t.id)}
          </div>
        ))}
    </div>
  );
}
