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

export function CampaignForm({ onDone }: { onDone?: () => void }) {
  const router = useRouter();
  const toast = useToast();
  const [pending, start] = useTransition();
  const form = useForm<CampaignInput>({ resolver: zodResolver(campaignSchema), defaultValues: { name: "", description: "", cover_url: "", players_see_party: true, invites_enabled: true } });
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
      onDone?.();
      router.push(`/campanhas/${res.data!.id}`);
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
      <fieldset className="space-y-2 rounded-sm border border-line bg-void/40 p-4">
        <legend className="label-mono px-1 text-holo">Privacidade</legend>
        <p className="text-xs text-fg-muted">A campanha é sempre privada: só quem entra pelo convite participa.</p>
        <label className="flex items-start gap-2 text-sm">
          <input type="checkbox" className="mt-1 accent-[var(--color-primary)]" {...form.register("invites_enabled")} />
          <span>
            <span className="block text-fg">Convite ativo</span>
            <span className="block text-xs text-fg-dim">Você pode desativar ou renovar o link a qualquer momento.</span>
          </span>
        </label>
        <label className="flex items-start gap-2 text-sm">
          <input type="checkbox" className="mt-1 accent-[var(--color-primary)]" {...form.register("players_see_party")} />
          <span>
            <span className="block text-fg">Jogadores veem o grupo</span>
            <span className="block text-xs text-fg-dim">Nome, classe, origem e nível dos personagens dos outros jogadores (nunca as fichas completas).</span>
          </span>
        </label>
      </fieldset>
      <p className="text-sm text-fg-dim">Você será o Mestre desta campanha e receberá um link de convite para os jogadores.</p>
      <div className="flex justify-end">
        <Button type="submit" loading={pending}>
          Criar campanha
        </Button>
      </div>
    </form>
  );
}
