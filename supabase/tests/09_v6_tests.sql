-- Testes da versão 6.0: combate por rolagens opostas, desempates, granadas, kit do Demolidor, fotos no grupo.
-- Rodam depois de 01–08 (usam a campanha, os usuários e os personagens criados lá).
\set ON_ERROR_STOP on

create or replace function pg_temp.act(u text) returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', case u when 'A' then '00000000-0000-0000-0000-00000000000a'
    when 'B' then '00000000-0000-0000-0000-00000000000b' when 'C' then '00000000-0000-0000-0000-00000000000c'
    when 'D' then '00000000-0000-0000-0000-00000000000d' else '' end, false);
end $$;

-- =====================================================================
-- 1. Regras puras do confronto (iguais ao motor; a paridade completa está em 08)
-- =====================================================================
reset role;
do $$
declare r jsonb;
begin
  -- maior d100 vence
  r := public.confront_outcome(70, 30, 50, 50, false, false, 0);
  assert r ->> 'winner' = 'attacker', 'maior resultado vence (atacante)';
  r := public.confront_outcome(30, 70, 50, 50, false, false, 0);
  assert r ->> 'winner' = 'defender', 'maior resultado vence (defensor)';
  -- qualidade separada do vencedor: 70 contra perícia 50 = falha de qualidade, mas acerta com dano padrão
  r := public.confront_outcome(70, 30, 50, 50, false, false, 0);
  assert r ->> 'quality' = 'failure' and (r ->> 'multiplier')::numeric = 1, 'venceu: dano padrão mesmo com qualidade baixa';
  -- extremo ×1,5 só quando vence
  r := public.confront_outcome(9, 5, 50, 50, false, false, 0);
  assert r ->> 'quality' = 'extreme' and (r ->> 'multiplier')::numeric = 1.5, 'extremo ×1,5 ao vencer';
  r := public.confront_outcome(9, 40, 50, 50, false, false, 0);
  assert r ->> 'winner' = 'defender' and (r ->> 'multiplier')::numeric = 0, 'perdeu: sem dano';
  -- empates
  r := public.confront_outcome(40, 40, 10, 90, true, false, 0);
  assert r ->> 'winner' = 'attacker' and r ->> 'tie_break' = 'player', 'empate: jogador atacando vence o NPC';
  r := public.confront_outcome(40, 40, 90, 10, false, true, 0);
  assert r ->> 'winner' = 'defender' and r ->> 'tie_break' = 'player', 'empate: jogador defendendo vence o NPC';
  r := public.confront_outcome(40, 40, 60, 55, true, true, 0);
  assert r ->> 'winner' = 'attacker' and r ->> 'tie_break' = 'skill', 'PvP: maior perícia vence o empate';
  r := public.confront_outcome(40, 40, 55, 55, false, false, 0);
  assert r ->> 'winner' = 'reroll', 'mesma perícia: nova rolagem';
  -- resultado 1 (só vence no empate): ×2, sem acumular com extremo
  r := public.confront_outcome(1, 1, 50, 50, true, false, 0);
  assert r ->> 'quality' = 'critical_success' and (r ->> 'multiplier')::numeric = 2, 'crítico ×2';
end $$;

