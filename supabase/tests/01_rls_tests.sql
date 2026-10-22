-- Testes de permissões (RLS) e funções. Rodar após o shim e a migração.
\set ON_ERROR_STOP on

-- Usuários: A = Mestre, B = Jogador, C = estranho
insert into auth.users (id, email, raw_user_meta_data) values
  ('00000000-0000-0000-0000-00000000000a', 'a@x.com', '{"username":"mestre_a"}'),
  ('00000000-0000-0000-0000-00000000000b', 'b@x.com', '{"username":"jogador b!"}'),
  ('00000000-0000-0000-0000-00000000000c', 'c@x.com', '{"username":"mestre_a"}');

do $$ begin
  assert (select username::text from public.profiles where id = '00000000-0000-0000-0000-00000000000b') = 'jogadorb', 'username sanitizado';
  assert (select username::text from public.profiles where id = '00000000-0000-0000-0000-00000000000c') = 'mestre_a1', 'username duplicado recebe sufixo';
end $$;

create or replace function pg_temp.act(u text) returns void language plpgsql as $$
begin
  perform set_config('request.jwt.claim.sub', case u when 'A' then '00000000-0000-0000-0000-00000000000a'
    when 'B' then '00000000-0000-0000-0000-00000000000b' when 'C' then '00000000-0000-0000-0000-00000000000c' else '' end, false);
end $$;

-- ---------- Personagens ----------
set role authenticated;
select pg_temp.act('B');
insert into public.characters (owner_id, name) values ('00000000-0000-0000-0000-00000000000b', 'Iara') ;
do $$ begin
  assert (select count(*) from public.characters) = 1, 'B vê o próprio personagem';
  assert (select count(*) from public.character_forms) = 1, 'forma base criada automaticamente';
end $$;

-- Rolagem no servidor é estável (recarregar não rola de novo)
do $$
declare f uuid; r1 public.attribute_rolls; r2 public.attribute_rolls;
begin
  select id into f from public.character_forms limit 1;
  r1 := public.roll_attribute_set(f);
  r2 := public.roll_attribute_set(f);
  assert r1.id = r2.id, 'rolagem pendente reaproveitada';
  assert r1.best between 15 and 90 and r1.best % 5 = 0, 'valor 3d6x5';
  assert r1.best = (select max(x) from unnest(r1.results) x), 'maior destacado';
  perform public.assign_attribute_roll(r1.id, 'FOR');
  begin
    perform public.assign_attribute_roll(r1.id, 'DEX');
    assert false, 'reutilizar rolagem deveria falhar';
  exception when raise_exception then null; end;
  r2 := public.roll_attribute_set(f);
  assert r2.id <> r1.id, 'nova rolagem após atribuir';
  begin
    perform public.assign_attribute_roll(r2.id, 'FOR');
    assert false, 'atributo já preenchido deveria falhar';
  exception when raise_exception then null; end;
  assert (select base_value from public.form_attributes where form_id = f and attribute = 'FOR') = r1.best, 'valor gravado';
end $$;

-- Cliente não consegue inserir rolagem forjada
do $$ begin
  begin
    insert into public.attribute_rolls (form_id, faces, results, best)
    select id, '{6,6,6}', '{90,90,90}', 90 from public.character_forms limit 1;
    assert false, 'insert direto em attribute_rolls deveria ser bloqueado';
  exception when insufficient_privilege then null; end;
end $$;

-- Gasto de PC idempotente (spend_pc ficou restrito ao servidor na Fase 3; testado como administrador)
reset role;
do $$
declare f uuid; left_pc int;
begin
  select id into f from public.character_forms limit 1;
  update public.character_forms set pc_current = 10 where id = f;
  left_pc := public.spend_pc(f, 3, '11111111-1111-1111-1111-111111111111');
  assert left_pc = 7, 'débito';
  left_pc := public.spend_pc(f, 3, '11111111-1111-1111-1111-111111111111');
  assert left_pc = 7, 'mesmo request não debita duas vezes';
  begin
    perform public.spend_pc(f, 50, '22222222-2222-2222-2222-222222222222');
    assert false, 'PC insuficiente deveria falhar';
  exception when raise_exception then null; end;
end $$;
set role authenticated;

-- C não vê nem altera o personagem de B
select pg_temp.act('C');
do $$ begin
  assert (select count(*) from public.characters) = 0, 'C não vê personagens alheios';
  update public.characters set name = 'hack';
  assert not found, 'C não altera';
  begin
    perform public.roll_attribute_set((select id from public.character_forms limit 1));
  exception when others then null; end;
end $$;

-- ---------- Campanhas ----------
select pg_temp.act('A');
insert into public.campaigns (owner_id, name) values ('00000000-0000-0000-0000-00000000000a', 'Noite do Saci');
do $$ begin
  assert (select count(*) from public.campaign_members where role = 'master') = 1, 'criador vira Mestre';
  assert (select count(*) from public.characters) = 0, 'Mestre ainda não vê ficha de B';
end $$;

-- Campanha não pode ser criada em nome de outro
do $$ begin
  begin
    insert into public.campaigns (owner_id, name) values ('00000000-0000-0000-0000-00000000000b', 'x');
    assert false, 'owner_id forjado deveria falhar';
  exception when insufficient_privilege then null; end;
end $$;

