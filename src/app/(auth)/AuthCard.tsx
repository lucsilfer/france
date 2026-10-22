import { AlertTriangle, Info } from "lucide-react";
import { HudDivider } from "@/components/ui/Ornament";

export function AuthCard({ eyebrow, title, children, footer }: { eyebrow: string; title: string; children: React.ReactNode; footer?: React.ReactNode }) {
  return (
    <div className="hud-panel px-6 pt-9 pb-6 shadow-[0_0_80px_-40px_rgb(21_155_255/0.6)] sm:px-8">
      <span className="hud-tag">{eyebrow}</span>
      <h1 className="text-3xl tracking-[0.08em] text-fg uppercase">{title}</h1>
      <HudDivider className="my-5" label="autenticação" />
      {children}
      {footer && <div className="mt-6 border-t border-line/70 pt-5 text-sm text-fg-dim">{footer}</div>}
    </div>
  );
}

export function FormError({ message }: { message?: string | null }) {
  if (!message) return null;
  return (
    <p role="alert" className="flex items-start gap-2 border border-alert/50 bg-alert/10 px-3 py-2 text-sm text-alert">
      <AlertTriangle className="mt-0.5 h-4 w-4 shrink-0" aria-hidden /> {message}
    </p>
  );
}

export function FormNotice({ message }: { message?: string | null }) {
  if (!message) return null;
  return (
    <p role="status" className="flex items-start gap-2 border border-holo/50 bg-holo/5 px-3 py-2 text-sm text-fg">
      <Info className="mt-0.5 h-4 w-4 shrink-0 text-cyan" aria-hidden /> {message}
    </p>
  );
}
