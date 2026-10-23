-- Testes da Fase 5: Homebrew completo, monstros em combate, fotos e Storage (rodam depois de 01–06).
\set ON_ERROR_STOP on

create or replace function pg_temp.act(u text) returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', case u when 'A' then '00000000-0000-0000-0000-00000000000a'
    when 'B' then '00000000-0000-0000-0000-00000000000b' when 'C' then '00000000-0000-0000-0000-00000000000c'
    when 'D' then '00000000-0000-0000-0000-00000000000d' else '' end, false);
end $$;

-- Preparação (administrador): usuário D (fora das campanhas), Artificial de B com as duas formas, campanha 2 (A mestre, só B).
reset role;
insert into auth.users (id, email, raw_user_meta_data) values ('00000000-0000-0000-0000-00000000000d', 'd@x.com', '{"username":"forasteiro"}');
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values
  ('50000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000b', 'Viktor', 'active', 'brawler', 'artificial', 5);
insert into public.character_forms (character_id, kind, name, setup_complete) values ('50000000-0000-0000-0000-000000000001', 'lenda', 'Mecha Viktor', true);
insert into public.campaigns (id, owner_id, name) values ('51000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-00000000000a', 'Campanha 2');
insert into public.campaign_members (campaign_id, user_id, role) values ('51000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-00000000000b', 'player')
  on conflict do nothing;
set role authenticated;

-- =====================================================================
-- 1–2. Criar e salvar um monstro no Homebrew
-- =====================================================================
select pg_temp.act('A');
do $$
declare hb uuid;
begin
  insert into public.homebrew (id, owner_id, kind, name, description, data, image_path) values (
    '52000000-0000-0000-0000-000000000001', auth.uid(), 'monstro', 'Leshy', 'Guardião da mata',
    '{"category":"Folclore","level":"Chefe","attributes":{"FOR":80,"CON":90},"skills":[{"id":"luta","value":85}],
      "pv_max":150,"pc_max":20,"defense":"15","resistances":["Cortante"],
      "attacks":[{"id":"a1","name":"Galhos","uses":"skill:luta","damage":"2d8+4","conditions":[{"name":"Imobilizado","turns":1}]}],
      "abilities":[{"id":"h1","name":"Raízes","pc_cost":5,"damage":"3d6","condition":{"name":"Lentidão","turns":2}}],
      "master_notes":"Fraco a fogo"}',
    'homebrew/00000000-0000-0000-0000-00000000000a/monstro-leshy.webp');   -- (1)
  -- (2) gravado no banco, com dados e imagem
  assert (select (data ->> 'pv_max')::int from public.homebrew where id = '52000000-0000-0000-0000-000000000001') = 150, 'monstro salvo';
  begin
    insert into public.homebrew (owner_id, kind, name, image_path) values (auth.uid(), 'monstro', 'Errado', 'homebrew/00000000-0000-0000-0000-00000000000b/x.webp');
    assert false, 'imagem na pasta de outro usuário recusada';
  exception when raise_exception then null; end;
  begin
    insert into public.homebrew (owner_id, kind, name, image_path) values (auth.uid(), 'monstro', 'Errado', 'homebrew/00000000-0000-0000-0000-00000000000a/../x.webp');
    assert false, 'caminho com ../ recusado';
  exception when raise_exception then null; end;
  insert into public.homebrew (owner_id, kind, name) values (auth.uid(), 'item_especial', 'Amuleto') returning id into hb;
  assert hb is not null, 'categoria nova (item especial)';
end $$;
select pg_temp.act('B');
do $$ begin
  assert not exists (select 1 from public.homebrew where id = '52000000-0000-0000-0000-000000000001'), 'Homebrew é privado do autor';
end $$;
select pg_temp.act('C');
insert into public.homebrew (id, owner_id, kind, name, data) values ('52000000-0000-0000-0000-0000000000c1', '00000000-0000-0000-0000-00000000000c', 'monstro', 'Monstro do C', '{"pv_max":10}');

