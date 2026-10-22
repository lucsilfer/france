-- Testes da Atualização 3.5 (rodam depois de 01–04, no mesmo banco).
\set ON_ERROR_STOP on

create or replace function pg_temp.act(u text) returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', case u when 'A' then '00000000-0000-0000-0000-00000000000a'
    when 'B' then '00000000-0000-0000-0000-00000000000b' when 'C' then '00000000-0000-0000-0000-00000000000c' else '' end, false);
end $$;

-- Preparação (administrador): personagens ativos de B com FOR 60 / CON 45.
reset role;
insert into public.characters (id, owner_id, name, status, class_id, origin_id, origin_path_id) values
  ('35000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000b', 'Tank Amaldiçoado', 'active', 'tank', 'amaldicoado', null),
  ('35000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-00000000000b', 'Brawler Elo', 'active', 'brawler', 'elo', null),
  ('35000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-00000000000b', 'Muto', 'active', 'healer', 'muto', null),
  ('35000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-00000000000b', 'Arsenal', 'active', 'lider', 'prodigio', 'arsenal'),
  ('35000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-00000000000b', 'Rascunho', 'draft', 'healer', 'muto', null);
insert into public.form_attributes (form_id, attribute, base_value)
select cf.id, a.attr, a.v from public.character_forms cf,
  (values ('FOR', 60), ('DEX', 50), ('INT', 60), ('CON', 45), ('MIT', 30), ('PER', 55), ('CAR', 40), ('VIG', 70)) as a(attr, v)
where cf.character_id::text like '35000000-%';

-- ---------- PV = (FOR + CON) ÷ 3 ----------
do $$
declare f1 uuid; f2 uuid; f3 uuid;
begin
  select id into f1 from public.character_forms where character_id = '35000000-0000-0000-0000-000000000001';
  select id into f2 from public.character_forms where character_id = '35000000-0000-0000-0000-000000000002';
  select id into f3 from public.character_forms where character_id = '35000000-0000-0000-0000-000000000003';
  assert public.form_pv_max(f3) = 35, '(60 + 45) ÷ 3 = 35 — nunca 60 + 45÷3 = 75';
  assert public.form_pv_max(f1) = 55, 'Tank: +20 depois da divisão';
  assert public.form_pv_max(f2) = 36, 'Brawler: +4 FOR antes da divisão → (64 + 45) ÷ 3 = 36';
  -- Ganhos de nível ativos e outros bônus são preservados
  insert into public.level_progressions (form_id, level, pv_dice, pv_roll, pv_gain, pc_gain) values (f3, 2, '1d6', '{}', 5, 0), (f3, 3, '1d6', '{}', 4, 0);
  update public.character_forms set pv_other_bonus = 2 where id = f3;
  update public.characters set level = 2 where id = '35000000-0000-0000-0000-000000000003';
  assert public.form_pv_max(f3) = 35 + 5 + 2, 'só os níveis até o atual contam';
  update public.characters set level = 1 where id = '35000000-0000-0000-0000-000000000003';
  update public.character_forms set pv_other_bonus = 0 where id = f3;
  delete from public.level_progressions where form_id = f3;

  -- Personagens existentes: PV atual acima do novo máximo é reduzido, com registro; quem está abaixo não muda.
  update public.character_forms set pv_current = 95 where id = f3;   -- valor da fórmula antiga
  update public.character_forms set pv_current = 10 where id = f1;
  assert public.fix_pv_after_formula_change() >= 1, 'rotina ajustou';
  assert (select pv_current from public.character_forms where id = f3) = 35, 'PV atual limitado ao novo máximo';
  assert (select pv_current from public.character_forms where id = f1) = 10, 'PV abaixo do máximo não muda';
  assert exists (select 1 from public.pv_formula_fix_log where form_id = f3 and old_pv_current = 95 and new_pv_current = 35), 'mudança registrada';
  assert public.fix_pv_after_formula_change() = 0, 'reaplicar não muda mais nada';
