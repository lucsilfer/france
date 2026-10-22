import type { Metadata } from "next";
import { AuthCard } from "../AuthCard";
import { NewPasswordForm } from "@/components/NewPasswordForm";

export const metadata: Metadata = { title: "Nova senha" };

export default function ResetPasswordPage() {
  return (
    <AuthCard eyebrow="Recuperação de acesso" title="Criar nova senha">
      <NewPasswordForm redirectTo="/painel" />
    </AuthCard>
  );
}
