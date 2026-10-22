"use client";

import Link from "next/link";
import { useState, useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Power } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { signInSchema, type SignInInput } from "@/lib/validation";
import { signIn } from "../actions";
import { FormError } from "../AuthCard";

export function LoginForm({ next }: { next?: string }) {
  const [pending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const form = useForm<SignInInput>({ resolver: zodResolver(signInSchema), defaultValues: { email: "", password: "" } });
  const { errors } = form.formState;

  const onSubmit = form.handleSubmit((values) => {
    setError(null);
    startTransition(async () => {
      const res = await signIn(values, next);
      // Em caso de sucesso o servidor redireciona; só chegamos aqui em erro.
      if (res && !res.ok) setError(res.error);
    });
  });

  return (
    <form onSubmit={onSubmit} noValidate className="space-y-5">
      <FormError message={error} />
      <Field label="E-mail" error={errors.email?.message}>
        <input type="email" autoComplete="email" className="field-input" {...form.register("email")} />
      </Field>
      <Field label="Senha" error={errors.password?.message}>
        <input type="password" autoComplete="current-password" className="field-input" {...form.register("password")} />
      </Field>
      <Button type="submit" loading={pending} className="w-full py-3.5 text-sm">
        {!pending && <Power className="h-4 w-4" aria-hidden />} Entrar
        <span className="ml-1 hidden font-mono text-[0.58rem] tracking-[0.2em] text-cyan/80 sm:inline">{"// ativar sessão"}</span>
      </Button>
      <div className="flex justify-end">
        <Link href="/recuperar-senha" className="text-sm text-fg-dim underline-offset-4 hover:text-cyan hover:underline">
          Recuperar senha
        </Link>
      </div>
    </form>
  );
}
