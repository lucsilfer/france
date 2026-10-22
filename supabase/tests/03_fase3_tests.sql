-- Testes da Fase 3 (rodam depois de 01 e 02, no mesmo banco).
\set ON_ERROR_STOP on

create or replace function pg_temp.act(u text) returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', case u when 'A' then '00000000-0000-0000-0000-00000000000a'
    when 'B' then '00000000-0000-0000-0000-00000000000b' when 'C' then '00000000-0000-0000-0000-00000000000c' else '' end, false);
end $$;

-- Preparação (como administrador): personagem ativo de B, FOR 80, classe Tank, origem Muto.
reset role;
insert into public.characters (id, owner_id, name, status, class_id, origin_id)
values ('33333333-3333-3333-3333-333333333333', '00000000-0000-0000-0000-00000000000b', 'Teste F3', 'active', 'tank', 'muto');
insert into public.form_attributes (form_id, attribute, base_value)
select cf.id, a.attr, a.v from public.character_forms cf,
  (values ('FOR', 80), ('DEX', 50), ('INT', 60), ('CON', 45), ('MIT', 30), ('PER', 55), ('CAR', 40), ('VIG', 70)) as a(attr, v)
where cf.character_id = '33333333-3333-3333-3333-333333333333';

set role authenticated;
select pg_temp.act('B');

-- ---------- Limite total de perícias ----------
do $$
declare f uuid;
begin
  select id into f from public.character_forms where character_id = '33333333-3333-3333-3333-333333333333' and kind = 'base';
  assert public.skill_fixed_part(f, 'luta') = 40, 'Luta base 40 com FOR 80';
  assert public.skill_fixed_part(f, 'investigacao') = 20, 'Investigação base 20';
  assert public.skill_cap(f) = 75, 'limite 75';
  insert into public.form_skills (form_id, skill_id, points) values (f, 'investigacao', 55);
  begin
    update public.form_skills set points = 56 where form_id = f and skill_id = 'investigacao';
    assert false, 'Investigação 76 deveria falhar';
  exception when raise_exception then null; end;
  insert into public.form_skills (form_id, skill_id, points) values (f, 'luta', 35);
  begin
    insert into public.form_skills (form_id, skill_id, points) values (f, 'luta', 36)
    on conflict (form_id, skill_id) do update set points = excluded.points;
    assert false, 'Luta 76 deveria falhar (upsert)';
  exception when raise_exception then null; end;
  begin
    update public.form_skills set other_bonus = 1 where form_id = f and skill_id = 'luta';
    assert false, 'bônus também conta no limite';
  exception when raise_exception then null; end;
end $$;

-- Dado antigo acima do limite: pode ser reduzido, nunca aumentado
-- (simula dado gravado antes da correção: 15 + 70 = 85)
reset role;
alter table public.form_skills disable trigger form_skills_validate;
insert into public.form_skills (form_id, skill_id, points)
select id, 'enganacao', 70 from public.character_forms where character_id = '33333333-3333-3333-3333-333333333333' and kind = 'base';
alter table public.form_skills enable trigger form_skills_validate;
set role authenticated;
select pg_temp.act('B');
do $$
declare f uuid;
begin
  select id into f from public.character_forms where character_id = '33333333-3333-3333-3333-333333333333' and kind = 'base';
  update public.form_skills set points = 65 where form_id = f and skill_id = 'enganacao'; -- 85 → 80: ainda acima, mas reduziu
  begin
    update public.form_skills set points = 66 where form_id = f and skill_id = 'enganacao';
    assert false, 'não pode aumentar perícia inválida';
  exception when raise_exception then null; end;
  update public.form_skills set points = 60 where form_id = f and skill_id = 'enganacao';
end $$;

