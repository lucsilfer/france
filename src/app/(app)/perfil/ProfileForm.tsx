"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { useToast } from "@/components/ui/Toast";
import { profileSchema, type ProfileInput } from "@/lib/validation";
import { updateProfile } from "../actions";

const ROLL_SPEEDS = [
  { id: "instant", label: "Instantânea", hint: "Mostra o resultado sem animação." },
  { id: "fast", label: "Rápida", hint: "Animação de ~0,3 s (padrão)." },
  { id: "normal", label: "Normal", hint: "Animação de ~0,8 s." },
] as const;

export function ProfileForm({ defaults }: { defaults: ProfileInput }) {
  const router = useRouter();
  const toast = useToast();
  const [pending, start] = useTransition();
  const form = useForm<ProfileInput>({ resolver: zodResolver(profileSchema), defaultValues: defaults });
  const { errors, isDirty } = form.formState;

  const onSubmit = form.handleSubmit((values) =>
    start(async () => {
      const res = await updateProfile(values);
      if (!res.ok) {
        for (const [k, msg] of Object.entries(res.fieldErrors ?? {})) form.setError(k as keyof ProfileInput, { message: msg });
        toast(res.error, "error");
        return;
      }
      toast(res.message ?? "Perfil salvo.");
      form.reset(values);
      router.refresh();
    }),
  );

  return (
    <form onSubmit={onSubmit} noValidate className="space-y-5">
      <Field label="Nome de usuário" error={errors.username?.message}>
        <input autoComplete="username" className="field-input" {...form.register("username")} />
      </Field>
      <Field label="Nome de exibição" error={errors.display_name?.message} hint="Opcional — aparece no topo e nas campanhas.">
        <input className="field-input" {...form.register("display_name")} />
      </Field>
      <label className="flex cursor-pointer items-start gap-3 rounded-sm border border-line bg-void/40 p-4">
        <input type="checkbox" className="mt-1 h-4 w-4 accent-[var(--color-primary)]" {...form.register("reduce_motion")} />
        <span>
          <span className="block text-fg">Reduzir animações</span>
          <span className="block text-sm text-fg-dim">
            Desliga transições e animações de dados. O sistema também respeita a preferência de movimento do seu dispositivo.
          </span>
        </span>
      </label>
      <fieldset className="rounded-sm border border-line bg-void/40 p-4">
        <legend className="label-mono px-1 text-holo">Velocidade das rolagens</legend>
        <div className="grid gap-2 sm:grid-cols-3">
          {ROLL_SPEEDS.map((o) => (
            <label key={o.id} className="flex cursor-pointer items-start gap-2 rounded-sm border border-line/70 p-3 has-[:checked]:border-holo has-[:checked]:bg-primary/10">
              <input type="radio" value={o.id} className="mt-1 accent-[var(--color-primary)]" {...form.register("roll_speed")} />
              <span>
                <span className="block text-fg">{o.label}</span>
                <span className="block text-xs text-fg-dim">{o.hint}</span>
              </span>
            </label>
          ))}
        </div>
        <p className="mt-2 text-xs text-fg-muted">Com “Reduzir animações” ligado, as rolagens são sempre instantâneas.</p>
      </fieldset>
      <div className="flex justify-end">
        <Button type="submit" loading={pending} disabled={!isDirty}>
          Salvar perfil
        </Button>
      </div>
    </form>
  );
}
