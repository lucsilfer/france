"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";
import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import { useToast } from "@/components/ui/Toast";
import { campaignSchema, type CampaignInput } from "@/lib/validation";
import { createCampaign } from "../../actions";

export function CampaignForm() {
  const router = useRouter();
  const toast = useToast();
  const [pending, start] = useTransition();
  const form = useForm<CampaignInput>({ resolver: zodResolver(campaignSchema), defaultValues: { name: "", description: "", cover_url: "" } });
  const { errors } = form.formState;

  const onSubmit = form.handleSubmit((values) =>
    start(async () => {
      const res = await createCampaign(values);
      if (!res.ok) {
        for (const [k, msg] of Object.entries(res.fieldErrors ?? {})) form.setError(k as keyof CampaignInput, { message: msg });
        toast(res.error, "error");
        return;
      }
      toast(res.message ?? "Campanha criada.");
      router.push("/painel?aba=campanhas");
      router.refresh();
    }),
  );

  return (
    <form onSubmit={onSubmit} noValidate className="space-y-5">
      <Field label="Nome da campanha" error={errors.name?.message}>
        <input className="field-input" {...form.register("name")} />
      </Field>
      <Field label="Descrição" error={errors.description?.message}>
        <textarea rows={6} className="field-input resize-y" {...form.register("description")} />
      </Field>
      <Field label="Imagem de capa (opcional)" error={errors.cover_url?.message} hint="Link https:// de uma imagem já publicada.">
        <input type="url" inputMode="url" placeholder="https://" className="field-input" {...form.register("cover_url")} />
      </Field>
      <p className="text-sm text-fg-dim">Você será o Mestre desta campanha e receberá um link de convite para os jogadores.</p>
      <div className="flex justify-end">
        <Button type="submit" loading={pending}>
          Criar campanha
        </Button>
      </div>
    </form>
  );
}
