-- Testes da Fase 4: Técnicas do Arsenal, campanhas e Escudo do Mestre (rodam depois de 01–05).
\set ON_ERROR_STOP on

create or replace function pg_temp.act(u text) returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', case u when 'A' then '00000000-0000-0000-0000-00000000000a'
    when 'B' then '00000000-0000-0000-0000-00000000000b' when 'C' then '00000000-0000-0000-0000-00000000000c' else '' end, false);
end $$;

-- Preparação (administrador): Prodígio do Arsenal de B (DEX 60) e um Tank de C.
reset role;
insert into public.characters (id, owner_id, name, status, class_id, origin_id, origin_path_id, level) values
  ('40000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000b', 'Arsenal', 'active', 'lider', 'prodigio', 'arsenal', 1),
  ('40000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-00000000000c', 'Tank C', 'active', 'tank', 'muto', null, 1);
insert into public.form_attributes (form_id, attribute, base_value)
select cf.id, a.attr, a.v from public.character_forms cf,
  (values ('FOR', 60), ('DEX', 60), ('INT', 60), ('CON', 45), ('MIT', 30), ('PER', 55), ('CAR', 40), ('VIG', 70)) as a(attr, v)
where cf.character_id::text like '40000000-%';
update public.character_forms set pv_current = 30, pc_current = 10 where character_id::text like '40000000-%';

set role authenticated;

-- =====================================================================
-- 1–3. Técnicas do Arsenal
-- =====================================================================
select pg_temp.act('B');
do $$
declare st jsonb; r jsonb;
begin
  begin
    perform public.learn_technique('40000000-0000-0000-0000-000000000001', 'passos_leves');
    assert false, 'nível 1: nenhuma técnica (uma a cada nível par)';
  exception when raise_exception then null; end;
  perform public.set_character_level('40000000-0000-0000-0000-000000000001', 2);
  -- (1) aprende uma técnica oficial
  perform public.learn_technique('40000000-0000-0000-0000-000000000001', 'passos_leves');
  begin
    perform public.learn_technique('40000000-0000-0000-0000-000000000001', 'passos_leves');
    assert false, 'mesma técnica duas vezes';
  exception when raise_exception then null; end;
  st := public.ability_status('40000000-0000-0000-0000-000000000001');
  assert (st ->> 'created')::int = 1 and (st ->> 'granted')::int = 1, 'técnica ocupa a vaga do nível par';
  begin
    insert into public.powers (character_id, name, components) values ('40000000-0000-0000-0000-000000000001', 'Extra', '[]');
    assert false, 'sem consumo duplicado: poder não cabe sem vaga';
  exception when raise_exception then null; end;
  perform public.set_character_level('40000000-0000-0000-0000-000000000001', 4);
  -- (2) requisitos: Furtividade Rápida exige DEX 70+ (B tem 60)
  begin
    perform public.learn_technique('40000000-0000-0000-0000-000000000001', 'furtividade_rapida');
    assert false, 'DEX 60 não atende DEX 70+';
  exception when raise_exception then null; end;
  perform public.learn_technique('40000000-0000-0000-0000-000000000001', 'arte_desarme');
  -- Uso por cena
  r := public.use_technique('40000000-0000-0000-0000-000000000001', 'arte_desarme', 'b1000000-0000-0000-0000-000000000001');
  begin
    perform public.use_technique('40000000-0000-0000-0000-000000000001', 'arte_desarme', 'b1000000-0000-0000-0000-000000000002');
    assert false, 'uma vez por cena';
  exception when raise_exception then null; end;
  r := public.use_technique('40000000-0000-0000-0000-000000000001', 'arte_desarme', 'b1000000-0000-0000-0000-000000000001');
  assert (r ->> 'duplicate')::boolean, 'mesmo pedido não registra duas vezes';
  begin
    perform public.use_technique('40000000-0000-0000-0000-000000000001', 'passos_leves', 'b1000000-0000-0000-0000-000000000003');
    assert false, 'passiva não é usada';
  exception when raise_exception then null; end;
  perform public.advance_tracker('40000000-0000-0000-0000-000000000001', 'scene');
  perform public.use_technique('40000000-0000-0000-0000-000000000001', 'arte_desarme', 'b1000000-0000-0000-0000-000000000004');
  -- Suspensão ao descer de nível (a escolha continua salva)
  perform public.set_character_level('40000000-0000-0000-0000-000000000001', 2);
  begin
    perform public.use_technique('40000000-0000-0000-0000-000000000001', 'arte_desarme', 'b1000000-0000-0000-0000-000000000005');
    assert false, 'técnica do nível 4 suspensa no nível 2';
  exception when raise_exception then null; end;
  perform public.set_character_level('40000000-0000-0000-0000-000000000001', 4);