-- =====================================================================
-- 2. Confrontos no combate (dados rolados no banco)
-- =====================================================================
set role authenticated;
select pg_temp.act('A');
do $$
declare cb uuid; b uuid; c uuid; m uuid; cmb public.combats; r jsonb; pv_before int; pv_after int; n int;
begin
  insert into public.combats (id, campaign_id, name, status) values ('90000000-0000-0000-0000-000000000001', '41000000-0000-0000-0000-000000000001', 'Confrontos v6', 'paused') returning id into cb;
  insert into public.combatants (id, combat_id, character_id, name, sort_order) values ('90000000-0000-0000-0000-0000000000b1', cb, '40000000-0000-0000-0000-000000000001', 'Arsenal', 0) returning id into b;
  insert into public.combatants (id, combat_id, character_id, name, sort_order) values ('90000000-0000-0000-0000-0000000000c1', cb, '40000000-0000-0000-0000-000000000002', 'Tank C', 1) returning id into c;
  insert into public.combatants (id, combat_id, kind, name, sort_order, pv_max, pv_current, data)
  values ('90000000-0000-0000-0000-0000000000e1', cb, 'monstro', 'Lobisomem', 2, 300, 300,
          '{"skills":[{"id":"luta","value":70},{"id":"reflexo","value":40}],"attacks":[{"id":"g","name":"Garras","uses":"skill:luta","damage":"2d6"}]}')
  returning id into m;
  insert into public.combatants (id, combat_id, kind, name, sort_order, pv_max, pv_current, hidden) values ('90000000-0000-0000-0000-0000000000f1', cb, 'monstro', 'Espreitador', 3, 20, 20, true);
  select * into cmb from public.combats where id = cb;
  cmb := public.combat_control(cb, 'start', cmb.version);

  -- Mestre: monstro ataca o jogador, com dano aplicado ao vencer
  select pv_current into pv_before from public.character_forms where character_id = '40000000-0000-0000-0000-000000000001' and kind = 'base';
  r := public.combat_confront(cb, m, b, '{"label":"Garras","skill":"luta","damage":"2d6","attack_kind":"melee"}', null, 'a9000000-0000-0000-0000-000000000001', true, true);
  assert (r ->> 'attack_roll')::int between 1 and 100 and (r ->> 'defend_roll')::int between 1 and 100, 'dois d100 rolados no banco';
  assert r ->> 'reaction_skill' = 'luta', 'reação automática corpo a corpo: Luta';
  assert (r ->> 'attack_value')::int = 70, 'perícia do monstro vem da ficha copiada';
  select pv_current into pv_after from public.character_forms where character_id = '40000000-0000-0000-0000-000000000001' and kind = 'base';
  if r ->> 'winner' = 'attacker' then
    assert pv_after = greatest(pv_before - (r ->> 'applied_damage')::int, 0) and (r ->> 'applied')::boolean, 'dano aplicado uma vez ao vencer';
  else
    assert pv_after = pv_before and (r ->> 'final_damage')::numeric = 0, 'defendido: sem dano';
  end if;
  -- idempotência
  r := public.combat_confront(cb, m, b, '{"label":"Garras","skill":"luta","damage":"2d6"}', null, 'a9000000-0000-0000-0000-000000000001', true, true);
  assert (r ->> 'duplicate')::boolean, 'mesmo pedido não rola de novo';
  select count(*) into n from public.combat_confrontations where request_id = 'a9000000-0000-0000-0000-000000000001';
  assert n = 1, 'um registro por pedido';
  assert exists (select 1 from public.combat_log where combat_id = cb and kind = 'confronto'), 'confronto no histórico';
  -- NPC × NPC e reação escolhida
  r := public.combat_confront(cb, m, '90000000-0000-0000-0000-0000000000f1', '{"label":"Garras","skill":"luta","damage":"2d6"}', 'reflexo', 'a9000000-0000-0000-0000-000000000002', false, true);
  assert r ->> 'reaction_skill' = 'reflexo' and not (r ->> 'public')::boolean, 'reação escolhida; alvo oculto não vai para os jogadores';
end $$;

-- Jogador ataca com o próprio personagem: dano fica para o Mestre confirmar
select pg_temp.act('B');
do $$
declare r jsonb; v int;
begin
  r := public.combat_confront('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000b1', '90000000-0000-0000-0000-0000000000e1',
        '{"label":"Faca","skill":"luta","damage":"1d4","attack_kind":"melee","value":999,"modifier":-500,"factor":50}', null, 'b9000000-0000-0000-0000-000000000001', true, true);
  assert not (r ->> 'applied')::boolean, 'jogador não aplica dano sozinho';
  assert (r ->> 'by_player')::boolean, 'marcado como ataque de jogador';
  assert (r ->> 'attack_value')::int <> 999, 'valor da perícia calculado no banco (não aceita o enviado)';
  assert (r ->> 'reaction_skill') = 'luta', 'reação padrão';
  begin
    perform public.combat_confront('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000c1', '90000000-0000-0000-0000-0000000000e1', '{"label":"x","skill":"luta"}', null, 'b9000000-0000-0000-0000-000000000002', false, true);
    assert false, 'não ataca com o personagem de outro jogador';
  exception when raise_exception then null; end;
  begin
    perform public.combat_confront('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000b1', '90000000-0000-0000-0000-0000000000f1', '{"label":"x","skill":"luta"}', null, 'b9000000-0000-0000-0000-000000000003', false, true);
    assert false, 'não ataca alvo oculto';
  exception when raise_exception then null; end;
  begin
    insert into public.combat_confrontations (combat_id, attacker_name, defender_name, attack_roll, defend_roll, winner, quality, defender_quality, request_id)
    values ('90000000-0000-0000-0000-000000000001', 'x', 'y', 100, 1, 'attacker', 'extreme', 'failure', gen_random_uuid());
    assert false, 'ninguém grava confronto direto (resultados não são manipuláveis)';
  exception when insufficient_privilege then null; end;
  begin
    perform public.combat_confront_apply((r ->> 'id')::uuid);
    assert false, 'jogador não confirma o próprio dano';
  exception when raise_exception then null; end;
  assert exists (select 1 from public.combat_confrontations where request_id = 'b9000000-0000-0000-0000-000000000001'), 'jogador vê o confronto público';
  assert not exists (select 1 from public.combat_confrontations where request_id = 'a9000000-0000-0000-0000-000000000002'), 'jogador não vê confronto oculto';
  perform set_config('test.c1', r ->> 'id', false);
  perform set_config('test.c1win', r ->> 'winner', false);
  perform set_config('test.c1dmg', r ->> 'applied_damage', false);
