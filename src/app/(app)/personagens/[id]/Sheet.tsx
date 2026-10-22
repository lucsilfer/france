"use client";

import Link from "next/link";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { ArrowLeft, Eye } from "lucide-react";
import { useRouter } from "next/navigation";
import { usePrefs } from "@/components/Providers";
import { useToast } from "@/components/ui/Toast";
import { abilityStatus, powersTabInfo, type AbilityStatus, type PowersTabInfo } from "@/rules/abilities.ts";
import { buildSheet, type ComputedSheet } from "@/rules/sheet.ts";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import type { CharacterBundle, CharacterRow, EffectRow, FormRow, HomebrewItemRow, ItemRow, PowerRow } from "@/lib/character";
import type { RollEntry } from "@/lib/rolls";
import type { RollSpeed } from "@/lib/types";
import { rollCheck, setActiveForm } from "../actions";
import { IdentityCard } from "./IdentityCard";
import { ResourcePanel } from "./ResourcePanel";
import { AttributesSection } from "./AttributesSection";
import { SkillsSection } from "./SkillsSection";
import { RightPanel, type Tab } from "./RightPanel";
import { RollStack, type RollCard } from "./RollTray";
import { FormSwitcher } from "./FormSwitcher";

type Updater<T> = (fn: (prev: T) => T) => void;

export interface SheetState {
  character: CharacterRow;
  /** Forma ativa (base ou Lenda). */
  form: FormRow;
  base: FormRow;
  lenda: FormRow | null;
  isLenda: boolean;
  /** Prodígio: não usa PC (sem barra, sem custo, sem limites). */
  noPc: boolean;
  sheet: ComputedSheet;
  items: ItemRow[];
  powers: PowerRow[];
  effects: EffectRow[];
  homebrew: HomebrewItemRow[];
  abilities: AbilityStatus;
  powersTab: PowersTabInfo;
  canEdit: boolean;
  isOwner: boolean;
  rollSpeed: RollSpeed;
  setCharacter: (patch: Partial<CharacterRow>) => void;
  /** Atualiza a forma ATIVA. Para respostas assíncronas, prefira patchForm com o id da forma usada. */
  setForm: (patch: Partial<FormRow>) => void;
  patchForm: (formId: string, patch: Partial<FormRow>) => void;
  setItems: Updater<ItemRow[]>;
  setPowers: Updater<PowerRow[]>;
  setEffects: Updater<EffectRow[]>;
  setHomebrew: Updater<HomebrewItemRow[]>;
  /** Recarrega tudo do servidor (usado só quando necessário, ex.: evolução de nível). */
  refresh: () => void;
  /** Janelas de rolagem: abre na hora do clique e preenche quando o servidor responde. */
  beginRoll: (label: string) => string;
  finishRoll: (token: string, entry: RollEntry) => void;
  failRoll: (token: string) => void;
  tab: Tab;
  setTab: (t: Tab) => void;
  /** Abre a aba de poderes já com o criador aberto. */
  openCreator: () => void;
  creatorRequest: number;
  switchForm: (kind: "base" | "lenda") => void;
}

let tokenSeq = 0;
const MAX_CARDS = 3;

