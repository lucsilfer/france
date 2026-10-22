"use client";

import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { useToast } from "@/components/ui/Toast";
import { resetPasswordSchema, type ResetPasswordInput } from "@/lib/validation";
import { updatePassword } from "@/app/(auth)/actions";

export function NewPasswordForm({ redirectTo }: { redirectTo?: string }) {
  const router = useRouter();
  const toast = useToast();
  const [pending, startTransition] = useTransition();
  const [error, setError] = useState<string | null>(null);
  const form = useForm<ResetPasswordInput>({ resolver: zodResolver(resetPasswordSchema), defaultValues: { password: "", confirmPassword: "" } });
  const { errors } = form.formState;

  const onSubmit = form.handleSubmit((values) => {
    setError(null);
    startTransition(async () => {
      const res = await updatePassword(values);
      if (!res.ok) return setError(res.error);
      toast(res.message ?? "Senha atualizada.");
      form.reset();
      if (redirectTo) router.replace(redirectTo);
    });
  });

  return (
    <form onSubmit={onSubmit} noValidate className="space-y-5">
      {error && (
        <p role="alert" className="text-sm text-alert">
          {error}
        </p>
      )}
      <Field label="Nova senha" error={errors.password?.message} hint="Mínimo de 8 caracteres, com letras e números">
        <input type="password" autoComplete="new-password" className="field-input" {...form.register("password")} />
      </Field>
      <Field label="Confirmar nova senha" error={errors.confirmPassword?.message}>
        <input type="password" autoComplete="new-password" className="field-input" {...form.register("confirmPassword")} />
      </Field>
      <Button type="submit" loading={pending}>
        Salvar senha
      </Button>
    </form>
  );
}
