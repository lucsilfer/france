-- F.R.A.N.C.E 6.1 — INSTALAÇÃO COMPLETA (projeto Supabase novo, ex.: o do Lovable)
-- Cole no Supabase: SQL Editor → New query → Run. Não apaga dados; pode ser executado de novo.
-- Arquivos incluídos, nesta ordem:
--   20261021000000_folkara_schema.sql
--   20261022000000_rules_sync.sql
--   20261022000100_phase2_character.sql
--   20261023000000_rules_sync_fase3.sql
--   20261023000100_fase3_sistemas.sql
--   20261024000000_rules_sync_3_5.sql
--   20261024000100_atualizacao_3_5.sql
--   20261025000000_rules_sync_fase4.sql
--   20261025000100_fase4_campanhas.sql
--   20261026000100_fase5_homebrew.sql
--   20261027000000_rules_sync_v6.sql
--   20261027000100_v6_finalizacao.sql
--   20261028000000_rules_sync_v6_1.sql
--   20261028000100_v6_1_menor_vence.sql


-- =====================================================================
-- >>> 20261021000000_folkara_schema.sql
-- =====================================================================
-- =====================================================================
-- FOLKARA — Esquema do banco (Supabase / PostgreSQL)
-- Fase 1: estrutura completa + RLS + funções de campanha e perfil.
-- Regras de jogo ficam no motor TypeScript (src/rules); o banco garante
-- posse, permissões, integridade e idempotência.
-- =====================================================================

create extension if not exists pgcrypto with schema extensions;
create extension if not exists citext with schema extensions;

-- ---------------------------------------------------------------------
-- Utilidades
-- ---------------------------------------------------------------------
create or replace function public.set_updated_at() returns trigger
language plpgsql as $$
begin
  new.updated_at := now();
  return new;
end $$;

-- Dado criptográfico 1..sides (amostragem por rejeição).
create or replace function public.roll_die(sides int) returns int
language plpgsql volatile
set search_path = public, extensions
as $$
declare
  lim bigint;
  v bigint;
begin
  if sides < 2 or sides > 1000 then
    raise exception 'faces inválidas';
  end if;
  lim := 4294967296 - (4294967296 % sides);
  loop
    v := ('x' || encode(extensions.gen_random_bytes(4), 'hex'))::bit(32)::bigint;
    if v < lim then
      return (v % sides) + 1;
    end if;
  end loop;
end $$;

-- ---------------------------------------------------------------------
-- Perfis
-- ---------------------------------------------------------------------
create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  username extensions.citext not null unique
    check (char_length(username) between 3 and 24 and username ~ '^[A-Za-z0-9_.-]+$'),
  display_name text check (char_length(display_name) <= 60),
  avatar_url text,
  reduce_motion boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger profiles_updated before update on public.profiles
  for each row execute function public.set_updated_at();

-- Cria o perfil automaticamente no cadastro (username vem dos metadados).
create or replace function public.handle_new_user() returns trigger
language plpgsql security definer
set search_path = public
as $$
declare
  wanted text := coalesce(nullif(trim(new.raw_user_meta_data ->> 'username'), ''), split_part(new.email, '@', 1));
  candidate text;
  n int := 0;
begin
  wanted := regexp_replace(wanted, '[^A-Za-z0-9_.-]', '', 'g');
  if char_length(wanted) < 3 then
    wanted := 'jogador';
  end if;
  wanted := left(wanted, 20);
  candidate := wanted;
  while exists (select 1 from public.profiles where username = candidate) loop
    n := n + 1;
    candidate := wanted || n::text;
  end loop;
  insert into public.profiles (id, username, display_name)
  values (new.id, candidate, nullif(new.raw_user_meta_data ->> 'display_name', ''));
  return new;
end $$;

create trigger on_auth_user_created after insert on auth.users
  for each row execute function public.handle_new_user();

-- Disponibilidade de nome de usuário (para o cadastro, sem expor a tabela).
create or replace function public.username_available(p_username text) returns boolean
language sql stable security definer
set search_path = public
as $$
  select not exists (select 1 from public.profiles where username = p_username::extensions.citext);
$$;

