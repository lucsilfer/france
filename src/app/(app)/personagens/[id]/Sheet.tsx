"use client";

import Link from "next/link";
import { useEffect, useMemo, useState } from "react";
import { AnimatePresence, motion } from "motion/react";
import { ArrowLeft, Eye } from "lucide-react";
import { useRouter } from "next/navigation";
import { useToast } from "@/components/ui/Toast";
import { buildSheet, type ComputedSheet } from "@/rules/sheet.ts";
import type { CharacterBundle, CharacterRow, EffectRow, FormRow, HomebrewItemRow, ItemRow, PowerRow } from "@/lib/character";
import type { RollEntry } from "@/lib/rolls";
import { rollCheck } from "../actions";
import { IdentityCard } from "./IdentityCard";
import { ResourcePanel } from "./ResourcePanel";
import { AttributesSection } from "./AttributesSection";
import { SkillsSection } from "./SkillsSection";
import { RightPanel } from "./RightPanel";
import { RollTray } from "./RollTray";
import { FormSwitcher } from "./FormSwitcher";

export interface SheetState {
  character: CharacterRow;
  /** Forma ativa (base ou Lenda). */
  form: FormRow;
  base: FormRow;
  lenda: FormRow | null;
  isLenda: boolean;
  sheet: ComputedSheet;
  items: ItemRow[];
  powers: PowerRow[];
  effects: EffectRow[];
  homebrew: HomebrewItemRow[];
  canEdit: boolean;
  isOwner: boolean;
  setCharacter: (patch: Partial<CharacterRow>) => void;
  setForm: (patch: Partial<FormRow>) => void;
  refresh: () => void;
  /** Mostra um resultado (teste, ataque, poder) na janela de resultados. */
  showResult: (entry: RollEntry | null, pending?: boolean) => void;
}

export function Sheet({ bundle, initialRolls, homebrew }: { bundle: CharacterBundle; initialRolls: RollEntry[]; homebrew: HomebrewItemRow[] }) {
  const router = useRouter();
  const toast = useToast();
  const [character, setCharacterState] = useState(bundle.character);
  const [base, setBase] = useState(bundle.base);
  const [lenda, setLenda] = useState(bundle.lenda);
  const [rolls, setRolls] = useState(initialRolls);
  const [rolling, setRolling] = useState<string | null>(null);
  const [busy, setBusy] = useState(false);
  const [latest, setLatest] = useState<RollEntry | null>(null);

  // Sempre que o servidor devolve dados novos (após salvar), eles passam a valer.
  useEffect(() => {
    setCharacterState(bundle.character);
    setBase(bundle.base);
    setLenda(bundle.lenda);
  }, [bundle]);

  const isLenda = character.active_form === "lenda" && Boolean(lenda?.setup_complete);
  const form = isLenda && lenda ? lenda : base;

  const sheet = useMemo(
    () => buildSheet({ classId: character.class_id, originId: character.origin_id, level: character.level, form }),
    [character.class_id, character.origin_id, character.level, form],
  );

  const state: SheetState = {
    character,
    form,
    base,
    lenda,
    isLenda,
    sheet,
    items: bundle.items,
    powers: bundle.powers,
    effects: bundle.effects,
    homebrew,
    canEdit: bundle.canEdit,
    isOwner: bundle.isOwner,
    setCharacter: (patch) => setCharacterState((c) => ({ ...c, ...patch })),
    setForm: (patch) => (isLenda ? setLenda((f) => (f ? { ...f, ...patch } : f)) : setBase((f) => ({ ...f, ...patch }))),
    refresh: () => router.refresh(),
    showResult: (entry, pending = false) => {
      setBusy(pending);
      setLatest(entry);
      if (entry) setRolls((r) => [entry, ...r.filter((x) => x.id !== entry.id)].slice(0, 20));
    },
  };

  async function roll(kind: "attribute" | "skill", id: string) {
    if (!bundle.canEdit || rolling || busy) return;
    setRolling(`${kind}:${id}`);
    setLatest(null);
    const res = await rollCheck(character.id, kind, id, form.id);
    setRolling(null);
    if (!res.ok) return toast(res.error, "error");
    state.showResult(res.data!);
  }

  return (
    <div className="space-y-6 pb-40">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <Link href="/painel" className="inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
          <ArrowLeft className="h-4 w-4" aria-hidden /> Painel
        </Link>
        <div className="flex flex-wrap items-center gap-3">
          {!bundle.isOwner && (
            <span className="label-mono flex items-center gap-1.5 text-cyan">
              <Eye className="h-3.5 w-3.5" aria-hidden /> {bundle.canEdit ? "Ficha de jogador — edição autorizada" : "Ficha de jogador — somente leitura"}
            </span>
          )}
          {character.origin_id === "artificial" && <FormSwitcher state={state} />}
        </div>
      </div>

      <div className="grid gap-6 lg:grid-cols-[minmax(0,5fr)_minmax(0,6fr)] lg:items-start">
        <AnimatePresence mode="wait">
          <motion.div
            key={form.id}
            className="space-y-6"
            initial={{ opacity: 0, clipPath: "inset(0 0 100% 0)", filter: "hue-rotate(40deg) blur(2px)" }}
            animate={{ opacity: 1, clipPath: "inset(0 0 0% 0)", filter: "hue-rotate(0deg) blur(0px)" }}
            exit={{ opacity: 0, filter: "blur(3px)" }}
            transition={{ duration: 0.35, ease: [0.2, 0.8, 0.2, 1] }}
          >
            <IdentityCard state={state} />
            <ResourcePanel state={state} sheet={sheet} />
            <AttributesSection state={state} sheet={sheet} onRoll={(id) => roll("attribute", id)} rolling={rolling} />
            <SkillsSection state={state} sheet={sheet} onRoll={(id) => roll("skill", id)} rolling={rolling} />
          </motion.div>
        </AnimatePresence>
        <div className="lg:sticky lg:top-20">
          <RightPanel state={state} />
        </div>
      </div>

      <RollTray latest={latest} rolling={rolling !== null || busy} history={rolls} onClose={() => setLatest(null)} />
    </div>
  );
}
