"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { signUpSchema, type SignUpInput } from "@/lib/validation";
import { signUp } from "../actions";
import { FormError, FormNotice } from "../AuthCard";

export function SignUpForm() {
  const router = useRouter();
  const [pending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const [sentTo, setSentTo] = useState<string | null>(null);
  const form = useForm<SignUpInput>({
    resolver: zodResolver(signUpSchema),
    defaultValues: { username: "", email: "", password: "", confirmPassword: "" },
  });
  const { errors } = form.formState;

  const onSubmit = form.handleSubmit((values) => {
    setError(null);
    startTransition(async () => {
      const res = await signUp(values);
      if (!res.ok) {
        setError(res.error);
        for (const [k, msg] of Object.entries(res.fieldErrors ?? {})) form.setError(k as keyof SignUpInput, { message: msg });
        return;
      }
      if (res.data?.needsConfirmation) setSentTo(values.email);
      else router.replace("/painel");
    });
  });

  if (sentTo) {
    return (
      <FormNotice
        message={`Conta criada. Enviamos um link de confirmação para ${sentTo}. Abra o e-mail para ativar seu acesso.`}
      />
    );
  }

  return (
    <form onSubmit={onSubmit} noValidate className="space-y-5">
      <FormError message={error} />
      <Field label="Nome de usuário" error={errors.username?.message} hint="3 a 24 caracteres: letras, números, ponto, hífen ou _">
        <input autoComplete="username" className="field-input" {...form.register("username")} />
      </Field>
      <Field label="E-mail" error={errors.email?.message}>
        <input type="email" autoComplete="email" className="field-input" {...form.register("email")} />
      </Field>
      <Field label="Senha" error={errors.password?.message} hint="Mínimo de 8 caracteres, com letras e números">
        <input type="password" autoComplete="new-password" className="field-input" {...form.register("password")} />
      </Field>
      <Field label="Confirmar senha" error={errors.confirmPassword?.message}>
        <input type="password" autoComplete="new-password" className="field-input" {...form.register("confirmPassword")} />
      </Field>
      <Button type="submit" loading={pending} className="w-full">
        Criar conta
      </Button>
    </form>
  );
}