-- =====================================================================
-- 3–6. Campanha, combate, várias cópias independentes
-- =====================================================================
select pg_temp.act('A');
do $$
declare cb uuid; l1 uuid; l2 uuid; l3 uuid; npc uuid; n int;
begin
  -- (3) NPC/monstro da campanha a partir do modelo (cópia)
  insert into public.npcs (campaign_id, source_homebrew_id, kind, name, data, pv_max, pv_current, image_path)
  select '41000000-0000-0000-0000-000000000001', id, kind, name, data, 150, 150, image_path from public.homebrew where id = '52000000-0000-0000-0000-000000000001'
  returning id into npc;
  assert npc is not null, '(3) monstro adicionado à campanha';
  begin
    update public.npcs set image_path = 'homebrew/00000000-0000-0000-0000-00000000000c/x.webp' where id = npc;
    assert false, 'NPC não aponta para imagem de outro usuário';
  exception when raise_exception then null; end;

  insert into public.combats (id, campaign_id, name, status) values ('53000000-0000-0000-0000-000000000001', '41000000-0000-0000-0000-000000000001', 'Clareira', 'paused') returning id into cb;
  -- (4)(5) três instâncias do mesmo modelo
  insert into public.combatants (combat_id, homebrew_id, kind, name, sort_order, pv_max, pv_current, pc_max, pc_current, image_path, data)
  select cb, h.id, 'monstro', 'Leshy ' || g, g, 150, 150, 20, 20, h.image_path, h.data
  from public.homebrew h, generate_series(1, 3) g where h.id = '52000000-0000-0000-0000-000000000001';
  select id into l1 from public.combatants where combat_id = cb and name = 'Leshy 1';
  select id into l2 from public.combatants where combat_id = cb and name = 'Leshy 2';
  select id into l3 from public.combatants where combat_id = cb and name = 'Leshy 3';
  assert (select count(*) from public.combatants where combat_id = cb and homebrew_id is not null) = 3, '(5) três cópias';
  begin
    insert into public.combatants (combat_id, homebrew_id, kind, name) values (cb, '52000000-0000-0000-0000-0000000000c1', 'monstro', 'Roubado');
    assert false, 'modelo de outro usuário não entra no combate';
  exception when raise_exception then null; end;

  -- (6) dano numa cópia não afeta as outras
  perform public.combat_apply(l1, 'damage', 50, 'c5000000-0000-0000-0000-000000000001');
  perform public.combat_apply(l1, 'damage', 50, 'c5000000-0000-0000-0000-000000000001'); -- mesmo pedido: não repete
  assert (select pv_current from public.combatants where id = l1) = 100, '(6) cópia 1 com 100';
  assert (select pv_current from public.combatants where id = l2) = 150 and (select pv_current from public.combatants where id = l3) = 150, '(6) cópias 2 e 3 intactas';
  perform public.combat_condition(l2, 'add', 'Lentidão', 2, null);
  assert jsonb_array_length((select conditions from public.combatants where id = l2)) = 1
     and jsonb_array_length((select conditions from public.combatants where id = l1)) = 0, 'condição só na cópia escolhida';
  assert (select (data ->> 'pv_max')::int from public.homebrew where id = '52000000-0000-0000-0000-000000000001') = 150, 'modelo não muda';
end $$;
select pg_temp.act('B');
do $$ begin
  begin
    insert into public.combatants (combat_id, homebrew_id, kind, name) values ('53000000-0000-0000-0000-000000000001', '52000000-0000-0000-0000-000000000001', 'monstro', 'X');
    assert false, 'jogador não adiciona combatentes';
  exception when insufficient_privilege then null; when raise_exception then null; end;
  assert (select count(*) from public.combatants where combat_id = '53000000-0000-0000-0000-000000000001') = 0, 'jogador não lê a tabela do Mestre';
  assert (select count(*) from public.combatants_public where combat_id = '53000000-0000-0000-0000-000000000001' and image_path like 'homebrew/%') = 3, 'jogador vê as instâncias e a imagem pela visão pública';
