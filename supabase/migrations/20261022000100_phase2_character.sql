-- =====================================================================
-- FOLKARA — Fase 2: ajustes para criação de personagem e ficha digital
-- =====================================================================

-- Ajuste atômico de PV/PC atuais, limitado entre 0 e o máximo calculado pelo motor.
-- Dois cliques simultâneos nunca se sobrescrevem (UPDATE único com row lock).
create or replace function public.adjust_form_resource(p_form uuid, p_resource text, p_delta int, p_max int)
returns int
language plpgsql security definer set search_path = public as $$
declare
  v int;
begin
  if not public.can_edit_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  if p_resource not in ('pv', 'pc') then
    raise exception 'Recurso inválido.';
  end if;
  if p_max < 0 or abs(p_delta) > 100000 then
    raise exception 'Valor inválido.';
  end if;
  if p_resource = 'pv' then
    update public.character_forms set pv_current = least(greatest(pv_current + p_delta, 0), p_max)
    where id = p_form returning pv_current into v;
  else
    update public.character_forms set pc_current = least(greatest(pc_current + p_delta, 0), p_max)
    where id = p_form returning pc_current into v;
  end if;
  return v;
end $$;

-- Atributos e perícias de uma forma só aceitam valores dentro de limites sãos.
alter table public.form_attributes
  add constraint form_attributes_bonus_range check (other_bonus between -100 and 100 and temp_bonus between -100 and 100);
alter table public.form_skills
  add constraint form_skills_bonus_range check (other_bonus between -100 and 100 and temp_bonus between -100 and 100);
alter table public.character_forms
  add constraint character_forms_resource_range check (
    pv_current between 0 and 9999 and pc_current between 0 and 9999
    and pv_other_bonus between -9999 and 9999 and pc_other_bonus between -9999 and 9999);

-- Enquanto a ficha é rascunho, atributos-base só entram pela rolagem do servidor.
create or replace function public.guard_draft_attributes() returns trigger
language plpgsql as $$
declare
  st text;
begin
  select c.status into st from public.characters c
  join public.character_forms f on f.character_id = c.id
  where f.id = new.form_id;
  if st = 'draft' and current_user in ('authenticated', 'anon')
     and (tg_op = 'INSERT' or new.base_value is distinct from old.base_value) then
    raise exception 'Durante a criação, os atributos vêm apenas das rolagens.';
  end if;
  return new;
end $$;

create trigger form_attributes_guard_draft before insert or update on public.form_attributes
  for each row execute function public.guard_draft_attributes();

-- Índice para o histórico de rolagens da ficha.
create index if not exists roll_log_character_user_idx on public.roll_log (character_id, user_id, created_at desc);

grant execute on function public.adjust_form_resource(uuid, text, int, int) to authenticated;
