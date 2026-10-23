-- F.R.A.N.C.E 6.1 — ATUALIZAÇÃO (banco que já tem a Fase 5)
-- Cole no Supabase: SQL Editor → New query → Run. Não apaga dados; pode ser executado de novo.
-- Arquivos incluídos, nesta ordem:
--   20261027000000_rules_sync_v6.sql
--   20261027000100_v6_finalizacao.sql
--   20261028000000_rules_sync_v6_1.sql
--   20261028000100_v6_1_menor_vence.sql


-- =====================================================================
-- >>> 20261027000000_rules_sync_v6.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10-v6) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10-v6",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "pvFormula": "sum_div3",
  "abilities": {
    "base": 2,
    "perEvenLevel": 1,
    "blockLevelUpWhenPending": true,
    "originModes": {
      "muto": "none",
      "elo": "free"
    },
    "pathOverrides": {
      "prodigio:arsenal": {
        "base": 0,
        "perEvenLevel": 1
      },
      "prodigio:engrenagem": {
        "base": 1,
        "perEvenLevel": 1
      }
    }
  },
  "prodigioPowers": {
    "noPcCost": true,
    "noLimits": true,
    "allowNoEffects": true
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "skillDefs": {
    "luta": {
      "kind": "attribute",
      "attribute": "FOR",
      "divisor": 2
    },
    "reflexo": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "conhecimento_belico": {
      "kind": "attribute",
      "attribute": "INT",
      "divisor": 2
    },
    "arma_de_fogo": {
      "kind": "fixed",
      "value": 20
    },
    "pontaria": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "investigacao": {
      "kind": "fixed",
      "value": 20
    },
    "enganacao": {
      "kind": "fixed",
      "value": 15
    },
    "furtividade": {
      "kind": "fixed",
      "value": 20
    },
    "pilotagem": {
      "kind": "fixed",
      "value": 5
    },
    "intuicao": {
      "kind": "fixed",
      "value": 10
    }
  },
  "skillDistribution": {
    "skillsToChoose": 4,
    "totalPoints": 150,
    "maxSkillTotal": 75
  },
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "FOR": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "DEX": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {
        "PER": 4
      },
      "skillBonus": {},
      "maxSkillTotal": 95,
      "skillPointsBonus": 50,
      "pvBonusAtLevel1": 0
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "attributeBonus": {
        "MIT": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "arma_de_fogo": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "furtividade": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 20
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null,
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 2
      },
      "pcDice": null
    }
  },
  "weaponModifiers": {
    "afiada": "laminas",
    "perfurante": "perfurantes_projeteis",
    "serrilhada": "laminas",
    "precisa": "distancia",
    "equilibrada": "corpo_a_corpo",
    "pesada": "pesadas",
    "brutal": "pesadas",
    "concussiva": "contundentes",
    "gancho": "foices_correntes",
    "executora": "corpo_a_corpo",
    "rajada": "arma_de_fogo",
    "automatica": "arma_de_fogo",
    "curto_alcance": "arma_de_fogo",
    "mira_precisao": "arma_de_fogo",
    "recuo_pesado": "arma_de_fogo",
    "dispersao": "arma_de_fogo",
    "penetrante": "arma_de_fogo",
    "confiavel": "arma_de_fogo"
  },
  "techniques": {
    "arte_desarme": {
      "name": "Arte do Desarme",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "arte_contra_ataque": {
      "name": "Arte do Contra-ataque",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "provocacao": {
      "name": "Provocação",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_alvos": {
      "name": "Múltiplos Alvos",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_golpes": {
      "name": "Múltiplos Golpes",
      "usage": {
        "kind": "a_cada_turnos",
        "turns": 2
      },
      "requires": {},
      "special": null
    },
    "adrenalina": {
      "name": "Adrenalina",
      "usage": {
        "kind": "acao",
        "action": "Ação de movimento"
      },
      "requires": {},
      "special": "recarregar_cena"
    },
    "metavisao": {
      "name": "Metavisão",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": "esquiva_rodada"
    },
    "recobrar_se": {
      "name": "Recobrar-se",
      "usage": {
        "kind": "por_sessao",
        "times": 1
      },
      "requires": {},
      "special": "recobrar"
    },
    "passos_leves": {
      "name": "Passos Leves",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "ataque_furtivo": {
      "name": "Ataque Furtivo",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "furtividade_rapida": {
      "name": "Furtividade Rápida",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {
        "attributes": {
          "DEX": 70
        },
        "techniques": [
          "passos_leves"
        ]
      },
      "special": null
    }
  },
  "maxWeaponModifiers": 2,
  "grenades": {
    "granada_fragmentacao": {
      "name": "Granada de Fragmentação",
      "damage": "3d8",
      "area": "Área pequena",
      "condition": null
    },
    "granada_incendiaria": {
      "name": "Granada Incendiária",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Em chamas",
        "turns": 2,
        "dot": "1d6",
        "automatic": true,
        "target": "alvo"
      }
    },
    "granada_concussao": {
      "name": "Granada de Concussão",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Atordoado",
        "turns": 1,
        "automatic": false,
        "target": "alvo"
      }
    },
    "granada_explosiva_pesada": {
      "name": "Granada Explosiva Pesada",
      "damage": "5d8",
      "area": "Área média",
      "condition": null
    },
    "granada_fumaca": {
      "name": "Granada de Fumaça",
      "damage": null,
      "area": "Área pequena",
      "condition": {
        "name": "Cobertura de fumaça",
        "turns": 3,
        "automatic": true,
        "target": "lancador"
      }
    }
  },
  "thresholds": {
    "goodDivisor": 2,
    "extremeDivisor": 5,
    "rounding": "floor"
  },
  "damageMultiplier": {
    "extreme": 1.5,
    "critical": 2
  },
  "damageRounding": "none",
  "attackSkill": {
    "melee": "luta",
    "ranged": "pontaria",
    "firearm": "arma_de_fogo"
  },
  "opposed": {
    "winner": "higher",
    "tiePlayerWins": true,
    "maxRerolls": 10,
    "defaultReaction": {
      "melee": "luta",
      "ranged": "reflexo",
      "firearm": "reflexo"
    },
    "appliedRounding": "floor"
  },
  "powers": {
    "damageSingle": [
      3,
      6,
      9,
      12,
      15
    ],
    "damageArea": [
      6,
      9,
      12,
      15,
      18
    ],
    "areaSizes": {
      "pequena": 0,
      "media": 3,
      "grande": 6,
      "enorme": 9
    },
    "extraDieCost": 3,
    "heal": [
      3,
      6,
      9,
      12,
      15
    ],
    "healArea": {
      "alvo": 0,
      "pequena": 6,
      "media": 9,
      "grande": 12,
      "enorme": 15
    },
    "healContinuous": [
      2,
      3,
      4,
      5,
      6
    ],
    "shield": [
      3,
      6,
      9,
      12,
      15
    ],
    "shieldDuration": {
      "1t": 0,
      "2t": 2,
      "3t": 4,
      "cena": 6
    },
    "conditions": {
      "leve": {
        "initial": 3,
        "perTurn": 1
      },
      "moderada": {
        "initial": 6,
        "perTurn": 2
      },
      "forte": {
        "initial": 9,
        "perTurn": 3
      },
      "severa": {
        "initial": 12,
        "perTurn": 4
      },
      "extrema": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "buffs": {
      "teste_1": {
        "initial": 3,
        "perTurn": 1
      },
      "teste_2": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_1": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_2": {
        "initial": 9,
        "perTurn": 3
      },
      "acao": {
        "initial": 12,
        "perTurn": 4
      },
      "grande": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "levelTable": [
      {
        "level": 1,
        "maxPc": 15,
        "maxExtraDice": 1
      },
      {
        "level": 2,
        "maxPc": 18,
        "maxExtraDice": 1
      },
      {
        "level": 4,
        "maxPc": 24,
        "maxExtraDice": 2
      },
      {
        "level": 6,
        "maxPc": 30,
        "maxExtraDice": 3
      },
      {
        "level": 8,
        "maxPc": 36,
        "maxExtraDice": 4
      },
      {
        "level": 10,
        "maxPc": 42,
        "maxExtraDice": 5
      },
      {
        "level": 15,
        "maxPc": 57,
        "maxExtraDice": 7
      },
      {
        "level": 20,
        "maxPc": 72,
        "maxExtraDice": 10
      }
    ],
    "limitMode": "linear",
    "perTurnCountsTowardLimit": false,
    "amaldicoadoRounding": "ceil",
    "amaldicoadoLimitUsesFullCost": true
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

-- ---------------------------------------------------------------------
-- PV máximo da forma — mesma conta do motor (buildSheet):
-- (FOR + CON) ÷ 3 para baixo + bônus de classe + ganhos de nível ativos + outros bônus.
-- ---------------------------------------------------------------------
create or replace function public.form_pv_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  str int;
  con int;
  base int;
  gains int;
begin
  select cf.id, cf.kind, cf.pv_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into str
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'FOR';
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into con
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'CON';
  str := coalesce(str, 0) + coalesce((cls -> 'attributeBonus' ->> 'FOR')::int, 0);
  con := coalesce(con, 0) + coalesce((cls -> 'attributeBonus' ->> 'CON')::int, 0);
  if cfg ->> 'pvFormula' = 'sum_div3' then
    base := floor((str + con)::numeric / 3)::int;
  else
    base := str + floor(con::numeric / 3)::int;
  end if;
  base := base + coalesce((cls ->> 'pvBonusAtLevel1')::int, 0);
  select coalesce(sum(lp.pv_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, base + gains + f.pv_other_bonus);
end $$;

-- PC máximo da forma — mesma conta do motor: VIG ÷ 3 para baixo + ganhos de nível ativos + outros bônus.
create or replace function public.form_pc_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  vig int;
  gains int;
begin
  select cf.id, cf.kind, cf.pc_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into vig
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'VIG';
  vig := coalesce(vig, 0) + coalesce((cls -> 'attributeBonus' ->> 'VIG')::int, 0);
  select coalesce(sum(lp.pc_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, floor(vig::numeric / 3)::int + gains + f.pc_other_bonus);
end $$;

-- ---------------------------------------------------------------------
-- Vagas de habilidades — mesma conta do motor (abilities.ts).
-- mode: standard | free (Elo) | none (Muto). Executa com as permissões de quem chama.
-- ---------------------------------------------------------------------
create or replace function public.ability_granted(p_origin text, p_path text, p_level int) returns int
language plpgsql immutable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ov jsonb := cfg -> 'pathOverrides' -> (p_origin || ':' || p_path);
begin
  if coalesce(cfg -> 'originModes' ->> p_origin, 'standard') <> 'standard' then
    return 0;
  end if;
  return coalesce((ov ->> 'base')::int, (cfg ->> 'base')::int)
       + coalesce((ov ->> 'perEvenLevel')::int, (cfg ->> 'perEvenLevel')::int) * (greatest(p_level, 1) / 2);
end $$;

create or replace function public.ability_status(p_character uuid) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ch record;
  created int;
begin
  select level, origin_id, origin_path_id into ch from public.characters where id = p_character;
  -- Técnicas oficiais do Arsenal e poderes criados ocupam o mesmo conjunto de vagas (sem consumo duplicado).
  select (select count(*) from public.powers where character_id = p_character)
       + (select count(*) from public.character_techniques where character_id = p_character)
    into created;
  return jsonb_build_object(
    'mode', coalesce(cfg -> 'originModes' ->> ch.origin_id, 'standard'),
    'granted', public.ability_granted(ch.origin_id, ch.origin_path_id, ch.level),
    'created', created,
    'level', ch.level);
end $$;

grant execute on function public.rules_config() to authenticated;
grant execute on function public.form_pv_max(uuid), public.form_pc_max(uuid), public.ability_granted(text, text, int), public.ability_status(uuid) to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;


-- =====================================================================
-- >>> 20261027000100_v6_finalizacao.sql
-- =====================================================================
-- =====================================================================
-- F.R.A.N.C.E — VERSÃO 6.0 (Fase 6): combate por rolagens opostas, granadas,
-- efeitos contínuos com dano, fotos nos cartões de campanha.
-- Incremental sobre a Fase 5 (aplique DEPOIS de 20261027000000_rules_sync_v6.sql).
-- Não apaga tabelas nem dados; pode ser reaplicada.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Classificação do d100 e resultado do confronto (mesma conta do motor: src/rules/opposed.ts)
-- ---------------------------------------------------------------------
create or replace function public.apply_rounding(p_value numeric, p_mode text) returns numeric
language sql immutable as $$
  select case p_mode when 'floor' then floor(p_value) when 'ceil' then ceil(p_value) when 'round' then round(p_value) else p_value end
$$;

-- Menor é melhor: 1 = crítico, 100 = falha crítica; extremo ≤ valor/5, bom ≤ valor/2, normal ≤ valor.
create or replace function public.classify_d100(p_natural int, p_value int, p_modifier int default 0) returns text
language plpgsql stable set search_path = public as $$
declare
  t jsonb := public.rules_config() -> 'thresholds';
  v int := greatest(0, coalesce(p_value, 0));
  eff int := p_natural + coalesce(p_modifier, 0);
begin
  if p_natural is null or p_natural < 1 or p_natural > 100 then
    raise exception 'O resultado do d100 deve ser um inteiro entre 1 e 100.';
  end if;
  if p_natural = 1 then return 'critical_success'; end if;
  if p_natural = 100 then return 'critical_failure'; end if;
  if eff <= public.apply_rounding(v::numeric / (t ->> 'extremeDivisor')::numeric, t ->> 'rounding') then return 'extreme'; end if;
  if eff <= public.apply_rounding(v::numeric / (t ->> 'goodDivisor')::numeric, t ->> 'rounding') then return 'good'; end if;
  if eff <= v then return 'normal'; end if;
  return 'failure';
end $$;

create or replace function public.outcome_label(p_outcome text) returns text
language sql immutable as $$
  select case p_outcome when 'critical_success' then 'Acerto crítico' when 'critical_failure' then 'Falha crítica'
    when 'extreme' then 'Acerto extremo' when 'good' then 'Acerto bom' when 'normal' then 'Acerto normal' else 'Falha' end
$$;

-- Uma rodada: vencedor (maior d100, configurável), desempates e multiplicador do dano.
create or replace function public.confront_outcome(p_attack int, p_defend int, p_att_skill int, p_def_skill int,
                                                   p_att_player boolean, p_def_player boolean, p_modifier int default 0)
returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  higher boolean := coalesce(cfg -> 'opposed' ->> 'winner', 'higher') = 'higher';
  quality text := public.classify_d100(p_attack, p_att_skill, p_modifier);
  dquality text := public.classify_d100(p_defend, p_def_skill, 0);
  winner text;
  tie text := 'none';
  mult numeric := 0;
begin
  if p_attack <> p_defend then
    winner := case when (p_attack > p_defend) = higher then 'attacker' else 'defender' end;
  elsif coalesce((cfg -> 'opposed' ->> 'tiePlayerWins')::boolean, true) and p_att_player is distinct from p_def_player then
    winner := case when p_att_player then 'attacker' else 'defender' end;
    tie := 'player';
  elsif coalesce(p_att_skill, 0) <> coalesce(p_def_skill, 0) then
    winner := case when coalesce(p_att_skill, 0) > coalesce(p_def_skill, 0) then 'attacker' else 'defender' end;
    tie := 'skill';
  else
    winner := 'reroll';
    tie := 'reroll';
  end if;
  if winner = 'attacker' then
    mult := case quality when 'critical_success' then (cfg -> 'damageMultiplier' ->> 'critical')::numeric
                         when 'extreme' then (cfg -> 'damageMultiplier' ->> 'extreme')::numeric else 1 end;
  end if;
  return jsonb_build_object('winner', winner, 'tie_break', tie, 'quality', quality, 'defender_quality', dquality, 'multiplier', mult);
end $$;

-- ---------------------------------------------------------------------
-- 2. Valor das perícias (mesma conta do motor: base do atributo final + pontos + classe + outros + temporários)
-- ---------------------------------------------------------------------
create or replace function public.form_skill_value(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
  base int;
  fs record;
begin
  if def is null then
    return 0;
  end if;
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    base := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    base := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  select coalesce(points, 0) as points, coalesce(other_bonus, 0) as other_bonus, coalesce(temp_bonus, 0) as temp_bonus into fs
  from public.form_skills where form_id = p_form and skill_id = p_skill;
  return base + coalesce(fs.points, 0) + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0) + coalesce(fs.other_bonus, 0) + coalesce(fs.temp_bonus, 0);
end $$;
revoke execute on function public.form_skill_value(uuid, text) from public, anon;

-- Perícia de um combatente: personagem → ficha (forma usada no combate); criatura → ficha copiada (perícia,
-- senão a base do atributo como nas regras, senão 0).
create or replace function public.combatant_skill_value(p_combatant uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cb public.combatants;
  d jsonb;
  def jsonb := public.rules_config() -> 'skillDefs' -> p_skill;
  v int;
begin
  select * into cb from public.combatants where id = p_combatant;
  if cb.id is null then return 0; end if;
  if cb.character_id is not null then
    return public.form_skill_value(cb.form_id, p_skill);
  end if;
  d := coalesce(cb.data, '{}'::jsonb);
  if jsonb_array_length(coalesce(d -> 'skills', '[]'::jsonb)) = 0 and d -> 'attributes' is null and cb.npc_id is not null then
    select data into d from public.npcs where id = cb.npc_id;
  end if;
  select (s ->> 'value')::int into v from jsonb_array_elements(coalesce(d -> 'skills', '[]'::jsonb)) s where s ->> 'id' = p_skill limit 1;
  if v is not null then return v; end if;
  if def ->> 'kind' = 'fixed' then return (def ->> 'value')::int; end if;
  if def ->> 'kind' = 'attribute' and (d -> 'attributes' ->> (def ->> 'attribute')) is not null then
    return floor((d -> 'attributes' ->> (def ->> 'attribute'))::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return 0;
end $$;
revoke execute on function public.combatant_skill_value(uuid, text) from public, anon;

-- ---------------------------------------------------------------------
-- 3. CONFRONTOS (histórico próprio; os dados são rolados AQUI — ninguém escolhe o número)
-- ---------------------------------------------------------------------
create table if not exists public.combat_confrontations (
  id uuid primary key default gen_random_uuid(),
  combat_id uuid not null references public.combats (id) on delete cascade,
  attacker_id uuid references public.combatants (id) on delete set null,
  defender_id uuid references public.combatants (id) on delete set null,
  attacker_name text not null,
  defender_name text not null,
  label text not null default '',
  attack_skill text,
  attack_value int not null default 0,
  reaction_skill text,
  defense_value int not null default 0,
  rounds jsonb not null default '[]'::jsonb,
  attack_roll int not null,
  defend_roll int not null,
  winner text not null check (winner in ('attacker', 'defender')),
  tie_break text not null default 'none',
  quality text not null,
  defender_quality text not null,
  multiplier numeric not null default 0,
  damage jsonb,
  final_damage numeric not null default 0,
  applied_damage int not null default 0,
  applied boolean not null default false,
  conditions jsonb not null default '[]'::jsonb,
  public boolean not null default true,
  requested_by uuid references auth.users (id) on delete set null,
  by_player boolean not null default false,
  request_id uuid not null unique,
  round int not null default 1,
  created_at timestamptz not null default now()
);
create index if not exists combat_confrontations_combat_idx on public.combat_confrontations (combat_id, created_at desc);
alter table public.combat_confrontations enable row level security;
drop policy if exists confront_master on public.combat_confrontations;
create policy confront_master on public.combat_confrontations for select to authenticated
  using (exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_master(c.campaign_id)));
drop policy if exists confront_players on public.combat_confrontations;
create policy confront_players on public.combat_confrontations for select to authenticated
  using (public and exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_member(c.campaign_id)));
revoke insert, update, delete on public.combat_confrontations from authenticated, anon;
grant select on public.combat_confrontations to authenticated;

-- Aplica as condições de um confronto vencido no defensor (com dano contínuo, se houver). Uso interno.
create or replace function public.combatant_add_conditions(p_combatant uuid, p_conditions jsonb) returns void
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  c jsonb;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  if cbt.id is null then return; end if;
  for c in select * from jsonb_array_elements(coalesce(p_conditions, '[]'::jsonb)) loop
    continue when coalesce(c ->> 'name', '') = '' or coalesce((c ->> 'automatic')::boolean, true) = false;
    if cbt.character_id is not null then
      update public.character_forms set conditions = public.condition_add_dot(conditions, left(c ->> 'name', 80), nullif(c ->> 'turns', '')::int, null, nullif(c ->> 'dot', ''))
      where id = cbt.form_id;
    else
      update public.combatants set conditions = public.condition_add_dot(conditions, left(c ->> 'name', 80), nullif(c ->> 'turns', '')::int, null, nullif(c ->> 'dot', ''))
      where id = cbt.id;
    end if;
  end loop;
end $$;
revoke execute on function public.combatant_add_conditions(uuid, jsonb) from public, anon, authenticated;

create or replace function public.combat_confront(
  p_combat uuid, p_attacker uuid, p_defender uuid, p_attack jsonb, p_reaction text, p_request uuid,
  p_apply boolean default false, p_public boolean default true)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  cb public.combats;
  att public.combatants;
  def public.combatants;
  existing public.combat_confrontations;
  is_master boolean;
  skill text := nullif(p_attack ->> 'skill', '');
  reaction text := nullif(p_reaction, '');
  att_value int;
  def_value int;
  modifier int := coalesce((p_attack ->> 'modifier')::int, 0);
  factor numeric := coalesce((p_attack ->> 'factor')::numeric, 1);
  dmg_expr text := nullif(trim(coalesce(p_attack ->> 'damage', '')), '');
  crit_expr text := nullif(trim(coalesce(p_attack ->> 'critical', '')), '');
  label text := left(coalesce(nullif(p_attack ->> 'label', ''), 'Ataque'), 120);
  a int; d int;
  o jsonb;
  rounds jsonb := '[]'::jsonb;
  n int := 0;
  dmg jsonb;
  final numeric := 0;
  applied_amount int := 0;
  visible boolean;
  row public.combat_confrontations;
  msg text;
begin
  select * into existing from public.combat_confrontations where request_id = p_request;
  if existing.id is not null then
    return to_jsonb(existing) || jsonb_build_object('duplicate', true);
  end if;
  select * into cb from public.combats where id = p_combat;
  select * into att from public.combatants where id = p_attacker and combat_id = p_combat;
  select * into def from public.combatants where id = p_defender and combat_id = p_combat;
  if cb.id is null or att.id is null or def.id is null then
    raise exception 'Combate ou participantes inválidos.';
  end if;
  if att.id = def.id then
    raise exception 'Escolha outro alvo.';
  end if;
  is_master := public.is_campaign_master(cb.campaign_id);
  if not is_master then
    -- Jogador: só ataca com o próprio personagem, em combate em andamento; o dano não é aplicado sozinho.
    if att.character_id is null or not public.owns_character(att.character_id) or cb.status <> 'active' then
      raise exception 'Você só pode atacar com o seu personagem, durante o combate.';
    end if;
    if def.hidden then
      raise exception 'Alvo inválido.';
    end if;
    p_apply := false;
    p_public := true;
    modifier := greatest(-60, least(60, modifier));
    factor := greatest(1, least(2, factor));
  end if;
  if cb.status = 'ended' then
    raise exception 'Combate encerrado.';
  end if;
  if skill is not null and not (cfg -> 'skills') ? skill then
    raise exception 'Perícia de ataque inválida.';
  end if;
  if reaction is null then
    reaction := coalesce(cfg -> 'opposed' -> 'defaultReaction' ->> coalesce(p_attack ->> 'attack_kind', 'melee'), 'reflexo');
  end if;
  if not (cfg -> 'skills') ? reaction then
    raise exception 'Perícia de reação inválida.';
  end if;
  if dmg_expr is not null and not public.is_valid_dice(dmg_expr) then raise exception 'Dano inválido.'; end if;
  if crit_expr is not null and not public.is_valid_dice(crit_expr) then raise exception 'Dano crítico inválido.'; end if;

  -- Valores das perícias calculados no banco (personagens) ou pela ficha copiada (criaturas).
  if att.character_id is not null then
    att_value := public.form_skill_value(att.form_id, coalesce(skill, cfg -> 'attackSkill' ->> coalesce(p_attack ->> 'attack_kind', 'melee')));
  elsif is_master and (p_attack ->> 'value') is not null then
    att_value := greatest(0, least(999, (p_attack ->> 'value')::int));
  else
    att_value := public.combatant_skill_value(att.id, coalesce(skill, 'luta'));
  end if;
  def_value := public.combatant_skill_value(def.id, reaction);

  loop
    n := n + 1;
    a := public.roll_die(100);
    d := public.roll_die(100);
    o := public.confront_outcome(a, d, att_value, def_value, att.character_id is not null, def.character_id is not null, modifier);
    rounds := rounds || jsonb_build_array(jsonb_build_object('attack', a, 'defend', d, 'winner', o ->> 'winner', 'tie_break', o ->> 'tie_break'));
    exit when o ->> 'winner' <> 'reroll' or n > coalesce((cfg -> 'opposed' ->> 'maxRerolls')::int, 10);
  end loop;
  if o ->> 'winner' = 'reroll' then
    o := o || jsonb_build_object('winner', 'defender', 'multiplier', 0);
  end if;

  if o ->> 'winner' = 'attacker' and dmg_expr is not null then
    dmg := public.roll_expression(case when o ->> 'quality' = 'critical_success' and crit_expr is not null then crit_expr else dmg_expr end);
    final := public.apply_rounding((dmg ->> 'total')::numeric * (o ->> 'multiplier')::numeric * factor, cfg ->> 'damageRounding');
    applied_amount := greatest(0, public.apply_rounding(final, coalesce(cfg -> 'opposed' ->> 'appliedRounding', 'floor'))::int);
  end if;

  visible := p_public and not att.hidden and not def.hidden;
  insert into public.combat_confrontations (combat_id, attacker_id, defender_id, attacker_name, defender_name, label, attack_skill, attack_value,
    reaction_skill, defense_value, rounds, attack_roll, defend_roll, winner, tie_break, quality, defender_quality, multiplier, damage,
    final_damage, applied_damage, conditions, public, requested_by, by_player, request_id, round)
  values (p_combat, att.id, def.id, att.name, def.name, label, skill, att_value, reaction, def_value, rounds, a, d, o ->> 'winner',
    o ->> 'tie_break', o ->> 'quality', o ->> 'defender_quality', (o ->> 'multiplier')::numeric, dmg, final, applied_amount,
    case when o ->> 'winner' = 'attacker' then coalesce(p_attack -> 'conditions', '[]'::jsonb) else '[]'::jsonb end,
    visible, auth.uid(), not is_master, p_request, cb.round)
  returning * into row;

  msg := format('%s → %s (%s): d100 %s × %s — %s', att.name, def.name, label, a, d,
    case when o ->> 'winner' = 'attacker' then 'acertou' else 'defendido' end)
    || case when o ->> 'tie_break' <> 'none' then ' (' || case o ->> 'tie_break' when 'player' then 'empate: jogador vence' when 'skill' then 'empate: perícia' else 'empate' end || ')' else '' end
    || case when o ->> 'winner' = 'attacker' then ', ' || public.outcome_label(o ->> 'quality') ||
         case when dmg is not null then format(', %s de dano', final) else '' end else '' end || '.';
  perform public.combat_log_add(p_combat, 'confronto', msg, jsonb_build_object('confront', row.id), visible);

  if p_apply and is_master and row.winner = 'attacker' and (applied_amount > 0 or jsonb_array_length(row.conditions) > 0) then
    if applied_amount > 0 then
      perform public.combat_apply(def.id, 'damage', applied_amount, md5('confront:' || row.id::text)::uuid, label);
    end if;
    perform public.combatant_add_conditions(def.id, row.conditions);
    update public.combat_confrontations set applied = true where id = row.id returning * into row;
  end if;
  update public.combats set version = version + 1, updated_at = now() where id = p_combat;
  return to_jsonb(row) || jsonb_build_object('duplicate', false);
end $$;
revoke execute on function public.combat_confront(uuid, uuid, uuid, jsonb, text, uuid, boolean, boolean) from public, anon;
grant execute on function public.combat_confront(uuid, uuid, uuid, jsonb, text, uuid, boolean, boolean) to authenticated;

-- O Mestre confirma o dano de um confronto (ex.: ataque feito pelo jogador). Aplica uma vez só.
create or replace function public.combat_confront_apply(p_confront uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  r public.combat_confrontations;
  cb public.combats;
begin
  select * into r from public.combat_confrontations where id = p_confront for update;
  select * into cb from public.combats where id = r.combat_id;
  if r.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica o dano.';
  end if;
  if r.winner <> 'attacker' or (r.applied_damage <= 0 and jsonb_array_length(r.conditions) = 0) or r.defender_id is null then
    raise exception 'Não há dano para aplicar.';
  end if;
  if r.applied then
    return to_jsonb(r) || jsonb_build_object('duplicate', true);
  end if;
  if r.applied_damage > 0 then
    perform public.combat_apply(r.defender_id, 'damage', r.applied_damage, md5('confront:' || r.id::text)::uuid, r.label);
  end if;
  perform public.combatant_add_conditions(r.defender_id, r.conditions);
  update public.combat_confrontations set applied = true where id = r.id returning * into r;
  return to_jsonb(r) || jsonb_build_object('duplicate', false);
end $$;
revoke execute on function public.combat_confront_apply(uuid) from public, anon;
grant execute on function public.combat_confront_apply(uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 4. EFEITOS CONTÍNUOS COM DANO (ex.: Granada Incendiária: +1d6 por 2 turnos)
-- Condição pode ter "dot" (expressão de dados): o dano é rolado no fim do turno de quem a tem, antes da duração cair.
-- ---------------------------------------------------------------------
create or replace function public.condition_add_dot(p_list jsonb, p_name text, p_turns int, p_note text, p_dot text) returns jsonb
language plpgsql volatile as $$
declare
  l jsonb := public.condition_add(p_list, p_name, p_turns, p_note);
begin
  if p_dot is null or trim(p_dot) = '' then
    return l;
  end if;
  if not public.is_valid_dice(p_dot) then
    raise exception 'Dano contínuo inválido.';
  end if;
  return jsonb_set(l, array[(jsonb_array_length(l) - 1)::text], (l -> (jsonb_array_length(l) - 1)) || jsonb_build_object('dot', p_dot));
end $$;

drop function if exists public.combat_condition(uuid, text, text, int, text);
create or replace function public.combat_condition(p_combatant uuid, p_action text, p_name text default null, p_turns int default null,
                                                   p_id text default null, p_dot text default null)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
  list jsonb;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica condições no combate.';
  end if;
  if p_action = 'add' then
    if cbt.character_id is not null then
      update public.character_forms set conditions = public.condition_add_dot(conditions, p_name, p_turns, null, p_dot) where id = cbt.form_id returning conditions into list;
    else
      update public.combatants set conditions = public.condition_add_dot(conditions, p_name, p_turns, null, p_dot) where id = cbt.id returning conditions into list;
    end if;
  elsif p_action = 'remove' then
    if cbt.character_id is not null then
      update public.character_forms set conditions = public.condition_remove(conditions, p_id) where id = cbt.form_id returning conditions into list;
    else
      update public.combatants set conditions = public.condition_remove(conditions, p_id) where id = cbt.id returning conditions into list;
    end if;
  else
    raise exception 'Ação inválida.';
  end if;
  perform public.combat_log_add(cb.id, 'condicao',
    case when p_action = 'add' then format('%s: %s%s%s.', cbt.name, p_name, case when p_turns is null then '' else format(' (%s turno(s))', p_turns) end,
                                           case when p_dot is null then '' else format(', %s por turno', p_dot) end)
         else format('%s: condição removida.', cbt.name) end, '{}'::jsonb, not cbt.hidden);
  update public.combats set version = version + 1, updated_at = now() where id = cb.id;
  return list;
end $$;
revoke execute on function public.combat_condition(uuid, text, text, int, text, text) from public, anon;
grant execute on function public.combat_condition(uuid, text, text, int, text, text) to authenticated;

create or replace function public.combat_tick_conditions(p_combat uuid, p_combatant public.combatants) returns void
language plpgsql security definer set search_path = public as $$
declare
  r record;
  hidden boolean := p_combatant.hidden;
  conds jsonb;
  c jsonb;
  roll jsonb;
  total int := 0;
  parts text[] := '{}';
begin
  if p_combatant.character_id is not null and p_combatant.form_id is not null then
    select conditions into conds from public.character_forms where id = p_combatant.form_id;
  else
    conds := p_combatant.conditions;
  end if;
  -- Dano contínuo (dot) antes de a duração diminuir.
  for c in select * from jsonb_array_elements(coalesce(conds, '[]'::jsonb)) loop
    if coalesce(c ->> 'dot', '') <> '' and public.is_valid_dice(c ->> 'dot') then
      roll := public.roll_expression(c ->> 'dot');
      total := total + greatest(0, (roll ->> 'total')::int);
      parts := array_append(parts, format('%s %s', c ->> 'name', roll ->> 'total'));
    end if;
  end loop;
  if total > 0 then
    if p_combatant.character_id is not null and p_combatant.form_id is not null then
      update public.character_forms set pv_current = greatest(pv_current - total, 0) where id = p_combatant.form_id;
    else
      update public.combatants set pv_current = greatest(coalesce(pv_current, 0) - total, 0) where id = p_combatant.id and pv_current is not null;
    end if;
    perform public.combat_log_add(p_combat, 'damage', format('%s sofre %s de dano contínuo (%s).', p_combatant.name, total, array_to_string(parts, ', ')), '{}'::jsonb, not hidden);
  end if;
  select * into r from public.condition_tick(conds);
  if p_combatant.character_id is not null and p_combatant.form_id is not null then
    update public.character_forms set conditions = r.list where id = p_combatant.form_id;
  else
    update public.combatants set conditions = r.list where id = p_combatant.id;
  end if;
  if cardinality(r.expired) > 0 then
    perform public.combat_log_add(p_combat, 'condicao', format('%s: terminou %s.', p_combatant.name, array_to_string(r.expired, ', ')), '{}'::jsonb, not hidden);
  end if;
end $$;
revoke execute on function public.combat_tick_conditions(uuid, public.combatants) from public, anon, authenticated;

-- ---------------------------------------------------------------------
-- 5. FOTOS NOS CARTÕES DA CAMPANHA
-- O grupo (personagens aceitos) mostra a foto da forma ativa; quem vê o grupo também vê as fotos.
-- ---------------------------------------------------------------------
drop function if exists public.campaign_party(uuid);
create or replace function public.campaign_party(p_campaign uuid)
returns table (character_id uuid, name text, class_id text, origin_id text, origin_path_id text, level int,
               owner_id uuid, owner_username text, status text, is_mine boolean, active_form text, portrait_path text)
language sql stable security definer set search_path = public as $$
  select c.id, c.name, c.class_id, c.origin_id, c.origin_path_id, c.level, c.owner_id, p.username::text, cc.status,
         c.owner_id = auth.uid(), c.active_form,
         coalesce((select cf.portrait_path from public.character_forms cf where cf.character_id = c.id and cf.kind = c.active_form and cf.setup_complete),
                  (select cf.portrait_path from public.character_forms cf where cf.character_id = c.id and cf.kind = 'base'))
  from public.campaign_characters cc
  join public.characters c on c.id = cc.character_id
  left join public.profiles p on p.id = c.owner_id
  where cc.campaign_id = p_campaign
    and public.is_campaign_member(p_campaign)
    and (
      public.is_campaign_master(p_campaign)
      or c.owner_id = auth.uid()
      or (cc.status = 'accepted' and coalesce((select (settings ->> 'players_see_party')::boolean from public.campaigns where id = p_campaign), true))
    )
  order by cc.linked_at;
$$;
grant execute on function public.campaign_party(uuid) to authenticated;

create or replace function public.can_read_media(p_name text) returns boolean
language plpgsql stable security definer set search_path = public as $$
declare
  folder text := split_part(p_name, '/', 1);
  v_owner uuid := public.try_uuid(split_part(p_name, '/', 2));
begin
  if auth.uid() is null or v_owner is null then
    return false;
  end if;
  if folder = 'characters' then
    -- Dono e Mestre (vínculo aceito) + colegas de campanha que podem ver o grupo.
    return public.can_view_character(v_owner) or exists (
      select 1 from public.campaign_characters cc join public.campaigns k on k.id = cc.campaign_id
      where cc.character_id = v_owner and cc.status = 'accepted' and public.is_campaign_member(cc.campaign_id)
        and coalesce((k.settings ->> 'players_see_party')::boolean, true));
  elsif folder = 'homebrew' then
    if v_owner = auth.uid() then
      return true;
    end if;
    if exists (select 1 from public.homebrew h where h.image_path = p_name and public.homebrew_shared_with_me(h.id)) then
      return true;
    end if;
  elsif folder = 'npcs' then
    if public.is_campaign_master(v_owner) then
      return true;
    end if;
  else
    return false;
  end if;
  return exists (select 1 from public.npcs n where n.image_path = p_name and n.visible_to_players and public.is_campaign_member(n.campaign_id))
      or exists (select 1 from public.combatants cb join public.combats c on c.id = cb.combat_id
                 where cb.image_path = p_name and not cb.hidden and public.is_campaign_member(c.campaign_id))
      or exists (select 1 from public.items i where i.image_path = p_name and public.can_view_character(i.character_id));
end $$;
grant execute on function public.can_read_media(text) to authenticated;

-- ---------------------------------------------------------------------
-- 5b. GRANADAS E KIT DO DEMOLIDOR
-- ---------------------------------------------------------------------
-- Kit: uma linha por tipo de granada ("kit:demolidor:granadas.fragmentacao"); a linha antiga continua válida.
alter table public.items drop constraint if exists items_kit_ref_format;
alter table public.items add constraint items_kit_ref_format check (kit_ref is null or kit_ref ~ '^kit:[a-z_]+:[a-z_]+(\.[a-z_]+)?$');

-- Idempotência de uso de itens em combate: o mesmo clique nunca consome duas vezes.
create table if not exists public.item_uses (
  request_id uuid primary key,
  item_id uuid references public.items (id) on delete set null,
  created_by uuid references auth.users (id) on delete set null,
  result jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.item_uses enable row level security;
drop policy if exists item_uses_select on public.item_uses;
create policy item_uses_select on public.item_uses for select to authenticated using (created_by = auth.uid());
revoke insert, update, delete on public.item_uses from authenticated, anon;
grant select on public.item_uses to authenticated;

-- Lança uma granada no combate: desconta 1 do inventário (atômico) e resolve um confronto por alvo
-- (Pontaria do lançador × Reflexo do alvo, rolado aqui). Fumaça não tem alvo: cria cobertura em quem lançou.
create or replace function public.combat_use_grenade(p_combat uuid, p_attacker uuid, p_item uuid, p_targets uuid[], p_request uuid)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  cb public.combats;
  att public.combatants;
  it public.items;
  g jsonb;
  done public.item_uses;
  is_master boolean;
  t uuid;
  n int := 0;
  results jsonb := '[]'::jsonb;
  cond jsonb;
  r jsonb;
  out jsonb;
begin
  select * into done from public.item_uses where request_id = p_request;
  if done.request_id is not null then
    return done.result || jsonb_build_object('duplicate', true);
  end if;
  select * into cb from public.combats where id = p_combat;
  select * into att from public.combatants where id = p_attacker and combat_id = p_combat;
  if cb.id is null or att.id is null or att.character_id is null then
    raise exception 'Combate ou lançador inválido.';
  end if;
  if cb.status <> 'active' then
    raise exception 'O combate não está em andamento.';
  end if;
  is_master := public.is_campaign_master(cb.campaign_id);
  if not (public.owns_character(att.character_id) or (is_master and public.can_edit_character(att.character_id))) then
    raise exception 'Você só lança granadas do seu personagem.';
  end if;
  select * into it from public.items where id = p_item and character_id = att.character_id for update;
  g := cfg -> 'grenades' -> coalesce(it.source_ref, '');
  if it.id is null or g is null then
    raise exception 'Este item não é uma granada.';
  end if;
  if it.quantity <= 0 then
    raise exception 'Sem granadas deste tipo.';
  end if;
  if coalesce(array_length(p_targets, 1), 0) > 12 then
    raise exception 'Alvos demais.';
  end if;
  if g ->> 'damage' is not null and coalesce(array_length(p_targets, 1), 0) = 0 then
    raise exception 'Escolha ao menos um alvo na área.';
  end if;
  update public.items set quantity = quantity - 1 where id = it.id returning * into it;
  cond := g -> 'condition';

  if g ->> 'damage' is not null then
    foreach t in array p_targets loop
      n := n + 1;
      r := public.combat_confront(p_combat, p_attacker, t,
        jsonb_build_object('label', g ->> 'name', 'skill', 'pontaria', 'attack_kind', 'ranged', 'damage', g ->> 'damage',
          'conditions', case when cond is not null and cond ->> 'target' = 'alvo'
                             then jsonb_build_array(cond || jsonb_build_object('automatic', coalesce((cond ->> 'automatic')::boolean, true))) else '[]'::jsonb end),
        'reflexo', md5(p_request::text || ':' || t::text)::uuid, is_master, true);
      results := results || jsonb_build_array(r);
    end loop;
  end if;
  -- Efeito em quem lançou (ex.: cobertura de fumaça).
  if cond is not null and cond ->> 'target' = 'lancador' then
    perform public.combatant_add_conditions(att.id, jsonb_build_array(cond));
    perform public.combat_log_add(p_combat, 'efeito', format('%s usa %s: %s (%s turnos).', att.name, g ->> 'name', cond ->> 'name', cond ->> 'turns'), '{}'::jsonb, not att.hidden);
  end if;
  update public.combats set version = version + 1, updated_at = now() where id = p_combat;
  out := jsonb_build_object('grenade', g ->> 'name', 'item', it.id, 'quantity', it.quantity, 'confronts', results, 'self_condition',
    case when cond ->> 'target' = 'lancador' then cond else null end);
  insert into public.item_uses (request_id, item_id, created_by, result) values (p_request, it.id, auth.uid(), out);
  return out || jsonb_build_object('duplicate', false);
end $$;
revoke execute on function public.combat_use_grenade(uuid, uuid, uuid, uuid[], uuid) from public, anon;
grant execute on function public.combat_use_grenade(uuid, uuid, uuid, uuid[], uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 6. Realtime
-- ---------------------------------------------------------------------
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
     and not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'combat_confrontations') then
    alter publication supabase_realtime add table public.combat_confrontations;
  end if;
end $$;

grant execute on function public.classify_d100(int, int, int), public.confront_outcome(int, int, int, int, boolean, boolean, int), public.outcome_label(text) to authenticated;


-- =====================================================================
-- >>> 20261028000000_rules_sync_v6_1.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10-v6.1) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10-v6.1",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "pvFormula": "sum_div3",
  "abilities": {
    "base": 2,
    "perEvenLevel": 1,
    "blockLevelUpWhenPending": true,
    "originModes": {
      "muto": "none",
      "elo": "free"
    },
    "pathOverrides": {
      "prodigio:arsenal": {
        "base": 0,
        "perEvenLevel": 1
      },
      "prodigio:engrenagem": {
        "base": 1,
        "perEvenLevel": 1
      }
    }
  },
  "prodigioPowers": {
    "noPcCost": true,
    "noLimits": true,
    "allowNoEffects": true
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "skillDefs": {
    "luta": {
      "kind": "attribute",
      "attribute": "FOR",
      "divisor": 2
    },
    "reflexo": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "conhecimento_belico": {
      "kind": "attribute",
      "attribute": "INT",
      "divisor": 2
    },
    "arma_de_fogo": {
      "kind": "fixed",
      "value": 20
    },
    "pontaria": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "investigacao": {
      "kind": "fixed",
      "value": 20
    },
    "enganacao": {
      "kind": "fixed",
      "value": 15
    },
    "furtividade": {
      "kind": "fixed",
      "value": 20
    },
    "pilotagem": {
      "kind": "fixed",
      "value": 5
    },
    "intuicao": {
      "kind": "fixed",
      "value": 10
    }
  },
  "skillDistribution": {
    "skillsToChoose": 4,
    "totalPoints": 150,
    "maxSkillTotal": 75
  },
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "FOR": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "DEX": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {
        "PER": 4
      },
      "skillBonus": {},
      "maxSkillTotal": 95,
      "skillPointsBonus": 50,
      "pvBonusAtLevel1": 0
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "attributeBonus": {
        "MIT": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "arma_de_fogo": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "furtividade": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 20
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null,
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 2
      },
      "pcDice": null
    }
  },
  "weaponModifiers": {
    "afiada": "laminas",
    "perfurante": "perfurantes_projeteis",
    "serrilhada": "laminas",
    "precisa": "distancia",
    "equilibrada": "corpo_a_corpo",
    "pesada": "pesadas",
    "brutal": "pesadas",
    "concussiva": "contundentes",
    "gancho": "foices_correntes",
    "executora": "corpo_a_corpo",
    "rajada": "arma_de_fogo",
    "automatica": "arma_de_fogo",
    "curto_alcance": "arma_de_fogo",
    "mira_precisao": "arma_de_fogo",
    "recuo_pesado": "arma_de_fogo",
    "dispersao": "arma_de_fogo",
    "penetrante": "arma_de_fogo",
    "confiavel": "arma_de_fogo"
  },
  "techniques": {
    "arte_desarme": {
      "name": "Arte do Desarme",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "arte_contra_ataque": {
      "name": "Arte do Contra-ataque",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "provocacao": {
      "name": "Provocação",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_alvos": {
      "name": "Múltiplos Alvos",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_golpes": {
      "name": "Múltiplos Golpes",
      "usage": {
        "kind": "a_cada_turnos",
        "turns": 2
      },
      "requires": {},
      "special": null
    },
    "adrenalina": {
      "name": "Adrenalina",
      "usage": {
        "kind": "acao",
        "action": "Ação de movimento"
      },
      "requires": {},
      "special": "recarregar_cena"
    },
    "metavisao": {
      "name": "Metavisão",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": "esquiva_rodada"
    },
    "recobrar_se": {
      "name": "Recobrar-se",
      "usage": {
        "kind": "por_sessao",
        "times": 1
      },
      "requires": {},
      "special": "recobrar"
    },
    "passos_leves": {
      "name": "Passos Leves",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "ataque_furtivo": {
      "name": "Ataque Furtivo",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "furtividade_rapida": {
      "name": "Furtividade Rápida",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {
        "attributes": {
          "DEX": 70
        },
        "techniques": [
          "passos_leves"
        ]
      },
      "special": null
    }
  },
  "maxWeaponModifiers": 2,
  "grenades": {
    "granada_fragmentacao": {
      "name": "Granada de Fragmentação",
      "damage": "3d8",
      "area": "Área pequena",
      "condition": null
    },
    "granada_incendiaria": {
      "name": "Granada Incendiária",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Em chamas",
        "turns": 2,
        "dot": "1d6",
        "automatic": true,
        "target": "alvo"
      }
    },
    "granada_concussao": {
      "name": "Granada de Concussão",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Atordoado",
        "turns": 1,
        "automatic": false,
        "target": "alvo"
      }
    },
    "granada_explosiva_pesada": {
      "name": "Granada Explosiva Pesada",
      "damage": "5d8",
      "area": "Área média",
      "condition": null
    },
    "granada_fumaca": {
      "name": "Granada de Fumaça",
      "damage": null,
      "area": "Área pequena",
      "condition": {
        "name": "Cobertura de fumaça",
        "turns": 3,
        "automatic": true,
        "target": "lancador"
      }
    }
  },
  "thresholds": {
    "goodDivisor": 2,
    "extremeDivisor": 5,
    "rounding": "floor"
  },
  "damageMultiplier": {
    "extreme": 1.5,
    "critical": 2
  },
  "damageRounding": "none",
  "attackSkill": {
    "melee": "luta",
    "ranged": "pontaria",
    "firearm": "arma_de_fogo"
  },
  "opposed": {
    "winner": "lower",
    "tiePlayerWins": true,
    "maxRerolls": 10,
    "defaultReaction": {
      "melee": "luta",
      "ranged": "reflexo",
      "firearm": "reflexo"
    },
    "appliedRounding": "floor"
  },
  "powers": {
    "damageSingle": [
      3,
      6,
      9,
      12,
      15
    ],
    "damageArea": [
      6,
      9,
      12,
      15,
      18
    ],
    "areaSizes": {
      "pequena": 0,
      "media": 3,
      "grande": 6,
      "enorme": 9
    },
    "extraDieCost": 3,
    "heal": [
      3,
      6,
      9,
      12,
      15
    ],
    "healArea": {
      "alvo": 0,
      "pequena": 6,
      "media": 9,
      "grande": 12,
      "enorme": 15
    },
    "healContinuous": [
      2,
      3,
      4,
      5,
      6
    ],
    "shield": [
      3,
      6,
      9,
      12,
      15
    ],
    "shieldDuration": {
      "1t": 0,
      "2t": 2,
      "3t": 4,
      "cena": 6
    },
    "conditions": {
      "leve": {
        "initial": 3,
        "perTurn": 1
      },
      "moderada": {
        "initial": 6,
        "perTurn": 2
      },
      "forte": {
        "initial": 9,
        "perTurn": 3
      },
      "severa": {
        "initial": 12,
        "perTurn": 4
      },
      "extrema": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "buffs": {
      "teste_1": {
        "initial": 3,
        "perTurn": 1
      },
      "teste_2": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_1": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_2": {
        "initial": 9,
        "perTurn": 3
      },
      "acao": {
        "initial": 12,
        "perTurn": 4
      },
      "grande": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "levelTable": [
      {
        "level": 1,
        "maxPc": 15,
        "maxExtraDice": 1
      },
      {
        "level": 2,
        "maxPc": 18,
        "maxExtraDice": 1
      },
      {
        "level": 4,
        "maxPc": 24,
        "maxExtraDice": 2
      },
      {
        "level": 6,
        "maxPc": 30,
        "maxExtraDice": 3
      },
      {
        "level": 8,
        "maxPc": 36,
        "maxExtraDice": 4
      },
      {
        "level": 10,
        "maxPc": 42,
        "maxExtraDice": 5
      },
      {
        "level": 15,
        "maxPc": 57,
        "maxExtraDice": 7
      },
      {
        "level": 20,
        "maxPc": 72,
        "maxExtraDice": 10
      }
    ],
    "limitMode": "linear",
    "perTurnCountsTowardLimit": false,
    "amaldicoadoRounding": "ceil",
    "amaldicoadoLimitUsesFullCost": true
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

-- ---------------------------------------------------------------------
-- PV máximo da forma — mesma conta do motor (buildSheet):
-- (FOR + CON) ÷ 3 para baixo + bônus de classe + ganhos de nível ativos + outros bônus.
-- ---------------------------------------------------------------------
create or replace function public.form_pv_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  str int;
  con int;
  base int;
  gains int;
begin
  select cf.id, cf.kind, cf.pv_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into str
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'FOR';
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into con
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'CON';
  str := coalesce(str, 0) + coalesce((cls -> 'attributeBonus' ->> 'FOR')::int, 0);
  con := coalesce(con, 0) + coalesce((cls -> 'attributeBonus' ->> 'CON')::int, 0);
  if cfg ->> 'pvFormula' = 'sum_div3' then
    base := floor((str + con)::numeric / 3)::int;
  else
    base := str + floor(con::numeric / 3)::int;
  end if;
  base := base + coalesce((cls ->> 'pvBonusAtLevel1')::int, 0);
  select coalesce(sum(lp.pv_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, base + gains + f.pv_other_bonus);
end $$;

-- PC máximo da forma — mesma conta do motor: VIG ÷ 3 para baixo + ganhos de nível ativos + outros bônus.
create or replace function public.form_pc_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  vig int;
  gains int;
begin
  select cf.id, cf.kind, cf.pc_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into vig
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'VIG';
  vig := coalesce(vig, 0) + coalesce((cls -> 'attributeBonus' ->> 'VIG')::int, 0);
  select coalesce(sum(lp.pc_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, floor(vig::numeric / 3)::int + gains + f.pc_other_bonus);
end $$;

-- ---------------------------------------------------------------------
-- Vagas de habilidades — mesma conta do motor (abilities.ts).
-- mode: standard | free (Elo) | none (Muto). Executa com as permissões de quem chama.
-- ---------------------------------------------------------------------
create or replace function public.ability_granted(p_origin text, p_path text, p_level int) returns int
language plpgsql immutable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ov jsonb := cfg -> 'pathOverrides' -> (p_origin || ':' || p_path);
begin
  if coalesce(cfg -> 'originModes' ->> p_origin, 'standard') <> 'standard' then
    return 0;
  end if;
  return coalesce((ov ->> 'base')::int, (cfg ->> 'base')::int)
       + coalesce((ov ->> 'perEvenLevel')::int, (cfg ->> 'perEvenLevel')::int) * (greatest(p_level, 1) / 2);
end $$;

create or replace function public.ability_status(p_character uuid) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ch record;
  created int;
begin
  select level, origin_id, origin_path_id into ch from public.characters where id = p_character;
  -- Técnicas oficiais do Arsenal e poderes criados ocupam o mesmo conjunto de vagas (sem consumo duplicado).
  select (select count(*) from public.powers where character_id = p_character)
       + (select count(*) from public.character_techniques where character_id = p_character)
    into created;
  return jsonb_build_object(
    'mode', coalesce(cfg -> 'originModes' ->> ch.origin_id, 'standard'),
    'granted', public.ability_granted(ch.origin_id, ch.origin_path_id, ch.level),
    'created', created,
    'level', ch.level);
end $$;

grant execute on function public.rules_config() to authenticated;
grant execute on function public.form_pv_max(uuid), public.form_pc_max(uuid), public.ability_granted(text, text, int), public.ability_status(uuid) to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;


-- =====================================================================
-- >>> 20261028000100_v6_1_menor_vence.sql
-- =====================================================================
-- =====================================================================
-- F.R.A.N.C.E — VERSÃO 6.1: correção da regra de combate.
-- No confronto de rolagens opostas, vence quem tirar o MENOR d100.
-- A regra vem de public.rules_config() (atualizada por 20261028000000_rules_sync_v6_1.sql);
-- aqui só o valor padrão de segurança da função passa a ser "menor vence".
-- Desempates, classificação (menor é melhor) e multiplicadores não mudam.
-- Não apaga dados; confrontos já registrados ficam como estão. Pode ser reaplicada.
-- =====================================================================
create or replace function public.confront_outcome(p_attack int, p_defend int, p_att_skill int, p_def_skill int,
                                                   p_att_player boolean, p_def_player boolean, p_modifier int default 0)
returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  higher boolean := coalesce(cfg -> 'opposed' ->> 'winner', 'lower') = 'higher';
  quality text := public.classify_d100(p_attack, p_att_skill, p_modifier);
  dquality text := public.classify_d100(p_defend, p_def_skill, 0);
  winner text;
  tie text := 'none';
  mult numeric := 0;
begin
  if p_attack <> p_defend then
    winner := case when (p_attack > p_defend) = higher then 'attacker' else 'defender' end;
  elsif coalesce((cfg -> 'opposed' ->> 'tiePlayerWins')::boolean, true) and p_att_player is distinct from p_def_player then
    winner := case when p_att_player then 'attacker' else 'defender' end;
    tie := 'player';
  elsif coalesce(p_att_skill, 0) <> coalesce(p_def_skill, 0) then
    winner := case when coalesce(p_att_skill, 0) > coalesce(p_def_skill, 0) then 'attacker' else 'defender' end;
    tie := 'skill';
  else
    winner := 'reroll';
    tie := 'reroll';
  end if;
  if winner = 'attacker' then
    mult := case quality when 'critical_success' then (cfg -> 'damageMultiplier' ->> 'critical')::numeric
                         when 'extreme' then (cfg -> 'damageMultiplier' ->> 'extreme')::numeric else 1 end;
  end if;
  return jsonb_build_object('winner', winner, 'tie_break', tie, 'quality', quality, 'defender_quality', dquality, 'multiplier', mult);
end $$;
grant execute on function public.confront_outcome(int, int, int, int, boolean, boolean, int) to authenticated;

-- Conferência: deve devolver "attacker" (10 é menor que 90).
do $$ begin
  if public.confront_outcome(10, 90, 50, 50, false, false, 0) ->> 'winner' <> 'attacker' then
    raise exception 'Regra do confronto não atualizada: aplique antes 20261028000000_rules_sync_v6_1.sql.';
  end if;
end $$;
