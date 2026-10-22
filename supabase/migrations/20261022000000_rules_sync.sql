-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
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
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6"
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6"
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8"
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12"
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8"
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8"
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10"
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6"
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8"
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
      "pc": null
    }
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

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  return new;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

grant execute on function public.rules_config() to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
