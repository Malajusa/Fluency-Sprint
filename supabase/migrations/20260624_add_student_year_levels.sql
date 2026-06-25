-- Fluency Sprint migration: add teacher-assigned student year levels
-- Run this in Supabase SQL Editor before updating the front end to rely on year_level.
-- This is intended to be non-destructive and preserve existing students.

-- 1. Add year-level fields.

alter table public.students
  add column if not exists year_level text not null default 'Y4';

alter table public.classes
  add column if not exists default_year_level text not null default 'Y4';

-- 2. Add safe constraints without failing if they already exist.

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'students_year_level_check'
      and conrelid = 'public.students'::regclass
  ) then
    alter table public.students
      add constraint students_year_level_check
      check (year_level in ('PP', 'Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6'));
  end if;
end $$;

do $$
begin
  if not exists (
    select 1
    from pg_constraint
    where conname = 'classes_default_year_level_check'
      and conrelid = 'public.classes'::regclass
  ) then
    alter table public.classes
      add constraint classes_default_year_level_check
      check (default_year_level in ('PP', 'Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6'));
  end if;
end $$;

-- 3. Replace create_student so it can accept an optional year level.
-- Existing three-argument behaviour is preserved by the default p_year_level value.

drop function if exists public.create_student(uuid, text, text);
drop function if exists public.create_student(uuid, text, text, text);

create function public.create_student(
  p_class_id uuid,
  p_alias text,
  p_pin text,
  p_year_level text default 'Y4'
)
returns table (
  id uuid,
  class_id uuid,
  teacher_id uuid,
  first_name text,
  last_name text,
  alias text,
  year_level text,
  created_at timestamptz,
  deleted_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  owner_id uuid;
  clean_alias text;
  clean_year_level text;
  new_student public.students;
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;

  clean_alias := regexp_replace(trim(coalesce(p_alias, '')), '[[:space:]]+', ' ', 'g');
  clean_year_level := coalesce(nullif(trim(p_year_level), ''), 'Y4');

  if clean_year_level not in ('PP', 'Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6') then
    raise exception 'Invalid year level';
  end if;

  if clean_alias = '' then
    raise exception 'Student alias is required';
  end if;

  if length(clean_alias) > 40 then
    raise exception 'Student alias must be 40 characters or fewer';
  end if;

  if length(trim(coalesce(p_pin, ''))) < 4 then
    raise exception 'PIN must be at least 4 characters';
  end if;

  select c.teacher_id into owner_id
  from public.classes as c
  where c.id = p_class_id and c.deleted_at is null;

  if owner_id is null or owner_id <> auth.uid() then
    raise exception 'Class not found';
  end if;

  if exists (
    select 1
    from public.students as s
    where s.class_id = p_class_id
      and lower(s.alias) = lower(clean_alias)
      and s.deleted_at is null
  ) then
    raise exception 'That alias already exists in this class';
  end if;

  insert into public.students (class_id, teacher_id, first_name, last_name, alias, pin_hash, year_level)
  values (
    p_class_id,
    auth.uid(),
    '',
    '',
    clean_alias,
    extensions.crypt(trim(coalesce(p_pin, '')), extensions.gen_salt('bf')),
    clean_year_level
  )
  returning * into new_student;

  insert into public.audit_log (teacher_id, action, details)
  values (
    auth.uid(),
    'student_added',
    jsonb_build_object(
      'class_id', p_class_id,
      'student_id', new_student.id,
      'year_level', new_student.year_level
    )
  );

  return query
  select
    new_student.id,
    new_student.class_id,
    new_student.teacher_id,
    new_student.first_name,
    new_student.last_name,
    new_student.alias,
    new_student.year_level,
    new_student.created_at,
    new_student.deleted_at;
end;
$$;

-- 4. Add teacher-only RPC for editing a student's year level.

create or replace function public.update_student_year_level(
  p_student_id uuid,
  p_year_level text
)
returns table (
  id uuid,
  class_id uuid,
  teacher_id uuid,
  first_name text,
  last_name text,
  alias text,
  year_level text,
  created_at timestamptz,
  deleted_at timestamptz
)
language plpgsql
security definer
set search_path = public
as $$
declare
  clean_year_level text;
  updated_student public.students;
begin
  if auth.uid() is null then
    raise exception 'Not signed in';
  end if;

  clean_year_level := coalesce(nullif(trim(p_year_level), ''), 'Y4');

  if clean_year_level not in ('PP', 'Y1', 'Y2', 'Y3', 'Y4', 'Y5', 'Y6') then
    raise exception 'Invalid year level';
  end if;

  update public.students as s
  set year_level = clean_year_level
  where s.id = p_student_id
    and s.teacher_id = auth.uid()
    and s.deleted_at is null
  returning s.* into updated_student;

  if updated_student.id is null then
    raise exception 'Student not found';
  end if;

  insert into public.audit_log (teacher_id, action, details)
  values (
    auth.uid(),
    'student_year_level_updated',
    jsonb_build_object(
      'student_id', updated_student.id,
      'class_id', updated_student.class_id,
      'year_level', updated_student.year_level
    )
  );

  return query
  select
    updated_student.id,
    updated_student.class_id,
    updated_student.teacher_id,
    updated_student.first_name,
    updated_student.last_name,
    updated_student.alias,
    updated_student.year_level,
    updated_student.created_at,
    updated_student.deleted_at;
end;
$$;

-- 5. Optional: update reset_student_pin return shape to include year_level later if the front end needs it.
-- Current reset logic can continue to work without this because dashboard reloads students.
