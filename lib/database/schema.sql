# TABEL SATU
-- Create table for meal plans
create table public.meal_plans (
  id uuid not null default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  day text not null, -- Senin, Selasa, dll
  recipe_id uuid, -- Bisa null jika user menulis manual nama menu tanpa relasi ID
  recipe_name text, -- Menyimpan nama menu (jika tidak ada relasi ID)
  created_at timestamptz default now(),
  constraint meal_plans_pkey primary key (id),
  constraint meal_plans_user_id_fkey foreign key (user_id) references auth.users(id) on delete cascade
  -- Optional: Foreign key ke recipes jika ingin strict relation
  -- constraint meal_plans_recipe_id_fkey foreign key (recipe_id) references public.recipes(id)
);
-- Enable RLS
alter table public.meal_plans enable row level security;
-- Policies
create policy "Users can view their own meal plans" on public.meal_plans
  for select using (auth.uid() = user_id);
create policy "Users can insert their own meal plans" on public.meal_plans
  for insert with check (auth.uid() = user_id);
create policy "Users can update their own meal plans" on public.meal_plans
  for update using (auth.uid() = user_id);
create policy "Users can delete their own meal plans" on public.meal_plans
  for delete using (auth.uid() = user_id);


# TABEL DUA
-- Create table for meal plans
create table public.meal_plans (
  id uuid not null default gen_random_uuid(),
  user_id uuid not null default auth.uid(),
  day text not null, -- Senin, Selasa, dll
  recipe_id uuid, -- Bisa null jika user menulis manual nama menu tanpa relasi ID
  recipe_name text, -- Menyimpan nama menu (jika tidak ada relasi ID)
  created_at timestamptz default now(),
  constraint meal_plans_pkey primary key (id),
  constraint meal_plans_user_id_fkey foreign key (user_id) references auth.users(id) on delete cascade
  -- Optional: Foreign key ke recipes jika ingin strict relation
  -- constraint meal_plans_recipe_id_fkey foreign key (recipe_id) references public.recipes(id)
);
-- Enable RLS
alter table public.meal_plans enable row level security;
-- Policies
create policy "Users can view their own meal plans" on public.meal_plans
  for select using (auth.uid() = user_id);
create policy "Users can insert their own meal plans" on public.meal_plans
  for insert with check (auth.uid() = user_id);
create policy "Users can update their own meal plans" on public.meal_plans
  for update using (auth.uid() = user_id);
create policy "Users can delete their own meal plans" on public.meal_plans
  for delete using (auth.uid() = user_id);