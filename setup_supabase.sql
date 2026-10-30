-- Safar Sherzad shop: run in Supabase SQL Editor after project is created.
create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  price bigint not null check (price > 0),
  description text not null default '',
  image_url text,
  badge text,
  active boolean not null default true,
  created_at timestamptz not null default now()
);
create table if not exists public.store_admins (user_id uuid primary key references auth.users(id) on delete cascade);
alter table public.products enable row level security;
alter table public.store_admins enable row level security;
grant select on public.products to anon, authenticated;
grant insert, update, delete on public.products to authenticated;
revoke all on public.store_admins from anon, authenticated;
create or replace function public.is_store_admin() returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.store_admins a where a.user_id = (select auth.uid()));
$$;
revoke all on function public.is_store_admin() from public;
grant execute on function public.is_store_admin() to authenticated;
drop policy if exists "active products are public" on public.products;
create policy "active products are public" on public.products for select to anon, authenticated using (active = true);
drop policy if exists "store admins can see all products" on public.products;
create policy "store admins can see all products" on public.products for select to authenticated using (public.is_store_admin());
drop policy if exists "store admins can insert products" on public.products;
create policy "store admins can insert products" on public.products for insert to authenticated with check (public.is_store_admin());
drop policy if exists "store admins can update products" on public.products;
create policy "store admins can update products" on public.products for update to authenticated using (public.is_store_admin()) with check (public.is_store_admin());
drop policy if exists "store admins can delete products" on public.products;
create policy "store admins can delete products" on public.products for delete to authenticated using (public.is_store_admin());
-- After creating the owner in Authentication > Users, run this to grant owner access:
insert into public.store_admins (user_id) select id from auth.users where email = 'safarsherzad974@gmail.com' on conflict (user_id) do nothing;

-- Run this once in Supabase SQL Editor to enable product image uploads.
insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do update set public = excluded.public;

drop policy if exists "product images are public to view" on storage.objects;
create policy "product images are public to view"
on storage.objects for select to anon, authenticated
using (bucket_id = 'product-images');

drop policy if exists "store admins upload product images" on storage.objects;
create policy "store admins upload product images"
on storage.objects for insert to authenticated
with check (bucket_id = 'product-images' and public.is_store_admin());

drop policy if exists "store admins update product images" on storage.objects;
create policy "store admins update product images"
on storage.objects for update to authenticated
using (bucket_id = 'product-images' and public.is_store_admin())
with check (bucket_id = 'product-images' and public.is_store_admin());

drop policy if exists "store admins delete product images" on storage.objects;
create policy "store admins delete product images"
on storage.objects for delete to authenticated
using (bucket_id = 'product-images' and public.is_store_admin());
