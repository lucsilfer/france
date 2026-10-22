import type { Metadata } from "next";
import Link from "next/link";
import { PageShell } from "@/components/PageShell";
import { requireUser } from "@/lib/supabase/server";
import { JoinButton } from "./JoinButton";

export const metadata: Metadata = { title: "Convite de campanha" };

type Preview = { id: string; name: string; description: string; master_username: string; already_member: boolean };

export default async function InvitePage({ params }: { params: Promise<{ code: string }> }) {
  const { code } = await params;
  const { supabase } = await requireUser();
  const valid = /^[a-f0-9]{18}$/.test(code);
  const { data } = valid ? await supabase.rpc("campaign_invite_preview", { p_code: code }) : { data: null };
  const preview = (Array.isArray(data) ? data[0] : null) as Preview | null;

  if (!preview) {
    return (
      <PageShell eyebrow="Convite" title="Convite inválido">
        <p className="text-fg-dim">Este link não existe mais ou foi substituído pelo Mestre. Peça um novo convite.</p>
      </PageShell>
    );
  }

  return (
    <PageShell eyebrow="Convite" title={preview.name}>
      <div className="space-y-5">
        <p className="label-mono">Mestre: {preview.master_username}</p>
        {preview.description && <p className="whitespace-pre-line text-fg-dim">{preview.description}</p>}
        {preview.already_member ? (
          <p className="text-fg">
            Você já participa desta campanha.{" "}
            <Link href="/painel?aba=campanhas" className="text-cyan underline-offset-4 hover:underline">
              Ver campanhas
            </Link>
          </p>
        ) : (
          <>
            <div className="rounded-sm border border-cyan-dim/50 bg-cyan/5 p-4 text-sm leading-relaxed text-fg-dim">
              Ao entrar você será <strong className="text-fg">Jogador</strong>. Quando vincular um personagem à campanha, o Mestre poderá
              ver a ficha e, se você autorizar, alterar atributos, PV, PC e outros dados durante as sessões. Você poderá revogar essa
              autorização a qualquer momento.
            </div>
            <JoinButton code={code} />
          </>
        )}
      </div>
    </PageShell>
  );
}