end $$;

-- =====================================================================
-- 7–9. Ataques, habilidades (PC), encerrar e reabrir
-- =====================================================================
select pg_temp.act('A');
do $$
declare cb uuid := '53000000-0000-0000-0000-000000000001'; l1 uuid; l2 uuid; c public.combats; r jsonb;
begin
  select id into l1 from public.combatants where combat_id = cb and name = 'Leshy 1';
  select id into l2 from public.combatants where combat_id = cb and name = 'Leshy 2';
  -- (7) a rolagem acontece no servidor (motor); o banco registra no histórico e aplica o dano no alvo escolhido
  perform public.combat_note(cb, 'ataque', 'Leshy 1 — Galhos: 12 contra 85 (Acerto bom), 14 de dano.', '{}'::jsonb, true, null);
  insert into public.roll_log (user_id, campaign_id, label, expression, result, visibility) values (auth.uid(), '41000000-0000-0000-0000-000000000001', 'Leshy 1: Galhos', '1d100 + 2d8+4', '{"kind":"attack"}', 'self');
  perform public.combat_apply(l2, 'damage', 14, 'c5000000-0000-0000-0000-000000000002');
  assert (select pv_current from public.combatants where id = l2) = 136, '(7) dano do ataque aplicado no alvo';
  assert exists (select 1 from public.combat_log where combat_id = cb and kind = 'ataque'), 'ataque no histórico';

  -- (8) habilidade: consome PC da instância, recusa sem PC suficiente, não cobra duas vezes
  r := public.combatant_spend_pc(l1, 5, 'c5000000-0000-0000-0000-000000000003', 'Raízes');
  r := public.combatant_spend_pc(l1, 5, 'c5000000-0000-0000-0000-000000000003', 'Raízes');
  assert (select pc_current from public.combatants where id = l1) = 15, '(8) PC descontado uma vez';
  assert (select pc_current from public.combatants where id = l2) = 20, 'PC das outras cópias intacto';
  begin
    perform public.combatant_spend_pc(l1, 99, 'c5000000-0000-0000-0000-000000000004', 'Grande');
    assert false, 'PC insuficiente é recusado';
  exception when raise_exception then null; end;

  -- (9) encerrar e reabrir não perde o estado; editar o modelo depois não altera o combate
  select * into c from public.combats where id = cb;
  c := public.combat_control(cb, 'start', c.version);
  c := public.combat_control(cb, 'end', c.version);
  assert c.status = 'ended', 'encerrado';
  c := public.combat_control(cb, 'reopen', c.version);
  assert (select pv_current from public.combatants where id = l1) = 100 and (select pc_current from public.combatants where id = l1) = 15, '(9) estado preservado';
  assert jsonb_array_length((select conditions from public.combatants where id = l2)) = 1, 'condições preservadas';
  update public.homebrew set data = jsonb_set(data, '{pv_max}', '999') where id = '52000000-0000-0000-0000-000000000001';
  assert (select pv_max from public.combatants where id = l1) = 150, 'editar o modelo não mexe nas instâncias';
end $$;
select pg_temp.act('B');
do $$ begin
  begin
    perform public.combatant_spend_pc((select id from public.combatants_public where name = 'Leshy 3' limit 1), 1, 'c5000000-0000-0000-0000-000000000005', 'x');
    assert false, 'jogador não usa habilidade de criatura';
  exception when raise_exception then null; end;
end $$;

