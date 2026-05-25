create extension if not exists pgcrypto with schema extensions;

create table public.profiles (
  id uuid primary key references auth.users (id) on delete cascade,
  email text not null unique,
  display_name text,
  role text not null default 'admin' check (role = 'admin'),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table public.categories (
  id uuid primary key default gen_random_uuid(),
  parent_id uuid references public.categories (id) on delete set null,
  slug text not null unique,
  kind text not null check (kind in ('parasha', 'holiday', 'custom')),
  name_de text not null,
  name_en text not null,
  name_he text not null,
  sort_order integer not null default 0,
  is_active boolean not null default true,
  created_by uuid references public.profiles (id) on delete set null,
  updated_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index categories_parent_id_idx on public.categories (parent_id);
create index categories_is_active_idx on public.categories (is_active);

create table public.content_items (
  id uuid primary key default gen_random_uuid(),
  category_id uuid not null references public.categories (id) on delete restrict,
  slug text not null unique,
  title_de text not null,
  title_en text,
  title_he text,
  year integer check (year between 0 and 9999),
  publication_date date,
  is_current boolean not null default false,
  is_published boolean not null default false,
  created_by uuid not null references public.profiles (id) on delete restrict,
  updated_by uuid references public.profiles (id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index content_items_category_id_idx on public.content_items (category_id);
create index content_items_published_deleted_idx on public.content_items (is_published, deleted_at);
create unique index content_items_one_current_idx
  on public.content_items (is_current)
  where is_current and deleted_at is null;

create table public.pdf_assets (
  id uuid primary key default gen_random_uuid(),
  content_item_id uuid not null references public.content_items (id) on delete cascade,
  language_code text not null check (language_code in ('de', 'en', 'he')),
  file_path text not null,
  original_filename text not null,
  file_size bigint not null check (file_size >= 0),
  mime_type text not null,
  uploaded_by uuid not null references public.profiles (id) on delete restrict,
  uploaded_at timestamptz not null default now(),
  deleted_at timestamptz
);

create index pdf_assets_content_item_id_idx on public.pdf_assets (content_item_id);
create index pdf_assets_deleted_at_idx on public.pdf_assets (deleted_at);
create unique index pdf_assets_one_active_language_per_item_idx
  on public.pdf_assets (content_item_id, language_code)
  where deleted_at is null;

create table public.admin_activity_log (
  id bigint generated always as identity primary key,
  admin_id uuid not null references public.profiles (id) on delete restrict,
  action text not null,
  entity_type text not null,
  entity_id uuid,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

create index admin_activity_log_admin_id_idx on public.admin_activity_log (admin_id);
create index admin_activity_log_entity_idx on public.admin_activity_log (entity_type, entity_id);
create index admin_activity_log_created_at_idx on public.admin_activity_log (created_at desc);

create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger profiles_set_updated_at
before update on public.profiles
for each row
execute function public.set_updated_at();

create trigger categories_set_updated_at
before update on public.categories
for each row
execute function public.set_updated_at();

create trigger content_items_set_updated_at
before update on public.content_items
for each row
execute function public.set_updated_at();

create or replace function public.is_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.profiles p
    where p.id = auth.uid()
      and p.role = 'admin'
  );
$$;

revoke execute on function public.is_admin() from public, anon;
grant execute on function public.is_admin() to authenticated;

grant select on public.categories to anon, authenticated;
grant select on public.content_items to anon, authenticated;
grant select on public.pdf_assets to anon, authenticated;
grant select on public.admin_activity_log to authenticated;
grant insert, update, delete on public.categories to authenticated;
grant insert, update, delete on public.content_items to authenticated;
grant insert, update, delete on public.pdf_assets to authenticated;
grant insert on public.admin_activity_log to authenticated;
grant usage, select on sequence public.admin_activity_log_id_seq to authenticated;

grant select on public.profiles to authenticated;
grant insert, update, delete on public.profiles to authenticated;

alter table public.profiles enable row level security;
alter table public.categories enable row level security;
alter table public.content_items enable row level security;
alter table public.pdf_assets enable row level security;
alter table public.admin_activity_log enable row level security;

create policy "profiles_select_own"
  on public.profiles
  for select
  to authenticated
  using (id = auth.uid());

create policy "profiles_admin_manage"
  on public.profiles
  for all
  to authenticated
  using ((select public.is_admin()))
  with check ((select public.is_admin()));

create policy "categories_public_read_active"
  on public.categories
  for select
  to anon, authenticated
  using (is_active);

create policy "categories_admin_manage"
  on public.categories
  for all
  to authenticated
  using ((select public.is_admin()))
  with check ((select public.is_admin()));

create policy "content_items_public_read_published"
  on public.content_items
  for select
  to anon, authenticated
  using (is_published and deleted_at is null);

create policy "content_items_admin_manage"
  on public.content_items
  for all
  to authenticated
  using ((select public.is_admin()))
  with check ((select public.is_admin()));

create policy "pdf_assets_public_read_published_items"
  on public.pdf_assets
  for select
  to anon, authenticated
  using (
    deleted_at is null
    and exists (
      select 1
      from public.content_items ci
      where ci.id = content_item_id
        and ci.is_published
        and ci.deleted_at is null
    )
  );

create policy "pdf_assets_admin_manage"
  on public.pdf_assets
  for all
  to authenticated
  using ((select public.is_admin()))
  with check ((select public.is_admin()));

create policy "admin_activity_log_admin_read"
  on public.admin_activity_log
  for select
  to authenticated
  using ((select public.is_admin()));

create policy "admin_activity_log_admin_insert"
  on public.admin_activity_log
  for insert
  to authenticated
  with check ((select public.is_admin()));