-- ---------------------------------------------------------------------
-- Campanhas (declaradas antes dos personagens por causa das permissões)
-- ---------------------------------------------------------------------
create table public.campaigns (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users (id) on delete cascade,
  name text not null check (char_length(name) between 1 and 120),
  description text not null default '' check (char_length(description) <= 5000),
  cover_url text check (cover_url is null or cover_url ~ '^https://'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger campaigns_updated before update on public.campaigns
  for each row execute function public.set_updated_at();

-- Convite em tabela separada: só o Mestre lê o código.
create table public.campaign_invites (
  campaign_id uuid primary key references public.campaigns (id) on delete cascade,
  code text not null unique default encode(extensions.gen_random_bytes(9), 'hex'),
  created_at timestamptz not null default now()
);

create table public.campaign_members (
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  role text not null check (role in ('master', 'player')),
  joined_at timestamptz not null default now(),
  primary key (campaign_id, user_id)
);
create index campaign_members_user_idx on public.campaign_members (user_id);

create or replace function public.is_campaign_member(p_campaign uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.campaign_members where campaign_id = p_campaign and user_id = auth.uid());
$$;

create or replace function public.is_campaign_master(p_campaign uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.campaign_members where campaign_id = p_campaign and user_id = auth.uid() and role = 'master');
$$;

-- O criador vira Mestre automaticamente.
create or replace function public.add_campaign_master() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.campaign_members (campaign_id, user_id, role) values (new.id, new.owner_id, 'master');
  insert into public.campaign_invites (campaign_id) values (new.id);
  return new;
end $$;
create trigger campaigns_add_master after insert on public.campaigns
  for each row execute function public.add_campaign_master();

-- ---------------------------------------------------------------------
-- Personagens
-- ---------------------------------------------------------------------
create table public.characters (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users (id) on delete cascade,
  status text not null default 'draft' check (status in ('draft', 'active')),
  creation_step int not null default 1 check (creation_step between 1 and 6),
  name text not null default '' check (char_length(name) <= 120),
  player_name text not null default '' check (char_length(player_name) <= 120),
  origin_id text,
  origin_path_id text,
  class_id text,
  level int not null default 1 check (level between 1 and 20),
  money numeric(14, 2) not null default 0,
  story text not null default '',
  appearance text not null default '',
  extra_info text not null default '',
  personal_notes text not null default '',
  active_form text not null default 'base' check (active_form in ('base', 'lenda')),
  rules_version text not null default 'livro-1.0',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index characters_owner_idx on public.characters (owner_id);
create trigger characters_updated before update on public.characters
  for each row execute function public.set_updated_at();

create table public.campaign_characters (
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  character_id uuid not null references public.characters (id) on delete cascade,
  added_by uuid not null references auth.users (id) on delete cascade,
  master_can_edit boolean not null default true,
  linked_at timestamptz not null default now(),
  primary key (campaign_id, character_id)
);
create index campaign_characters_char_idx on public.campaign_characters (character_id);

create or replace function public.owns_character(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.characters where id = p_character and owner_id = auth.uid());
$$;

create or replace function public.can_view_character(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.owns_character(p_character)
      or exists (
        select 1 from public.campaign_characters cc
        join public.campaign_members m on m.campaign_id = cc.campaign_id
        where cc.character_id = p_character and m.user_id = auth.uid() and m.role = 'master');
$$;

create or replace function public.can_edit_character(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.owns_character(p_character)
      or exists (
        select 1 from public.campaign_characters cc
        join public.campaign_members m on m.campaign_id = cc.campaign_id
        where cc.character_id = p_character and cc.master_can_edit
          and m.user_id = auth.uid() and m.role = 'master');
$$;

-- Ninguém (nem o Mestre) pode transferir a posse de um personagem.
create or replace function public.lock_character_owner() returns trigger
language plpgsql as $$
begin
  if new.owner_id <> old.owner_id then
    raise exception 'A posse do personagem não pode ser alterada.';
  end if;
  return new;
end $$;
create trigger characters_lock_owner before update on public.characters
  for each row execute function public.lock_character_owner();

-- Formas: 'base' para todos; 'lenda' só para o Artificial (ficha secundária).
create table public.character_forms (
  id uuid primary key default gen_random_uuid(),
  character_id uuid not null references public.characters (id) on delete cascade,
  kind text not null check (kind in ('base', 'lenda')),
  name text not null default '',
  description text not null default '',
  special_rules text not null default '',
  pv_current int not null default 0,
  pc_current int not null default 0,
  pv_other_bonus int not null default 0,
  pc_other_bonus int not null default 0,
  updated_at timestamptz not null default now(),
  unique (character_id, kind)
);
create trigger character_forms_updated before update on public.character_forms
  for each row execute function public.set_updated_at();

create or replace function public.form_character(p_form uuid) returns uuid
language sql stable security definer set search_path = public as $$
  select character_id from public.character_forms where id = p_form;
$$;

-- Cada personagem nasce com a forma base.
create or replace function public.create_base_form() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  insert into public.character_forms (character_id, kind) values (new.id, 'base');
  return new;
end $$;
create trigger characters_base_form after insert on public.characters
  for each row execute function public.create_base_form();

create table public.form_attributes (
  form_id uuid not null references public.character_forms (id) on delete cascade,
  attribute text not null check (attribute in ('FOR', 'DEX', 'INT', 'CON', 'MIT', 'PER', 'CAR', 'VIG')),
  base_value int check (base_value between 0 and 200),
  other_bonus int not null default 0,
  temp_bonus int not null default 0,
  roll_id uuid,
  primary key (form_id, attribute)
);

-- Rolagens de atributo feitas no servidor: recarregar a página nunca gera rolagem nova.
create table public.attribute_rolls (
  id uuid primary key default gen_random_uuid(),
  form_id uuid not null references public.character_forms (id) on delete cascade,
  faces int[] not null,
  results int[] not null check (array_length(results, 1) = 3),
  best int not null,
  assigned_attribute text,
  created_at timestamptz not null default now()
);
create unique index attribute_rolls_one_pending on public.attribute_rolls (form_id) where assigned_attribute is null;
create unique index attribute_rolls_one_per_attr on public.attribute_rolls (form_id, assigned_attribute) where assigned_attribute is not null;
alter table public.form_attributes
  add constraint form_attributes_roll_fk foreign key (roll_id) references public.attribute_rolls (id) on delete set null;

create table public.form_skills (
  form_id uuid not null references public.character_forms (id) on delete cascade,
  skill_id text not null,
  points int not null default 0 check (points between 0 and 200),
  other_bonus int not null default 0,
  temp_bonus int not null default 0,
  primary key (form_id, skill_id)
);

-- Ganhos de nível: um registro por forma e nível; nunca é rolado de novo.
create table public.level_progressions (
  form_id uuid not null references public.character_forms (id) on delete cascade,
  level int not null check (level between 2 and 20),
  pv_dice text not null,
  pc_dice text,
  pv_roll jsonb not null,
  pc_roll jsonb,
  pv_gain int not null,
  pc_gain int not null,
  rolled_at timestamptz not null default now(),
  primary key (form_id, level)
);

-- ---------------------------------------------------------------------
-- Homebrew (biblioteca de modelos)
-- ---------------------------------------------------------------------
create table public.homebrew (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users (id) on delete cascade,
  kind text not null check (kind in ('item', 'arma', 'modificador', 'monstro', 'npc', 'outro')),
  name text not null check (char_length(name) between 1 and 120),
  description text not null default '' check (char_length(description) <= 10000),
  data jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index homebrew_owner_idx on public.homebrew (owner_id, kind);
create trigger homebrew_updated before update on public.homebrew
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------
-- Inventário e poderes (compartilhados entre as formas do personagem)
-- ---------------------------------------------------------------------
create table public.items (
  id uuid primary key default gen_random_uuid(),
  character_id uuid not null references public.characters (id) on delete cascade,
  source_kind text not null default 'custom' check (source_kind in ('catalog', 'homebrew', 'custom')),
  source_ref text, -- id do catálogo oficial ou do homebrew de origem (cópia independente)
  name text not null check (char_length(name) between 1 and 120),
  description text not null default '',
  item_type text not null default 'item',
  category text not null default '',
  quantity int not null default 1 check (quantity >= 0),
  weight numeric(8, 2),
  effect_dice text,
  effect_kind text check (effect_kind in ('dano', 'cura', 'outro')),
  attack_kind text check (attack_kind in ('melee', 'ranged', 'firearm')),
  range text not null default '',
  special_rules text not null default '',
  tags text[] not null default '{}',
  quick_access boolean not null default false,
  sort_order int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index items_character_idx on public.items (character_id);
create trigger items_updated before update on public.items
  for each row execute function public.set_updated_at();

create table public.item_modifiers (
  id uuid primary key default gen_random_uuid(),
  item_id uuid not null references public.items (id) on delete cascade,
  modifier_id text not null,
  is_temporary boolean not null default false,
  created_at timestamptz not null default now(),
  unique (item_id, modifier_id)
);

create table public.powers (
  id uuid primary key default gen_random_uuid(),
  character_id uuid not null references public.characters (id) on delete cascade,
  name text not null check (char_length(name) between 1 and 120),
  description text not null default '',
  ability_type text not null default '',
  target text not null default '',
  range text not null default '',
  duration text not null default '',
  components jsonb not null default '[]'::jsonb,
  initial_cost int not null default 0 check (initial_cost >= 0),
  per_turn_cost int not null default 0 check (per_turn_cost >= 0),
  effect_dice text,
  quick_access boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index powers_character_idx on public.powers (character_id);
create trigger powers_updated before update on public.powers
  for each row execute function public.set_updated_at();

create table public.active_effects (
  id uuid primary key default gen_random_uuid(),
  character_id uuid not null references public.characters (id) on delete cascade,
  form_id uuid references public.character_forms (id) on delete cascade,
  power_id uuid references public.powers (id) on delete set null,
  label text not null,
  per_turn_cost int not null default 0,
  turns_paid int not null default 0,
  active boolean not null default true,
  started_at timestamptz not null default now()
);

-- Livro-razão de PC: request_id único impede débito duplo pelo mesmo clique.
create table public.pc_transactions (
  request_id uuid primary key,
  form_id uuid not null references public.character_forms (id) on delete cascade,
  amount int not null,
  reason text not null default '',
  created_by uuid references auth.users (id) on delete set null,
  created_at timestamptz not null default now()
);

-- ---------------------------------------------------------------------
-- Rolagens (histórico)
-- ---------------------------------------------------------------------
create table public.roll_log (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users (id) on delete cascade,
  character_id uuid references public.characters (id) on delete cascade,
  campaign_id uuid references public.campaigns (id) on delete cascade,
  label text not null,
  expression text not null,
  result jsonb not null,
  visibility text not null default 'public' check (visibility in ('public', 'master', 'self')),
  created_at timestamptz not null default now()
);
create index roll_log_campaign_idx on public.roll_log (campaign_id, created_at desc);
create index roll_log_character_idx on public.roll_log (character_id, created_at desc);

-- ---------------------------------------------------------------------
-- Escudo do Mestre
-- ---------------------------------------------------------------------
create table public.npcs (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  source_homebrew_id uuid references public.homebrew (id) on delete set null,
  kind text not null default 'npc' check (kind in ('npc', 'monstro')),
  name text not null,
  data jsonb not null default '{}'::jsonb,
  pv_current int, pv_max int, pc_current int, pc_max int,
  conditions jsonb not null default '[]'::jsonb,
  visible_to_players boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger npcs_updated before update on public.npcs
  for each row execute function public.set_updated_at();

create table public.combats (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  name text not null default 'Combate',
  status text not null default 'active' check (status in ('active', 'paused', 'ended')),
  round int not null default 1,
  turn_index int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger combats_updated before update on public.combats
  for each row execute function public.set_updated_at();

create table public.combatants (
  id uuid primary key default gen_random_uuid(),
  combat_id uuid not null references public.combats (id) on delete cascade,
  character_id uuid references public.characters (id) on delete cascade,
  npc_id uuid references public.npcs (id) on delete cascade,
  name text not null,
  initiative int,
  sort_order int not null default 0,
  pv_current int, pv_max int, pc_current int, pc_max int,
  conditions jsonb not null default '[]'::jsonb,
  hide_stats boolean not null default false,
  hidden boolean not null default false,
  check (num_nonnulls(character_id, npc_id) <= 1)
);

create table public.investigations (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  title text not null,
  description text not null default '',
  locations jsonb not null default '[]'::jsonb,
  related jsonb not null default '[]'::jsonb,
  visible_to_players boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger investigations_updated before update on public.investigations
  for each row execute function public.set_updated_at();

create table public.investigation_secrets (
  investigation_id uuid primary key references public.investigations (id) on delete cascade,
  master_notes text not null default ''
);

create table public.clues (
  id uuid primary key default gen_random_uuid(),
  investigation_id uuid not null references public.investigations (id) on delete cascade,
  title text not null,
  content text not null default '',
  attachments jsonb not null default '[]'::jsonb,
  revealed boolean not null default false,
  created_at timestamptz not null default now()
);

create table public.reports (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  title text not null,
  report_date date not null default current_date,
  description text not null default '',
  participants jsonb not null default '[]'::jsonb,
  events jsonb not null default '[]'::jsonb,
  attachments jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create trigger reports_updated before update on public.reports
  for each row execute function public.set_updated_at();

create table public.campaign_notes (
  id uuid primary key default gen_random_uuid(),
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  author_id uuid not null references auth.users (id) on delete cascade,
  title text not null default 'Sem título',
  category text not null default '',
  content text not null default '',
  is_private boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
create index campaign_notes_search_idx on public.campaign_notes
  using gin (to_tsvector('portuguese', title || ' ' || content));
create trigger campaign_notes_updated before update on public.campaign_notes
  for each row execute function public.set_updated_at();

-- ---------------------------------------------------------------------
-- Histórico de alterações importantes
-- ---------------------------------------------------------------------
create table public.audit_log (
  id bigint generated always as identity primary key,
  user_id uuid,
  entity text not null,
  entity_id text not null,
  character_id uuid,
  campaign_id uuid,
  action text not null,
  changes jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
create index audit_log_character_idx on public.audit_log (character_id, created_at desc);
create index audit_log_campaign_idx on public.audit_log (campaign_id, created_at desc);

create or replace function public.log_change() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  old_j jsonb := case when tg_op in ('UPDATE', 'DELETE') then to_jsonb(old) else '{}'::jsonb end;
  new_j jsonb := case when tg_op in ('INSERT', 'UPDATE') then to_jsonb(new) else '{}'::jsonb end;
  row_j jsonb := case when tg_op = 'DELETE' then old_j else new_j end;
  diff jsonb := '{}'::jsonb;
  k text;
  char_id uuid;
begin
  if tg_op = 'UPDATE' then
    for k in select jsonb_object_keys(new_j) loop
      if k not in ('updated_at') and (old_j -> k) is distinct from (new_j -> k) then
        diff := diff || jsonb_build_object(k, jsonb_build_array(old_j -> k, new_j -> k));
      end if;
    end loop;
    if diff = '{}'::jsonb then
      return new;
    end if;
  end if;
  char_id := case
    when tg_table_name = 'characters' then (row_j ->> 'id')::uuid
    when row_j ? 'character_id' then (row_j ->> 'character_id')::uuid
    when row_j ? 'form_id' then public.form_character((row_j ->> 'form_id')::uuid)
  end;
  insert into public.audit_log (user_id, entity, entity_id, character_id, campaign_id, action, changes)
  values (
    auth.uid(), tg_table_name,
    coalesce(row_j ->> 'id', row_j ->> 'form_id', ''),
    char_id,
    case when tg_table_name = 'campaigns' then (row_j ->> 'id')::uuid else (row_j ->> 'campaign_id')::uuid end,
    lower(tg_op),
    case tg_op when 'UPDATE' then diff when 'DELETE' then old_j else '{}'::jsonb end
  );
  return coalesce(new, old);
end $$;

create trigger audit_characters after insert or update or delete on public.characters
  for each row execute function public.log_change();
create trigger audit_forms after update on public.character_forms
  for each row execute function public.log_change();
create trigger audit_form_attributes after update on public.form_attributes
  for each row execute function public.log_change();
create trigger audit_campaign_characters after insert or update or delete on public.campaign_characters
  for each row execute function public.log_change();
create trigger audit_campaigns after insert or update on public.campaigns
  for each row execute function public.log_change();

-- =====================================================================
-- ROW LEVEL SECURITY
-- =====================================================================
alter table public.profiles enable row level security;
alter table public.campaigns enable row level security;
alter table public.campaign_members enable row level security;
alter table public.campaign_invites enable row level security;
alter table public.characters enable row level security;
alter table public.campaign_characters enable row level security;
alter table public.character_forms enable row level security;
alter table public.form_attributes enable row level security;
alter table public.attribute_rolls enable row level security;
alter table public.form_skills enable row level security;
alter table public.level_progressions enable row level security;
alter table public.homebrew enable row level security;
alter table public.items enable row level security;
alter table public.item_modifiers enable row level security;
alter table public.powers enable row level security;
alter table public.active_effects enable row level security;
alter table public.pc_transactions enable row level security;
alter table public.roll_log enable row level security;
alter table public.npcs enable row level security;
alter table public.combats enable row level security;
alter table public.combatants enable row level security;
alter table public.investigations enable row level security;
alter table public.investigation_secrets enable row level security;
alter table public.clues enable row level security;
alter table public.reports enable row level security;
alter table public.campaign_notes enable row level security;
alter table public.audit_log enable row level security;

-- Perfis: cada um vê o próprio e os de quem divide campanha.
create policy profiles_select on public.profiles for select to authenticated
  using (id = auth.uid() or exists (
    select 1 from public.campaign_members a join public.campaign_members b on a.campaign_id = b.campaign_id
    where a.user_id = auth.uid() and b.user_id = profiles.id));
create policy profiles_update on public.profiles for update to authenticated
  using (id = auth.uid()) with check (id = auth.uid());

-- Campanhas
create policy campaigns_select on public.campaigns for select to authenticated
  using (owner_id = auth.uid() or public.is_campaign_member(id));
create policy campaigns_insert on public.campaigns for insert to authenticated
  with check (owner_id = auth.uid());
create policy campaigns_update on public.campaigns for update to authenticated
  using (public.is_campaign_master(id)) with check (public.is_campaign_master(id));
create policy campaigns_delete on public.campaigns for delete to authenticated
  using (owner_id = auth.uid());

create policy invites_master on public.campaign_invites for select to authenticated
  using (public.is_campaign_master(campaign_id));

create policy members_select on public.campaign_members for select to authenticated
  using (public.is_campaign_member(campaign_id));
-- Entrada só pela função join_campaign; o Mestre pode remover jogadores; o jogador pode sair.
create policy members_delete on public.campaign_members for delete to authenticated
  using ((public.is_campaign_master(campaign_id) and role = 'player') or (user_id = auth.uid() and role = 'player'));

-- Personagens
create policy characters_select on public.characters for select to authenticated
  using (owner_id = auth.uid() or public.can_view_character(id));
create policy characters_insert on public.characters for insert to authenticated
  with check (owner_id = auth.uid());
create policy characters_update on public.characters for update to authenticated
  using (public.can_edit_character(id)) with check (public.can_edit_character(id));
create policy characters_delete on public.characters for delete to authenticated
  using (owner_id = auth.uid());

-- Vínculo com campanha: o dono vincula o próprio personagem (autorizando o Mestre);
-- o Mestre pode vincular os próprios personagens à sua campanha.
create policy cc_select on public.campaign_characters for select to authenticated
  using (public.is_campaign_member(campaign_id));
create policy cc_insert on public.campaign_characters for insert to authenticated
  with check (added_by = auth.uid() and public.owns_character(character_id) and public.is_campaign_member(campaign_id));
create policy cc_update on public.campaign_characters for update to authenticated
  using (public.owns_character(character_id)) with check (public.owns_character(character_id));
create policy cc_delete on public.campaign_characters for delete to authenticated
  using (public.owns_character(character_id) or public.is_campaign_master(campaign_id));

-- Formas e tabelas filhas seguem as permissões do personagem.
create policy forms_select on public.character_forms for select to authenticated
  using (public.can_view_character(character_id));
create policy forms_insert on public.character_forms for insert to authenticated
  with check (public.owns_character(character_id));
create policy forms_update on public.character_forms for update to authenticated
  using (public.can_edit_character(character_id)) with check (public.can_edit_character(character_id));

create policy fattr_select on public.form_attributes for select to authenticated
  using (public.can_view_character(public.form_character(form_id)));
create policy fattr_write on public.form_attributes for all to authenticated
  using (public.can_edit_character(public.form_character(form_id)))
  with check (public.can_edit_character(public.form_character(form_id)));

-- Rolagens de atributo e de nível: só leitura para clientes (escrita via funções do servidor).
create policy arolls_select on public.attribute_rolls for select to authenticated
  using (public.can_view_character(public.form_character(form_id)));
create policy lprog_select on public.level_progressions for select to authenticated
  using (public.can_view_character(public.form_character(form_id)));

create policy fskills_select on public.form_skills for select to authenticated
  using (public.can_view_character(public.form_character(form_id)));
create policy fskills_write on public.form_skills for all to authenticated
  using (public.can_edit_character(public.form_character(form_id)))
  with check (public.can_edit_character(public.form_character(form_id)));

-- Homebrew: privado do autor.
create policy homebrew_all on public.homebrew for all to authenticated
  using (owner_id = auth.uid()) with check (owner_id = auth.uid());

-- Inventário, poderes, efeitos
create policy items_select on public.items for select to authenticated
  using (public.can_view_character(character_id));
create policy items_write on public.items for all to authenticated
  using (public.can_edit_character(character_id)) with check (public.can_edit_character(character_id));
create policy itemmods_select on public.item_modifiers for select to authenticated
  using (exists (select 1 from public.items i where i.id = item_id and public.can_view_character(i.character_id)));
create policy itemmods_write on public.item_modifiers for all to authenticated
  using (exists (select 1 from public.items i where i.id = item_id and public.can_edit_character(i.character_id)))
  with check (exists (select 1 from public.items i where i.id = item_id and public.can_edit_character(i.character_id)));
create policy powers_select on public.powers for select to authenticated
  using (public.can_view_character(character_id));
create policy powers_write on public.powers for all to authenticated
  using (public.can_edit_character(character_id)) with check (public.can_edit_character(character_id));
create policy effects_select on public.active_effects for select to authenticated
  using (public.can_view_character(character_id));
create policy effects_write on public.active_effects for all to authenticated
  using (public.can_edit_character(character_id)) with check (public.can_edit_character(character_id));
create policy pctx_select on public.pc_transactions for select to authenticated
  using (public.can_view_character(public.form_character(form_id)));

-- Histórico de rolagens: rolagens privadas do Mestre nunca saem do banco para jogadores.
create policy rolls_select on public.roll_log for select to authenticated
  using (
    user_id = auth.uid()
    or (campaign_id is not null and visibility = 'public' and public.is_campaign_member(campaign_id))
    or (campaign_id is not null and visibility = 'master' and public.is_campaign_master(campaign_id))
    or (campaign_id is null and character_id is not null and visibility = 'public' and public.can_view_character(character_id))
  );
create policy rolls_insert on public.roll_log for insert to authenticated
  with check (
    user_id = auth.uid()
    and (campaign_id is null or public.is_campaign_member(campaign_id))
    and (character_id is null or public.can_edit_character(character_id))
    and (visibility <> 'master' or public.is_campaign_master(campaign_id))
  );

-- Tabelas do Mestre
create policy npcs_master on public.npcs for all to authenticated
  using (public.is_campaign_master(campaign_id)) with check (public.is_campaign_master(campaign_id));
create policy npcs_players on public.npcs for select to authenticated
  using (visible_to_players and public.is_campaign_member(campaign_id));

create policy combats_master on public.combats for all to authenticated
  using (public.is_campaign_master(campaign_id)) with check (public.is_campaign_master(campaign_id));
create policy combats_players on public.combats for select to authenticated
  using (public.is_campaign_member(campaign_id));

create policy combatants_master on public.combatants for all to authenticated
  using (exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_master(c.campaign_id)))
  with check (exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_master(c.campaign_id)));

create policy inv_master on public.investigations for all to authenticated
  using (public.is_campaign_master(campaign_id)) with check (public.is_campaign_master(campaign_id));
create policy inv_players on public.investigations for select to authenticated
  using (visible_to_players and public.is_campaign_member(campaign_id));
create policy invsec_master on public.investigation_secrets for all to authenticated
  using (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)))
  with check (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)));
create policy clues_master on public.clues for all to authenticated
  using (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)))
  with check (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)));
create policy clues_players on public.clues for select to authenticated
  using (revealed and exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_member(i.campaign_id)));

create policy reports_master on public.reports for all to authenticated
  using (public.is_campaign_master(campaign_id)) with check (public.is_campaign_master(campaign_id));
create policy reports_players on public.reports for select to authenticated
  using (public.is_campaign_member(campaign_id));

create policy notes_master on public.campaign_notes for all to authenticated
  using (public.is_campaign_master(campaign_id)) with check (public.is_campaign_master(campaign_id) and author_id = auth.uid());
create policy notes_players on public.campaign_notes for select to authenticated
  using (not is_private and public.is_campaign_member(campaign_id));

create policy audit_select on public.audit_log for select to authenticated
  using ((character_id is not null and public.can_view_character(character_id))
      or (campaign_id is not null and public.is_campaign_master(campaign_id)));

-- Visão dos combatentes para jogadores: oculta linhas escondidas e mascara recursos.
create or replace view public.combatants_public with (security_barrier = true) as
select cb.id, cb.combat_id, cb.character_id, cb.npc_id, cb.name, cb.initiative, cb.sort_order,
  case when cb.hide_stats then null else cb.pv_current end as pv_current,
  case when cb.hide_stats then null else cb.pv_max end as pv_max,
  case when cb.hide_stats then null else cb.pc_current end as pc_current,
  case when cb.hide_stats then null else cb.pc_max end as pc_max,
  cb.conditions
from public.combatants cb
join public.combats c on c.id = cb.combat_id
where public.is_campaign_member(c.campaign_id)
  and (not cb.hidden or public.is_campaign_master(c.campaign_id));
revoke all on public.combatants_public from anon;
grant select on public.combatants_public to authenticated;

-- =====================================================================
-- FUNÇÕES (RPC)
-- =====================================================================

-- Entrar numa campanha pelo código do convite.
create or replace function public.join_campaign(p_code text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  cid uuid;
begin
  if auth.uid() is null then
    raise exception 'É preciso estar autenticado.';
  end if;
  select campaign_id into cid from public.campaign_invites where code = p_code;
  if cid is null then
    raise exception 'Convite inválido ou expirado.';
  end if;
  insert into public.campaign_members (campaign_id, user_id, role)
  values (cid, auth.uid(), 'player')
  on conflict (campaign_id, user_id) do nothing;
  return cid;
end $$;

-- Prévia do convite (nome da campanha) sem ser membro.
create or replace function public.campaign_invite_preview(p_code text)
returns table (id uuid, name text, description text, master_username text, already_member boolean)
language sql stable security definer set search_path = public as $$
  select c.id, c.name, c.description, p.username::text,
         exists (select 1 from public.campaign_members m where m.campaign_id = c.id and m.user_id = auth.uid())
  from public.campaign_invites i
  join public.campaigns c on c.id = i.campaign_id
  join public.profiles p on p.id = c.owner_id
  where i.code = p_code and auth.uid() is not null;
$$;

-- Gera um novo código de convite (invalida o anterior).
create or replace function public.regenerate_invite(p_campaign uuid) returns text
language plpgsql security definer set search_path = public, extensions as $$
declare
  code_new text := encode(extensions.gen_random_bytes(9), 'hex');
begin
  if not public.is_campaign_master(p_campaign) then
    raise exception 'Apenas o Mestre pode gerar convites.';
  end if;
  update public.campaign_invites set code = code_new, created_at = now() where campaign_id = p_campaign;
  return code_new;
end $$;

-- Rolagem de atributos no servidor. Se já existe rolagem pendente, devolve a mesma
-- (recarregar a página não gera nova rolagem).
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  s int;
  f int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.attribute_rolls where form_id = p_form and assigned_attribute is not null) >= 8 then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..3 loop
    s := 0;
    for f in 1..3 loop
      faces := faces || public.roll_die(6);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * 5);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Atribui o maior resultado da rolagem pendente a um atributo vazio.
create or replace function public.assign_attribute_roll(p_roll uuid, p_attribute text) returns void
language plpgsql security definer set search_path = public as $$
declare
  r public.attribute_rolls;
begin
  select * into r from public.attribute_rolls where id = p_roll for update;
  if not found or not public.owns_character(public.form_character(r.form_id)) then
    raise exception 'Rolagem não encontrada.';
  end if;
  if r.assigned_attribute is not null then
    raise exception 'Esta rolagem já foi usada.';
  end if;
  if p_attribute not in ('FOR', 'DEX', 'INT', 'CON', 'MIT', 'PER', 'CAR', 'VIG') then
    raise exception 'Atributo inválido.';
  end if;
  if exists (select 1 from public.form_attributes where form_id = r.form_id and attribute = p_attribute and base_value is not null) then
    raise exception 'Esse atributo já tem valor.';
  end if;
  update public.attribute_rolls set assigned_attribute = p_attribute where id = p_roll;
  insert into public.form_attributes (form_id, attribute, base_value, roll_id)
  values (r.form_id, p_attribute, r.best, r.id)
  on conflict (form_id, attribute) do update set base_value = excluded.base_value, roll_id = excluded.roll_id;
end $$;

-- Gasto de PC atômico e idempotente (mesmo request_id nunca debita duas vezes).
create or replace function public.spend_pc(p_form uuid, p_amount int, p_request uuid, p_reason text default '')
returns int
language plpgsql security definer set search_path = public as $$
declare
  cur int;
begin
  if p_amount < 0 then
    raise exception 'Valor inválido.';
  end if;
  if not public.can_edit_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  select pc_current into cur from public.character_forms where id = p_form for update;
  if exists (select 1 from public.pc_transactions where request_id = p_request) then
    return cur;
  end if;
  if cur < p_amount then
    raise exception 'PC insuficiente (atual: %, necessário: %).', cur, p_amount;
  end if;
  update public.character_forms set pc_current = pc_current - p_amount where id = p_form returning pc_current into cur;
  insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
  values (p_request, p_form, -p_amount, p_reason, auth.uid());
  return cur;
end $$;

-- Permissões de execução
revoke execute on all functions in schema public from public, anon;
grant execute on function
  public.is_campaign_member(uuid), public.is_campaign_master(uuid),
  public.owns_character(uuid), public.can_view_character(uuid), public.can_edit_character(uuid),
  public.form_character(uuid),
  public.join_campaign(text), public.campaign_invite_preview(text), public.regenerate_invite(uuid),
  public.roll_attribute_set(uuid), public.assign_attribute_roll(uuid, text),
  public.spend_pc(uuid, int, uuid, text)
  to authenticated;
grant execute on function public.username_available(text) to anon, authenticated;

-- =====================================================================
-- TEMPO REAL
-- =====================================================================
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    alter publication supabase_realtime add table
      public.characters, public.character_forms, public.form_attributes, public.form_skills,
      public.items, public.powers, public.active_effects, public.roll_log,
      public.campaign_members, public.campaign_characters,
      public.npcs, public.combats, public.combatants, public.clues;
  end if;
end $$;


-- =====================================================================
-- >>> 20261022000000_rules_sync.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6"
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6"
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8"
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12"
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8"
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8"
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10"
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6"
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8"
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null
    }
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  return new;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

grant execute on function public.rules_config() to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;


-- =====================================================================
-- >>> 20261022000100_phase2_character.sql
-- =====================================================================
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


-- =====================================================================
-- >>> 20261023000000_rules_sync_fase3.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10-fase3) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10-fase3",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "skillDefs": {
    "luta": {
      "kind": "attribute",
      "attribute": "FOR",
      "divisor": 2
    },
    "reflexo": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "conhecimento_belico": {
      "kind": "attribute",
      "attribute": "INT",
      "divisor": 2
    },
    "arma_de_fogo": {
      "kind": "fixed",
      "value": 20
    },
    "pontaria": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "investigacao": {
      "kind": "fixed",
      "value": 20
    },
    "enganacao": {
      "kind": "fixed",
      "value": 15
    },
    "furtividade": {
      "kind": "fixed",
      "value": 20
    },
    "pilotagem": {
      "kind": "fixed",
      "value": 5
    },
    "intuicao": {
      "kind": "fixed",
      "value": 10
    }
  },
  "skillDistribution": {
    "skillsToChoose": 4,
    "totalPoints": 150,
    "maxSkillTotal": 75
  },
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "FOR": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "DEX": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {
        "PER": 4
      },
      "skillBonus": {},
      "maxSkillTotal": 95,
      "skillPointsBonus": 50
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "attributeBonus": {
        "MIT": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "arma_de_fogo": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "furtividade": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null,
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 2
      },
      "pcDice": null
    }
  },
  "weaponModifiers": {
    "afiada": "laminas",
    "perfurante": "perfurantes_projeteis",
    "serrilhada": "laminas",
    "precisa": "distancia",
    "equilibrada": "corpo_a_corpo",
    "pesada": "pesadas",
    "brutal": "pesadas",
    "concussiva": "contundentes",
    "gancho": "foices_correntes",
    "executora": "corpo_a_corpo",
    "rajada": "arma_de_fogo",
    "automatica": "arma_de_fogo",
    "curto_alcance": "arma_de_fogo",
    "mira_precisao": "arma_de_fogo",
    "recuo_pesado": "arma_de_fogo",
    "dispersao": "arma_de_fogo",
    "penetrante": "arma_de_fogo",
    "confiavel": "arma_de_fogo"
  },
  "maxWeaponModifiers": 2,
  "powers": {
    "damageSingle": [
      3,
      6,
      9,
      12,
      15
    ],
    "damageArea": [
      6,
      9,
      12,
      15,
      18
    ],
    "areaSizes": {
      "pequena": 0,
      "media": 3,
      "grande": 6,
      "enorme": 9
    },
    "extraDieCost": 3,
    "heal": [
      3,
      6,
      9,
      12,
      15
    ],
    "healArea": {
      "alvo": 0,
      "pequena": 6,
      "media": 9,
      "grande": 12,
      "enorme": 15
    },
    "healContinuous": [
      2,
      3,
      4,
      5,
      6
    ],
    "shield": [
      3,
      6,
      9,
      12,
      15
    ],
    "shieldDuration": {
      "1t": 0,
      "2t": 2,
      "3t": 4,
      "cena": 6
    },
    "conditions": {
      "leve": {
        "initial": 3,
        "perTurn": 1
      },
      "moderada": {
        "initial": 6,
        "perTurn": 2
      },
      "forte": {
        "initial": 9,
        "perTurn": 3
      },
      "severa": {
        "initial": 12,
        "perTurn": 4
      },
      "extrema": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "buffs": {
      "teste_1": {
        "initial": 3,
        "perTurn": 1
      },
      "teste_2": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_1": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_2": {
        "initial": 9,
        "perTurn": 3
      },
      "acao": {
        "initial": 12,
        "perTurn": 4
      },
      "grande": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "levelTable": [
      {
        "level": 1,
        "maxPc": 15,
        "maxExtraDice": 1
      },
      {
        "level": 2,
        "maxPc": 18,
        "maxExtraDice": 1
      },
      {
        "level": 4,
        "maxPc": 24,
        "maxExtraDice": 2
      },
      {
        "level": 6,
        "maxPc": 30,
        "maxExtraDice": 3
      },
      {
        "level": 8,
        "maxPc": 36,
        "maxExtraDice": 4
      },
      {
        "level": 10,
        "maxPc": 42,
        "maxExtraDice": 5
      },
      {
        "level": 15,
        "maxPc": 57,
        "maxExtraDice": 7
      },
      {
        "level": 20,
        "maxPc": 72,
        "maxExtraDice": 10
      }
    ],
    "limitMode": "linear",
    "perTurnCountsTowardLimit": false,
    "amaldicoadoRounding": "ceil",
    "amaldicoadoLimitUsesFullCost": true
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

grant execute on function public.rules_config() to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;


-- =====================================================================
-- >>> 20261023000100_fase3_sistemas.sql
-- =====================================================================
-- =====================================================================
-- F.R.A.N.C.E — Fase 3: inventário, modificadores, poderes, evolução de nível
-- e ficha secundária do Artificial.
-- INCREMENTAL: só adiciona colunas/funções/regras; não apaga nem recria tabelas.
-- Depende de 20261023000000_rules_sync_fase3.sql (rules_config v3).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Formas (ficha secundária do Artificial)
-- ---------------------------------------------------------------------
alter table public.character_forms
  add column if not exists setup_complete boolean not null default true;

-- Atributo-base só vem da rolagem enquanto o personagem OU a forma estão em criação.
create or replace function public.guard_draft_attributes() returns trigger
language plpgsql as $$
declare
  st text;
  ready boolean;
begin
  select c.status, f.setup_complete into st, ready
  from public.characters c join public.character_forms f on f.character_id = c.id
  where f.id = new.form_id;
  if (st = 'draft' or ready = false) and current_user in ('authenticated', 'anon')
     and (tg_op = 'INSERT' or new.base_value is distinct from old.base_value) then
    raise exception 'Durante a criação, os atributos vêm apenas das rolagens.';
  end if;
  return new;
end $$;

-- Forma ativa só pode ser "lenda" se a ficha da Lenda estiver pronta.
create or replace function public.validate_active_form() returns trigger
language plpgsql as $$
begin
  if new.active_form = 'lenda' and not exists (
    select 1 from public.character_forms f where f.character_id = new.id and f.kind = 'lenda' and f.setup_complete
  ) then
    raise exception 'A ficha da Lenda ainda não foi criada.';
  end if;
  return new;
end $$;
drop trigger if exists characters_active_form on public.characters;
create trigger characters_active_form before update of active_form on public.characters
  for each row execute function public.validate_active_form();

create or replace function public.create_lenda_form(p_character uuid, p_name text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  fid uuid;
begin
  if not public.owns_character(p_character) then
    raise exception 'Apenas o dono pode criar a ficha da Lenda.';
  end if;
  if not exists (select 1 from public.characters where id = p_character and origin_id = 'artificial' and status = 'active') then
    raise exception 'Somente personagens Artificiais finalizados têm a forma Lenda.';
  end if;
  select id into fid from public.character_forms where character_id = p_character and kind = 'lenda';
  if fid is not null then
    return fid;
  end if;
  insert into public.character_forms (character_id, kind, name, setup_complete)
  values (p_character, 'lenda', left(coalesce(nullif(trim(p_name), ''), 'Lenda'), 120), false)
  returning id into fid;
  return fid;
end $$;

-- Conclui a criação da Lenda. PV/PC iniciais são calculados pelo motor no servidor.
create or replace function public.complete_lenda_form(p_form uuid, p_pv int, p_pc int) returns void
language plpgsql security definer set search_path = public as $$
declare
  f public.character_forms;
begin
  select * into f from public.character_forms where id = p_form for update;
  if not found or f.kind <> 'lenda' or not public.owns_character(f.character_id) then
    raise exception 'Ficha da Lenda não encontrada.';
  end if;
  if f.setup_complete then
    return;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null) < 8 then
    raise exception 'Defina os oito atributos da Lenda.';
  end if;
  if trim(f.name) = '' then
    raise exception 'Dê um nome à Lenda.';
  end if;
  update public.character_forms
  set setup_complete = true, pv_current = greatest(p_pv, 0), pc_current = greatest(p_pc, 0)
  where id = p_form;
end $$;

-- ---------------------------------------------------------------------
-- 2. Evolução de nível (rolagens no servidor, uma vez por nível e forma)
-- ---------------------------------------------------------------------
create or replace function public.roll_simple_dice(p_dice jsonb) returns jsonb
language plpgsql volatile set search_path = public as $$
declare
  faces int[] := '{}';
  i int;
  total int := 0;
begin
  if p_dice is null or p_dice = 'null'::jsonb then
    return null;
  end if;
  for i in 1..(p_dice ->> 'count')::int loop
    faces := faces || public.roll_die((p_dice ->> 'sides')::int);
    total := total + faces[i];
  end loop;
  total := total + coalesce((p_dice ->> 'bonus')::int, 0);
  return jsonb_build_object('faces', to_jsonb(faces), 'bonus', coalesce((p_dice ->> 'bonus')::int, 0), 'total', total);
end $$;

create or replace function public.set_character_level(p_character uuid, p_level int) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  ch public.characters;
  dice jsonb;
  f record;
  l int;
  pv jsonb;
  pc jsonb;
  created jsonb := '[]'::jsonb;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar o nível.';
  end if;
  if p_level < (cfg -> 'levels' ->> 'min')::int or p_level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  select * into ch from public.characters where id = p_character for update;
  if ch.status <> 'active' then
    raise exception 'Finalize o personagem antes de mudar o nível.';
  end if;
  if ch.origin_id is not null and cfg -> 'progressionOverrides' ? ch.origin_id then
    dice := cfg -> 'progressionOverrides' -> ch.origin_id;
  elsif ch.class_id is not null then
    dice := cfg -> 'classes' -> ch.class_id;
  else
    raise exception 'Personagem sem classe.';
  end if;

  for f in select id from public.character_forms where character_id = p_character and setup_complete loop
    for l in 2..p_level loop
      if not exists (select 1 from public.level_progressions where form_id = f.id and level = l) then
        pv := public.roll_simple_dice(dice -> 'pvDice');
        pc := public.roll_simple_dice(dice -> 'pcDice');
        insert into public.level_progressions (form_id, level, pv_dice, pc_dice, pv_roll, pc_roll, pv_gain, pc_gain)
        values (f.id, l, dice ->> 'pv', dice ->> 'pc', pv, pc, (pv ->> 'total')::int, coalesce((pc ->> 'total')::int, 0))
        on conflict (form_id, level) do nothing;
        if found then
          created := created || jsonb_build_array(jsonb_build_object('form_id', f.id, 'level', l));
        end if;
      end if;
    end loop;
  end loop;

  update public.characters set level = p_level where id = p_character;
  return jsonb_build_object(
    'level', p_level,
    'created', created,
    'rows', coalesce((
      select jsonb_agg(jsonb_build_object('form_id', lp.form_id, 'kind', cf.kind, 'level', lp.level, 'pv_gain', lp.pv_gain, 'pc_gain', lp.pc_gain,
                                          'pv_roll', lp.pv_roll, 'pc_roll', lp.pc_roll, 'pv_dice', lp.pv_dice, 'pc_dice', lp.pc_dice) order by cf.kind, lp.level)
      from public.level_progressions lp join public.character_forms cf on cf.id = lp.form_id
      where cf.character_id = p_character and lp.level <= p_level), '[]'::jsonb)
  );
end $$;

-- ---------------------------------------------------------------------
-- 3. Inventário e modificadores de armas
-- ---------------------------------------------------------------------
alter table public.items add column if not exists damage_type text;
alter table public.items add column if not exists skill_override text;
alter table public.items add column if not exists tier text;
alter table public.items drop constraint if exists items_effect_kind_check;
alter table public.items add constraint items_effect_kind_check
  check (effect_kind is null or effect_kind in ('dano', 'cura', 'condicao', 'utilidade', 'personalizado', 'outro'));

create or replace function public.is_valid_dice(p text) returns boolean
language sql immutable as $$
  select p is null or regexp_replace(lower(p), '\s', '', 'g') ~ '^(\d{0,3}d\d{1,4}|\d{1,5})([+-](\d{0,3}d\d{1,4}|\d{1,5})){0,19}$';
$$;

create or replace function public.validate_item() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  t text;
begin
  if not public.is_valid_dice(new.effect_dice) then
    raise exception 'Expressão de dados inválida: %', new.effect_dice;
  end if;
  if new.skill_override is not null and not (cfg -> 'skills') ? new.skill_override then
    raise exception 'Perícia inválida para a arma.';
  end if;
  foreach t in array new.tags loop
    if not exists (select 1 from jsonb_each_text(cfg -> 'weaponModifiers') m where m.value = t) then
      raise exception 'Categoria de arma inválida: %', t;
    end if;
  end loop;
  return new;
end $$;
drop trigger if exists items_validate on public.items;
create trigger items_validate before insert or update on public.items
  for each row execute function public.validate_item();

-- Só modificadores compatíveis; até 2 permanentes; 1 temporário só para Prodígio do Arsenal.
create or replace function public.validate_item_modifier() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  req text := cfg -> 'weaponModifiers' ->> new.modifier_id;
  it record;
  n int;
begin
  if req is null then
    raise exception 'Modificador desconhecido.';
  end if;
  select i.tags, i.attack_kind, c.origin_id, c.origin_path_id into it
  from public.items i join public.characters c on c.id = i.character_id where i.id = new.item_id;
  if it.attack_kind is null then
    raise exception 'Modificadores só podem ser aplicados a armas.';
  end if;
  if not (req = any (it.tags)) then
    raise exception 'Modificador incompatível com esta arma.';
  end if;
  if new.is_temporary then
    if not (it.origin_id = 'prodigio' and it.origin_path_id = 'arsenal') then
      raise exception 'Modificadores temporários são exclusivos do Caminho do Arsenal.';
    end if;
    select count(*) into n from public.item_modifiers where item_id = new.item_id and is_temporary and id <> new.id;
    if n >= 1 then
      raise exception 'Apenas um modificador temporário por vez.';
    end if;
  else
    select count(*) into n from public.item_modifiers where item_id = new.item_id and not is_temporary and id <> new.id;
    if n >= (cfg ->> 'maxWeaponModifiers')::int then
      raise exception 'Cada arma suporta até % modificações.', cfg ->> 'maxWeaponModifiers';
    end if;
  end if;
  return new;
end $$;
drop trigger if exists item_modifiers_validate on public.item_modifiers;
create trigger item_modifiers_validate before insert or update on public.item_modifiers
  for each row execute function public.validate_item_modifier();

-- ---------------------------------------------------------------------
-- 4. Poderes: custo calculado NO BANCO com as tabelas do motor
-- ---------------------------------------------------------------------
create or replace function public.compute_power_cost(p_components jsonb, p_level int, p_origin text) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'powers';
  c jsonb;
  t text;
  tier int;
  ex int;
  base_cost int;
  area_cost int;
  full_initial int := 0;
  per_turn int := 0;
  extra int := 0;
  max_pc int;
  max_extra int := 1;
  row jsonb;
  initial int;
  per_turn_final int;
  limit_cost int;
  errors text[] := '{}';
  cursed boolean := p_origin = 'amaldicoado';
begin
  if p_components is null or jsonb_typeof(p_components) <> 'array' or jsonb_array_length(p_components) = 0 then
    errors := array_append(errors, 'Adicione pelo menos um efeito.');
  elsif jsonb_array_length(p_components) > 10 then
    errors := array_append(errors, 'Efeitos demais.');
  else
    for c in select * from jsonb_array_elements(p_components) loop
      begin
        t := c ->> 'type';
        tier := (c ->> 'tier')::int;
        ex := coalesce((c ->> 'extraDice')::int, 0);
        if ex < 0 or (t in ('damage', 'heal', 'heal_continuous', 'shield') and (tier is null or tier < 0)) then
          raise exception 'faixa';
        end if;
        if t = 'damage' then
          if c ->> 'area' = 'alvo' then
            base_cost := (cfg -> 'damageSingle' ->> tier)::int;
            area_cost := 0;
          else
            base_cost := (cfg -> 'damageArea' ->> tier)::int;
            area_cost := (cfg -> 'areaSizes' ->> (c ->> 'area'))::int;
          end if;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'heal' then
          base_cost := (cfg -> 'heal' ->> tier)::int;
          area_cost := (cfg -> 'healArea' ->> (c ->> 'area'))::int;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'heal_continuous' then
          base_cost := (cfg -> 'healContinuous' ->> tier)::int;
          if base_cost is null then raise exception 'x'; end if;
          per_turn := per_turn + base_cost;
        elsif t = 'shield' then
          base_cost := (cfg -> 'shield' ->> tier)::int;
          area_cost := (cfg -> 'shieldDuration' ->> (c ->> 'duration'))::int;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'condition' then
          row := cfg -> 'conditions' -> (c ->> 'intensity');
          if row is null then raise exception 'x'; end if;
          full_initial := full_initial + (row ->> 'initial')::int;
          per_turn := per_turn + (row ->> 'perTurn')::int;
        elsif t = 'buff' then
          row := cfg -> 'buffs' -> (c ->> 'buff');
          if row is null then raise exception 'x'; end if;
          full_initial := full_initial + (row ->> 'initial')::int;
          per_turn := per_turn + (row ->> 'perTurn')::int;
        else
          raise exception 'x';
        end if;
      exception when others then
        errors := array_append(errors, 'Efeito inválido.');
      end;
    end loop;
  end if;

  for row in select * from jsonb_array_elements(cfg -> 'levelTable') loop
    if (row ->> 'level')::int <= p_level then
      max_extra := (row ->> 'maxExtraDice')::int;
      max_pc := (row ->> 'maxPc')::int;
    end if;
  end loop;
  if cfg ->> 'limitMode' = 'linear' then
    max_pc := 15 + 3 * (p_level - 1);
  end if;

  initial := case when cursed then
      case cfg ->> 'amaldicoadoRounding' when 'ceil' then ceil(full_initial / 2.0) when 'round' then round(full_initial / 2.0) else floor(full_initial / 2.0) end
    else full_initial end;
  per_turn_final := case when cursed then
      case cfg ->> 'amaldicoadoRounding' when 'ceil' then ceil(per_turn / 2.0) when 'round' then round(per_turn / 2.0) else floor(per_turn / 2.0) end
    else per_turn end;
  limit_cost := (case when cursed and not (cfg ->> 'amaldicoadoLimitUsesFullCost')::boolean then initial else full_initial end)
              + (case when (cfg ->> 'perTurnCountsTowardLimit')::boolean then per_turn else 0 end);
  if limit_cost > max_pc then
    errors := array_append(errors, format('Custo de %s PC acima do limite de %s PC no nível %s.', limit_cost, max_pc, p_level));
  end if;
  if extra > max_extra then
    errors := array_append(errors, format('%s dados extras acima do máximo de +%s no nível %s.', extra, max_extra, p_level));
  end if;
  return jsonb_build_object('full_initial', full_initial, 'initial', initial, 'per_turn', per_turn_final, 'extra_dice', extra,
                            'max_pc', max_pc, 'max_extra_dice', max_extra, 'valid', cardinality(errors) = 0, 'errors', to_jsonb(errors));
end $$;

create or replace function public.validate_power() returns trigger
language plpgsql as $$
declare
  ch record;
  cost jsonb;
begin
  if tg_op = 'UPDATE' and new.components = old.components and new.character_id = old.character_id then
    -- Componentes iguais: custo gravado continua o mesmo (mudar nome, favorito etc.).
    new.initial_cost := old.initial_cost;
    new.per_turn_cost := old.per_turn_cost;
    return new;
  end if;
  select level, origin_id into ch from public.characters where id = new.character_id;
  cost := public.compute_power_cost(new.components, ch.level, ch.origin_id);
  if not (cost ->> 'valid')::boolean then
    raise exception 'Poder inválido: %', array_to_string(array(select jsonb_array_elements_text(cost -> 'errors')), ' ');
  end if;
  -- O banco grava o custo calculado por ele mesmo (o valor enviado pelo navegador é ignorado).
  new.initial_cost := (cost ->> 'initial')::int;
  new.per_turn_cost := (cost ->> 'per_turn')::int;
  return new;
end $$;
drop trigger if exists powers_validate on public.powers;
create trigger powers_validate before insert or update on public.powers
  for each row execute function public.validate_power();

-- ---------------------------------------------------------------------
-- 5. Uso de poderes e efeitos contínuos (débito atômico e idempotente)
-- ---------------------------------------------------------------------
alter table public.active_effects add column if not exists turns_total int not null default 0;
alter table public.active_effects add column if not exists activation_request uuid unique;
alter table public.active_effects add column if not exists ended_at timestamptz;

-- Efeitos só mudam pelas funções abaixo (leitura continua liberada a quem vê a ficha).
drop policy if exists effects_write on public.active_effects;

create or replace function public.use_power(p_power uuid, p_form uuid, p_request uuid, p_turns int default 0) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  pw public.powers;
  fm public.character_forms;
  eff uuid;
begin
  select * into pw from public.powers where id = p_power;
  select * into fm from public.character_forms where id = p_form for update;
  if pw.id is null or fm.id is null or pw.character_id <> fm.character_id then
    raise exception 'Poder ou forma inválidos.';
  end if;
  if not public.can_edit_character(pw.character_id) then
    raise exception 'Sem permissão.';
  end if;
  if exists (select 1 from public.pc_transactions where request_id = p_request) then
    select id into eff from public.active_effects where activation_request = p_request;
    return jsonb_build_object('pc_current', fm.pc_current, 'effect_id', eff, 'duplicate', true, 'cost', pw.initial_cost);
  end if;
  if fm.pc_current < pw.initial_cost then
    raise exception 'PC insuficiente (atual: %, necessário: %).', fm.pc_current, pw.initial_cost;
  end if;
  update public.character_forms set pc_current = pc_current - pw.initial_cost where id = p_form returning * into fm;
  insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
  values (p_request, p_form, -pw.initial_cost, 'Poder: ' || pw.name, auth.uid());
  if pw.per_turn_cost > 0 and coalesce(p_turns, 0) > 0 then
    insert into public.active_effects (character_id, form_id, power_id, label, per_turn_cost, turns_total, activation_request)
    values (pw.character_id, p_form, pw.id, pw.name, pw.per_turn_cost, least(p_turns, 100), p_request)
    returning id into eff;
  end if;
  return jsonb_build_object('pc_current', fm.pc_current, 'effect_id', eff, 'duplicate', false, 'cost', pw.initial_cost);
end $$;

create or replace function public.advance_effect(p_effect uuid, p_request uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  ef public.active_effects;
  fm public.character_forms;
begin
  select * into ef from public.active_effects where id = p_effect for update;
  if ef.id is null or not public.can_edit_character(ef.character_id) then
    raise exception 'Efeito não encontrado.';
  end if;
  select * into fm from public.character_forms where id = ef.form_id for update;
  if exists (select 1 from public.pc_transactions where request_id = p_request) then
    return jsonb_build_object('pc_current', fm.pc_current, 'turns_paid', ef.turns_paid, 'turns_total', ef.turns_total, 'active', ef.active, 'duplicate', true);
  end if;
  if not ef.active then
    raise exception 'Este efeito já foi encerrado.';
  end if;
  if fm.pc_current < ef.per_turn_cost then
    raise exception 'PC insuficiente para manter o efeito (atual: %, necessário: %).', fm.pc_current, ef.per_turn_cost;
  end if;
  update public.character_forms set pc_current = pc_current - ef.per_turn_cost where id = fm.id returning * into fm;
  insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
  values (p_request, fm.id, -ef.per_turn_cost, 'Manutenção: ' || ef.label, auth.uid());
  update public.active_effects
  set turns_paid = turns_paid + 1,
      active = (turns_total = 0 or turns_paid + 1 < turns_total),
      ended_at = case when turns_total > 0 and turns_paid + 1 >= turns_total then now() end
  where id = ef.id returning * into ef;
  return jsonb_build_object('pc_current', fm.pc_current, 'turns_paid', ef.turns_paid, 'turns_total', ef.turns_total, 'active', ef.active, 'duplicate', false);
end $$;

create or replace function public.end_effect(p_effect uuid) returns void
language plpgsql security definer set search_path = public as $$
declare
  ef public.active_effects;
begin
  select * into ef from public.active_effects where id = p_effect;
  if ef.id is null or not public.can_edit_character(ef.character_id) then
    raise exception 'Efeito não encontrado.';
  end if;
  update public.active_effects set active = false, ended_at = coalesce(ended_at, now()) where id = p_effect;
end $$;

-- spend_pc (Fase 1) recebia o valor do navegador; agora só ajustes manuais passam
-- por adjust_form_resource e poderes passam por use_power.
revoke execute on function public.spend_pc(uuid, int, uuid, text) from authenticated;

-- ---------------------------------------------------------------------
-- 6. Permissões de execução
-- ---------------------------------------------------------------------
revoke execute on function public.roll_simple_dice(jsonb) from public, anon, authenticated;
grant execute on function
  public.create_lenda_form(uuid, text),
  public.complete_lenda_form(uuid, int, int),
  public.set_character_level(uuid, int),
  public.compute_power_cost(jsonb, int, text),
  public.is_valid_dice(text),
  public.use_power(uuid, uuid, uuid, int),
  public.advance_effect(uuid, uuid),
  public.end_effect(uuid)
  to authenticated;


-- =====================================================================
-- >>> 20261024000000_rules_sync_3_5.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10-3.5) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10-3.5",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "pvFormula": "sum_div3",
  "abilities": {
    "base": 2,
    "perEvenLevel": 1,
    "blockLevelUpWhenPending": true,
    "originModes": {
      "muto": "none",
      "elo": "free"
    },
    "pathOverrides": {
      "prodigio:arsenal": {
        "base": 0,
        "perEvenLevel": 1
      },
      "prodigio:engrenagem": {
        "base": 1,
        "perEvenLevel": 1
      }
    }
  },
  "prodigioPowers": {
    "noPcCost": true,
    "noLimits": true,
    "allowNoEffects": true
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "skillDefs": {
    "luta": {
      "kind": "attribute",
      "attribute": "FOR",
      "divisor": 2
    },
    "reflexo": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "conhecimento_belico": {
      "kind": "attribute",
      "attribute": "INT",
      "divisor": 2
    },
    "arma_de_fogo": {
      "kind": "fixed",
      "value": 20
    },
    "pontaria": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "investigacao": {
      "kind": "fixed",
      "value": 20
    },
    "enganacao": {
      "kind": "fixed",
      "value": 15
    },
    "furtividade": {
      "kind": "fixed",
      "value": 20
    },
    "pilotagem": {
      "kind": "fixed",
      "value": 5
    },
    "intuicao": {
      "kind": "fixed",
      "value": 10
    }
  },
  "skillDistribution": {
    "skillsToChoose": 4,
    "totalPoints": 150,
    "maxSkillTotal": 75
  },
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "FOR": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "DEX": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {
        "PER": 4
      },
      "skillBonus": {},
      "maxSkillTotal": 95,
      "skillPointsBonus": 50,
      "pvBonusAtLevel1": 0
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "attributeBonus": {
        "MIT": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "arma_de_fogo": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "furtividade": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 20
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null,
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 2
      },
      "pcDice": null
    }
  },
  "weaponModifiers": {
    "afiada": "laminas",
    "perfurante": "perfurantes_projeteis",
    "serrilhada": "laminas",
    "precisa": "distancia",
    "equilibrada": "corpo_a_corpo",
    "pesada": "pesadas",
    "brutal": "pesadas",
    "concussiva": "contundentes",
    "gancho": "foices_correntes",
    "executora": "corpo_a_corpo",
    "rajada": "arma_de_fogo",
    "automatica": "arma_de_fogo",
    "curto_alcance": "arma_de_fogo",
    "mira_precisao": "arma_de_fogo",
    "recuo_pesado": "arma_de_fogo",
    "dispersao": "arma_de_fogo",
    "penetrante": "arma_de_fogo",
    "confiavel": "arma_de_fogo"
  },
  "maxWeaponModifiers": 2,
  "powers": {
    "damageSingle": [
      3,
      6,
      9,
      12,
      15
    ],
    "damageArea": [
      6,
      9,
      12,
      15,
      18
    ],
    "areaSizes": {
      "pequena": 0,
      "media": 3,
      "grande": 6,
      "enorme": 9
    },
    "extraDieCost": 3,
    "heal": [
      3,
      6,
      9,
      12,
      15
    ],
    "healArea": {
      "alvo": 0,
      "pequena": 6,
      "media": 9,
      "grande": 12,
      "enorme": 15
    },
    "healContinuous": [
      2,
      3,
      4,
      5,
      6
    ],
    "shield": [
      3,
      6,
      9,
      12,
      15
    ],
    "shieldDuration": {
      "1t": 0,
      "2t": 2,
      "3t": 4,
      "cena": 6
    },
    "conditions": {
      "leve": {
        "initial": 3,
        "perTurn": 1
      },
      "moderada": {
        "initial": 6,
        "perTurn": 2
      },
      "forte": {
        "initial": 9,
        "perTurn": 3
      },
      "severa": {
        "initial": 12,
        "perTurn": 4
      },
      "extrema": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "buffs": {
      "teste_1": {
        "initial": 3,
        "perTurn": 1
      },
      "teste_2": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_1": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_2": {
        "initial": 9,
        "perTurn": 3
      },
      "acao": {
        "initial": 12,
        "perTurn": 4
      },
      "grande": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "levelTable": [
      {
        "level": 1,
        "maxPc": 15,
        "maxExtraDice": 1
      },
      {
        "level": 2,
        "maxPc": 18,
        "maxExtraDice": 1
      },
      {
        "level": 4,
        "maxPc": 24,
        "maxExtraDice": 2
      },
      {
        "level": 6,
        "maxPc": 30,
        "maxExtraDice": 3
      },
      {
        "level": 8,
        "maxPc": 36,
        "maxExtraDice": 4
      },
      {
        "level": 10,
        "maxPc": 42,
        "maxExtraDice": 5
      },
      {
        "level": 15,
        "maxPc": 57,
        "maxExtraDice": 7
      },
      {
        "level": 20,
        "maxPc": 72,
        "maxExtraDice": 10
      }
    ],
    "limitMode": "linear",
    "perTurnCountsTowardLimit": false,
    "amaldicoadoRounding": "ceil",
    "amaldicoadoLimitUsesFullCost": true
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

-- ---------------------------------------------------------------------
-- PV máximo da forma — mesma conta do motor (buildSheet):
-- (FOR + CON) ÷ 3 para baixo + bônus de classe + ganhos de nível ativos + outros bônus.
-- ---------------------------------------------------------------------
create or replace function public.form_pv_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  str int;
  con int;
  base int;
  gains int;
begin
  select cf.id, cf.kind, cf.pv_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into str
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'FOR';
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into con
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'CON';
  str := coalesce(str, 0) + coalesce((cls -> 'attributeBonus' ->> 'FOR')::int, 0);
  con := coalesce(con, 0) + coalesce((cls -> 'attributeBonus' ->> 'CON')::int, 0);
  if cfg ->> 'pvFormula' = 'sum_div3' then
    base := floor((str + con)::numeric / 3)::int;
  else
    base := str + floor(con::numeric / 3)::int;
  end if;
  base := base + coalesce((cls ->> 'pvBonusAtLevel1')::int, 0);
  select coalesce(sum(lp.pv_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, base + gains + f.pv_other_bonus);
end $$;

-- ---------------------------------------------------------------------
-- Vagas de habilidades — mesma conta do motor (abilities.ts).
-- mode: standard | free (Elo) | none (Muto). Executa com as permissões de quem chama.
-- ---------------------------------------------------------------------
create or replace function public.ability_granted(p_origin text, p_path text, p_level int) returns int
language plpgsql immutable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ov jsonb := cfg -> 'pathOverrides' -> (p_origin || ':' || p_path);
begin
  if coalesce(cfg -> 'originModes' ->> p_origin, 'standard') <> 'standard' then
    return 0;
  end if;
  return coalesce((ov ->> 'base')::int, (cfg ->> 'base')::int)
       + coalesce((ov ->> 'perEvenLevel')::int, (cfg ->> 'perEvenLevel')::int) * (greatest(p_level, 1) / 2);
end $$;

create or replace function public.ability_status(p_character uuid) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ch record;
  created int;
begin
  select level, origin_id, origin_path_id into ch from public.characters where id = p_character;
  select count(*) into created from public.powers where character_id = p_character;
  return jsonb_build_object(
    'mode', coalesce(cfg -> 'originModes' ->> ch.origin_id, 'standard'),
    'granted', public.ability_granted(ch.origin_id, ch.origin_path_id, ch.level),
    'created', created,
    'level', ch.level);
end $$;

grant execute on function public.rules_config() to authenticated;
grant execute on function public.form_pv_max(uuid), public.ability_granted(text, text, int), public.ability_status(uuid) to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;


-- =====================================================================
-- >>> 20261024000100_atualizacao_3_5.sql
-- =====================================================================
-- =====================================================================
-- F.R.A.N.C.E — Atualização 3.5
-- PV (FOR + CON) ÷ 3, vagas de habilidades e bloqueio de evolução,
-- equipamento inicial das classes, Prodígio sem PC, velocidade das rolagens.
-- INCREMENTAL: só adiciona colunas/funções e ajusta dados com registro.
-- Não apaga personagens, contas, poderes nem inventários.
-- Depende de 20261024000000_rules_sync_3_5.sql (rules_config 3.5, form_pv_max, ability_status).
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Configuração do usuário: velocidade das rolagens
-- ---------------------------------------------------------------------
alter table public.profiles add column if not exists roll_speed text not null default 'fast';
alter table public.profiles drop constraint if exists profiles_roll_speed_check;
alter table public.profiles add constraint profiles_roll_speed_check check (roll_speed in ('instant', 'fast', 'normal'));

-- ---------------------------------------------------------------------
-- 2. Equipamento inicial das classes
--    starting_kit: escolhas feitas na criação ({"vaga": "opção"}).
--    items.kit_ref: "kit:<classe>:<vaga>" — uma vaga nunca é entregue duas vezes.
-- ---------------------------------------------------------------------
alter table public.characters add column if not exists starting_kit jsonb not null default '{}'::jsonb;
alter table public.items add column if not exists kit_ref text;
alter table public.items drop constraint if exists items_kit_ref_unique;
alter table public.items add constraint items_kit_ref_unique unique (character_id, kit_ref);
alter table public.items drop constraint if exists items_kit_ref_format;
alter table public.items add constraint items_kit_ref_format check (kit_ref is null or kit_ref ~ '^kit:[a-z_]+:[a-z_]+$');

-- Trocar de classe apaga as escolhas anteriores (os itens só são entregues ao finalizar).
create or replace function public.reset_kit_on_class_change() returns trigger
language plpgsql as $$
begin
  if new.class_id is distinct from old.class_id then
    new.starting_kit := '{}'::jsonb;
  end if;
  return new;
end $$;
drop trigger if exists characters_reset_kit on public.characters;
create trigger characters_reset_kit before update of class_id on public.characters
  for each row execute function public.reset_kit_on_class_change();

-- ---------------------------------------------------------------------
-- 3. Poderes: custo com a regra do Prodígio (sem PC, sem limites)
-- ---------------------------------------------------------------------
create or replace function public.compute_power_cost(p_components jsonb, p_level int, p_origin text) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'powers';
  c jsonb;
  t text;
  tier int;
  ex int;
  base_cost int;
  area_cost int;
  full_initial int := 0;
  per_turn int := 0;
  extra int := 0;
  max_pc int;
  max_extra int := 1;
  row jsonb;
  initial int;
  per_turn_final int;
  limit_cost int;
  errors text[] := '{}';
  cursed boolean := p_origin = 'amaldicoado';
  -- Prodígio (Atualização 3.5): sem custo de PC, sem limites, pode não ter efeito de dados.
  pp jsonb := case when p_origin = 'prodigio' then public.rules_config() -> 'prodigioPowers' else '{}'::jsonb end;
  limited boolean := not coalesce((pp ->> 'noLimits')::boolean, false);
begin
  if p_components is null or jsonb_typeof(p_components) <> 'array' then
    errors := array_append(errors, 'Adicione pelo menos um efeito.');
  elsif jsonb_array_length(p_components) = 0 then
    if not coalesce((pp ->> 'allowNoEffects')::boolean, false) then
      errors := array_append(errors, 'Adicione pelo menos um efeito.');
    end if;
  elsif jsonb_array_length(p_components) > 10 then
    errors := array_append(errors, 'Efeitos demais.');
  else
    for c in select * from jsonb_array_elements(p_components) loop
      begin
        t := c ->> 'type';
        tier := (c ->> 'tier')::int;
        ex := coalesce((c ->> 'extraDice')::int, 0);
        if ex < 0 or (t in ('damage', 'heal', 'heal_continuous', 'shield') and (tier is null or tier < 0)) then
          raise exception 'faixa';
        end if;
        if t = 'damage' then
          if c ->> 'area' = 'alvo' then
            base_cost := (cfg -> 'damageSingle' ->> tier)::int;
            area_cost := 0;
          else
            base_cost := (cfg -> 'damageArea' ->> tier)::int;
            area_cost := (cfg -> 'areaSizes' ->> (c ->> 'area'))::int;
          end if;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'heal' then
          base_cost := (cfg -> 'heal' ->> tier)::int;
          area_cost := (cfg -> 'healArea' ->> (c ->> 'area'))::int;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'heal_continuous' then
          base_cost := (cfg -> 'healContinuous' ->> tier)::int;
          if base_cost is null then raise exception 'x'; end if;
          per_turn := per_turn + base_cost;
        elsif t = 'shield' then
          base_cost := (cfg -> 'shield' ->> tier)::int;
          area_cost := (cfg -> 'shieldDuration' ->> (c ->> 'duration'))::int;
          if base_cost is null or area_cost is null then raise exception 'x'; end if;
          full_initial := full_initial + base_cost + ex * (cfg ->> 'extraDieCost')::int + area_cost;
          extra := extra + ex;
        elsif t = 'condition' then
          row := cfg -> 'conditions' -> (c ->> 'intensity');
          if row is null then raise exception 'x'; end if;
          full_initial := full_initial + (row ->> 'initial')::int;
          per_turn := per_turn + (row ->> 'perTurn')::int;
        elsif t = 'buff' then
          row := cfg -> 'buffs' -> (c ->> 'buff');
          if row is null then raise exception 'x'; end if;
          full_initial := full_initial + (row ->> 'initial')::int;
          per_turn := per_turn + (row ->> 'perTurn')::int;
        else
          raise exception 'x';
        end if;
      exception when others then
        errors := array_append(errors, 'Efeito inválido.');
      end;
    end loop;
  end if;

  for row in select * from jsonb_array_elements(cfg -> 'levelTable') loop
    if (row ->> 'level')::int <= p_level then
      max_extra := (row ->> 'maxExtraDice')::int;
      max_pc := (row ->> 'maxPc')::int;
    end if;
  end loop;
  if cfg ->> 'limitMode' = 'linear' then
    max_pc := 15 + 3 * (p_level - 1);
  end if;

  initial := case when cursed then
      case cfg ->> 'amaldicoadoRounding' when 'ceil' then ceil(full_initial / 2.0) when 'round' then round(full_initial / 2.0) else floor(full_initial / 2.0) end
    else full_initial end;
  per_turn_final := case when cursed then
      case cfg ->> 'amaldicoadoRounding' when 'ceil' then ceil(per_turn / 2.0) when 'round' then round(per_turn / 2.0) else floor(per_turn / 2.0) end
    else per_turn end;
  if coalesce((pp ->> 'noPcCost')::boolean, false) then
    initial := 0;
    per_turn_final := 0;
  end if;
  limit_cost := (case when cursed and not (cfg ->> 'amaldicoadoLimitUsesFullCost')::boolean then initial else full_initial end)
              + (case when (cfg ->> 'perTurnCountsTowardLimit')::boolean then per_turn else 0 end);
  if limited and limit_cost > max_pc then
    errors := array_append(errors, format('Custo de %s PC acima do limite de %s PC no nível %s.', limit_cost, max_pc, p_level));
  end if;
  if limited and extra > max_extra then
    errors := array_append(errors, format('%s dados extras acima do máximo de +%s no nível %s.', extra, max_extra, p_level));
  end if;
  return jsonb_build_object('full_initial', full_initial, 'initial', initial, 'per_turn', per_turn_final, 'extra_dice', extra,
                            'max_pc', max_pc, 'max_extra_dice', max_extra, 'unlimited', not limited, 'valid', cardinality(errors) = 0, 'errors', to_jsonb(errors));
end $$;

-- Valida e grava o custo calculado pelo banco.
--  * Inserção: confere vagas de habilidades (regra geral; Elo e Muto livres).
--  * Edição dos efeitos: precisa caber nos limites do nível atual.
--  * Edição só de nome/favorito: aceita poderes antigos fora do limite (nada é apagado).
create or replace function public.validate_power() returns trigger
language plpgsql as $$
declare
  ch record;
  cost jsonb;
  st jsonb;
  effects_changed boolean := true;
begin
  if tg_op = 'UPDATE' then
    effects_changed := new.components is distinct from old.components or new.character_id <> old.character_id;
  end if;
  select level, origin_id into ch from public.characters where id = new.character_id;
  cost := public.compute_power_cost(new.components, ch.level, ch.origin_id);
  if effects_changed and not (cost ->> 'valid')::boolean then
    raise exception 'Poder inválido: %', array_to_string(array(select jsonb_array_elements_text(cost -> 'errors')), ' ');
  end if;
  if tg_op = 'INSERT' then
    st := public.ability_status(new.character_id);
    if st ->> 'mode' = 'standard' and (st ->> 'created')::int >= (st ->> 'granted')::int then
      raise exception 'Sem habilidades disponíveis: % de % já criadas neste nível.', st ->> 'created', st ->> 'granted';
    end if;
  end if;
  -- O banco grava o custo calculado por ele mesmo (o valor enviado pelo navegador é ignorado).
  new.initial_cost := coalesce((cost ->> 'initial')::int, 0);
  new.per_turn_cost := coalesce((cost ->> 'per_turn')::int, 0);
  return new;
end $$;
drop trigger if exists powers_validate on public.powers;
create trigger powers_validate before insert or update on public.powers
  for each row execute function public.validate_power();

-- Uso de poder: efeito contínuo depende dos EFEITOS (não do custo), para o Prodígio também ter estado ativo.
create or replace function public.use_power(p_power uuid, p_form uuid, p_request uuid, p_turns int default 0) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  pw public.powers;
  fm public.character_forms;
  eff uuid;
  continuous boolean;
begin
  select * into pw from public.powers where id = p_power;
  select * into fm from public.character_forms where id = p_form for update;
  if pw.id is null or fm.id is null or pw.character_id <> fm.character_id then
    raise exception 'Poder ou forma inválidos.';
  end if;
  if not public.can_edit_character(pw.character_id) then
    raise exception 'Sem permissão.';
  end if;
  if exists (select 1 from public.pc_transactions where request_id = p_request) then
    select id into eff from public.active_effects where activation_request = p_request;
    return jsonb_build_object('pc_current', fm.pc_current, 'effect_id', eff, 'duplicate', true, 'cost', pw.initial_cost);
  end if;
  if fm.pc_current < pw.initial_cost then
    raise exception 'PC insuficiente (atual: %, necessário: %).', fm.pc_current, pw.initial_cost;
  end if;
  if pw.initial_cost > 0 then
    update public.character_forms set pc_current = pc_current - pw.initial_cost where id = p_form returning * into fm;
  end if;
  insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
  values (p_request, p_form, -pw.initial_cost, 'Poder: ' || pw.name, auth.uid());
  continuous := pw.per_turn_cost > 0 or exists (
    select 1 from jsonb_array_elements(pw.components) c where c ->> 'type' in ('heal_continuous', 'condition', 'buff'));
  if continuous and coalesce(p_turns, 0) > 0 then
    insert into public.active_effects (character_id, form_id, power_id, label, per_turn_cost, turns_total, activation_request)
    values (pw.character_id, p_form, pw.id, pw.name, pw.per_turn_cost, least(p_turns, 100), p_request)
    returning id into eff;
  end if;
  return jsonb_build_object('pc_current', fm.pc_current, 'effect_id', eff, 'duplicate', false, 'cost', pw.initial_cost);
end $$;

-- ---------------------------------------------------------------------
-- 4. Evolução: bloqueada enquanto houver habilidades pendentes
--    Para chegar ao nível L é preciso ter criado as habilidades de L−1 (validado nível a nível).
-- ---------------------------------------------------------------------
create or replace function public.set_character_level(p_character uuid, p_level int) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  ch public.characters;
  dice jsonb;
  f record;
  l int;
  pv jsonb;
  pc jsonb;
  created jsonb := '[]'::jsonb;
  n_powers int;
  needed int;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar o nível.';
  end if;
  if p_level < (cfg -> 'levels' ->> 'min')::int or p_level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  select * into ch from public.characters where id = p_character for update;
  if ch.status <> 'active' then
    raise exception 'Finalize o personagem antes de mudar o nível.';
  end if;

  if p_level > ch.level and coalesce((cfg -> 'abilities' ->> 'blockLevelUpWhenPending')::boolean, false)
     and coalesce(cfg -> 'abilities' -> 'originModes' ->> ch.origin_id, 'standard') = 'standard' then
    select count(*) into n_powers from public.powers where character_id = p_character;
    for l in ch.level..(p_level - 1) loop
      needed := public.ability_granted(ch.origin_id, ch.origin_path_id, l);
      if n_powers < needed then
        raise exception 'EVOLUÇÃO BLOQUEADA: você ainda possui habilidades disponíveis para criar (nível %: % de %). Finalize suas habilidades antes de avançar para o próximo nível.', l, n_powers, needed;
      end if;
    end loop;
  end if;

  if ch.origin_id is not null and cfg -> 'progressionOverrides' ? ch.origin_id then
    dice := cfg -> 'progressionOverrides' -> ch.origin_id;
  elsif ch.class_id is not null then
    dice := cfg -> 'classes' -> ch.class_id;
  else
    raise exception 'Personagem sem classe.';
  end if;

  for f in select id from public.character_forms where character_id = p_character and setup_complete loop
    for l in 2..p_level loop
      if not exists (select 1 from public.level_progressions where form_id = f.id and level = l) then
        pv := public.roll_simple_dice(dice -> 'pvDice');
        pc := public.roll_simple_dice(dice -> 'pcDice');
        insert into public.level_progressions (form_id, level, pv_dice, pc_dice, pv_roll, pc_roll, pv_gain, pc_gain)
        values (f.id, l, dice ->> 'pv', dice ->> 'pc', pv, pc, (pv ->> 'total')::int, coalesce((pc ->> 'total')::int, 0))
        on conflict (form_id, level) do nothing;
        if found then
          created := created || jsonb_build_array(jsonb_build_object('form_id', f.id, 'level', l));
        end if;
      end if;
    end loop;
  end loop;

  update public.characters set level = p_level where id = p_character;

  -- PV/PC atuais nunca ficam acima do novo máximo (descer de nível suspende ganhos).
  update public.character_forms cf
  set pv_current = least(cf.pv_current, public.form_pv_max(cf.id))
  where cf.character_id = p_character and cf.setup_complete and cf.pv_current > public.form_pv_max(cf.id);

  return jsonb_build_object(
    'level', p_level,
    'created', created,
    'rows', coalesce((
      select jsonb_agg(jsonb_build_object('form_id', lp.form_id, 'kind', cf.kind, 'level', lp.level, 'pv_gain', lp.pv_gain, 'pc_gain', lp.pc_gain,
                                          'pv_roll', lp.pv_roll, 'pc_roll', lp.pc_roll, 'pv_dice', lp.pv_dice, 'pc_dice', lp.pc_dice) order by cf.kind, lp.level)
      from public.level_progressions lp join public.character_forms cf on cf.id = lp.form_id
      where cf.character_id = p_character and lp.level <= p_level), '[]'::jsonb)
  );
end $$;

-- Ajuste atômico de PV/PC: para PV o banco usa o próprio máximo (form_pv_max), sem confiar no valor enviado.
create or replace function public.adjust_form_resource(p_form uuid, p_resource text, p_delta int, p_max int)
returns int
language plpgsql security definer set search_path = public as $$
declare
  v int;
  cap int;
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
    cap := least(p_max, coalesce(public.form_pv_max(p_form), p_max));
    update public.character_forms set pv_current = least(greatest(pv_current + p_delta, 0), cap)
    where id = p_form returning pv_current into v;
  else
    update public.character_forms set pc_current = least(greatest(pc_current + p_delta, 0), p_max)
    where id = p_form returning pc_current into v;
  end if;
  return v;
end $$;

-- ---------------------------------------------------------------------
-- 5. Ajuste seguro dos dados existentes (idempotente, com registro)
-- ---------------------------------------------------------------------
-- 5.1 PV: o máximo passa a ser (FOR + CON) ÷ 3 (+ classe, + níveis, + outros). Ele é sempre
--     recalculado a partir dos atributos — nada derivado é apagado. Só o PV ATUAL acima do novo
--     máximo é reduzido, e cada mudança fica registrada em pv_formula_fix_log.
create table if not exists public.pv_formula_fix_log (
  id bigserial primary key,
  form_id uuid not null,
  character_id uuid not null,
  old_pv_current int not null,
  new_pv_current int not null,
  new_pv_max int not null,
  fixed_at timestamptz not null default now()
);
alter table public.pv_formula_fix_log enable row level security;
-- Sem políticas: só administradores (SQL Editor) leem o registro.

-- Rotina reaplicável: só mexe em quem está acima do novo máximo. Retorna quantas formas foram ajustadas.
create or replace function public.fix_pv_after_formula_change() returns int
language plpgsql security definer set search_path = public as $$
declare
  n int;
begin
  with fix as (
    select cf.id, cf.character_id, cf.pv_current, public.form_pv_max(cf.id) as pv_max
    from public.character_forms cf
    join public.characters c on c.id = cf.character_id
    where c.status = 'active' and cf.setup_complete
  ), changed as (
    update public.character_forms cf
    set pv_current = fix.pv_max
    from fix
    where cf.id = fix.id and fix.pv_current > fix.pv_max
    returning cf.id, fix.character_id, fix.pv_current as old_pv, fix.pv_max
  ), logged as (
    insert into public.pv_formula_fix_log (form_id, character_id, old_pv_current, new_pv_current, new_pv_max)
    select id, character_id, old_pv, pv_max, pv_max from changed
    returning 1
  )
  select count(*) into n from logged;
  return n;
end $$;
revoke execute on function public.fix_pv_after_formula_change() from public, anon, authenticated;

select public.fix_pv_after_formula_change() as formas_com_pv_ajustado;

-- 5.2 Poderes de Prodígios criados antes desta versão passam a custar 0 PC (recalculado pelo trigger).
update public.powers p set initial_cost = p.initial_cost
from public.characters c
where c.id = p.character_id and c.origin_id = 'prodigio' and (p.initial_cost <> 0 or p.per_turn_cost <> 0);

-- ---------------------------------------------------------------------
-- 6. Permissões
-- ---------------------------------------------------------------------
grant execute on function
  public.compute_power_cost(jsonb, int, text),
  public.use_power(uuid, uuid, uuid, int),
  public.set_character_level(uuid, int)
  to authenticated;


-- =====================================================================
-- >>> 20261025000000_rules_sync_fase4.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10-fase4) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10-fase4",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "pvFormula": "sum_div3",
  "abilities": {
    "base": 2,
    "perEvenLevel": 1,
    "blockLevelUpWhenPending": true,
    "originModes": {
      "muto": "none",
      "elo": "free"
    },
    "pathOverrides": {
      "prodigio:arsenal": {
        "base": 0,
        "perEvenLevel": 1
      },
      "prodigio:engrenagem": {
        "base": 1,
        "perEvenLevel": 1
      }
    }
  },
  "prodigioPowers": {
    "noPcCost": true,
    "noLimits": true,
    "allowNoEffects": true
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "skillDefs": {
    "luta": {
      "kind": "attribute",
      "attribute": "FOR",
      "divisor": 2
    },
    "reflexo": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "conhecimento_belico": {
      "kind": "attribute",
      "attribute": "INT",
      "divisor": 2
    },
    "arma_de_fogo": {
      "kind": "fixed",
      "value": 20
    },
    "pontaria": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "investigacao": {
      "kind": "fixed",
      "value": 20
    },
    "enganacao": {
      "kind": "fixed",
      "value": 15
    },
    "furtividade": {
      "kind": "fixed",
      "value": 20
    },
    "pilotagem": {
      "kind": "fixed",
      "value": 5
    },
    "intuicao": {
      "kind": "fixed",
      "value": 10
    }
  },
  "skillDistribution": {
    "skillsToChoose": 4,
    "totalPoints": 150,
    "maxSkillTotal": 75
  },
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "FOR": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "DEX": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {
        "PER": 4
      },
      "skillBonus": {},
      "maxSkillTotal": 95,
      "skillPointsBonus": 50,
      "pvBonusAtLevel1": 0
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "attributeBonus": {
        "MIT": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "arma_de_fogo": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "furtividade": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 20
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null,
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 2
      },
      "pcDice": null
    }
  },
  "weaponModifiers": {
    "afiada": "laminas",
    "perfurante": "perfurantes_projeteis",
    "serrilhada": "laminas",
    "precisa": "distancia",
    "equilibrada": "corpo_a_corpo",
    "pesada": "pesadas",
    "brutal": "pesadas",
    "concussiva": "contundentes",
    "gancho": "foices_correntes",
    "executora": "corpo_a_corpo",
    "rajada": "arma_de_fogo",
    "automatica": "arma_de_fogo",
    "curto_alcance": "arma_de_fogo",
    "mira_precisao": "arma_de_fogo",
    "recuo_pesado": "arma_de_fogo",
    "dispersao": "arma_de_fogo",
    "penetrante": "arma_de_fogo",
    "confiavel": "arma_de_fogo"
  },
  "techniques": {
    "arte_desarme": {
      "name": "Arte do Desarme",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "arte_contra_ataque": {
      "name": "Arte do Contra-ataque",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "provocacao": {
      "name": "Provocação",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_alvos": {
      "name": "Múltiplos Alvos",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_golpes": {
      "name": "Múltiplos Golpes",
      "usage": {
        "kind": "a_cada_turnos",
        "turns": 2
      },
      "requires": {},
      "special": null
    },
    "adrenalina": {
      "name": "Adrenalina",
      "usage": {
        "kind": "acao",
        "action": "Ação de movimento"
      },
      "requires": {},
      "special": "recarregar_cena"
    },
    "metavisao": {
      "name": "Metavisão",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": "esquiva_rodada"
    },
    "recobrar_se": {
      "name": "Recobrar-se",
      "usage": {
        "kind": "por_sessao",
        "times": 1
      },
      "requires": {},
      "special": "recobrar"
    },
    "passos_leves": {
      "name": "Passos Leves",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "ataque_furtivo": {
      "name": "Ataque Furtivo",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "furtividade_rapida": {
      "name": "Furtividade Rápida",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {
        "attributes": {
          "DEX": 70
        },
        "techniques": [
          "passos_leves"
        ]
      },
      "special": null
    }
  },
  "maxWeaponModifiers": 2,
  "powers": {
    "damageSingle": [
      3,
      6,
      9,
      12,
      15
    ],
    "damageArea": [
      6,
      9,
      12,
      15,
      18
    ],
    "areaSizes": {
      "pequena": 0,
      "media": 3,
      "grande": 6,
      "enorme": 9
    },
    "extraDieCost": 3,
    "heal": [
      3,
      6,
      9,
      12,
      15
    ],
    "healArea": {
      "alvo": 0,
      "pequena": 6,
      "media": 9,
      "grande": 12,
      "enorme": 15
    },
    "healContinuous": [
      2,
      3,
      4,
      5,
      6
    ],
    "shield": [
      3,
      6,
      9,
      12,
      15
    ],
    "shieldDuration": {
      "1t": 0,
      "2t": 2,
      "3t": 4,
      "cena": 6
    },
    "conditions": {
      "leve": {
        "initial": 3,
        "perTurn": 1
      },
      "moderada": {
        "initial": 6,
        "perTurn": 2
      },
      "forte": {
        "initial": 9,
        "perTurn": 3
      },
      "severa": {
        "initial": 12,
        "perTurn": 4
      },
      "extrema": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "buffs": {
      "teste_1": {
        "initial": 3,
        "perTurn": 1
      },
      "teste_2": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_1": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_2": {
        "initial": 9,
        "perTurn": 3
      },
      "acao": {
        "initial": 12,
        "perTurn": 4
      },
      "grande": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "levelTable": [
      {
        "level": 1,
        "maxPc": 15,
        "maxExtraDice": 1
      },
      {
        "level": 2,
        "maxPc": 18,
        "maxExtraDice": 1
      },
      {
        "level": 4,
        "maxPc": 24,
        "maxExtraDice": 2
      },
      {
        "level": 6,
        "maxPc": 30,
        "maxExtraDice": 3
      },
      {
        "level": 8,
        "maxPc": 36,
        "maxExtraDice": 4
      },
      {
        "level": 10,
        "maxPc": 42,
        "maxExtraDice": 5
      },
      {
        "level": 15,
        "maxPc": 57,
        "maxExtraDice": 7
      },
      {
        "level": 20,
        "maxPc": 72,
        "maxExtraDice": 10
      }
    ],
    "limitMode": "linear",
    "perTurnCountsTowardLimit": false,
    "amaldicoadoRounding": "ceil",
    "amaldicoadoLimitUsesFullCost": true
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

-- ---------------------------------------------------------------------
-- PV máximo da forma — mesma conta do motor (buildSheet):
-- (FOR + CON) ÷ 3 para baixo + bônus de classe + ganhos de nível ativos + outros bônus.
-- ---------------------------------------------------------------------
create or replace function public.form_pv_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  str int;
  con int;
  base int;
  gains int;
begin
  select cf.id, cf.kind, cf.pv_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into str
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'FOR';
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into con
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'CON';
  str := coalesce(str, 0) + coalesce((cls -> 'attributeBonus' ->> 'FOR')::int, 0);
  con := coalesce(con, 0) + coalesce((cls -> 'attributeBonus' ->> 'CON')::int, 0);
  if cfg ->> 'pvFormula' = 'sum_div3' then
    base := floor((str + con)::numeric / 3)::int;
  else
    base := str + floor(con::numeric / 3)::int;
  end if;
  base := base + coalesce((cls ->> 'pvBonusAtLevel1')::int, 0);
  select coalesce(sum(lp.pv_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, base + gains + f.pv_other_bonus);
end $$;

-- PC máximo da forma — mesma conta do motor: VIG ÷ 3 para baixo + ganhos de nível ativos + outros bônus.
create or replace function public.form_pc_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  vig int;
  gains int;
begin
  select cf.id, cf.kind, cf.pc_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into vig
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'VIG';
  vig := coalesce(vig, 0) + coalesce((cls -> 'attributeBonus' ->> 'VIG')::int, 0);
  select coalesce(sum(lp.pc_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, floor(vig::numeric / 3)::int + gains + f.pc_other_bonus);
end $$;

-- ---------------------------------------------------------------------
-- Vagas de habilidades — mesma conta do motor (abilities.ts).
-- mode: standard | free (Elo) | none (Muto). Executa com as permissões de quem chama.
-- ---------------------------------------------------------------------
create or replace function public.ability_granted(p_origin text, p_path text, p_level int) returns int
language plpgsql immutable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ov jsonb := cfg -> 'pathOverrides' -> (p_origin || ':' || p_path);
begin
  if coalesce(cfg -> 'originModes' ->> p_origin, 'standard') <> 'standard' then
    return 0;
  end if;
  return coalesce((ov ->> 'base')::int, (cfg ->> 'base')::int)
       + coalesce((ov ->> 'perEvenLevel')::int, (cfg ->> 'perEvenLevel')::int) * (greatest(p_level, 1) / 2);
end $$;

create or replace function public.ability_status(p_character uuid) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ch record;
  created int;
begin
  select level, origin_id, origin_path_id into ch from public.characters where id = p_character;
  -- Técnicas oficiais do Arsenal e poderes criados ocupam o mesmo conjunto de vagas (sem consumo duplicado).
  select (select count(*) from public.powers where character_id = p_character)
       + (select count(*) from public.character_techniques where character_id = p_character)
    into created;
  return jsonb_build_object(
    'mode', coalesce(cfg -> 'originModes' ->> ch.origin_id, 'standard'),
    'granted', public.ability_granted(ch.origin_id, ch.origin_path_id, ch.level),
    'created', created,
    'level', ch.level);
end $$;

grant execute on function public.rules_config() to authenticated;
grant execute on function public.form_pv_max(uuid), public.form_pc_max(uuid), public.ability_granted(text, text, int), public.ability_status(uuid) to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;


-- =====================================================================
-- >>> 20261025000100_fase4_campanhas.sql
-- =====================================================================
-- =====================================================================
-- F.R.A.N.C.E — Fase 4: Técnicas do Arsenal, campanhas, Escudo do Mestre
-- (Agentes, Combates, Investigação, Relatórios, Dados, Anotações).
-- INCREMENTAL: só adiciona tabelas/colunas/funções e redefine políticas.
-- Não apaga tabelas nem dados. Depende de 20261025000000_rules_sync_fase4.sql.
-- =====================================================================

-- =====================================================================
-- 1. TÉCNICAS DO ARSENAL
-- =====================================================================
create table if not exists public.character_techniques (
  id uuid primary key default gen_random_uuid(),
  character_id uuid not null references public.characters (id) on delete cascade,
  technique_id text not null,
  learned_level int not null check (learned_level between 1 and 20),
  created_at timestamptz not null default now(),
  unique (character_id, technique_id)
);

-- Contadores de cena / sessão / turno do personagem (limites de uso das técnicas).
create table if not exists public.character_trackers (
  character_id uuid primary key references public.characters (id) on delete cascade,
  scene int not null default 1 check (scene >= 1),
  session int not null default 1 check (session >= 1),
  turn int not null default 1 check (turn >= 1),
  updated_at timestamptz not null default now()
);

create table if not exists public.technique_uses (
  id bigint generated always as identity primary key,
  character_id uuid not null references public.characters (id) on delete cascade,
  technique_id text not null,
  scene int not null,
  session int not null,
  turn int not null,
  request_id uuid unique,
  data jsonb not null default '{}'::jsonb,
  created_by uuid default auth.uid(),
  created_at timestamptz not null default now()
);
create index if not exists technique_uses_char_idx on public.technique_uses (character_id, session, scene);

alter table public.character_techniques enable row level security;
alter table public.character_trackers enable row level security;
alter table public.technique_uses enable row level security;
drop policy if exists techniques_select on public.character_techniques;
create policy techniques_select on public.character_techniques for select to authenticated using (public.can_view_character(character_id));
drop policy if exists trackers_select on public.character_trackers;
create policy trackers_select on public.character_trackers for select to authenticated using (public.can_view_character(character_id));
drop policy if exists tuses_select on public.technique_uses;
create policy tuses_select on public.technique_uses for select to authenticated using (public.can_view_character(character_id));
-- Escrita só pelas funções abaixo (validam requisitos, vagas e limites de uso).

create or replace function public.ensure_tracker(p_character uuid) returns public.character_trackers
language plpgsql security definer set search_path = public as $$
declare
  t public.character_trackers;
begin
  insert into public.character_trackers (character_id) values (p_character) on conflict do nothing;
  select * into t from public.character_trackers where character_id = p_character for update;
  return t;
end $$;
revoke execute on function public.ensure_tracker(uuid) from public, anon, authenticated;

-- Atributo permanente da forma principal (base + outros + bônus de classe; sem temporário).
create or replace function public.permanent_attribute(p_character uuid, p_attr text) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(fa.base_value, 0) + fa.other_bonus
       + coalesce((public.rules_config() -> 'classes' -> c.class_id -> 'attributeBonus' ->> p_attr)::int, 0)
  from public.characters c
  join public.character_forms cf on cf.character_id = c.id and cf.kind = 'base'
  join public.form_attributes fa on fa.form_id = cf.id and fa.attribute = p_attr
  where c.id = p_character;
$$;

create or replace function public.learn_technique(p_character uuid, p_technique text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'techniques' -> p_technique;
  ch public.characters;
  st jsonb;
  a record;
  req text;
  new_id uuid;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  select * into ch from public.characters where id = p_character for update;
  if ch.origin_id is distinct from 'prodigio' or ch.origin_path_id is distinct from 'arsenal' then
    raise exception 'Só o Prodígio do Caminho do Arsenal aprende técnicas da lista.';
  end if;
  if cfg is null then
    raise exception 'Técnica desconhecida.';
  end if;
  if exists (select 1 from public.character_techniques where character_id = p_character and technique_id = p_technique) then
    raise exception 'Técnica já aprendida.';
  end if;
  for a in select key, value from jsonb_each_text(coalesce(cfg -> 'requires' -> 'attributes', '{}'::jsonb)) loop
    if coalesce(public.permanent_attribute(p_character, a.key), 0) < a.value::int then
      raise exception 'Requisito não atendido: % %+.', a.key, a.value;
    end if;
  end loop;
  for req in select jsonb_array_elements_text(coalesce(cfg -> 'requires' -> 'techniques', '[]'::jsonb)) loop
    if not exists (select 1 from public.character_techniques where character_id = p_character and technique_id = req) then
      raise exception 'Requisito não atendido: técnica %.', public.rules_config() -> 'techniques' -> req ->> 'name';
    end if;
  end loop;
  st := public.ability_status(p_character);
  if (st ->> 'created')::int >= (st ->> 'granted')::int then
    raise exception 'Nenhuma técnica disponível neste nível (uma a cada nível par).';
  end if;
  insert into public.character_techniques (character_id, technique_id, learned_level)
  values (p_character, p_technique, ch.level) returning id into new_id;
  return new_id;
end $$;

create or replace function public.forget_technique(p_character uuid, p_technique text) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  if exists (
    select 1 from public.character_techniques ct
    where ct.character_id = p_character and ct.technique_id <> p_technique
      and (public.rules_config() -> 'techniques' -> ct.technique_id -> 'requires' -> 'techniques') ? p_technique
  ) then
    raise exception 'Outra técnica aprendida depende desta.';
  end if;
  delete from public.character_techniques where character_id = p_character and technique_id = p_technique;
end $$;

-- Avança o contador (turno / cena / sessão). Nova sessão também começa uma cena nova.
create or replace function public.advance_tracker(p_character uuid, p_kind text) returns public.character_trackers
language plpgsql security definer set search_path = public as $$
declare
  t public.character_trackers;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  t := public.ensure_tracker(p_character);
  if p_kind = 'turn' then
    update public.character_trackers set turn = turn + 1, updated_at = now() where character_id = p_character returning * into t;
  elsif p_kind = 'scene' then
    update public.character_trackers set scene = scene + 1, turn = 1, updated_at = now() where character_id = p_character returning * into t;
  elsif p_kind = 'session' then
    update public.character_trackers set session = session + 1, scene = scene + 1, turn = 1, updated_at = now() where character_id = p_character returning * into t;
  else
    raise exception 'Contador inválido.';
  end if;
  return t;
end $$;

-- Usa uma técnica: confere aprendizado, suspensão por nível e limite de uso; aplica efeitos especiais.
create or replace function public.use_technique(p_character uuid, p_technique text, p_request uuid, p_data jsonb default '{}'::jsonb)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'techniques' -> p_technique;
  usage jsonb := cfg -> 'usage';
  ch public.characters;
  ct public.character_techniques;
  t public.character_trackers;
  n int;
  last_turn int;
  last_adr bigint;
  fm public.character_forms;
  heal int;
  result jsonb := '{}'::jsonb;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  if exists (select 1 from public.technique_uses where request_id = p_request) then
    return jsonb_build_object('duplicate', true);
  end if;
  select * into ch from public.characters where id = p_character;
  select * into ct from public.character_techniques where character_id = p_character and technique_id = p_technique;
  if ct.id is null or cfg is null then
    raise exception 'Técnica não aprendida.';
  end if;
  if ct.learned_level > ch.level then
    raise exception 'Técnica suspensa: foi aprendida no nível %, acima do nível atual.', ct.learned_level;
  end if;
  t := public.ensure_tracker(p_character);
  if usage ->> 'kind' = 'passiva' then
    raise exception 'Técnica passiva: sempre ativa, não precisa ser usada.';
  elsif usage ->> 'kind' = 'por_cena' then
    select coalesce(max(u.id), 0) into last_adr from public.technique_uses u
    where u.character_id = p_character and u.scene = t.scene and u.session = t.session
      and public.rules_config() -> 'techniques' -> u.technique_id ->> 'special' = 'recarregar_cena';
    select count(*) into n from public.technique_uses
    where character_id = p_character and technique_id = p_technique and scene = t.scene and session = t.session and id > last_adr;
    if n >= (usage ->> 'times')::int then
      raise exception 'Já usada nesta cena.';
    end if;
  elsif usage ->> 'kind' = 'por_sessao' then
    select count(*) into n from public.technique_uses where character_id = p_character and technique_id = p_technique and session = t.session;
    if n >= (usage ->> 'times')::int then
      raise exception 'Já usada nesta sessão.';
    end if;
  elsif usage ->> 'kind' = 'a_cada_turnos' then
    select max(turn) into last_turn from public.technique_uses
    where character_id = p_character and technique_id = p_technique and scene = t.scene and session = t.session;
    if last_turn is not null and t.turn - last_turn < (usage ->> 'turns')::int then
      raise exception 'Disponível de novo no turno %.', last_turn + (usage ->> 'turns')::int;
    end if;
  end if;

  -- Recobrar-se: cura metade do dano do ataque, ou volta com 1 PV (na forma ativa).
  if cfg ->> 'special' = 'recobrar' then
    select * into fm from public.character_forms
    where character_id = p_character and kind = case when ch.active_form = 'lenda' then 'lenda' else 'base' end and setup_complete
    for update;
    if fm.id is null then
      select * into fm from public.character_forms where character_id = p_character and kind = 'base' for update;
    end if;
    if p_data ->> 'mode' = 'revive' then
      update public.character_forms set pv_current = greatest(pv_current, 1) where id = fm.id returning * into fm;
      result := jsonb_build_object('pv_current', fm.pv_current, 'healed', 0, 'form_id', fm.id);
    else
      heal := greatest(0, floor(coalesce((p_data ->> 'damage')::numeric, 0) / 2)::int);
      if heal > 10000 then raise exception 'Valor inválido.'; end if;
      update public.character_forms set pv_current = least(pv_current + heal, public.form_pv_max(fm.id)) where id = fm.id returning * into fm;
      result := jsonb_build_object('pv_current', fm.pv_current, 'healed', heal, 'form_id', fm.id);
    end if;
  end if;

  insert into public.technique_uses (character_id, technique_id, scene, session, turn, request_id, data)
  values (p_character, p_technique, t.scene, t.session, t.turn, p_request, coalesce(p_data, '{}'::jsonb));
  return result || jsonb_build_object('duplicate', false, 'scene', t.scene, 'session', t.session, 'turn', t.turn);
end $$;

-- Evolução: técnicas oficiais e poderes ocupam as mesmas vagas (ability_status conta os dois).
create or replace function public.set_character_level(p_character uuid, p_level int) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  ch public.characters;
  dice jsonb;
  f record;
  l int;
  pv jsonb;
  pc jsonb;
  created jsonb := '[]'::jsonb;
  n_created int;
  needed int;
begin
  if not public.can_edit_character(p_character) then
    raise exception 'Sem permissão para alterar o nível.';
  end if;
  if p_level < (cfg -> 'levels' ->> 'min')::int or p_level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  select * into ch from public.characters where id = p_character for update;
  if ch.status <> 'active' then
    raise exception 'Finalize o personagem antes de mudar o nível.';
  end if;

  if p_level > ch.level and coalesce((cfg -> 'abilities' ->> 'blockLevelUpWhenPending')::boolean, false)
     and coalesce(cfg -> 'abilities' -> 'originModes' ->> ch.origin_id, 'standard') = 'standard' then
    n_created := (select count(*) from public.powers where character_id = p_character)
               + (select count(*) from public.character_techniques where character_id = p_character);
    for l in ch.level..(p_level - 1) loop
      needed := public.ability_granted(ch.origin_id, ch.origin_path_id, l);
      if n_created < needed then
        raise exception 'EVOLUÇÃO BLOQUEADA: você ainda possui habilidades disponíveis para criar (nível %: % de %). Finalize suas habilidades antes de avançar para o próximo nível.', l, n_created, needed;
      end if;
    end loop;
  end if;

  if ch.origin_id is not null and cfg -> 'progressionOverrides' ? ch.origin_id then
    dice := cfg -> 'progressionOverrides' -> ch.origin_id;
  elsif ch.class_id is not null then
    dice := cfg -> 'classes' -> ch.class_id;
  else
    raise exception 'Personagem sem classe.';
  end if;

  for f in select id from public.character_forms where character_id = p_character and setup_complete loop
    for l in 2..p_level loop
      if not exists (select 1 from public.level_progressions where form_id = f.id and level = l) then
        pv := public.roll_simple_dice(dice -> 'pvDice');
        pc := public.roll_simple_dice(dice -> 'pcDice');
        insert into public.level_progressions (form_id, level, pv_dice, pc_dice, pv_roll, pc_roll, pv_gain, pc_gain)
        values (f.id, l, dice ->> 'pv', dice ->> 'pc', pv, pc, (pv ->> 'total')::int, coalesce((pc ->> 'total')::int, 0))
        on conflict (form_id, level) do nothing;
        if found then
          created := created || jsonb_build_array(jsonb_build_object('form_id', f.id, 'level', l));
        end if;
      end if;
    end loop;
  end loop;

  update public.characters set level = p_level where id = p_character;
  update public.character_forms cf
  set pv_current = least(cf.pv_current, public.form_pv_max(cf.id))
  where cf.character_id = p_character and cf.setup_complete and cf.pv_current > public.form_pv_max(cf.id);

  return jsonb_build_object(
    'level', p_level,
    'created', created,
    'rows', coalesce((
      select jsonb_agg(jsonb_build_object('form_id', lp.form_id, 'kind', cf.kind, 'level', lp.level, 'pv_gain', lp.pv_gain, 'pc_gain', lp.pc_gain,
                                          'pv_roll', lp.pv_roll, 'pc_roll', lp.pc_roll, 'pv_dice', lp.pv_dice, 'pc_dice', lp.pc_dice) order by cf.kind, lp.level)
      from public.level_progressions lp join public.character_forms cf on cf.id = lp.form_id
      where cf.character_id = p_character and lp.level <= p_level), '[]'::jsonb)
  );
end $$;

-- =====================================================================
-- 2. CAMPANHAS: configurações, convites, vínculo de personagens
-- =====================================================================
alter table public.campaigns add column if not exists settings jsonb not null default '{"players_see_party": true}'::jsonb;
alter table public.campaigns drop constraint if exists campaigns_settings_object;
alter table public.campaigns add constraint campaigns_settings_object check (jsonb_typeof(settings) = 'object');

alter table public.campaign_invites add column if not exists active boolean not null default true;

-- Entrar pelo convite: só convites ativos; nunca duplica; convite não dá permissão de Mestre.
create or replace function public.join_campaign(p_code text) returns uuid
language plpgsql security definer set search_path = public as $$
declare
  cid uuid;
begin
  if auth.uid() is null then
    raise exception 'É preciso estar autenticado.';
  end if;
  select campaign_id into cid from public.campaign_invites where code = p_code and active;
  if cid is null then
    raise exception 'Convite inválido ou desativado.';
  end if;
  insert into public.campaign_members (campaign_id, user_id, role)
  values (cid, auth.uid(), 'player')
  on conflict (campaign_id, user_id) do nothing;
  return cid;
end $$;

create or replace function public.campaign_invite_preview(p_code text)
returns table (id uuid, name text, description text, master_username text, already_member boolean)
language sql stable security definer set search_path = public as $$
  select c.id, c.name, c.description, p.username::text,
         exists (select 1 from public.campaign_members m where m.campaign_id = c.id and m.user_id = auth.uid())
  from public.campaign_invites i
  join public.campaigns c on c.id = i.campaign_id
  join public.profiles p on p.id = c.owner_id
  where i.code = p_code and i.active and auth.uid() is not null;
$$;

create or replace function public.regenerate_invite(p_campaign uuid) returns text
language plpgsql security definer set search_path = public, extensions as $$
declare
  code_new text := encode(extensions.gen_random_bytes(9), 'hex');
begin
  if not public.is_campaign_master(p_campaign) then
    raise exception 'Apenas o Mestre pode gerar convites.';
  end if;
  update public.campaign_invites set code = code_new, active = true, created_at = now() where campaign_id = p_campaign;
  return code_new;
end $$;

create or replace function public.set_invite_active(p_campaign uuid, p_active boolean) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_campaign_master(p_campaign) then
    raise exception 'Apenas o Mestre pode alterar o convite.';
  end if;
  update public.campaign_invites set active = p_active where campaign_id = p_campaign;
end $$;

-- Personagens: o jogador vincula (pendente) e o Mestre aceita. Vínculos antigos continuam aceitos.
alter table public.campaign_characters add column if not exists status text not null default 'accepted';
alter table public.campaign_characters drop constraint if exists campaign_characters_status_check;
alter table public.campaign_characters add constraint campaign_characters_status_check check (status in ('pending', 'accepted'));

create or replace function public.character_is_active(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (select 1 from public.characters where id = p_character and status = 'active');
$$;
revoke execute on function public.character_is_active(uuid) from public, anon;
grant execute on function public.character_is_active(uuid) to authenticated;

create or replace function public.guard_campaign_character() returns trigger
language plpgsql as $$
begin
  if tg_op = 'INSERT' then
    if public.owns_character(new.character_id) and not public.character_is_active(new.character_id) then
      raise exception 'Finalize o personagem antes de vinculá-lo a uma campanha.';
    end if;
    new.status := case when public.is_campaign_master(new.campaign_id) then 'accepted' else 'pending' end;
  elsif new.status is distinct from old.status and not public.is_campaign_master(new.campaign_id)
        and current_user in ('authenticated', 'anon') then
    raise exception 'Só o Mestre aceita personagens na campanha.';
  end if;
  return new;
end $$;
drop trigger if exists campaign_characters_guard on public.campaign_characters;
create trigger campaign_characters_guard before insert or update on public.campaign_characters
  for each row execute function public.guard_campaign_character();

create or replace function public.review_campaign_character(p_campaign uuid, p_character uuid, p_accept boolean) returns void
language plpgsql security definer set search_path = public as $$
begin
  if not public.is_campaign_master(p_campaign) then
    raise exception 'Apenas o Mestre pode aceitar ou remover personagens.';
  end if;
  if p_accept then
    update public.campaign_characters set status = 'accepted' where campaign_id = p_campaign and character_id = p_character;
  else
    delete from public.campaign_characters where campaign_id = p_campaign and character_id = p_character;
  end if;
end $$;

-- O Mestre só vê/edita fichas ACEITAS na campanha (e, para editar, com a autorização do jogador).
create or replace function public.can_view_character(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.owns_character(p_character)
      or exists (
        select 1 from public.campaign_characters cc
        join public.campaign_members m on m.campaign_id = cc.campaign_id
        where cc.character_id = p_character and cc.status = 'accepted' and m.user_id = auth.uid() and m.role = 'master');
$$;

create or replace function public.can_edit_character(p_character uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select public.owns_character(p_character)
      or exists (
        select 1 from public.campaign_characters cc
        join public.campaign_members m on m.campaign_id = cc.campaign_id
        where cc.character_id = p_character and cc.status = 'accepted' and cc.master_can_edit
          and m.user_id = auth.uid() and m.role = 'master');
$$;

-- Grupo da campanha (informação pública para membros; sem atributos nem recursos).
create or replace function public.campaign_party(p_campaign uuid)
returns table (character_id uuid, name text, class_id text, origin_id text, origin_path_id text, level int,
               owner_id uuid, owner_username text, status text, is_mine boolean, active_form text)
language sql stable security definer set search_path = public as $$
  select c.id, c.name, c.class_id, c.origin_id, c.origin_path_id, c.level, c.owner_id, p.username::text, cc.status,
         c.owner_id = auth.uid(), c.active_form
  from public.campaign_characters cc
  join public.characters c on c.id = cc.character_id
  left join public.profiles p on p.id = c.owner_id
  where cc.campaign_id = p_campaign
    and public.is_campaign_member(p_campaign)
    and (
      public.is_campaign_master(p_campaign)
      or c.owner_id = auth.uid()
      or (cc.status = 'accepted' and coalesce((select (settings ->> 'players_see_party')::boolean from public.campaigns where id = p_campaign), true))
    )
  order by cc.linked_at;
$$;

-- =====================================================================
-- 3. CONDIÇÕES (fichas, NPCs e combatentes)
-- Formato: [{"id": "...", "name": "Atordoado", "turns": 2 | null, "note": ""}]
-- =====================================================================
alter table public.character_forms add column if not exists conditions jsonb not null default '[]'::jsonb;
alter table public.character_forms drop constraint if exists character_forms_conditions_array;
alter table public.character_forms add constraint character_forms_conditions_array check (jsonb_typeof(conditions) = 'array');

create or replace function public.condition_add(p_list jsonb, p_name text, p_turns int, p_note text) returns jsonb
language plpgsql volatile as $$
begin
  if p_name is null or char_length(trim(p_name)) = 0 or char_length(p_name) > 80 then
    raise exception 'Nome da condição inválido.';
  end if;
  if p_turns is not null and (p_turns < 1 or p_turns > 100) then
    raise exception 'Duração inválida (1–100 turnos).';
  end if;
  if jsonb_array_length(coalesce(p_list, '[]'::jsonb)) >= 30 then
    raise exception 'Condições demais.';
  end if;
  return coalesce(p_list, '[]'::jsonb) || jsonb_build_array(jsonb_build_object(
    'id', md5(random()::text || clock_timestamp()::text), 'name', trim(p_name), 'turns', p_turns, 'note', left(coalesce(p_note, ''), 200)));
end $$;

create or replace function public.condition_remove(p_list jsonb, p_id text) returns jsonb
language sql immutable as $$
  select coalesce(jsonb_agg(c), '[]'::jsonb) from jsonb_array_elements(coalesce(p_list, '[]'::jsonb)) c where c ->> 'id' <> p_id;
$$;

-- Diminui as durações; devolve a lista nova e os nomes que expiraram.
create or replace function public.condition_tick(p_list jsonb, out list jsonb, out expired text[])
language plpgsql immutable as $$
declare
  c jsonb;
begin
  list := '[]'::jsonb;
  expired := '{}';
  for c in select * from jsonb_array_elements(coalesce(p_list, '[]'::jsonb)) loop
    if c ->> 'turns' is null then
      list := list || jsonb_build_array(c);
    elsif (c ->> 'turns')::int <= 1 then
      expired := array_append(expired, c ->> 'name');
    else
      list := list || jsonb_build_array(jsonb_set(c, '{turns}', to_jsonb((c ->> 'turns')::int - 1)));
    end if;
  end loop;
end $$;

create or replace function public.form_condition(p_form uuid, p_action text, p_name text default null, p_turns int default null, p_id text default null, p_note text default null)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  f public.character_forms;
begin
  select * into f from public.character_forms where id = p_form for update;
  if f.id is null or not public.can_edit_character(f.character_id) then
    raise exception 'Sem permissão para alterar esta ficha.';
  end if;
  if p_action = 'add' then
    update public.character_forms set conditions = public.condition_add(conditions, p_name, p_turns, p_note) where id = p_form returning * into f;
  elsif p_action = 'remove' then
    update public.character_forms set conditions = public.condition_remove(conditions, p_id) where id = p_form returning * into f;
  else
    raise exception 'Ação inválida.';
  end if;
  return f.conditions;
end $$;

-- =====================================================================
-- 4. NPCs e monstros (instâncias da campanha; modelos do Homebrew preservados)
-- =====================================================================
alter table public.npcs drop constraint if exists npcs_conditions_array;
alter table public.npcs add constraint npcs_conditions_array check (jsonb_typeof(conditions) = 'array');
alter table public.npcs drop constraint if exists npcs_name_len;
alter table public.npcs add constraint npcs_name_len check (char_length(name) between 1 and 120);

-- =====================================================================
-- 5. COMBATES
-- =====================================================================
alter table public.combats add column if not exists version int not null default 0;
alter table public.combats add column if not exists started_at timestamptz;
alter table public.combats add column if not exists ended_at timestamptz;
alter table public.combats add column if not exists initiative_mode text not null default 'manual';
alter table public.combats drop constraint if exists combats_initiative_mode_check;
alter table public.combats add constraint combats_initiative_mode_check check (initiative_mode in ('manual', 'reflexo', 'd20'));

alter table public.combatants add column if not exists form_id uuid references public.character_forms (id) on delete set null;
alter table public.combatants add column if not exists kind text not null default 'other';
alter table public.combatants drop constraint if exists combatants_kind_check;
alter table public.combatants add constraint combatants_kind_check check (kind in ('character', 'npc', 'monstro', 'other'));
alter table public.combatants add column if not exists notes text not null default '';
alter table public.combatants drop constraint if exists combatants_conditions_array;
alter table public.combatants add constraint combatants_conditions_array check (jsonb_typeof(conditions) = 'array');

create table if not exists public.combat_log (
  id bigint generated always as identity primary key,
  combat_id uuid not null references public.combats (id) on delete cascade,
  round int not null,
  turn_index int not null,
  kind text not null,
  message text not null,
  data jsonb not null default '{}'::jsonb,
  public boolean not null default true,
  request_id uuid unique,
  actor uuid default auth.uid(),
  created_at timestamptz not null default now()
);
create index if not exists combat_log_combat_idx on public.combat_log (combat_id, id desc);
alter table public.combat_log enable row level security;
drop policy if exists combat_log_master on public.combat_log;
create policy combat_log_master on public.combat_log for select to authenticated
  using (exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_master(c.campaign_id)));
drop policy if exists combat_log_players on public.combat_log;
create policy combat_log_players on public.combat_log for select to authenticated
  using (public and exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_member(c.campaign_id)));

-- Combatente-personagem precisa estar ACEITO na campanha; a forma usada é a ativa (se não informada).
create or replace function public.guard_combatant() returns trigger
language plpgsql as $$
declare
  camp uuid;
begin
  select campaign_id into camp from public.combats where id = new.combat_id;
  if new.character_id is not null then
    if not exists (select 1 from public.campaign_characters where campaign_id = camp and character_id = new.character_id and status = 'accepted') then
      raise exception 'Personagem não está aceito nesta campanha.';
    end if;
    new.kind := 'character';
    if new.form_id is null or not exists (select 1 from public.character_forms where id = new.form_id and character_id = new.character_id) then
      select cf.id into new.form_id from public.characters c
      join public.character_forms cf on cf.character_id = c.id
        and cf.kind = case when c.active_form = 'lenda' then 'lenda' else 'base' end and cf.setup_complete
      where c.id = new.character_id;
      if new.form_id is null then
        select id into new.form_id from public.character_forms where character_id = new.character_id and kind = 'base';
      end if;
    end if;
    new.pv_current := null; new.pv_max := null; new.pc_current := null; new.pc_max := null; -- valores vivos vêm da ficha
  elsif new.npc_id is not null then
    if not exists (select 1 from public.npcs where id = new.npc_id and campaign_id = camp) then
      raise exception 'NPC de outra campanha.';
    end if;
    if new.kind not in ('npc', 'monstro') then
      select kind into new.kind from public.npcs where id = new.npc_id;
    end if;
  end if;
  if new.pv_max is not null and new.pv_current is not null then
    new.pv_current := least(greatest(new.pv_current, 0), new.pv_max);
  end if;
  if new.pc_max is not null and new.pc_current is not null then
    new.pc_current := least(greatest(new.pc_current, 0), new.pc_max);
  end if;
  return new;
end $$;
drop trigger if exists combatants_guard on public.combatants;
create trigger combatants_guard before insert or update on public.combatants
  for each row execute function public.guard_combatant();

-- Toda mudança em combatentes avança a versão do combate (jogadores recebem pelo Realtime e recarregam).
create or replace function public.bump_combat_version() returns trigger
language plpgsql security definer set search_path = public as $$
begin
  update public.combats set version = version + 1, updated_at = now() where id = coalesce(new.combat_id, old.combat_id);
  return coalesce(new, old);
end $$;
drop trigger if exists combatants_bump on public.combatants;
create trigger combatants_bump after insert or update or delete on public.combatants
  for each row execute function public.bump_combat_version();

create or replace function public.combat_log_add(p_combat uuid, p_kind text, p_message text, p_data jsonb default '{}'::jsonb,
                                                 p_public boolean default true, p_request uuid default null)
returns void
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
begin
  select * into cb from public.combats where id = p_combat;
  insert into public.combat_log (combat_id, round, turn_index, kind, message, data, public, request_id)
  values (p_combat, cb.round, cb.turn_index, p_kind, left(p_message, 500), coalesce(p_data, '{}'::jsonb), p_public, p_request);
end $$;
revoke execute on function public.combat_log_add(uuid, text, text, jsonb, boolean, uuid) from public, anon, authenticated;

-- Ordem dos turnos: sort_order (o Mestre define; a iniciativa só sugere).
create or replace function public.combat_order(p_combat uuid) returns uuid[]
language sql stable security definer set search_path = public as $$
  select coalesce(array_agg(id order by sort_order, initiative desc nulls last, name), '{}') from public.combatants where combat_id = p_combat;
$$;

-- Cobra a manutenção dos efeitos contínuos do personagem no início do turno dele (uma vez por turno/rodada).
create or replace function public.combat_charge_effects(p_combat uuid, p_combatant public.combatants) returns void
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
  ef public.active_effects;
  fm public.character_forms;
  req uuid;
begin
  if p_combatant.character_id is null then
    return;
  end if;
  select * into cb from public.combats where id = p_combat;
  for ef in select * from public.active_effects where character_id = p_combatant.character_id and active
            and (form_id is null or form_id = p_combatant.form_id) for update loop
    req := md5(p_combat::text || ':' || cb.round || ':' || cb.turn_index || ':' || ef.id::text)::uuid;
    continue when exists (select 1 from public.pc_transactions where request_id = req);
    select * into fm from public.character_forms where id = coalesce(ef.form_id, p_combatant.form_id) for update;
    if fm.pc_current < ef.per_turn_cost then
      update public.active_effects set active = false, ended_at = now() where id = ef.id;
      perform public.combat_log_add(p_combat, 'efeito', format('%s: %s encerrado (PC insuficiente para manter).', p_combatant.name, ef.label));
      continue;
    end if;
    if ef.per_turn_cost > 0 then
      update public.character_forms set pc_current = pc_current - ef.per_turn_cost where id = fm.id;
    end if;
    insert into public.pc_transactions (request_id, form_id, amount, reason, created_by)
    values (req, fm.id, -ef.per_turn_cost, 'Manutenção (combate): ' || ef.label, auth.uid());
    update public.active_effects
    set turns_paid = turns_paid + 1,
        active = (turns_total = 0 or turns_paid + 1 < turns_total),
        ended_at = case when turns_total > 0 and turns_paid + 1 >= turns_total then now() end
    where id = ef.id;
    perform public.combat_log_add(p_combat, 'efeito',
      format('%s mantém %s (−%s PC).', p_combatant.name, ef.label, ef.per_turn_cost));
  end loop;
end $$;
revoke execute on function public.combat_charge_effects(uuid, public.combatants) from public, anon, authenticated;

-- Fim do turno de um combatente: condições com duração diminuem; as que acabam saem (com registro).
create or replace function public.combat_tick_conditions(p_combat uuid, p_combatant public.combatants) returns void
language plpgsql security definer set search_path = public as $$
declare
  r record;
  hidden boolean := p_combatant.hidden;
begin
  if p_combatant.character_id is not null and p_combatant.form_id is not null then
    select * into r from public.condition_tick((select conditions from public.character_forms where id = p_combatant.form_id));
    update public.character_forms set conditions = r.list where id = p_combatant.form_id;
  else
    select * into r from public.condition_tick(p_combatant.conditions);
    update public.combatants set conditions = r.list where id = p_combatant.id;
  end if;
  if cardinality(r.expired) > 0 then
    perform public.combat_log_add(p_combat, 'condicao', format('%s: terminou %s.', p_combatant.name, array_to_string(r.expired, ', ')), '{}'::jsonb, not hidden);
  end if;
end $$;
revoke execute on function public.combat_tick_conditions(uuid, public.combatants) from public, anon, authenticated;

-- Iniciar / turnos / rodadas / encerrar. p_version evita que dois cliques (ou dois aparelhos) avancem duas vezes.
create or replace function public.combat_control(p_combat uuid, p_action text, p_version int) returns public.combats
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
  ids uuid[];
  n int;
  cur public.combatants;
  nxt public.combatants;
  c record;
begin
  select * into cb from public.combats where id = p_combat for update;
  if cb.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre controla o combate.';
  end if;
  if p_version is distinct from cb.version then
    raise exception 'O combate foi alterado por outra ação. Os dados foram recarregados — confira e tente de novo.';
  end if;
  if cb.status = 'ended' and p_action <> 'reopen' then
    raise exception 'Combate encerrado.';
  end if;
  ids := public.combat_order(p_combat);
  n := coalesce(array_length(ids, 1), 0);

  if p_action = 'start' then
    if n = 0 then raise exception 'Adicione participantes antes de iniciar.'; end if;
    update public.combats set status = 'active', round = 1, turn_index = 0, started_at = coalesce(started_at, now()) where id = p_combat;
    -- Combate começa uma cena nova para cada personagem (limites de técnicas "por cena").
    for c in select distinct character_id from public.combatants where combat_id = p_combat and character_id is not null loop
      perform public.ensure_tracker(c.character_id);
      update public.character_trackers set scene = scene + 1, turn = 1, updated_at = now() where character_id = c.character_id;
    end loop;
    perform public.combat_log_add(p_combat, 'inicio', format('Combate iniciado com %s participante(s).', n));
    select * into nxt from public.combatants where id = ids[1];
    perform public.combat_charge_effects(p_combat, nxt);
  elsif p_action = 'next' then
    if n = 0 then raise exception 'Sem participantes.'; end if;
    select * into cur from public.combatants where id = ids[least(cb.turn_index, n - 1) + 1];
    if cur.id is not null then
      perform public.combat_tick_conditions(p_combat, cur);
    end if;
    if cb.turn_index + 1 >= n then
      update public.combats set round = round + 1, turn_index = 0 where id = p_combat returning * into cb;
      perform public.combat_log_add(p_combat, 'rodada', format('Rodada %s.', cb.round));
    else
      update public.combats set turn_index = turn_index + 1 where id = p_combat returning * into cb;
    end if;
    select * into nxt from public.combatants where id = ids[cb.turn_index + 1];
    if nxt.character_id is not null then
      perform public.ensure_tracker(nxt.character_id);
      update public.character_trackers set turn = turn + 1, updated_at = now() where character_id = nxt.character_id;
    end if;
    perform public.combat_charge_effects(p_combat, nxt);
    perform public.combat_log_add(p_combat, 'turno', format('Turno de %s.', nxt.name), '{}'::jsonb, not nxt.hidden);
  elsif p_action = 'prev' then
    if cb.turn_index > 0 then
      update public.combats set turn_index = turn_index - 1 where id = p_combat;
    elsif cb.round > 1 then
      update public.combats set round = round - 1, turn_index = greatest(n - 1, 0) where id = p_combat;
    else
      raise exception 'Já está no primeiro turno.';
    end if;
    perform public.combat_log_add(p_combat, 'turno', 'Turno voltou (sem desfazer efeitos já aplicados).');
  elsif p_action = 'new_round' then
    update public.combats set round = round + 1, turn_index = 0 where id = p_combat returning * into cb;
    perform public.combat_log_add(p_combat, 'rodada', format('Rodada %s (nova rodada).', cb.round));
  elsif p_action = 'pause' then
    update public.combats set status = 'paused' where id = p_combat;
  elsif p_action = 'end' then
    update public.combats set status = 'ended', ended_at = now() where id = p_combat;
    perform public.combat_log_add(p_combat, 'fim', 'Combate encerrado.');
  elsif p_action = 'reopen' then
    update public.combats set status = 'active', ended_at = null where id = p_combat;
  else
    raise exception 'Ação inválida.';
  end if;

  update public.combats set version = version + 1, updated_at = now() where id = p_combat returning * into cb;
  return cb;
end $$;

-- Dano, cura e recursos de um participante. Atômico e idempotente (p_request).
create or replace function public.combat_apply(p_combatant uuid, p_kind text, p_amount int, p_request uuid, p_note text default '')
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
  fm public.character_forms;
  before int;
  after int;
  label text;
  hidden boolean;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica efeitos no combate.';
  end if;
  if exists (select 1 from public.combat_log where request_id = p_request) then
    return jsonb_build_object('duplicate', true);
  end if;
  if p_amount is null or p_amount < 0 or p_amount > 100000 then
    raise exception 'Valor inválido.';
  end if;
  hidden := cbt.hidden or cbt.hide_stats;
  if cbt.character_id is not null then
    if not public.can_edit_character(cbt.character_id) then
      raise exception 'O jogador não autorizou o Mestre a editar esta ficha.';
    end if;
    select * into fm from public.character_forms where id = cbt.form_id for update;
    if p_kind in ('damage', 'heal') then
      before := fm.pv_current;
      after := case when p_kind = 'damage' then greatest(before - p_amount, 0) else least(before + p_amount, public.form_pv_max(fm.id)) end;
      update public.character_forms set pv_current = after where id = fm.id;
    elsif p_kind in ('pc_spend', 'pc_gain') then
      before := fm.pc_current;
      after := case when p_kind = 'pc_spend' then greatest(before - p_amount, 0) else least(before + p_amount, public.form_pc_max(fm.id)) end;
      update public.character_forms set pc_current = after where id = fm.id;
    else
      raise exception 'Ação inválida.';
    end if;
  else
    if p_kind in ('damage', 'heal') then
      before := coalesce(cbt.pv_current, 0);
      after := case when p_kind = 'damage' then greatest(before - p_amount, 0) else least(before + p_amount, coalesce(cbt.pv_max, before + p_amount)) end;
      update public.combatants set pv_current = after where id = cbt.id;
    elsif p_kind in ('pc_spend', 'pc_gain') then
      before := coalesce(cbt.pc_current, 0);
      after := case when p_kind = 'pc_spend' then greatest(before - p_amount, 0) else least(before + p_amount, coalesce(cbt.pc_max, before + p_amount)) end;
      update public.combatants set pc_current = after where id = cbt.id;
    else
      raise exception 'Ação inválida.';
    end if;
  end if;
  label := case p_kind when 'damage' then 'sofreu %s de dano' when 'heal' then 'recuperou %s PV' when 'pc_spend' then 'gastou %s PC' else 'recuperou %s PC' end;
  perform public.combat_log_add(cb.id, p_kind,
    format('%s ' || label || '%s', cbt.name, p_amount, case when coalesce(p_note, '') <> '' then ' — ' || left(p_note, 200) else '' end)
      || case when hidden then '' else format(' (%s → %s).', before, after) end,
    jsonb_build_object('combatant', cbt.id, 'before', before, 'after', after, 'amount', p_amount), not cbt.hidden, p_request);
  update public.combats set version = version + 1, updated_at = now() where id = cb.id;
  return jsonb_build_object('duplicate', false, 'before', before, 'after', after);
end $$;

create or replace function public.combat_condition(p_combatant uuid, p_action text, p_name text default null, p_turns int default null, p_id text default null)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
  list jsonb;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica condições no combate.';
  end if;
  if cbt.character_id is not null then
    list := public.form_condition(cbt.form_id, p_action, p_name, p_turns, p_id);
  else
    if p_action = 'add' then
      update public.combatants set conditions = public.condition_add(conditions, p_name, p_turns, null) where id = cbt.id returning conditions into list;
    elsif p_action = 'remove' then
      update public.combatants set conditions = public.condition_remove(conditions, p_id) where id = cbt.id returning conditions into list;
    else
      raise exception 'Ação inválida.';
    end if;
  end if;
  perform public.combat_log_add(cb.id, 'condicao',
    case when p_action = 'add' then format('%s: %s%s.', cbt.name, p_name, case when p_turns is null then '' else format(' (%s turno(s))', p_turns) end)
         else format('%s: condição removida.', cbt.name) end, '{}'::jsonb, not cbt.hidden);
  update public.combats set version = version + 1, updated_at = now() where id = cb.id;
  return list;
end $$;

-- Registro livre (ataque de NPC, uso de poder, efeito narrativo).
create or replace function public.combat_note(p_combat uuid, p_kind text, p_message text, p_data jsonb default '{}'::jsonb, p_public boolean default true, p_request uuid default null)
returns void
language plpgsql security definer set search_path = public as $$
declare
  cb public.combats;
begin
  select * into cb from public.combats where id = p_combat;
  if cb.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre registra eventos do combate.';
  end if;
  if p_kind not in ('ataque', 'poder', 'efeito', 'nota') then
    raise exception 'Tipo inválido.';
  end if;
  if p_request is not null and exists (select 1 from public.combat_log where request_id = p_request) then
    return;
  end if;
  perform public.combat_log_add(p_combat, p_kind, p_message, p_data, p_public, p_request);
end $$;

-- Visão dos combatentes para jogadores: personagens mostram os PV vivos da ficha; ocultos não aparecem.
drop view if exists public.combatants_public;
create view public.combatants_public with (security_barrier = true) as
select cb.id, cb.combat_id, cb.character_id, cb.npc_id, cb.kind, cb.form_id, cb.name, cb.initiative, cb.sort_order,
  case when cb.hide_stats then null when cb.character_id is not null then cf.pv_current else cb.pv_current end as pv_current,
  case when cb.hide_stats then null when cb.character_id is not null then public.form_pv_max(cf.id) else cb.pv_max end as pv_max,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then cf.pc_current else cb.pc_current end as pc_current,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then public.form_pc_max(cf.id) else cb.pc_max end as pc_max,
  case when cb.character_id is not null then cf.conditions else cb.conditions end as conditions,
  cb.hidden
from public.combatants cb
join public.combats c on c.id = cb.combat_id
left join public.character_forms cf on cf.id = cb.form_id
left join public.characters ch on ch.id = cb.character_id
where public.is_campaign_member(c.campaign_id)
  and (not cb.hidden or public.is_campaign_master(c.campaign_id));
revoke all on public.combatants_public from anon;
grant select on public.combatants_public to authenticated;

-- =====================================================================
-- 6. INVESTIGAÇÃO
-- =====================================================================
alter table public.investigations add column if not exists location text not null default '';
alter table public.investigations add column if not exists status text not null default 'aberta';
alter table public.investigations drop constraint if exists investigations_status_check;
alter table public.investigations add constraint investigations_status_check check (status in ('aberta', 'em_andamento', 'resolvida', 'arquivada'));
alter table public.investigations add column if not exists characters jsonb not null default '[]'::jsonb;

alter table public.clues add column if not exists location text not null default '';
alter table public.clues add column if not exists characters jsonb not null default '[]'::jsonb;
alter table public.clues add column if not exists image_url text;
alter table public.clues drop constraint if exists clues_image_url_https;
alter table public.clues add constraint clues_image_url_https check (image_url is null or image_url ~ '^https://');
alter table public.clues add column if not exists revealed_at timestamptz;
alter table public.clues add column if not exists board_x real;
alter table public.clues add column if not exists board_y real;

create or replace function public.stamp_clue_reveal() returns trigger
language plpgsql as $$
begin
  if new.revealed and (tg_op = 'INSERT' or not old.revealed) then
    new.revealed_at := now();
  elsif not new.revealed then
    new.revealed_at := null;
  end if;
  return new;
end $$;
drop trigger if exists clues_reveal_stamp on public.clues;
create trigger clues_reveal_stamp before insert or update on public.clues
  for each row execute function public.stamp_clue_reveal();

-- Pista revelada é visível aos jogadores mesmo que o caso esteja oculto (a política antiga dependia
-- de o jogador conseguir ler a investigação, o que escondia pistas reveladas de casos sigilosos).
create or replace function public.investigation_campaign(p_investigation uuid) returns uuid
language sql stable security definer set search_path = public as $$
  select campaign_id from public.investigations where id = p_investigation;
$$;
grant execute on function public.investigation_campaign(uuid) to authenticated;
drop policy if exists clues_players on public.clues;
create policy clues_players on public.clues for select to authenticated
  using (revealed and public.is_campaign_member(public.investigation_campaign(investigation_id)));

-- Quadro de investigação (opcional): nós (lugares, personagens, notas) e ligações. Só o Mestre.
create table if not exists public.investigation_nodes (
  id uuid primary key default gen_random_uuid(),
  investigation_id uuid not null references public.investigations (id) on delete cascade,
  kind text not null check (kind in ('place', 'character', 'note')),
  label text not null check (char_length(label) between 1 and 120),
  x real not null default 0,
  y real not null default 0,
  created_at timestamptz not null default now()
);
create table if not exists public.investigation_links (
  id uuid primary key default gen_random_uuid(),
  investigation_id uuid not null references public.investigations (id) on delete cascade,
  from_id uuid not null,
  to_id uuid not null,
  label text not null default '' check (char_length(label) <= 80),
  created_at timestamptz not null default now(),
  unique (investigation_id, from_id, to_id),
  check (from_id <> to_id)
);
alter table public.investigation_nodes enable row level security;
alter table public.investigation_links enable row level security;
drop policy if exists invnodes_master on public.investigation_nodes;
create policy invnodes_master on public.investigation_nodes for all to authenticated
  using (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)))
  with check (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)));
drop policy if exists invlinks_master on public.investigation_links;
create policy invlinks_master on public.investigation_links for all to authenticated
  using (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)))
  with check (exists (select 1 from public.investigations i where i.id = investigation_id and public.is_campaign_master(i.campaign_id)));

-- Pista revelada: jogadores veem o título da investigação mesmo se o caso estiver oculto? Não — só o da pista.
create or replace function public.revealed_clues(p_campaign uuid)
returns table (id uuid, investigation_id uuid, investigation_title text, title text, content text, location text,
               image_url text, attachments jsonb, revealed_at timestamptz)
language sql stable security definer set search_path = public as $$
  select cl.id, cl.investigation_id,
         case when i.visible_to_players or public.is_campaign_master(p_campaign) then i.title else 'Caso sigiloso' end,
         cl.title, cl.content, cl.location, cl.image_url, cl.attachments, cl.revealed_at
  from public.clues cl join public.investigations i on i.id = cl.investigation_id
  where i.campaign_id = p_campaign and cl.revealed and public.is_campaign_member(p_campaign)
  order by cl.revealed_at desc nulls last;
$$;

-- =====================================================================
-- 7. RELATÓRIOS (privados ou visíveis aos jogadores)
-- =====================================================================
alter table public.reports add column if not exists is_private boolean not null default false;
alter table public.reports add column if not exists conclusions text not null default '';
drop policy if exists reports_players on public.reports;
create policy reports_players on public.reports for select to authenticated
  using (not is_private and public.is_campaign_member(campaign_id));

-- =====================================================================
-- 8. ROLAGENS (públicas e privadas) — dados rolados NO BANCO
-- visibility: public (todos da campanha) · master (quem rolou + Mestre) · self (só quem rolou)
-- =====================================================================
drop policy if exists rolls_insert on public.roll_log;
create policy rolls_insert on public.roll_log for insert to authenticated
  with check (
    user_id = auth.uid()
    and (campaign_id is null or public.is_campaign_member(campaign_id))
    and (character_id is null or public.can_edit_character(character_id))
    and (visibility <> 'master' or (campaign_id is not null and public.is_campaign_member(campaign_id)))
  );

create or replace function public.roll_expression(p_expr text) returns jsonb
language plpgsql volatile set search_path = public as $$
declare
  e text := regexp_replace(lower(coalesce(p_expr, '')), '\s', '', 'g');
  m text[];
  terms jsonb := '[]'::jsonb;
  total int := 0;
  sign int;
  cnt int;
  sides int;
  rolls int[];
  i int;
  s int;
  dice_total int := 0;
  n_terms int := 0;
begin
  if e = '' or e !~ '^[+-]?(\d{0,3}d\d{1,4}|\d{1,5})([+-](\d{0,3}d\d{1,4}|\d{1,5}))*$' then
    raise exception 'Expressão de dados inválida (ex.: 2d6+3, 1d100, 2d12+1d6).';
  end if;
  for m in select regexp_matches(e, '([+-]?)(\d{0,3}d\d{1,4}|\d{1,5})', 'g') loop
    n_terms := n_terms + 1;
    if n_terms > 20 then raise exception 'Termos demais.'; end if;
    sign := case when m[1] = '-' then -1 else 1 end;
    if position('d' in m[2]) > 0 then
      cnt := coalesce(nullif(split_part(m[2], 'd', 1), '')::int, 1);
      sides := split_part(m[2], 'd', 2)::int;
      if cnt < 1 or cnt > 100 or sides < 2 or sides > 1000 then raise exception 'Dados fora do limite (até 100 dados de até 1000 lados).'; end if;
      dice_total := dice_total + cnt;
      if dice_total > 100 then raise exception 'Dados demais (máximo 100).'; end if;
      rolls := '{}';
      s := 0;
      for i in 1..cnt loop
        rolls := rolls || public.roll_die(sides);
        s := s + rolls[i];
      end loop;
      total := total + sign * s;
      terms := terms || jsonb_build_array(jsonb_build_object('sign', sign, 'count', cnt, 'sides', sides, 'rolls', to_jsonb(rolls), 'subtotal', sign * s));
    else
      total := total + sign * m[2]::int;
      terms := terms || jsonb_build_array(jsonb_build_object('sign', sign, 'count', 0, 'sides', 0, 'value', m[2]::int, 'subtotal', sign * m[2]::int));
    end if;
  end loop;
  return jsonb_build_object('expression', e, 'terms', terms, 'total', total);
end $$;

-- Rolagem livre da aba Dados. O resultado é gerado aqui (ninguém consegue escolher o número).
create or replace function public.roll_dice(p_campaign uuid, p_expression text, p_visibility text, p_label text default '')
returns public.roll_log
language plpgsql security definer set search_path = public as $$
declare
  r jsonb;
  row public.roll_log;
begin
  if not public.is_campaign_member(p_campaign) then
    raise exception 'Você não participa desta campanha.';
  end if;
  if p_visibility not in ('public', 'master', 'self') then
    raise exception 'Visibilidade inválida.';
  end if;
  r := public.roll_expression(p_expression);
  insert into public.roll_log (user_id, campaign_id, label, expression, result, visibility)
  values (auth.uid(), p_campaign, left(coalesce(nullif(trim(p_label), ''), 'Rolagem'), 120), r ->> 'expression',
          r || jsonb_build_object('kind', 'dice'), p_visibility)
  returning * into row;
  return row;
end $$;

-- Quem rolou (nome) — para o histórico da campanha.
create or replace function public.campaign_member_names(p_campaign uuid)
returns table (user_id uuid, username text, display_name text, role text)
language sql stable security definer set search_path = public as $$
  select m.user_id, p.username::text, p.display_name, m.role
  from public.campaign_members m left join public.profiles p on p.id = m.user_id
  where m.campaign_id = p_campaign and public.is_campaign_member(p_campaign);
$$;

-- =====================================================================
-- 9. REALTIME (Supabase): mudanças relevantes chegam aos navegadores conectados.
-- O Realtime respeita o RLS: cada um só recebe o que pode ler.
-- =====================================================================
do $$
declare
  t text;
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array['character_forms', 'combats', 'clues', 'roll_log', 'campaign_characters', 'npcs',
                             'character_trackers', 'technique_uses', 'campaign_notes', 'reports', 'characters'] loop
      if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
        execute format('alter publication supabase_realtime add table public.%I', t);
      end if;
    end loop;
  end if;
end $$;

-- =====================================================================
-- 10. PERMISSÕES DE EXECUÇÃO
-- =====================================================================
grant execute on function
  public.learn_technique(uuid, text),
  public.forget_technique(uuid, text),
  public.advance_tracker(uuid, text),
  public.use_technique(uuid, text, uuid, jsonb),
  public.set_character_level(uuid, int),
  public.join_campaign(text),
  public.campaign_invite_preview(text),
  public.regenerate_invite(uuid),
  public.set_invite_active(uuid, boolean),
  public.review_campaign_character(uuid, uuid, boolean),
  public.campaign_party(uuid),
  public.form_condition(uuid, text, text, int, text, text),
  public.combat_control(uuid, text, int),
  public.combat_apply(uuid, text, int, uuid, text),
  public.combat_condition(uuid, text, text, int, text),
  public.combat_note(uuid, text, text, jsonb, boolean, uuid),
  public.revealed_clues(uuid),
  public.roll_dice(uuid, text, text, text),
  public.campaign_member_names(uuid)
  to authenticated;
revoke execute on function public.roll_expression(text) from public, anon, authenticated;
revoke execute on function public.permanent_attribute(uuid, text) from public, anon, authenticated;
revoke execute on function public.combat_order(uuid) from public, anon, authenticated;


-- =====================================================================
-- >>> 20261026000100_fase5_homebrew.sql
-- =====================================================================
-- =====================================================================
-- F.R.A.N.C.E — FASE 5: Homebrew completo, monstros em combate, imagens
-- Incremental sobre a Fase 4. Não apaga tabelas nem dados; pode ser reaplicada.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 0. Ajudantes
-- ---------------------------------------------------------------------
create or replace function public.try_uuid(p text) returns uuid
language sql immutable as $$
  select case when p ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' then p::uuid end
$$;

-- Caminho de imagem válido dentro do bucket: <pasta>/<id>/<arquivo>.(webp|png|jpg|jpeg)
create or replace function public.is_media_path(p text, p_folder text, p_owner text) returns boolean
language sql immutable as $$
  select p is null or (
    split_part(p, '/', 1) = p_folder
    and split_part(p, '/', 2) = p_owner
    and split_part(p, '/', 3) ~ '^[A-Za-z0-9_-]{1,80}\.(webp|png|jpg|jpeg)$'
    and split_part(p, '/', 4) = ''
  )
$$;

-- ---------------------------------------------------------------------
-- 1. HOMEBREW: categorias, imagem, tamanho
-- ---------------------------------------------------------------------
alter table public.homebrew drop constraint if exists homebrew_kind_check;
alter table public.homebrew add constraint homebrew_kind_check
  check (kind in ('item', 'arma', 'modificador', 'monstro', 'npc', 'item_especial', 'outro'));
alter table public.homebrew add column if not exists image_path text;
alter table public.homebrew drop constraint if exists homebrew_data_size;
alter table public.homebrew add constraint homebrew_data_size check (pg_column_size(data) <= 262144);
create index if not exists homebrew_owner_updated_idx on public.homebrew (owner_id, updated_at desc);

create or replace function public.guard_homebrew() returns trigger
language plpgsql as $$
begin
  if not public.is_media_path(new.image_path, 'homebrew', new.owner_id::text) then
    raise exception 'Imagem inválida para este conteúdo.';
  end if;
  if tg_op = 'UPDATE' and new.owner_id <> old.owner_id then
    raise exception 'O autor de um conteúdo não muda.';
  end if;
  return new;
end $$;
drop trigger if exists homebrew_guard on public.homebrew;
create trigger homebrew_guard before insert or update on public.homebrew
  for each row execute function public.guard_homebrew();

-- ---------------------------------------------------------------------
-- 2. COMPARTILHAMENTO com campanhas (o modelo continua do autor)
-- ---------------------------------------------------------------------
create table if not exists public.homebrew_shares (
  homebrew_id uuid not null references public.homebrew (id) on delete cascade,
  campaign_id uuid not null references public.campaigns (id) on delete cascade,
  shared_by uuid not null references auth.users (id) on delete cascade,
  created_at timestamptz not null default now(),
  primary key (homebrew_id, campaign_id)
);
create index if not exists homebrew_shares_campaign_idx on public.homebrew_shares (campaign_id);
alter table public.homebrew_shares enable row level security;

-- Só conteúdos de equipamento podem ser compartilhados (fichas de monstros/NPCs têm segredos do Mestre).
create or replace function public.guard_homebrew_share() returns trigger
language plpgsql security definer set search_path = public as $$
declare
  hb public.homebrew;
begin
  select * into hb from public.homebrew where id = new.homebrew_id;
  if hb.id is null or hb.owner_id <> auth.uid() then
    raise exception 'Só o autor compartilha o conteúdo.';
  end if;
  if hb.kind not in ('item', 'arma', 'modificador', 'item_especial', 'outro') then
    raise exception 'Monstros e NPCs não são compartilhados com jogadores (use-os pelo Escudo do Mestre).';
  end if;
  if not public.is_campaign_master(new.campaign_id) then
    raise exception 'Só o Mestre da campanha disponibiliza conteúdos nela.';
  end if;
  new.shared_by := auth.uid();
  return new;
end $$;
drop trigger if exists homebrew_shares_guard on public.homebrew_shares;
create trigger homebrew_shares_guard before insert or update on public.homebrew_shares
  for each row execute function public.guard_homebrew_share();

drop policy if exists hb_shares_owner on public.homebrew_shares;
create policy hb_shares_owner on public.homebrew_shares for all to authenticated
  using (shared_by = auth.uid()) with check (shared_by = auth.uid());
drop policy if exists hb_shares_members on public.homebrew_shares;
create policy hb_shares_members on public.homebrew_shares for select to authenticated
  using (public.is_campaign_member(campaign_id));

-- Leitura (nunca escrita) de conteúdos compartilhados com campanhas de que participo.
create or replace function public.homebrew_shared_with_me(p_homebrew uuid) returns boolean
language sql stable security definer set search_path = public as $$
  select exists (
    select 1 from public.homebrew_shares s
    join public.campaign_members m on m.campaign_id = s.campaign_id and m.user_id = auth.uid()
    where s.homebrew_id = p_homebrew
  )
$$;
grant execute on function public.homebrew_shared_with_me(uuid) to authenticated;
drop policy if exists homebrew_shared_select on public.homebrew;
create policy homebrew_shared_select on public.homebrew for select to authenticated
  using (public.homebrew_shared_with_me(id));

-- ---------------------------------------------------------------------
-- 3. FOTOS DOS PERSONAGENS (uma por forma: humana e Lenda são independentes)
-- ---------------------------------------------------------------------
alter table public.character_forms add column if not exists portrait_path text;

create or replace function public.guard_form_portrait() returns trigger
language plpgsql as $$
begin
  if new.portrait_path is distinct from (case when tg_op = 'UPDATE' then old.portrait_path end) then
    if not public.is_media_path(new.portrait_path, 'characters', new.character_id::text) then
      raise exception 'Foto inválida para este personagem.';
    end if;
    if auth.uid() is not null and not public.owns_character(new.character_id) then
      raise exception 'Só o dono do personagem troca a foto.';
    end if;
  end if;
  return new;
end $$;
drop trigger if exists character_forms_portrait on public.character_forms;
create trigger character_forms_portrait before insert or update on public.character_forms
  for each row execute function public.guard_form_portrait();

-- ---------------------------------------------------------------------
-- 4. INVENTÁRIO: imagem, usos e modificadores personalizados (cópia na arma)
-- ---------------------------------------------------------------------
alter table public.items add column if not exists image_path text;
alter table public.items add column if not exists custom_modifiers jsonb not null default '[]'::jsonb;
alter table public.items add column if not exists uses_max int;
alter table public.items add column if not exists uses_left int;
alter table public.items drop constraint if exists items_uses_check;
alter table public.items add constraint items_uses_check
  check ((uses_max is null and uses_left is null) or (uses_max between 1 and 9999 and uses_left between 0 and uses_max));
alter table public.items drop constraint if exists items_custom_modifiers_array;
alter table public.items add constraint items_custom_modifiers_array check (jsonb_typeof(custom_modifiers) = 'array' and jsonb_array_length(custom_modifiers) <= 6);

create or replace function public.validate_item() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  t text;
  m jsonb;
  req text;
  counted int := 0;
  official int := 0;
begin
  if not public.is_valid_dice(new.effect_dice) then
    raise exception 'Expressão de dados inválida: %', new.effect_dice;
  end if;
  if new.skill_override is not null and not (cfg -> 'skills') ? new.skill_override then
    raise exception 'Perícia inválida para a arma.';
  end if;
  foreach t in array new.tags loop
    if not exists (select 1 from jsonb_each_text(cfg -> 'weaponModifiers') x where x.value = t) then
      raise exception 'Categoria de arma inválida: %', t;
    end if;
  end loop;
  -- Imagem: só a de um modelo do Homebrew que quem grava consegue ler (próprio ou compartilhado com sua campanha).
  -- Sem isso, alguém poderia apontar para a imagem privada de outra pessoa e ganhar acesso a ela.
  if new.image_path is not null and auth.uid() is not null
     and (tg_op = 'INSERT' or new.image_path is distinct from old.image_path)
     and not exists (select 1 from public.homebrew h where h.image_path = new.image_path) then
    raise exception 'Imagem inválida.';
  end if;
  if jsonb_array_length(coalesce(new.custom_modifiers, '[]'::jsonb)) > 0 then
    if new.attack_kind is null then
      raise exception 'Modificadores só podem ser aplicados a armas.';
    end if;
    for m in select * from jsonb_array_elements(new.custom_modifiers) loop
      req := m ->> 'requires';
      if coalesce(m ->> 'name', '') = '' or req is null then
        raise exception 'Modificador personalizado incompleto.';
      end if;
      if req <> 'qualquer' and not (req = any (new.tags)) then
        raise exception 'Modificador "%" incompatível com esta arma.', m ->> 'name';
      end if;
      if not coalesce((m ->> 'ignoreLimit')::boolean, false) then
        counted := counted + 1;
      end if;
    end loop;
    if new.id is not null then
      select count(*) into official from public.item_modifiers where item_id = new.id and not is_temporary;
    end if;
    if official + counted > (cfg ->> 'maxWeaponModifiers')::int then
      raise exception 'Cada arma suporta até % modificações.', cfg ->> 'maxWeaponModifiers';
    end if;
  end if;
  return new;
end $$;

create or replace function public.validate_item_modifier() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
  req text := cfg -> 'weaponModifiers' ->> new.modifier_id;
  it record;
  n int;
  custom int;
begin
  if req is null then
    raise exception 'Modificador desconhecido.';
  end if;
  select i.tags, i.attack_kind, i.custom_modifiers, c.origin_id, c.origin_path_id into it
  from public.items i join public.characters c on c.id = i.character_id where i.id = new.item_id;
  if it.attack_kind is null then
    raise exception 'Modificadores só podem ser aplicados a armas.';
  end if;
  if not (req = any (it.tags)) then
    raise exception 'Modificador incompatível com esta arma.';
  end if;
  if new.is_temporary then
    if not (it.origin_id = 'prodigio' and it.origin_path_id = 'arsenal') then
      raise exception 'Modificadores temporários são exclusivos do Caminho do Arsenal.';
    end if;
    select count(*) into n from public.item_modifiers where item_id = new.item_id and is_temporary and id <> new.id;
    if n >= 1 then
      raise exception 'Apenas um modificador temporário por vez.';
    end if;
  else
    select count(*) into n from public.item_modifiers where item_id = new.item_id and not is_temporary and id <> new.id;
    select count(*) into custom from jsonb_array_elements(coalesce(it.custom_modifiers, '[]'::jsonb)) x
      where not coalesce((x ->> 'ignoreLimit')::boolean, false);
    if n + custom >= (cfg ->> 'maxWeaponModifiers')::int then
      raise exception 'Cada arma suporta até % modificações.', cfg ->> 'maxWeaponModifiers';
    end if;
  end if;
  return new;
end $$;

-- Uso de item (consumível / cura / usos limitados): desconta de forma atômica.
create or replace function public.consume_item(p_item uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  it public.items;
begin
  select * into it from public.items where id = p_item for update;
  if it.id is null or not public.can_edit_character(it.character_id) then
    raise exception 'Sem permissão para usar este item.';
  end if;
  if it.uses_max is not null then
    if it.uses_left <= 0 then
      raise exception 'Este item não tem mais usos.';
    end if;
    update public.items set uses_left = uses_left - 1 where id = it.id returning * into it;
  elsif it.item_type = 'consumivel' then
    if it.quantity <= 0 then
      raise exception 'Quantidade esgotada.';
    end if;
    update public.items set quantity = quantity - 1 where id = it.id returning * into it;
  end if;
  return jsonb_build_object('quantity', it.quantity, 'uses_left', it.uses_left);
end $$;
revoke execute on function public.consume_item(uuid) from public, anon;
grant execute on function public.consume_item(uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 5. NPCs DA CAMPANHA: imagem e informações secretas
-- ---------------------------------------------------------------------
alter table public.npcs add column if not exists image_path text;

create or replace function public.guard_npc_image() returns trigger
language plpgsql as $$
declare
  master uuid;
begin
  select owner_id into master from public.campaigns where id = new.campaign_id;
  if new.image_path is not null and not (
       public.is_media_path(new.image_path, 'npcs', new.campaign_id::text)
       or public.is_media_path(new.image_path, 'homebrew', master::text)) then
    raise exception 'Imagem inválida para o NPC.';
  end if;
  return new;
end $$;
drop trigger if exists npcs_image on public.npcs;
create trigger npcs_image before insert or update on public.npcs
  for each row execute function public.guard_npc_image();

-- Antes os jogadores liam a linha inteira de NPCs visíveis (incluindo notas do Mestre).
-- Agora leem só a visão pública: nome, tipo, imagem, descrição e aparência.
drop policy if exists npcs_players on public.npcs;
drop view if exists public.npcs_public;
create view public.npcs_public with (security_barrier = true) as
select n.id, n.campaign_id, n.kind, n.name, n.image_path,
  coalesce(n.data ->> 'description', '') as description,
  coalesce(n.data ->> 'appearance', '') as appearance,
  n.conditions
from public.npcs n
where n.visible_to_players and public.is_campaign_member(n.campaign_id);
revoke all on public.npcs_public from anon;
grant select on public.npcs_public to authenticated;

-- ---------------------------------------------------------------------
-- 6. COMBATENTES: instâncias independentes de monstros/NPCs
-- ---------------------------------------------------------------------
alter table public.combatants add column if not exists data jsonb not null default '{}'::jsonb;
alter table public.combatants add column if not exists image_path text;
alter table public.combatants add column if not exists homebrew_id uuid references public.homebrew (id) on delete set null;
alter table public.combatants drop constraint if exists combatants_data_size;
alter table public.combatants add constraint combatants_data_size check (pg_column_size(data) <= 131072);

create or replace function public.guard_combatant() returns trigger
language plpgsql as $$
declare
  camp uuid;
  master uuid;
begin
  select c.campaign_id, k.owner_id into camp, master from public.combats c join public.campaigns k on k.id = c.campaign_id where c.id = new.combat_id;
  if new.character_id is not null then
    if not exists (select 1 from public.campaign_characters where campaign_id = camp and character_id = new.character_id and status = 'accepted') then
      raise exception 'Personagem não está aceito nesta campanha.';
    end if;
    new.kind := 'character';
    if new.form_id is null or not exists (select 1 from public.character_forms where id = new.form_id and character_id = new.character_id) then
      select cf.id into new.form_id from public.characters c
      join public.character_forms cf on cf.character_id = c.id
        and cf.kind = case when c.active_form = 'lenda' then 'lenda' else 'base' end and cf.setup_complete
      where c.id = new.character_id;
      if new.form_id is null then
        select id into new.form_id from public.character_forms where character_id = new.character_id and kind = 'base';
      end if;
    end if;
    new.pv_current := null; new.pv_max := null; new.pc_current := null; new.pc_max := null; -- valores vivos vêm da ficha
    new.data := '{}'::jsonb; new.homebrew_id := null; new.image_path := null;
  elsif new.npc_id is not null then
    if not exists (select 1 from public.npcs where id = new.npc_id and campaign_id = camp) then
      raise exception 'NPC de outra campanha.';
    end if;
    if new.kind not in ('npc', 'monstro') then
      select kind into new.kind from public.npcs where id = new.npc_id;
    end if;
  end if;
  -- Modelo do Homebrew: só do Mestre desta campanha (a instância é uma cópia; o modelo nunca muda).
  if new.homebrew_id is not null and (tg_op = 'INSERT' or new.homebrew_id is distinct from old.homebrew_id) then
    if not exists (select 1 from public.homebrew where id = new.homebrew_id and owner_id = master and kind in ('monstro', 'npc')) then
      raise exception 'Modelo do Homebrew inválido para esta campanha.';
    end if;
  end if;
  if new.image_path is not null and not (
       public.is_media_path(new.image_path, 'npcs', camp::text)
       or public.is_media_path(new.image_path, 'homebrew', master::text)) then
    raise exception 'Imagem inválida para o combatente.';
  end if;
  if new.pv_max is not null and new.pv_current is not null then
    new.pv_current := least(greatest(new.pv_current, 0), new.pv_max);
  end if;
  if new.pc_max is not null and new.pc_current is not null then
    new.pc_current := least(greatest(new.pc_current, 0), new.pc_max);
  end if;
  return new;
end $$;

-- Visão dos jogadores ganha a imagem (combatentes ocultos continuam fora).
drop view if exists public.combatants_public;
create view public.combatants_public with (security_barrier = true) as
select cb.id, cb.combat_id, cb.character_id, cb.npc_id, cb.kind, cb.form_id, cb.name, cb.initiative, cb.sort_order,
  case when cb.hide_stats then null when cb.character_id is not null then cf.pv_current else cb.pv_current end as pv_current,
  case when cb.hide_stats then null when cb.character_id is not null then public.form_pv_max(cf.id) else cb.pv_max end as pv_max,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then cf.pc_current else cb.pc_current end as pc_current,
  case when cb.hide_stats or ch.origin_id = 'prodigio' then null when cb.character_id is not null then public.form_pc_max(cf.id) else cb.pc_max end as pc_max,
  case when cb.character_id is not null then cf.conditions else cb.conditions end as conditions,
  cb.hidden,
  case when cb.character_id is not null then cf.portrait_path else cb.image_path end as image_path
from public.combatants cb
join public.combats c on c.id = cb.combat_id
left join public.character_forms cf on cf.id = cb.form_id
left join public.characters ch on ch.id = cb.character_id
where public.is_campaign_member(c.campaign_id)
  and (not cb.hidden or public.is_campaign_master(c.campaign_id));
revoke all on public.combatants_public from anon;
grant select on public.combatants_public to authenticated;

-- Gasto de PC de habilidade de monstro: recusa se não houver PC suficiente (combat_apply só limita a 0).
create or replace function public.combatant_spend_pc(p_combatant uuid, p_amount int, p_request uuid, p_note text default '')
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre usa habilidades de criaturas.';
  end if;
  if cbt.character_id is not null then
    raise exception 'Personagens gastam PC pela própria ficha.';
  end if;
  if p_amount is null or p_amount < 0 or p_amount > 99999 then
    raise exception 'Custo inválido.';
  end if;
  if p_amount = 0 then
    return jsonb_build_object('before', cbt.pc_current, 'after', cbt.pc_current);
  end if;
  if coalesce(cbt.pc_current, 0) < p_amount then
    raise exception 'PC insuficiente (% de %).', coalesce(cbt.pc_current, 0), p_amount;
  end if;
  return public.combat_apply(p_combatant, 'pc_spend', p_amount, p_request, p_note);
end $$;
revoke execute on function public.combatant_spend_pc(uuid, int, uuid, text) from public, anon;
grant execute on function public.combatant_spend_pc(uuid, int, uuid, text) to authenticated;

-- ---------------------------------------------------------------------
-- 7. STORAGE: bucket privado + políticas (nada de base64 no banco)
-- ---------------------------------------------------------------------
-- Quem pode LER um arquivo:
--   characters/<personagem>/…  → quem pode ver a ficha (dono e Mestre de campanha com vínculo aceito)
--   homebrew/<autor>/…          → o autor; membros de campanha com o conteúdo compartilhado;
--                                 jogadores, quando a imagem está num NPC visível ou combatente não oculto
--   npcs/<campanha>/…           → o Mestre; jogadores, se o NPC estiver visível ou o combatente não oculto
create or replace function public.can_read_media(p_name text) returns boolean
language plpgsql stable security definer set search_path = public as $$
declare
  folder text := split_part(p_name, '/', 1);
  owner_id uuid := public.try_uuid(split_part(p_name, '/', 2));
begin
  if auth.uid() is null or owner_id is null then
    return false;
  end if;
  if folder = 'characters' then
    return public.can_view_character(owner_id);
  elsif folder = 'homebrew' then
    if owner_id = auth.uid() then
      return true;
    end if;
    if exists (select 1 from public.homebrew h where h.image_path = p_name and public.homebrew_shared_with_me(h.id)) then
      return true;
    end if;
  elsif folder = 'npcs' then
    if public.is_campaign_master(owner_id) then
      return true;
    end if;
  else
    return false;
  end if;
  return exists (select 1 from public.npcs n where n.image_path = p_name and n.visible_to_players and public.is_campaign_member(n.campaign_id))
      or exists (select 1 from public.combatants cb join public.combats c on c.id = cb.combat_id
                 where cb.image_path = p_name and not cb.hidden and public.is_campaign_member(c.campaign_id))
      or exists (select 1 from public.items i where i.image_path = p_name and public.can_view_character(i.character_id));
end $$;

-- Quem pode ENVIAR/TROCAR/APAGAR: só o dono da pasta.
create or replace function public.can_write_media(p_name text) returns boolean
language plpgsql stable security definer set search_path = public as $$
declare
  folder text := split_part(p_name, '/', 1);
  owner_id uuid := public.try_uuid(split_part(p_name, '/', 2));
begin
  if auth.uid() is null or owner_id is null or split_part(p_name, '/', 3) !~ '^[A-Za-z0-9_-]{1,80}\.(webp|png|jpg|jpeg)$' or split_part(p_name, '/', 4) <> '' then
    return false;
  end if;
  return case folder
    when 'characters' then public.owns_character(owner_id)
    when 'homebrew' then owner_id = auth.uid()
    when 'npcs' then public.is_campaign_master(owner_id)
    else false
  end;
end $$;
grant execute on function public.can_read_media(text), public.can_write_media(text) to authenticated;

do $$
begin
  if exists (select 1 from pg_namespace where nspname = 'storage')
     and exists (select 1 from pg_class c join pg_namespace n on n.oid = c.relnamespace where n.nspname = 'storage' and c.relname = 'objects') then
    insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
    values ('france-media', 'france-media', false, 2097152, array['image/webp', 'image/png', 'image/jpeg'])
    on conflict (id) do update set public = false, file_size_limit = 2097152, allowed_mime_types = array['image/webp', 'image/png', 'image/jpeg'];

    execute 'drop policy if exists france_media_read on storage.objects';
    execute 'drop policy if exists france_media_insert on storage.objects';
    execute 'drop policy if exists france_media_update on storage.objects';
    execute 'drop policy if exists france_media_delete on storage.objects';
    execute $p$create policy france_media_read on storage.objects for select to authenticated
             using (bucket_id = 'france-media' and public.can_read_media(name))$p$;
    execute $p$create policy france_media_insert on storage.objects for insert to authenticated
             with check (bucket_id = 'france-media' and public.can_write_media(name))$p$;
    execute $p$create policy france_media_update on storage.objects for update to authenticated
             using (bucket_id = 'france-media' and public.can_write_media(name))
             with check (bucket_id = 'france-media' and public.can_write_media(name))$p$;
    execute $p$create policy france_media_delete on storage.objects for delete to authenticated
             using (bucket_id = 'france-media' and public.can_write_media(name))$p$;
  end if;
end $$;

-- ---------------------------------------------------------------------
-- 8. Realtime (fotos e instâncias de combate)
-- ---------------------------------------------------------------------
do $$
declare
  t text;
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime') then
    foreach t in array array['homebrew_shares'] loop
      if not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = t) then
        execute format('alter publication supabase_realtime add table public.%I', t);
      end if;
    end loop;
  end if;
end $$;

grant select, insert, update, delete on public.homebrew_shares to authenticated;


-- =====================================================================
-- >>> 20261027000000_rules_sync_v6.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10-v6) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10-v6",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "pvFormula": "sum_div3",
  "abilities": {
    "base": 2,
    "perEvenLevel": 1,
    "blockLevelUpWhenPending": true,
    "originModes": {
      "muto": "none",
      "elo": "free"
    },
    "pathOverrides": {
      "prodigio:arsenal": {
        "base": 0,
        "perEvenLevel": 1
      },
      "prodigio:engrenagem": {
        "base": 1,
        "perEvenLevel": 1
      }
    }
  },
  "prodigioPowers": {
    "noPcCost": true,
    "noLimits": true,
    "allowNoEffects": true
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "skillDefs": {
    "luta": {
      "kind": "attribute",
      "attribute": "FOR",
      "divisor": 2
    },
    "reflexo": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "conhecimento_belico": {
      "kind": "attribute",
      "attribute": "INT",
      "divisor": 2
    },
    "arma_de_fogo": {
      "kind": "fixed",
      "value": 20
    },
    "pontaria": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "investigacao": {
      "kind": "fixed",
      "value": 20
    },
    "enganacao": {
      "kind": "fixed",
      "value": 15
    },
    "furtividade": {
      "kind": "fixed",
      "value": 20
    },
    "pilotagem": {
      "kind": "fixed",
      "value": 5
    },
    "intuicao": {
      "kind": "fixed",
      "value": 10
    }
  },
  "skillDistribution": {
    "skillsToChoose": 4,
    "totalPoints": 150,
    "maxSkillTotal": 75
  },
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "FOR": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "DEX": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {
        "PER": 4
      },
      "skillBonus": {},
      "maxSkillTotal": 95,
      "skillPointsBonus": 50,
      "pvBonusAtLevel1": 0
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "attributeBonus": {
        "MIT": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "arma_de_fogo": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "furtividade": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 20
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null,
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 2
      },
      "pcDice": null
    }
  },
  "weaponModifiers": {
    "afiada": "laminas",
    "perfurante": "perfurantes_projeteis",
    "serrilhada": "laminas",
    "precisa": "distancia",
    "equilibrada": "corpo_a_corpo",
    "pesada": "pesadas",
    "brutal": "pesadas",
    "concussiva": "contundentes",
    "gancho": "foices_correntes",
    "executora": "corpo_a_corpo",
    "rajada": "arma_de_fogo",
    "automatica": "arma_de_fogo",
    "curto_alcance": "arma_de_fogo",
    "mira_precisao": "arma_de_fogo",
    "recuo_pesado": "arma_de_fogo",
    "dispersao": "arma_de_fogo",
    "penetrante": "arma_de_fogo",
    "confiavel": "arma_de_fogo"
  },
  "techniques": {
    "arte_desarme": {
      "name": "Arte do Desarme",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "arte_contra_ataque": {
      "name": "Arte do Contra-ataque",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "provocacao": {
      "name": "Provocação",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_alvos": {
      "name": "Múltiplos Alvos",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_golpes": {
      "name": "Múltiplos Golpes",
      "usage": {
        "kind": "a_cada_turnos",
        "turns": 2
      },
      "requires": {},
      "special": null
    },
    "adrenalina": {
      "name": "Adrenalina",
      "usage": {
        "kind": "acao",
        "action": "Ação de movimento"
      },
      "requires": {},
      "special": "recarregar_cena"
    },
    "metavisao": {
      "name": "Metavisão",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": "esquiva_rodada"
    },
    "recobrar_se": {
      "name": "Recobrar-se",
      "usage": {
        "kind": "por_sessao",
        "times": 1
      },
      "requires": {},
      "special": "recobrar"
    },
    "passos_leves": {
      "name": "Passos Leves",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "ataque_furtivo": {
      "name": "Ataque Furtivo",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "furtividade_rapida": {
      "name": "Furtividade Rápida",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {
        "attributes": {
          "DEX": 70
        },
        "techniques": [
          "passos_leves"
        ]
      },
      "special": null
    }
  },
  "maxWeaponModifiers": 2,
  "grenades": {
    "granada_fragmentacao": {
      "name": "Granada de Fragmentação",
      "damage": "3d8",
      "area": "Área pequena",
      "condition": null
    },
    "granada_incendiaria": {
      "name": "Granada Incendiária",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Em chamas",
        "turns": 2,
        "dot": "1d6",
        "automatic": true,
        "target": "alvo"
      }
    },
    "granada_concussao": {
      "name": "Granada de Concussão",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Atordoado",
        "turns": 1,
        "automatic": false,
        "target": "alvo"
      }
    },
    "granada_explosiva_pesada": {
      "name": "Granada Explosiva Pesada",
      "damage": "5d8",
      "area": "Área média",
      "condition": null
    },
    "granada_fumaca": {
      "name": "Granada de Fumaça",
      "damage": null,
      "area": "Área pequena",
      "condition": {
        "name": "Cobertura de fumaça",
        "turns": 3,
        "automatic": true,
        "target": "lancador"
      }
    }
  },
  "thresholds": {
    "goodDivisor": 2,
    "extremeDivisor": 5,
    "rounding": "floor"
  },
  "damageMultiplier": {
    "extreme": 1.5,
    "critical": 2
  },
  "damageRounding": "none",
  "attackSkill": {
    "melee": "luta",
    "ranged": "pontaria",
    "firearm": "arma_de_fogo"
  },
  "opposed": {
    "winner": "higher",
    "tiePlayerWins": true,
    "maxRerolls": 10,
    "defaultReaction": {
      "melee": "luta",
      "ranged": "reflexo",
      "firearm": "reflexo"
    },
    "appliedRounding": "floor"
  },
  "powers": {
    "damageSingle": [
      3,
      6,
      9,
      12,
      15
    ],
    "damageArea": [
      6,
      9,
      12,
      15,
      18
    ],
    "areaSizes": {
      "pequena": 0,
      "media": 3,
      "grande": 6,
      "enorme": 9
    },
    "extraDieCost": 3,
    "heal": [
      3,
      6,
      9,
      12,
      15
    ],
    "healArea": {
      "alvo": 0,
      "pequena": 6,
      "media": 9,
      "grande": 12,
      "enorme": 15
    },
    "healContinuous": [
      2,
      3,
      4,
      5,
      6
    ],
    "shield": [
      3,
      6,
      9,
      12,
      15
    ],
    "shieldDuration": {
      "1t": 0,
      "2t": 2,
      "3t": 4,
      "cena": 6
    },
    "conditions": {
      "leve": {
        "initial": 3,
        "perTurn": 1
      },
      "moderada": {
        "initial": 6,
        "perTurn": 2
      },
      "forte": {
        "initial": 9,
        "perTurn": 3
      },
      "severa": {
        "initial": 12,
        "perTurn": 4
      },
      "extrema": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "buffs": {
      "teste_1": {
        "initial": 3,
        "perTurn": 1
      },
      "teste_2": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_1": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_2": {
        "initial": 9,
        "perTurn": 3
      },
      "acao": {
        "initial": 12,
        "perTurn": 4
      },
      "grande": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "levelTable": [
      {
        "level": 1,
        "maxPc": 15,
        "maxExtraDice": 1
      },
      {
        "level": 2,
        "maxPc": 18,
        "maxExtraDice": 1
      },
      {
        "level": 4,
        "maxPc": 24,
        "maxExtraDice": 2
      },
      {
        "level": 6,
        "maxPc": 30,
        "maxExtraDice": 3
      },
      {
        "level": 8,
        "maxPc": 36,
        "maxExtraDice": 4
      },
      {
        "level": 10,
        "maxPc": 42,
        "maxExtraDice": 5
      },
      {
        "level": 15,
        "maxPc": 57,
        "maxExtraDice": 7
      },
      {
        "level": 20,
        "maxPc": 72,
        "maxExtraDice": 10
      }
    ],
    "limitMode": "linear",
    "perTurnCountsTowardLimit": false,
    "amaldicoadoRounding": "ceil",
    "amaldicoadoLimitUsesFullCost": true
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

-- ---------------------------------------------------------------------
-- PV máximo da forma — mesma conta do motor (buildSheet):
-- (FOR + CON) ÷ 3 para baixo + bônus de classe + ganhos de nível ativos + outros bônus.
-- ---------------------------------------------------------------------
create or replace function public.form_pv_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  str int;
  con int;
  base int;
  gains int;
begin
  select cf.id, cf.kind, cf.pv_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into str
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'FOR';
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into con
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'CON';
  str := coalesce(str, 0) + coalesce((cls -> 'attributeBonus' ->> 'FOR')::int, 0);
  con := coalesce(con, 0) + coalesce((cls -> 'attributeBonus' ->> 'CON')::int, 0);
  if cfg ->> 'pvFormula' = 'sum_div3' then
    base := floor((str + con)::numeric / 3)::int;
  else
    base := str + floor(con::numeric / 3)::int;
  end if;
  base := base + coalesce((cls ->> 'pvBonusAtLevel1')::int, 0);
  select coalesce(sum(lp.pv_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, base + gains + f.pv_other_bonus);
end $$;

-- PC máximo da forma — mesma conta do motor: VIG ÷ 3 para baixo + ganhos de nível ativos + outros bônus.
create or replace function public.form_pc_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  vig int;
  gains int;
begin
  select cf.id, cf.kind, cf.pc_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into vig
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'VIG';
  vig := coalesce(vig, 0) + coalesce((cls -> 'attributeBonus' ->> 'VIG')::int, 0);
  select coalesce(sum(lp.pc_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, floor(vig::numeric / 3)::int + gains + f.pc_other_bonus);
end $$;

-- ---------------------------------------------------------------------
-- Vagas de habilidades — mesma conta do motor (abilities.ts).
-- mode: standard | free (Elo) | none (Muto). Executa com as permissões de quem chama.
-- ---------------------------------------------------------------------
create or replace function public.ability_granted(p_origin text, p_path text, p_level int) returns int
language plpgsql immutable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ov jsonb := cfg -> 'pathOverrides' -> (p_origin || ':' || p_path);
begin
  if coalesce(cfg -> 'originModes' ->> p_origin, 'standard') <> 'standard' then
    return 0;
  end if;
  return coalesce((ov ->> 'base')::int, (cfg ->> 'base')::int)
       + coalesce((ov ->> 'perEvenLevel')::int, (cfg ->> 'perEvenLevel')::int) * (greatest(p_level, 1) / 2);
end $$;

create or replace function public.ability_status(p_character uuid) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ch record;
  created int;
begin
  select level, origin_id, origin_path_id into ch from public.characters where id = p_character;
  -- Técnicas oficiais do Arsenal e poderes criados ocupam o mesmo conjunto de vagas (sem consumo duplicado).
  select (select count(*) from public.powers where character_id = p_character)
       + (select count(*) from public.character_techniques where character_id = p_character)
    into created;
  return jsonb_build_object(
    'mode', coalesce(cfg -> 'originModes' ->> ch.origin_id, 'standard'),
    'granted', public.ability_granted(ch.origin_id, ch.origin_path_id, ch.level),
    'created', created,
    'level', ch.level);
end $$;

grant execute on function public.rules_config() to authenticated;
grant execute on function public.form_pv_max(uuid), public.form_pc_max(uuid), public.ability_granted(text, text, int), public.ability_status(uuid) to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;


-- =====================================================================
-- >>> 20261027000100_v6_finalizacao.sql
-- =====================================================================
-- =====================================================================
-- F.R.A.N.C.E — VERSÃO 6.0 (Fase 6): combate por rolagens opostas, granadas,
-- efeitos contínuos com dano, fotos nos cartões de campanha.
-- Incremental sobre a Fase 5 (aplique DEPOIS de 20261027000000_rules_sync_v6.sql).
-- Não apaga tabelas nem dados; pode ser reaplicada.
-- =====================================================================

-- ---------------------------------------------------------------------
-- 1. Classificação do d100 e resultado do confronto (mesma conta do motor: src/rules/opposed.ts)
-- ---------------------------------------------------------------------
create or replace function public.apply_rounding(p_value numeric, p_mode text) returns numeric
language sql immutable as $$
  select case p_mode when 'floor' then floor(p_value) when 'ceil' then ceil(p_value) when 'round' then round(p_value) else p_value end
$$;

-- Menor é melhor: 1 = crítico, 100 = falha crítica; extremo ≤ valor/5, bom ≤ valor/2, normal ≤ valor.
create or replace function public.classify_d100(p_natural int, p_value int, p_modifier int default 0) returns text
language plpgsql stable set search_path = public as $$
declare
  t jsonb := public.rules_config() -> 'thresholds';
  v int := greatest(0, coalesce(p_value, 0));
  eff int := p_natural + coalesce(p_modifier, 0);
begin
  if p_natural is null or p_natural < 1 or p_natural > 100 then
    raise exception 'O resultado do d100 deve ser um inteiro entre 1 e 100.';
  end if;
  if p_natural = 1 then return 'critical_success'; end if;
  if p_natural = 100 then return 'critical_failure'; end if;
  if eff <= public.apply_rounding(v::numeric / (t ->> 'extremeDivisor')::numeric, t ->> 'rounding') then return 'extreme'; end if;
  if eff <= public.apply_rounding(v::numeric / (t ->> 'goodDivisor')::numeric, t ->> 'rounding') then return 'good'; end if;
  if eff <= v then return 'normal'; end if;
  return 'failure';
end $$;

create or replace function public.outcome_label(p_outcome text) returns text
language sql immutable as $$
  select case p_outcome when 'critical_success' then 'Acerto crítico' when 'critical_failure' then 'Falha crítica'
    when 'extreme' then 'Acerto extremo' when 'good' then 'Acerto bom' when 'normal' then 'Acerto normal' else 'Falha' end
$$;

-- Uma rodada: vencedor (maior d100, configurável), desempates e multiplicador do dano.
create or replace function public.confront_outcome(p_attack int, p_defend int, p_att_skill int, p_def_skill int,
                                                   p_att_player boolean, p_def_player boolean, p_modifier int default 0)
returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  higher boolean := coalesce(cfg -> 'opposed' ->> 'winner', 'higher') = 'higher';
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

-- ---------------------------------------------------------------------
-- 2. Valor das perícias (mesma conta do motor: base do atributo final + pontos + classe + outros + temporários)
-- ---------------------------------------------------------------------
create or replace function public.form_skill_value(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
  base int;
  fs record;
begin
  if def is null then
    return 0;
  end if;
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    base := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    base := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  select coalesce(points, 0) as points, coalesce(other_bonus, 0) as other_bonus, coalesce(temp_bonus, 0) as temp_bonus into fs
  from public.form_skills where form_id = p_form and skill_id = p_skill;
  return base + coalesce(fs.points, 0) + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0) + coalesce(fs.other_bonus, 0) + coalesce(fs.temp_bonus, 0);
end $$;
revoke execute on function public.form_skill_value(uuid, text) from public, anon;

-- Perícia de um combatente: personagem → ficha (forma usada no combate); criatura → ficha copiada (perícia,
-- senão a base do atributo como nas regras, senão 0).
create or replace function public.combatant_skill_value(p_combatant uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cb public.combatants;
  d jsonb;
  def jsonb := public.rules_config() -> 'skillDefs' -> p_skill;
  v int;
begin
  select * into cb from public.combatants where id = p_combatant;
  if cb.id is null then return 0; end if;
  if cb.character_id is not null then
    return public.form_skill_value(cb.form_id, p_skill);
  end if;
  d := coalesce(cb.data, '{}'::jsonb);
  if jsonb_array_length(coalesce(d -> 'skills', '[]'::jsonb)) = 0 and d -> 'attributes' is null and cb.npc_id is not null then
    select data into d from public.npcs where id = cb.npc_id;
  end if;
  select (s ->> 'value')::int into v from jsonb_array_elements(coalesce(d -> 'skills', '[]'::jsonb)) s where s ->> 'id' = p_skill limit 1;
  if v is not null then return v; end if;
  if def ->> 'kind' = 'fixed' then return (def ->> 'value')::int; end if;
  if def ->> 'kind' = 'attribute' and (d -> 'attributes' ->> (def ->> 'attribute')) is not null then
    return floor((d -> 'attributes' ->> (def ->> 'attribute'))::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return 0;
end $$;
revoke execute on function public.combatant_skill_value(uuid, text) from public, anon;

-- ---------------------------------------------------------------------
-- 3. CONFRONTOS (histórico próprio; os dados são rolados AQUI — ninguém escolhe o número)
-- ---------------------------------------------------------------------
create table if not exists public.combat_confrontations (
  id uuid primary key default gen_random_uuid(),
  combat_id uuid not null references public.combats (id) on delete cascade,
  attacker_id uuid references public.combatants (id) on delete set null,
  defender_id uuid references public.combatants (id) on delete set null,
  attacker_name text not null,
  defender_name text not null,
  label text not null default '',
  attack_skill text,
  attack_value int not null default 0,
  reaction_skill text,
  defense_value int not null default 0,
  rounds jsonb not null default '[]'::jsonb,
  attack_roll int not null,
  defend_roll int not null,
  winner text not null check (winner in ('attacker', 'defender')),
  tie_break text not null default 'none',
  quality text not null,
  defender_quality text not null,
  multiplier numeric not null default 0,
  damage jsonb,
  final_damage numeric not null default 0,
  applied_damage int not null default 0,
  applied boolean not null default false,
  conditions jsonb not null default '[]'::jsonb,
  public boolean not null default true,
  requested_by uuid references auth.users (id) on delete set null,
  by_player boolean not null default false,
  request_id uuid not null unique,
  round int not null default 1,
  created_at timestamptz not null default now()
);
create index if not exists combat_confrontations_combat_idx on public.combat_confrontations (combat_id, created_at desc);
alter table public.combat_confrontations enable row level security;
drop policy if exists confront_master on public.combat_confrontations;
create policy confront_master on public.combat_confrontations for select to authenticated
  using (exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_master(c.campaign_id)));
drop policy if exists confront_players on public.combat_confrontations;
create policy confront_players on public.combat_confrontations for select to authenticated
  using (public and exists (select 1 from public.combats c where c.id = combat_id and public.is_campaign_member(c.campaign_id)));
revoke insert, update, delete on public.combat_confrontations from authenticated, anon;
grant select on public.combat_confrontations to authenticated;

-- Aplica as condições de um confronto vencido no defensor (com dano contínuo, se houver). Uso interno.
create or replace function public.combatant_add_conditions(p_combatant uuid, p_conditions jsonb) returns void
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  c jsonb;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  if cbt.id is null then return; end if;
  for c in select * from jsonb_array_elements(coalesce(p_conditions, '[]'::jsonb)) loop
    continue when coalesce(c ->> 'name', '') = '' or coalesce((c ->> 'automatic')::boolean, true) = false;
    if cbt.character_id is not null then
      update public.character_forms set conditions = public.condition_add_dot(conditions, left(c ->> 'name', 80), nullif(c ->> 'turns', '')::int, null, nullif(c ->> 'dot', ''))
      where id = cbt.form_id;
    else
      update public.combatants set conditions = public.condition_add_dot(conditions, left(c ->> 'name', 80), nullif(c ->> 'turns', '')::int, null, nullif(c ->> 'dot', ''))
      where id = cbt.id;
    end if;
  end loop;
end $$;
revoke execute on function public.combatant_add_conditions(uuid, jsonb) from public, anon, authenticated;

create or replace function public.combat_confront(
  p_combat uuid, p_attacker uuid, p_defender uuid, p_attack jsonb, p_reaction text, p_request uuid,
  p_apply boolean default false, p_public boolean default true)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  cb public.combats;
  att public.combatants;
  def public.combatants;
  existing public.combat_confrontations;
  is_master boolean;
  skill text := nullif(p_attack ->> 'skill', '');
  reaction text := nullif(p_reaction, '');
  att_value int;
  def_value int;
  modifier int := coalesce((p_attack ->> 'modifier')::int, 0);
  factor numeric := coalesce((p_attack ->> 'factor')::numeric, 1);
  dmg_expr text := nullif(trim(coalesce(p_attack ->> 'damage', '')), '');
  crit_expr text := nullif(trim(coalesce(p_attack ->> 'critical', '')), '');
  label text := left(coalesce(nullif(p_attack ->> 'label', ''), 'Ataque'), 120);
  a int; d int;
  o jsonb;
  rounds jsonb := '[]'::jsonb;
  n int := 0;
  dmg jsonb;
  final numeric := 0;
  applied_amount int := 0;
  visible boolean;
  row public.combat_confrontations;
  msg text;
begin
  select * into existing from public.combat_confrontations where request_id = p_request;
  if existing.id is not null then
    return to_jsonb(existing) || jsonb_build_object('duplicate', true);
  end if;
  select * into cb from public.combats where id = p_combat;
  select * into att from public.combatants where id = p_attacker and combat_id = p_combat;
  select * into def from public.combatants where id = p_defender and combat_id = p_combat;
  if cb.id is null or att.id is null or def.id is null then
    raise exception 'Combate ou participantes inválidos.';
  end if;
  if att.id = def.id then
    raise exception 'Escolha outro alvo.';
  end if;
  is_master := public.is_campaign_master(cb.campaign_id);
  if not is_master then
    -- Jogador: só ataca com o próprio personagem, em combate em andamento; o dano não é aplicado sozinho.
    if att.character_id is null or not public.owns_character(att.character_id) or cb.status <> 'active' then
      raise exception 'Você só pode atacar com o seu personagem, durante o combate.';
    end if;
    if def.hidden then
      raise exception 'Alvo inválido.';
    end if;
    p_apply := false;
    p_public := true;
    modifier := greatest(-60, least(60, modifier));
    factor := greatest(1, least(2, factor));
  end if;
  if cb.status = 'ended' then
    raise exception 'Combate encerrado.';
  end if;
  if skill is not null and not (cfg -> 'skills') ? skill then
    raise exception 'Perícia de ataque inválida.';
  end if;
  if reaction is null then
    reaction := coalesce(cfg -> 'opposed' -> 'defaultReaction' ->> coalesce(p_attack ->> 'attack_kind', 'melee'), 'reflexo');
  end if;
  if not (cfg -> 'skills') ? reaction then
    raise exception 'Perícia de reação inválida.';
  end if;
  if dmg_expr is not null and not public.is_valid_dice(dmg_expr) then raise exception 'Dano inválido.'; end if;
  if crit_expr is not null and not public.is_valid_dice(crit_expr) then raise exception 'Dano crítico inválido.'; end if;

  -- Valores das perícias calculados no banco (personagens) ou pela ficha copiada (criaturas).
  if att.character_id is not null then
    att_value := public.form_skill_value(att.form_id, coalesce(skill, cfg -> 'attackSkill' ->> coalesce(p_attack ->> 'attack_kind', 'melee')));
  elsif is_master and (p_attack ->> 'value') is not null then
    att_value := greatest(0, least(999, (p_attack ->> 'value')::int));
  else
    att_value := public.combatant_skill_value(att.id, coalesce(skill, 'luta'));
  end if;
  def_value := public.combatant_skill_value(def.id, reaction);

  loop
    n := n + 1;
    a := public.roll_die(100);
    d := public.roll_die(100);
    o := public.confront_outcome(a, d, att_value, def_value, att.character_id is not null, def.character_id is not null, modifier);
    rounds := rounds || jsonb_build_array(jsonb_build_object('attack', a, 'defend', d, 'winner', o ->> 'winner', 'tie_break', o ->> 'tie_break'));
    exit when o ->> 'winner' <> 'reroll' or n > coalesce((cfg -> 'opposed' ->> 'maxRerolls')::int, 10);
  end loop;
  if o ->> 'winner' = 'reroll' then
    o := o || jsonb_build_object('winner', 'defender', 'multiplier', 0);
  end if;

  if o ->> 'winner' = 'attacker' and dmg_expr is not null then
    dmg := public.roll_expression(case when o ->> 'quality' = 'critical_success' and crit_expr is not null then crit_expr else dmg_expr end);
    final := public.apply_rounding((dmg ->> 'total')::numeric * (o ->> 'multiplier')::numeric * factor, cfg ->> 'damageRounding');
    applied_amount := greatest(0, public.apply_rounding(final, coalesce(cfg -> 'opposed' ->> 'appliedRounding', 'floor'))::int);
  end if;

  visible := p_public and not att.hidden and not def.hidden;
  insert into public.combat_confrontations (combat_id, attacker_id, defender_id, attacker_name, defender_name, label, attack_skill, attack_value,
    reaction_skill, defense_value, rounds, attack_roll, defend_roll, winner, tie_break, quality, defender_quality, multiplier, damage,
    final_damage, applied_damage, conditions, public, requested_by, by_player, request_id, round)
  values (p_combat, att.id, def.id, att.name, def.name, label, skill, att_value, reaction, def_value, rounds, a, d, o ->> 'winner',
    o ->> 'tie_break', o ->> 'quality', o ->> 'defender_quality', (o ->> 'multiplier')::numeric, dmg, final, applied_amount,
    case when o ->> 'winner' = 'attacker' then coalesce(p_attack -> 'conditions', '[]'::jsonb) else '[]'::jsonb end,
    visible, auth.uid(), not is_master, p_request, cb.round)
  returning * into row;

  msg := format('%s → %s (%s): d100 %s × %s — %s', att.name, def.name, label, a, d,
    case when o ->> 'winner' = 'attacker' then 'acertou' else 'defendido' end)
    || case when o ->> 'tie_break' <> 'none' then ' (' || case o ->> 'tie_break' when 'player' then 'empate: jogador vence' when 'skill' then 'empate: perícia' else 'empate' end || ')' else '' end
    || case when o ->> 'winner' = 'attacker' then ', ' || public.outcome_label(o ->> 'quality') ||
         case when dmg is not null then format(', %s de dano', final) else '' end else '' end || '.';
  perform public.combat_log_add(p_combat, 'confronto', msg, jsonb_build_object('confront', row.id), visible);

  if p_apply and is_master and row.winner = 'attacker' and (applied_amount > 0 or jsonb_array_length(row.conditions) > 0) then
    if applied_amount > 0 then
      perform public.combat_apply(def.id, 'damage', applied_amount, md5('confront:' || row.id::text)::uuid, label);
    end if;
    perform public.combatant_add_conditions(def.id, row.conditions);
    update public.combat_confrontations set applied = true where id = row.id returning * into row;
  end if;
  update public.combats set version = version + 1, updated_at = now() where id = p_combat;
  return to_jsonb(row) || jsonb_build_object('duplicate', false);
end $$;
revoke execute on function public.combat_confront(uuid, uuid, uuid, jsonb, text, uuid, boolean, boolean) from public, anon;
grant execute on function public.combat_confront(uuid, uuid, uuid, jsonb, text, uuid, boolean, boolean) to authenticated;

-- O Mestre confirma o dano de um confronto (ex.: ataque feito pelo jogador). Aplica uma vez só.
create or replace function public.combat_confront_apply(p_confront uuid) returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  r public.combat_confrontations;
  cb public.combats;
begin
  select * into r from public.combat_confrontations where id = p_confront for update;
  select * into cb from public.combats where id = r.combat_id;
  if r.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica o dano.';
  end if;
  if r.winner <> 'attacker' or (r.applied_damage <= 0 and jsonb_array_length(r.conditions) = 0) or r.defender_id is null then
    raise exception 'Não há dano para aplicar.';
  end if;
  if r.applied then
    return to_jsonb(r) || jsonb_build_object('duplicate', true);
  end if;
  if r.applied_damage > 0 then
    perform public.combat_apply(r.defender_id, 'damage', r.applied_damage, md5('confront:' || r.id::text)::uuid, r.label);
  end if;
  perform public.combatant_add_conditions(r.defender_id, r.conditions);
  update public.combat_confrontations set applied = true where id = r.id returning * into r;
  return to_jsonb(r) || jsonb_build_object('duplicate', false);
end $$;
revoke execute on function public.combat_confront_apply(uuid) from public, anon;
grant execute on function public.combat_confront_apply(uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 4. EFEITOS CONTÍNUOS COM DANO (ex.: Granada Incendiária: +1d6 por 2 turnos)
-- Condição pode ter "dot" (expressão de dados): o dano é rolado no fim do turno de quem a tem, antes da duração cair.
-- ---------------------------------------------------------------------
create or replace function public.condition_add_dot(p_list jsonb, p_name text, p_turns int, p_note text, p_dot text) returns jsonb
language plpgsql volatile as $$
declare
  l jsonb := public.condition_add(p_list, p_name, p_turns, p_note);
begin
  if p_dot is null or trim(p_dot) = '' then
    return l;
  end if;
  if not public.is_valid_dice(p_dot) then
    raise exception 'Dano contínuo inválido.';
  end if;
  return jsonb_set(l, array[(jsonb_array_length(l) - 1)::text], (l -> (jsonb_array_length(l) - 1)) || jsonb_build_object('dot', p_dot));
end $$;

drop function if exists public.combat_condition(uuid, text, text, int, text);
create or replace function public.combat_condition(p_combatant uuid, p_action text, p_name text default null, p_turns int default null,
                                                   p_id text default null, p_dot text default null)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cbt public.combatants;
  cb public.combats;
  list jsonb;
begin
  select * into cbt from public.combatants where id = p_combatant for update;
  select * into cb from public.combats where id = cbt.combat_id;
  if cbt.id is null or not public.is_campaign_master(cb.campaign_id) then
    raise exception 'Apenas o Mestre aplica condições no combate.';
  end if;
  if p_action = 'add' then
    if cbt.character_id is not null then
      update public.character_forms set conditions = public.condition_add_dot(conditions, p_name, p_turns, null, p_dot) where id = cbt.form_id returning conditions into list;
    else
      update public.combatants set conditions = public.condition_add_dot(conditions, p_name, p_turns, null, p_dot) where id = cbt.id returning conditions into list;
    end if;
  elsif p_action = 'remove' then
    if cbt.character_id is not null then
      update public.character_forms set conditions = public.condition_remove(conditions, p_id) where id = cbt.form_id returning conditions into list;
    else
      update public.combatants set conditions = public.condition_remove(conditions, p_id) where id = cbt.id returning conditions into list;
    end if;
  else
    raise exception 'Ação inválida.';
  end if;
  perform public.combat_log_add(cb.id, 'condicao',
    case when p_action = 'add' then format('%s: %s%s%s.', cbt.name, p_name, case when p_turns is null then '' else format(' (%s turno(s))', p_turns) end,
                                           case when p_dot is null then '' else format(', %s por turno', p_dot) end)
         else format('%s: condição removida.', cbt.name) end, '{}'::jsonb, not cbt.hidden);
  update public.combats set version = version + 1, updated_at = now() where id = cb.id;
  return list;
end $$;
revoke execute on function public.combat_condition(uuid, text, text, int, text, text) from public, anon;
grant execute on function public.combat_condition(uuid, text, text, int, text, text) to authenticated;

create or replace function public.combat_tick_conditions(p_combat uuid, p_combatant public.combatants) returns void
language plpgsql security definer set search_path = public as $$
declare
  r record;
  hidden boolean := p_combatant.hidden;
  conds jsonb;
  c jsonb;
  roll jsonb;
  total int := 0;
  parts text[] := '{}';
begin
  if p_combatant.character_id is not null and p_combatant.form_id is not null then
    select conditions into conds from public.character_forms where id = p_combatant.form_id;
  else
    conds := p_combatant.conditions;
  end if;
  -- Dano contínuo (dot) antes de a duração diminuir.
  for c in select * from jsonb_array_elements(coalesce(conds, '[]'::jsonb)) loop
    if coalesce(c ->> 'dot', '') <> '' and public.is_valid_dice(c ->> 'dot') then
      roll := public.roll_expression(c ->> 'dot');
      total := total + greatest(0, (roll ->> 'total')::int);
      parts := array_append(parts, format('%s %s', c ->> 'name', roll ->> 'total'));
    end if;
  end loop;
  if total > 0 then
    if p_combatant.character_id is not null and p_combatant.form_id is not null then
      update public.character_forms set pv_current = greatest(pv_current - total, 0) where id = p_combatant.form_id;
    else
      update public.combatants set pv_current = greatest(coalesce(pv_current, 0) - total, 0) where id = p_combatant.id and pv_current is not null;
    end if;
    perform public.combat_log_add(p_combat, 'damage', format('%s sofre %s de dano contínuo (%s).', p_combatant.name, total, array_to_string(parts, ', ')), '{}'::jsonb, not hidden);
  end if;
  select * into r from public.condition_tick(conds);
  if p_combatant.character_id is not null and p_combatant.form_id is not null then
    update public.character_forms set conditions = r.list where id = p_combatant.form_id;
  else
    update public.combatants set conditions = r.list where id = p_combatant.id;
  end if;
  if cardinality(r.expired) > 0 then
    perform public.combat_log_add(p_combat, 'condicao', format('%s: terminou %s.', p_combatant.name, array_to_string(r.expired, ', ')), '{}'::jsonb, not hidden);
  end if;
end $$;
revoke execute on function public.combat_tick_conditions(uuid, public.combatants) from public, anon, authenticated;

-- ---------------------------------------------------------------------
-- 5. FOTOS NOS CARTÕES DA CAMPANHA
-- O grupo (personagens aceitos) mostra a foto da forma ativa; quem vê o grupo também vê as fotos.
-- ---------------------------------------------------------------------
drop function if exists public.campaign_party(uuid);
create or replace function public.campaign_party(p_campaign uuid)
returns table (character_id uuid, name text, class_id text, origin_id text, origin_path_id text, level int,
               owner_id uuid, owner_username text, status text, is_mine boolean, active_form text, portrait_path text)
language sql stable security definer set search_path = public as $$
  select c.id, c.name, c.class_id, c.origin_id, c.origin_path_id, c.level, c.owner_id, p.username::text, cc.status,
         c.owner_id = auth.uid(), c.active_form,
         coalesce((select cf.portrait_path from public.character_forms cf where cf.character_id = c.id and cf.kind = c.active_form and cf.setup_complete),
                  (select cf.portrait_path from public.character_forms cf where cf.character_id = c.id and cf.kind = 'base'))
  from public.campaign_characters cc
  join public.characters c on c.id = cc.character_id
  left join public.profiles p on p.id = c.owner_id
  where cc.campaign_id = p_campaign
    and public.is_campaign_member(p_campaign)
    and (
      public.is_campaign_master(p_campaign)
      or c.owner_id = auth.uid()
      or (cc.status = 'accepted' and coalesce((select (settings ->> 'players_see_party')::boolean from public.campaigns where id = p_campaign), true))
    )
  order by cc.linked_at;
$$;
grant execute on function public.campaign_party(uuid) to authenticated;

create or replace function public.can_read_media(p_name text) returns boolean
language plpgsql stable security definer set search_path = public as $$
declare
  folder text := split_part(p_name, '/', 1);
  v_owner uuid := public.try_uuid(split_part(p_name, '/', 2));
begin
  if auth.uid() is null or v_owner is null then
    return false;
  end if;
  if folder = 'characters' then
    -- Dono e Mestre (vínculo aceito) + colegas de campanha que podem ver o grupo.
    return public.can_view_character(v_owner) or exists (
      select 1 from public.campaign_characters cc join public.campaigns k on k.id = cc.campaign_id
      where cc.character_id = v_owner and cc.status = 'accepted' and public.is_campaign_member(cc.campaign_id)
        and coalesce((k.settings ->> 'players_see_party')::boolean, true));
  elsif folder = 'homebrew' then
    if v_owner = auth.uid() then
      return true;
    end if;
    if exists (select 1 from public.homebrew h where h.image_path = p_name and public.homebrew_shared_with_me(h.id)) then
      return true;
    end if;
  elsif folder = 'npcs' then
    if public.is_campaign_master(v_owner) then
      return true;
    end if;
  else
    return false;
  end if;
  return exists (select 1 from public.npcs n where n.image_path = p_name and n.visible_to_players and public.is_campaign_member(n.campaign_id))
      or exists (select 1 from public.combatants cb join public.combats c on c.id = cb.combat_id
                 where cb.image_path = p_name and not cb.hidden and public.is_campaign_member(c.campaign_id))
      or exists (select 1 from public.items i where i.image_path = p_name and public.can_view_character(i.character_id));
end $$;
grant execute on function public.can_read_media(text) to authenticated;

-- ---------------------------------------------------------------------
-- 5b. GRANADAS E KIT DO DEMOLIDOR
-- ---------------------------------------------------------------------
-- Kit: uma linha por tipo de granada ("kit:demolidor:granadas.fragmentacao"); a linha antiga continua válida.
alter table public.items drop constraint if exists items_kit_ref_format;
alter table public.items add constraint items_kit_ref_format check (kit_ref is null or kit_ref ~ '^kit:[a-z_]+:[a-z_]+(\.[a-z_]+)?$');

-- Idempotência de uso de itens em combate: o mesmo clique nunca consome duas vezes.
create table if not exists public.item_uses (
  request_id uuid primary key,
  item_id uuid references public.items (id) on delete set null,
  created_by uuid references auth.users (id) on delete set null,
  result jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);
alter table public.item_uses enable row level security;
drop policy if exists item_uses_select on public.item_uses;
create policy item_uses_select on public.item_uses for select to authenticated using (created_by = auth.uid());
revoke insert, update, delete on public.item_uses from authenticated, anon;
grant select on public.item_uses to authenticated;

-- Lança uma granada no combate: desconta 1 do inventário (atômico) e resolve um confronto por alvo
-- (Pontaria do lançador × Reflexo do alvo, rolado aqui). Fumaça não tem alvo: cria cobertura em quem lançou.
create or replace function public.combat_use_grenade(p_combat uuid, p_attacker uuid, p_item uuid, p_targets uuid[], p_request uuid)
returns jsonb
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  cb public.combats;
  att public.combatants;
  it public.items;
  g jsonb;
  done public.item_uses;
  is_master boolean;
  t uuid;
  n int := 0;
  results jsonb := '[]'::jsonb;
  cond jsonb;
  r jsonb;
  out jsonb;
begin
  select * into done from public.item_uses where request_id = p_request;
  if done.request_id is not null then
    return done.result || jsonb_build_object('duplicate', true);
  end if;
  select * into cb from public.combats where id = p_combat;
  select * into att from public.combatants where id = p_attacker and combat_id = p_combat;
  if cb.id is null or att.id is null or att.character_id is null then
    raise exception 'Combate ou lançador inválido.';
  end if;
  if cb.status <> 'active' then
    raise exception 'O combate não está em andamento.';
  end if;
  is_master := public.is_campaign_master(cb.campaign_id);
  if not (public.owns_character(att.character_id) or (is_master and public.can_edit_character(att.character_id))) then
    raise exception 'Você só lança granadas do seu personagem.';
  end if;
  select * into it from public.items where id = p_item and character_id = att.character_id for update;
  g := cfg -> 'grenades' -> coalesce(it.source_ref, '');
  if it.id is null or g is null then
    raise exception 'Este item não é uma granada.';
  end if;
  if it.quantity <= 0 then
    raise exception 'Sem granadas deste tipo.';
  end if;
  if coalesce(array_length(p_targets, 1), 0) > 12 then
    raise exception 'Alvos demais.';
  end if;
  if g ->> 'damage' is not null and coalesce(array_length(p_targets, 1), 0) = 0 then
    raise exception 'Escolha ao menos um alvo na área.';
  end if;
  update public.items set quantity = quantity - 1 where id = it.id returning * into it;
  cond := g -> 'condition';

  if g ->> 'damage' is not null then
    foreach t in array p_targets loop
      n := n + 1;
      r := public.combat_confront(p_combat, p_attacker, t,
        jsonb_build_object('label', g ->> 'name', 'skill', 'pontaria', 'attack_kind', 'ranged', 'damage', g ->> 'damage',
          'conditions', case when cond is not null and cond ->> 'target' = 'alvo'
                             then jsonb_build_array(cond || jsonb_build_object('automatic', coalesce((cond ->> 'automatic')::boolean, true))) else '[]'::jsonb end),
        'reflexo', md5(p_request::text || ':' || t::text)::uuid, is_master, true);
      results := results || jsonb_build_array(r);
    end loop;
  end if;
  -- Efeito em quem lançou (ex.: cobertura de fumaça).
  if cond is not null and cond ->> 'target' = 'lancador' then
    perform public.combatant_add_conditions(att.id, jsonb_build_array(cond));
    perform public.combat_log_add(p_combat, 'efeito', format('%s usa %s: %s (%s turnos).', att.name, g ->> 'name', cond ->> 'name', cond ->> 'turns'), '{}'::jsonb, not att.hidden);
  end if;
  update public.combats set version = version + 1, updated_at = now() where id = p_combat;
  out := jsonb_build_object('grenade', g ->> 'name', 'item', it.id, 'quantity', it.quantity, 'confronts', results, 'self_condition',
    case when cond ->> 'target' = 'lancador' then cond else null end);
  insert into public.item_uses (request_id, item_id, created_by, result) values (p_request, it.id, auth.uid(), out);
  return out || jsonb_build_object('duplicate', false);
end $$;
revoke execute on function public.combat_use_grenade(uuid, uuid, uuid, uuid[], uuid) from public, anon;
grant execute on function public.combat_use_grenade(uuid, uuid, uuid, uuid[], uuid) to authenticated;

-- ---------------------------------------------------------------------
-- 6. Realtime
-- ---------------------------------------------------------------------
do $$
begin
  if exists (select 1 from pg_publication where pubname = 'supabase_realtime')
     and not exists (select 1 from pg_publication_tables where pubname = 'supabase_realtime' and schemaname = 'public' and tablename = 'combat_confrontations') then
    alter publication supabase_realtime add table public.combat_confrontations;
  end if;
end $$;

grant execute on function public.classify_d100(int, int, int), public.confront_outcome(int, int, int, int, boolean, boolean, int), public.outcome_label(text) to authenticated;


-- =====================================================================
-- >>> 20261028000000_rules_sync_v6_1.sql
-- =====================================================================
-- =====================================================================
-- GERADO AUTOMATICAMENTE por scripts/generate-rules-sql.ts — NÃO EDITE.
-- Espelha src/rules (versão livro-1.0+site-2026.10-v6.1) para que o banco valide
-- e role dados com as MESMAS regras do motor.
-- Seguro para reaplicar (somente create or replace / drop trigger if exists).
-- =====================================================================

create or replace function public.rules_config() returns jsonb
language sql immutable
as $rules$
  select '{
  "version": "livro-1.0+site-2026.10-v6.1",
  "attributeRoll": {
    "dicePerRoll": 3,
    "sides": 6,
    "multiplier": 5,
    "rollsPerSet": 3
  },
  "pvFormula": "sum_div3",
  "abilities": {
    "base": 2,
    "perEvenLevel": 1,
    "blockLevelUpWhenPending": true,
    "originModes": {
      "muto": "none",
      "elo": "free"
    },
    "pathOverrides": {
      "prodigio:arsenal": {
        "base": 0,
        "perEvenLevel": 1
      },
      "prodigio:engrenagem": {
        "base": 1,
        "perEvenLevel": 1
      }
    }
  },
  "prodigioPowers": {
    "noPcCost": true,
    "noLimits": true,
    "allowNoEffects": true
  },
  "levels": {
    "min": 1,
    "max": 20
  },
  "attributes": [
    "FOR",
    "DEX",
    "INT",
    "CON",
    "MIT",
    "PER",
    "CAR",
    "VIG"
  ],
  "skills": [
    "luta",
    "reflexo",
    "conhecimento_belico",
    "arma_de_fogo",
    "pontaria",
    "investigacao",
    "enganacao",
    "furtividade",
    "pilotagem",
    "intuicao"
  ],
  "skillDefs": {
    "luta": {
      "kind": "attribute",
      "attribute": "FOR",
      "divisor": 2
    },
    "reflexo": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "conhecimento_belico": {
      "kind": "attribute",
      "attribute": "INT",
      "divisor": 2
    },
    "arma_de_fogo": {
      "kind": "fixed",
      "value": 20
    },
    "pontaria": {
      "kind": "attribute",
      "attribute": "DEX",
      "divisor": 2
    },
    "investigacao": {
      "kind": "fixed",
      "value": 20
    },
    "enganacao": {
      "kind": "fixed",
      "value": 15
    },
    "furtividade": {
      "kind": "fixed",
      "value": 20
    },
    "pilotagem": {
      "kind": "fixed",
      "value": 5
    },
    "intuicao": {
      "kind": "fixed",
      "value": 10
    }
  },
  "skillDistribution": {
    "skillsToChoose": 4,
    "totalPoints": 150,
    "maxSkillTotal": 75
  },
  "classes": {
    "brawler": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "FOR": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "demolidor": {
      "pv": "1d10",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {
        "DEX": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "detalhista": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {
        "PER": 4
      },
      "skillBonus": {},
      "maxSkillTotal": 95,
      "skillPointsBonus": 50,
      "pvBonusAtLevel1": 0
    },
    "esoterico": {
      "pv": "1d6",
      "pc": "1d12",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "attributeBonus": {
        "MIT": 4
      },
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "atirador": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "arma_de_fogo": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "rato": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {
        "furtividade": 25
      },
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "healer": {
      "pv": "1d6",
      "pc": "1d10",
      "pvDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 10,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    },
    "tank": {
      "pv": "1d12",
      "pc": "1d6",
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 6,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 20
    },
    "lider": {
      "pv": "1d8",
      "pc": "1d8",
      "pvDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "pcDice": {
        "count": 1,
        "sides": 8,
        "bonus": 0
      },
      "attributeBonus": {},
      "skillBonus": {},
      "maxSkillTotal": null,
      "skillPointsBonus": 0,
      "pvBonusAtLevel1": 0
    }
  },
  "origins": {
    "filho_de_lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "receptaculo": {
      "paths": [],
      "secondarySheet": false
    },
    "artificial": {
      "paths": [],
      "secondarySheet": true
    },
    "muto": {
      "paths": [],
      "secondarySheet": false
    },
    "elo": {
      "paths": [],
      "secondarySheet": false
    },
    "amaldicoado": {
      "paths": [],
      "secondarySheet": false
    },
    "remanescente": {
      "paths": [],
      "secondarySheet": false
    },
    "lenda": {
      "paths": [],
      "secondarySheet": false
    },
    "prodigio": {
      "paths": [
        "arsenal",
        "engrenagem",
        "pacto"
      ],
      "secondarySheet": false
    }
  },
  "progressionOverrides": {
    "prodigio": {
      "pv": "1d12+2",
      "pc": null,
      "pvDice": {
        "count": 1,
        "sides": 12,
        "bonus": 2
      },
      "pcDice": null
    }
  },
  "weaponModifiers": {
    "afiada": "laminas",
    "perfurante": "perfurantes_projeteis",
    "serrilhada": "laminas",
    "precisa": "distancia",
    "equilibrada": "corpo_a_corpo",
    "pesada": "pesadas",
    "brutal": "pesadas",
    "concussiva": "contundentes",
    "gancho": "foices_correntes",
    "executora": "corpo_a_corpo",
    "rajada": "arma_de_fogo",
    "automatica": "arma_de_fogo",
    "curto_alcance": "arma_de_fogo",
    "mira_precisao": "arma_de_fogo",
    "recuo_pesado": "arma_de_fogo",
    "dispersao": "arma_de_fogo",
    "penetrante": "arma_de_fogo",
    "confiavel": "arma_de_fogo"
  },
  "techniques": {
    "arte_desarme": {
      "name": "Arte do Desarme",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "arte_contra_ataque": {
      "name": "Arte do Contra-ataque",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "provocacao": {
      "name": "Provocação",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_alvos": {
      "name": "Múltiplos Alvos",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": null
    },
    "multiplos_golpes": {
      "name": "Múltiplos Golpes",
      "usage": {
        "kind": "a_cada_turnos",
        "turns": 2
      },
      "requires": {},
      "special": null
    },
    "adrenalina": {
      "name": "Adrenalina",
      "usage": {
        "kind": "acao",
        "action": "Ação de movimento"
      },
      "requires": {},
      "special": "recarregar_cena"
    },
    "metavisao": {
      "name": "Metavisão",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {},
      "special": "esquiva_rodada"
    },
    "recobrar_se": {
      "name": "Recobrar-se",
      "usage": {
        "kind": "por_sessao",
        "times": 1
      },
      "requires": {},
      "special": "recobrar"
    },
    "passos_leves": {
      "name": "Passos Leves",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "ataque_furtivo": {
      "name": "Ataque Furtivo",
      "usage": {
        "kind": "passiva"
      },
      "requires": {},
      "special": null
    },
    "furtividade_rapida": {
      "name": "Furtividade Rápida",
      "usage": {
        "kind": "por_cena",
        "times": 1
      },
      "requires": {
        "attributes": {
          "DEX": 70
        },
        "techniques": [
          "passos_leves"
        ]
      },
      "special": null
    }
  },
  "maxWeaponModifiers": 2,
  "grenades": {
    "granada_fragmentacao": {
      "name": "Granada de Fragmentação",
      "damage": "3d8",
      "area": "Área pequena",
      "condition": null
    },
    "granada_incendiaria": {
      "name": "Granada Incendiária",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Em chamas",
        "turns": 2,
        "dot": "1d6",
        "automatic": true,
        "target": "alvo"
      }
    },
    "granada_concussao": {
      "name": "Granada de Concussão",
      "damage": "2d6",
      "area": "Área pequena",
      "condition": {
        "name": "Atordoado",
        "turns": 1,
        "automatic": false,
        "target": "alvo"
      }
    },
    "granada_explosiva_pesada": {
      "name": "Granada Explosiva Pesada",
      "damage": "5d8",
      "area": "Área média",
      "condition": null
    },
    "granada_fumaca": {
      "name": "Granada de Fumaça",
      "damage": null,
      "area": "Área pequena",
      "condition": {
        "name": "Cobertura de fumaça",
        "turns": 3,
        "automatic": true,
        "target": "lancador"
      }
    }
  },
  "thresholds": {
    "goodDivisor": 2,
    "extremeDivisor": 5,
    "rounding": "floor"
  },
  "damageMultiplier": {
    "extreme": 1.5,
    "critical": 2
  },
  "damageRounding": "none",
  "attackSkill": {
    "melee": "luta",
    "ranged": "pontaria",
    "firearm": "arma_de_fogo"
  },
  "opposed": {
    "winner": "lower",
    "tiePlayerWins": true,
    "maxRerolls": 10,
    "defaultReaction": {
      "melee": "luta",
      "ranged": "reflexo",
      "firearm": "reflexo"
    },
    "appliedRounding": "floor"
  },
  "powers": {
    "damageSingle": [
      3,
      6,
      9,
      12,
      15
    ],
    "damageArea": [
      6,
      9,
      12,
      15,
      18
    ],
    "areaSizes": {
      "pequena": 0,
      "media": 3,
      "grande": 6,
      "enorme": 9
    },
    "extraDieCost": 3,
    "heal": [
      3,
      6,
      9,
      12,
      15
    ],
    "healArea": {
      "alvo": 0,
      "pequena": 6,
      "media": 9,
      "grande": 12,
      "enorme": 15
    },
    "healContinuous": [
      2,
      3,
      4,
      5,
      6
    ],
    "shield": [
      3,
      6,
      9,
      12,
      15
    ],
    "shieldDuration": {
      "1t": 0,
      "2t": 2,
      "3t": 4,
      "cena": 6
    },
    "conditions": {
      "leve": {
        "initial": 3,
        "perTurn": 1
      },
      "moderada": {
        "initial": 6,
        "perTurn": 2
      },
      "forte": {
        "initial": 9,
        "perTurn": 3
      },
      "severa": {
        "initial": 12,
        "perTurn": 4
      },
      "extrema": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "buffs": {
      "teste_1": {
        "initial": 3,
        "perTurn": 1
      },
      "teste_2": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_1": {
        "initial": 6,
        "perTurn": 2
      },
      "dano_2": {
        "initial": 9,
        "perTurn": 3
      },
      "acao": {
        "initial": 12,
        "perTurn": 4
      },
      "grande": {
        "initial": 15,
        "perTurn": 5
      }
    },
    "levelTable": [
      {
        "level": 1,
        "maxPc": 15,
        "maxExtraDice": 1
      },
      {
        "level": 2,
        "maxPc": 18,
        "maxExtraDice": 1
      },
      {
        "level": 4,
        "maxPc": 24,
        "maxExtraDice": 2
      },
      {
        "level": 6,
        "maxPc": 30,
        "maxExtraDice": 3
      },
      {
        "level": 8,
        "maxPc": 36,
        "maxExtraDice": 4
      },
      {
        "level": 10,
        "maxPc": 42,
        "maxExtraDice": 5
      },
      {
        "level": 15,
        "maxPc": 57,
        "maxExtraDice": 7
      },
      {
        "level": 20,
        "maxPc": 72,
        "maxExtraDice": 10
      }
    ],
    "limitMode": "linear",
    "perTurnCountsTowardLimit": false,
    "amaldicoadoRounding": "ceil",
    "amaldicoadoLimitUsesFullCost": true
  }
}'::jsonb
$rules$;

-- Rolagem de atributos usando a configuração do motor.
create or replace function public.roll_attribute_set(p_form uuid) returns public.attribute_rolls
language plpgsql security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'attributeRoll';
  n_rolls int := (cfg ->> 'rollsPerSet')::int;
  n_dice int := (cfg ->> 'dicePerRoll')::int;
  sides int := (cfg ->> 'sides')::int;
  mult int := (cfg ->> 'multiplier')::int;
  r public.attribute_rolls;
  faces int[] := '{}';
  results int[] := '{}';
  i int;
  f int;
  s int;
begin
  if not public.owns_character(public.form_character(p_form)) then
    raise exception 'Sem permissão.';
  end if;
  perform 1 from public.character_forms where id = p_form for update;
  select * into r from public.attribute_rolls where form_id = p_form and assigned_attribute is null;
  if found then
    return r;
  end if;
  if (select count(*) from public.form_attributes where form_id = p_form and base_value is not null)
     >= jsonb_array_length(public.rules_config() -> 'attributes') then
    raise exception 'Todos os atributos já foram definidos.';
  end if;
  for i in 1..n_rolls loop
    s := 0;
    for f in 1..n_dice loop
      faces := faces || public.roll_die(sides);
      s := s + faces[array_length(faces, 1)];
    end loop;
    results := results || (s * mult);
  end loop;
  insert into public.attribute_rolls (form_id, faces, results, best)
  values (p_form, faces, results, (select max(x) from unnest(results) x))
  returning * into r;
  return r;
end $$;

-- Valida identificadores de regra gravados no banco.
create or replace function public.validate_character_rules() returns trigger
language plpgsql as $$
declare
  cfg jsonb := public.rules_config();
begin
  if new.class_id is not null and not (cfg -> 'classes') ? new.class_id then
    raise exception 'Classe inválida: %', new.class_id;
  end if;
  if new.origin_id is not null and not (cfg -> 'origins') ? new.origin_id then
    raise exception 'Origem inválida: %', new.origin_id;
  end if;
  if new.origin_path_id is not null and (
       new.origin_id is null
       or not (cfg -> 'origins' -> new.origin_id -> 'paths') ? new.origin_path_id) then
    raise exception 'Caminho inválido para a origem.';
  end if;
  if new.level < (cfg -> 'levels' ->> 'min')::int or new.level > (cfg -> 'levels' ->> 'max')::int then
    raise exception 'Nível fora do intervalo.';
  end if;
  return new;
end $$;

drop trigger if exists characters_validate_rules on public.characters;
create trigger characters_validate_rules before insert or update on public.characters
  for each row execute function public.validate_character_rules();

-- ---------------------------------------------------------------------
-- Limite TOTAL de perícia: base permanente + pontos + classe + outros <= 75
-- (Detalhista 95; forma Lenda não usa a classe). Mesma conta do motor.
-- ---------------------------------------------------------------------
create or replace function public.skill_fixed_part(p_form uuid, p_skill text) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  def jsonb := cfg -> 'skillDefs' -> p_skill;
  f record;
  cls jsonb;
  attr int;
begin
  select cf.kind, c.class_id into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  if def ->> 'kind' = 'fixed' then
    attr := (def ->> 'value')::int;
  else
    select coalesce(fa.base_value, 0) + fa.other_bonus into attr
    from public.form_attributes fa where fa.form_id = p_form and fa.attribute = def ->> 'attribute';
    attr := coalesce(attr, 0) + coalesce((cls -> 'attributeBonus' ->> (def ->> 'attribute'))::int, 0);
    attr := floor(attr::numeric / (def ->> 'divisor')::numeric)::int;
  end if;
  return attr + coalesce((cls -> 'skillBonus' ->> p_skill)::int, 0);
end $$;

create or replace function public.skill_cap(p_form uuid) returns int
language sql stable security definer set search_path = public as $$
  select coalesce(
    case when cf.kind = 'base' then (public.rules_config() -> 'classes' -> c.class_id ->> 'maxSkillTotal')::int end,
    (public.rules_config() -> 'skillDistribution' ->> 'maxSkillTotal')::int)
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
$$;

create or replace function public.validate_form_skill() returns trigger
language plpgsql as $$
declare
  fixed int;
  cap int;
  new_total int;
  old_total int;
begin
  if not (public.rules_config() -> 'skills') ? new.skill_id then
    raise exception 'Perícia inválida: %', new.skill_id;
  end if;
  fixed := public.skill_fixed_part(new.form_id, new.skill_id);
  cap := public.skill_cap(new.form_id);
  new_total := fixed + new.points + new.other_bonus;
  if new_total <= cap then
    return new;
  end if;
  -- Acima do limite: só aceito se não aumentar o que já estava gravado (corrigir dados antigos).
  if tg_op = 'UPDATE' then
    old_total := fixed + old.points + old.other_bonus;
  else
    select fixed + fs.points + fs.other_bonus into old_total
    from public.form_skills fs where fs.form_id = new.form_id and fs.skill_id = new.skill_id;
  end if;
  if old_total is not null and new_total <= old_total then
    return new;
  end if;
  raise exception 'Perícia acima do limite: total % (máximo %).', new_total, cap;
end $$;

drop trigger if exists form_skills_validate on public.form_skills;
create trigger form_skills_validate before insert or update on public.form_skills
  for each row execute function public.validate_form_skill();

-- ---------------------------------------------------------------------
-- PV máximo da forma — mesma conta do motor (buildSheet):
-- (FOR + CON) ÷ 3 para baixo + bônus de classe + ganhos de nível ativos + outros bônus.
-- ---------------------------------------------------------------------
create or replace function public.form_pv_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  str int;
  con int;
  base int;
  gains int;
begin
  select cf.id, cf.kind, cf.pv_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into str
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'FOR';
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into con
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'CON';
  str := coalesce(str, 0) + coalesce((cls -> 'attributeBonus' ->> 'FOR')::int, 0);
  con := coalesce(con, 0) + coalesce((cls -> 'attributeBonus' ->> 'CON')::int, 0);
  if cfg ->> 'pvFormula' = 'sum_div3' then
    base := floor((str + con)::numeric / 3)::int;
  else
    base := str + floor(con::numeric / 3)::int;
  end if;
  base := base + coalesce((cls ->> 'pvBonusAtLevel1')::int, 0);
  select coalesce(sum(lp.pv_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, base + gains + f.pv_other_bonus);
end $$;

-- PC máximo da forma — mesma conta do motor: VIG ÷ 3 para baixo + ganhos de nível ativos + outros bônus.
create or replace function public.form_pc_max(p_form uuid) returns int
language plpgsql stable security definer set search_path = public as $$
declare
  cfg jsonb := public.rules_config();
  f record;
  cls jsonb;
  vig int;
  gains int;
begin
  select cf.id, cf.kind, cf.pc_other_bonus, c.class_id, c.level into f
  from public.character_forms cf join public.characters c on c.id = cf.character_id
  where cf.id = p_form;
  if f.id is null then
    return null;
  end if;
  cls := case when f.kind = 'base' and f.class_id is not null then cfg -> 'classes' -> f.class_id end;
  select coalesce(fa.base_value, 0) + fa.other_bonus + fa.temp_bonus into vig
  from public.form_attributes fa where fa.form_id = p_form and fa.attribute = 'VIG';
  vig := coalesce(vig, 0) + coalesce((cls -> 'attributeBonus' ->> 'VIG')::int, 0);
  select coalesce(sum(lp.pc_gain), 0) into gains
  from public.level_progressions lp where lp.form_id = p_form and lp.level between 2 and f.level;
  return greatest(0, floor(vig::numeric / 3)::int + gains + f.pc_other_bonus);
end $$;

-- ---------------------------------------------------------------------
-- Vagas de habilidades — mesma conta do motor (abilities.ts).
-- mode: standard | free (Elo) | none (Muto). Executa com as permissões de quem chama.
-- ---------------------------------------------------------------------
create or replace function public.ability_granted(p_origin text, p_path text, p_level int) returns int
language plpgsql immutable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ov jsonb := cfg -> 'pathOverrides' -> (p_origin || ':' || p_path);
begin
  if coalesce(cfg -> 'originModes' ->> p_origin, 'standard') <> 'standard' then
    return 0;
  end if;
  return coalesce((ov ->> 'base')::int, (cfg ->> 'base')::int)
       + coalesce((ov ->> 'perEvenLevel')::int, (cfg ->> 'perEvenLevel')::int) * (greatest(p_level, 1) / 2);
end $$;

create or replace function public.ability_status(p_character uuid) returns jsonb
language plpgsql stable set search_path = public as $$
declare
  cfg jsonb := public.rules_config() -> 'abilities';
  ch record;
  created int;
begin
  select level, origin_id, origin_path_id into ch from public.characters where id = p_character;
  -- Técnicas oficiais do Arsenal e poderes criados ocupam o mesmo conjunto de vagas (sem consumo duplicado).
  select (select count(*) from public.powers where character_id = p_character)
       + (select count(*) from public.character_techniques where character_id = p_character)
    into created;
  return jsonb_build_object(
    'mode', coalesce(cfg -> 'originModes' ->> ch.origin_id, 'standard'),
    'granted', public.ability_granted(ch.origin_id, ch.origin_path_id, ch.level),
    'created', created,
    'level', ch.level);
end $$;

grant execute on function public.rules_config() to authenticated;
grant execute on function public.form_pv_max(uuid), public.form_pc_max(uuid), public.ability_granted(text, text, int), public.ability_status(uuid) to authenticated;
grant execute on function public.roll_attribute_set(uuid) to authenticated;
grant execute on function public.skill_fixed_part(uuid, text), public.skill_cap(uuid) to authenticated;


-- =====================================================================
-- >>> 20261028000100_v6_1_menor_vence.sql
-- =====================================================================
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
