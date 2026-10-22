import type { Metadata } from "next";
import { getDashboardData } from "@/lib/queries";
import { Dashboard } from "./Dashboard";

export const metadata: Metadata = { title: "Painel" };

const TABS = ["personagens", "campanhas", "homebrew"] as const;

export default async function DashboardPage({ searchParams }: { searchParams: Promise<{ aba?: string }> }) {
  const { aba } = await searchParams;
  const data = await getDashboardData();
  const initialTab = (TABS as readonly string[]).includes(aba ?? "") ? (aba as (typeof TABS)[number]) : "personagens";
  return <Dashboard {...data} initialTab={initialTab} />;
}
