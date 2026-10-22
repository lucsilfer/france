import type { Metadata } from "next";
import { PageShell } from "@/components/PageShell";
import { HomebrewForm } from "../HomebrewForm";

export const metadata: Metadata = { title: "Novo homebrew" };

export default function NewHomebrewPage() {
  return (
    <PageShell eyebrow="Homebrew" title="Novo conteúdo" back="/painel?aba=homebrew" backLabel="Voltar à biblioteca">
      <HomebrewForm />
    </PageShell>
  );
}
