"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState, useTransition } from "react";
import { ArrowLeft, CopyPlus, Pencil, Share2, Swords, Trash2, UserPlus } from "lucide-react";
import { Button } from "@/components/ui/Button";
import { ConfirmDialog } from "@/components/ui/ConfirmDialog";
import { useToast } from "@/components/ui/Toast";
import { HoloFrame } from "@/components/media/ImageField";
import { HOMEBREW_KINDS, SHAREABLE_KINDS, type HomebrewEntry } from "@/lib/types";
import { ITEM_KINDS, defaultData, weaponFromData, type ItemFormValue, type ModifierFormValue, type NpcFormValue, type OtherFormValue, type WeaponFormValue } from "@/lib/homebrew";
import { normalizeCreature, testValue, usesLabel } from "@/rules/creatures.ts";
import { thresholds } from "@/rules/d100.ts";
import { ATTRIBUTES } from "@/rules/data/attributes.ts";
import { SKILL_BY_ID } from "@/rules/data/skills.ts";
import { DAMAGE_TYPE_LABEL, WEAPON_MODIFIER_BY_ID, WEAPON_TAG_LABEL, type WeaponTag } from "@/rules/data/equipment.ts";
import { weaponPreview } from "@/rules/combat.ts";
import { duplicateHomebrew } from "../../actions";
import { deleteHomebrewEntry, setHomebrewShare } from "../actions";
import { npcFromHomebrew } from "../../campanhas/shield-actions";
import { addHomebrewItem } from "../../personagens/inventory-actions";

const KIND_LABEL = Object.fromEntries(HOMEBREW_KINDS.map((k) => [k.id, k.label])) as Record<string, string>;
const th = (v: number) => {
  const t = thresholds(v);
  return `${t.normal} / ${t.good} / ${t.extreme}`;
};

function Block({ title, children }: { title: string; children: React.ReactNode }) {
  return (
    <section className="space-y-2 border border-line/70 bg-panel/60 p-4">
      <h2 className="font-mono text-xs tracking-[0.22em] text-holo uppercase">{title}</h2>
      {children}
    </section>
  );
}
function Text({ label, value, secret }: { label: string; value?: string | null; secret?: boolean }) {
  if (!value) return null;
  return (
    <div className={secret ? "border-l-2 border-alert/70 bg-alert/5 px-3 py-2" : ""}>
      <p className={`label-mono ${secret ? "text-alert" : ""}`}>{label}</p>
      <p className="text-sm whitespace-pre-line text-fg-dim">{value}</p>
    </div>
  );
}

