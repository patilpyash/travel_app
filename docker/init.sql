create role anon noinherit;
create role authenticated noinherit;

create extension if not exists pgcrypto;
create extension if not exists pgjwt;

create table if not exists public.profiles (
  id uuid primary key,
  email text unique,
  full_name text,
  avatar_url text,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create table if not exists public.people (
  id bigserial primary key,
  full_name text not null,
  title text,
  bio text,
  image_url text,
  created_at timestamptz default now()
);

alter table public.profiles enable row level security;
alter table public.people   enable row level security;

create policy "Public read own profile" on public.profiles
  for select using (auth.uid() = id);
create policy "Update own profile" on public.profiles
  for update using (auth.uid() = id);
create policy "Insert own profile" on public.profiles
  for insert with check (true);

create policy "Anon can read people" on public.people
  for select using (true);
create policy "Auth can write people" on public.people
  for insert with check (true);
create policy "Auth can update people" on public.people
  for update using (true);

insert into public.people (full_name, title, bio, image_url) values
 ('John Doe', 'Software Engineer', 'Likes clean code and coffee.', 'https://picsum.photos/seed/john1/600/400'),
 ('John Doe', 'Designer', 'Minimalist UI/UX nerd.', 'https://picsum.photos/seed/john2/600/400'),
 ('John Doe', 'Product Manager', 'Backlog whisperer.', 'https://picsum.photos/seed/john3/600/400');
