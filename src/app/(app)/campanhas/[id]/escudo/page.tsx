import type { Metadata } from "next";
import { loadShield } from "@/lib/campaign";
import { Shield } from "./Shield";

export const metadata: Metadata = { title: "Escudo do Mestre" };

export default async function ShieldPage({ params }: { params: Promise<{ id: string }> }) {
  const { id } = await params;
  // loadShield redireciona quem não é o Mestre desta campanha.
  const data = await loadShield(id);
  return <Shield data={data} />;
}
