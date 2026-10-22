/**
 * Logotipo oficial do F.R.A.N.C.E (arquivo enviado pelo autor, sem redesenho).
 * - france-logo-contorno-*.png: fundo removido + contorno branco do próprio desenho, para fundos escuros.
 * - france-logo.png: fundo removido, sem contorno (para fundos claros).
 * - france-logo-original.png: arquivo original preservado.
 */
export const LOGO = {
  small: "/brand/france-logo-contorno-96.png",
  medium: "/brand/france-logo-contorno-256.png",
  large: "/brand/france-logo-contorno-512.png",
  transparent: "/brand/france-logo.png",
  original: "/brand/france-logo-original.png",
} as const;

export const SYSTEM_NAME = "F.R.A.N.C.E";
export const SYSTEM_TAGLINE = "Sistema de Gerenciamento de Lendas";

export function Logo({ size = 40, glow = true, className = "", priority = false }: { size?: number; glow?: boolean; className?: string; priority?: boolean }) {
  const src = size <= 64 ? LOGO.small : size <= 200 ? LOGO.medium : LOGO.large;
  return (
    // eslint-disable-next-line @next/next/no-img-element
    <img
      src={src}
      alt="Logotipo F.R.A.N.C.E"
      width={size}
      height={size}
      loading={priority ? "eager" : "lazy"}
      decoding="async"
      className={`select-none object-contain ${glow ? "drop-shadow-[0_0_14px_rgb(72_199_255/0.45)]" : ""} ${className}`}
      draggable={false}
    />
  );
}

/** Logotipo + nome, para cabeçalho e menus. */
export function Wordmark({ size = "md" }: { size?: "md" | "lg" }) {
  const lg = size === "lg";
  return (
    <span className="inline-flex items-center gap-3">
      <Logo size={lg ? 72 : 36} priority />
      <span className="flex flex-col leading-none">
        <span className={`font-display font-bold tracking-[0.3em] text-fg ${lg ? "text-3xl sm:text-4xl" : "text-sm sm:text-base"}`}>{SYSTEM_NAME}</span>
        {lg && <span className="mt-2 font-mono text-[0.68rem] tracking-[0.28em] text-fg-dim uppercase">{SYSTEM_TAGLINE}</span>}
      </span>
    </span>
  );
}

/** Logotipo cercado por anéis holográficos giratórios (login, carregamento). */
export function HoloEmblem({ size = 280, spinning = true }: { size?: number; spinning?: boolean }) {
  return (
    <div className="relative grid place-items-center" style={{ width: size, height: size }} aria-hidden={false}>
      <svg viewBox="0 0 200 200" className={`absolute inset-0 h-full w-full ${spinning ? "animate-[spin_22s_linear_infinite]" : ""}`} aria-hidden>
        <circle cx="100" cy="100" r="96" fill="none" stroke="var(--color-line)" strokeWidth="0.6" />
        <circle cx="100" cy="100" r="96" fill="none" stroke="var(--color-holo)" strokeWidth="1.4" strokeDasharray="40 22 6 22" strokeLinecap="round" opacity="0.8" />
        {Array.from({ length: 36 }, (_, i) => (
          <line key={i} x1="100" y1="2" x2="100" y2={i % 3 === 0 ? 9 : 6} stroke="var(--color-line-strong)" strokeWidth="0.8" transform={`rotate(${i * 10} 100 100)`} />
        ))}
      </svg>
      <svg viewBox="0 0 200 200" className={`absolute inset-[9%] h-[82%] w-[82%] ${spinning ? "animate-[spin_14s_linear_infinite_reverse]" : ""}`} aria-hidden>
        <circle cx="100" cy="100" r="94" fill="none" stroke="var(--color-cyan)" strokeWidth="0.8" strokeDasharray="2 10" opacity="0.6" />
        <path d="M100 6 A94 94 0 0 1 194 100" fill="none" stroke="var(--color-primary)" strokeWidth="2" opacity="0.7" />
      </svg>
      <div className="absolute inset-[22%] rounded-full bg-primary/10 blur-2xl" aria-hidden />
      <Logo size={Math.round(size * 0.56)} priority className="relative" />
    </div>
  );
}
