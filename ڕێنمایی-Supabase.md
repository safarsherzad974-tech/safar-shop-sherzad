# ڕێکخستنی Supabase بۆ فرۆشگای Safar Sherzad

1. لە Supabase Dashboard، SQL Editor → New query بکەرەوە.
2. ناوەڕۆکی setup_supabase.sql لەم فۆڵدەرە کۆپی بکە، پاشان Run بکە. خشتەی بەرهەم و یاساکانی RLS دروست دەکات.
3. بچۆ Authentication → Users → Add user. بە ئیمەیڵی safarsherzad974@gmail.com هەژماری خاوەن دروست بکە و وشەی نهێنییەکی بەهێز دابنێ.
4. دووبارە SQL Editor → New query بکەرەوە و ئەم SQL ـە Run بکە:

```sql
insert into public.store_admins (user_id)
select id from auth.users where email = 'safarsherzad974@gmail.com'
on conflict (user_id) do nothing;
```

5. SQL ـی فایل setup_storage.sql لە SQL Editor جێبەجێ بکە تا بارکردنی وێنەکان چالاک بێت.
6. وێبسایتەکە لە هۆستێکی HTTPS بڵاو بکەرەوە؛ پەڕگەی file:// تەنها لە ئامێری خۆت کار دەکات.
7. پەڕەکە بکەرەوە، بەشی خاوەن هەڵبژێرە و بە ئیمەیڵ و وشەی نهێنیی Auth بچۆ ژوورەوە. لە خانەی وێنە، فایلێکی وێنە لە ئامێرەکەت هەڵبژێرە (تا ٥MB).

فرۆشگا بە URL و Publishable key ـی پڕۆژەکەت پەیوەستە. کلیلێکی secret یان service_role لە وێبسایت مەخە.

پارەدان: ڕێگاکان لە پەڕەکە پیشان دەدرێن و داواکاری بە واتسئاپ دەنێردرێت. بۆ وەرگرتنی ئۆنلاین، هەژماری merchant و payment gateway پێویستن.
