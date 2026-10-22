import type { Metadata } from "next";
import { loadCampaignHub } from "@/lib/campaign";
import { CampaignHub } from "./CampaignHub";

export const metadata: Metadata = { title: "Campanha" };

export default async function CampaignPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  const data = await loadCampaignHub(id);
  return <CampaignHub data={data} />;
}
