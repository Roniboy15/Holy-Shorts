insert into public.categories (
  parent_id,
  slug,
  kind,
  name_de,
  name_en,
  name_he,
  sort_order,
  is_active
)
values
  (null, 'bereshit', 'parasha', 'Bereshit', 'Bereshit', 'Bereshit', 10, true),
  (null, 'shemot', 'parasha', 'Shemot', 'Shemot', 'Shemot', 20, true),
  (null, 'vayikra', 'parasha', 'Vayikra', 'Vayikra', 'Vayikra', 30, true),
  (null, 'bamidbar', 'parasha', 'Bamidbar', 'Bamidbar', 'Bamidbar', 40, true),
  (null, 'devarim', 'parasha', 'Devarim', 'Devarim', 'Devarim', 50, true),
  (null, 'feiertage', 'holiday', 'Feiertage', 'Holidays', 'Hagim', 60, true)
on conflict (slug) do update
set
  kind = excluded.kind,
  name_de = excluded.name_de,
  name_en = excluded.name_en,
  name_he = excluded.name_he,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active;

insert into public.categories (
  parent_id,
  slug,
  kind,
  name_de,
  name_en,
  name_he,
  sort_order,
  is_active
)
values
  ((select id from public.categories where slug = 'feiertage'), 'pesach', 'holiday', 'Pesach', 'Passover', 'Pesach', 610, true),
  ((select id from public.categories where slug = 'feiertage'), 'shavuot', 'holiday', 'Shavuot', 'Shavuot', 'Shavuot', 620, true),
  ((select id from public.categories where slug = 'feiertage'), 'sukkot', 'holiday', 'Sukkot', 'Sukkot', 'Sukkot', 630, true),
  ((select id from public.categories where slug = 'feiertage'), 'rosh-hashana', 'holiday', 'Rosh Hashana', 'Rosh Hashanah', 'Rosh Hashana', 640, true),
  ((select id from public.categories where slug = 'feiertage'), 'yom-kippur', 'holiday', 'Yom Kippur', 'Yom Kippur', 'Yom Kippur', 650, true),
  ((select id from public.categories where slug = 'feiertage'), 'chanukka', 'holiday', 'Chanukka', 'Hanukkah', 'Chanukka', 660, true),
  ((select id from public.categories where slug = 'feiertage'), 'purim', 'holiday', 'Purim', 'Purim', 'Purim', 670, true)
on conflict (slug) do update
set
  parent_id = excluded.parent_id,
  kind = excluded.kind,
  name_de = excluded.name_de,
  name_en = excluded.name_en,
  name_he = excluded.name_he,
  sort_order = excluded.sort_order,
  is_active = excluded.is_active;