export function EntryView({
  entry,
  isOwner,
  campaigns,
  sharedWith,
  characters,
}: {
  entry: HomebrewEntry;
  isOwner: boolean;
  campaigns: { id: string; name: string }[];
  sharedWith: string[];
  characters: { id: string; name: string }[];
}) {
  const router = useRouter();
  const toast = useToast();
  const [busy, start] = useTransition();
  const [confirm, setConfirm] = useState(false);
  const [shared, setShared] = useState(new Set(sharedWith));
  const [camp, setCamp] = useState(campaigns[0]?.id ?? "");
  const [char, setChar] = useState(characters[0]?.id ?? "");
  const creature = entry.kind === "monstro" || entry.kind === "npc";
  const toInventory = ["item", "arma", "item_especial", "outro"].includes(entry.kind);

  function run<T>(fn: () => Promise<{ ok: boolean; error?: string; message?: string; data?: T }>, after?: (d?: T) => void) {
    start(async () => {
      const r = await fn();
      if (!r.ok) return toast(r.error ?? "Erro.", "error");
      if (r.message) toast(r.message);
      after?.(r.data);
    });
  }

  return (
    <div className="mx-auto max-w-4xl space-y-5 pb-24">
      <Link href="/painel?aba=homebrew" className="inline-flex items-center gap-2 text-sm text-fg-dim hover:text-cyan">
        <ArrowLeft className="h-4 w-4" aria-hidden /> Biblioteca Homebrew
      </Link>

      <header className="hud-panel grid gap-5 p-4 pt-7 sm:grid-cols-[12rem_1fr] sm:p-6 sm:pt-8">
        <span className="hud-tag">{KIND_LABEL[entry.kind]}</span>
        <HoloFrame url={entry.image_url ?? null} alt={entry.name} aspect={creature ? "portrait" : "square"} />
        <div className="min-w-0 space-y-3">
          <h1 className="font-head text-3xl tracking-wide text-fg text-glow">{entry.name}</h1>
          {entry.description && <p className="text-sm whitespace-pre-line text-fg-dim">{entry.description}</p>}
          <p className="font-mono text-[0.6rem] tracking-[0.15em] text-fg-muted uppercase">Atualizado em {new Date(entry.updated_at).toLocaleString("pt-BR")}</p>
          {isOwner ? (
            <div className="flex flex-wrap gap-2">
              <Link
                href={`/homebrew/${entry.id}/editar`}
                className="chamfer inline-flex items-center gap-2 border border-holo/60 bg-gradient-to-r from-primary-deep to-primary/80 px-4 py-2 font-mono text-xs tracking-[0.18em] text-fg uppercase hover:from-primary/90 hover:to-holo/90"
              >
                <Pencil className="h-3.5 w-3.5" aria-hidden /> Editar
              </Link>
              <Button size="sm" variant="secondary" loading={busy} onClick={() => run<{ id: string }>(() => duplicateHomebrew(entry.id), (d) => d && router.push(`/homebrew/${d.id}`))}>
                <CopyPlus className="h-3.5 w-3.5" aria-hidden /> Duplicar
              </Button>
              <Button size="sm" variant="danger" onClick={() => setConfirm(true)}>
                <Trash2 className="h-3.5 w-3.5" aria-hidden /> Excluir
              </Button>
            </div>
          ) : (
            <p className="text-xs text-cyan">Disponibilizado pelo Mestre de uma campanha sua. Você pode adicionar cópias às suas fichas; o modelo original não pode ser alterado.</p>
          )}
        </div>
      </header>

      {/* Uso prático */}
      <div className="grid gap-4 md:grid-cols-2">
        {creature && isOwner && (
          <Block title="Usar em campanhas">
            {campaigns.length === 0 ? (
              <p className="text-sm text-fg-muted">Crie uma campanha para usar esta criatura no Escudo do Mestre.</p>
            ) : (
              <>
                <div className="flex flex-wrap gap-2">
                  <select className="field-input w-auto flex-1" value={camp} onChange={(e) => setCamp(e.target.value)} aria-label="Campanha">
                    {campaigns.map((c) => (
                      <option key={c.id} value={c.id}>
                        {c.name}
                      </option>
                    ))}
                  </select>
                  <Button size="sm" loading={busy} disabled={!camp} onClick={() => run(() => npcFromHomebrew(camp, entry.id))}>
                    <UserPlus className="h-3.5 w-3.5" aria-hidden /> Adicionar à campanha
                  </Button>
                </div>
                <p className="flex items-start gap-1.5 text-xs text-fg-muted">
                  <Swords className="mt-0.5 h-3.5 w-3.5 shrink-0" aria-hidden /> Para combates, use <strong className="text-fg">+ Adicionar combatente → Monstros do Homebrew</strong> no Escudo: cada inclusão vira uma instância com PV e condições próprios.
                </p>
              </>
            )}
          </Block>
        )}
        {toInventory && (
          <Block title="Adicionar à ficha">
            {characters.length === 0 ? (
              <p className="text-sm text-fg-muted">Você não tem fichas ativas.</p>
            ) : (
              <div className="flex flex-wrap gap-2">
                <select className="field-input w-auto flex-1" value={char} onChange={(e) => setChar(e.target.value)} aria-label="Personagem">
                  {characters.map((c) => (
                    <option key={c.id} value={c.id}>
                      {c.name}
                    </option>
                  ))}
                </select>
                <Button size="sm" loading={busy} disabled={!char} onClick={() => run(() => addHomebrewItem(char, entry.id))}>
                  Adicionar ao inventário
                </Button>
              </div>
            )}
            <p className="text-xs text-fg-muted">Cada ficha recebe uma cópia independente (quantidade, usos e modificadores próprios).</p>
          </Block>
        )}
        {isOwner && SHAREABLE_KINDS.includes(entry.kind) && (
          <Block title="Disponibilizar para campanhas">
            {campaigns.length === 0 ? (
              <p className="text-sm text-fg-muted">Você não mestra nenhuma campanha.</p>
            ) : (
              <ul className="space-y-1.5">
                {campaigns.map((c) => (
                  <li key={c.id}>
                    <label className="flex items-center gap-2 text-sm text-fg-dim">
                      <input
                        type="checkbox"
                        className="accent-[var(--color-holo)]"
                        checked={shared.has(c.id)}
                        disabled={busy}
                        onChange={(e) => {
                          const on = e.target.checked;
                          run(
                            () => setHomebrewShare(entry.id, c.id, on),
                            () =>
                              setShared((s) => {
                                const n = new Set(s);
                                if (on) n.add(c.id);
                                else n.delete(c.id);
                                return n;
                              }),
                          );
                        }}
                      />
                      <Share2 className="h-3.5 w-3.5" aria-hidden /> {c.name}
                    </label>
                  </li>
                ))}
              </ul>
            )}
            <p className="text-xs text-fg-muted">Os jogadores dessas campanhas veem o conteúdo e podem adicioná-lo às próprias fichas. Ninguém além de você edita o modelo.</p>
          </Block>
        )}
      </div>

      <Details entry={entry} isOwner={isOwner} />

      <ConfirmDialog
        open={confirm}
        title={`Excluir “${entry.name}”?`}
        description="Sai da biblioteca. Cópias já colocadas em fichas, campanhas e combates continuam intactas."
        confirmLabel="Excluir"
        loading={busy}
        onCancel={() => setConfirm(false)}
        onConfirm={() =>
          run(
            () => deleteHomebrewEntry(entry.id),
            () => {
              router.push("/painel?aba=homebrew");
              router.refresh();
            },
          )
        }
      />
    </div>
  );
}

