"use client";

import { useMemo, useState, useTransition } from "react";
import { AnimatePresence, motion } from "motion/react";
import { BookMarked, ChevronDown, Coins, Library, Package, Pencil, Plus, Search, Star, Trash2, Wrench, X } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { Modal } from "@/components/ui/Modal";
import { SaveIndicator } from "@/components/SaveIndicator";
import { useAutosave } from "@/components/useAutosave";
import { useToast } from "@/components/ui/Toast";
import type { ItemRow } from "@/lib/character";
import { ATTACK_KIND_LABEL, CATALOG, EFFECT_KIND_LABEL, ITEM_TYPE_LABEL, type EffectKind, type ItemType } from "@/rules/catalog.ts";
import { DAMAGE_TYPE_LABEL, WEAPON_MODIFIER_BY_ID, WEAPON_TAG_LABEL, compatibleModifiers, type DamageType } from "@/rules/data/equipment.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { RULES_CONFIG } from "@/rules/config.ts";
import {
  addCatalogItem,
  addHomebrewItem,
  addModifier,
  addCustomModifier,
  removeCustomModifier,
  createCustomItem,
  removeItem,
  removeModifier,
  saveMoney,
  setQuickAccess,
  updateItem,
} from "../../inventory-actions";
import type { SheetState } from "../Sheet";
import { AttackButton, UseItemButton } from "./actions-ui";
import { customModifierCompatible, modifierSlotsUsed } from "@/rules/combat.ts";
import { KitChoices } from "@/components/sheet/KitChoices";
import { slotReceived, startingKit, validateKitChoices, type KitChoices as Choices } from "@/rules/data/startingKits.ts";
import { CLASS_BY_ID } from "@/rules/data/classes.ts";
import { grantStartingKit } from "../../actions";
import { ItemForm } from "./ItemForm";

export function InventoryTab({ state }: { state: SheetState }) {
  const [adding, setAdding] = useState(false);
  const [kitOpen, setKitOpen] = useState(false);
  const c = state.character;
  const kit = startingKit(c.class_id);
  const received = kit.filter((s) => slotReceived(c.class_id ?? "", s.id, state.items.map((i) => i.kit_ref))).map((s) => s.id);
  const missingKit = kit.length > 0 && received.length < kit.length;
  return (
    <div className="space-y-5">
      <MoneyField state={state} />
      {missingKit && state.canEdit && (
        <button
          onClick={() => setKitOpen(true)}
          className="flex w-full items-center justify-between gap-3 border border-holo/50 bg-primary/10 px-4 py-2.5 text-left hover:bg-primary/15"
        >
          <span className="flex items-center gap-2 text-sm text-fg">
            <Package className="h-4 w-4 text-cyan" aria-hidden /> Equipamento inicial da classe: {kit.length - received.length} pendente(s)
          </span>
          <span className="font-mono text-[0.6rem] tracking-[0.15em] text-cyan uppercase">Resgatar →</span>
        </button>
      )}
      {kitOpen && <StartingKitModal state={state} received={received} onClose={() => setKitOpen(false)} />}
      <div className="flex items-center justify-between gap-2">
        <p className="label-mono">
          Itens <span className="text-fg">({state.items.length})</span>
        </p>
        {state.canEdit && (
          <Button size="sm" onClick={() => setAdding(true)}>
            <Plus className="h-3.5 w-3.5" aria-hidden /> Adicionar item
          </Button>
        )}
      </div>
      {state.items.length === 0 ? (
        <p className="border border-dashed border-line p-6 text-center text-sm text-fg-muted">Inventário vazio. Use “+ Adicionar item” para buscar no catálogo ou criar um item.</p>
      ) : (
        <ul className="space-y-2">
          {state.items.map((i) => (
            <ItemCard key={i.id} state={state} item={i} />
          ))}
        </ul>
      )}
      {adding && <AddItemModal state={state} onClose={() => setAdding(false)} />}
    </div>
  );
}

// ------------------------------------------------------------------ Dinheiro

