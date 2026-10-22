import type { Metadata } from "next";
import { PageShell } from "@/components/PageShell";
import { NewPasswordForm } from "@/components/NewPasswordForm";
import { getSessionProfile } from "@/lib/queries";
import { ProfileForm } from "./ProfileForm";

export const metadata: Metadata = { title: "Perfil" };

export default async function ProfilePage() {
  const { profile, user } = await getSessionProfile();
  return (
    <div className="space-y-10">
      <PageShell eyebrow="Perfil" title="Seu registro">
        <p className="mb-6 text-sm text-fg-dim">
          E-mail da conta: <span className="text-fg">{user.email}</span>
        </p>
        <ProfileForm
          defaults={{ username: profile.username, display_name: profile.display_name ?? "", reduce_motion: profile.reduce_motion }}
        />
      </PageShell>
      <div className="mx-auto max-w-2xl">
        <div className="hud-panel px-5 pt-8 pb-6 sm:px-8">
          <span className="hud-tag">Segurança</span>
          <h2 className="mb-6 text-xl text-fg">Trocar senha</h2>
          <NewPasswordForm />
        </div>
      </div>
    </div>
  );
}
