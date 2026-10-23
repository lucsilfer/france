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
