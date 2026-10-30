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
