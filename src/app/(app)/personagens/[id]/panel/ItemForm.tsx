"use client";

import { useForm } from "react-hook-form";
import { zodResolver } from "@hookform/resolvers/zod";
import { z } from "zod";
import { Button } from "@/components/ui/Button";
import { Field } from "@/components/ui/Field";
import type { ItemRow } from "@/lib/character";
import { ATTACK_KIND_LABEL, EFFECT_KIND_LABEL, ITEM_TYPE_LABEL, type EffectKind, type ItemType } from "@/rules/catalog.ts";
import { DAMAGE_TYPE_LABEL, WEAPON_TAG_LABEL, type AttackKind, type DamageType, type WeaponTag } from "@/rules/data/equipment.ts";
import { SKILLS } from "@/rules/data/skills.ts";
import { diceRange, isValidDice } from "@/rules/dice.ts";
import type { ItemInput } from "../../inventory-actions";

const TAGS = Object.keys(WEAPON_TAG_LABEL) as WeaponTag[];

// Espelha a validação do servidor (que é a que vale).
const schema = z
  .object({
    name: z.string().trim().min(1, "Dê um nome ao item.").max(120),
    description: z.string().max(5000),
    item_type: z.enum(["arma", "armadura", "equipamento", "consumivel", "outro"]),
    category: z.string().trim().max(60),
    quantity: z.number({ error: "Quantidade inválida." }).int().min(0).max(9999),
    range: z.string().trim().max(60),
    effect_kind: z.string(),
    effect_dice: z.string().trim().max(60).refine((v) => !v || isValidDice(v), "Expressão inválida (ex.: 1d6, 2d8+3, 1d10+1d6)."),
    special_rules: z.string().max(5000),
    attack_kind: z.string(),
    damage_type: z.string(),
    skill_override: z.string(),
    tags: z.array(z.string()),
  })
  .refine((d) => d.item_type !== "arma" || (d.attack_kind && d.effect_dice), { message: "Arma precisa de tipo de ataque e dano.", path: ["effect_dice"] });

type Values = z.infer<typeof schema>;

export function itemToValues(i?: ItemRow | null): Values {
  return {
    name: i?.name ?? "",
    description: i?.description ?? "",
    item_type: (i?.item_type as ItemType) ?? "equipamento",
    category: i?.category ?? "",
    quantity: i?.quantity ?? 1,
    range: i?.range ?? "",
    effect_kind: i?.effect_kind === "outro" ? "personalizado" : (i?.effect_kind ?? ""),
    effect_dice: i?.effect_dice ?? "",
    special_rules: i?.special_rules ?? "",
    attack_kind: i?.attack_kind ?? "",
    damage_type: i?.damage_type ?? "",
    skill_override: i?.skill_override ?? "",
    tags: i?.tags ?? [],
  };
}

function toInput(v: Values): ItemInput {
  const weapon = v.item_type === "arma";
  return {
    name: v.name.trim(),
    description: v.description,
    item_type: v.item_type,
    category: v.category.trim(),
    quantity: v.quantity,
    range: v.range.trim(),
    effect_kind: (v.effect_kind || (weapon ? "dano" : null)) as EffectKind | null,
    effect_dice: v.effect_dice.trim() || null,
    special_rules: v.special_rules,
    attack_kind: weapon ? ((v.attack_kind || null) as AttackKind | null) : null,
    damage_type: weapon ? ((v.damage_type || null) as DamageType | null) : null,
    skill_override: weapon ? v.skill_override || null : null,
    tags: weapon ? (v.tags as WeaponTag[]) : [],
  };
}

