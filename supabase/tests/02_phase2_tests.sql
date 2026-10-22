-- Testes da Fase 2 (rodam depois de 01_rls_tests.sql, no mesmo banco).
\set ON_ERROR_STOP on

create or replace function pg_temp.act(u text) returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', case u when 'A' then '00000000-0000-0000-0000-00000000000a'
    when 'B' then '00000000-0000-0000-0000-00000000000b' when 'C' then '00000000-0000-0000-0000-00000000000c' else '' end, false);
end $$;

set role authenticated;
select pg_temp.act('B');

-- Regras sincronizadas com o motor
do $$ begin
  assert (public.rules_config() -> 'attributeRoll' ->> 'multiplier')::int = 5, 'config de rolagem vinda do motor';
  assert (public.rules_config() -> 'classes' -> 'esoterico' ->> 'pc') = '1d12', 'progressão do Esotérico';
  assert jsonb_array_length(public.rules_config() -> 'skills') = 10, '10 perícias';
end $$;

-- Novo personagem completo: 8 rolagens atribuídas pelo servidor
insert into public.characters (owner_id, name) values (auth.uid(), 'Caipora');
do $$
declare f uuid; r public.attribute_rolls; a text;
begin
  select cf.id into f from public.character_forms cf join public.characters c on c.id = cf.character_id where c.name = 'Caipora';
  foreach a in array array['FOR','DEX','INT','CON','MIT','PER','CAR','VIG'] loop
    r := public.roll_attribute_set(f);
    assert array_length(r.faces, 1) = 9, '9 faces (3 × 3d6)';
    perform public.assign_attribute_roll(r.id, a);
  end loop;
  assert (select count(*) from public.form_attributes where form_id = f and base_value is not null) = 8, '8 atributos';
  begin
    perform public.roll_attribute_set(f);
    assert false, 'não deveria rolar um 9º atributo';
  exception when raise_exception then null; end;

  -- Rascunho: atributo-base não pode ser editado à mão
  begin
    update public.form_attributes set base_value = 90 where form_id = f and attribute = 'FOR';
    assert false, 'edição manual de atributo em rascunho deveria falhar';
  exception when raise_exception then null; end;
  -- Bônus "outros" pode
  update public.form_attributes set other_bonus = 2 where form_id = f and attribute = 'FOR';
end $$;

-- Identificadores de regra validados no banco
do $$ begin
  begin
    update public.characters set class_id = 'mago' where name = 'Caipora';
    assert false, 'classe inexistente deveria falhar';
  exception when raise_exception then null; end;
  begin
    update public.characters set origin_id = 'muto', origin_path_id = 'arsenal' where name = 'Caipora';
    assert false, 'caminho fora do Prodígio deveria falhar';
  exception when raise_exception then null; end;
  update public.characters set origin_id = 'prodigio', origin_path_id = 'arsenal', class_id = 'detalhista' where name = 'Caipora';
  begin
    insert into public.form_skills (form_id, skill_id, points)
    select cf.id, 'magia', 10 from public.character_forms cf join public.characters c on c.id = cf.character_id where c.name = 'Caipora';
    assert false, 'perícia inexistente deveria falhar';
  exception when raise_exception then null; end;
  insert into public.form_skills (form_id, skill_id, points)
  select cf.id, 'investigacao', 75 from public.character_forms cf join public.characters c on c.id = cf.character_id where c.name = 'Caipora';
end $$;

-- Ficha ativa: edição livre de atributos; ajuste de recurso atômico e limitado
update public.characters set status = 'active' where name = 'Caipora';
do $$
declare f uuid; v int;
begin
  select cf.id into f from public.character_forms cf join public.characters c on c.id = cf.character_id where c.name = 'Caipora';
  update public.form_attributes set base_value = 88 where form_id = f and attribute = 'FOR';
  update public.character_forms set pv_current = 10, pc_current = 5 where id = f;
  v := public.adjust_form_resource(f, 'pv', 50, 30);
  assert v = 30, 'PV limitado ao máximo';
  v := public.adjust_form_resource(f, 'pv', -100, 30);
  assert v = 0, 'PV não fica negativo';
  v := public.adjust_form_resource(f, 'pc', -2, 20);
  assert v = 3, 'PC descontado';
end $$;

-- Estranho não ajusta recursos
select pg_temp.act('C');
do $$ declare f uuid; begin
  reset role;
  select cf.id into f from public.character_forms cf join public.characters c on c.id = cf.character_id where c.name = 'Caipora';
  set role authenticated;
  begin
    perform public.adjust_form_resource(f, 'pv', 1, 99);
    assert false, 'estranho não ajusta PV';
  exception when raise_exception then null; end;
end $$;

reset role;
select 'TESTES DA FASE 2 PASSARAM' as resultado;
