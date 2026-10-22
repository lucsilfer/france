import type { Metadata } from "next";
import { PageShell } from "@/components/PageShell";
import { CampaignForm } from "./CampaignForm";

export const metadata: Metadata = { title: "Nova campanha" };

export default function NewCampaignPage() {
  return (
    <PageShell eyebrow="Nova campanha" title="Abrir uma campanha" back="/painel?aba=campanhas" backLabel="Voltar às campanhas">
      <CampaignForm />
    </PageShell>
  );
}
