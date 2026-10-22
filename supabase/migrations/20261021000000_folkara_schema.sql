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