-- =====================================================================
-- 10. NPCs: criar, editar, segredos
-- =====================================================================
select pg_temp.act('A');
do $$
declare hb uuid; npc uuid;
begin
  insert into public.homebrew (owner_id, kind, name, data) values (auth.uid(), 'npc', 'Dona Cida', '{"mode":"completa","age":"62","master_notes":"É a bruxa"}') returning id into hb;
  update public.homebrew set data = data || '{"personality":"Desconfiada"}' where id = hb;
  assert (select data ->> 'personality' from public.homebrew where id = hb) = 'Desconfiada', '(10) NPC editado';
  insert into public.npcs (campaign_id, kind, name, data, visible_to_players, image_path)
  values ('41000000-0000-0000-0000-000000000001', 'npc', 'Dona Cida', '{"description":"Vende ervas","master_notes":"É a bruxa"}', true, 'npcs/41000000-0000-0000-0000-000000000001/npc-cida.webp') returning id into npc;
  insert into public.npcs (campaign_id, kind, name, data, visible_to_players, image_path)
  values ('41000000-0000-0000-0000-000000000001', 'npc', 'Informante', '{}', false, 'npcs/41000000-0000-0000-0000-000000000001/npc-secreto.webp');
end $$;
select pg_temp.act('B');
do $$ begin
  begin
    update public.homebrew set name = 'Hack' where kind = 'npc';
  exception when others then null; end;
  assert not exists (select 1 from public.homebrew where name = 'Hack'), 'jogador não edita o modelo';
  assert (select count(*) from public.npcs) = 0, 'jogador não lê a tabela de NPCs (segredos)';
  assert (select description from public.npcs_public where name = 'Dona Cida') = 'Vende ervas', 'visão pública do NPC visível';
  assert not exists (select 1 from public.npcs_public where name = 'Informante'), 'NPC secreto não aparece';
end $$;

-- =====================================================================
-- 11–13. Armas, inventário e modificadores personalizados
-- =====================================================================
select pg_temp.act('A');
insert into public.homebrew (id, owner_id, kind, name, data, image_path) values
  ('52000000-0000-0000-0000-000000000011', '00000000-0000-0000-0000-00000000000a', 'arma', 'Lança de Prata', '{"attack_kind":"melee","tags":["corpo_a_corpo","perfurantes_projeteis"],"effect_dice":"1d10+2","modifiers":["equilibrada"]}',
   'homebrew/00000000-0000-0000-0000-00000000000a/arma-lanca.webp'); -- (11)
select pg_temp.act('B');
do $$
declare it uuid;
begin
  begin
    insert into public.items (character_id, name, item_type, attack_kind, effect_dice, tags, image_path)
    values ('50000000-0000-0000-0000-000000000001', 'Lança', 'arma', 'melee', '1d10+2', '{corpo_a_corpo}', 'homebrew/00000000-0000-0000-0000-00000000000a/arma-lanca.webp');
    assert false, 'não aponta para imagem de modelo que não pode ler';
  exception when raise_exception then null; end;
  -- (12) arma no inventário (cópia), com modificadores personalizados copiados
  insert into public.items (character_id, source_kind, name, item_type, attack_kind, effect_dice, tags, custom_modifiers)
  values ('50000000-0000-0000-0000-000000000001', 'homebrew', 'Lança de Prata', 'arma', 'melee', '1d10+2', '{corpo_a_corpo,perfurantes_projeteis}',
          '[{"id":"hb:x1","name":"Bento","requires":"perfurantes_projeteis","always":{"extraDamage":"1d4"}}]') returning id into it;
  assert it is not null, '(12) arma no inventário';
  -- (13) compatibilidade e limite
  begin
    update public.items set custom_modifiers = custom_modifiers || '[{"id":"hb:x2","name":"Lâmina rúnica","requires":"laminas"}]' where id = it;
    assert false, 'modificador incompatível recusado';
  exception when raise_exception then null; end;
  insert into public.item_modifiers (item_id, modifier_id) values (it, 'equilibrada');
  begin
    update public.items set custom_modifiers = custom_modifiers || '[{"id":"hb:x3","name":"Extra","requires":"qualquer"}]' where id = it;
    assert false, 'limite de 2 modificações (oficial + personalizado)';
  exception when raise_exception then null; end;
  update public.items set custom_modifiers = custom_modifiers || '[{"id":"hb:x4","name":"Bênção","requires":"qualquer","ignoreLimit":true}]' where id = it;
  assert jsonb_array_length((select custom_modifiers from public.items where id = it)) = 2, 'regra especial ultrapassa o limite';
  begin
    insert into public.item_modifiers (item_id, modifier_id) values (it, 'perfurante');
    assert false, 'oficial também respeita o limite com personalizados';
  exception when raise_exception then null; end;
  -- usos limitados
  insert into public.items (character_id, name, item_type, effect_kind, effect_dice, uses_max, uses_left) values ('50000000-0000-0000-0000-000000000001', 'Kit médico', 'equipamento', 'cura', '2d6', 2, 2) returning id into it;
  perform public.consume_item(it);
  perform public.consume_item(it);
  begin
    perform public.consume_item(it);
    assert false, 'sem usos restantes';
  exception when raise_exception then null; end;
