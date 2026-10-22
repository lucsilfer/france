"use client";

import { useState, useTransition } from "react";
import { useRouter } from "next/navigation";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { useToast } from "@/components/ui/Toast";
import type { ActionResult } from "@/lib/types";

export function EmptyState({ icon, title, text, children }: { icon: React.ReactNode; title: string; text: string; children?: React.ReactNode }) {
  return (
    <div className="hud-panel flex flex-col items-center gap-4 px-6 py-14 text-center">
      <div className="text-cyan-dim">{icon}</div>
      <h2 className="text-xl text-fg">{title}</h2>
      <p className="max-w-md text-sm leading-relaxed text-fg-dim">{text}</p>
      {children}
    </div>
  );
}

export function SectionHeader({ title, subtitle, action }: { title: string; subtitle: string; action?: React.ReactNode }) {
  return (
    <div className="mb-6 flex flex-wrap items-end justify-between gap-4">
      <div>
        <h2 className="text-2xl text-fg">{title}</h2>
        <p className="mt-1 text-sm text-fg-dim">{subtitle}</p>
      </div>
      {action}
    </div>
  );
}

/** Executa uma ação de servidor após confirmação, com aviso de sucesso/erro. */
export function useConfirmedAction() {
  const router = useRouter();
  const toast = useToast();
  const [pending, startTransition] = useTransition();
  const [state, setState] = useState<{ title: string; description: React.ReactNode; confirmLabel: string; run: () => Promise<ActionResult<unknown>> } | null>(null);

  const dialog = (
    <ConfirmDialog
      open={state !== null}
      title={state?.title ?? ""}
      description={state?.description}
      confirmLabel={state?.confirmLabel}
      loading={pending}
      onCancel={() => setState(null)}
      onConfirm={() =>
        startTransition(async () => {
          if (!state) return;
          const res = await state.run();
          if (res.ok) {
            toast(res.message ?? "Feito.");
            setState(null);
            router.refresh();
          } else toast(res.error, "error");
        })
      }
    />
  );
  return { ask: setState, dialog };
}
