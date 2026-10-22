"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { Copy, Crown, DoorOpen, Link2, Plus, RefreshCw, Trash2, UsersRound } from "lucide-react";
import type { CampaignSummary } from "@/lib/types";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { deleteCampaign, leaveCampaign, regenerateInvite } from "../actions";
import { EmptyState, SectionHeader, useConfirmedAction } from "./shared";

function inviteUrl(code: string) {
  return `${window.location.origin}/convite/${code}`;
}

function JoinByCode() {
  const router = useRouter();
  const toast = useToast();
  const [value, setValue] = useState("");
  const code = value.trim().match(/[a-f0-9]{18}/)?.[0];
  return (
    <form
      className="flex w-full max-w-md gap-2"
      onSubmit={(e) => {
        e.preventDefault();
        if (!code) return toast("Cole o link ou o código do convite.", "error");
        router.push(`/convite/${code}`);
      }}
    >
      <label htmlFor="join-code" className="sr-only">
        Link ou código de convite
      </label>
      <input
        id="join-code"
        value={value}
        onChange={(e) => setValue(e.target.value)}
        placeholder="Cole o link de convite"
        className="field-input py-2 text-sm"
      />
      <Button type="submit" variant="secondary" size="sm">
        Entrar
      </Button>
    </form>
  );
}

function CampaignCard({ c, onAsk }: { c: CampaignSummary; onAsk: ReturnType<typeof useConfirmedAction>["ask"] }) {
  const toast = useToast();
  const router = useRouter();
  const [pending, start] = useTransition();
  const isMaster = c.role === "master";

  async function copy() {
    if (!c.invite_code) return;
    try {
      await navigator.clipboard.writeText(inviteUrl(c.invite_code));
      toast("Link de convite copiado.");
    } catch {
      toast("Não foi possível copiar. Selecione e copie o link manualmente.", "error");
    }
  }

  return (
    <li className="hud-panel hud-card overflow-hidden">
      {c.cover_url ? (
        // eslint-disable-next-line @next/next/no-img-element
        <img src={c.cover_url} alt="" className="h-32 w-full object-cover opacity-80" loading="lazy" referrerPolicy="no-referrer" />
      ) : (
        <div aria-hidden className="h-20 bg-gradient-to-br from-primary-deep/40 via-panel-3 to-panel" />
      )}
      <div className="space-y-3 p-5">
        <div className="flex items-start justify-between gap-3">
          <h3 className="text-lg text-fg">{c.name}</h3>
          <span
            className={`label-mono flex shrink-0 items-center gap-1 rounded-sm border px-2 py-0.5 ${
              isMaster ? "border-cyan-dim text-cyan" : "border-line-strong text-fg-dim"
            }`}
          >
            {isMaster && <Crown className="h-3 w-3" aria-hidden />}
            {isMaster ? "Mestre" : "Jogador"}
          </span>
        </div>
        {c.description && <p className="line-clamp-3 text-sm text-fg-dim">{c.description}</p>}
        <p className="flex items-center gap-1.5 text-xs text-fg-muted">
          <UsersRound className="h-3.5 w-3.5" aria-hidden /> {c.member_count} {c.member_count === 1 ? "participante" : "participantes"}
        </p>

        {isMaster && c.invite_code && (
          <div className="space-y-2 rounded-sm border border-line bg-void/50 p-3">
            <p className="label-mono flex items-center gap-1.5">
              <Link2 className="h-3 w-3" aria-hidden /> Convite
            </p>
            <p className="truncate font-mono text-xs text-fg-dim" title="Link de convite">
              /convite/{c.invite_code}
            </p>
            <div className="flex flex-wrap gap-2">
              <Button size="sm" variant="secondary" onClick={copy}>
                <Copy className="h-3.5 w-3.5" aria-hidden /> Copiar link
              </Button>
              <Button
                size="sm"
                variant="ghost"
                loading={pending}
                onClick={() =>
                  start(async () => {
                    const res = await regenerateInvite(c.id);
                    if (res.ok) {
                      toast(res.message ?? "Novo link gerado.");
                      router.refresh();
                    } else toast(res.error, "error");
                  })
                }
              >
                <RefreshCw className="h-3.5 w-3.5" aria-hidden /> Novo link
              </Button>
            </div>
          </div>
        )}

        <div className="flex justify-end border-t border-line pt-3">
          {isMaster ? (
            <Button
              size="sm"
              variant="danger"
              onClick={() =>
                onAsk({
                  title: "Excluir campanha?",
                  description: (
                    <>
                      <strong className="text-fg">{c.name}</strong> será apagada com combates, investigações, relatórios e anotações.
                      As fichas dos jogadores continuam existindo, apenas desvinculadas.
                    </>
                  ),
                  confirmLabel: "Excluir campanha",
                  run: () => deleteCampaign(c.id),
                })
              }
            >
              <Trash2 className="h-3.5 w-3.5" aria-hidden /> Excluir
            </Button>
          ) : (
            <Button
              size="sm"
              variant="ghost"
              onClick={() =>
                onAsk({
                  title: "Sair da campanha?",
                  description: "Você perderá o acesso até receber um novo convite. Seu personagem continua salvo na sua conta.",
                  confirmLabel: "Sair",
                  run: () => leaveCampaign(c.id),
                })
              }
            >
              <DoorOpen className="h-3.5 w-3.5" aria-hidden /> Sair
            </Button>
          )}
        </div>
      </div>
    </li>
  );
}

export function CampaignsPanel({ campaigns }: { campaigns: CampaignSummary[] }) {
  const { ask, dialog } = useConfirmedAction();
  const create = (
    <Link
      href="/campanhas/nova"
      className="chamfer inline-flex items-center gap-2 border border-holo/60 bg-gradient-to-r from-primary-deep to-primary/80 px-5 py-2.5 font-mono text-xs font-medium tracking-[0.18em] text-fg uppercase transition-[background,color] hover:from-primary/90 hover:to-holo/90 hover:text-white"
    >
      <Plus className="h-4 w-4" aria-hidden /> Criar campanha
    </Link>
  );

  return (
    <div className="space-y-6">
      {campaigns.length === 0 ? (
        <EmptyState
          icon={<UsersRound className="h-10 w-10" aria-hidden />}
          title="Nenhuma campanha ainda"
          text="Crie uma campanha para ser o Mestre e convidar jogadores por link — ou cole abaixo um convite que você recebeu."
        >
          {create}
          <JoinByCode />
        </EmptyState>
      ) : (
        <>
          <SectionHeader title="Campanhas" subtitle="Campanhas que você mestra ou das quais participa." action={create} />
          <JoinByCode />
          <ul className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {campaigns.map((c) => (
              <CampaignCard key={c.id} c={c} onAsk={ask} />
            ))}
          </ul>
        </>
      )}
      {dialog}
    </div>
  );
}
