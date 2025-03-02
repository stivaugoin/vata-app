create type "public"."gender" as enum ('male', 'female');

create type "public"."name_type" as enum ('birth', 'marriage', 'nickname', 'unknown');

create table "public"."families" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "husband_id" uuid,
    "wife_id" uuid,
    "gedcom_id" bigint generated by default as identity not null
);


alter table "public"."families" enable row level security;

create table "public"."family_children" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "family_id" uuid not null,
    "individual_id" uuid not null
);


alter table "public"."family_children" enable row level security;

create table "public"."individuals" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "gender" gender not null,
    "gedcom_id" bigint generated by default as identity not null
);


alter table "public"."individuals" enable row level security;

create table "public"."names" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "individual_id" uuid not null,
    "first_name" text,
    "last_name" text,
    "surname" text,
    "type" name_type not null default 'birth'::name_type,
    "is_primary" boolean not null default true
);


alter table "public"."names" enable row level security;

CREATE UNIQUE INDEX families_pkey ON public.families USING btree (id);

CREATE UNIQUE INDEX family_children_pkey ON public.family_children USING btree (id);

CREATE UNIQUE INDEX individuals_gedcom_id_key ON public.individuals USING btree (gedcom_id);

CREATE UNIQUE INDEX individuals_pkey ON public.individuals USING btree (id);

CREATE UNIQUE INDEX names_pkey ON public.names USING btree (id);

alter table "public"."families" add constraint "families_pkey" PRIMARY KEY using index "families_pkey";

alter table "public"."family_children" add constraint "family_children_pkey" PRIMARY KEY using index "family_children_pkey";

alter table "public"."individuals" add constraint "individuals_pkey" PRIMARY KEY using index "individuals_pkey";

alter table "public"."names" add constraint "names_pkey" PRIMARY KEY using index "names_pkey";

alter table "public"."families" add constraint "families_husband_id_fkey" FOREIGN KEY (husband_id) REFERENCES individuals(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."families" validate constraint "families_husband_id_fkey";

alter table "public"."families" add constraint "families_wife_id_fkey" FOREIGN KEY (wife_id) REFERENCES individuals(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."families" validate constraint "families_wife_id_fkey";

alter table "public"."family_children" add constraint "family_children_family_id_fkey" FOREIGN KEY (family_id) REFERENCES families(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."family_children" validate constraint "family_children_family_id_fkey";

alter table "public"."family_children" add constraint "family_children_individual_id_fkey" FOREIGN KEY (individual_id) REFERENCES individuals(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."family_children" validate constraint "family_children_individual_id_fkey";

alter table "public"."individuals" add constraint "individuals_gedcom_id_key" UNIQUE using index "individuals_gedcom_id_key";

alter table "public"."names" add constraint "names_individual_id_fkey" FOREIGN KEY (individual_id) REFERENCES individuals(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."names" validate constraint "names_individual_id_fkey";

grant delete on table "public"."families" to "anon";

grant insert on table "public"."families" to "anon";

grant references on table "public"."families" to "anon";

grant select on table "public"."families" to "anon";

grant trigger on table "public"."families" to "anon";

grant truncate on table "public"."families" to "anon";

grant update on table "public"."families" to "anon";

grant delete on table "public"."families" to "authenticated";

grant insert on table "public"."families" to "authenticated";

grant references on table "public"."families" to "authenticated";

grant select on table "public"."families" to "authenticated";

grant trigger on table "public"."families" to "authenticated";

grant truncate on table "public"."families" to "authenticated";

grant update on table "public"."families" to "authenticated";

grant delete on table "public"."families" to "service_role";

grant insert on table "public"."families" to "service_role";

grant references on table "public"."families" to "service_role";

grant select on table "public"."families" to "service_role";

grant trigger on table "public"."families" to "service_role";

grant truncate on table "public"."families" to "service_role";

grant update on table "public"."families" to "service_role";

grant delete on table "public"."family_children" to "anon";

grant insert on table "public"."family_children" to "anon";

grant references on table "public"."family_children" to "anon";

grant select on table "public"."family_children" to "anon";

grant trigger on table "public"."family_children" to "anon";

grant truncate on table "public"."family_children" to "anon";

grant update on table "public"."family_children" to "anon";

grant delete on table "public"."family_children" to "authenticated";

grant insert on table "public"."family_children" to "authenticated";

grant references on table "public"."family_children" to "authenticated";

grant select on table "public"."family_children" to "authenticated";

grant trigger on table "public"."family_children" to "authenticated";

grant truncate on table "public"."family_children" to "authenticated";

grant update on table "public"."family_children" to "authenticated";

grant delete on table "public"."family_children" to "service_role";

grant insert on table "public"."family_children" to "service_role";

grant references on table "public"."family_children" to "service_role";

grant select on table "public"."family_children" to "service_role";

grant trigger on table "public"."family_children" to "service_role";

grant truncate on table "public"."family_children" to "service_role";

grant update on table "public"."family_children" to "service_role";

grant delete on table "public"."individuals" to "anon";

grant insert on table "public"."individuals" to "anon";

grant references on table "public"."individuals" to "anon";

grant select on table "public"."individuals" to "anon";

grant trigger on table "public"."individuals" to "anon";

grant truncate on table "public"."individuals" to "anon";

grant update on table "public"."individuals" to "anon";

grant delete on table "public"."individuals" to "authenticated";

grant insert on table "public"."individuals" to "authenticated";

grant references on table "public"."individuals" to "authenticated";

grant select on table "public"."individuals" to "authenticated";

grant trigger on table "public"."individuals" to "authenticated";

grant truncate on table "public"."individuals" to "authenticated";

grant update on table "public"."individuals" to "authenticated";

grant delete on table "public"."individuals" to "service_role";

grant insert on table "public"."individuals" to "service_role";

grant references on table "public"."individuals" to "service_role";

grant select on table "public"."individuals" to "service_role";

grant trigger on table "public"."individuals" to "service_role";

grant truncate on table "public"."individuals" to "service_role";

grant update on table "public"."individuals" to "service_role";

grant delete on table "public"."names" to "anon";

grant insert on table "public"."names" to "anon";

grant references on table "public"."names" to "anon";

grant select on table "public"."names" to "anon";

grant trigger on table "public"."names" to "anon";

grant truncate on table "public"."names" to "anon";

grant update on table "public"."names" to "anon";

grant delete on table "public"."names" to "authenticated";

grant insert on table "public"."names" to "authenticated";

grant references on table "public"."names" to "authenticated";

grant select on table "public"."names" to "authenticated";

grant trigger on table "public"."names" to "authenticated";

grant truncate on table "public"."names" to "authenticated";

grant update on table "public"."names" to "authenticated";

grant delete on table "public"."names" to "service_role";

grant insert on table "public"."names" to "service_role";

grant references on table "public"."names" to "service_role";

grant select on table "public"."names" to "service_role";

grant trigger on table "public"."names" to "service_role";

grant truncate on table "public"."names" to "service_role";

grant update on table "public"."names" to "service_role";

create policy "Enable read access for all users"
on "public"."families"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."individuals"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."names"
as permissive
for select
to public
using (true);