end $$;
select pg_temp.act('A');
do $$
declare r jsonb; pv0 int; pv1 int;
begin
  select pv_current into pv0 from public.combatants where id = '90000000-0000-0000-0000-0000000000e1';
  if current_setting('test.c1win') = 'attacker' and current_setting('test.c1dmg')::int > 0 then
    r := public.combat_confront_apply(current_setting('test.c1')::uuid);
    r := public.combat_confront_apply(current_setting('test.c1')::uuid);
    assert (r ->> 'duplicate')::boolean, 'confirmar duas vezes não aplica duas vezes';
    select pv_current into pv1 from public.combatants where id = '90000000-0000-0000-0000-0000000000e1';
    assert pv1 = pv0 - current_setting('test.c1dmg')::int, 'Mestre aplicou o dano do jogador';
  else
    begin
      perform public.combat_confront_apply(current_setting('test.c1')::uuid);
      assert false, 'sem dano para aplicar quando o ataque foi defendido';
    exception when raise_exception then null; end;
  end if;
end $$;

-- =====================================================================
-- 3. Granadas
-- =====================================================================
select pg_temp.act('B');
do $$
declare it uuid; smoke uuid; r jsonb; q int; n int;
begin
  insert into public.items (character_id, source_kind, source_ref, name, item_type, quantity, effect_kind, effect_dice)
  values ('40000000-0000-0000-0000-000000000001', 'catalog', 'granada_incendiaria', 'Granada Incendiária', 'consumivel', 2, 'dano', '2d6') returning id into it;
  insert into public.items (character_id, source_kind, source_ref, name, item_type, quantity, effect_kind)
  values ('40000000-0000-0000-0000-000000000001', 'catalog', 'granada_fumaca', 'Granada de Fumaça', 'consumivel', 1, 'utilidade') returning id into smoke;
  r := public.combat_use_grenade('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000b1', it,
        array['90000000-0000-0000-0000-0000000000e1', '90000000-0000-0000-0000-0000000000c1']::uuid[], 'c9000000-0000-0000-0000-000000000001');
  assert (r ->> 'quantity')::int = 1, 'granada descontada';
  assert jsonb_array_length(r -> 'confronts') = 2, 'um confronto por alvo na área';
  assert (r -> 'confronts' -> 0 ->> 'attack_skill') = 'pontaria' and (r -> 'confronts' -> 0 ->> 'reaction_skill') = 'reflexo', 'Pontaria × Reflexo';
  r := public.combat_use_grenade('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000b1', it,
        array['90000000-0000-0000-0000-0000000000e1']::uuid[], 'c9000000-0000-0000-0000-000000000001');
  assert (r ->> 'duplicate')::boolean, 'mesmo lançamento não desconta de novo';
  select quantity into q from public.items where id = it;
  assert q = 1, 'quantidade preservada no clique repetido';
  r := public.combat_use_grenade('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000b1', it, array['90000000-0000-0000-0000-0000000000e1']::uuid[], 'c9000000-0000-0000-0000-000000000002');
  begin
    perform public.combat_use_grenade('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000b1', it, array['90000000-0000-0000-0000-0000000000e1']::uuid[], 'c9000000-0000-0000-0000-000000000003');
    assert false, 'sem granadas: recusado';
  exception when raise_exception then null; end;
  -- Fumaça: sem alvo, cobertura em quem lançou
  r := public.combat_use_grenade('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000b1', smoke, '{}'::uuid[], 'c9000000-0000-0000-0000-000000000004');
  assert exists (select 1 from public.character_forms cf, jsonb_array_elements(cf.conditions) x
                 where cf.character_id = '40000000-0000-0000-0000-000000000001' and cf.kind = 'base' and x ->> 'name' = 'Cobertura de fumaça' and (x ->> 'turns')::int = 3), 'fumaça: cobertura por 3 turnos';
  begin
    perform public.combat_use_grenade('90000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-0000000000c1',
      (select id from public.items where character_id = '40000000-0000-0000-0000-000000000001' limit 1), '{}'::uuid[], 'c9000000-0000-0000-0000-000000000005');
    assert false, 'não lança granada de outro personagem';
  exception when raise_exception then null; end;