-- Detalhista: limite 95
reset role;
update public.characters set class_id = 'detalhista' where id = '33333333-3333-3333-3333-333333333333';
set role authenticated;
select pg_temp.act('B');
do $$
declare f uuid;
begin
  select id into f from public.character_forms where character_id = '33333333-3333-3333-3333-333333333333' and kind = 'base';
  assert public.skill_cap(f) = 95, 'Detalhista: 95';
  update public.form_skills set points = 75 where form_id = f and skill_id = 'investigacao';
  begin
    update public.form_skills set points = 76 where form_id = f and skill_id = 'investigacao';
    assert false, 'Detalhista 96 deveria falhar';
  exception when raise_exception then null; end;
end $$;
reset role;
update public.characters set class_id = 'tank' where id = '33333333-3333-3333-3333-333333333333';
set role authenticated;
select pg_temp.act('B');

-- ---------- Inventário e modificadores ----------
do $$
declare it uuid; gun uuid;
begin
  insert into public.items (character_id, source_kind, source_ref, name, item_type, effect_dice, effect_kind, attack_kind, tags)
  values ('33333333-3333-3333-3333-333333333333', 'catalog', 'espada_grande', 'Espada grande', 'arma', '2d8', 'dano', 'melee', '{corpo_a_corpo,laminas,pesadas}')
  returning id into it;
  insert into public.item_modifiers (item_id, modifier_id) values (it, 'afiada'), (it, 'pesada');
  begin
    insert into public.item_modifiers (item_id, modifier_id) values (it, 'brutal');
    assert false, 'terceiro modificador deveria falhar';
  exception when raise_exception then null; end;
  begin
    insert into public.item_modifiers (item_id, modifier_id, is_temporary) values (it, 'brutal', true);
    assert false, 'temporário só para Arsenal';
  exception when raise_exception then null; end;
  insert into public.items (character_id, name, item_type, effect_dice, effect_kind, attack_kind, tags)
  values ('33333333-3333-3333-3333-333333333333', 'Revólver', 'arma', '1d12+1d6', 'dano', 'firearm', '{arma_de_fogo,distancia}')
  returning id into gun;
  begin
    insert into public.item_modifiers (item_id, modifier_id) values (gun, 'afiada');
    assert false, 'modificador de lâmina em arma de fogo deveria falhar';
  exception when raise_exception then null; end;
  insert into public.item_modifiers (item_id, modifier_id) values (gun, 'rajada');
  begin
    insert into public.items (character_id, name, effect_dice) values ('33333333-3333-3333-3333-333333333333', 'X', '1d6; drop table x');
    assert false, 'dado inválido deveria falhar';
  exception when raise_exception then null; end;
  update public.items set quick_access = true where id = it;
  assert (select quick_access from public.items where id = it), 'favorito salvo';
end $$;

