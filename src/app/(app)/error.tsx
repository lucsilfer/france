"use client";

import { useEffect } from "react";
import { Button } from "@/components/ui/Button";

export default function AppError({ error, reset }: { error: Error & { digest?: string }; reset: () => void }) {
  useEffect(() => {
    console.error(error);
  }, [error]);
  return (
    <div role="alert" className="hud-panel mx-auto max-w-lg space-y-4 px-6 pt-8 pb-6 text-center">
      <span className="hud-tag text-alert">Falha de módulo</span>
      <h1 className="text-2xl tracking-[0.06em] text-fg uppercase">Não foi possível carregar o módulo</h1>
      <p className="text-sm text-fg-dim">Não foi possível carregar esta tela. Seus dados salvos não foram afetados.</p>
      {error.digest && <p className="label-mono">Código: {error.digest}</p>}
      <Button onClick={reset}>Tentar de novo</Button>
    </div>
  );
}