function Details({ entry, isOwner }: { entry: HomebrewEntry; isOwner: boolean }) {
  const d = entry.data ?? {};
  if (entry.kind === "monstro" || entry.kind === "npc") {
    const c = normalizeCreature(d);
    const n = defaultData(entry.kind, d) as unknown as NpcFormValue & { category?: string; level?: string };
    return (
      <div className="space-y-4">
        <Block title="Informações">
          <dl className="grid grid-cols-2 gap-3 text-sm sm:grid-cols-4">
            {[
              ["Categoria", n.category],
              ["Nível", n.level],
              ["Idade", n.age],
              ["PV", c.pv_max != null ? `${c.pv_current ?? c.pv_max}/${c.pv_max}` : ""],
              ["PC", c.pc_max != null ? `${c.pc_current ?? c.pc_max}/${c.pc_max}` : ""],
              ["Defesa", c.defense],
              ["Deslocamento", c.movement],
            ]
              .filter(([, v]) => v)
              .map(([k, v]) => (
                <div key={k}>
                  <dt className="label-mono">{k}</dt>
                  <dd className="text-fg">{v}</dd>
                </div>
              ))}
          </dl>
          {c.resistances.length > 0 && <p className="text-sm text-fg-dim">Resistências: {c.resistances.join(", ")}</p>}
          {c.vulnerabilities.length > 0 && <p className="text-sm text-fg-dim">Vulnerabilidades: {c.vulnerabilities.join(", ")}</p>}
          {c.immunities.length > 0 && <p className="text-sm text-fg-dim">Imunidades: {c.immunities.join(", ")}</p>}
          <Text label="Descrição física" value={n.appearance} />
          <Text label="Personalidade" value={n.personality} />
          <Text label="História" value={n.story} />
          <Text label="Relação com a campanha" value={n.relation} />
          {isOwner && <Text label="Anotações do Mestre (privadas)" value={n.master_notes} secret />}
        </Block>
        {Object.keys(c.attributes).length > 0 && (
          <Block title="Atributos (normal / bom / extremo)">
            <div className="grid grid-cols-2 gap-2 sm:grid-cols-4">
              {ATTRIBUTES.filter((a) => c.attributes[a.id] != null).map((a) => (
                <div key={a.id} className="border border-line/60 p-2">
                  <p className="label-mono">{a.name}</p>
                  <p className="font-mono text-sm text-fg">{th(c.attributes[a.id]!)}</p>
                </div>
              ))}
            </div>
          </Block>
        )}
        {c.skills.length > 0 && (
          <Block title="Perícias">
            <ul className="grid gap-1 text-sm sm:grid-cols-2">
              {c.skills.map((s) => (
                <li key={s.id} className="flex justify-between gap-2 border-b border-line/40 py-1">
                  <span className="text-fg">{SKILL_BY_ID[s.id]?.name ?? s.name ?? s.id.replace(/^custom:/, "")}</span>
                  <span className="font-mono text-fg-dim">{th(s.value)}</span>
                </li>
              ))}
            </ul>
          </Block>
        )}
        {c.attacks.length > 0 && (
          <Block title="Ataques">
            {c.attacks.map((a) => (
              <div key={a.id} className="border-b border-line/40 pb-2 text-sm last:border-0">
                <p className="text-fg">
                  {a.name} <span className="font-mono text-cyan">{a.damage}</span>
                  {a.damage_type && <span className="text-fg-dim"> {a.damage_type}</span>}
                </p>
                <p className="text-xs text-fg-dim">
                  {usesLabel(a.uses, c)} {th(testValue(c, a.uses, a.value))}
                  {a.range && ` · ${a.range}`}
                  {a.conditions?.length ? ` · aplica ${a.conditions.map((x) => x.name + (x.turns ? ` (${x.turns})` : "")).join(", ")}` : ""}
                </p>
                {a.description && <p className="text-xs text-fg-muted">{a.description}</p>}
                {a.effects && <p className="text-xs text-fg-muted">{a.effects}</p>}
              </div>
            ))}
          </Block>
        )}
        {c.abilities.length > 0 && (
          <Block title="Habilidades">
            {c.abilities.map((a) => (
              <div key={a.id} className="border-b border-line/40 pb-2 text-sm last:border-0">
                <p className="text-fg">
                  {a.name} {a.type && <span className="text-xs text-fg-muted">({a.type})</span>} {a.pc_cost ? <span className="font-mono text-holo">{a.pc_cost} PC</span> : null}
                </p>
                <p className="text-xs text-fg-dim">
                  {[a.damage && `Dano ${a.damage}`, a.heal && `Cura ${a.heal}`, a.condition && `${a.condition.name}${a.condition.turns ? ` (${a.condition.turns} t)` : ""}`, a.area, a.duration, a.manual && "efeito manual"].filter(Boolean).join(" · ")}
                </p>
                {a.description && <p className="text-xs text-fg-muted">{a.description}</p>}
                {a.special && <p className="text-xs text-fg-muted">{a.special}</p>}
              </div>
            ))}
          </Block>
        )}
        {c.inventory.length > 0 && (
          <Block title="Inventário">
            <ul className="text-sm text-fg-dim">
              {c.inventory.map((i, k) => (
                <li key={k}>
                  {i.quantity && i.quantity > 1 ? `${i.quantity}× ` : ""}
                  {i.name}
                  {i.notes ? ` — ${i.notes}` : ""}
                </li>
              ))}
            </ul>
          </Block>
        )}
      </div>
    );
  }
  if (entry.kind === "arma") {
    const w = defaultData("arma", d) as unknown as WeaponFormValue;
    let preview: ReturnType<typeof weaponPreview> | null = null;
    try {
      preview = weaponPreview(weaponFromData(entry.name, w));
    } catch {
      preview = null;
    }
    return (
      <Block title="Arma">
        <p className="text-sm text-fg">
          Dano <span className="font-mono text-cyan">{preview?.damage ?? w.effect_dice}</span>
          {w.damage_type && ` · ${DAMAGE_TYPE_LABEL[w.damage_type]}`}
          {w.range && ` · ${w.range}`}
          {preview && preview.attackBonus !== 0 && ` · ${preview.attackBonus > 0 ? "+" : ""}${preview.attackBonus} no ataque`}
        </p>
        <p className="text-xs text-fg-dim">Categorias: {w.tags.map((t) => WEAPON_TAG_LABEL[t as WeaponTag]).join(", ") || "—"}</p>
        {(w.modifiers.length > 0 || w.custom_modifiers.length > 0) && (
          <p className="text-xs text-fg-dim">Modificadores: {[...w.modifiers.map((m) => WEAPON_MODIFIER_BY_ID[m]?.name ?? m), ...w.custom_modifiers.map((m) => `${m.name} (homebrew)`)].join(", ")}</p>
        )}
        {preview?.conditions.map((c) => (
          <p key={c} className="text-xs text-fg-muted">
            {c}
          </p>
        ))}
        <Text label="Efeitos especiais" value={w.special_rules} />
      </Block>
    );
  }
  if (entry.kind === "item" || entry.kind === "item_especial") {
    const it = defaultData(entry.kind, d) as unknown as ItemFormValue;
    return (
      <Block title="Item">
        <p className="text-sm text-fg">
          {ITEM_KINDS.find((k) => k.id === it.item_type)?.label} · quantidade {it.quantity}
          {it.uses_max ? ` · ${it.uses_max} uso(s)` : ""}
          {it.effect_dice && (
            <>
              {" "}
              · <span className="font-mono text-cyan">{it.effect_dice}</span> {it.effect_kind}
            </>
          )}
        </p>
        <Text label="Efeito e condições" value={it.special_rules} />
        {it.ability?.name && <Text label={`Concede: ${it.ability.name}`} value={it.ability.description || " "} />}
      </Block>
    );
  }
  if (entry.kind === "modificador") {
    const m = defaultData("modificador", d) as unknown as ModifierFormValue;
    return (
      <Block title="Modificador">
        <p className="text-sm text-fg">
          {m.requires === "qualquer" ? "Qualquer arma" : WEAPON_TAG_LABEL[m.requires as WeaponTag]}
          {m.attack_bonus ? ` · ${m.attack_bonus > 0 ? "+" : ""}${m.attack_bonus} no ataque` : ""}
          {m.extra_damage ? ` · +${m.extra_damage} de dano` : ""}
          {m.extra_weapon_dice ? ` · ${m.extra_weapon_dice > 0 ? "+" : ""}${m.extra_weapon_dice} dado(s)` : ""}
          {m.ignore_limit ? " · não ocupa vaga" : ""}
        </p>
        {(m.crit_extra_damage || m.crit_extra_weapon_dice) && (
          <p className="text-xs text-fg-dim">
            Em crítico: {[m.crit_extra_damage && `+${m.crit_extra_damage}`, m.crit_extra_weapon_dice && `+${m.crit_extra_weapon_dice} dado(s)`].filter(Boolean).join(", ")}
          </p>
        )}
        <Text label="Condição" value={m.condition} />
        <Text label="Penalidades" value={m.penalties} />
        <Text label="Requisitos" value={m.requirements} />
      </Block>
    );
  }
  const o = defaultData("outro", d) as unknown as OtherFormValue;
  return (
    <Block title={o.category || "Conteúdo"}>
      {o.effect_dice && <p className="font-mono text-sm text-cyan">{o.effect_dice}</p>}
      <p className="text-sm whitespace-pre-line text-fg-dim">{o.content || "—"}</p>
    </Block>
  );
}
