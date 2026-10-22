"use client";

import { useEffect, useState } from "react";
import { MotionConfig } from "motion/react";
import { ToastProvider } from "./ui/Toast";

const KEY = "france:reduce-motion";

/**
 * Preferência "reduzir animações": do perfil (quando logado) ou a última salva
 * neste navegador (telas públicas). A preferência do sistema operacional sempre vale.
 */
export function Providers({ reduceMotion, children }: { reduceMotion?: boolean; children: React.ReactNode }) {
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
    <MotionConfig reducedMotion={reduce ? "always" : "user"}>
      <ToastProvider>{children}</ToastProvider>
    </MotionConfig>
  );
}
