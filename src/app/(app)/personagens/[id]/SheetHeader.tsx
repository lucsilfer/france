"use client";

import { useState } from "react";
import { Camera } from "lucide-react";
import { Modal } from "@/components/ui/Modal";
import { useToast } from "@/components/ui/Toast";
import { HoloFrame, ImageField } from "@/components/media/ImageField";
import { discardMedia, primeMediaUrls, uploadMedia, useMediaUrl } from "@/components/media/media-client";
import { mediaPath } from "@/lib/media-shared";
import type { FormRow } from "@/lib/character";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { ORIGIN_BY_ID } from "@/rules/data/origins.ts";
import { removeFormPortrait, setFormPortrait } from "../portrait-actions";
import type { SheetState } from "./Sheet";

/** Cabeçalho da ficha: foto da forma ATIVA (a Lenda tem a sua, com moldura corrompida), nome, classe, origem e nível. */
export function SheetHeader({ state, portraits }: { state: SheetState; portraits: Record<string, string> }) {
  const { character: c, form, isLenda } = state;
  const [open, setOpen] = useState(false);
  primeMediaUrls(portraits);
  const url = useMediaUrl(form.portrait_path, form.portrait_path ? portraits[form.portrait_path] : null);
  const origin = c.origin_id ? ORIGIN_BY_ID[c.origin_id] : undefined;
  const path = origin?.paths?.find((p) => p.id === c.origin_path_id);
  const cls = c.class_id ? CLASS_BY_ID[c.class_id] : undefined;
  const title = isLenda ? form.name || "Forma Lenda" : c.name;

  return (
    <header className="hud-panel flex flex-col gap-5 p-4 pt-6 sm:flex-row sm:items-center sm:p-5 sm:pt-7">
      <span className="hud-tag">{isLenda ? "Forma Lenda" : "Unidade"}</span>
      <div className="relative mx-auto w-40 shrink-0 sm:mx-0 sm:w-36">
        <HoloFrame key={form.id} url={url} alt={`Foto de ${title}`} variant={isLenda ? "corrupted" : "holo"} />
        {state.isOwner && (
          <button
            type="button"
            onClick={() => setOpen(true)}
            className="absolute right-1.5 bottom-1.5 z-10 inline-flex items-center gap-1 border border-holo/60 bg-void/80 px-2 py-1 font-mono text-[0.58rem] tracking-[0.15em] text-cyan uppercase backdrop-blur hover:border-cyan"
          >
            <Camera className="h-3 w-3" aria-hidden /> Foto
          </button>
        )}
      </div>
      <div className="min-w-0 flex-1 space-y-2 text-center sm:text-left">
        <h1 className="truncate font-head text-3xl tracking-wide text-fg text-glow sm:text-4xl">{title || "Sem nome"}</h1>
        {isLenda && <p className="text-sm text-fg-dim">{c.name}</p>}
        <dl className="grid grid-cols-3 gap-3 font-mono text-[0.6rem] tracking-[0.18em] uppercase sm:max-w-lg">
          <div>
            <dt className="text-fg-muted">Classe</dt>
            <dd className="truncate text-sm tracking-normal text-fg normal-case">{(!isLenda && cls?.name) || (isLenda ? "—" : "Sem classe")}</dd>
          </div>
          <div>
            <dt className="text-fg-muted">Origem</dt>
            <dd className="truncate text-sm tracking-normal text-fg normal-case">
              {origin?.name ?? "—"}
              {path && <span className="text-fg-dim"> · {path.name}</span>}
            </dd>
          </div>
          <div>
            <dt className="text-fg-muted">Nível</dt>
            <dd className="font-display text-2xl leading-none text-holo text-glow">{String(c.level).padStart(2, "0")}</dd>
          </div>
        </dl>
      </div>
      {state.isOwner && <PortraitModal open={open} onClose={() => setOpen(false)} state={state} portraits={portraits} />}
    </header>
  );
}

function PortraitModal({ open, onClose, state, portraits }: { open: boolean; onClose: () => void; state: SheetState; portraits: Record<string, string> }) {
  const showLenda = state.character.origin_id === "artificial" && Boolean(state.lenda?.setup_complete);
  return (
    <Modal open={open} onClose={onClose} title="Foto do personagem" tag="Registro visual" size={showLenda ? "lg" : "md"}>
      <div className={`grid gap-6 ${showLenda ? "sm:grid-cols-2" : ""}`}>
        <FormPortrait characterId={state.character.id} onChange={state.patchForm} form={state.base} label={showLenda ? "Forma humana" : "Foto do personagem"} portraits={portraits} />
        {showLenda && state.lenda && <FormPortrait characterId={state.character.id} onChange={state.patchForm} form={state.lenda} label="Forma Lenda" portraits={portraits} corrupted />}
      </div>
      <p className="mt-4 text-xs text-fg-muted">PNG, JPG ou WebP. A imagem é recortada no seu aparelho e salva com até 2 MB. Só você pode trocá-la; o Mestre da campanha consegue vê-la.</p>
    </Modal>
  );
}

/** Foto de uma forma específica (a outra forma nunca é alterada). Usado na ficha e na criação. */
export function FormPortrait({
  characterId: cid,
  onChange,
  form,
  label,
  portraits,
  corrupted,
}: {
  characterId: string;
  onChange: (formId: string, patch: { portrait_path: string | null }) => void;
  form: Pick<FormRow, "id" | "kind" | "portrait_path">;
  label: string;
  portraits?: Record<string, string>;
  corrupted?: boolean;
}) {
  const toast = useToast();
  const url = useMediaUrl(form.portrait_path, form.portrait_path ? portraits?.[form.portrait_path] : null);
  const [fresh, setFresh] = useState<{ path: string; url: string | null } | null>(null);
  const shown = fresh && fresh.path === form.portrait_path ? fresh.url : url;
  return (
    <div className="space-y-2">
      <p className="label-mono text-center">{label}</p>
      <ImageField
        url={shown}
        label={label}
        variant={corrupted ? "corrupted" : "holo"}
        onUpload={async (blob, ext) => {
          const path = mediaPath("characters", cid, form.kind, ext);
          const up = await uploadMedia(path, blob);
          if (!up.ok) {
            toast(up.error, "error");
            return false;
          }
          const r = await setFormPortrait(cid, form.id, path);
          if (!r.ok) {
            await discardMedia(path);
            toast(r.error, "error");
            return false;
          }
          primeMediaUrls(r.data?.url ? { [path]: r.data.url } : undefined);
          setFresh({ path, url: r.data?.url ?? null });
          onChange(form.id, { portrait_path: path });
          toast(r.message ?? "Foto atualizada.");
          return true;
        }}
        onRemove={async () => {
          const r = await removeFormPortrait(cid, form.id);
          if (!r.ok) return toast(r.error, "error");
          onChange(form.id, { portrait_path: null });
          toast(r.message ?? "Foto removida.");
        }}
      />
    </div>
  );
}