end $$;
-- Mestre confirma a incendiária: dano + condição contínua; o fim do turno rola o dano contínuo
select pg_temp.act('A');
do $$
declare r public.combat_confrontations; cb public.combatants; pv0 int; pv1 int; n_applied int := 0;
begin
  for r in select * from public.combat_confrontations where label = 'Granada Incendiária' and defender_id = '90000000-0000-0000-0000-0000000000e1' and winner = 'attacker' and not applied loop
    perform public.combat_confront_apply(r.id);
    n_applied := n_applied + 1;
  end loop;
  if n_applied > 0 then
    assert exists (select 1 from public.combatants, jsonb_array_elements(conditions) x
                   where id = '90000000-0000-0000-0000-0000000000e1' and x ->> 'name' = 'Em chamas' and x ->> 'dot' = '1d6'), 'incendiária: Em chamas com 1d6 por turno';
  end if;
  perform set_config('test.burn', n_applied::text, false);
end $$;
reset role;
do $$
declare cb public.combatants; pv0 int; pv1 int;
begin
  if current_setting('test.burn')::int > 0 then
    select * into cb from public.combatants where id = '90000000-0000-0000-0000-0000000000e1';
    pv0 := cb.pv_current;
    perform public.combat_tick_conditions('90000000-0000-0000-0000-000000000001', cb);
    select pv_current into pv1 from public.combatants where id = cb.id;
    assert pv1 < pv0 and pv1 >= pv0 - 6 * current_setting('test.burn')::int, 'dano contínuo rolado no fim do turno';
    assert exists (select 1 from public.combatants, jsonb_array_elements(conditions) x where id = cb.id and x ->> 'name' = 'Em chamas' and (x ->> 'turns')::int = 1), 'duração diminui';
  end if;
end $$;

-- =====================================================================
-- 4. Kit do Demolidor (uma linha por tipo, sem duplicar) e fotos no grupo
-- =====================================================================
set role authenticated;
select pg_temp.act('B');
do $$ begin
  insert into public.items (character_id, source_kind, source_ref, kit_ref, name, item_type, quantity)
  values ('50000000-0000-0000-0000-000000000001', 'catalog', 'granada_fragmentacao', 'kit:demolidor:granadas.fragmentacao', 'Granada de Fragmentação', 'consumivel', 2),
         ('50000000-0000-0000-0000-000000000001', 'catalog', 'granada_fumaca', 'kit:demolidor:granadas.fumaca', 'Granada de Fumaça', 'consumivel', 3);
  begin
    insert into public.items (character_id, source_kind, source_ref, kit_ref, name, item_type, quantity)
    values ('50000000-0000-0000-0000-000000000001', 'catalog', 'granada_fragmentacao', 'kit:demolidor:granadas.fragmentacao', 'Granada de Fragmentação', 'consumivel', 2);
    assert false, 'mesma vaga do kit não duplica';
  exception when unique_violation then null; end;
  begin
    insert into public.items (character_id, name, kit_ref) values ('50000000-0000-0000-0000-000000000001', 'x', 'kit:demolidor:granadas.frag/../');
    assert false, 'formato do kit validado';
  exception when check_violation then null; end;
end $$;
select pg_temp.act('C');
do $$ begin
  assert (select portrait_path from public.campaign_party('41000000-0000-0000-0000-000000000001') where name = 'Viktor') is not null, 'grupo traz a foto da forma ativa';
  assert exists (select 1 from storage.objects where name like 'characters/50000000-0000-0000-0000-000000000001/%'), 'colega de campanha vê a foto no grupo';
end $$;
select pg_temp.act('D');
do $$ begin
  assert not exists (select 1 from storage.objects where name like 'characters/50000000-%'), 'quem é de fora não vê';
  assert (select count(*) from public.combat_confrontations) = 0, 'quem é de fora não vê confrontos';
end $$;

reset role;
select 'TESTES DA VERSÃO 6.0 PASSARAM' as resultado;
