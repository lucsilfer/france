"use client";

import Link from "next/link";
import { useState, useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { recoverSchema, type RecoverInput } from "@/lib/validation";
import { requestPasswordReset } from "../actions";
import { AuthCard, FormError, FormNotice } from "../AuthCard";

export default function RecoverPage() {
  const [pending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const [notice, setNotice] = useState<string | null>(null);
  const form = useForm<RecoverInput>({ resolver: zodResolver(recoverSchema), defaultValues: { email: "" } });

  const onSubmit = form.handleSubmit((values) => {
    setError(null);
    startTransition(async () => {
      const res = await requestPasswordReset(values);
      if (res.ok) setNotice(res.message ?? null);
      else setError(res.error);
    });
  });

  return (
    <AuthCard
      eyebrow="Recuperação de acesso"
      title="Recuperar senha"
      footer={
        <Link href="/entrar" className="text-cyan underline-offset-4 hover:underline">
          Voltar para o login
        </Link>
      }
    >
      {notice ? (
        <FormNotice message={notice} />
      ) : (
        <form onSubmit={onSubmit} noValidate className="space-y-5">
          <FormError message={error} />
          <Field label="E-mail da conta" error={form.formState.errors.email?.message}>
            <input type="email" autoComplete="email" className="field-input" {...form.register("email")} />
          </Field>
          <Button type="submit" loading={pending} className="w-full">
            Enviar link
          </Button>
        </form>
      )}
    </AuthCard>
  );
}
