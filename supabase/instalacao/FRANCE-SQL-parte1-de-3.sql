-- F.R.A.N.C.E 6.1 — INSTALAÇÃO COMPLETA — PARTE 1 DE 3 (rode as 3 em ordem)
-- Cole no Supabase: SQL Editor → New query → Run. Não apaga dados; pode ser executado de novo.
-- Arquivos incluídos, nesta ordem:
--   20261021000000_folkara_schema.sql
--   20261022000000_rules_sync.sql
--   20261022000100_phase2_character.sql
--   20261023000000_rules_sync_fase3.sql
--   20261023000100_fase3_sistemas.sql


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
