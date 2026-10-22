-- GERADO por scripts/generate-parity-tests.ts — 1849 casos.
-- Custo de poderes: banco (compute_power_cost) = motor (computePowerCost).
\set ON_ERROR_STOP on
do $$
declare r jsonb;
begin
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 2 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 2+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 2 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 2+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 2 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 2+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 4 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 4+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 4 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 4+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 9+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 9+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 9+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 9+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 9+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 9+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 11+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 11+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 13+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 13+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 14+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 14+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 16+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 16+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":0}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+2 true', '[{"type":"heal_continuous","tier":0}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":0}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+2 true', '[{"type":"heal_continuous","tier":0}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":0}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+1 true', '[{"type":"heal_continuous","tier":0}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":0}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+2 true', '[{"type":"heal_continuous","tier":0}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":0}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+2 true', '[{"type":"heal_continuous","tier":0}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 4 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 4+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 12+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 14+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 14+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 16+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 16+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 19+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 19+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":1}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+3 true', '[{"type":"heal_continuous","tier":1}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":1}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+3 true', '[{"type":"heal_continuous","tier":1}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":1}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+2 true', '[{"type":"heal_continuous","tier":1}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":1}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+3 true', '[{"type":"heal_continuous","tier":1}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":1}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+3 true', '[{"type":"heal_continuous","tier":1}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 16+0 false', '[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 15+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 19+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 19+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 20+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 20+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 22+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 22+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 22+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 22+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":2}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+4 true', '[{"type":"heal_continuous","tier":2}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":2}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+4 true', '[{"type":"heal_continuous","tier":2}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":2}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+2 true', '[{"type":"heal_continuous","tier":2}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":2}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+4 true', '[{"type":"heal_continuous","tier":2}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":2}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+4 true', '[{"type":"heal_continuous","tier":2}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 7 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 7+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 16+0 false', '[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 16 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 16+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 19+0 false', '[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 20+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 20+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 22+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 22+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 22+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 22+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 23+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 23+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 23+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 23+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 25+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 25+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 25+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 25+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":3}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+5 true', '[{"type":"heal_continuous","tier":3}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":3}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+5 true', '[{"type":"heal_continuous","tier":3}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":3}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+3 true', '[{"type":"heal_continuous","tier":3}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":3}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+5 true', '[{"type":"heal_continuous","tier":3}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":3}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+5 true', '[{"type":"heal_continuous","tier":3}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 19+0 false', '[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 19 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 19+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 20+0 false', '[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 10 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 10+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 22+0 false', '[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 22+0 false', '[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 22+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 22 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 22+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 21+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 23+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 23+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 23+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 23+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 25+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 25+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 25+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 25 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 25+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 33+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 17+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 36+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 18+0 false', '[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 39 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 39+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 39 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 39+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 20+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 39 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 39+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 39 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 39+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 24+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 26 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 26+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 26 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 26+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 13 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 13+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 26 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 26+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 26 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 26+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 28 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 28+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 28 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 28+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 14 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 14+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 28 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 28+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 28 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 28+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":4}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 6 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+6 true', '[{"type":"heal_continuous","tier":4}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":4}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 6 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+6 true', '[{"type":"heal_continuous","tier":4}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":4}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+3 true', '[{"type":"heal_continuous","tier":4}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":4}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 6 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+6 true', '[{"type":"heal_continuous","tier":4}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":4}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 6 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+6 true', '[{"type":"heal_continuous","tier":4}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"leve"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"condition","intensity":"leve"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"leve"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"condition","intensity":"leve"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"leve"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 2 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 2+1 true', '[{"type":"condition","intensity":"leve"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"leve"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"condition","intensity":"leve"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"leve"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"condition","intensity":"leve"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"moderada"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"condition","intensity":"moderada"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"moderada"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"condition","intensity":"moderada"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"moderada"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"condition","intensity":"moderada"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"moderada"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"condition","intensity":"moderada"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"moderada"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"condition","intensity":"moderada"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"forte"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"condition","intensity":"forte"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"forte"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"condition","intensity":"forte"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"forte"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+2 true', '[{"type":"condition","intensity":"forte"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"forte"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"condition","intensity":"forte"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"forte"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"condition","intensity":"forte"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"severa"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"condition","intensity":"severa"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"severa"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"condition","intensity":"severa"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"severa"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"condition","intensity":"severa"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"severa"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"condition","intensity":"severa"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"severa"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"condition","intensity":"severa"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"extrema"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"condition","intensity":"extrema"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"extrema"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"condition","intensity":"extrema"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"extrema"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+3 true', '[{"type":"condition","intensity":"extrema"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"extrema"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"condition","intensity":"extrema"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"extrema"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"condition","intensity":"extrema"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_1"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"buff","buff":"teste_1"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_1"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"buff","buff":"teste_1"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_1"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 2 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 2+1 true', '[{"type":"buff","buff":"teste_1"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_1"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"buff","buff":"teste_1"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_1"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"buff","buff":"teste_1"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_2"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"teste_2"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_2"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"teste_2"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_2"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"buff","buff":"teste_2"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_2"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"teste_2"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_2"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"teste_2"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_1"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"dano_1"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_1"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"dano_1"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_1"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 3 or (r->>'per_turn')::int <> 1 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 3+1 true', '[{"type":"buff","buff":"dano_1"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_1"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"dano_1"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_1"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"dano_1"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_2"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"buff","buff":"dano_2"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_2"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"buff","buff":"dano_2"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_2"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 5 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 5+2 true', '[{"type":"buff","buff":"dano_2"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_2"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"buff","buff":"dano_2"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_2"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 9 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 9+3 true', '[{"type":"buff","buff":"dano_2"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"acao"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"buff","buff":"acao"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"acao"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"buff","buff":"acao"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"acao"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"buff","buff":"acao"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"acao"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"buff","buff":"acao"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"acao"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+4 true', '[{"type":"buff","buff":"acao"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"grande"}]'::jsonb, 1, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"buff","buff":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"grande"}]'::jsonb, 3, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"buff","buff":"grande"}]', 3, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"grande"}]'::jsonb, 6, 'amaldicoado');
  if (r->>'initial')::int <> 8 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 8+3 true', '[{"type":"buff","buff":"grande"}]', 6, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"grande"}]'::jsonb, 12, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"buff","buff":"grande"}]', 12, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"grande"}]'::jsonb, 20, null);
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 5 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+5 true', '[{"type":"buff","buff":"grande"}]', 20, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"},{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"},{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"grande"},{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 15 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 15+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"grande"},{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"},{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 12 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 12+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"},{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"grande"},{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"grande"},{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"},{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"},{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"grande"},{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"grande"},{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"},{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"},{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"grande"},{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":0,"extraDice":3,"area":"grande"},{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":0},{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 6 or (r->>'per_turn')::int <> 2 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 6+2 true', '[{"type":"heal_continuous","tier":0},{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"grande"},{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 17 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 17+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"grande"},{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"},{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"},{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"},{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"},{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"},{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"},{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"grande"},{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 23+0 false', '[{"type":"damage","tier":1,"extraDice":2,"area":"grande"},{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"},{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 33 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 33+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"},{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"grande"},{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 26 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 26+0 false', '[{"type":"damage","tier":1,"extraDice":3,"area":"grande"},{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"},{"type":"heal_continuous","tier":1}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 3 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+3 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"},{"type":"heal_continuous","tier":1}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"media"},{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 18 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 18+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"media"},{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"},{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 28 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 28+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"},{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"media"},{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"media"},{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"},{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 34 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 34+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"},{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"media"},{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":2,"extraDice":2,"area":"media"},{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"},{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 40 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 40+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"},{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"media"},{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":2,"extraDice":3,"area":"media"},{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"},{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 46 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 46+0 false', '[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"},{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"media"},{"type":"heal","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 20 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 20+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"media"},{"type":"heal","tier":3,"extraDice":0,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"},{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 30+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"},{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"media"},{"type":"heal","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 23 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 23+0 false', '[{"type":"damage","tier":3,"extraDice":1,"area":"media"},{"type":"heal","tier":3,"extraDice":1,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"},{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 36 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 36+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"},{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"media"},{"type":"heal","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 26 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 26+0 false', '[{"type":"damage","tier":3,"extraDice":2,"area":"media"},{"type":"heal","tier":3,"extraDice":2,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"},{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 42 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 42+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"},{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"media"},{"type":"heal","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 29 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 29+0 false', '[{"type":"damage","tier":3,"extraDice":3,"area":"media"},{"type":"heal","tier":3,"extraDice":3,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"},{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 48 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 48+0 false', '[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"},{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"},{"type":"damage","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 21 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 21+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"},{"type":"damage","tier":4,"extraDice":0,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"},{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 32 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 32+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"},{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"},{"type":"damage","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 24 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 24+0 false', '[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"},{"type":"damage","tier":4,"extraDice":1,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"},{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 38 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 38+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"},{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"},{"type":"damage","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 27+0 false', '[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"},{"type":"damage","tier":4,"extraDice":2,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"},{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 44 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 44+0 false', '[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"},{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"},{"type":"damage","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 30 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 30+0 false', '[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"},{"type":"damage","tier":4,"extraDice":3,"area":"media"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"},{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 50 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 50+0 false', '[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"},{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"forte"},{"type":"condition","intensity":"severa"}]'::jsonb, 10, 'amaldicoado');
  if (r->>'initial')::int <> 11 or (r->>'per_turn')::int <> 4 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 11+4 true', '[{"type":"condition","intensity":"forte"},{"type":"condition","intensity":"severa"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"acao"},{"type":"buff","buff":"grande"}]'::jsonb, 10, null);
  if (r->>'initial')::int <> 27 or (r->>'per_turn')::int <> 9 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 27+9 true', '[{"type":"buff","buff":"acao"},{"type":"buff","buff":"grande"}]', 10, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":0}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal_continuous","tier":0}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":1}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal_continuous","tier":1}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":2}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal_continuous","tier":2}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":3}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal_continuous","tier":3}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":2,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":2,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal_continuous","tier":4}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal_continuous","tier":4}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"leve"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"condition","intensity":"leve"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"moderada"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"condition","intensity":"moderada"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"forte"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"condition","intensity":"forte"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"severa"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"condition","intensity":"severa"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"extrema"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"condition","intensity":"extrema"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_1"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"buff","buff":"teste_1"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"teste_2"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"buff","buff":"teste_2"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_1"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"buff","buff":"dano_1"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"dano_2"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"buff","buff":"dano_2"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"acao"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"buff","buff":"acao"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"buff","buff":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"buff","buff":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"},{"type":"heal","tier":0,"extraDice":0,"area":"alvo"},{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":0,"area":"alvo"},{"type":"heal","tier":0,"extraDice":0,"area":"alvo"},{"type":"damage","tier":0,"extraDice":0,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"},{"type":"shield","tier":0,"extraDice":0,"duration":"3t"},{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":0,"duration":"2t"},{"type":"shield","tier":0,"extraDice":0,"duration":"3t"},{"type":"shield","tier":0,"extraDice":0,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"},{"type":"heal","tier":0,"extraDice":1,"area":"enorme"},{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":1,"area":"enorme"},{"type":"heal","tier":0,"extraDice":1,"area":"enorme"},{"type":"shield","tier":0,"extraDice":1,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":0,"extraDice":2,"area":"media"},{"type":"damage","tier":0,"extraDice":2,"area":"grande"},{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":0,"extraDice":2,"area":"media"},{"type":"damage","tier":0,"extraDice":2,"area":"grande"},{"type":"heal","tier":0,"extraDice":2,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"},{"type":"heal","tier":0,"extraDice":3,"area":"pequena"},{"type":"damage","tier":0,"extraDice":3,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":0,"extraDice":3,"area":"pequena"},{"type":"heal","tier":0,"extraDice":3,"area":"pequena"},{"type":"damage","tier":0,"extraDice":3,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"},{"type":"heal_continuous","tier":0},{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":0,"extraDice":3,"duration":"cena"},{"type":"heal_continuous","tier":0},{"type":"damage","tier":1,"extraDice":0,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"},{"type":"shield","tier":1,"extraDice":0,"duration":"1t"},{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":0,"area":"enorme"},{"type":"shield","tier":1,"extraDice":0,"duration":"1t"},{"type":"shield","tier":1,"extraDice":0,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":1,"area":"grande"},{"type":"heal","tier":1,"extraDice":1,"area":"grande"},{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":1,"area":"grande"},{"type":"heal","tier":1,"extraDice":1,"area":"grande"},{"type":"damage","tier":1,"extraDice":1,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"},{"type":"damage","tier":1,"extraDice":2,"area":"media"},{"type":"heal","tier":1,"extraDice":2,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":1,"extraDice":2,"area":"pequena"},{"type":"damage","tier":1,"extraDice":2,"area":"media"},{"type":"heal","tier":1,"extraDice":2,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"},{"type":"heal","tier":1,"extraDice":3,"area":"alvo"},{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":1,"extraDice":3,"area":"alvo"},{"type":"heal","tier":1,"extraDice":3,"area":"alvo"},{"type":"damage","tier":1,"extraDice":3,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"},{"type":"shield","tier":1,"extraDice":3,"duration":"3t"},{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":1,"extraDice":3,"duration":"2t"},{"type":"shield","tier":1,"extraDice":3,"duration":"3t"},{"type":"shield","tier":1,"extraDice":3,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":0,"area":"grande"},{"type":"damage","tier":2,"extraDice":0,"area":"enorme"},{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":0,"area":"grande"},{"type":"damage","tier":2,"extraDice":0,"area":"enorme"},{"type":"heal","tier":2,"extraDice":0,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":2,"extraDice":1,"area":"media"},{"type":"heal","tier":2,"extraDice":1,"area":"media"},{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":2,"extraDice":1,"area":"media"},{"type":"heal","tier":2,"extraDice":1,"area":"media"},{"type":"damage","tier":2,"extraDice":1,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"},{"type":"damage","tier":2,"extraDice":2,"area":"pequena"},{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":2,"area":"alvo"},{"type":"damage","tier":2,"extraDice":2,"area":"pequena"},{"type":"heal","tier":2,"extraDice":2,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"},{"type":"shield","tier":2,"extraDice":2,"duration":"cena"},{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":2,"extraDice":2,"duration":"3t"},{"type":"shield","tier":2,"extraDice":2,"duration":"cena"},{"type":"damage","tier":2,"extraDice":3,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"},{"type":"shield","tier":2,"extraDice":3,"duration":"1t"},{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":2,"extraDice":3,"area":"enorme"},{"type":"shield","tier":2,"extraDice":3,"duration":"1t"},{"type":"shield","tier":2,"extraDice":3,"duration":"2t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":0,"area":"media"},{"type":"damage","tier":3,"extraDice":0,"area":"grande"},{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":0,"area":"media"},{"type":"damage","tier":3,"extraDice":0,"area":"grande"},{"type":"heal","tier":3,"extraDice":0,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"},{"type":"heal","tier":3,"extraDice":1,"area":"pequena"},{"type":"damage","tier":3,"extraDice":1,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":3,"extraDice":1,"area":"pequena"},{"type":"heal","tier":3,"extraDice":1,"area":"pequena"},{"type":"damage","tier":3,"extraDice":1,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"},{"type":"damage","tier":3,"extraDice":2,"area":"alvo"},{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":1,"duration":"cena"},{"type":"damage","tier":3,"extraDice":2,"area":"alvo"},{"type":"heal","tier":3,"extraDice":2,"area":"alvo"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"},{"type":"shield","tier":3,"extraDice":2,"duration":"2t"},{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":3,"extraDice":2,"duration":"1t"},{"type":"shield","tier":3,"extraDice":2,"duration":"2t"},{"type":"shield","tier":3,"extraDice":2,"duration":"3t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":3,"extraDice":3,"area":"grande"},{"type":"damage","tier":3,"extraDice":3,"area":"enorme"},{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":3,"extraDice":3,"area":"grande"},{"type":"damage","tier":3,"extraDice":3,"area":"enorme"},{"type":"heal","tier":3,"extraDice":3,"area":"enorme"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"},{"type":"damage","tier":4,"extraDice":0,"area":"media"},{"type":"heal","tier":4,"extraDice":0,"area":"media"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":0,"area":"pequena"},{"type":"damage","tier":4,"extraDice":0,"area":"media"},{"type":"heal","tier":4,"extraDice":0,"area":"media"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"},{"type":"heal","tier":4,"extraDice":1,"area":"alvo"},{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":1,"area":"alvo"},{"type":"heal","tier":4,"extraDice":1,"area":"alvo"},{"type":"damage","tier":4,"extraDice":1,"area":"pequena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"},{"type":"shield","tier":4,"extraDice":1,"duration":"3t"},{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"shield","tier":4,"extraDice":1,"duration":"2t"},{"type":"shield","tier":4,"extraDice":1,"duration":"3t"},{"type":"shield","tier":4,"extraDice":1,"duration":"cena"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"},{"type":"heal","tier":4,"extraDice":2,"area":"enorme"},{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"damage","tier":4,"extraDice":2,"area":"enorme"},{"type":"heal","tier":4,"extraDice":2,"area":"enorme"},{"type":"shield","tier":4,"extraDice":2,"duration":"1t"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"heal","tier":4,"extraDice":3,"area":"media"},{"type":"damage","tier":4,"extraDice":3,"area":"grande"},{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"heal","tier":4,"extraDice":3,"area":"media"},{"type":"damage","tier":4,"extraDice":3,"area":"grande"},{"type":"heal","tier":4,"extraDice":3,"area":"grande"}]', 1, r;
  end if;
  r := public.compute_power_cost('[{"type":"condition","intensity":"moderada"},{"type":"condition","intensity":"forte"},{"type":"condition","intensity":"severa"}]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[{"type":"condition","intensity":"moderada"},{"type":"condition","intensity":"forte"},{"type":"condition","intensity":"severa"}]', 1, r;
  end if;
  r := public.compute_power_cost('[]'::jsonb, 1, 'prodigio');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> true then
    raise exception 'divergência: % nível % → banco % / motor 0+0 true', '[]', 1, r;
  end if;
  r := public.compute_power_cost('[]'::jsonb, 5, null);
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 0+0 false', '[]', 5, r;
  end if;
  r := public.compute_power_cost('[]'::jsonb, 5, 'amaldicoado');
  if (r->>'initial')::int <> 0 or (r->>'per_turn')::int <> 0 or (r->>'valid')::boolean <> false then
    raise exception 'divergência: % nível % → banco % / motor 0+0 false', '[]', 5, r;
  end if;
end $$;
select 'PARIDADE BANCO x MOTOR: 1849 CASOS OK' as resultado;
