-- Fluency Sprint Supabase setup
-- Paste this into Supabase SQL Editor and run it once.

create schema if not exists extensions;
create extension if not exists pgcrypto with schema extensions;

create table if not exists public.teacher_profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.classes (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  code text not null unique,
  code_rotated_at timestamptz,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create table if not exists public.students (
  id uuid primary key default gen_random_uuid(),
  class_id uuid not null references public.classes(id) on delete cascade,
  teacher_id uuid not null references auth.users(id) on delete cascade,
  alias text not null,
  pin_hash text not null,
  student_token_hash text,
  student_token_expires_at timestamptz,
  created_at timestamptz not null default now(),
  deleted_at timestamptz
);

create unique index if not exists students_class_alias_active_idx
  on public.students (class_id, lower(alias))
  where deleted_at is null;

create table if not exists public.sessions (
  id uuid primary key default gen_random_uuid(),
  class_id uuid not null references public.classes(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  teacher_id uuid not null references auth.users(id) on delete cascade,
  student_alias text not null,
  mode text not null check (mode in ('practice', 'sprint')),
  operation text not null,
  level_id text not null,
  level_name text not null,
  tags text[] not null default '{}',
  attempted integer not null default 0,
  correct integer not null default 0,
  accuracy integer not null default 0,
  best_streak integer not null default 0,
  time_spent integer not null default 0,
  score integer not null default 0,
  created_at timestamptz not null default now()
);

create table if not exists public.mistakes (
  id uuid primary key default gen_random_uuid(),
  session_id uuid not null references public.sessions(id) on delete cascade,
  class_id uuid not null references public.classes(id) on delete cascade,
  student_id uuid not null references public.students(id) on delete cascade,
  teacher_id uuid not null references auth.users(id) on delete cascade,
  question text not null,
  student_answer text not null,
  correct_answer text not null,
  operation text not null,
  level_id text not null,
  tags text[] not null default '{}',
  recovered boolean not null default false,
  created_at timestamptz not null default now()
);

create table if not exists public.audit_log (
  id uuid primary key default gen_random_uuid(),
  teacher_id uuid references auth.users(id) on delete set null,
  action text not null,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.teacher_profiles enable row level security;
alter table public.classes enable row level security;
alter table public.students enable row level security;
alter table public.sessions enable row level security;
alter table public.mistakes enable row level security;
alter table public.audit_log enable row level security;

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on public.teacher_profiles to authenticated;
grant select, insert, update, delete on public.classes to authenticated;
grant select, insert, update, delete on public.students to authenticated;
grant select on public.sessions to authenticated;
grant select on public.mistakes to authenticated;
grant select on public.audit_log to authenticated;

drop policy if exists "teachers read own profile" on public.teacher_profiles;
create policy "teachers read own profile"
  on public.teacher_profiles for select
  to authenticated
  using (auth.uid() = id);

drop policy if exists "teachers insert own profile" on public.teacher_profiles;
create policy "teachers insert own profile"
  on public.teacher_profiles for insert
  to authenticated
  with check (auth.uid() = id);

drop policy if exists "teachers update own profile" on public.teacher_profiles;
create policy "teachers update own profile"
  on public.teacher_profiles for update
  to authenticated
  using (auth.uid() = id)
  with check (auth.uid() = id);

drop policy if exists "teachers access own classes" on public.classes;
create policy "teachers access own classes"
  on public.classes for all
  to authenticated
  using (auth.uid() = teacher_id)
  with check (auth.uid() = teacher_id);

drop policy if exists "teachers read own students" on public.students;
create policy "teachers read own students"
  on public.students for select
  to authenticated
  using (auth.uid() = teacher_id);

drop policy if exists "teachers update own students" on public.students;
create policy "teachers update own students"
  on public.students for update
  to authenticated
  using (auth.uid() = teacher_id)
  with check (auth.uid() = teacher_id);

drop policy if exists "teachers read own sessions" on public.sessions;
create policy "teachers read own sessions"
  on public.sessions for select
  to authenticated
  using (auth.uid() = teacher_id);

drop policy if exists "teachers read own mistakes" on public.mistakes;
create policy "teachers read own mistakes"
  on public.mistakes for select
  to authenticated
  using (auth.uid() = teacher_id);

drop policy if exists "teachers read own audit log" on public.audit_log;
create policy "teachers read own audit log"
  on public.audit_log for select
  to authenticated
  using (auth.uid() = teacher_id);

create or replace function public.touch_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists teacher_profiles_touch_updated_at on public.teacher_profiles;
create trigger teacher_profiles_touch_updated_at
before update on public.teacher_profiles
for each row execute function public.touch_updated_at();

create or replace function public.random_class_code()
returns text
language plpgsql
as $$
declare
  alphabet text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  code text := '';
  i integer;
begin
  for i in 1..9 loop
    code := code || substr(alphabet, 1 + floor(random() * length(alphabet))::integer, 1);
    if i in (3, 6) then
      code := code || '-';
    end if;
  end loop;
  return code;
end;
$$;

create or replace function public.ensure_teacher_profile(p_display_name text default '')
returns public.teacher_profiles
language plpgsql
security definer
set search_path = public
as $$
declare
  profile public.teacher_profiles;
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;

  insert into public.teacher_profiles (id, display_name)
  values (auth.uid(), coalesce(nullif(trim(p_display_name), ''), 'Teacher'))
  on conflict (id) do update
    set display_name = coalesce(nullif(trim(p_display_name), ''), public.teacher_profiles.display_name)
  returning * into profile;

  return profile;
end;
$$;

create or replace function public.create_class(p_name text)
returns public.classes
language plpgsql
security definer
set search_path = public
as $$
declare
  new_code text;
  klass public.classes;
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;

  loop
    new_code := public.random_class_code();
    exit when not exists (select 1 from public.classes where code = new_code and deleted_at is null);
  end loop;

  insert into public.classes (teacher_id, name, code)
  values (auth.uid(), trim(p_name), new_code)
  returning * into klass;

  insert into public.audit_log (teacher_id, action, details)
  values (auth.uid(), 'class_created', jsonb_build_object('class_id', klass.id, 'name', klass.name));

  return klass;
end;
$$;

create or replace function public.rotate_class_code(p_class_id uuid)
returns public.classes
language plpgsql
security definer
set search_path = public
as $$
declare
  new_code text;
  klass public.classes;
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;

  if not exists (
    select 1
    from public.classes as c
    where c.id = p_class_id and c.teacher_id = auth.uid() and c.deleted_at is null
  ) then
    raise exception 'Class not found';
  end if;

  loop
    new_code := public.random_class_code();
    exit when not exists (select 1 from public.classes where code = new_code and deleted_at is null);
  end loop;

  update public.classes as c
  set code = new_code, code_rotated_at = now()
  where c.id = p_class_id and c.teacher_id = auth.uid()
  returning c.* into klass;

  insert into public.audit_log (teacher_id, action, details)
  values (auth.uid(), 'class_code_rotated', jsonb_build_object('class_id', klass.id));

  return klass;
end;
$$;

drop function if exists public.create_student(uuid, text, text);
create function public.create_student(p_class_id uuid, p_alias text, p_pin text)
returns table (
  id uuid,
  class_id uuid,
  teacher_id uuid,
  alias text,
  created_at timestamptz,
  deleted_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  owner_id uuid;
  new_student public.students;
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;

  if length(trim(p_pin)) < 4 then
    raise exception 'PIN must be at least 4 characters';
  end if;

  select c.teacher_id into owner_id
  from public.classes as c
  where c.id = p_class_id and c.deleted_at is null;

  if owner_id is null or owner_id <> auth.uid() then
    raise exception 'Class not found';
  end if;

  insert into public.students (class_id, teacher_id, alias, pin_hash)
  values (p_class_id, auth.uid(), trim(p_alias), extensions.crypt(trim(p_pin), extensions.gen_salt('bf')))
  returning * into new_student;

  insert into public.audit_log (teacher_id, action, details)
  values (auth.uid(), 'student_added', jsonb_build_object('class_id', p_class_id, 'student_id', new_student.id));

  return query
  select new_student.id, new_student.class_id, new_student.teacher_id,
         new_student.alias, new_student.created_at, new_student.deleted_at;
end;
$$;

create or replace function public.join_student(p_class_code text, p_alias text, p_pin text)
returns table (
  student_id uuid,
  class_id uuid,
  teacher_id uuid,
  alias text,
  access_token text
)
language plpgsql
security definer
set search_path = public
as $$
declare
  student public.students;
  token text;
begin
  select s.* into student
  from public.students s
  join public.classes c on c.id = s.class_id
  where upper(c.code) = upper(trim(p_class_code))
    and lower(s.alias) = lower(trim(p_alias))
    and c.deleted_at is null
    and s.deleted_at is null
  limit 1;

  if student.id is null or student.pin_hash <> extensions.crypt(trim(p_pin), student.pin_hash) then
    raise exception 'Class code, alias, or PIN did not match';
  end if;

  token := encode(extensions.gen_random_bytes(32), 'hex');

  update public.students as s
  set student_token_hash = encode(extensions.digest(token, 'sha256'), 'hex'),
      student_token_expires_at = now() + interval '8 hours'
  where s.id = student.id;

  return query
  select student.id, student.class_id, student.teacher_id, student.alias, token;
end;
$$;

create or replace function public.submit_student_session(
  p_student_id uuid,
  p_access_token text,
  p_mode text,
  p_operation text,
  p_level_id text,
  p_level_name text,
  p_tags text[],
  p_attempted integer,
  p_correct integer,
  p_accuracy integer,
  p_best_streak integer,
  p_time_spent integer,
  p_score integer,
  p_mistakes jsonb
)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  student public.students;
  session_id uuid;
  mistake jsonb;
begin
  select s.* into student
  from public.students as s
  where s.id = p_student_id
    and s.deleted_at is null
    and s.student_token_hash = encode(extensions.digest(p_access_token, 'sha256'), 'hex')
    and s.student_token_expires_at > now();

  if student.id is null then
    raise exception 'Student session expired or invalid';
  end if;

  insert into public.sessions (
    class_id, student_id, teacher_id, student_alias, mode, operation,
    level_id, level_name, tags, attempted, correct, accuracy,
    best_streak, time_spent, score
  )
  values (
    student.class_id, student.id, student.teacher_id, student.alias, p_mode, p_operation,
    p_level_id, p_level_name, coalesce(p_tags, '{}'), coalesce(p_attempted, 0),
    coalesce(p_correct, 0), coalesce(p_accuracy, 0), coalesce(p_best_streak, 0),
    coalesce(p_time_spent, 0), coalesce(p_score, 0)
  )
  returning id into session_id;

  for mistake in select * from jsonb_array_elements(coalesce(p_mistakes, '[]'::jsonb))
  loop
    insert into public.mistakes (
      session_id, class_id, student_id, teacher_id, question, student_answer,
      correct_answer, operation, level_id, tags, recovered
    )
    values (
      session_id,
      student.class_id,
      student.id,
      student.teacher_id,
      coalesce(mistake->>'question', ''),
      coalesce(mistake->>'studentAnswer', ''),
      coalesce(mistake->>'correctAnswer', ''),
      coalesce(mistake->>'operation', p_operation),
      coalesce(mistake->>'levelId', p_level_id),
      coalesce(array(select jsonb_array_elements_text(coalesce(mistake->'tags', '[]'::jsonb))), '{}'),
      coalesce((mistake->>'recovered')::boolean, false)
    );
  end loop;

  return session_id;
end;
$$;

create or replace function public.reset_student_pin(p_student_id uuid, p_new_pin text)
returns table (
  id uuid,
  class_id uuid,
  teacher_id uuid,
  alias text,
  created_at timestamptz,
  deleted_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  updated_student public.students;
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;

  if length(trim(p_new_pin)) < 4 then
    raise exception 'PIN must be at least 4 characters';
  end if;

  update public.students as s
  set pin_hash = extensions.crypt(trim(p_new_pin), extensions.gen_salt('bf')),
      student_token_hash = null,
      student_token_expires_at = null
  where s.id = p_student_id
    and s.teacher_id = auth.uid()
    and s.deleted_at is null
  returning s.* into updated_student;

  if updated_student.id is null then
    raise exception 'Student not found';
  end if;

  insert into public.audit_log (teacher_id, action, details)
  values (auth.uid(), 'student_pin_reset', jsonb_build_object('student_id', updated_student.id, 'class_id', updated_student.class_id));

  return query
  select updated_student.id, updated_student.class_id, updated_student.teacher_id,
         updated_student.alias, updated_student.created_at, updated_student.deleted_at;
end;
$$;

grant execute on function public.ensure_teacher_profile(text) to authenticated;
grant execute on function public.create_class(text) to authenticated;
grant execute on function public.rotate_class_code(uuid) to authenticated;
grant execute on function public.create_student(uuid, text, text) to authenticated;
grant execute on function public.reset_student_pin(uuid, text) to authenticated;
grant execute on function public.join_student(text, text, text) to anon, authenticated;
grant execute on function public.submit_student_session(uuid, text, text, text, text, text, text[], integer, integer, integer, integer, integer, integer, jsonb) to anon, authenticated;