end $$;

set role authenticated;
select pg_temp.act('B');

-- ---------- Vagas de habilidades e bloqueio de evolução ----------
do $$
declare st jsonb; n int;
begin
  st := public.ability_status('35000000-0000-0000-0000-000000000001');
  assert st ->> 'mode' = 'standard' and (st ->> 'granted')::int = 2 and (st ->> 'created')::int = 0, 'nível 1: 2 vagas';
  insert into public.powers (character_id, name, components)
  values ('35000000-0000-0000-0000-000000000001', 'H1', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
  begin
    perform public.set_character_level('35000000-0000-0000-0000-000000000001', 2);
    assert false, 'com 1 de 2 criadas não sobe';
  exception when raise_exception then null; end;
  insert into public.powers (character_id, name, components)
  values ('35000000-0000-0000-0000-000000000001', 'H2', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
  begin
    insert into public.powers (character_id, name, components)
    values ('35000000-0000-0000-0000-000000000001', 'H3', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
    assert false, 'sem vaga no nível 1';
  exception when raise_exception then null; end;
  begin
    perform public.set_character_level('35000000-0000-0000-0000-000000000001', 3);
    assert false, 'salto 1 → 3 ignorando o nível 2 é bloqueado';
  exception when raise_exception then null; end;
  perform public.set_character_level('35000000-0000-0000-0000-000000000001', 2);
  st := public.ability_status('35000000-0000-0000-0000-000000000001');
  assert (st ->> 'granted')::int = 3, 'nível par: +1 vaga';
  begin
    perform public.set_character_level('35000000-0000-0000-0000-000000000001', 3);
    assert false, 'nível 2 exige a terceira';
  exception when raise_exception then null; end;
  -- Editar não consome vaga; excluir devolve.
  update public.powers set name = 'H1 editada' where character_id = '35000000-0000-0000-0000-000000000001' and name = 'H1';
  insert into public.powers (character_id, name, components)
  values ('35000000-0000-0000-0000-000000000001', 'H3', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
  perform public.set_character_level('35000000-0000-0000-0000-000000000001', 3);
  delete from public.powers where character_id = '35000000-0000-0000-0000-000000000001' and name = 'H3';
  insert into public.powers (character_id, name, components)
  values ('35000000-0000-0000-0000-000000000001', 'H3b', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]');
  -- Descer nunca é bloqueado e não apaga poderes
  perform public.set_character_level('35000000-0000-0000-0000-000000000001', 1);
  select count(*) into n from public.powers where character_id = '35000000-0000-0000-0000-000000000001';
  assert n = 3, 'poderes preservados ao descer';

  -- Elo: cria à vontade e sobe sem criar
  perform public.set_character_level('35000000-0000-0000-0000-000000000002', 6);
  insert into public.powers (character_id, name, components)
  select '35000000-0000-0000-0000-000000000002', 'E' || g, '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]' from generate_series(1, 12) g;
  -- Muto: sem vagas e sem bloqueio
  assert public.ability_status('35000000-0000-0000-0000-000000000003') ->> 'mode' = 'none', 'Muto não usa o sistema';
  perform public.set_character_level('35000000-0000-0000-0000-000000000003', 4);
end $$;

-- C não consegue burlar (nem ver) a ficha de B
select pg_temp.act('C');
do $$ begin
  begin
    perform public.set_character_level('35000000-0000-0000-0000-000000000002', 7);
    assert false, 'estranho não muda nível';
  exception when raise_exception then null; end;
  assert (public.ability_status('35000000-0000-0000-0000-000000000001') ->> 'created')::int = 0, 'contagem respeita RLS';
end $$;
select pg_temp.act('B');

-- ---------- Prodígio: sem PC e sem limites ----------
do $$
declare p uuid; f uuid; r jsonb;
begin
  select id into f from public.character_forms where character_id = '35000000-0000-0000-0000-000000000004';
  assert (public.ability_status('35000000-0000-0000-0000-000000000004') ->> 'granted')::int = 0, 'Arsenal nível 1: 0 técnicas';
  perform public.set_character_level('35000000-0000-0000-0000-000000000004', 2);
  insert into public.powers (character_id, name, components)
  values ('35000000-0000-0000-0000-000000000004', 'Golpe imenso', '[{"type":"damage","tier":4,"extraDice":8,"area":"enorme"},{"type":"condition","intensity":"extrema"}]')
  returning id into p;
  assert (select initial_cost + per_turn_cost from public.powers where id = p) = 0, 'sem custo de PC';
  update public.character_forms set pc_current = 0 where id = f;
  r := public.use_power(p, f, 'a5000000-0000-0000-0000-000000000001', 2);
  assert (r ->> 'pc_current')::int = 0 and (r ->> 'effect_id') is not null, 'usa sem PC e mantém efeito contínuo';
  r := public.advance_effect((r ->> 'effect_id')::uuid, 'a5000000-0000-0000-0000-000000000002');
  assert (r ->> 'pc_current')::int = 0, 'turno sem custo';
  -- Técnica só de texto (sem efeito de dados) é aceita para Prodígio, recusada para os demais
  perform public.set_character_level('35000000-0000-0000-0000-000000000004', 3);
end $$;
do $$ begin
  begin
    insert into public.powers (character_id, name, components) values ('35000000-0000-0000-0000-000000000002', 'Vazio', '[]');
    assert false, 'sem efeito só para Prodígio';
  exception when raise_exception then null; end;
end $$;

-- ---------- Equipamento inicial ----------
do $$
declare n int;
begin
  insert into public.items (character_id, source_kind, source_ref, kit_ref, name, item_type)
  values ('35000000-0000-0000-0000-000000000001', 'catalog', 'armadura_7', 'kit:tank:armadura', 'Armadura', 'armadura');
  begin
    insert into public.items (character_id, source_kind, source_ref, kit_ref, name, item_type)
    values ('35000000-0000-0000-0000-000000000001', 'catalog', 'armadura_7', 'kit:tank:armadura', 'Armadura', 'armadura');
    assert false, 'mesma vaga não é entregue duas vezes';
  exception when unique_violation then null; end;
  -- Itens comuns continuam podendo repetir
  insert into public.items (character_id, name) values ('35000000-0000-0000-0000-000000000001', 'Corda'), ('35000000-0000-0000-0000-000000000001', 'Corda');
  select count(*) into n from public.items where character_id = '35000000-0000-0000-0000-000000000001' and name = 'Corda';
  assert n = 2, 'itens sem kit não são afetados';
  -- Trocar de classe na criação limpa as escolhas
  update public.characters set starting_kit = '{"arma_simples":"pa"}' where id = '35000000-0000-0000-0000-000000000005';
  update public.characters set class_id = 'tank' where id = '35000000-0000-0000-0000-000000000005';
  assert (select starting_kit from public.characters where id = '35000000-0000-0000-0000-000000000005') = '{}'::jsonb, 'escolhas zeradas ao trocar de classe';
end $$;

-- ---------- Configuração de velocidade das rolagens ----------
do $$ begin
  update public.profiles set roll_speed = 'instant' where id = '00000000-0000-0000-0000-00000000000b';
  assert (select roll_speed from public.profiles where id = '00000000-0000-0000-0000-00000000000b') = 'instant', 'salva a velocidade';
  begin
    update public.profiles set roll_speed = 'turbo' where id = '00000000-0000-0000-0000-00000000000b';
    assert false, 'valor inválido';
  exception when check_violation then null; end;
end $$;

reset role;
select 'TESTES DA ATUALIZAÇÃO 3.5 PASSARAM' as resultado;