function MoneyField({ state }: { state: SheetState }) {
  const { character: c } = state;
  const [value, setValue] = useState(String(c.money ?? 0));
  const saver = useAutosave((v: number) => saveMoney(c.id, v), 800);
  return (
    <div className="flex flex-wrap items-end gap-3 border border-line/70 bg-panel-2/40 p-3">
      <label className="flex-1 text-sm">
        <span className="label-mono mb-1 flex items-center gap-1.5 text-holo">
          <Coins className="h-3.5 w-3.5" aria-hidden /> Dinheiro
        </span>
        <input
          inputMode="decimal"
          className="field-input font-mono text-lg"
          value={value}
          readOnly={!state.canEdit}
          onChange={(e) => {
            const raw = e.target.value.replace(",", ".");
            setValue(e.target.value);
            const n = Number(raw);
            if (raw.trim() !== "" && Number.isFinite(n)) {
              saver.schedule(n);
              state.setCharacter({ money: n });
            }
          }}
          aria-describedby="money-status"
        />
      </label>
      <span id="money-status">
        <SaveIndicator status={saver.status} error={saver.error} />
      </span>
    </div>
  );
}

// ------------------------------------------------------------------ Card do item

function ItemCard({ state, item }: { state: SheetState; item: ItemRow }) {
  const toast = useToast();
  const [open, setOpen] = useState(false);
  const [editing, setEditing] = useState(false);
  const [confirm, setConfirm] = useState(false);
  const [pending, start] = useTransition();
  const [modPick, setModPick] = useState("");
  const cid = state.character.id;
  const weapon = Boolean(item.attack_kind && item.effect_dice);
  const mods = item.item_modifiers;
  const customMods = item.custom_modifiers ?? [];
  const permanent = modifierSlotsUsed(mods.filter((m) => !m.is_temporary).length, customMods);
  const compatible = weapon ? compatibleModifiers(item.tags).filter((m) => !mods.some((x) => x.modifier_id === m.id)) : [];
  const canAddMod = weapon && permanent < RULES_CONFIG.maxWeaponModifiers;
  const [customPick, setCustomPick] = useState("");
  const libraryMods = weapon
    ? state.homebrew.filter((h) => h.kind === "modificador" && !customMods.some((m) => m.id === `hb:${h.id}`) && customModifierCompatible({ requires: ((h.data?.requires as string) || "qualquer") as "qualquer" }, item.tags))
    : [];
  const exhausted = item.uses_max != null ? (item.uses_left ?? 0) <= 0 : item.item_type === "consumivel" && item.quantity <= 0;

  type Res<T> = { ok: true; data?: T; message?: string } | { ok: false; error: string };
  /** Executa no servidor e aplica o resultado localmente (sem recarregar a ficha). */
  function run<T>(fn: () => Promise<Res<T>>, apply?: (data: T | undefined) => void, quiet = false) {
    start(async () => {
      const res = await fn();
      if (!res.ok) return toast(res.error ?? "Erro.", "error");
      if (res.message && !quiet) toast(res.message);
      apply?.(res.data);
    });
  }
  const patchItem = (patch: Partial<ItemRow>) => state.setItems((list) => list.map((i) => (i.id === item.id ? { ...i, ...patch } : i)));

  function toggleQuick(value: boolean) {
    // Otimista: marca na hora e desfaz se o banco recusar.
    patchItem({ quick_access: value });
    void setQuickAccess(cid, "item", item.id, value).then((res) => {
      if (!res.ok) {
        patchItem({ quick_access: !value });
        toast(res.error, "error");
      }
    });
  }


  return (
    <li className={`border bg-panel-2/40 transition-colors ${open ? "border-holo/60" : "border-line/70 hover:border-line-strong"}`}>
      <div className="flex items-center gap-2 px-3 py-2">
        {state.canEdit && (
          <label className="flex shrink-0 cursor-pointer items-center" title="Inventário Rápido">
            <input
              type="checkbox"
              className="sr-only"
              checked={item.quick_access}
              onChange={(e) => toggleQuick(e.target.checked)}
              aria-label={`${item.name} no Inventário Rápido`}
            />
            <Star className={`h-4 w-4 ${item.quick_access ? "fill-cyan text-cyan" : "text-fg-muted hover:text-fg-dim"}`} aria-hidden />
          </label>
        )}
        <button onClick={() => setOpen((o) => !o)} aria-expanded={open} className="flex min-w-0 flex-1 items-center gap-2 text-left">
          <span className="truncate text-sm text-fg">{item.name}</span>
          {item.quantity !== 1 && <span className="shrink-0 font-mono text-[0.65rem] text-fg-dim">×{item.quantity}</span>}
          <span className="shrink-0 font-mono text-[0.6rem] tracking-[0.12em] text-fg-muted uppercase">{ITEM_TYPE_LABEL[item.item_type as ItemType] ?? item.item_type}</span>
          {item.effect_dice && <span className="shrink-0 font-mono text-[0.65rem] text-cyan">{item.effect_dice}</span>}
          {mods.length + customMods.length > 0 && <span className="shrink-0 font-mono text-[0.6rem] text-holo">+{mods.length + customMods.length} MOD</span>}
          {item.uses_max != null && (
            <span className={`shrink-0 font-mono text-[0.6rem] ${exhausted ? "text-alert" : "text-fg-dim"}`}>
              {item.uses_left ?? 0}/{item.uses_max} usos
            </span>
          )}
          <ChevronDown className={`ml-auto h-4 w-4 shrink-0 text-fg-muted transition-transform ${open ? "rotate-180" : ""}`} aria-hidden />
        </button>
        {weapon && <AttackButton state={state} item={item} compact />}
        <UseItemButton state={state} item={item} />
      </div>

      <AnimatePresence initial={false}>
        {open && (
          <motion.div initial={{ height: 0, opacity: 0 }} animate={{ height: "auto", opacity: 1 }} exit={{ height: 0, opacity: 0 }} className="overflow-hidden">
            <div className="space-y-3 border-t border-line/60 px-3 py-3 text-sm">
              {editing ? (
                <ItemForm
                  initial={item}
                  submitLabel="Salvar item"
                  pending={pending}
                  onCancel={() => setEditing(false)}
                  onSubmit={(input) =>
                    run(
                      () => updateItem(cid, item.id, input),
                      (fresh) => {
                        if (fresh) state.setItems((list) => list.map((i) => (i.id === item.id ? fresh : i)));
                        setEditing(false);
                      },
                    )
                  }
                />
              ) : (
                <>
                  <dl className="grid grid-cols-2 gap-2 text-xs sm:grid-cols-3">
                    {item.category && <Info label="Categoria" value={item.category} />}
                    {item.effect_kind && <Info label="Efeito" value={EFFECT_KIND_LABEL[item.effect_kind as EffectKind] ?? item.effect_kind} />}
                    {item.effect_dice && <Info label={weapon ? "Dano" : "Dados"} value={item.effect_dice} mono />}
                    {item.attack_kind && <Info label="Ataque" value={ATTACK_KIND_LABEL[item.attack_kind]} />}
                    {item.damage_type && <Info label="Tipo de dano" value={DAMAGE_TYPE_LABEL[item.damage_type as DamageType] ?? item.damage_type} />}
                    {item.skill_override && <Info label="Perícia" value={SKILL_BY_ID[item.skill_override]?.name ?? item.skill_override} />}
                    {item.range && <Info label="Alcance" value={item.range} />}
                    <Info label="Origem" value={item.source_kind === "catalog" ? "Catálogo oficial" : item.source_kind === "homebrew" ? "Homebrew (cópia)" : "Personalizado"} />
                  </dl>
                  {item.tags.length > 0 && (
                    <p className="flex flex-wrap gap-1">
                      {item.tags.map((t) => (
                        <span key={t} className="border border-line px-1.5 py-0.5 font-mono text-[0.58rem] tracking-[0.1em] text-fg-dim uppercase">
                          {WEAPON_TAG_LABEL[t]}
                        </span>
                      ))}
                    </p>
                  )}
                  {item.description && <p className="whitespace-pre-line text-fg-dim">{item.description}</p>}
                  {item.special_rules && <p className="whitespace-pre-line text-xs text-cyan-dim">{item.special_rules}</p>}

                  {weapon && (
                    <section className="border-t border-line/60 pt-3">
                      <p className="label-mono mb-2 flex items-center gap-1.5">
                        <Wrench className="h-3.5 w-3.5" aria-hidden /> Modificadores ({permanent}/{RULES_CONFIG.maxWeaponModifiers})
                      </p>
                      {mods.length === 0 && <p className="text-xs text-fg-muted">Nenhum modificador.</p>}
                      <ul className="space-y-2">
                        {mods.map((m) => {
                          const def = WEAPON_MODIFIER_BY_ID[m.modifier_id];
                          return (
                            <li key={m.id} className="flex items-start justify-between gap-2 border border-line/60 p-2">
                              <div>
                                <p className="text-sm text-fg">
                                  {def?.name ?? m.modifier_id}
                                  {m.is_temporary && <span className="ml-2 font-mono text-[0.6rem] text-cyan">TEMPORÁRIO</span>}
                                </p>
                                <p className="text-xs text-fg-dim">{def?.text}</p>
                                {def?.condition && <p className="mt-1 text-xs text-cyan-dim">Condição: {def.condition}</p>}
                              </div>
                              {state.canEdit && (
                                <button onClick={() => run(() => removeModifier(cid, m.id), () => patchItem({ item_modifiers: item.item_modifiers.filter((x) => x.id !== m.id) }))} className="shrink-0 p-1 text-fg-muted hover:text-alert" aria-label={`Remover ${def?.name ?? "modificador"}`} disabled={pending}>
                                  <X className="h-3.5 w-3.5" />
                                </button>
                              )}
                            </li>
                          );
                        })}
                      </ul>
                      {state.canEdit && (
                        <div className="mt-2 flex flex-wrap items-center gap-2">
                          {compatible.length === 0 ? (
                            <p className="text-xs text-fg-muted">Nenhum outro modificador compatível com as categorias desta arma.</p>
                          ) : canAddMod ? (
                            <>
                              <select className="field-input max-w-xs py-1 text-sm" value={modPick} onChange={(e) => setModPick(e.target.value)} aria-label="Modificador compatível">
                                <option value="">Escolha um modificador…</option>
                                {compatible.map((m) => (
                                  <option key={m.id} value={m.id}>
                                    {m.name} ({m.classLabel})
                                  </option>
                                ))}
                              </select>
                              <Button size="sm" variant="secondary" disabled={!modPick || pending} onClick={() =>
                                  run(
                                    () => addModifier(cid, item.id, modPick),
                                    (row) => {
                                      if (row) patchItem({ item_modifiers: [...item.item_modifiers, row] });
                                      setModPick("");
                                    },
                                  )
                                }>
                                <Plus className="h-3.5 w-3.5" aria-hidden /> Adicionar modificador
                              </Button>
                            </>
                          ) : (
                            <p className="text-xs text-fg-muted">Limite de {RULES_CONFIG.maxWeaponModifiers} modificadores permanentes atingido.</p>
                          )}
                        </div>
                      )}
                      {modPick && <p className="mt-1 text-xs text-fg-dim">{WEAPON_MODIFIER_BY_ID[modPick]?.text}</p>}
                      {customMods.length > 0 && (
                        <ul className="mt-2 space-y-2">
                          {customMods.map((m) => (
                            <li key={m.id} className="flex items-start justify-between gap-2 border border-holo/40 p-2">
                              <div>
                                <p className="text-sm text-fg">
                                  {m.name} <span className="font-mono text-[0.6rem] text-holo">HOMEBREW{m.ignoreLimit ? " · SEM VAGA" : ""}</span>
                                </p>
                                {m.text && <p className="text-xs whitespace-pre-line text-fg-dim">{m.text}</p>}
                                {m.condition && <p className="mt-1 text-xs text-cyan-dim">Condição: {m.condition}</p>}
                              </div>
                              {state.canEdit && (
                                <button
                                  onClick={() => run(() => removeCustomModifier(cid, item.id, m.id), (fresh) => fresh && patchItem(fresh))}
                                  className="shrink-0 p-1 text-fg-muted hover:text-alert"
                                  aria-label={`Remover ${m.name}`}
                                  disabled={pending}
                                >
                                  <X className="h-3.5 w-3.5" />
                                </button>
                              )}
                            </li>
                          ))}
                        </ul>
                      )}
                      {state.canEdit && libraryMods.length > 0 && (
                        <div className="mt-2 flex flex-wrap items-center gap-2">
                          <select className="field-input max-w-xs py-1 text-sm" value={customPick} onChange={(e) => setCustomPick(e.target.value)} aria-label="Modificador do Homebrew">
                            <option value="">Modificador do Homebrew…</option>
                            {libraryMods.map((h) => (
                              <option key={h.id} value={h.id}>
                                {h.name}
                              </option>
                            ))}
                          </select>
                          <Button
                            size="sm"
                            variant="secondary"
                            disabled={!customPick || pending}
                            onClick={() =>
                              run(
                                () => addCustomModifier(cid, item.id, customPick),
                                (fresh) => {
                                  if (fresh) patchItem(fresh);
                                  setCustomPick("");
                                },
                              )
                            }
                          >
                            <Plus className="h-3.5 w-3.5" aria-hidden /> Aplicar
                          </Button>
                        </div>
                      )}
                    </section>
                  )}

                  {state.canEdit && (
                    <div className="flex justify-end gap-2 border-t border-line/60 pt-3">
                      <Button size="sm" variant="secondary" onClick={() => setEditing(true)}>
                        <Pencil className="h-3.5 w-3.5" aria-hidden /> Editar
                      </Button>
                      <Button size="sm" variant="danger" onClick={() => setConfirm(true)}>
                        <Trash2 className="h-3.5 w-3.5" aria-hidden /> Remover
                      </Button>
                    </div>
                  )}
                </>
              )}
            </div>
          </motion.div>
        )}
      </AnimatePresence>
      <ConfirmDialog
        open={confirm}
        title="Remover item"
        description={`Remover “${item.name}” do inventário? Modelos da biblioteca Homebrew não são afetados.`}
        confirmLabel="Remover"
        loading={pending}
        onCancel={() => setConfirm(false)}
        onConfirm={() =>
          run(
            () => removeItem(cid, item.id),
            () => {
              setConfirm(false);
              state.setItems((list) => list.filter((i) => i.id !== item.id));
            },
          )
        }
      />
    </li>
  );
}

