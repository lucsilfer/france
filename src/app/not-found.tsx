import Link from "next/link";
import { Logo, SYSTEM_NAME } from "@/components/brand/Logo";

export default function NotFound() {
  return (
    <main className="flex min-h-dvh flex-col items-center justify-center gap-5 px-4 text-center">
      <Logo size={96} />
      <p className="label-mono text-alert">{SYSTEM_NAME} {"//"} Erro 404</p>
      <h1 className="text-3xl tracking-[0.08em] text-fg uppercase">Módulo não encontrado</h1>
      <p className="text-fg-dim">O endereço solicitado não existe ou foi removido do sistema.</p>
      <Link href="/painel" className="mt-2 font-mono text-xs tracking-[0.2em] text-holo uppercase underline-offset-4 hover:text-cyan hover:underline">
        Voltar à central de controle
      </Link>
    </main>
  );
}