end $$;
-- (3) continua salva (nova transação / "recarregar a página")
do $$ begin
  assert (select count(*) from public.character_techniques where character_id = '40000000-0000-0000-0000-000000000001') = 2, 'técnicas persistidas';
end $$;
-- Outro usuário não ensina técnicas à ficha de B
select pg_temp.act('C');
do $$ begin
  begin
    perform public.learn_technique('40000000-0000-0000-0000-000000000001', 'adrenalina');
    assert false, 'C não altera a ficha de B';
  exception when raise_exception then null; end;
  begin
    insert into public.character_techniques (character_id, technique_id, learned_level) values ('40000000-0000-0000-0000-000000000002', 'adrenalina', 1);
    assert false, 'tabela só via função';
  exception when insufficient_privilege then null; end;
end $$;

-- =====================================================================
-- 4–7. Campanha, convite, vínculo, Mestre visualiza
-- =====================================================================
select pg_temp.act('A');
insert into public.campaigns (id, owner_id, name, description) values ('41000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000a', 'Noite em Osasco', 'Teste');
do $$ begin
  assert public.is_campaign_master('41000000-0000-0000-0000-000000000001'), '(4) criador é o Mestre';
end $$;
reset role;
select set_config('test.inv4', (select code from public.campaign_invites where campaign_id = '41000000-0000-0000-0000-000000000001'), false);
set role authenticated;

select pg_temp.act('A');
do $$ begin perform public.set_invite_active('41000000-0000-0000-0000-000000000001', false); end $$;
select pg_temp.act('B');
do $$ begin
  begin
    perform public.join_campaign(current_setting('test.inv4'));
    assert false, 'convite desativado não funciona';
  exception when raise_exception then null; end;
end $$;
select pg_temp.act('A');
do $$ begin perform public.set_invite_active('41000000-0000-0000-0000-000000000001', true); end $$;
select pg_temp.act('B');
do $$ declare cid uuid; begin
  cid := public.join_campaign(current_setting('test.inv4'));          -- (5)
  cid := public.join_campaign(current_setting('test.inv4'));          -- sem duplicar
  assert (select count(*) from public.campaign_members where campaign_id = cid and user_id = auth.uid()) = 1, 'entrada única';
  assert not public.is_campaign_master(cid), 'convite não dá poder de Mestre';
  insert into public.campaign_characters (campaign_id, character_id, added_by)
  values (cid, '40000000-0000-0000-0000-000000000001', auth.uid());           -- (6)
  begin
    update public.campaign_characters set status = 'accepted' where character_id = '40000000-0000-0000-0000-000000000001';
    assert false, 'jogador não se aceita sozinho';
  exception when raise_exception then null; end;
end $$;
select pg_temp.act('C');
do $$ declare cid uuid := public.join_campaign(current_setting('test.inv4')); begin
  insert into public.campaign_characters (campaign_id, character_id, added_by) values (cid, '40000000-0000-0000-0000-000000000002', auth.uid());
  begin
    insert into public.campaign_characters (campaign_id, character_id, added_by) values (cid, '40000000-0000-0000-0000-000000000001', auth.uid());
    assert false, 'C não vincula personagem de B';
  exception when insufficient_privilege then null; end;
