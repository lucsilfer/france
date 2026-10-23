"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { ArrowLeft, Save } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { ImageField } from "@/components/media/ImageField";
import { discardMedia, primeMediaUrls, uploadMedia } from "@/components/media/media-client";
import { CreatureFields } from "@/components/homebrew/CreatureFields";
import { ItemFields, ModifierFields, OtherFields, WeaponFields } from "@/components/homebrew/ItemishFields";
import { L, Section } from "@/components/homebrew/kit";
import { mediaPath } from "@/lib/media-shared";
import { HOMEBREW_KINDS, type HomebrewEntry, type HomebrewKind } from "@/lib/types";
import type { ItemFormValue, ModifierFormValue, MonsterFormValue, NpcFormValue, OtherFormValue, WeaponFormValue } from "@/lib/homebrew";
import { saveHomebrewEntry } from "./actions";

const KIND_LABEL = Object.fromEntries(HOMEBREW_KINDS.map((k) => [k.id, k.label])) as Record<HomebrewKind, string>;

export interface EditorInitial {
  name: string;
  description: string;
  image_path: string | null;
  image_url: string | null;
  data: Record<string, unknown>;
}

/** Editor avançado de conteúdo Homebrew (seções expansíveis; imagem com recorte). */
export function EntryEditor({ kind, id, initial, userId, library }: { kind: HomebrewKind; id?: string; initial: EditorInitial; userId: string; library: HomebrewEntry[] }) {
  const router = useRouter();
  const toast = useToast();
  const [name, setName] = useState(initial.name);
  const [description, setDescription] = useState(initial.description);
  const [image, setImage] = useState<{ path: string | null; url: string | null }>({ path: initial.image_path, url: initial.image_url });
  const [data, setData] = useState<Record<string, unknown>>(initial.data);
  const [uploaded, setUploaded] = useState<string[]>([]);
  const [saving, start] = useTransition();
  const creature = kind === "monstro" || kind === "npc";
  const npc = data as unknown as NpcFormValue;
  const monster = data as unknown as MonsterFormValue;

  function save() {
    if (!name.trim()) return toast("Dê um nome.", "error");
    start(async () => {
      const r = await saveHomebrewEntry(kind, { name, description, image_path: image.path }, data, id);
      if (!r.ok) return toast(r.error, "error");
      // Imagens enviadas e depois trocadas antes de salvar: apaga as que sobraram.
      for (const p of uploaded) if (p !== image.path) void discardMedia(p);
      toast(r.message ?? "Salvo.");
      router.push(`/homebrew/${r.data!.id}`);
      router.refresh();
    });
  }

  return (
    <div className="mx-auto max-w-4xl space-y-5 pb-28">
      <Link href={id ? `/homebrew/${id}` : "/painel?aba=homebrew"} className="inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
        <ArrowLeft className="h-4 w-4" aria-hidden /> {id ? "Voltar ao conteúdo" : "Voltar à biblioteca"}
      </Link>

      <header className="hud-panel space-y-5 p-4 pt-7 sm:p-6 sm:pt-8">
        <span className="hud-tag">
          {id ? "Editar" : "Criar"} · {KIND_LABEL[kind]}
        </span>
        <div className="grid gap-5 sm:grid-cols-[13rem_1fr]">
          <ImageField
            url={image.url}
            label={`Imagem ${creature ? "da criatura" : "do conteúdo"}`}
            aspect={creature ? "portrait" : "square"}
            onUpload={async (blob, ext) => {
              const path = mediaPath("homebrew", userId, kind, ext);
              const up = await uploadMedia(path, blob);
              if (!up.ok) {
                toast(up.error, "error");
                return false;
              }
              setUploaded((u) => [...u, path]);
              setImage({ path, url: URL.createObjectURL(blob) });
              primeMediaUrls(undefined);
              return true;
            }}
            onRemove={() => setImage({ path: null, url: null })}
          />
          <div className="space-y-4">
            <L label="Nome">
              <input className="field-input text-lg" maxLength={120} value={name} onChange={(e) => setName(e.target.value)} placeholder={kind === "monstro" ? "Leshy" : ""} />
            </L>
            <L label="Descrição resumida">
              <textarea className="field-input" rows={4} maxLength={10000} value={description} onChange={(e) => setDescription(e.target.value)} />
            </L>
          </div>
        </div>
      </header>

      {kind === "monstro" && (
        <>
          <Section title="Informações básicas" defaultOpen>
            <div className="grid gap-3 sm:grid-cols-2">
              <L label="Categoria">
                <input className="field-input" maxLength={60} list="hb-monster-cats" value={monster.category} onChange={(e) => setData({ ...data, category: e.target.value })} />
              </L>
              <L label="Nível ou classificação (opcional)">
                <input className="field-input" maxLength={40} value={monster.level} onChange={(e) => setData({ ...data, level: e.target.value })} placeholder="5, Chefe, Ameaça B…" />
              </L>
            </div>
            <datalist id="hb-monster-cats">
              {["Folclore", "Lenda", "Fera", "Morto-vivo", "Espírito", "Aberração", "Humanoide", "Constructo"].map((c) => (
                <option key={c} value={c} />
              ))}
            </datalist>
            <L label="História ou origem">
              <textarea className="field-input" rows={4} value={monster.story} onChange={(e) => setData({ ...data, story: e.target.value })} />
            </L>
            <L label="Observações do Mestre (privadas)">
              <textarea className="field-input border-alert/40" rows={3} value={monster.master_notes} onChange={(e) => setData({ ...data, master_notes: e.target.value })} />
            </L>
          </Section>
          <CreatureFields value={monster} onChange={(v) => setData(v as unknown as Record<string, unknown>)} library={library} />
        </>
      )}

      {kind === "npc" && (
        <>
          <Section title="Informações" defaultOpen>
            <fieldset className="flex flex-wrap gap-4 text-sm text-fg-dim">
              <legend className="label-mono mb-1">Modalidade da ficha</legend>
              <label className="flex items-center gap-1.5">
                <input type="radio" className="accent-[var(--color-holo)]" checked={npc.mode === "simples"} onChange={() => setData({ ...data, mode: "simples" })} /> Simplificada (PV, PC, ataques e habilidades)
              </label>
              <label className="flex items-center gap-1.5">
                <input type="radio" className="accent-[var(--color-holo)]" checked={npc.mode === "completa"} onChange={() => setData({ ...data, mode: "completa" })} /> Completa (atributos, perícias, inventário)
              </label>
            </fieldset>
            <div className="grid gap-3 sm:grid-cols-[8rem_1fr]">
              <L label="Idade (opcional)">
                <input className="field-input" maxLength={40} value={npc.age} onChange={(e) => setData({ ...data, age: e.target.value })} />
              </L>
              <L label="Relação com a campanha">
                <input className="field-input" maxLength={5000} value={npc.relation} onChange={(e) => setData({ ...data, relation: e.target.value })} placeholder="Informante do grupo, rival…" />
              </L>
            </div>
            <L label="Descrição física">
              <textarea className="field-input" rows={3} value={npc.appearance} onChange={(e) => setData({ ...data, appearance: e.target.value })} />
            </L>
            <L label="Personalidade">
              <textarea className="field-input" rows={3} value={npc.personality} onChange={(e) => setData({ ...data, personality: e.target.value })} />
            </L>
            <L label="História">
              <textarea className="field-input" rows={4} value={npc.story} onChange={(e) => setData({ ...data, story: e.target.value })} />
            </L>
            <L label="Anotações secretas do Mestre (nunca vão para os jogadores)">
              <textarea className="field-input border-alert/40" rows={3} value={npc.master_notes} onChange={(e) => setData({ ...data, master_notes: e.target.value })} />
            </L>
            {npc.mode === "completa" && (
              <L label="Equipamentos">
                <textarea className="field-input" rows={2} value={npc.equipment} onChange={(e) => setData({ ...data, equipment: e.target.value })} />
              </L>
            )}
          </Section>
          <CreatureFields value={npc} onChange={(v) => setData(v as unknown as Record<string, unknown>)} simple={npc.mode === "simples"} library={library} showInventory />
        </>
      )}

      {kind === "arma" && <WeaponFields value={data as unknown as WeaponFormValue} onChange={(v) => setData(v as unknown as Record<string, unknown>)} name={name} library={library} />}
      {(kind === "item" || kind === "item_especial") && <ItemFields value={data as unknown as ItemFormValue} onChange={(v) => setData(v as unknown as Record<string, unknown>)} />}
      {kind === "modificador" && <ModifierFields value={data as unknown as ModifierFormValue} onChange={(v) => setData(v as unknown as Record<string, unknown>)} />}
      {kind === "outro" && <OtherFields value={data as unknown as OtherFormValue} onChange={(v) => setData(v as unknown as Record<string, unknown>)} />}

      <div className="sticky bottom-3 z-20 flex justify-end">
        <div className="hud-panel flex items-center gap-3 px-3 py-2 shadow-[0_8px_30px_-10px_black]">
          <span className="hidden text-xs text-fg-muted sm:inline">Salvo no Supabase · cópias já usadas em fichas e combates não mudam</span>
          <Button onClick={save} loading={saving}>
            <Save className="h-4 w-4" aria-hidden /> {id ? "Salvar alterações" : "Salvar na biblioteca"}
          </Button>
        </div>
      </div>
    </div>
  );
}
