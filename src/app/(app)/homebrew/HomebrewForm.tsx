"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { useToast } from "@/components/ui/Toast";
import { HOMEBREW_KINDS } from "@/lib/types";
import { homebrewSchema, type HomebrewInput } from "@/lib/validation";
import { saveHomebrew } from "../actions";

export function HomebrewForm({ id, defaults }: { id?: string; defaults?: Partial<HomebrewInput> }) {
  const router = useRouter();
  const toast = useToast();
  const [pending, start] = useTransition();
  const form = useForm<HomebrewInput>({
    resolver: zodResolver(homebrewSchema),
    defaultValues: { kind: "item", name: "", description: "", effect_dice: "", effect_kind: "", range: "", special_rules: "", ...defaults },
  });
  const { errors } = form.formState;

  const onSubmit = form.handleSubmit((values) =>
    start(async () => {
      const res = await saveHomebrew(values, id);
      if (!res.ok) {
        for (const [k, msg] of Object.entries(res.fieldErrors ?? {})) form.setError(k as keyof HomebrewInput, { message: msg });
        toast(res.error, "error");
        return;
      }
      toast(res.message ?? "Salvo.");
      router.push("/painel?aba=homebrew");
      router.refresh();
    }),
  );

  return (
    <form onSubmit={onSubmit} noValidate className="space-y-5">
      <div className="grid gap-5 sm:grid-cols-[12rem_1fr]">
        <Field label="Categoria" error={errors.kind?.message}>
          <select className="field-input" {...form.register("kind")}>
            {HOMEBREW_KINDS.map((k) => (
              <option key={k.id} value={k.id}>
                {k.label}
              </option>
            ))}
          </select>
        </Field>
        <Field label="Nome" error={errors.name?.message}>
          <input className="field-input" {...form.register("name")} />
        </Field>
      </div>
      <Field label="Descrição" error={errors.description?.message}>
        <textarea rows={5} className="field-input resize-y" {...form.register("description")} />
      </Field>
      <div className="grid gap-5 sm:grid-cols-3">
        <Field label="Dado de efeito" error={errors.effect_dice?.message} hint="Ex.: 1d6, 2d8+3, 1d12+1d6">
          <input className="field-input font-mono" placeholder="—" {...form.register("effect_dice")} />
        </Field>
        <Field label="Tipo de efeito" error={errors.effect_kind?.message}>
          <select className="field-input" {...form.register("effect_kind")}>
            <option value="">—</option>
            <option value="dano">Dano</option>
            <option value="cura">Cura</option>
            <option value="condicao">Condição</option>
            <option value="utilidade">Utilidade</option>
            <option value="personalizado">Personalizado</option>
            <option value="outro">Outro (antigo)</option>
          </select>
        </Field>
        <Field label="Alcance" error={errors.range?.message}>
          <input className="field-input" placeholder="Corpo a corpo, 12 m…" {...form.register("range")} />
        </Field>
      </div>
      <Field label="Regras especiais" error={errors.special_rules?.message}>
        <textarea rows={3} className="field-input resize-y" {...form.register("special_rules")} />
      </Field>
      <p className="text-xs text-fg-muted">
        Editores completos de monstros e NPCs (atributos, perícias, ataques, resistências) chegam na Fase 5; este formulário já salva o
        modelo na biblioteca.
      </p>
      <div className="flex justify-end">
        <Button type="submit" loading={pending}>
          {id ? "Salvar alterações" : "Salvar na biblioteca"}
        </Button>
      </div>
    </form>
  );
}