end $$;
select pg_temp.act('A');
do $$ begin
  assert (select count(*) from public.characters where id = '40000000-0000-0000-0000-000000000001') = 0, 'pendente: Mestre não vê';
  perform public.review_campaign_character('41000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000001', true);
  perform public.review_campaign_character('41000000-0000-0000-0000-000000000001', '40000000-0000-0000-0000-000000000002', true);
  assert (select count(*) from public.characters where id::text like '40000000-%') = 2, '(7) Mestre vê as fichas aceitas';
  assert (select count(*) from public.campaign_party('41000000-0000-0000-0000-000000000001')) = 2, 'grupo da campanha';
end $$;
-- (8) Mestre altera PV (o jogador recebe pelo Realtime — aqui conferimos o dado salvo e o limite do servidor)
do $$ declare f uuid; v int; begin
  select id into f from public.character_forms where character_id = '40000000-0000-0000-0000-000000000001';
  v := public.adjust_form_resource(f, 'pv', -5, 999);
  assert v = 25, 'Mestre aplica dano';
  v := public.adjust_form_resource(f, 'pv', 500, 999);
  assert v = public.form_pv_max(f), 'cura limitada ao máximo calculado pelo banco (ignora o máximo enviado)';
  perform public.form_condition(f, 'add', 'Sangrando', 2);
  assert jsonb_array_length((select conditions from public.character_forms where id = f)) = 1, 'condição na ficha';
end $$;
select pg_temp.act('B');
do $$ begin
  assert (select jsonb_array_length(conditions) from public.character_forms where character_id = '40000000-0000-0000-0000-000000000001') = 1, 'jogador vê a condição aplicada';
  -- jogador não altera ficha de outro jogador
  update public.character_forms set pv_current = 1 where character_id = '40000000-0000-0000-0000-000000000002';
  assert not found, 'B não edita a ficha de C';
end $$;

