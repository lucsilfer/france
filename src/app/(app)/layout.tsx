import Link from "next/link";
import { LogOut, UserRound } from "lucide-react";
import { Providers } from "@/components/Providers";
import { Logo, SYSTEM_NAME } from "@/components/brand/Logo";
import { StatusDot } from "@/components/hud/Panel";
import { getSessionProfile } from "@/lib/queries";
import { signOut } from "@/app/(auth)/actions";

export default async function AppLayout({ children }: { children: React.ReactNode }) {
  const { profile } = await getSessionProfile();
  const shown = profile.display_name || profile.username;

  return (
    <Providers reduceMotion={profile.reduce_motion}>
      <a href="#conteudo" className="sr-only focus:not-sr-only focus:fixed focus:top-2 focus:left-2 focus:z-50 focus:bg-panel focus:px-3 focus:py-2">
        Pular para o conteúdo
      </a>
      <header className="sticky top-0 z-40 border-b border-line/70 bg-void/80 backdrop-blur-md">
        <div className="mx-auto flex h-16 max-w-7xl items-center justify-between gap-3 px-4 sm:px-6">
          <Link href="/painel" aria-label={`${SYSTEM_NAME} — central de controle`} className="group flex items-center gap-3">
            <Logo size={38} priority className="transition-transform duration-300 group-hover:scale-105" />
            <span className="flex flex-col leading-none">
              <span className="font-display text-sm font-bold tracking-[0.3em] text-fg sm:text-base">{SYSTEM_NAME}</span>
              <span className="mt-1 hidden sm:block">
                <StatusDot tone="online" label="Sistema online" />
              </span>
            </span>
          </Link>
          <nav className="flex items-center gap-1 sm:gap-2" aria-label="Conta">
            <Link
              href="/perfil"
              className="flex items-center gap-2 border border-transparent px-2.5 py-1.5 text-sm text-fg-dim transition-colors hover:border-line hover:bg-panel-2/60 hover:text-cyan"
            >
              <UserRound className="h-4 w-4 text-holo" aria-hidden />
              <span className="max-w-[9rem] truncate font-head text-base tracking-wide">{shown}</span>
            </Link>
            <form action={signOut}>
              <button
                type="submit"
                className="flex items-center gap-2 border border-transparent px-2.5 py-1.5 font-mono text-[0.68rem] tracking-[0.18em] text-fg-muted uppercase transition-colors hover:border-alert/50 hover:text-alert"
              >
                <LogOut className="h-4 w-4" aria-hidden />
                <span className="hidden sm:inline">Sair</span>
              </button>
            </form>
          </nav>
        </div>
        <div className="h-px bg-gradient-to-r from-transparent via-holo/60 to-transparent" aria-hidden />
      </header>
      <main id="conteudo" className="mx-auto max-w-7xl px-4 py-8 sm:px-6 sm:py-10">
        {children}
      </main>
    </Providers>
  );
}
