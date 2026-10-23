-- GERADO por scripts/generate-confront-parity.ts — 2086 casos.
-- Combate por rolagens opostas e perícias: banco = motor.
\set ON_ERROR_STOP on
reset role;
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000001', '00000000-0000-0000-0000-00000000000a', 'Paridade brawler', 'active', 'brawler', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000001' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000001' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000002', '00000000-0000-0000-0000-00000000000a', 'Paridade demolidor', 'active', 'demolidor', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000002' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000002' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000003', '00000000-0000-0000-0000-00000000000a', 'Paridade detalhista', 'active', 'detalhista', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000003' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000003' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000004', '00000000-0000-0000-0000-00000000000a', 'Paridade esoterico', 'active', 'esoterico', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000004' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000004' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000005', '00000000-0000-0000-0000-00000000000a', 'Paridade atirador', 'active', 'atirador', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000005' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000005' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000006', '00000000-0000-0000-0000-00000000000a', 'Paridade rato', 'active', 'rato', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000006' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000006' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000007', '00000000-0000-0000-0000-00000000000a', 'Paridade healer', 'active', 'healer', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000007' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000007' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000008', '00000000-0000-0000-0000-00000000000a', 'Paridade tank', 'active', 'tank', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000008' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000008' and cf.kind = 'base';
insert into public.characters (id, owner_id, name, status, class_id, origin_id, level) values ('60000000-0000-0000-0000-000000000009', '00000000-0000-0000-0000-00000000000a', 'Paridade lider', 'active', 'lider', 'muto', 1);
insert into public.form_attributes (form_id, attribute, base_value, other_bonus, temp_bonus) select cf.id, a.attr, a.v, a.o, a.t from public.character_forms cf, (values ('FOR', 62, 0, 4), ('DEX', 47, 3, 0), ('INT', 55, 0, 0), ('CON', 41, 0, 0), ('MIT', 38, 0, 0), ('PER', 66, 0, 0), ('CAR', 29, 0, 0), ('VIG', 53, 0, 0)) as a(attr, v, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000009' and cf.kind = 'base';
insert into public.form_skills (form_id, skill_id, points, other_bonus, temp_bonus) select cf.id, s.k, s.p, s.o, s.t from public.character_forms cf, (values ('luta', 10, 2, 5), ('reflexo', 7, 0, -3), ('pontaria', 4, 1, 0)) as s(k, p, o, t) where cf.character_id = '60000000-0000-0000-0000-000000000009' and cf.kind = 'base';
do $$
declare r jsonb; v int;
begin
  if public.classify_d100(1, 0, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 0, 0, public.classify_d100(1, 0, 0); end if;
  if public.classify_d100(1, 0, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 0, -10, public.classify_d100(1, 0, -10); end if;
  if public.classify_d100(1, 0, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 0, 15, public.classify_d100(1, 0, 15); end if;
  if public.classify_d100(2, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 2, 0, 0, public.classify_d100(2, 0, 0); end if;
  if public.classify_d100(2, 0, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 0, -10, public.classify_d100(2, 0, -10); end if;
  if public.classify_d100(2, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 2, 0, 15, public.classify_d100(2, 0, 15); end if;
  if public.classify_d100(3, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 3, 0, 0, public.classify_d100(3, 0, 0); end if;
  if public.classify_d100(3, 0, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 0, -10, public.classify_d100(3, 0, -10); end if;
  if public.classify_d100(3, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 3, 0, 15, public.classify_d100(3, 0, 15); end if;
  if public.classify_d100(5, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 0, 0, public.classify_d100(5, 0, 0); end if;
  if public.classify_d100(5, 0, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 0, -10, public.classify_d100(5, 0, -10); end if;
  if public.classify_d100(5, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 0, 15, public.classify_d100(5, 0, 15); end if;
  if public.classify_d100(9, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 0, 0, public.classify_d100(9, 0, 0); end if;
  if public.classify_d100(9, 0, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 0, -10, public.classify_d100(9, 0, -10); end if;
  if public.classify_d100(9, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 0, 15, public.classify_d100(9, 0, 15); end if;
  if public.classify_d100(10, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 0, 0, public.classify_d100(10, 0, 0); end if;
  if public.classify_d100(10, 0, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 0, -10, public.classify_d100(10, 0, -10); end if;
  if public.classify_d100(10, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 0, 15, public.classify_d100(10, 0, 15); end if;
  if public.classify_d100(11, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 0, 0, public.classify_d100(11, 0, 0); end if;
  if public.classify_d100(11, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 0, -10, public.classify_d100(11, 0, -10); end if;
  if public.classify_d100(11, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 0, 15, public.classify_d100(11, 0, 15); end if;
  if public.classify_d100(12, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 0, 0, public.classify_d100(12, 0, 0); end if;
  if public.classify_d100(12, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 0, -10, public.classify_d100(12, 0, -10); end if;
  if public.classify_d100(12, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 0, 15, public.classify_d100(12, 0, 15); end if;
  if public.classify_d100(16, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 0, 0, public.classify_d100(16, 0, 0); end if;
  if public.classify_d100(16, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 0, -10, public.classify_d100(16, 0, -10); end if;
  if public.classify_d100(16, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 0, 15, public.classify_d100(16, 0, 15); end if;
  if public.classify_d100(17, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 0, 0, public.classify_d100(17, 0, 0); end if;
  if public.classify_d100(17, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 0, -10, public.classify_d100(17, 0, -10); end if;
  if public.classify_d100(17, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 0, 15, public.classify_d100(17, 0, 15); end if;
  if public.classify_d100(25, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 0, 0, public.classify_d100(25, 0, 0); end if;
  if public.classify_d100(25, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 0, -10, public.classify_d100(25, 0, -10); end if;
  if public.classify_d100(25, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 0, 15, public.classify_d100(25, 0, 15); end if;
  if public.classify_d100(30, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 0, 0, public.classify_d100(30, 0, 0); end if;
  if public.classify_d100(30, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 0, -10, public.classify_d100(30, 0, -10); end if;
  if public.classify_d100(30, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 0, 15, public.classify_d100(30, 0, 15); end if;
  if public.classify_d100(37, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 0, 0, public.classify_d100(37, 0, 0); end if;
  if public.classify_d100(37, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 0, -10, public.classify_d100(37, 0, -10); end if;
  if public.classify_d100(37, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 0, 15, public.classify_d100(37, 0, 15); end if;
  if public.classify_d100(38, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 0, 0, public.classify_d100(38, 0, 0); end if;
  if public.classify_d100(38, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 0, -10, public.classify_d100(38, 0, -10); end if;
  if public.classify_d100(38, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 0, 15, public.classify_d100(38, 0, 15); end if;
  if public.classify_d100(49, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 0, 0, public.classify_d100(49, 0, 0); end if;
  if public.classify_d100(49, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 0, -10, public.classify_d100(49, 0, -10); end if;
  if public.classify_d100(49, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 0, 15, public.classify_d100(49, 0, 15); end if;
  if public.classify_d100(50, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 0, 0, public.classify_d100(50, 0, 0); end if;
  if public.classify_d100(50, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 0, -10, public.classify_d100(50, 0, -10); end if;
  if public.classify_d100(50, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 0, 15, public.classify_d100(50, 0, 15); end if;
  if public.classify_d100(51, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 0, 0, public.classify_d100(51, 0, 0); end if;
  if public.classify_d100(51, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 0, -10, public.classify_d100(51, 0, -10); end if;
  if public.classify_d100(51, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 0, 15, public.classify_d100(51, 0, 15); end if;
  if public.classify_d100(60, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 0, 0, public.classify_d100(60, 0, 0); end if;
  if public.classify_d100(60, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 0, -10, public.classify_d100(60, 0, -10); end if;
  if public.classify_d100(60, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 0, 15, public.classify_d100(60, 0, 15); end if;
  if public.classify_d100(74, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 0, 0, public.classify_d100(74, 0, 0); end if;
  if public.classify_d100(74, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 0, -10, public.classify_d100(74, 0, -10); end if;
  if public.classify_d100(74, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 0, 15, public.classify_d100(74, 0, 15); end if;
  if public.classify_d100(75, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 0, 0, public.classify_d100(75, 0, 0); end if;
  if public.classify_d100(75, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 0, -10, public.classify_d100(75, 0, -10); end if;
  if public.classify_d100(75, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 0, 15, public.classify_d100(75, 0, 15); end if;
  if public.classify_d100(76, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 0, 0, public.classify_d100(76, 0, 0); end if;
  if public.classify_d100(76, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 0, -10, public.classify_d100(76, 0, -10); end if;
  if public.classify_d100(76, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 0, 15, public.classify_d100(76, 0, 15); end if;
  if public.classify_d100(95, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 0, 0, public.classify_d100(95, 0, 0); end if;
  if public.classify_d100(95, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 0, -10, public.classify_d100(95, 0, -10); end if;
  if public.classify_d100(95, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 0, 15, public.classify_d100(95, 0, 15); end if;
  if public.classify_d100(99, 0, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 0, 0, public.classify_d100(99, 0, 0); end if;
  if public.classify_d100(99, 0, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 0, -10, public.classify_d100(99, 0, -10); end if;
  if public.classify_d100(99, 0, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 0, 15, public.classify_d100(99, 0, 15); end if;
  if public.classify_d100(100, 0, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 0, 0, public.classify_d100(100, 0, 0); end if;
  if public.classify_d100(100, 0, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 0, -10, public.classify_d100(100, 0, -10); end if;
  if public.classify_d100(100, 0, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 0, 15, public.classify_d100(100, 0, 15); end if;
  if public.classify_d100(1, 1, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 1, 0, public.classify_d100(1, 1, 0); end if;
  if public.classify_d100(1, 1, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 1, -10, public.classify_d100(1, 1, -10); end if;
  if public.classify_d100(1, 1, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 1, 15, public.classify_d100(1, 1, 15); end if;
  if public.classify_d100(2, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 2, 1, 0, public.classify_d100(2, 1, 0); end if;
  if public.classify_d100(2, 1, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 1, -10, public.classify_d100(2, 1, -10); end if;
  if public.classify_d100(2, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 2, 1, 15, public.classify_d100(2, 1, 15); end if;
  if public.classify_d100(3, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 3, 1, 0, public.classify_d100(3, 1, 0); end if;
  if public.classify_d100(3, 1, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 1, -10, public.classify_d100(3, 1, -10); end if;
  if public.classify_d100(3, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 3, 1, 15, public.classify_d100(3, 1, 15); end if;
  if public.classify_d100(5, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 1, 0, public.classify_d100(5, 1, 0); end if;
  if public.classify_d100(5, 1, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 1, -10, public.classify_d100(5, 1, -10); end if;
  if public.classify_d100(5, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 1, 15, public.classify_d100(5, 1, 15); end if;
  if public.classify_d100(9, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 1, 0, public.classify_d100(9, 1, 0); end if;
  if public.classify_d100(9, 1, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 1, -10, public.classify_d100(9, 1, -10); end if;
  if public.classify_d100(9, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 1, 15, public.classify_d100(9, 1, 15); end if;
  if public.classify_d100(10, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 1, 0, public.classify_d100(10, 1, 0); end if;
  if public.classify_d100(10, 1, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 1, -10, public.classify_d100(10, 1, -10); end if;
  if public.classify_d100(10, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 1, 15, public.classify_d100(10, 1, 15); end if;
  if public.classify_d100(11, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 1, 0, public.classify_d100(11, 1, 0); end if;
  if public.classify_d100(11, 1, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 11, 1, -10, public.classify_d100(11, 1, -10); end if;
  if public.classify_d100(11, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 1, 15, public.classify_d100(11, 1, 15); end if;
  if public.classify_d100(12, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 1, 0, public.classify_d100(12, 1, 0); end if;
  if public.classify_d100(12, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 1, -10, public.classify_d100(12, 1, -10); end if;
  if public.classify_d100(12, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 1, 15, public.classify_d100(12, 1, 15); end if;
  if public.classify_d100(16, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 1, 0, public.classify_d100(16, 1, 0); end if;
  if public.classify_d100(16, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 1, -10, public.classify_d100(16, 1, -10); end if;
  if public.classify_d100(16, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 1, 15, public.classify_d100(16, 1, 15); end if;
  if public.classify_d100(17, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 1, 0, public.classify_d100(17, 1, 0); end if;
  if public.classify_d100(17, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 1, -10, public.classify_d100(17, 1, -10); end if;
  if public.classify_d100(17, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 1, 15, public.classify_d100(17, 1, 15); end if;
  if public.classify_d100(25, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 1, 0, public.classify_d100(25, 1, 0); end if;
  if public.classify_d100(25, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 1, -10, public.classify_d100(25, 1, -10); end if;
  if public.classify_d100(25, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 1, 15, public.classify_d100(25, 1, 15); end if;
  if public.classify_d100(30, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 1, 0, public.classify_d100(30, 1, 0); end if;
  if public.classify_d100(30, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 1, -10, public.classify_d100(30, 1, -10); end if;
  if public.classify_d100(30, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 1, 15, public.classify_d100(30, 1, 15); end if;
  if public.classify_d100(37, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 1, 0, public.classify_d100(37, 1, 0); end if;
  if public.classify_d100(37, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 1, -10, public.classify_d100(37, 1, -10); end if;
  if public.classify_d100(37, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 1, 15, public.classify_d100(37, 1, 15); end if;
  if public.classify_d100(38, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 1, 0, public.classify_d100(38, 1, 0); end if;
  if public.classify_d100(38, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 1, -10, public.classify_d100(38, 1, -10); end if;
  if public.classify_d100(38, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 1, 15, public.classify_d100(38, 1, 15); end if;
  if public.classify_d100(49, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 1, 0, public.classify_d100(49, 1, 0); end if;
  if public.classify_d100(49, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 1, -10, public.classify_d100(49, 1, -10); end if;
  if public.classify_d100(49, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 1, 15, public.classify_d100(49, 1, 15); end if;
  if public.classify_d100(50, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 1, 0, public.classify_d100(50, 1, 0); end if;
  if public.classify_d100(50, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 1, -10, public.classify_d100(50, 1, -10); end if;
  if public.classify_d100(50, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 1, 15, public.classify_d100(50, 1, 15); end if;
  if public.classify_d100(51, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 1, 0, public.classify_d100(51, 1, 0); end if;
  if public.classify_d100(51, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 1, -10, public.classify_d100(51, 1, -10); end if;
  if public.classify_d100(51, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 1, 15, public.classify_d100(51, 1, 15); end if;
  if public.classify_d100(60, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 1, 0, public.classify_d100(60, 1, 0); end if;
  if public.classify_d100(60, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 1, -10, public.classify_d100(60, 1, -10); end if;
  if public.classify_d100(60, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 1, 15, public.classify_d100(60, 1, 15); end if;
  if public.classify_d100(74, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 1, 0, public.classify_d100(74, 1, 0); end if;
  if public.classify_d100(74, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 1, -10, public.classify_d100(74, 1, -10); end if;
  if public.classify_d100(74, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 1, 15, public.classify_d100(74, 1, 15); end if;
  if public.classify_d100(75, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 1, 0, public.classify_d100(75, 1, 0); end if;
  if public.classify_d100(75, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 1, -10, public.classify_d100(75, 1, -10); end if;
  if public.classify_d100(75, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 1, 15, public.classify_d100(75, 1, 15); end if;
  if public.classify_d100(76, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 1, 0, public.classify_d100(76, 1, 0); end if;
  if public.classify_d100(76, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 1, -10, public.classify_d100(76, 1, -10); end if;
  if public.classify_d100(76, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 1, 15, public.classify_d100(76, 1, 15); end if;
  if public.classify_d100(95, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 1, 0, public.classify_d100(95, 1, 0); end if;
  if public.classify_d100(95, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 1, -10, public.classify_d100(95, 1, -10); end if;
  if public.classify_d100(95, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 1, 15, public.classify_d100(95, 1, 15); end if;
  if public.classify_d100(99, 1, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 1, 0, public.classify_d100(99, 1, 0); end if;
  if public.classify_d100(99, 1, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 1, -10, public.classify_d100(99, 1, -10); end if;
  if public.classify_d100(99, 1, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 1, 15, public.classify_d100(99, 1, 15); end if;
  if public.classify_d100(100, 1, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 1, 0, public.classify_d100(100, 1, 0); end if;
  if public.classify_d100(100, 1, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 1, -10, public.classify_d100(100, 1, -10); end if;
  if public.classify_d100(100, 1, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 1, 15, public.classify_d100(100, 1, 15); end if;
  if public.classify_d100(1, 4, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 4, 0, public.classify_d100(1, 4, 0); end if;
  if public.classify_d100(1, 4, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 4, -10, public.classify_d100(1, 4, -10); end if;
  if public.classify_d100(1, 4, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 4, 15, public.classify_d100(1, 4, 15); end if;
  if public.classify_d100(2, 4, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 2, 4, 0, public.classify_d100(2, 4, 0); end if;
  if public.classify_d100(2, 4, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 4, -10, public.classify_d100(2, 4, -10); end if;
  if public.classify_d100(2, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 2, 4, 15, public.classify_d100(2, 4, 15); end if;
  if public.classify_d100(3, 4, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 3, 4, 0, public.classify_d100(3, 4, 0); end if;
  if public.classify_d100(3, 4, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 4, -10, public.classify_d100(3, 4, -10); end if;
  if public.classify_d100(3, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 3, 4, 15, public.classify_d100(3, 4, 15); end if;
  if public.classify_d100(5, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 4, 0, public.classify_d100(5, 4, 0); end if;
  if public.classify_d100(5, 4, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 4, -10, public.classify_d100(5, 4, -10); end if;
  if public.classify_d100(5, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 4, 15, public.classify_d100(5, 4, 15); end if;
  if public.classify_d100(9, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 4, 0, public.classify_d100(9, 4, 0); end if;
  if public.classify_d100(9, 4, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 4, -10, public.classify_d100(9, 4, -10); end if;
  if public.classify_d100(9, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 4, 15, public.classify_d100(9, 4, 15); end if;
  if public.classify_d100(10, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 4, 0, public.classify_d100(10, 4, 0); end if;
  if public.classify_d100(10, 4, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 4, -10, public.classify_d100(10, 4, -10); end if;
  if public.classify_d100(10, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 4, 15, public.classify_d100(10, 4, 15); end if;
  if public.classify_d100(11, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 4, 0, public.classify_d100(11, 4, 0); end if;
  if public.classify_d100(11, 4, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 11, 4, -10, public.classify_d100(11, 4, -10); end if;
  if public.classify_d100(11, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 4, 15, public.classify_d100(11, 4, 15); end if;
  if public.classify_d100(12, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 4, 0, public.classify_d100(12, 4, 0); end if;
  if public.classify_d100(12, 4, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 4, -10, public.classify_d100(12, 4, -10); end if;
  if public.classify_d100(12, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 4, 15, public.classify_d100(12, 4, 15); end if;
  if public.classify_d100(16, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 4, 0, public.classify_d100(16, 4, 0); end if;
  if public.classify_d100(16, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 4, -10, public.classify_d100(16, 4, -10); end if;
  if public.classify_d100(16, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 4, 15, public.classify_d100(16, 4, 15); end if;
  if public.classify_d100(17, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 4, 0, public.classify_d100(17, 4, 0); end if;
  if public.classify_d100(17, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 4, -10, public.classify_d100(17, 4, -10); end if;
  if public.classify_d100(17, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 4, 15, public.classify_d100(17, 4, 15); end if;
  if public.classify_d100(25, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 4, 0, public.classify_d100(25, 4, 0); end if;
  if public.classify_d100(25, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 4, -10, public.classify_d100(25, 4, -10); end if;
  if public.classify_d100(25, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 4, 15, public.classify_d100(25, 4, 15); end if;
  if public.classify_d100(30, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 4, 0, public.classify_d100(30, 4, 0); end if;
  if public.classify_d100(30, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 4, -10, public.classify_d100(30, 4, -10); end if;
  if public.classify_d100(30, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 4, 15, public.classify_d100(30, 4, 15); end if;
  if public.classify_d100(37, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 4, 0, public.classify_d100(37, 4, 0); end if;
  if public.classify_d100(37, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 4, -10, public.classify_d100(37, 4, -10); end if;
  if public.classify_d100(37, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 4, 15, public.classify_d100(37, 4, 15); end if;
  if public.classify_d100(38, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 4, 0, public.classify_d100(38, 4, 0); end if;
  if public.classify_d100(38, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 4, -10, public.classify_d100(38, 4, -10); end if;
  if public.classify_d100(38, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 4, 15, public.classify_d100(38, 4, 15); end if;
  if public.classify_d100(49, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 4, 0, public.classify_d100(49, 4, 0); end if;
  if public.classify_d100(49, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 4, -10, public.classify_d100(49, 4, -10); end if;
  if public.classify_d100(49, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 4, 15, public.classify_d100(49, 4, 15); end if;
  if public.classify_d100(50, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 4, 0, public.classify_d100(50, 4, 0); end if;
  if public.classify_d100(50, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 4, -10, public.classify_d100(50, 4, -10); end if;
  if public.classify_d100(50, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 4, 15, public.classify_d100(50, 4, 15); end if;
  if public.classify_d100(51, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 4, 0, public.classify_d100(51, 4, 0); end if;
  if public.classify_d100(51, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 4, -10, public.classify_d100(51, 4, -10); end if;
  if public.classify_d100(51, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 4, 15, public.classify_d100(51, 4, 15); end if;
  if public.classify_d100(60, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 4, 0, public.classify_d100(60, 4, 0); end if;
  if public.classify_d100(60, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 4, -10, public.classify_d100(60, 4, -10); end if;
  if public.classify_d100(60, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 4, 15, public.classify_d100(60, 4, 15); end if;
  if public.classify_d100(74, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 4, 0, public.classify_d100(74, 4, 0); end if;
  if public.classify_d100(74, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 4, -10, public.classify_d100(74, 4, -10); end if;
  if public.classify_d100(74, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 4, 15, public.classify_d100(74, 4, 15); end if;
  if public.classify_d100(75, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 4, 0, public.classify_d100(75, 4, 0); end if;
  if public.classify_d100(75, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 4, -10, public.classify_d100(75, 4, -10); end if;
  if public.classify_d100(75, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 4, 15, public.classify_d100(75, 4, 15); end if;
  if public.classify_d100(76, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 4, 0, public.classify_d100(76, 4, 0); end if;
  if public.classify_d100(76, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 4, -10, public.classify_d100(76, 4, -10); end if;
  if public.classify_d100(76, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 4, 15, public.classify_d100(76, 4, 15); end if;
  if public.classify_d100(95, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 4, 0, public.classify_d100(95, 4, 0); end if;
  if public.classify_d100(95, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 4, -10, public.classify_d100(95, 4, -10); end if;
  if public.classify_d100(95, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 4, 15, public.classify_d100(95, 4, 15); end if;
  if public.classify_d100(99, 4, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 4, 0, public.classify_d100(99, 4, 0); end if;
  if public.classify_d100(99, 4, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 4, -10, public.classify_d100(99, 4, -10); end if;
  if public.classify_d100(99, 4, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 4, 15, public.classify_d100(99, 4, 15); end if;
  if public.classify_d100(100, 4, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 4, 0, public.classify_d100(100, 4, 0); end if;
  if public.classify_d100(100, 4, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 4, -10, public.classify_d100(100, 4, -10); end if;
  if public.classify_d100(100, 4, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 4, 15, public.classify_d100(100, 4, 15); end if;
  if public.classify_d100(1, 5, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 5, 0, public.classify_d100(1, 5, 0); end if;
  if public.classify_d100(1, 5, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 5, -10, public.classify_d100(1, 5, -10); end if;
  if public.classify_d100(1, 5, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 5, 15, public.classify_d100(1, 5, 15); end if;
  if public.classify_d100(2, 5, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 2, 5, 0, public.classify_d100(2, 5, 0); end if;
  if public.classify_d100(2, 5, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 5, -10, public.classify_d100(2, 5, -10); end if;
  if public.classify_d100(2, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 2, 5, 15, public.classify_d100(2, 5, 15); end if;
  if public.classify_d100(3, 5, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 3, 5, 0, public.classify_d100(3, 5, 0); end if;
  if public.classify_d100(3, 5, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 5, -10, public.classify_d100(3, 5, -10); end if;
  if public.classify_d100(3, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 3, 5, 15, public.classify_d100(3, 5, 15); end if;
  if public.classify_d100(5, 5, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 5, 5, 0, public.classify_d100(5, 5, 0); end if;
  if public.classify_d100(5, 5, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 5, -10, public.classify_d100(5, 5, -10); end if;
  if public.classify_d100(5, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 5, 15, public.classify_d100(5, 5, 15); end if;
  if public.classify_d100(9, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 5, 0, public.classify_d100(9, 5, 0); end if;
  if public.classify_d100(9, 5, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 5, -10, public.classify_d100(9, 5, -10); end if;
  if public.classify_d100(9, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 5, 15, public.classify_d100(9, 5, 15); end if;
  if public.classify_d100(10, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 5, 0, public.classify_d100(10, 5, 0); end if;
  if public.classify_d100(10, 5, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 5, -10, public.classify_d100(10, 5, -10); end if;
  if public.classify_d100(10, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 5, 15, public.classify_d100(10, 5, 15); end if;
  if public.classify_d100(11, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 5, 0, public.classify_d100(11, 5, 0); end if;
  if public.classify_d100(11, 5, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 5, -10, public.classify_d100(11, 5, -10); end if;
  if public.classify_d100(11, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 5, 15, public.classify_d100(11, 5, 15); end if;
  if public.classify_d100(12, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 5, 0, public.classify_d100(12, 5, 0); end if;
  if public.classify_d100(12, 5, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 5, -10, public.classify_d100(12, 5, -10); end if;
  if public.classify_d100(12, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 5, 15, public.classify_d100(12, 5, 15); end if;
  if public.classify_d100(16, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 5, 0, public.classify_d100(16, 5, 0); end if;
  if public.classify_d100(16, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 5, -10, public.classify_d100(16, 5, -10); end if;
  if public.classify_d100(16, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 5, 15, public.classify_d100(16, 5, 15); end if;
  if public.classify_d100(17, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 5, 0, public.classify_d100(17, 5, 0); end if;
  if public.classify_d100(17, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 5, -10, public.classify_d100(17, 5, -10); end if;
  if public.classify_d100(17, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 5, 15, public.classify_d100(17, 5, 15); end if;
  if public.classify_d100(25, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 5, 0, public.classify_d100(25, 5, 0); end if;
  if public.classify_d100(25, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 5, -10, public.classify_d100(25, 5, -10); end if;
  if public.classify_d100(25, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 5, 15, public.classify_d100(25, 5, 15); end if;
  if public.classify_d100(30, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 5, 0, public.classify_d100(30, 5, 0); end if;
  if public.classify_d100(30, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 5, -10, public.classify_d100(30, 5, -10); end if;
  if public.classify_d100(30, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 5, 15, public.classify_d100(30, 5, 15); end if;
  if public.classify_d100(37, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 5, 0, public.classify_d100(37, 5, 0); end if;
  if public.classify_d100(37, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 5, -10, public.classify_d100(37, 5, -10); end if;
  if public.classify_d100(37, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 5, 15, public.classify_d100(37, 5, 15); end if;
  if public.classify_d100(38, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 5, 0, public.classify_d100(38, 5, 0); end if;
  if public.classify_d100(38, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 5, -10, public.classify_d100(38, 5, -10); end if;
  if public.classify_d100(38, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 5, 15, public.classify_d100(38, 5, 15); end if;
  if public.classify_d100(49, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 5, 0, public.classify_d100(49, 5, 0); end if;
  if public.classify_d100(49, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 5, -10, public.classify_d100(49, 5, -10); end if;
  if public.classify_d100(49, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 5, 15, public.classify_d100(49, 5, 15); end if;
  if public.classify_d100(50, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 5, 0, public.classify_d100(50, 5, 0); end if;
  if public.classify_d100(50, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 5, -10, public.classify_d100(50, 5, -10); end if;
  if public.classify_d100(50, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 5, 15, public.classify_d100(50, 5, 15); end if;
  if public.classify_d100(51, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 5, 0, public.classify_d100(51, 5, 0); end if;
  if public.classify_d100(51, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 5, -10, public.classify_d100(51, 5, -10); end if;
  if public.classify_d100(51, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 5, 15, public.classify_d100(51, 5, 15); end if;
  if public.classify_d100(60, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 5, 0, public.classify_d100(60, 5, 0); end if;
  if public.classify_d100(60, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 5, -10, public.classify_d100(60, 5, -10); end if;
  if public.classify_d100(60, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 5, 15, public.classify_d100(60, 5, 15); end if;
  if public.classify_d100(74, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 5, 0, public.classify_d100(74, 5, 0); end if;
  if public.classify_d100(74, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 5, -10, public.classify_d100(74, 5, -10); end if;
  if public.classify_d100(74, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 5, 15, public.classify_d100(74, 5, 15); end if;
  if public.classify_d100(75, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 5, 0, public.classify_d100(75, 5, 0); end if;
  if public.classify_d100(75, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 5, -10, public.classify_d100(75, 5, -10); end if;
  if public.classify_d100(75, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 5, 15, public.classify_d100(75, 5, 15); end if;
  if public.classify_d100(76, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 5, 0, public.classify_d100(76, 5, 0); end if;
  if public.classify_d100(76, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 5, -10, public.classify_d100(76, 5, -10); end if;
  if public.classify_d100(76, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 5, 15, public.classify_d100(76, 5, 15); end if;
  if public.classify_d100(95, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 5, 0, public.classify_d100(95, 5, 0); end if;
  if public.classify_d100(95, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 5, -10, public.classify_d100(95, 5, -10); end if;
  if public.classify_d100(95, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 5, 15, public.classify_d100(95, 5, 15); end if;
  if public.classify_d100(99, 5, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 5, 0, public.classify_d100(99, 5, 0); end if;
  if public.classify_d100(99, 5, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 5, -10, public.classify_d100(99, 5, -10); end if;
  if public.classify_d100(99, 5, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 5, 15, public.classify_d100(99, 5, 15); end if;
  if public.classify_d100(100, 5, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 5, 0, public.classify_d100(100, 5, 0); end if;
  if public.classify_d100(100, 5, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 5, -10, public.classify_d100(100, 5, -10); end if;
  if public.classify_d100(100, 5, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 5, 15, public.classify_d100(100, 5, 15); end if;
  if public.classify_d100(1, 10, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 10, 0, public.classify_d100(1, 10, 0); end if;
  if public.classify_d100(1, 10, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 10, -10, public.classify_d100(1, 10, -10); end if;
  if public.classify_d100(1, 10, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 10, 15, public.classify_d100(1, 10, 15); end if;
  if public.classify_d100(2, 10, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 10, 0, public.classify_d100(2, 10, 0); end if;
  if public.classify_d100(2, 10, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 10, -10, public.classify_d100(2, 10, -10); end if;
  if public.classify_d100(2, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 2, 10, 15, public.classify_d100(2, 10, 15); end if;
  if public.classify_d100(3, 10, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 3, 10, 0, public.classify_d100(3, 10, 0); end if;
  if public.classify_d100(3, 10, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 10, -10, public.classify_d100(3, 10, -10); end if;
  if public.classify_d100(3, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 3, 10, 15, public.classify_d100(3, 10, 15); end if;
  if public.classify_d100(5, 10, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 5, 10, 0, public.classify_d100(5, 10, 0); end if;
  if public.classify_d100(5, 10, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 10, -10, public.classify_d100(5, 10, -10); end if;
  if public.classify_d100(5, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 5, 10, 15, public.classify_d100(5, 10, 15); end if;
  if public.classify_d100(9, 10, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 9, 10, 0, public.classify_d100(9, 10, 0); end if;
  if public.classify_d100(9, 10, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 10, -10, public.classify_d100(9, 10, -10); end if;
  if public.classify_d100(9, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 9, 10, 15, public.classify_d100(9, 10, 15); end if;
  if public.classify_d100(10, 10, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 10, 10, 0, public.classify_d100(10, 10, 0); end if;
  if public.classify_d100(10, 10, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 10, -10, public.classify_d100(10, 10, -10); end if;
  if public.classify_d100(10, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 10, 10, 15, public.classify_d100(10, 10, 15); end if;
  if public.classify_d100(11, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 10, 0, public.classify_d100(11, 10, 0); end if;
  if public.classify_d100(11, 10, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 10, -10, public.classify_d100(11, 10, -10); end if;
  if public.classify_d100(11, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 11, 10, 15, public.classify_d100(11, 10, 15); end if;
  if public.classify_d100(12, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 10, 0, public.classify_d100(12, 10, 0); end if;
  if public.classify_d100(12, 10, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 10, -10, public.classify_d100(12, 10, -10); end if;
  if public.classify_d100(12, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 12, 10, 15, public.classify_d100(12, 10, 15); end if;
  if public.classify_d100(16, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 10, 0, public.classify_d100(16, 10, 0); end if;
  if public.classify_d100(16, 10, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 16, 10, -10, public.classify_d100(16, 10, -10); end if;
  if public.classify_d100(16, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 16, 10, 15, public.classify_d100(16, 10, 15); end if;
  if public.classify_d100(17, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 10, 0, public.classify_d100(17, 10, 0); end if;
  if public.classify_d100(17, 10, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 17, 10, -10, public.classify_d100(17, 10, -10); end if;
  if public.classify_d100(17, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 17, 10, 15, public.classify_d100(17, 10, 15); end if;
  if public.classify_d100(25, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 10, 0, public.classify_d100(25, 10, 0); end if;
  if public.classify_d100(25, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 10, -10, public.classify_d100(25, 10, -10); end if;
  if public.classify_d100(25, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 10, 15, public.classify_d100(25, 10, 15); end if;
  if public.classify_d100(30, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 10, 0, public.classify_d100(30, 10, 0); end if;
  if public.classify_d100(30, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 10, -10, public.classify_d100(30, 10, -10); end if;
  if public.classify_d100(30, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 10, 15, public.classify_d100(30, 10, 15); end if;
  if public.classify_d100(37, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 10, 0, public.classify_d100(37, 10, 0); end if;
  if public.classify_d100(37, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 10, -10, public.classify_d100(37, 10, -10); end if;
  if public.classify_d100(37, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 10, 15, public.classify_d100(37, 10, 15); end if;
  if public.classify_d100(38, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 10, 0, public.classify_d100(38, 10, 0); end if;
  if public.classify_d100(38, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 10, -10, public.classify_d100(38, 10, -10); end if;
  if public.classify_d100(38, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 10, 15, public.classify_d100(38, 10, 15); end if;
  if public.classify_d100(49, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 10, 0, public.classify_d100(49, 10, 0); end if;
  if public.classify_d100(49, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 10, -10, public.classify_d100(49, 10, -10); end if;
  if public.classify_d100(49, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 10, 15, public.classify_d100(49, 10, 15); end if;
  if public.classify_d100(50, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 10, 0, public.classify_d100(50, 10, 0); end if;
  if public.classify_d100(50, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 10, -10, public.classify_d100(50, 10, -10); end if;
  if public.classify_d100(50, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 10, 15, public.classify_d100(50, 10, 15); end if;
  if public.classify_d100(51, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 10, 0, public.classify_d100(51, 10, 0); end if;
  if public.classify_d100(51, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 10, -10, public.classify_d100(51, 10, -10); end if;
  if public.classify_d100(51, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 10, 15, public.classify_d100(51, 10, 15); end if;
  if public.classify_d100(60, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 10, 0, public.classify_d100(60, 10, 0); end if;
  if public.classify_d100(60, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 10, -10, public.classify_d100(60, 10, -10); end if;
  if public.classify_d100(60, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 10, 15, public.classify_d100(60, 10, 15); end if;
  if public.classify_d100(74, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 10, 0, public.classify_d100(74, 10, 0); end if;
  if public.classify_d100(74, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 10, -10, public.classify_d100(74, 10, -10); end if;
  if public.classify_d100(74, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 10, 15, public.classify_d100(74, 10, 15); end if;
  if public.classify_d100(75, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 10, 0, public.classify_d100(75, 10, 0); end if;
  if public.classify_d100(75, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 10, -10, public.classify_d100(75, 10, -10); end if;
  if public.classify_d100(75, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 10, 15, public.classify_d100(75, 10, 15); end if;
  if public.classify_d100(76, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 10, 0, public.classify_d100(76, 10, 0); end if;
  if public.classify_d100(76, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 10, -10, public.classify_d100(76, 10, -10); end if;
  if public.classify_d100(76, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 10, 15, public.classify_d100(76, 10, 15); end if;
  if public.classify_d100(95, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 10, 0, public.classify_d100(95, 10, 0); end if;
  if public.classify_d100(95, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 10, -10, public.classify_d100(95, 10, -10); end if;
  if public.classify_d100(95, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 10, 15, public.classify_d100(95, 10, 15); end if;
  if public.classify_d100(99, 10, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 10, 0, public.classify_d100(99, 10, 0); end if;
  if public.classify_d100(99, 10, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 10, -10, public.classify_d100(99, 10, -10); end if;
  if public.classify_d100(99, 10, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 10, 15, public.classify_d100(99, 10, 15); end if;
  if public.classify_d100(100, 10, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 10, 0, public.classify_d100(100, 10, 0); end if;
  if public.classify_d100(100, 10, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 10, -10, public.classify_d100(100, 10, -10); end if;
  if public.classify_d100(100, 10, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 10, 15, public.classify_d100(100, 10, 15); end if;
  if public.classify_d100(1, 33, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 33, 0, public.classify_d100(1, 33, 0); end if;
  if public.classify_d100(1, 33, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 33, -10, public.classify_d100(1, 33, -10); end if;
  if public.classify_d100(1, 33, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 33, 15, public.classify_d100(1, 33, 15); end if;
  if public.classify_d100(2, 33, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 33, 0, public.classify_d100(2, 33, 0); end if;
  if public.classify_d100(2, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 33, -10, public.classify_d100(2, 33, -10); end if;
  if public.classify_d100(2, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 2, 33, 15, public.classify_d100(2, 33, 15); end if;
  if public.classify_d100(3, 33, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 33, 0, public.classify_d100(3, 33, 0); end if;
  if public.classify_d100(3, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 33, -10, public.classify_d100(3, 33, -10); end if;
  if public.classify_d100(3, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 3, 33, 15, public.classify_d100(3, 33, 15); end if;
  if public.classify_d100(5, 33, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 33, 0, public.classify_d100(5, 33, 0); end if;
  if public.classify_d100(5, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 33, -10, public.classify_d100(5, 33, -10); end if;
  if public.classify_d100(5, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 5, 33, 15, public.classify_d100(5, 33, 15); end if;
  if public.classify_d100(9, 33, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 9, 33, 0, public.classify_d100(9, 33, 0); end if;
  if public.classify_d100(9, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 33, -10, public.classify_d100(9, 33, -10); end if;
  if public.classify_d100(9, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 9, 33, 15, public.classify_d100(9, 33, 15); end if;
  if public.classify_d100(10, 33, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 10, 33, 0, public.classify_d100(10, 33, 0); end if;
  if public.classify_d100(10, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 33, -10, public.classify_d100(10, 33, -10); end if;
  if public.classify_d100(10, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 10, 33, 15, public.classify_d100(10, 33, 15); end if;
  if public.classify_d100(11, 33, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 11, 33, 0, public.classify_d100(11, 33, 0); end if;
  if public.classify_d100(11, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 33, -10, public.classify_d100(11, 33, -10); end if;
  if public.classify_d100(11, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 11, 33, 15, public.classify_d100(11, 33, 15); end if;
  if public.classify_d100(12, 33, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 33, 0, public.classify_d100(12, 33, 0); end if;
  if public.classify_d100(12, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 33, -10, public.classify_d100(12, 33, -10); end if;
  if public.classify_d100(12, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 12, 33, 15, public.classify_d100(12, 33, 15); end if;
  if public.classify_d100(16, 33, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 16, 33, 0, public.classify_d100(16, 33, 0); end if;
  if public.classify_d100(16, 33, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 33, -10, public.classify_d100(16, 33, -10); end if;
  if public.classify_d100(16, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 16, 33, 15, public.classify_d100(16, 33, 15); end if;
  if public.classify_d100(17, 33, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 17, 33, 0, public.classify_d100(17, 33, 0); end if;
  if public.classify_d100(17, 33, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 17, 33, -10, public.classify_d100(17, 33, -10); end if;
  if public.classify_d100(17, 33, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 17, 33, 15, public.classify_d100(17, 33, 15); end if;
  if public.classify_d100(25, 33, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 25, 33, 0, public.classify_d100(25, 33, 0); end if;
  if public.classify_d100(25, 33, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 33, -10, public.classify_d100(25, 33, -10); end if;
  if public.classify_d100(25, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 25, 33, 15, public.classify_d100(25, 33, 15); end if;
  if public.classify_d100(30, 33, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 30, 33, 0, public.classify_d100(30, 33, 0); end if;
  if public.classify_d100(30, 33, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 30, 33, -10, public.classify_d100(30, 33, -10); end if;
  if public.classify_d100(30, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 30, 33, 15, public.classify_d100(30, 33, 15); end if;
  if public.classify_d100(37, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 33, 0, public.classify_d100(37, 33, 0); end if;
  if public.classify_d100(37, 33, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 37, 33, -10, public.classify_d100(37, 33, -10); end if;
  if public.classify_d100(37, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 33, 15, public.classify_d100(37, 33, 15); end if;
  if public.classify_d100(38, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 33, 0, public.classify_d100(38, 33, 0); end if;
  if public.classify_d100(38, 33, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 33, -10, public.classify_d100(38, 33, -10); end if;
  if public.classify_d100(38, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 33, 15, public.classify_d100(38, 33, 15); end if;
  if public.classify_d100(49, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 33, 0, public.classify_d100(49, 33, 0); end if;
  if public.classify_d100(49, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 33, -10, public.classify_d100(49, 33, -10); end if;
  if public.classify_d100(49, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 33, 15, public.classify_d100(49, 33, 15); end if;
  if public.classify_d100(50, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 33, 0, public.classify_d100(50, 33, 0); end if;
  if public.classify_d100(50, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 33, -10, public.classify_d100(50, 33, -10); end if;
  if public.classify_d100(50, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 33, 15, public.classify_d100(50, 33, 15); end if;
  if public.classify_d100(51, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 33, 0, public.classify_d100(51, 33, 0); end if;
  if public.classify_d100(51, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 33, -10, public.classify_d100(51, 33, -10); end if;
  if public.classify_d100(51, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 33, 15, public.classify_d100(51, 33, 15); end if;
  if public.classify_d100(60, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 33, 0, public.classify_d100(60, 33, 0); end if;
  if public.classify_d100(60, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 33, -10, public.classify_d100(60, 33, -10); end if;
  if public.classify_d100(60, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 33, 15, public.classify_d100(60, 33, 15); end if;
  if public.classify_d100(74, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 33, 0, public.classify_d100(74, 33, 0); end if;
  if public.classify_d100(74, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 33, -10, public.classify_d100(74, 33, -10); end if;
  if public.classify_d100(74, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 33, 15, public.classify_d100(74, 33, 15); end if;
  if public.classify_d100(75, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 33, 0, public.classify_d100(75, 33, 0); end if;
  if public.classify_d100(75, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 33, -10, public.classify_d100(75, 33, -10); end if;
  if public.classify_d100(75, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 33, 15, public.classify_d100(75, 33, 15); end if;
  if public.classify_d100(76, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 33, 0, public.classify_d100(76, 33, 0); end if;
  if public.classify_d100(76, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 33, -10, public.classify_d100(76, 33, -10); end if;
  if public.classify_d100(76, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 33, 15, public.classify_d100(76, 33, 15); end if;
  if public.classify_d100(95, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 33, 0, public.classify_d100(95, 33, 0); end if;
  if public.classify_d100(95, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 33, -10, public.classify_d100(95, 33, -10); end if;
  if public.classify_d100(95, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 33, 15, public.classify_d100(95, 33, 15); end if;
  if public.classify_d100(99, 33, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 33, 0, public.classify_d100(99, 33, 0); end if;
  if public.classify_d100(99, 33, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 33, -10, public.classify_d100(99, 33, -10); end if;
  if public.classify_d100(99, 33, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 33, 15, public.classify_d100(99, 33, 15); end if;
  if public.classify_d100(100, 33, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 33, 0, public.classify_d100(100, 33, 0); end if;
  if public.classify_d100(100, 33, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 33, -10, public.classify_d100(100, 33, -10); end if;
  if public.classify_d100(100, 33, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 33, 15, public.classify_d100(100, 33, 15); end if;
  if public.classify_d100(1, 50, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 50, 0, public.classify_d100(1, 50, 0); end if;
  if public.classify_d100(1, 50, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 50, -10, public.classify_d100(1, 50, -10); end if;
  if public.classify_d100(1, 50, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 50, 15, public.classify_d100(1, 50, 15); end if;
  if public.classify_d100(2, 50, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 50, 0, public.classify_d100(2, 50, 0); end if;
  if public.classify_d100(2, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 50, -10, public.classify_d100(2, 50, -10); end if;
  if public.classify_d100(2, 50, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 2, 50, 15, public.classify_d100(2, 50, 15); end if;
  if public.classify_d100(3, 50, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 50, 0, public.classify_d100(3, 50, 0); end if;
  if public.classify_d100(3, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 50, -10, public.classify_d100(3, 50, -10); end if;
  if public.classify_d100(3, 50, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 3, 50, 15, public.classify_d100(3, 50, 15); end if;
  if public.classify_d100(5, 50, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 50, 0, public.classify_d100(5, 50, 0); end if;
  if public.classify_d100(5, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 50, -10, public.classify_d100(5, 50, -10); end if;
  if public.classify_d100(5, 50, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 5, 50, 15, public.classify_d100(5, 50, 15); end if;
  if public.classify_d100(9, 50, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 50, 0, public.classify_d100(9, 50, 0); end if;
  if public.classify_d100(9, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 50, -10, public.classify_d100(9, 50, -10); end if;
  if public.classify_d100(9, 50, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 9, 50, 15, public.classify_d100(9, 50, 15); end if;
  if public.classify_d100(10, 50, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 50, 0, public.classify_d100(10, 50, 0); end if;
  if public.classify_d100(10, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 50, -10, public.classify_d100(10, 50, -10); end if;
  if public.classify_d100(10, 50, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 10, 50, 15, public.classify_d100(10, 50, 15); end if;
  if public.classify_d100(11, 50, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 11, 50, 0, public.classify_d100(11, 50, 0); end if;
  if public.classify_d100(11, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 50, -10, public.classify_d100(11, 50, -10); end if;
  if public.classify_d100(11, 50, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 11, 50, 15, public.classify_d100(11, 50, 15); end if;
  if public.classify_d100(12, 50, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 50, 0, public.classify_d100(12, 50, 0); end if;
  if public.classify_d100(12, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 50, -10, public.classify_d100(12, 50, -10); end if;
  if public.classify_d100(12, 50, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 12, 50, 15, public.classify_d100(12, 50, 15); end if;
  if public.classify_d100(16, 50, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 16, 50, 0, public.classify_d100(16, 50, 0); end if;
  if public.classify_d100(16, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 50, -10, public.classify_d100(16, 50, -10); end if;
  if public.classify_d100(16, 50, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 16, 50, 15, public.classify_d100(16, 50, 15); end if;
  if public.classify_d100(17, 50, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 17, 50, 0, public.classify_d100(17, 50, 0); end if;
  if public.classify_d100(17, 50, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 17, 50, -10, public.classify_d100(17, 50, -10); end if;
  if public.classify_d100(17, 50, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 17, 50, 15, public.classify_d100(17, 50, 15); end if;
  if public.classify_d100(25, 50, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 50, 0, public.classify_d100(25, 50, 0); end if;
  if public.classify_d100(25, 50, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 50, -10, public.classify_d100(25, 50, -10); end if;
  if public.classify_d100(25, 50, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 25, 50, 15, public.classify_d100(25, 50, 15); end if;
  if public.classify_d100(30, 50, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 30, 50, 0, public.classify_d100(30, 50, 0); end if;
  if public.classify_d100(30, 50, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 50, -10, public.classify_d100(30, 50, -10); end if;
  if public.classify_d100(30, 50, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 30, 50, 15, public.classify_d100(30, 50, 15); end if;
  if public.classify_d100(37, 50, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 37, 50, 0, public.classify_d100(37, 50, 0); end if;
  if public.classify_d100(37, 50, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 37, 50, -10, public.classify_d100(37, 50, -10); end if;
  if public.classify_d100(37, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 37, 50, 15, public.classify_d100(37, 50, 15); end if;
  if public.classify_d100(38, 50, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 50, 0, public.classify_d100(38, 50, 0); end if;
  if public.classify_d100(38, 50, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 50, -10, public.classify_d100(38, 50, -10); end if;
  if public.classify_d100(38, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 38, 50, 15, public.classify_d100(38, 50, 15); end if;
  if public.classify_d100(49, 50, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 50, 0, public.classify_d100(49, 50, 0); end if;
  if public.classify_d100(49, 50, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 50, -10, public.classify_d100(49, 50, -10); end if;
  if public.classify_d100(49, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 50, 15, public.classify_d100(49, 50, 15); end if;
  if public.classify_d100(50, 50, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 50, 0, public.classify_d100(50, 50, 0); end if;
  if public.classify_d100(50, 50, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 50, -10, public.classify_d100(50, 50, -10); end if;
  if public.classify_d100(50, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 50, 15, public.classify_d100(50, 50, 15); end if;
  if public.classify_d100(51, 50, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 50, 0, public.classify_d100(51, 50, 0); end if;
  if public.classify_d100(51, 50, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 50, -10, public.classify_d100(51, 50, -10); end if;
  if public.classify_d100(51, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 50, 15, public.classify_d100(51, 50, 15); end if;
  if public.classify_d100(60, 50, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 50, 0, public.classify_d100(60, 50, 0); end if;
  if public.classify_d100(60, 50, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 50, -10, public.classify_d100(60, 50, -10); end if;
  if public.classify_d100(60, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 50, 15, public.classify_d100(60, 50, 15); end if;
  if public.classify_d100(74, 50, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 50, 0, public.classify_d100(74, 50, 0); end if;
  if public.classify_d100(74, 50, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 50, -10, public.classify_d100(74, 50, -10); end if;
  if public.classify_d100(74, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 50, 15, public.classify_d100(74, 50, 15); end if;
  if public.classify_d100(75, 50, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 50, 0, public.classify_d100(75, 50, 0); end if;
  if public.classify_d100(75, 50, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 50, -10, public.classify_d100(75, 50, -10); end if;
  if public.classify_d100(75, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 50, 15, public.classify_d100(75, 50, 15); end if;
  if public.classify_d100(76, 50, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 50, 0, public.classify_d100(76, 50, 0); end if;
  if public.classify_d100(76, 50, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 50, -10, public.classify_d100(76, 50, -10); end if;
  if public.classify_d100(76, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 50, 15, public.classify_d100(76, 50, 15); end if;
  if public.classify_d100(95, 50, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 50, 0, public.classify_d100(95, 50, 0); end if;
  if public.classify_d100(95, 50, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 50, -10, public.classify_d100(95, 50, -10); end if;
  if public.classify_d100(95, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 50, 15, public.classify_d100(95, 50, 15); end if;
  if public.classify_d100(99, 50, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 50, 0, public.classify_d100(99, 50, 0); end if;
  if public.classify_d100(99, 50, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 50, -10, public.classify_d100(99, 50, -10); end if;
  if public.classify_d100(99, 50, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 50, 15, public.classify_d100(99, 50, 15); end if;
  if public.classify_d100(100, 50, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 50, 0, public.classify_d100(100, 50, 0); end if;
  if public.classify_d100(100, 50, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 50, -10, public.classify_d100(100, 50, -10); end if;
  if public.classify_d100(100, 50, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 50, 15, public.classify_d100(100, 50, 15); end if;
  if public.classify_d100(1, 60, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 60, 0, public.classify_d100(1, 60, 0); end if;
  if public.classify_d100(1, 60, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 60, -10, public.classify_d100(1, 60, -10); end if;
  if public.classify_d100(1, 60, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 60, 15, public.classify_d100(1, 60, 15); end if;
  if public.classify_d100(2, 60, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 60, 0, public.classify_d100(2, 60, 0); end if;
  if public.classify_d100(2, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 60, -10, public.classify_d100(2, 60, -10); end if;
  if public.classify_d100(2, 60, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 2, 60, 15, public.classify_d100(2, 60, 15); end if;
  if public.classify_d100(3, 60, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 60, 0, public.classify_d100(3, 60, 0); end if;
  if public.classify_d100(3, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 60, -10, public.classify_d100(3, 60, -10); end if;
  if public.classify_d100(3, 60, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 3, 60, 15, public.classify_d100(3, 60, 15); end if;
  if public.classify_d100(5, 60, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 60, 0, public.classify_d100(5, 60, 0); end if;
  if public.classify_d100(5, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 60, -10, public.classify_d100(5, 60, -10); end if;
  if public.classify_d100(5, 60, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 5, 60, 15, public.classify_d100(5, 60, 15); end if;
  if public.classify_d100(9, 60, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 60, 0, public.classify_d100(9, 60, 0); end if;
  if public.classify_d100(9, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 60, -10, public.classify_d100(9, 60, -10); end if;
  if public.classify_d100(9, 60, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 9, 60, 15, public.classify_d100(9, 60, 15); end if;
  if public.classify_d100(10, 60, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 60, 0, public.classify_d100(10, 60, 0); end if;
  if public.classify_d100(10, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 60, -10, public.classify_d100(10, 60, -10); end if;
  if public.classify_d100(10, 60, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 10, 60, 15, public.classify_d100(10, 60, 15); end if;
  if public.classify_d100(11, 60, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 60, 0, public.classify_d100(11, 60, 0); end if;
  if public.classify_d100(11, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 60, -10, public.classify_d100(11, 60, -10); end if;
  if public.classify_d100(11, 60, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 11, 60, 15, public.classify_d100(11, 60, 15); end if;
  if public.classify_d100(12, 60, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 60, 0, public.classify_d100(12, 60, 0); end if;
  if public.classify_d100(12, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 60, -10, public.classify_d100(12, 60, -10); end if;
  if public.classify_d100(12, 60, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 60, 15, public.classify_d100(12, 60, 15); end if;
  if public.classify_d100(16, 60, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 16, 60, 0, public.classify_d100(16, 60, 0); end if;
  if public.classify_d100(16, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 60, -10, public.classify_d100(16, 60, -10); end if;
  if public.classify_d100(16, 60, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 16, 60, 15, public.classify_d100(16, 60, 15); end if;
  if public.classify_d100(17, 60, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 17, 60, 0, public.classify_d100(17, 60, 0); end if;
  if public.classify_d100(17, 60, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 17, 60, -10, public.classify_d100(17, 60, -10); end if;
  if public.classify_d100(17, 60, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 17, 60, 15, public.classify_d100(17, 60, 15); end if;
  if public.classify_d100(25, 60, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 60, 0, public.classify_d100(25, 60, 0); end if;
  if public.classify_d100(25, 60, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 60, -10, public.classify_d100(25, 60, -10); end if;
  if public.classify_d100(25, 60, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 25, 60, 15, public.classify_d100(25, 60, 15); end if;
  if public.classify_d100(30, 60, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 60, 0, public.classify_d100(30, 60, 0); end if;
  if public.classify_d100(30, 60, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 60, -10, public.classify_d100(30, 60, -10); end if;
  if public.classify_d100(30, 60, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 30, 60, 15, public.classify_d100(30, 60, 15); end if;
  if public.classify_d100(37, 60, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 37, 60, 0, public.classify_d100(37, 60, 0); end if;
  if public.classify_d100(37, 60, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 60, -10, public.classify_d100(37, 60, -10); end if;
  if public.classify_d100(37, 60, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 37, 60, 15, public.classify_d100(37, 60, 15); end if;
  if public.classify_d100(38, 60, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 60, 0, public.classify_d100(38, 60, 0); end if;
  if public.classify_d100(38, 60, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 38, 60, -10, public.classify_d100(38, 60, -10); end if;
  if public.classify_d100(38, 60, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 60, 15, public.classify_d100(38, 60, 15); end if;
  if public.classify_d100(49, 60, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 60, 0, public.classify_d100(49, 60, 0); end if;
  if public.classify_d100(49, 60, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 60, -10, public.classify_d100(49, 60, -10); end if;
  if public.classify_d100(49, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 49, 60, 15, public.classify_d100(49, 60, 15); end if;
  if public.classify_d100(50, 60, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 60, 0, public.classify_d100(50, 60, 0); end if;
  if public.classify_d100(50, 60, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 60, -10, public.classify_d100(50, 60, -10); end if;
  if public.classify_d100(50, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 50, 60, 15, public.classify_d100(50, 60, 15); end if;
  if public.classify_d100(51, 60, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 60, 0, public.classify_d100(51, 60, 0); end if;
  if public.classify_d100(51, 60, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 60, -10, public.classify_d100(51, 60, -10); end if;
  if public.classify_d100(51, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 51, 60, 15, public.classify_d100(51, 60, 15); end if;
  if public.classify_d100(60, 60, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 60, 0, public.classify_d100(60, 60, 0); end if;
  if public.classify_d100(60, 60, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 60, -10, public.classify_d100(60, 60, -10); end if;
  if public.classify_d100(60, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 60, 60, 15, public.classify_d100(60, 60, 15); end if;
  if public.classify_d100(74, 60, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 60, 0, public.classify_d100(74, 60, 0); end if;
  if public.classify_d100(74, 60, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 60, -10, public.classify_d100(74, 60, -10); end if;
  if public.classify_d100(74, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 60, 15, public.classify_d100(74, 60, 15); end if;
  if public.classify_d100(75, 60, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 60, 0, public.classify_d100(75, 60, 0); end if;
  if public.classify_d100(75, 60, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 60, -10, public.classify_d100(75, 60, -10); end if;
  if public.classify_d100(75, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 60, 15, public.classify_d100(75, 60, 15); end if;
  if public.classify_d100(76, 60, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 60, 0, public.classify_d100(76, 60, 0); end if;
  if public.classify_d100(76, 60, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 60, -10, public.classify_d100(76, 60, -10); end if;
  if public.classify_d100(76, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 60, 15, public.classify_d100(76, 60, 15); end if;
  if public.classify_d100(95, 60, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 60, 0, public.classify_d100(95, 60, 0); end if;
  if public.classify_d100(95, 60, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 60, -10, public.classify_d100(95, 60, -10); end if;
  if public.classify_d100(95, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 60, 15, public.classify_d100(95, 60, 15); end if;
  if public.classify_d100(99, 60, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 60, 0, public.classify_d100(99, 60, 0); end if;
  if public.classify_d100(99, 60, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 60, -10, public.classify_d100(99, 60, -10); end if;
  if public.classify_d100(99, 60, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 60, 15, public.classify_d100(99, 60, 15); end if;
  if public.classify_d100(100, 60, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 60, 0, public.classify_d100(100, 60, 0); end if;
  if public.classify_d100(100, 60, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 60, -10, public.classify_d100(100, 60, -10); end if;
  if public.classify_d100(100, 60, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 60, 15, public.classify_d100(100, 60, 15); end if;
  if public.classify_d100(1, 75, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 75, 0, public.classify_d100(1, 75, 0); end if;
  if public.classify_d100(1, 75, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 75, -10, public.classify_d100(1, 75, -10); end if;
  if public.classify_d100(1, 75, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 75, 15, public.classify_d100(1, 75, 15); end if;
  if public.classify_d100(2, 75, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 75, 0, public.classify_d100(2, 75, 0); end if;
  if public.classify_d100(2, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 75, -10, public.classify_d100(2, 75, -10); end if;
  if public.classify_d100(2, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 2, 75, 15, public.classify_d100(2, 75, 15); end if;
  if public.classify_d100(3, 75, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 75, 0, public.classify_d100(3, 75, 0); end if;
  if public.classify_d100(3, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 75, -10, public.classify_d100(3, 75, -10); end if;
  if public.classify_d100(3, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 3, 75, 15, public.classify_d100(3, 75, 15); end if;
  if public.classify_d100(5, 75, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 75, 0, public.classify_d100(5, 75, 0); end if;
  if public.classify_d100(5, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 75, -10, public.classify_d100(5, 75, -10); end if;
  if public.classify_d100(5, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 5, 75, 15, public.classify_d100(5, 75, 15); end if;
  if public.classify_d100(9, 75, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 75, 0, public.classify_d100(9, 75, 0); end if;
  if public.classify_d100(9, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 75, -10, public.classify_d100(9, 75, -10); end if;
  if public.classify_d100(9, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 9, 75, 15, public.classify_d100(9, 75, 15); end if;
  if public.classify_d100(10, 75, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 75, 0, public.classify_d100(10, 75, 0); end if;
  if public.classify_d100(10, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 75, -10, public.classify_d100(10, 75, -10); end if;
  if public.classify_d100(10, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 10, 75, 15, public.classify_d100(10, 75, 15); end if;
  if public.classify_d100(11, 75, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 75, 0, public.classify_d100(11, 75, 0); end if;
  if public.classify_d100(11, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 75, -10, public.classify_d100(11, 75, -10); end if;
  if public.classify_d100(11, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 11, 75, 15, public.classify_d100(11, 75, 15); end if;
  if public.classify_d100(12, 75, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 75, 0, public.classify_d100(12, 75, 0); end if;
  if public.classify_d100(12, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 75, -10, public.classify_d100(12, 75, -10); end if;
  if public.classify_d100(12, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 75, 15, public.classify_d100(12, 75, 15); end if;
  if public.classify_d100(16, 75, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 16, 75, 0, public.classify_d100(16, 75, 0); end if;
  if public.classify_d100(16, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 75, -10, public.classify_d100(16, 75, -10); end if;
  if public.classify_d100(16, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 16, 75, 15, public.classify_d100(16, 75, 15); end if;
  if public.classify_d100(17, 75, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 17, 75, 0, public.classify_d100(17, 75, 0); end if;
  if public.classify_d100(17, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 17, 75, -10, public.classify_d100(17, 75, -10); end if;
  if public.classify_d100(17, 75, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 17, 75, 15, public.classify_d100(17, 75, 15); end if;
  if public.classify_d100(25, 75, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 75, 0, public.classify_d100(25, 75, 0); end if;
  if public.classify_d100(25, 75, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 25, 75, -10, public.classify_d100(25, 75, -10); end if;
  if public.classify_d100(25, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 25, 75, 15, public.classify_d100(25, 75, 15); end if;
  if public.classify_d100(30, 75, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 75, 0, public.classify_d100(30, 75, 0); end if;
  if public.classify_d100(30, 75, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 75, -10, public.classify_d100(30, 75, -10); end if;
  if public.classify_d100(30, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 30, 75, 15, public.classify_d100(30, 75, 15); end if;
  if public.classify_d100(37, 75, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 75, 0, public.classify_d100(37, 75, 0); end if;
  if public.classify_d100(37, 75, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 75, -10, public.classify_d100(37, 75, -10); end if;
  if public.classify_d100(37, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 37, 75, 15, public.classify_d100(37, 75, 15); end if;
  if public.classify_d100(38, 75, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 75, 0, public.classify_d100(38, 75, 0); end if;
  if public.classify_d100(38, 75, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 38, 75, -10, public.classify_d100(38, 75, -10); end if;
  if public.classify_d100(38, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 75, 15, public.classify_d100(38, 75, 15); end if;
  if public.classify_d100(49, 75, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 75, 0, public.classify_d100(49, 75, 0); end if;
  if public.classify_d100(49, 75, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 75, -10, public.classify_d100(49, 75, -10); end if;
  if public.classify_d100(49, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 75, 15, public.classify_d100(49, 75, 15); end if;
  if public.classify_d100(50, 75, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 75, 0, public.classify_d100(50, 75, 0); end if;
  if public.classify_d100(50, 75, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 75, -10, public.classify_d100(50, 75, -10); end if;
  if public.classify_d100(50, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 75, 15, public.classify_d100(50, 75, 15); end if;
  if public.classify_d100(51, 75, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 75, 0, public.classify_d100(51, 75, 0); end if;
  if public.classify_d100(51, 75, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 75, -10, public.classify_d100(51, 75, -10); end if;
  if public.classify_d100(51, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 75, 15, public.classify_d100(51, 75, 15); end if;
  if public.classify_d100(60, 75, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 75, 0, public.classify_d100(60, 75, 0); end if;
  if public.classify_d100(60, 75, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 75, -10, public.classify_d100(60, 75, -10); end if;
  if public.classify_d100(60, 75, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 75, 15, public.classify_d100(60, 75, 15); end if;
  if public.classify_d100(74, 75, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 75, 0, public.classify_d100(74, 75, 0); end if;
  if public.classify_d100(74, 75, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 75, -10, public.classify_d100(74, 75, -10); end if;
  if public.classify_d100(74, 75, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 74, 75, 15, public.classify_d100(74, 75, 15); end if;
  if public.classify_d100(75, 75, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 75, 0, public.classify_d100(75, 75, 0); end if;
  if public.classify_d100(75, 75, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 75, -10, public.classify_d100(75, 75, -10); end if;
  if public.classify_d100(75, 75, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 75, 75, 15, public.classify_d100(75, 75, 15); end if;
  if public.classify_d100(76, 75, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 75, 0, public.classify_d100(76, 75, 0); end if;
  if public.classify_d100(76, 75, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 76, 75, -10, public.classify_d100(76, 75, -10); end if;
  if public.classify_d100(76, 75, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 76, 75, 15, public.classify_d100(76, 75, 15); end if;
  if public.classify_d100(95, 75, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 75, 0, public.classify_d100(95, 75, 0); end if;
  if public.classify_d100(95, 75, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 75, -10, public.classify_d100(95, 75, -10); end if;
  if public.classify_d100(95, 75, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 75, 15, public.classify_d100(95, 75, 15); end if;
  if public.classify_d100(99, 75, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 75, 0, public.classify_d100(99, 75, 0); end if;
  if public.classify_d100(99, 75, -10) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 75, -10, public.classify_d100(99, 75, -10); end if;
  if public.classify_d100(99, 75, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 75, 15, public.classify_d100(99, 75, 15); end if;
  if public.classify_d100(100, 75, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 75, 0, public.classify_d100(100, 75, 0); end if;
  if public.classify_d100(100, 75, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 75, -10, public.classify_d100(100, 75, -10); end if;
  if public.classify_d100(100, 75, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 75, 15, public.classify_d100(100, 75, 15); end if;
  if public.classify_d100(1, 95, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 95, 0, public.classify_d100(1, 95, 0); end if;
  if public.classify_d100(1, 95, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 95, -10, public.classify_d100(1, 95, -10); end if;
  if public.classify_d100(1, 95, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 95, 15, public.classify_d100(1, 95, 15); end if;
  if public.classify_d100(2, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 95, 0, public.classify_d100(2, 95, 0); end if;
  if public.classify_d100(2, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 95, -10, public.classify_d100(2, 95, -10); end if;
  if public.classify_d100(2, 95, 15) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 95, 15, public.classify_d100(2, 95, 15); end if;
  if public.classify_d100(3, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 95, 0, public.classify_d100(3, 95, 0); end if;
  if public.classify_d100(3, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 95, -10, public.classify_d100(3, 95, -10); end if;
  if public.classify_d100(3, 95, 15) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 95, 15, public.classify_d100(3, 95, 15); end if;
  if public.classify_d100(5, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 95, 0, public.classify_d100(5, 95, 0); end if;
  if public.classify_d100(5, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 95, -10, public.classify_d100(5, 95, -10); end if;
  if public.classify_d100(5, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 5, 95, 15, public.classify_d100(5, 95, 15); end if;
  if public.classify_d100(9, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 95, 0, public.classify_d100(9, 95, 0); end if;
  if public.classify_d100(9, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 95, -10, public.classify_d100(9, 95, -10); end if;
  if public.classify_d100(9, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 9, 95, 15, public.classify_d100(9, 95, 15); end if;
  if public.classify_d100(10, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 95, 0, public.classify_d100(10, 95, 0); end if;
  if public.classify_d100(10, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 95, -10, public.classify_d100(10, 95, -10); end if;
  if public.classify_d100(10, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 10, 95, 15, public.classify_d100(10, 95, 15); end if;
  if public.classify_d100(11, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 95, 0, public.classify_d100(11, 95, 0); end if;
  if public.classify_d100(11, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 95, -10, public.classify_d100(11, 95, -10); end if;
  if public.classify_d100(11, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 11, 95, 15, public.classify_d100(11, 95, 15); end if;
  if public.classify_d100(12, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 95, 0, public.classify_d100(12, 95, 0); end if;
  if public.classify_d100(12, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 95, -10, public.classify_d100(12, 95, -10); end if;
  if public.classify_d100(12, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 95, 15, public.classify_d100(12, 95, 15); end if;
  if public.classify_d100(16, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 95, 0, public.classify_d100(16, 95, 0); end if;
  if public.classify_d100(16, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 95, -10, public.classify_d100(16, 95, -10); end if;
  if public.classify_d100(16, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 16, 95, 15, public.classify_d100(16, 95, 15); end if;
  if public.classify_d100(17, 95, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 17, 95, 0, public.classify_d100(17, 95, 0); end if;
  if public.classify_d100(17, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 17, 95, -10, public.classify_d100(17, 95, -10); end if;
  if public.classify_d100(17, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 17, 95, 15, public.classify_d100(17, 95, 15); end if;
  if public.classify_d100(25, 95, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 95, 0, public.classify_d100(25, 95, 0); end if;
  if public.classify_d100(25, 95, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 25, 95, -10, public.classify_d100(25, 95, -10); end if;
  if public.classify_d100(25, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 95, 15, public.classify_d100(25, 95, 15); end if;
  if public.classify_d100(30, 95, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 95, 0, public.classify_d100(30, 95, 0); end if;
  if public.classify_d100(30, 95, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 95, -10, public.classify_d100(30, 95, -10); end if;
  if public.classify_d100(30, 95, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 95, 15, public.classify_d100(30, 95, 15); end if;
  if public.classify_d100(37, 95, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 95, 0, public.classify_d100(37, 95, 0); end if;
  if public.classify_d100(37, 95, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 95, -10, public.classify_d100(37, 95, -10); end if;
  if public.classify_d100(37, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 37, 95, 15, public.classify_d100(37, 95, 15); end if;
  if public.classify_d100(38, 95, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 38, 95, 0, public.classify_d100(38, 95, 0); end if;
  if public.classify_d100(38, 95, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 38, 95, -10, public.classify_d100(38, 95, -10); end if;
  if public.classify_d100(38, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 38, 95, 15, public.classify_d100(38, 95, 15); end if;
  if public.classify_d100(49, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 95, 0, public.classify_d100(49, 95, 0); end if;
  if public.classify_d100(49, 95, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 49, 95, -10, public.classify_d100(49, 95, -10); end if;
  if public.classify_d100(49, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 95, 15, public.classify_d100(49, 95, 15); end if;
  if public.classify_d100(50, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 95, 0, public.classify_d100(50, 95, 0); end if;
  if public.classify_d100(50, 95, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 50, 95, -10, public.classify_d100(50, 95, -10); end if;
  if public.classify_d100(50, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 95, 15, public.classify_d100(50, 95, 15); end if;
  if public.classify_d100(51, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 95, 0, public.classify_d100(51, 95, 0); end if;
  if public.classify_d100(51, 95, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 51, 95, -10, public.classify_d100(51, 95, -10); end if;
  if public.classify_d100(51, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 95, 15, public.classify_d100(51, 95, 15); end if;
  if public.classify_d100(60, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 95, 0, public.classify_d100(60, 95, 0); end if;
  if public.classify_d100(60, 95, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 95, -10, public.classify_d100(60, 95, -10); end if;
  if public.classify_d100(60, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 95, 15, public.classify_d100(60, 95, 15); end if;
  if public.classify_d100(74, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 95, 0, public.classify_d100(74, 95, 0); end if;
  if public.classify_d100(74, 95, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 95, -10, public.classify_d100(74, 95, -10); end if;
  if public.classify_d100(74, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 95, 15, public.classify_d100(74, 95, 15); end if;
  if public.classify_d100(75, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 95, 0, public.classify_d100(75, 95, 0); end if;
  if public.classify_d100(75, 95, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 95, -10, public.classify_d100(75, 95, -10); end if;
  if public.classify_d100(75, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 95, 15, public.classify_d100(75, 95, 15); end if;
  if public.classify_d100(76, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 76, 95, 0, public.classify_d100(76, 95, 0); end if;
  if public.classify_d100(76, 95, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 76, 95, -10, public.classify_d100(76, 95, -10); end if;
  if public.classify_d100(76, 95, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 76, 95, 15, public.classify_d100(76, 95, 15); end if;
  if public.classify_d100(95, 95, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 95, 95, 0, public.classify_d100(95, 95, 0); end if;
  if public.classify_d100(95, 95, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 95, 95, -10, public.classify_d100(95, 95, -10); end if;
  if public.classify_d100(95, 95, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 95, 95, 15, public.classify_d100(95, 95, 15); end if;
  if public.classify_d100(99, 95, 0) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 95, 0, public.classify_d100(99, 95, 0); end if;
  if public.classify_d100(99, 95, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 99, 95, -10, public.classify_d100(99, 95, -10); end if;
  if public.classify_d100(99, 95, 15) <> 'failure' then raise exception 'classify % % %: banco % / motor failure', 99, 95, 15, public.classify_d100(99, 95, 15); end if;
  if public.classify_d100(100, 95, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 95, 0, public.classify_d100(100, 95, 0); end if;
  if public.classify_d100(100, 95, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 95, -10, public.classify_d100(100, 95, -10); end if;
  if public.classify_d100(100, 95, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 95, 15, public.classify_d100(100, 95, 15); end if;
  if public.classify_d100(1, 120, 0) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 120, 0, public.classify_d100(1, 120, 0); end if;
  if public.classify_d100(1, 120, -10) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 120, -10, public.classify_d100(1, 120, -10); end if;
  if public.classify_d100(1, 120, 15) <> 'critical_success' then raise exception 'classify % % %: banco % / motor critical_success', 1, 120, 15, public.classify_d100(1, 120, 15); end if;
  if public.classify_d100(2, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 120, 0, public.classify_d100(2, 120, 0); end if;
  if public.classify_d100(2, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 120, -10, public.classify_d100(2, 120, -10); end if;
  if public.classify_d100(2, 120, 15) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 2, 120, 15, public.classify_d100(2, 120, 15); end if;
  if public.classify_d100(3, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 120, 0, public.classify_d100(3, 120, 0); end if;
  if public.classify_d100(3, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 120, -10, public.classify_d100(3, 120, -10); end if;
  if public.classify_d100(3, 120, 15) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 3, 120, 15, public.classify_d100(3, 120, 15); end if;
  if public.classify_d100(5, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 120, 0, public.classify_d100(5, 120, 0); end if;
  if public.classify_d100(5, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 120, -10, public.classify_d100(5, 120, -10); end if;
  if public.classify_d100(5, 120, 15) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 5, 120, 15, public.classify_d100(5, 120, 15); end if;
  if public.classify_d100(9, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 120, 0, public.classify_d100(9, 120, 0); end if;
  if public.classify_d100(9, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 120, -10, public.classify_d100(9, 120, -10); end if;
  if public.classify_d100(9, 120, 15) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 9, 120, 15, public.classify_d100(9, 120, 15); end if;
  if public.classify_d100(10, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 120, 0, public.classify_d100(10, 120, 0); end if;
  if public.classify_d100(10, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 10, 120, -10, public.classify_d100(10, 120, -10); end if;
  if public.classify_d100(10, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 10, 120, 15, public.classify_d100(10, 120, 15); end if;
  if public.classify_d100(11, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 120, 0, public.classify_d100(11, 120, 0); end if;
  if public.classify_d100(11, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 11, 120, -10, public.classify_d100(11, 120, -10); end if;
  if public.classify_d100(11, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 11, 120, 15, public.classify_d100(11, 120, 15); end if;
  if public.classify_d100(12, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 120, 0, public.classify_d100(12, 120, 0); end if;
  if public.classify_d100(12, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 12, 120, -10, public.classify_d100(12, 120, -10); end if;
  if public.classify_d100(12, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 12, 120, 15, public.classify_d100(12, 120, 15); end if;
  if public.classify_d100(16, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 120, 0, public.classify_d100(16, 120, 0); end if;
  if public.classify_d100(16, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 16, 120, -10, public.classify_d100(16, 120, -10); end if;
  if public.classify_d100(16, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 16, 120, 15, public.classify_d100(16, 120, 15); end if;
  if public.classify_d100(17, 120, 0) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 17, 120, 0, public.classify_d100(17, 120, 0); end if;
  if public.classify_d100(17, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 17, 120, -10, public.classify_d100(17, 120, -10); end if;
  if public.classify_d100(17, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 17, 120, 15, public.classify_d100(17, 120, 15); end if;
  if public.classify_d100(25, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 120, 0, public.classify_d100(25, 120, 0); end if;
  if public.classify_d100(25, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 25, 120, -10, public.classify_d100(25, 120, -10); end if;
  if public.classify_d100(25, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 25, 120, 15, public.classify_d100(25, 120, 15); end if;
  if public.classify_d100(30, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 120, 0, public.classify_d100(30, 120, 0); end if;
  if public.classify_d100(30, 120, -10) <> 'extreme' then raise exception 'classify % % %: banco % / motor extreme', 30, 120, -10, public.classify_d100(30, 120, -10); end if;
  if public.classify_d100(30, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 30, 120, 15, public.classify_d100(30, 120, 15); end if;
  if public.classify_d100(37, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 120, 0, public.classify_d100(37, 120, 0); end if;
  if public.classify_d100(37, 120, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 120, -10, public.classify_d100(37, 120, -10); end if;
  if public.classify_d100(37, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 37, 120, 15, public.classify_d100(37, 120, 15); end if;
  if public.classify_d100(38, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 38, 120, 0, public.classify_d100(38, 120, 0); end if;
  if public.classify_d100(38, 120, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 38, 120, -10, public.classify_d100(38, 120, -10); end if;
  if public.classify_d100(38, 120, 15) <> 'good' then raise exception 'classify % % %: banco % / motor good', 38, 120, 15, public.classify_d100(38, 120, 15); end if;
  if public.classify_d100(49, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 49, 120, 0, public.classify_d100(49, 120, 0); end if;
  if public.classify_d100(49, 120, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 49, 120, -10, public.classify_d100(49, 120, -10); end if;
  if public.classify_d100(49, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 49, 120, 15, public.classify_d100(49, 120, 15); end if;
  if public.classify_d100(50, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 50, 120, 0, public.classify_d100(50, 120, 0); end if;
  if public.classify_d100(50, 120, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 50, 120, -10, public.classify_d100(50, 120, -10); end if;
  if public.classify_d100(50, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 50, 120, 15, public.classify_d100(50, 120, 15); end if;
  if public.classify_d100(51, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 51, 120, 0, public.classify_d100(51, 120, 0); end if;
  if public.classify_d100(51, 120, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 51, 120, -10, public.classify_d100(51, 120, -10); end if;
  if public.classify_d100(51, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 51, 120, 15, public.classify_d100(51, 120, 15); end if;
  if public.classify_d100(60, 120, 0) <> 'good' then raise exception 'classify % % %: banco % / motor good', 60, 120, 0, public.classify_d100(60, 120, 0); end if;
  if public.classify_d100(60, 120, -10) <> 'good' then raise exception 'classify % % %: banco % / motor good', 60, 120, -10, public.classify_d100(60, 120, -10); end if;
  if public.classify_d100(60, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 60, 120, 15, public.classify_d100(60, 120, 15); end if;
  if public.classify_d100(74, 120, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 120, 0, public.classify_d100(74, 120, 0); end if;
  if public.classify_d100(74, 120, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 120, -10, public.classify_d100(74, 120, -10); end if;
  if public.classify_d100(74, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 74, 120, 15, public.classify_d100(74, 120, 15); end if;
  if public.classify_d100(75, 120, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 120, 0, public.classify_d100(75, 120, 0); end if;
  if public.classify_d100(75, 120, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 120, -10, public.classify_d100(75, 120, -10); end if;
  if public.classify_d100(75, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 75, 120, 15, public.classify_d100(75, 120, 15); end if;
  if public.classify_d100(76, 120, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 76, 120, 0, public.classify_d100(76, 120, 0); end if;
  if public.classify_d100(76, 120, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 76, 120, -10, public.classify_d100(76, 120, -10); end if;
  if public.classify_d100(76, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 76, 120, 15, public.classify_d100(76, 120, 15); end if;
  if public.classify_d100(95, 120, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 95, 120, 0, public.classify_d100(95, 120, 0); end if;
  if public.classify_d100(95, 120, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 95, 120, -10, public.classify_d100(95, 120, -10); end if;
  if public.classify_d100(95, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 95, 120, 15, public.classify_d100(95, 120, 15); end if;
  if public.classify_d100(99, 120, 0) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 99, 120, 0, public.classify_d100(99, 120, 0); end if;
  if public.classify_d100(99, 120, -10) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 99, 120, -10, public.classify_d100(99, 120, -10); end if;
  if public.classify_d100(99, 120, 15) <> 'normal' then raise exception 'classify % % %: banco % / motor normal', 99, 120, 15, public.classify_d100(99, 120, 15); end if;
  if public.classify_d100(100, 120, 0) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 120, 0, public.classify_d100(100, 120, 0); end if;
  if public.classify_d100(100, 120, -10) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 120, -10, public.classify_d100(100, 120, -10); end if;
  if public.classify_d100(100, 120, 15) <> 'critical_failure' then raise exception 'classify % % %: banco % / motor critical_failure', 100, 120, 15, public.classify_d100(100, 120, 15); end if;
  r := public.confront_outcome(1, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 2 then
    raise exception 'confronto 1×1 50/50 true/false: banco % / motor attacker player critical_success 2', r;
  end if;
  r := public.confront_outcome(1, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×1 50/50 false/true: banco % / motor defender player critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×1 50/50 true/true: banco % / motor reroll reroll critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×1 50/50 false/false: banco % / motor reroll reroll critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 2 then
    raise exception 'confronto 1×1 85/40 true/false: banco % / motor attacker player critical_success 2', r;
  end if;
  r := public.confront_outcome(1, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×1 85/40 false/true: banco % / motor defender player critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 2 then
    raise exception 'confronto 1×1 85/40 true/true: banco % / motor attacker skill critical_success 2', r;
  end if;
  r := public.confront_outcome(1, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 2 then
    raise exception 'confronto 1×1 85/40 false/false: banco % / motor attacker skill critical_success 2', r;
  end if;
  r := public.confront_outcome(1, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 2 then
    raise exception 'confronto 1×1 40/85 true/false: banco % / motor attacker player critical_success 2', r;
  end if;
  r := public.confront_outcome(1, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×1 40/85 false/true: banco % / motor defender player critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×1 40/85 true/true: banco % / motor defender skill critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×1 40/85 false/false: banco % / motor defender skill critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×2 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×9 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×17 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×34 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×50 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×51 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×75 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×99 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 50/50 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 50/50 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 50/50 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 50/50 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 85/40 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 85/40 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 85/40 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 85/40 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 40/85 true/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 40/85 false/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 40/85 true/true: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(1, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_success' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 1×100 40/85 false/false: banco % / motor defender none critical_success 0', r;
  end if;
  r := public.confront_outcome(2, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 50/50 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 50/50 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 50/50 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 50/50 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 85/40 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 85/40 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 85/40 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 85/40 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 40/85 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 40/85 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 40/85 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×1 40/85 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×2 50/50 true/false: banco % / motor attacker player extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×2 50/50 false/true: banco % / motor defender player extreme 0', r;
  end if;
  r := public.confront_outcome(2, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×2 50/50 true/true: banco % / motor reroll reroll extreme 0', r;
  end if;
  r := public.confront_outcome(2, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×2 50/50 false/false: banco % / motor reroll reroll extreme 0', r;
  end if;
  r := public.confront_outcome(2, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×2 85/40 true/false: banco % / motor attacker player extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×2 85/40 false/true: banco % / motor defender player extreme 0', r;
  end if;
  r := public.confront_outcome(2, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×2 85/40 true/true: banco % / motor attacker skill extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×2 85/40 false/false: banco % / motor attacker skill extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 2×2 40/85 true/false: banco % / motor attacker player extreme 1.5', r;
  end if;
  r := public.confront_outcome(2, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×2 40/85 false/true: banco % / motor defender player extreme 0', r;
  end if;
  r := public.confront_outcome(2, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×2 40/85 true/true: banco % / motor defender skill extreme 0', r;
  end if;
  r := public.confront_outcome(2, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×2 40/85 false/false: banco % / motor defender skill extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×9 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×17 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×34 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×50 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×51 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×75 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×99 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 40/85 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 40/85 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 40/85 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(2, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 2×100 40/85 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 50/50 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 50/50 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 50/50 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 50/50 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 85/40 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 85/40 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 85/40 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×1 85/40 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×1 40/85 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×1 40/85 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×1 40/85 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×1 40/85 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 50/50 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 50/50 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 50/50 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 50/50 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 85/40 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 85/40 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 85/40 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×2 85/40 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×2 40/85 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×2 40/85 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×2 40/85 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×2 40/85 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(9, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×9 50/50 true/false: banco % / motor attacker player extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×9 50/50 false/true: banco % / motor defender player extreme 0', r;
  end if;
  r := public.confront_outcome(9, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×9 50/50 true/true: banco % / motor reroll reroll extreme 0', r;
  end if;
  r := public.confront_outcome(9, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×9 50/50 false/false: banco % / motor reroll reroll extreme 0', r;
  end if;
  r := public.confront_outcome(9, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×9 85/40 true/false: banco % / motor attacker player extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×9 85/40 false/true: banco % / motor defender player extreme 0', r;
  end if;
  r := public.confront_outcome(9, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×9 85/40 true/true: banco % / motor attacker skill extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 9×9 85/40 false/false: banco % / motor attacker skill extreme 1.5', r;
  end if;
  r := public.confront_outcome(9, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 9×9 40/85 true/false: banco % / motor attacker player good 1', r;
  end if;
  r := public.confront_outcome(9, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×9 40/85 false/true: banco % / motor defender player good 0', r;
  end if;
  r := public.confront_outcome(9, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×9 40/85 true/true: banco % / motor defender skill good 0', r;
  end if;
  r := public.confront_outcome(9, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×9 40/85 false/false: banco % / motor defender skill good 0', r;
  end if;
  r := public.confront_outcome(9, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×17 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×34 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×50 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×51 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×75 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×99 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 50/50 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 50/50 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 50/50 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 50/50 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(9, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(9, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 9×100 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 50/50 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 50/50 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 50/50 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 50/50 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×1 85/40 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×1 85/40 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×1 85/40 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×1 85/40 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 40/85 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 40/85 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 40/85 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×1 40/85 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 50/50 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 50/50 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 50/50 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 50/50 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×2 85/40 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×2 85/40 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×2 85/40 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×2 85/40 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 40/85 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 40/85 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 40/85 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×2 40/85 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 50/50 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 50/50 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 50/50 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 50/50 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×9 85/40 true/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×9 85/40 false/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×9 85/40 true/true: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×9 85/40 false/false: banco % / motor attacker none extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 40/85 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 40/85 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 40/85 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×9 40/85 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(17, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×17 50/50 true/false: banco % / motor attacker player good 1', r;
  end if;
  r := public.confront_outcome(17, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×17 50/50 false/true: banco % / motor defender player good 0', r;
  end if;
  r := public.confront_outcome(17, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×17 50/50 true/true: banco % / motor reroll reroll good 0', r;
  end if;
  r := public.confront_outcome(17, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×17 50/50 false/false: banco % / motor reroll reroll good 0', r;
  end if;
  r := public.confront_outcome(17, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×17 85/40 true/false: banco % / motor attacker player extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×17 85/40 false/true: banco % / motor defender player extreme 0', r;
  end if;
  r := public.confront_outcome(17, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×17 85/40 true/true: banco % / motor attacker skill extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1.5 then
    raise exception 'confronto 17×17 85/40 false/false: banco % / motor attacker skill extreme 1.5', r;
  end if;
  r := public.confront_outcome(17, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 17×17 40/85 true/false: banco % / motor attacker player good 1', r;
  end if;
  r := public.confront_outcome(17, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×17 40/85 false/true: banco % / motor defender player good 0', r;
  end if;
  r := public.confront_outcome(17, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×17 40/85 true/true: banco % / motor defender skill good 0', r;
  end if;
  r := public.confront_outcome(17, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×17 40/85 false/false: banco % / motor defender skill good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 50/50 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 50/50 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 50/50 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 50/50 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×34 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 50/50 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 50/50 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 50/50 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 50/50 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×50 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 50/50 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 50/50 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 50/50 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 50/50 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×51 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 50/50 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 50/50 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 50/50 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 50/50 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×75 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 50/50 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 50/50 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 50/50 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 50/50 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×99 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 50/50 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 50/50 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 50/50 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 50/50 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 85/40 true/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 85/40 false/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 85/40 true/true: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'extreme' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 85/40 false/false: banco % / motor defender none extreme 0', r;
  end if;
  r := public.confront_outcome(17, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 40/85 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 40/85 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 40/85 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(17, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 17×100 40/85 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 85/40 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 85/40 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 85/40 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 85/40 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 40/85 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 40/85 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 40/85 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×1 40/85 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 85/40 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 85/40 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 85/40 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 85/40 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 40/85 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 40/85 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 40/85 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×2 40/85 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 85/40 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 85/40 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 85/40 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 85/40 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 40/85 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 40/85 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 40/85 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×9 40/85 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 85/40 true/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 85/40 false/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 85/40 true/true: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 85/40 false/false: banco % / motor attacker none good 1', r;
  end if;
  r := public.confront_outcome(34, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 40/85 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 40/85 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 40/85 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×17 40/85 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(34, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×34 50/50 true/false: banco % / motor attacker player normal 1', r;
  end if;
  r := public.confront_outcome(34, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×34 50/50 false/true: banco % / motor defender player normal 0', r;
  end if;
  r := public.confront_outcome(34, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×34 50/50 true/true: banco % / motor reroll reroll normal 0', r;
  end if;
  r := public.confront_outcome(34, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×34 50/50 false/false: banco % / motor reroll reroll normal 0', r;
  end if;
  r := public.confront_outcome(34, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×34 85/40 true/false: banco % / motor attacker player good 1', r;
  end if;
  r := public.confront_outcome(34, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×34 85/40 false/true: banco % / motor defender player good 0', r;
  end if;
  r := public.confront_outcome(34, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×34 85/40 true/true: banco % / motor attacker skill good 1', r;
  end if;
  r := public.confront_outcome(34, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×34 85/40 false/false: banco % / motor attacker skill good 1', r;
  end if;
  r := public.confront_outcome(34, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 34×34 40/85 true/false: banco % / motor attacker player normal 1', r;
  end if;
  r := public.confront_outcome(34, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×34 40/85 false/true: banco % / motor defender player normal 0', r;
  end if;
  r := public.confront_outcome(34, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×34 40/85 true/true: banco % / motor defender skill normal 0', r;
  end if;
  r := public.confront_outcome(34, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×34 40/85 false/false: banco % / motor defender skill normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 85/40 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 85/40 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 85/40 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 85/40 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 40/85 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 40/85 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 40/85 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×50 40/85 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 85/40 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 85/40 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 85/40 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 85/40 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 40/85 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 40/85 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 40/85 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×51 40/85 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 85/40 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 85/40 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 85/40 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 85/40 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 40/85 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 40/85 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 40/85 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×75 40/85 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 85/40 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 85/40 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 85/40 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 85/40 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 40/85 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 40/85 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 40/85 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×99 40/85 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 85/40 true/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 85/40 false/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 85/40 true/true: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'good' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 85/40 false/false: banco % / motor defender none good 0', r;
  end if;
  r := public.confront_outcome(34, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 40/85 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 40/85 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 40/85 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(34, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 34×100 40/85 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×1 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×2 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×9 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×17 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 50/50 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 50/50 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 50/50 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 50/50 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(50, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×34 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(50, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×50 50/50 true/false: banco % / motor attacker player normal 1', r;
  end if;
  r := public.confront_outcome(50, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×50 50/50 false/true: banco % / motor defender player normal 0', r;
  end if;
  r := public.confront_outcome(50, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×50 50/50 true/true: banco % / motor reroll reroll normal 0', r;
  end if;
  r := public.confront_outcome(50, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×50 50/50 false/false: banco % / motor reroll reroll normal 0', r;
  end if;
  r := public.confront_outcome(50, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×50 85/40 true/false: banco % / motor attacker player normal 1', r;
  end if;
  r := public.confront_outcome(50, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×50 85/40 false/true: banco % / motor defender player normal 0', r;
  end if;
  r := public.confront_outcome(50, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×50 85/40 true/true: banco % / motor attacker skill normal 1', r;
  end if;
  r := public.confront_outcome(50, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×50 85/40 false/false: banco % / motor attacker skill normal 1', r;
  end if;
  r := public.confront_outcome(50, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 50×50 40/85 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(50, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×50 40/85 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(50, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×50 40/85 true/true: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(50, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×50 40/85 false/false: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(50, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×51 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×75 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×99 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 50/50 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 50/50 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 50/50 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 50/50 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(50, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(50, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 50×100 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×1 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×2 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×9 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×17 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×34 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(51, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×50 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(51, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×51 50/50 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(51, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×51 50/50 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(51, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×51 50/50 true/true: banco % / motor reroll reroll failure 0', r;
  end if;
  r := public.confront_outcome(51, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×51 50/50 false/false: banco % / motor reroll reroll failure 0', r;
  end if;
  r := public.confront_outcome(51, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×51 85/40 true/false: banco % / motor attacker player normal 1', r;
  end if;
  r := public.confront_outcome(51, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×51 85/40 false/true: banco % / motor defender player normal 0', r;
  end if;
  r := public.confront_outcome(51, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×51 85/40 true/true: banco % / motor attacker skill normal 1', r;
  end if;
  r := public.confront_outcome(51, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×51 85/40 false/false: banco % / motor attacker skill normal 1', r;
  end if;
  r := public.confront_outcome(51, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 51×51 40/85 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(51, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×51 40/85 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(51, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×51 40/85 true/true: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(51, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×51 40/85 false/false: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 50/50 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 50/50 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 50/50 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 50/50 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×75 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 50/50 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 50/50 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 50/50 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 50/50 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×99 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 50/50 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 50/50 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 50/50 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 50/50 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(51, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(51, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 51×100 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×1 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×2 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×9 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×17 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×34 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×50 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 85/40 true/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 85/40 false/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 85/40 true/true: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 85/40 false/false: banco % / motor attacker none normal 1', r;
  end if;
  r := public.confront_outcome(75, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×51 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(75, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×75 50/50 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(75, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×75 50/50 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(75, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×75 50/50 true/true: banco % / motor reroll reroll failure 0', r;
  end if;
  r := public.confront_outcome(75, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×75 50/50 false/false: banco % / motor reroll reroll failure 0', r;
  end if;
  r := public.confront_outcome(75, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×75 85/40 true/false: banco % / motor attacker player normal 1', r;
  end if;
  r := public.confront_outcome(75, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×75 85/40 false/true: banco % / motor defender player normal 0', r;
  end if;
  r := public.confront_outcome(75, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×75 85/40 true/true: banco % / motor attacker skill normal 1', r;
  end if;
  r := public.confront_outcome(75, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×75 85/40 false/false: banco % / motor attacker skill normal 1', r;
  end if;
  r := public.confront_outcome(75, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 75×75 40/85 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(75, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×75 40/85 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(75, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×75 40/85 true/true: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(75, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×75 40/85 false/false: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 50/50 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 50/50 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 50/50 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 50/50 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×99 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 50/50 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 50/50 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 50/50 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 50/50 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 85/40 true/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 85/40 false/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 85/40 true/true: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'normal' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 85/40 false/false: banco % / motor defender none normal 0', r;
  end if;
  r := public.confront_outcome(75, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(75, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 75×100 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×1 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×2 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×9 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×17 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×34 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×50 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×51 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 50/50 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 50/50 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 50/50 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 50/50 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 85/40 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 85/40 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 85/40 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 85/40 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 40/85 true/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 40/85 false/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 40/85 true/true: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×75 40/85 false/false: banco % / motor attacker none failure 1', r;
  end if;
  r := public.confront_outcome(99, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×99 50/50 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(99, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×99 50/50 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(99, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×99 50/50 true/true: banco % / motor reroll reroll failure 0', r;
  end if;
  r := public.confront_outcome(99, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×99 50/50 false/false: banco % / motor reroll reroll failure 0', r;
  end if;
  r := public.confront_outcome(99, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×99 85/40 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(99, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×99 85/40 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(99, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×99 85/40 true/true: banco % / motor attacker skill failure 1', r;
  end if;
  r := public.confront_outcome(99, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×99 85/40 false/false: banco % / motor attacker skill failure 1', r;
  end if;
  r := public.confront_outcome(99, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 99×99 40/85 true/false: banco % / motor attacker player failure 1', r;
  end if;
  r := public.confront_outcome(99, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×99 40/85 false/true: banco % / motor defender player failure 0', r;
  end if;
  r := public.confront_outcome(99, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×99 40/85 true/true: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(99, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×99 40/85 false/false: banco % / motor defender skill failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 50/50 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 50/50 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 50/50 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 50/50 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 85/40 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 85/40 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 85/40 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 85/40 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 40/85 true/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 40/85 false/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 40/85 true/true: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(99, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'none' or r->>'quality' <> 'failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 99×100 40/85 false/false: banco % / motor defender none failure 0', r;
  end if;
  r := public.confront_outcome(100, 1, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 1, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_success' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×1 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 2, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×2 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 9, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×9 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 17, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'extreme' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×17 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 34, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'good' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×34 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 50, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×50 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 51, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×51 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 75, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×75 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 50/50 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 50, 50, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 50/50 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 50, 50, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 50/50 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 50, 50, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 50/50 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 85/40 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 85, 40, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 85/40 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 85/40 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 85/40 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 40/85 true/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 40, 85, false, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 40/85 false/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 40, 85, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 40/85 true/true: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 99, 40, 85, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'none' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×99 40/85 false/false: banco % / motor attacker none critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 100, 50, 50, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×100 50/50 true/false: banco % / motor attacker player critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 100, 50, 50, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 100×100 50/50 false/true: banco % / motor defender player critical_failure 0', r;
  end if;
  r := public.confront_outcome(100, 100, 50, 50, true, true, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 100×100 50/50 true/true: banco % / motor reroll reroll critical_failure 0', r;
  end if;
  r := public.confront_outcome(100, 100, 50, 50, false, false, 0);
  if r->>'winner' <> 'reroll' or r->>'tie_break' <> 'reroll' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 100×100 50/50 false/false: banco % / motor reroll reroll critical_failure 0', r;
  end if;
  r := public.confront_outcome(100, 100, 85, 40, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×100 85/40 true/false: banco % / motor attacker player critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 100, 85, 40, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 100×100 85/40 false/true: banco % / motor defender player critical_failure 0', r;
  end if;
  r := public.confront_outcome(100, 100, 85, 40, true, true, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×100 85/40 true/true: banco % / motor attacker skill critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 100, 85, 40, false, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×100 85/40 false/false: banco % / motor attacker skill critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 100, 40, 85, true, false, 0);
  if r->>'winner' <> 'attacker' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 1 then
    raise exception 'confronto 100×100 40/85 true/false: banco % / motor attacker player critical_failure 1', r;
  end if;
  r := public.confront_outcome(100, 100, 40, 85, false, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'player' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 100×100 40/85 false/true: banco % / motor defender player critical_failure 0', r;
  end if;
  r := public.confront_outcome(100, 100, 40, 85, true, true, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 100×100 40/85 true/true: banco % / motor defender skill critical_failure 0', r;
  end if;
  r := public.confront_outcome(100, 100, 40, 85, false, false, 0);
  if r->>'winner' <> 'defender' or r->>'tie_break' <> 'skill' or r->>'quality' <> 'critical_failure' or r->>'defender_quality' <> 'critical_failure' or (r->>'multiplier')::numeric <> 0 then
    raise exception 'confronto 100×100 40/85 false/false: banco % / motor defender skill critical_failure 0', r;
  end if;
  r := public.confront_outcome(60, 40, 0, 50, false, false, -15);
  if r->>'quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then raise exception 'modificador 0: banco %', r; end if;
  r := public.confront_outcome(60, 40, 40, 50, false, false, -15);
  if r->>'quality' <> 'failure' or (r->>'multiplier')::numeric <> 1 then raise exception 'modificador 40: banco %', r; end if;
  r := public.confront_outcome(60, 40, 50, 50, false, false, -15);
  if r->>'quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then raise exception 'modificador 50: banco %', r; end if;
  r := public.confront_outcome(60, 40, 85, 50, false, false, -15);
  if r->>'quality' <> 'normal' or (r->>'multiplier')::numeric <> 1 then raise exception 'modificador 85: banco %', r; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'luta');
  if v <> 52 then raise exception 'perícia brawler/luta: banco % / motor 52', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia brawler/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia brawler/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia brawler/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia brawler/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia brawler/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia brawler/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia brawler/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia brawler/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000001' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia brawler/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia demolidor/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'reflexo');
  if v <> 31 then raise exception 'perícia demolidor/reflexo: banco % / motor 31', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia demolidor/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia demolidor/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'pontaria');
  if v <> 32 then raise exception 'perícia demolidor/pontaria: banco % / motor 32', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia demolidor/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia demolidor/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia demolidor/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia demolidor/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000002' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia demolidor/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia detalhista/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia detalhista/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia detalhista/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia detalhista/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia detalhista/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia detalhista/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia detalhista/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia detalhista/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia detalhista/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000003' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia detalhista/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia esoterico/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia esoterico/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia esoterico/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia esoterico/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia esoterico/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia esoterico/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia esoterico/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia esoterico/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia esoterico/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000004' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia esoterico/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia atirador/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia atirador/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia atirador/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'arma_de_fogo');
  if v <> 45 then raise exception 'perícia atirador/arma_de_fogo: banco % / motor 45', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia atirador/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia atirador/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia atirador/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia atirador/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia atirador/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000005' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia atirador/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia rato/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia rato/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia rato/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia rato/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia rato/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia rato/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia rato/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'furtividade');
  if v <> 45 then raise exception 'perícia rato/furtividade: banco % / motor 45', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia rato/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000006' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia rato/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia healer/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia healer/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia healer/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia healer/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia healer/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia healer/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia healer/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia healer/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia healer/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000007' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia healer/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia tank/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia tank/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia tank/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia tank/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia tank/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia tank/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia tank/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia tank/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia tank/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000008' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia tank/intuicao: banco % / motor 10', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'luta');
  if v <> 50 then raise exception 'perícia lider/luta: banco % / motor 50', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'reflexo');
  if v <> 29 then raise exception 'perícia lider/reflexo: banco % / motor 29', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'conhecimento_belico');
  if v <> 27 then raise exception 'perícia lider/conhecimento_belico: banco % / motor 27', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'arma_de_fogo');
  if v <> 20 then raise exception 'perícia lider/arma_de_fogo: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'pontaria');
  if v <> 30 then raise exception 'perícia lider/pontaria: banco % / motor 30', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'investigacao');
  if v <> 20 then raise exception 'perícia lider/investigacao: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'enganacao');
  if v <> 15 then raise exception 'perícia lider/enganacao: banco % / motor 15', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'furtividade');
  if v <> 20 then raise exception 'perícia lider/furtividade: banco % / motor 20', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'pilotagem');
  if v <> 5 then raise exception 'perícia lider/pilotagem: banco % / motor 5', v; end if;
  v := public.form_skill_value((select id from public.character_forms where character_id = '60000000-0000-0000-0000-000000000009' and kind = 'base'), 'intuicao');
  if v <> 10 then raise exception 'perícia lider/intuicao: banco % / motor 10', v; end if;
end $$;
delete from public.characters where id::text like '60000000-%';
select 'PARIDADE DE CONFRONTOS E PERÍCIAS: 2086 CASOS OK' as resultado;