-- B entra pelo convite e vincula o personagem
reset role;
select set_config('test.invite', (select code from public.campaign_invites limit 1), false);
set role authenticated;
select pg_temp.act('B');
do $$ declare cid uuid; ch uuid; begin
  assert (select count(*) from public.campaign_invite_preview(current_setting('test.invite'))) = 1, 'prévia do convite';
  cid := public.join_campaign(current_setting('test.invite'));
  assert public.is_campaign_member(cid), 'B é membro';
  assert not public.is_campaign_master(cid), 'B não é Mestre';
  select id into ch from public.characters limit 1;
  insert into public.campaign_characters (campaign_id, character_id, added_by) values (cid, ch, auth.uid());
  -- B não pode promover-se a Mestre
  update public.campaign_members set role = 'master' where user_id = auth.uid();
  assert not public.is_campaign_master(cid), 'sem autopromoção';
  assert (select count(*) from public.campaign_invites) = 0, 'jogador não lê o código do convite';
  assert (select count(*) from public.campaigns) = 1, 'jogador vê a campanha';
end $$;

-- A (Mestre) agora vê e edita a ficha vinculada; C não
select pg_temp.act('A');
do $$ begin
  assert (select count(*) from public.characters) = 1, 'Mestre vê ficha vinculada';
  update public.character_forms set pv_current = 33;
  assert found, 'Mestre edita recursos autorizados';
  begin
    update public.characters set owner_id = auth.uid();
    assert false, 'Mestre não pode tomar a posse';
  exception when raise_exception then null; end;
  delete from public.characters;
  assert not found, 'Mestre não exclui ficha de jogador';
end $$;

-- B revoga a permissão de edição: Mestre continua vendo, mas não edita
select pg_temp.act('B');
update public.campaign_characters set master_can_edit = false;
select pg_temp.act('A');
do $$ begin
  update public.character_forms set pv_current = 1;
  assert not found, 'sem autorização, Mestre não edita';
  assert (select count(*) from public.characters) = 1, 'mas ainda visualiza';
end $$;

do $$ declare old text; neu text; begin
  select code into old from public.campaign_invites limit 1;
  neu := public.regenerate_invite((select id from public.campaigns limit 1));
  assert neu <> old, 'novo convite';
  assert (select count(*) from public.campaign_invite_preview(old)) = 0, 'convite antigo invalidado';
end $$;

-- ---------- Rolagens privadas do Mestre ----------
do $$ declare cid uuid; begin
  select id into cid from public.campaigns limit 1;
  insert into public.roll_log (user_id, campaign_id, label, expression, result, visibility)
  values (auth.uid(), cid, 'Segredo', '1d20', '{"total":20}', 'master'),
         (auth.uid(), cid, 'Aberta', '1d20', '{"total":3}', 'public');
end $$;
select pg_temp.act('B');
do $$ declare cid uuid; begin
  assert (select count(*) from public.roll_log where campaign_id is not null) = 1, 'jogador só vê rolagem pública';
  select id into cid from public.campaigns limit 1;
  begin
    insert into public.roll_log (user_id, campaign_id, label, expression, result, visibility)
    values (auth.uid(), cid, 'x', '1d6', '{}', 'master');
    assert false, 'jogador não cria rolagem de Mestre';
  exception when insufficient_privilege then null; end;
end $$;

-- ---------- Notas, pistas e combatentes ocultos ----------
select pg_temp.act('A');
do $$ declare cid uuid; inv uuid; cb uuid; begin
  select id into cid from public.campaigns limit 1;
  insert into public.campaign_notes (campaign_id, author_id, title, content) values (cid, auth.uid(), 'Plano', 'O saci é o vilão');
  insert into public.investigations (campaign_id, title, visible_to_players) values (cid, 'Caso 1', true) returning id into inv;
  insert into public.investigation_secrets (investigation_id, master_notes) values (inv, 'segredo');
  insert into public.clues (investigation_id, title, revealed) values (inv, 'Pegada', true), (inv, 'Gorro vermelho', false);
  insert into public.combats (campaign_id) values (cid) returning id into cb;
  insert into public.combatants (combat_id, name, pv_current, pv_max, hide_stats) values (cb, 'Saci', 30, 30, true);
  insert into public.combatants (combat_id, name, hidden) values (cb, 'Emboscada', true);
end $$;
select pg_temp.act('B');
do $$ begin
  assert (select count(*) from public.campaign_notes) = 0, 'nota privada invisível';
  assert (select count(*) from public.investigation_secrets) = 0, 'segredo da investigação invisível';
  assert (select count(*) from public.clues) = 1, 'só pista revelada';
  assert (select count(*) from public.combatants) = 0, 'tabela bruta de combatentes fechada';
  assert (select count(*) from public.combatants_public) = 1, 'combatente oculto some da visão';
  assert (select pv_current from public.combatants_public) is null, 'PV mascarado';
end $$;
select pg_temp.act('C');
do $$ begin
  assert (select count(*) from public.combatants_public) = 0, 'estranho não vê combate';
  assert (select count(*) from public.campaigns) = 0, 'estranho não vê campanha';
  assert (select count(*) from public.profiles) = 1, 'estranho só vê o próprio perfil';
end $$;

-- ---------- Homebrew ----------
select pg_temp.act('B');
insert into public.homebrew (owner_id, kind, name) values (auth.uid(), 'item', 'Espada da Existência');
select pg_temp.act('A');
do $$ begin
  assert (select count(*) from public.homebrew) = 0, 'homebrew é privado';
end $$;

-- ---------- Histórico ----------
select pg_temp.act('B');
do $$ begin
  assert (select count(*) from public.audit_log where entity = 'character_forms') >= 1, 'alterações de recursos registradas';
end $$;

reset role;
select 'TODOS OS TESTES DE RLS PASSARAM' as resultado;
