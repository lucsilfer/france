import type { Metadata } from "next";
import Link from "next/link";
import { AuthCard, FormError } from "../AuthCard";
import { LoginForm } from "./LoginForm";

export const metadata: Metadata = { title: "Entrar" };

export default async function LoginPage({ searchParams }: { searchParams: Promise<{ voltar?: string; erro?: string }> }) {
  const { voltar, erro } = await searchParams;
  return (
    <AuthCard
      eyebrow="Módulo de acesso"
      title="Acesso ao sistema"
      footer={
        <>
          Ainda não tem conta?{" "}
          <Link href="/cadastro" className="text-cyan underline-offset-4 hover:underline">
            Criar conta
          </Link>
        </>
      }
    >
      {erro === "link" && <FormError message="O link expirou ou já foi usado. Peça um novo." />}
      <LoginForm next={voltar} />
    </AuthCard>
  );
}
