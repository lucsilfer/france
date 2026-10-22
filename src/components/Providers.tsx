"use client";

import { createContext, useContext, useEffect, useState } from "react";
import { MotionConfig } from "motion/react";
import { ToastProvider } from "./ui/Toast";
import type { RollSpeed } from "@/lib/types";

const KEY = "france:reduce-motion";

interface Prefs {
  reduceMotion: boolean;
  rollSpeed: RollSpeed;
}
const PrefsContext = createContext<Prefs>({ reduceMotion: false, rollSpeed: "fast" });

/** Preferências do usuário (perfil) disponíveis em qualquer componente. */
export function usePrefs(): Prefs {
  return useContext(PrefsContext);
}

/**
 * Preferência "reduzir animações": do perfil (quando logado) ou a última salva
 * neste navegador (telas públicas). A preferência do sistema operacional sempre vale.
 */
export function Providers({ reduceMotion, rollSpeed = "fast", children }: { reduceMotion?: boolean; rollSpeed?: RollSpeed; children: React.ReactNode }) {
  const [stored, setStored] = useState(false);

  useEffect(() => {
    if (reduceMotion === undefined) {
      try {
        setStored(localStorage.getItem(KEY) === "true");
      } catch {}
      return;
    }
    document.documentElement.dataset.reduceMotion = String(reduceMotion);
    try {
      localStorage.setItem(KEY, String(reduceMotion));
    } catch {}
  }, [reduceMotion]);

  const reduce = reduceMotion ?? stored;
  return (
    <PrefsContext.Provider value={{ reduceMotion: reduce, rollSpeed }}>
      <MotionConfig reducedMotion={reduce ? "always" : "user"}>
        <ToastProvider>{children}</ToastProvider>
      </MotionConfig>
    </PrefsContext.Provider>
  );
}
