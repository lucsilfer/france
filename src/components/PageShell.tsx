import Link from "next/link";
import { ArrowLeft } from "lucide-react";
import { Ornament } from "@/components/ui/Ornament";

export function PageShell({ eyebrow, title, back = "/painel", backLabel = "Voltar ao painel", children }: {
  eyebrow: string;
  title: string;
  back?: string;
  backLabel?: string;
  children: React.ReactNode;
}) {
  return (
    <div className="mx-auto max-w-2xl">
      <Link href={back} className="mb-6 inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
        <ArrowLeft className="h-4 w-4" aria-hidden /> {backLabel}
      </Link>
      <div className="hud-panel px-5 pt-8 pb-6 sm:px-8">
        <span className="hud-tag">{eyebrow}</span>
        <h1 className="text-2xl text-fg sm:text-3xl">{title}</h1>
        <Ornament className="my-6" />
        {children}
      </div>
    </div>
  );
}
