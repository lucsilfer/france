import { Logo } from "@/components/brand/Logo";

/** Tela de carregamento com o logotipo e uma linha de progresso contínua. */
export function LoadingScreen({ label = "Carregando módulo" }: { label?: string }) {
  return (
    <div role="status" aria-live="polite" className="flex min-h-[45vh] flex-col items-center justify-center gap-5">
      <div className="relative grid place-items-center">
        <svg viewBox="0 0 100 100" className="absolute h-28 w-28 animate-[spin_1.6s_linear_infinite]" aria-hidden>
          <circle cx="50" cy="50" r="46" fill="none" stroke="var(--color-line)" strokeWidth="1" />
          <circle cx="50" cy="50" r="46" fill="none" stroke="var(--color-holo)" strokeWidth="2" strokeDasharray="60 230" strokeLinecap="round" />
        </svg>
        <Logo size={64} />
      </div>
      <div className="h-0.5 w-40 overflow-hidden bg-line/60" aria-hidden>
        <div className="h-full w-1/3 animate-[loading_1.1s_ease-in-out_infinite] bg-holo shadow-[0_0_8px_var(--color-holo)]" />
      </div>
      <span className="label-mono">{label}…</span>
      <style>{`@keyframes loading{0%{transform:translateX(-100%)}100%{transform:translateX(300%)}}`}</style>
    </div>
  );
}