end $$;
select pg_temp.act('C');
do $$ begin
  begin
    perform public.consume_item((select id from public.items where name = 'Kit médico' limit 1));
    assert false, 'C não usa item de B';
  exception when raise_exception then null; end;
end $$;

-- =====================================================================
-- 14–18. Fotos dos personagens (Storage + referência no banco)
-- =====================================================================
select pg_temp.act('B');
do $$
declare base uuid; lenda uuid;
begin
  select id into base from public.character_forms where character_id = '50000000-0000-0000-0000-000000000001' and kind = 'base';
  select id into lenda from public.character_forms where character_id = '50000000-0000-0000-0000-000000000001' and kind = 'lenda';
  -- (14) envio para a própria pasta
  insert into storage.objects (bucket_id, name) values ('france-media', 'characters/50000000-0000-0000-0000-000000000001/base-v1.webp');
  update public.character_forms set portrait_path = 'characters/50000000-0000-0000-0000-000000000001/base-v1.webp' where id = base;
  -- (15)(16) a ficha e o cartão leem a mesma referência
  assert (select portrait_path from public.character_forms where id = base) = 'characters/50000000-0000-0000-0000-000000000001/base-v1.webp', '(15) foto na ficha';
  assert (select cf.portrait_path from public.characters c join public.character_forms cf on cf.character_id = c.id and cf.kind = 'base'
          where c.id = '50000000-0000-0000-0000-000000000001' and c.owner_id = auth.uid()) like '%base-v1.webp', '(16) mesma foto no cartão';
  -- (17) trocar a foto: novo arquivo, referência atualizada, antigo apagado
  insert into storage.objects (bucket_id, name) values ('france-media', 'characters/50000000-0000-0000-0000-000000000001/base-v2.webp');
  update public.character_forms set portrait_path = 'characters/50000000-0000-0000-0000-000000000001/base-v2.webp' where id = base;
  delete from storage.objects where name = 'characters/50000000-0000-0000-0000-000000000001/base-v1.webp';
  assert (select portrait_path from public.character_forms where id = base) like '%base-v2.webp', '(17) foto atualizada';
  assert not exists (select 1 from storage.objects where name like '%base-v1.webp'), 'arquivo antigo removido';
  -- (18) Artificial: fotos diferentes para as duas formas
  insert into storage.objects (bucket_id, name) values ('france-media', 'characters/50000000-0000-0000-0000-000000000001/lenda-v1.webp');
  update public.character_forms set portrait_path = 'characters/50000000-0000-0000-0000-000000000001/lenda-v1.webp' where id = lenda;
  assert (select portrait_path from public.character_forms where id = lenda) like '%lenda-v1.webp'
     and (select portrait_path from public.character_forms where id = base) like '%base-v2.webp', '(18) formas com fotos independentes';
  begin
    update public.character_forms set portrait_path = 'characters/40000000-0000-0000-0000-000000000002/x.webp' where id = base;
    assert false, 'foto precisa estar na pasta do próprio personagem';
  exception when raise_exception then null; end;
