import type { Metadata } from "next";
import Link from "next/link";
import { AuthCard } from "../AuthCard";
import { SignUpForm } from "./SignUpForm";

export const metadata: Metadata = { title: "Criar conta" };

export default function SignUpPage() {
  return (
    <AuthCard
      eyebrow="Novo operador"
      title="Criar conta"
      footer={
        <>
          Já tem conta?{" "}
          <Link href="/entrar" className="text-cyan underline-offset-4 hover:underline">
            Entrar
          </Link>
        </>
      }
    >
      <SignUpForm />
    </AuthCard>
  );
}