-- =====================================================================
-- 9–13. NPC, combate, turnos, dano/cura, condições contínuas
-- =====================================================================
select pg_temp.act('A');
do $$
declare npc uuid; cb uuid; m uuid; pc1 uuid; c public.combats; r jsonb; f uuid; n int;
begin
  insert into public.npcs (campaign_id, kind, name, pv_max, pv_current) values ('41000000-0000-0000-0000-000000000001', 'monstro', 'Corpo-seco', 40, 40) returning id into npc; -- (9)
  insert into public.combats (campaign_id, name, status) values ('41000000-0000-0000-0000-000000000001', 'Ponte', 'paused') returning id into cb;
  insert into public.combatants (combat_id, npc_id, name, initiative, sort_order, pv_max, pv_current) values (cb, npc, 'Corpo-seco', 12, 1, 40, 40) returning id into m; -- (10)
  insert into public.combatants (combat_id, character_id, name, initiative, sort_order) values (cb, '40000000-0000-0000-0000-000000000001', 'Arsenal', 15, 0) returning id into pc1;
  insert into public.combatants (combat_id, name, sort_order, pv_max, pv_current, hidden) values (cb, 'Emboscador', 2, 10, 10, true);
  select * into c from public.combats where id = cb;
  c := public.combat_control(cb, 'start', c.version);
  assert c.round = 1 and c.turn_index = 0 and c.status = 'active', '(11) combate iniciado';
  begin
    perform public.combat_control(cb, 'next', c.version - 1);
    assert false, 'versão antiga é recusada (dois cliques não avançam duas vezes)';
  exception when raise_exception then null; end;
  -- (12) dano e cura
  r := public.combat_apply(m, 'damage', 15, 'c1000000-0000-0000-0000-000000000001', 'golpe');
  assert (select pv_current from public.combatants where id = m) = 25, 'dano no monstro';
  r := public.combat_apply(m, 'damage', 15, 'c1000000-0000-0000-0000-000000000001', 'golpe');
  assert (r ->> 'duplicate')::boolean and (select pv_current from public.combatants where id = m) = 25, 'sem desconto duplicado';
  r := public.combat_apply(m, 'heal', 100, 'c1000000-0000-0000-0000-000000000002');
  assert (select pv_current from public.combatants where id = m) = 40, 'cura limitada ao máximo';
  select form_id into f from public.combatants where id = pc1;
  r := public.combat_apply(pc1, 'damage', 4, 'c1000000-0000-0000-0000-000000000003');
  assert (select pv_current from public.character_forms where id = f) = public.form_pv_max(f) - 4, 'dano no personagem vai para a ficha';
  -- (13) condições com duração
  perform public.combat_condition(m, 'add', 'Lento', 1);
  select * into c from public.combats where id = cb;
  c := public.combat_control(cb, 'next', c.version);   -- sai do turno do Arsenal: Sangrando (2) → 1
  assert (select ((conditions -> 0) ->> 'turns')::int from public.character_forms where id = f) = 1, 'duração diminui no fim do turno';
  c := public.combat_control(cb, 'next', c.version);   -- sai do turno do Corpo-seco: Lento (1) expira
  assert jsonb_array_length((select conditions from public.combatants where id = m)) = 0, 'condição expira';
  c := public.combat_control(cb, 'next', c.version);   -- Emboscador → volta ao início
  assert c.round = 2 and c.turn_index = 0, 'nova rodada ao completar a ordem';
  c := public.combat_control(cb, 'prev', c.version);
  assert c.round = 1 and c.turn_index = 2, 'voltar turno';
  c := public.combat_control(cb, 'new_round', c.version);
  assert c.round = 2, 'nova rodada';
  assert exists (select 1 from public.combat_log where combat_id = cb and kind = 'damage'), 'histórico registra dano';
  c := public.combat_control(cb, 'end', c.version);
  assert c.status = 'ended', 'encerrado';
end $$;
select pg_temp.act('B');
do $$ declare cb uuid; begin
  select id into cb from public.combats where name = 'Ponte';
  assert (select count(*) from public.combatants_public where combat_id = cb) = 2, 'jogador não vê combatente oculto';
  assert (select count(*) from public.combatants where combat_id = cb) = 0, 'jogador não lê a tabela do Mestre';
  assert not exists (select 1 from public.combat_log where combat_id = cb and message like '%Emboscador%'), 'histórico oculto não vaza';
  begin
    perform public.combat_control(cb, 'reopen', 0);
    assert false, 'jogador não controla combate';
  exception when raise_exception then null; end;
end $$;

-- =====================================================================
-- 14–17. Investigação e pistas
-- =====================================================================
select pg_temp.act('A');
do $$ declare inv uuid; begin
  insert into public.investigations (campaign_id, title, description, location, status) values ('41000000-0000-0000-0000-000000000001', 'O caso da ponte', 'x', 'Centro', 'aberta') returning id into inv; -- (14)
  insert into public.investigation_secrets (investigation_id, master_notes) values (inv, 'O culpado é o padeiro');
  insert into public.clues (investigation_id, title, content) values (inv, 'Pegada F4', 'Pegada de bota'), (inv, 'Bilhete F4', 'Encontro às 3h');
  insert into public.investigation_nodes (investigation_id, kind, label, x, y) values (inv, 'place', 'Ponte', 10, 20);
end $$;
select pg_temp.act('B');
do $$ begin
  assert (select count(*) from public.clues where title in ('Pegada F4', 'Bilhete F4')) = 0, '(15) pista secreta não aparece';
  assert not exists (select 1 from public.investigation_secrets where master_notes like '%padeiro%'), 'segredos do Mestre protegidos';
  assert not exists (select 1 from public.investigation_nodes where label = 'Ponte'), 'quadro do Mestre protegido';
  assert (select count(*) from public.revealed_clues('41000000-0000-0000-0000-000000000001')) = 0, 'função não vaza pista secreta';