-- ---------- Poderes ----------
do $$
declare p uuid; f uuid; r jsonb; e uuid;
begin
  select id into f from public.character_forms where character_id = '33333333-3333-3333-3333-333333333333' and kind = 'base';
  -- Custo enviado pelo navegador é ignorado: o banco recalcula (2d6 = 6 PC).
  insert into public.powers (character_id, name, components, initial_cost)
  values ('33333333-3333-3333-3333-333333333333', 'Chama', '[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 0)
  returning id into p;
  assert (select initial_cost from public.powers where id = p) = 6, 'custo calculado no banco';
  begin
    insert into public.powers (character_id, name, components)
    values ('33333333-3333-3333-3333-333333333333', 'Grande demais', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]');
    assert false, '18 PC no nível 1 deveria falhar';
  exception when raise_exception then null; end;
  begin
    insert into public.powers (character_id, name, components)
    values ('33333333-3333-3333-3333-333333333333', 'Dados demais', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]');
    assert false, '2 dados extras no nível 1 deveria falhar';
  exception when raise_exception then null; end;
  begin
    insert into public.powers (character_id, name, components)
    values ('33333333-3333-3333-3333-333333333333', 'Hack', '[{"type":"damage","tier":-1,"extraDice":0,"area":"alvo"}]');
    assert false, 'faixa negativa deveria falhar';
  exception when raise_exception then null; end;

  -- Uso: desconta uma vez só por request
  update public.character_forms set pc_current = 10 where id = f;
  r := public.use_power(p, f, '44444444-4444-4444-4444-444444444444');
  assert (r ->> 'pc_current')::int = 4, 'PC descontado';
  r := public.use_power(p, f, '44444444-4444-4444-4444-444444444444');
  assert (r ->> 'pc_current')::int = 4 and (r ->> 'duplicate')::boolean, 'clique repetido não desconta de novo';
  begin
    perform public.use_power(p, f, '55555555-5555-5555-5555-555555555555');
    assert false, 'PC insuficiente deveria falhar';
  exception when raise_exception then null; end;

  -- Contínuo: condição leve (3 + 1/turno), 2 turnos
  insert into public.powers (character_id, name, components)
  values ('33333333-3333-3333-3333-333333333333', 'Lentidão', '[{"type":"condition","intensity":"leve"}]') returning id into p;
  update public.character_forms set pc_current = 10 where id = f;
  r := public.use_power(p, f, '66666666-6666-6666-6666-666666666666', 2);
  e := (r ->> 'effect_id')::uuid;
  assert (r ->> 'pc_current')::int = 7 and e is not null, 'ativação cobra o custo inicial';
  r := public.advance_effect(e, '77777777-7777-7777-7777-777777777777');
  r := public.advance_effect(e, '77777777-7777-7777-7777-777777777777');
  assert (r ->> 'pc_current')::int = 6, 'turno cobrado uma vez';
  r := public.advance_effect(e, '88888888-8888-8888-8888-888888888888');
  assert (r ->> 'pc_current')::int = 5 and not (r ->> 'active')::boolean, 'acaba após os turnos';
  begin
    perform public.advance_effect(e, '99999999-9999-9999-9999-999999999999');
    assert false, 'efeito encerrado não cobra';
  exception when raise_exception then null; end;
  begin
    update public.active_effects set turns_paid = 0 where id = e;
    assert not found, 'efeitos não são editáveis diretamente';
  exception when insufficient_privilege then null; end;
end $$;

-- Amaldiçoado paga metade
reset role;
update public.characters set origin_id = 'amaldicoado' where id = '33333333-3333-3333-3333-333333333333';
set role authenticated;
select pg_temp.act('B');
do $$
begin
  assert (public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]', 1, 'amaldicoado') ->> 'initial')::int = 5, 'metade arredondada para cima';
end $$;
reset role;
update public.characters set origin_id = 'muto' where id = '33333333-3333-3333-3333-333333333333';
set role authenticated;
select pg_temp.act('B');

-- ---------- Evolução de nível ----------
do $$
declare r jsonb; f uuid; g2 int; n int;
begin
  select id into f from public.character_forms where character_id = '33333333-3333-3333-3333-333333333333' and kind = 'base';
  r := public.set_character_level('33333333-3333-3333-3333-333333333333', 5);
  assert jsonb_array_length(r -> 'created') = 4, 'níveis 2..5 resolvidos';
  select pv_gain into g2 from public.level_progressions where form_id = f and level = 2;
  assert g2 between 1 and 12, 'Tank: 1d12 de PV';
  assert (select pc_gain from public.level_progressions where form_id = f and level = 2) between 1 and 6, 'Tank: 1d6 de PC';
  r := public.set_character_level('33333333-3333-3333-3333-333333333333', 1);
  assert (select level from public.characters where id = '33333333-3333-3333-3333-333333333333') = 1, 'desceu';
  select count(*) into n from public.level_progressions where form_id = f;
  assert n = 4, 'registros preservados ao descer';
  r := public.set_character_level('33333333-3333-3333-3333-333333333333', 2);
  assert jsonb_array_length(r -> 'created') = 0, 'não rola de novo';
  assert (select pv_gain from public.level_progressions where form_id = f and level = 2) = g2, 'mesmo valor';
  begin
    insert into public.level_progressions (form_id, level, pv_dice, pv_roll, pv_gain, pc_gain) values (f, 9, '1d12', '{}', 99, 99);
    assert false, 'cliente não grava evolução';
  exception when insufficient_privilege then null; end;
end $$;

-- Prodígio: 1d12+2 de PV e nenhuma rolagem de PC
reset role;
insert into public.characters (id, owner_id, name, status, class_id, origin_id, origin_path_id)
values ('33333333-3333-3333-3333-333333333334', '00000000-0000-0000-0000-00000000000b', 'Prodígio', 'active', 'esoterico', 'prodigio', 'pacto');
set role authenticated;
select pg_temp.act('B');
do $$
declare r jsonb; row jsonb;
begin
  -- Atualização 3.5: subir exige as habilidades do nível (Pacto: regra geral, 2 no nível 1, 3 no nível 2).
  insert into public.powers (character_id, name, components) values
    ('33333333-3333-3333-3333-333333333334', 'P1', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]'),
    ('33333333-3333-3333-3333-333333333334', 'P2', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
  r := public.set_character_level('33333333-3333-3333-3333-333333333334', 2);
  insert into public.powers (character_id, name, components) values
    ('33333333-3333-3333-3333-333333333334', 'P3', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
  r := public.set_character_level('33333333-3333-3333-3333-333333333334', 3);
  for row in select * from jsonb_array_elements(r -> 'rows') loop
    assert (row ->> 'pv_gain')::int between 3 and 14, 'PV 1d12+2';
    assert (row ->> 'pc_gain')::int = 0 and row -> 'pc_roll' = 'null'::jsonb, 'sem PC';
  end loop;
end $$;

-- C não muda nível de B
select pg_temp.act('C');
do $$ begin
  begin
    perform public.set_character_level('33333333-3333-3333-3333-333333333333', 3);
    assert false, 'estranho não muda nível';
  exception when raise_exception then null; end;
end $$;

-- ---------- Ficha secundária do Artificial ----------
select pg_temp.act('B');
do $$
declare lf uuid; r public.attribute_rolls; a text; n int;
begin
  begin
    perform public.create_lenda_form('33333333-3333-3333-3333-333333333333', 'X');
    assert false, 'só Artificial tem forma Lenda';
  exception when raise_exception then null; end;
  reset role;
  update public.characters set origin_id = 'artificial' where id = '33333333-3333-3333-3333-333333333333';
  set role authenticated;
  begin
    update public.characters set active_form = 'lenda' where id = '33333333-3333-3333-3333-333333333333';
    assert false, 'não alterna antes de criar a Lenda';
  exception when raise_exception then null; end;
  lf := public.create_lenda_form('33333333-3333-3333-3333-333333333333', 'Boitatá');
  assert public.create_lenda_form('33333333-3333-3333-3333-333333333333', 'Outra') = lf, 'uma Lenda por personagem';
  begin
    insert into public.form_attributes (form_id, attribute, base_value) values (lf, 'FOR', 90);
    assert false, 'atributos da Lenda só por rolagem durante a criação';
  exception when raise_exception then null; end;
  foreach a in array array['FOR','DEX','INT','CON','MIT','PER','CAR','VIG'] loop
    r := public.roll_attribute_set(lf);
    perform public.assign_attribute_roll(r.id, a);
  end loop;
  perform public.complete_lenda_form(lf, 1, 20);
  update public.characters set active_form = 'lenda' where id = '33333333-3333-3333-3333-333333333333';
  -- Atualização 3.5: no nível 2 (Artificial, regra geral) são 3 habilidades antes de subir.
  insert into public.powers (character_id, name, components)
  values ('33333333-3333-3333-3333-333333333333', 'Terceira', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
  perform public.set_character_level('33333333-3333-3333-3333-333333333333', 3);
  select count(*) into n from public.level_progressions where form_id = lf;
  assert n = 2, 'Lenda tem progressão própria';
  -- Recursos independentes
  assert (select pv_current from public.character_forms where id = lf) = 1, 'PV próprio da Lenda';
  -- Inventário e poderes são do personagem (compartilhados)
  assert (select count(*) from public.items where character_id = '33333333-3333-3333-3333-333333333333') = 2, 'inventário compartilhado';
end $$;

reset role;
select 'TESTES DA FASE 3 PASSARAM' as resultado;
