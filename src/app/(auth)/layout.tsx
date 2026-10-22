import { Providers } from "@/components/Providers";
import { HoloEmblem, Logo, SYSTEM_NAME, SYSTEM_TAGLINE } from "@/components/brand/Logo";

function CircuitLines() {
  return (
    <svg className="pointer-events-none absolute inset-0 h-full w-full" preserveAspectRatio="none" viewBox="0 0 600 800" aria-hidden>
      <g fill="none" stroke="var(--color-line)" strokeWidth="1" opacity="0.7">
        <path d="M0 140 H120 L150 170 H260" />
        <path d="M0 640 H90 L130 600 H230" />
        <path d="M600 90 H470 L440 120 H380" />
        <path d="M600 700 H500 L470 730 H360" />
      </g>
      <g fill="var(--color-holo)">
        <circle cx="260" cy="170" r="2.5" />
        <circle cx="230" cy="600" r="2.5" />
        <circle cx="380" cy="120" r="2.5" />
        <circle cx="360" cy="730" r="2.5" />
      </g>
    </svg>
  );
}

export default function AuthLayout({ children }: { children: React.ReactNode }) {
  return (
    <Providers>
      <main className="grid min-h-dvh lg:grid-cols-[1.15fr_1fr]">
        {/* Lado esquerdo: identidade */}
        <section className="relative hidden overflow-hidden border-r border-line/70 lg:flex lg:flex-col lg:items-center lg:justify-center lg:p-12">
          <div aria-hidden className="pointer-events-none absolute top-1/2 left-1/2 h-[70vh] w-[70vh] -translate-x-1/2 -translate-y-1/2 rounded-full bg-primary/10 blur-[120px]" />
          <CircuitLines />
          <div className="scanline" aria-hidden />
          <p className="label-mono absolute top-8 left-10">
            {SYSTEM_NAME} {"//"} Tríade das Lendas
          </p>
          <div className="relative flex flex-col items-center gap-8 text-center">
            <HoloEmblem size={340} />
            <div>
              <h1 className="font-display text-5xl font-bold tracking-[0.32em] text-fg text-glow">{SYSTEM_NAME}</h1>
              <p className="mt-3 font-head text-lg tracking-[0.18em] text-fg-dim uppercase">{SYSTEM_TAGLINE}</p>
            </div>
          </div>
          <div className="absolute bottom-8 left-10 flex items-center gap-2 font-mono text-[0.62rem] tracking-[0.25em] text-fg-muted uppercase">
            <span className="h-1.5 w-1.5 rounded-full bg-cyan shadow-[0_0_8px_var(--color-cyan)]" aria-hidden />
            Sistema online · conexão segura
          </div>
        </section>

        {/* Lado direito: painel de acesso */}
        <section className="relative flex items-center justify-center px-4 py-10 sm:px-8">
          <div className="w-full max-w-md">
            <div className="mb-8 flex flex-col items-center gap-3 text-center lg:hidden">
              <Logo size={120} priority />
              <span className="font-display text-2xl font-bold tracking-[0.3em] text-fg text-glow">{SYSTEM_NAME}</span>
              <span className="font-mono text-[0.62rem] tracking-[0.25em] text-fg-dim uppercase">{SYSTEM_TAGLINE}</span>
            </div>
            {children}
          </div>
        </section>
      </main>
    </Providers>
  );
}