export function Sheet({ bundle, initialRolls, homebrew: initialHomebrew }: { bundle: CharacterBundle; initialRolls: RollEntry[]; homebrew: HomebrewItemRow[] }) {
  const router = useRouter();
  const toast = useToast();
  const prefs = usePrefs();
  const [character, setCharacterState] = useState(bundle.character);
  const [base, setBase] = useState(bundle.base);
  const [lenda, setLenda] = useState(bundle.lenda);
  const [items, setItems] = useState(bundle.items);
  const [powers, setPowers] = useState(bundle.powers);
  const [effects, setEffects] = useState(bundle.effects);
  const [homebrew, setHomebrew] = useState(initialHomebrew);
  const [history, setHistory] = useState(initialRolls);
  const [cards, setCards] = useState<RollCard[]>([]);
  const [inflight, setInflight] = useState<ReadonlySet<string>>(new Set());
  const [tab, setTab] = useState<Tab>("rapido");
  const [creatorRequest, setCreatorRequest] = useState(0);
  const [fx, setFx] = useState(0);

  // Alternância de forma: otimista e serializada (cliques rápidos nunca se perdem nem se sobrepõem).
  const desiredForm = useRef(bundle.character.active_form);
  const confirmedForm = useRef(bundle.character.active_form);
  const savingForm = useRef(false);

  // Dados novos do servidor (após recarregar) passam a valer, sem desfazer uma troca de forma em andamento.
  useEffect(() => {
    setCharacterState(() => (savingForm.current ? { ...bundle.character, active_form: desiredForm.current } : bundle.character));
    if (!savingForm.current) {
      desiredForm.current = bundle.character.active_form;
      confirmedForm.current = bundle.character.active_form;
    }
    setBase(bundle.base);
    setLenda(bundle.lenda);
    setItems(bundle.items);
    setPowers(bundle.powers);
    setEffects(bundle.effects);
  }, [bundle]);
  useEffect(() => setHomebrew(initialHomebrew), [initialHomebrew]);

  const isLenda = character.active_form === "lenda" && Boolean(lenda?.setup_complete);
  const form = isLenda && lenda ? lenda : base;
  const noPc = character.origin_id === "prodigio";

  const sheet = useMemo(
    () => buildSheet({ classId: character.class_id, originId: character.origin_id, level: character.level, form }),
    [character.class_id, character.origin_id, character.level, form],
  );
  const abilities = useMemo(
    () => abilityStatus({ level: character.level, originId: character.origin_id, pathId: character.origin_path_id, created: powers.length }),
    [character.level, character.origin_id, character.origin_path_id, powers.length],
  );
  const powersTab = useMemo(() => powersTabInfo(character.origin_id, character.origin_path_id), [character.origin_id, character.origin_path_id]);

  const rollSpeed: RollSpeed = prefs.reduceMotion ? "instant" : prefs.rollSpeed;

  const patchForm = useCallback(
    (formId: string, patch: Partial<FormRow>) => {
      setBase((f) => (f.id === formId ? { ...f, ...patch } : f));
      setLenda((f) => (f && f.id === formId ? { ...f, ...patch } : f));
    },
    [],
  );

  const beginRoll = useCallback((label: string) => {
    const token = `r${++tokenSeq}`;
    setCards((c) => [{ token, label, entry: null, startedAt: Date.now() }, ...c].slice(0, MAX_CARDS));
    return token;
  }, []);
  const finishRoll = useCallback((token: string, entry: RollEntry) => {
    setCards((c) => {
      const exists = c.some((x) => x.token === token);
      const card = { token, label: entry.label, entry, startedAt: Date.now() };
      return (exists ? c.map((x) => (x.token === token ? card : x)) : [card, ...c]).slice(0, MAX_CARDS);
    });
    setHistory((h) => [entry, ...h.filter((x) => x.id !== entry.id)].slice(0, 30));
  }, []);
  const failRoll = useCallback((token: string) => setCards((c) => c.filter((x) => x.token !== token)), []);

  const flushForm = useCallback(async () => {
    if (savingForm.current) return;
    savingForm.current = true;
    try {
      while (desiredForm.current !== confirmedForm.current) {
        const target = desiredForm.current;
        const res = await setActiveForm(character.id, target);
        if (!res.ok) {
          // Erro de sincronização: avisa e volta ao último estado salvo no banco.
          toast(`${res.error} A forma foi restaurada.`, "error");
          desiredForm.current = confirmedForm.current;
          setCharacterState((c) => ({ ...c, active_form: confirmedForm.current }));
          break;
        }
        confirmedForm.current = target;
      }
    } finally {
      savingForm.current = false;
    }
  }, [character.id, toast]);

  const switchForm = useCallback(
    (kind: "base" | "lenda") => {
      if (kind === "lenda" && !lenda?.setup_complete) return;
      desiredForm.current = kind;
      setFx((n) => n + 1);
      setCharacterState((c) => (c.active_form === kind ? c : { ...c, active_form: kind }));
      void flushForm();
    },
    [flushForm, lenda?.setup_complete],
  );

  const openCreator = useCallback(() => {
    setTab("poderes");
    setCreatorRequest((n) => n + 1);
  }, []);

  const state: SheetState = {
    character,
    form,
    base,
    lenda,
    isLenda,
    noPc,
    sheet,
    items,
    powers,
    effects,
    homebrew,
    abilities,
    powersTab,
    canEdit: bundle.canEdit,
    isOwner: bundle.isOwner,
    rollSpeed,
    setCharacter: (patch) => setCharacterState((c) => ({ ...c, ...patch })),
    setForm: (patch) => patchForm(form.id, patch),
    patchForm,
    setItems,
    setPowers,
    setEffects,
    setHomebrew,
    refresh: () => router.refresh(),
    beginRoll,
    finishRoll,
    failRoll,
    tab,
    setTab,
    openCreator,
    creatorRequest,
    switchForm,
  };

  async function roll(kind: "attribute" | "skill", id: string) {
    if (!bundle.canEdit) return;
    const key = `${kind}:${id}`;
    const name = kind === "attribute" ? (ATTRIBUTES.find((a) => a.id === id)?.name ?? id) : (sheet.skills.find((s) => s.id === id)?.name ?? id);
    const token = beginRoll(`Teste de ${name}`);
    setInflight((s) => new Set(s).add(key));
    const res = await rollCheck(character.id, kind, id, form.id);
    setInflight((s) => {
      const n = new Set(s);
      n.delete(key);
      return n;
    });
    if (!res.ok) {
      failRoll(token);
      return toast(res.error, "error");
    }
    finishRoll(token, res.data!);
  }

  return (
    <div className="sheet-root space-y-6 pb-40" data-sheet-theme={isLenda ? "corrupted" : "base"}>
      {isLenda && <div className="corrupt-backdrop" aria-hidden />}
      {fx > 0 && <div key={fx} className={`form-fx ${isLenda ? "form-fx-in" : "form-fx-out"}`} aria-hidden />}
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
        <div key={form.id} className={`space-y-6 ${fx > 0 ? "form-swap" : ""}`}>
          <IdentityCard state={state} />
          <ResourcePanel state={state} sheet={sheet} />
          <AttributesSection state={state} sheet={sheet} onRoll={(id) => roll("attribute", id)} rolling={inflight} />
          <SkillsSection state={state} sheet={sheet} onRoll={(id) => roll("skill", id)} rolling={inflight} />
        </div>
        <div className="lg:sticky lg:top-20">
          <RightPanel state={state} />
        </div>
      </div>

      <RollStack cards={cards} history={history} speed={rollSpeed} onClose={failRoll} />
    </div>
  );
}