function Info({ label, value, mono }: { label: string; value: string; mono?: boolean }) {
  return (
    <div>
      <dt className="label-mono">{label}</dt>
      <dd className={`text-fg ${mono ? "font-mono" : ""}`}>{value}</dd>
    </div>
  );
}

// ------------------------------------------------------------------ Adicionar item

type AddTab = "catalogo" | "biblioteca" | "criar";

function AddItemModal({ state, onClose }: { state: SheetState; onClose: () => void }) {
  const toast = useToast();
  const [tab, setTab] = useState<AddTab>("catalogo");
  const [q, setQ] = useState("");
  const [type, setType] = useState<"" | ItemType>("");
  const [pending, start] = useTransition();
  const [busyId, setBusyId] = useState<string | null>(null);
  const cid = state.character.id;

  const norm = (s: string) => s.normalize("NFD").replace(/\p{Diacritic}/gu, "").toLowerCase();
  const catalog = useMemo(() => CATALOG.filter((c) => (!type || c.type === type) && (!q || norm(`${c.name} ${c.category} ${c.description}`).includes(norm(q)))), [q, type]);
  const library = useMemo(
    () =>
      state.homebrew.filter((h) => {
        if (h.kind === "modificador") return false; // modificadores entram pela arma
        const raw = (h.data.item_type as string) ?? (h.kind === "arma" ? "arma" : "equipamento");
        const t = h.kind === "arma" ? "arma" : raw === "cura" ? "consumivel" : ["especial", "mistico", "utilidade"].includes(raw) ? "equipamento" : raw;
        return (!type || t === type) && (!q || norm(`${h.name} ${h.description}`).includes(norm(q)));
      }),
    [state.homebrew, q, type],
  );

  function add(id: string, fn: () => Promise<{ ok: true; data?: ItemRow; message?: string } | { ok: false; error: string }>) {
    setBusyId(id);
    start(async () => {
      const res = await fn();
      setBusyId(null);
      if (!res.ok) return toast(res.error ?? "Erro.", "error");
      toast(res.message ?? "Adicionado.");
      const row = res.data;
      if (row) state.setItems((list) => [...list, row]);
    });
  }

  const TABS: { id: AddTab; label: string; icon: typeof Search }[] = [
    { id: "catalogo", label: "Catálogo", icon: BookMarked },
    { id: "biblioteca", label: `Biblioteca (${state.homebrew.length})`, icon: Library },
    { id: "criar", label: "Criar item", icon: Plus },
  ];

  return (
    <Modal
      open
      onClose={onClose}
      title="Adicionar item"
      tag="Inventário"
      size="lg"
      header={
        <div className="space-y-3">
          <div role="tablist" className="flex gap-1">
            {TABS.map((t) => (
              <button
                key={t.id}
                role="tab"
                aria-selected={tab === t.id}
                onClick={() => setTab(t.id)}
                className={`flex items-center gap-1.5 border px-3 py-1.5 font-mono text-[0.62rem] tracking-[0.15em] uppercase ${tab === t.id ? "border-holo bg-primary/15 text-cyan" : "border-line text-fg-muted hover:text-fg-dim"}`}
              >
                <t.icon className="h-3.5 w-3.5" aria-hidden /> {t.label}
              </button>
            ))}
          </div>
          {tab !== "criar" && (
            <div className="flex flex-wrap gap-2">
              <label className="relative min-w-48 flex-1">
                <Search className="pointer-events-none absolute top-1/2 left-2.5 h-4 w-4 -translate-y-1/2 text-fg-muted" aria-hidden />
                <input className="field-input pl-8" placeholder="Buscar…" value={q} onChange={(e) => setQ(e.target.value)} aria-label="Buscar item" />
              </label>
              <select className="field-input w-40" value={type} onChange={(e) => setType(e.target.value as ItemType | "")} aria-label="Filtrar por tipo">
                <option value="">Todos os tipos</option>
                {(Object.keys(ITEM_TYPE_LABEL) as ItemType[]).map((t) => (
                  <option key={t} value={t}>
                    {ITEM_TYPE_LABEL[t]}
                  </option>
                ))}
              </select>
            </div>
          )}
        </div>
      }
    >
      {tab === "catalogo" && (
        <ul className="space-y-2">
          {catalog.length === 0 && <p className="text-sm text-fg-muted">Nada encontrado.</p>}
          {catalog.map((c) => (
            <li key={c.id} className="flex items-start justify-between gap-3 border border-line/60 p-3">
              <div className="min-w-0">
                <p className="text-sm text-fg">
                  {c.name} <span className="font-mono text-[0.6rem] tracking-[0.12em] text-fg-muted uppercase">{c.category}</span>
                </p>
                <p className="text-xs text-fg-dim">{c.effectText}</p>
                {c.range && <p className="text-xs text-fg-muted">Alcance: {c.range}</p>}
                {c.modifiers.length > 0 && <p className="text-xs text-fg-muted">Modificadores compatíveis: {c.modifiers.map((m) => WEAPON_MODIFIER_BY_ID[m]?.name).join(", ")}</p>}
                {c.note && <p className="text-xs text-cyan-dim">{c.note}</p>}
              </div>
              <Button size="sm" variant="secondary" loading={pending && busyId === c.id} disabled={pending} onClick={() => add(c.id, () => addCatalogItem(cid, c.id))}>
                <Plus className="h-3.5 w-3.5" aria-hidden /> Adicionar
              </Button>
            </li>
          ))}
        </ul>
      )}
      {tab === "biblioteca" && (
        <ul className="space-y-2">
          {library.length === 0 && <p className="text-sm text-fg-muted">Sua biblioteca não tem itens{q || type ? " com esse filtro" : ""}. Itens criados aqui são salvos nela automaticamente.</p>}
          {library.map((h) => (
            <li key={h.id} className="flex items-start justify-between gap-3 border border-line/60 p-3">
              <div className="min-w-0">
                <p className="text-sm text-fg">
                  {h.name} {typeof h.data.effect_dice === "string" && h.data.effect_dice && <span className="font-mono text-xs text-cyan">{h.data.effect_dice}</span>}
                </p>
                {h.description && <p className="line-clamp-2 text-xs text-fg-dim">{h.description}</p>}
              </div>
              <Button size="sm" variant="secondary" loading={pending && busyId === h.id} disabled={pending} onClick={() => add(h.id, () => addHomebrewItem(cid, h.id))}>
                <Plus className="h-3.5 w-3.5" aria-hidden /> Adicionar cópia
              </Button>
            </li>
          ))}
        </ul>
      )}
      {tab === "criar" && (
        <>
          <p className="mb-4 text-xs text-fg-muted">O item vai para esta ficha e para sua biblioteca Homebrew. A cópia na ficha e o modelo da biblioteca são editados separadamente.</p>
          <ItemForm
            submitLabel="Criar item"
            pending={pending}
            onCancel={onClose}
            onSubmit={(input) =>
              start(async () => {
                const res = await createCustomItem(cid, input);
                if (!res.ok) return toast(res.error, "error");
                toast(res.message ?? "Item criado.");
                const { item: row, homebrew } = res.data!;
                state.setItems((list) => [...list, row]);
                state.setHomebrew((list) => [...list, homebrew].sort((a, b) => a.name.localeCompare(b.name)));
                onClose();
              })
            }
          />
        </>
      )}
    </Modal>
  );
}