end $$;
select pg_temp.act('C');
do $$ begin
  begin
    insert into storage.objects (bucket_id, name) values ('france-media', 'characters/50000000-0000-0000-0000-000000000001/base-hack.webp');
    assert false, 'outro usuário não envia foto para o personagem de B';
  exception when insufficient_privilege then null; end;
  delete from storage.objects where name like 'characters/50000000-0000-0000-0000-000000000001/%';
  update storage.objects set name = 'characters/50000000-0000-0000-0000-000000000001/base-x.webp' where name like 'characters/50000000-0000-0000-0000-000000000001/%';
  assert not exists (select 1 from storage.objects where name like 'characters/50000000-0000-0000-0000-000000000001/%'), 'C não lê nem apaga as fotos de B';
end $$;
select pg_temp.act('B');
do $$ begin
  assert (select count(*) from storage.objects where name like 'characters/50000000-0000-0000-0000-000000000001/%') = 2, 'fotos de B intactas';
end $$;

-- =====================================================================
-- 19. Compartilhar conteúdo com uma campanha
-- =====================================================================
select pg_temp.act('A');
do $$ begin
  insert into public.homebrew_shares (homebrew_id, campaign_id, shared_by) values ('52000000-0000-0000-0000-000000000011', '51000000-0000-0000-0000-000000000002', auth.uid());
  begin
    insert into public.homebrew_shares (homebrew_id, campaign_id, shared_by) values ('52000000-0000-0000-0000-000000000001', '51000000-0000-0000-0000-000000000002', auth.uid());
    assert false, 'monstro não é compartilhado com jogadores';
  exception when raise_exception then null; end;
end $$;
select pg_temp.act('B');
do $$ begin
  assert exists (select 1 from public.homebrew where id = '52000000-0000-0000-0000-000000000011'), '(19) jogador da campanha vê a arma compartilhada';
  assert not exists (select 1 from public.homebrew where id = '52000000-0000-0000-0000-000000000001'), 'o resto continua privado';
  update public.homebrew set name = 'Minha lança' where id = '52000000-0000-0000-0000-000000000011';
  assert (select name from public.homebrew where id = '52000000-0000-0000-0000-000000000011') = 'Lança de Prata', 'jogador não altera o modelo';
  insert into public.items (character_id, source_kind, source_ref, name, item_type, attack_kind, effect_dice, tags, image_path)
  values ('50000000-0000-0000-0000-000000000001', 'homebrew', '52000000-0000-0000-0000-000000000011', 'Lança de Prata', 'arma', 'melee', '1d10+2', '{corpo_a_corpo}', 'homebrew/00000000-0000-0000-0000-00000000000a/arma-lanca.webp');
  begin
    insert into public.homebrew_shares (homebrew_id, campaign_id, shared_by) values ('52000000-0000-0000-0000-000000000011', '41000000-0000-0000-0000-000000000001', auth.uid());
    assert false, 'jogador não compartilha conteúdo alheio';
  exception when raise_exception then null; when insufficient_privilege then null; end;
end $$;
select pg_temp.act('D');
do $$ begin
  assert not exists (select 1 from public.homebrew where id = '52000000-0000-0000-0000-000000000011'), 'quem não é da campanha não vê';
end $$;

-- =====================================================================
-- 20. Permissões do Storage
-- =====================================================================
reset role;
insert into storage.objects (bucket_id, name, owner) values
  ('france-media', 'homebrew/00000000-0000-0000-0000-00000000000a/monstro-leshy.webp', '00000000-0000-0000-0000-00000000000a'),
  ('france-media', 'homebrew/00000000-0000-0000-0000-00000000000a/arma-lanca.webp', '00000000-0000-0000-0000-00000000000a'),
  ('france-media', 'homebrew/00000000-0000-0000-0000-00000000000a/privado.webp', '00000000-0000-0000-0000-00000000000a'),
  ('france-media', 'npcs/41000000-0000-0000-0000-000000000001/npc-cida.webp', '00000000-0000-0000-0000-00000000000a'),
  ('france-media', 'npcs/41000000-0000-0000-0000-000000000001/npc-secreto.webp', '00000000-0000-0000-0000-00000000000a');