export function ItemForm({
  initial,
  submitLabel,
  pending,
  onSubmit,
  onCancel,
}: {
  initial?: ItemRow | null;
  submitLabel: string;
  pending: boolean;
  onSubmit: (input: ItemInput) => void;
  onCancel: () => void;
}) {
  const form = useForm<Values>({ resolver: zodResolver(schema), defaultValues: itemToValues(initial) });
  const { errors } = form.formState;
  const type = form.watch("item_type");
  const dice = form.watch("effect_dice");
  const tags = form.watch("tags");
  const attackKind = form.watch("attack_kind");
  const range = dice && isValidDice(dice) ? diceRange(dice) : null;

  return (
    <form onSubmit={form.handleSubmit((v) => onSubmit(toInput(v)))} noValidate className="space-y-4">
      <div className="grid gap-4 sm:grid-cols-[1fr_10rem_6rem]">
        <Field label="Nome" error={errors.name?.message}>
          <input className="field-input" maxLength={120} {...form.register("name")} />
        </Field>
        <Field label="Tipo">
          <select className="field-input" {...form.register("item_type")}>
            {(Object.keys(ITEM_TYPE_LABEL) as ItemType[]).map((t) => (
              <option key={t} value={t}>
                {ITEM_TYPE_LABEL[t]}
              </option>
            ))}
          </select>
        </Field>
        <Field label="Qtd." error={errors.quantity?.message}>
          <input type="number" min={0} max={9999} className="field-input font-mono" {...form.register("quantity", { valueAsNumber: true })} />
        </Field>
      </div>
      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Categoria">
          <input className="field-input" maxLength={60} placeholder="Ex.: Ferramenta, Poção…" {...form.register("category")} />
        </Field>
        <Field label="Alcance">
          <input className="field-input" maxLength={60} placeholder="Corpo a corpo, 12 m…" {...form.register("range")} />
        </Field>
      </div>
      <Field label="Descrição">
        <textarea rows={3} className="field-input resize-y" maxLength={5000} {...form.register("description")} />
      </Field>
      <div className="grid gap-4 sm:grid-cols-2">
        <Field label="Tipo de efeito">
          <select className="field-input" {...form.register("effect_kind")}>
            <option value="">—</option>
            {(Object.keys(EFFECT_KIND_LABEL) as EffectKind[]).map((k) => (
              <option key={k} value={k}>
                {EFFECT_KIND_LABEL[k]}
              </option>
            ))}
          </select>
        </Field>
        <Field label={type === "arma" ? "Dano" : "Dados de efeito"} error={errors.effect_dice?.message} hint={range ? `Resultado entre ${range.min} e ${range.max}` : "Ex.: 1d6, 2d8+3, 1d10+1d6"}>
          <input className="field-input font-mono" maxLength={60} placeholder="—" {...form.register("effect_dice")} />
        </Field>
      </div>

      {type === "arma" && (
        <fieldset className="space-y-4 border border-line/70 p-3">
          <legend className="label-mono px-1 text-holo">Configuração de arma</legend>
          <div className="grid gap-4 sm:grid-cols-3">
            <Field label="Tipo de ataque" error={errors.attack_kind?.message}>
              <select className="field-input" {...form.register("attack_kind")}>
                <option value="">—</option>
                {(Object.keys(ATTACK_KIND_LABEL) as AttackKind[]).map((k) => (
                  <option key={k} value={k}>
                    {ATTACK_KIND_LABEL[k]}
                  </option>
                ))}
              </select>
            </Field>
            <Field label="Tipo de dano">
              <select className="field-input" {...form.register("damage_type")}>
                <option value="">—</option>
                {(Object.keys(DAMAGE_TYPE_LABEL) as DamageType[]).map((k) => (
                  <option key={k} value={k}>
                    {DAMAGE_TYPE_LABEL[k]}
                  </option>
                ))}
              </select>
            </Field>
            <Field
              label="Perícia do ataque"
              hint={attackKind === "firearm" ? "Padrão: Arma de Fogo" : attackKind === "ranged" ? "Padrão: Pontaria" : attackKind === "melee" ? "Padrão: Luta" : undefined}
            >
              <select className="field-input" {...form.register("skill_override")}>
                <option value="">Padrão do tipo</option>
                {SKILLS.map((s) => (
                  <option key={s.id} value={s.id}>
                    {s.name}
                  </option>
                ))}
              </select>
            </Field>
          </div>
          <div>
            <p className="label-mono mb-2">Categorias (definem os modificadores compatíveis)</p>
            <div className="flex flex-wrap gap-2">
              {TAGS.map((t) => {
                const on = tags.includes(t);
                return (
                  <label key={t} className={`cursor-pointer border px-2 py-1 font-mono text-[0.62rem] tracking-[0.1em] uppercase ${on ? "border-holo bg-primary/15 text-cyan" : "border-line text-fg-muted hover:text-fg-dim"}`}>
                    <input
                      type="checkbox"
                      className="sr-only"
                      checked={on}
                      onChange={(e) => form.setValue("tags", e.target.checked ? [...tags, t] : tags.filter((x) => x !== t), { shouldDirty: true })}
                    />
                    {WEAPON_TAG_LABEL[t]}
                  </label>
                );
              })}
            </div>
          </div>
        </fieldset>
      )}

      <Field label="Regras especiais / efeito">
        <textarea rows={2} className="field-input resize-y" maxLength={5000} {...form.register("special_rules")} />
      </Field>
      <div className="flex justify-end gap-2">
        <Button type="button" variant="ghost" onClick={onCancel}>
          Cancelar
        </Button>
        <Button type="submit" loading={pending}>
          {submitLabel}
        </Button>
      </div>
    </form>
  );
}