end $$;
select pg_temp.act('A');
do $$ begin update public.clues set revealed = true where title = 'Pegada F4'; end $$;          -- (16)
select pg_temp.act('B');
do $$ begin
  assert (select count(*) from public.clues where title in ('Pegada F4', 'Bilhete F4')) = 1 and exists (select 1 from public.clues where title = 'Pegada F4'), '(17) jogador vê só a pista revelada';
  assert (select investigation_title from public.revealed_clues('41000000-0000-0000-0000-000000000001')) = 'Caso sigiloso', 'título do caso oculto não vaza';
end $$;
select pg_temp.act('C');
do $$ begin
  assert (select count(*) from public.revealed_clues('00000000-0000-0000-0000-000000000000')) = 0, 'outra campanha';
end $$;

-- =====================================================================
-- 18–20. Relatórios, notas e rolagens
-- =====================================================================
select pg_temp.act('A');
do $$ begin
  insert into public.reports (campaign_id, title, description, is_private) values
    ('41000000-0000-0000-0000-000000000001', 'Sessão 1', 'Pública', false),
    ('41000000-0000-0000-0000-000000000001', 'Bastidores', 'Privada', true);                                 -- (18)
  insert into public.campaign_notes (campaign_id, author_id, title, content, is_private) values
    ('41000000-0000-0000-0000-000000000001', auth.uid(), 'Plano secreto', 'Traição no ato 2', true),
    ('41000000-0000-0000-0000-000000000001', auth.uid(), 'Mapa', 'Compartilhado', false);
  perform public.roll_dice('41000000-0000-0000-0000-000000000001', '2d6+3', 'public', 'Teste público');
  perform public.roll_dice('41000000-0000-0000-0000-000000000001', '1d100', 'self', 'Segredo do Mestre');
end $$;
select pg_temp.act('B');
do $$ declare r public.roll_log; begin
  assert (select count(*) from public.reports where campaign_id = '41000000-0000-0000-0000-000000000001') = 1, 'relatório privado protegido';
  assert (select count(*) from public.campaign_notes where campaign_id = '41000000-0000-0000-0000-000000000001') = 1, '(19) nota privada protegida';
  update public.campaign_notes set content = 'hack' where title = 'Mapa';
  assert not found, 'jogador não edita notas';
  assert not exists (select 1 from public.roll_log where label = 'Segredo do Mestre'), '(20) rolagem privada do Mestre protegida';
  assert exists (select 1 from public.roll_log where label = 'Teste público'), 'rolagem pública visível';
  r := public.roll_dice('41000000-0000-0000-0000-000000000001', '2d12+1d6', 'master', 'Privada do jogador');
  assert (r.result ->> 'total')::int between 3 and 30, 'expressão composta rolada no banco';
  begin
    perform public.roll_dice('41000000-0000-0000-0000-000000000001', '2d6; drop table x', 'public', 'x');
    assert false, 'expressão inválida recusada';
  exception when raise_exception then null; end;
end $$;
select pg_temp.act('A');
do $$ begin
  assert exists (select 1 from public.roll_log where label = 'Privada do jogador'), 'Mestre vê a privada do jogador';
end $$;
select pg_temp.act('C');
do $$ begin
  assert not exists (select 1 from public.roll_log where label = 'Privada do jogador'), 'outro jogador não vê a privada';
  begin
    perform public.roll_dice('00000000-0000-0000-0000-000000000000', '1d6', 'public', 'x');
    assert false, 'não membro não rola';
  exception when raise_exception then null; end;
end $$;

reset role;
select 'TESTES DA FASE 4 PASSARAM' as resultado;