set role authenticated;
select pg_temp.act('A');
do $$ begin
  assert (select count(*) from storage.objects where name like 'characters/50000000-0000-0000-0000-000000000001/%') = 0, 'Mestre não vê foto de personagem fora da campanha';
  assert (select count(*) from storage.objects where name like 'npcs/41000000-%') = 2, 'Mestre lê imagens dos NPCs';
  begin
    insert into storage.objects (bucket_id, name) values ('france-media', 'npcs/51000000-0000-0000-0000-000000000002/sub/x.webp');
    assert false, 'subpastas recusadas';
  exception when insufficient_privilege then null; end;
  insert into storage.objects (bucket_id, name) values ('france-media', 'npcs/51000000-0000-0000-0000-000000000002/npc-ok.webp');
end $$;
select pg_temp.act('B');
do $$ begin
  assert exists (select 1 from storage.objects where name = 'npcs/41000000-0000-0000-0000-000000000001/npc-cida.webp'), 'jogador vê imagem de NPC visível';
  assert not exists (select 1 from storage.objects where name = 'npcs/41000000-0000-0000-0000-000000000001/npc-secreto.webp'), 'imagem de NPC secreto protegida';
  assert exists (select 1 from storage.objects where name = 'homebrew/00000000-0000-0000-0000-00000000000a/monstro-leshy.webp'), 'imagem de monstro visível no combate';
  assert exists (select 1 from storage.objects where name = 'homebrew/00000000-0000-0000-0000-00000000000a/arma-lanca.webp'), 'imagem de conteúdo compartilhado';
  assert not exists (select 1 from storage.objects where name = 'homebrew/00000000-0000-0000-0000-00000000000a/privado.webp'), 'imagem privada do Mestre protegida';
  begin
    insert into storage.objects (bucket_id, name) values ('france-media', 'npcs/41000000-0000-0000-0000-000000000001/hack.webp');
    assert false, 'jogador não envia imagem de NPC';
  exception when insufficient_privilege then null; end;
  begin
    insert into storage.objects (bucket_id, name) values ('france-media', 'homebrew/00000000-0000-0000-0000-00000000000a/hack.webp');
    assert false, 'ninguém escreve na pasta de outro autor';
  exception when insufficient_privilege then null; end;
  insert into storage.objects (bucket_id, name) values ('france-media', 'homebrew/00000000-0000-0000-0000-00000000000b/meu.webp');
end $$;
select pg_temp.act('A');
do $$ begin
  -- A é Mestre de B só em campanhas onde o personagem de B não foi vinculado: continua sem ver a foto
  assert not exists (select 1 from storage.objects where name like 'characters/50000000-%'), 'vínculo aceito é exigido';
  update public.combatants set hidden = true where name = 'Leshy 3';
end $$;
reset role;
insert into public.campaign_characters (campaign_id, character_id, added_by, status) values ('41000000-0000-0000-0000-000000000001', '50000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000b', 'accepted');
set role authenticated;
select pg_temp.act('A');
do $$ begin
  assert (select count(*) from storage.objects where name like 'characters/50000000-0000-0000-0000-000000000001/%') = 2, 'Mestre vê as fotos do personagem vinculado';
end $$;
select pg_temp.act('D');
do $$ begin
  assert (select count(*) from storage.objects) = 0, 'quem não participa não lê nada';
  begin
    insert into storage.objects (bucket_id, name) values ('outro-bucket', 'homebrew/00000000-0000-0000-0000-00000000000d/x.webp');
    assert false, 'outro bucket sem política';
  exception when insufficient_privilege then null; when foreign_key_violation then null; end;
end $$;

reset role;
select 'TESTES DA FASE 5 PASSARAM' as resultado;