// ------------------------------------------------------------------ Equipamento inicial (personagens já criados)

function StartingKitModal({ state, received, onClose }: { state: SheetState; received: string[]; onClose: () => void }) {
  const toast = useToast();
  const c = state.character;
  const [choices, setChoices] = useState<Choices>(() => ({ ...c.starting_kit }));
  const [pending, start] = useTransition();
  const pendingSlots = startingKit(c.class_id)
    .filter((s) => !received.includes(s.id))
    .map((s) => s.id);
  const errors = validateKitChoices(c.class_id, c.origin_id, choices, pendingSlots);
  const owned = state.items.filter((i) => i.source_kind === "catalog" && i.source_ref).map((i) => i.source_ref as string);

  function submit() {
    start(async () => {
      const res = await grantStartingKit(c.id, choices);
      if (!res.ok) return toast(res.error, "error");
      toast(res.message ?? "Equipamento entregue.");
      state.refresh();
      onClose();
    });
  }

  return (
    <Modal
      open
      onClose={onClose}
      title="Equipamento inicial"
      tag={c.class_id ? CLASS_BY_ID[c.class_id]?.name : "Classe"}
      size="md"
      footer={
        <>
          <Button variant="ghost" onClick={onClose}>
            Cancelar
          </Button>
          <Button onClick={submit} loading={pending} disabled={errors.length > 0}>
            <Package className="h-3.5 w-3.5" aria-hidden /> Receber itens
          </Button>
        </>
      }
    >
      <p className="mb-4 text-xs text-fg-muted">
        Os itens entram no inventário como itens reais. O que já foi recebido não é entregue de novo, e o inventário atual não é alterado.
      </p>
      <KitChoices classId={c.class_id!} originId={c.origin_id} choices={choices} onChange={setChoices} onlySlots={pendingSlots} received={received} owned={owned} />
      {errors.length > 0 && <p className="mt-3 text-xs text-fg-dim">{errors[0]}</p>}
    </Modal>
  );
}
