"use client";

import { useRouter } from "next/navigation";
import { useTransition } from "react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { joinCampaign } from "../../actions";

export function JoinButton({ code }: { code: string }) {
  const router = useRouter();
  const toast = useToast();
  const [pending, start] = useTransition();
  return (
    <Button
      loading={pending}
      onClick={() =>
        start(async () => {
          const res = await joinCampaign(code);
          if (!res.ok) return toast(res.error, "error");
          toast(res.message ?? "Você entrou na campanha.");
          router.push("/painel?aba=campanhas");
          router.refresh();
        })
      }
    >
      Entrar na campanha
    </Button>
  );
}
