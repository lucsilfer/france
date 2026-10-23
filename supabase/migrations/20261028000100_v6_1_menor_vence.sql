-- =====================================================================
-- F.R.A.N.C.E — VERSÃO 6.1: correção da regra de combate.
-- No confronto de rolagens opostas, vence quem tirar o MENOR d100.
-- A regra vem de public.rules_config() (atualizada por 20261028000000_rules_sync_v6_1.sql);
-- aqui só o valor padrão de segurança da função passa a ser "menor vence".
-- Desempates, classificação (menor é melhor) e multiplicadores não mudam.
-- Não apaga dados; confrontos já registrados ficam como estão. Pode ser reaplicada.
-- =====================================================================
create or replace function public.confront_outcome(p_attack int, p_defend int, p_att_skill int, p_def_skill int,
                                                   p_att_player boolean, p_def_player boolean, p_modifier int default 0)
returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  higher boolean := coalesce(cfg -> 'opposed' ->> 'winner', 'lower') = 'higher';
  quality text := public.classify_d100(p_attack, p_att_skill, p_modifier);
  dquality text := public.classify_d100(p_defend, p_def_skill, 0);
  winner text;
  tie text := 'none';
  mult numeric := 0;
begin
  if p_attack <> p_defend then
    winner := case when (p_attack > p_defend) = higher then 'attacker' else 'defender' end;
  elsif coalesce((cfg -> 'opposed' ->> 'tiePlayerWins')::boolean, true) and p_att_player is distinct from p_def_player then
    winner := case when p_att_player then 'attacker' else 'defender' end;
    tie := 'player';
  elsif coalesce(p_att_skill, 0) <> coalesce(p_def_skill, 0) then
    winner := case when coalesce(p_att_skill, 0) > coalesce(p_def_skill, 0) then 'attacker' else 'defender' end;
    tie := 'skill';
  else
    winner := 'reroll';
    tie := 'reroll';
  end if;
  if winner = 'attacker' then
    mult := case quality when 'critical_success' then (cfg -> 'damageMultiplier' ->> 'critical')::numeric
                         when 'extreme' then (cfg -> 'damageMultiplier' ->> 'extreme')::numeric else 1 end;
  end if;
  return jsonb_build_object('winner', winner, 'tie_break', tie, 'quality', quality, 'defender_quality', dquality, 'multiplier', mult);
end $$;
grant execute on function public.confront_outcome(int, int, int, int, boolean, boolean, int) to authenticated;

-- Conferência: deve devolver "attacker" (10 é menor que 90).
do $$ begin
  if public.confront_outcome(10, 90, 50, 50, false, false, 0) ->> 'winner' <> 'attacker' then
    raise exception 'Regra do confronto não atualizada: aplique antes 20261028000000_rules_sync_v6_1.sql.';
  end if;
end $$;
