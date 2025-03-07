create type "public"."gender" as enum ('male', 'female');

create type "public"."name_type" as enum ('birth', 'marriage', 'nickname', 'unknown');

create type "public"."family_type" as enum ('married', 'civil union', 'unknown', 'unmarried');

create table "public"."place_types" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    CONSTRAINT place_types_name_key UNIQUE (name)
);

alter table "public"."place_types" enable row level security;

-- Insert initial place types
INSERT INTO "public"."place_types" ("name") VALUES
('country'),
('state'),
('province'),
('city'),
('town'),
('village'),
('address'),
('cemetery'),
('church'),
('hospital'),
('other');

create table "public"."individual_event_types" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    CONSTRAINT individual_event_types_name_key UNIQUE (name)
);

alter table "public"."individual_event_types" enable row level security;

-- Insert initial individual event types
INSERT INTO "public"."individual_event_types" ("name") VALUES
('birth'),
('death'),
('baptism'),
('burial'),
('graduation'),
('retirement'),
('immigration'),
('emigration'),
('naturalization'),
('census'),
('will'),
('probate'),
('other');

create table "public"."family_event_types" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    CONSTRAINT family_event_types_name_key UNIQUE (name)
);

alter table "public"."family_event_types" enable row level security;

-- Insert initial family event types
INSERT INTO "public"."family_event_types" ("name") VALUES
('marriage'),
('divorce'),
('engagement'),
('annulment'),
('separation'),
('other');

create table "public"."families" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "husband_id" uuid,
    "wife_id" uuid,
    "gedcom_id" bigint generated by default as identity not null,
    "type" family_type not null default 'married'::family_type
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

create table "public"."places" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "name" text not null,
    "type_id" uuid not null,
    "parent_id" uuid,
    "latitude" decimal,
    "longitude" decimal
);

alter table "public"."places" enable row level security;

create table "public"."individual_events" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "individual_id" uuid not null,
    "type_id" uuid not null,
    "date" text,
    "place_id" uuid,
    "description" text
);

alter table "public"."individual_events" enable row level security;

create table "public"."family_events" (
    "id" uuid not null default gen_random_uuid(),
    "created_at" timestamp with time zone not null default now(),
    "family_id" uuid not null,
    "type_id" uuid not null,
    "date" text,
    "place_id" uuid,
    "description" text
);

alter table "public"."family_events" enable row level security;

CREATE UNIQUE INDEX families_pkey ON public.families USING btree (id);

CREATE UNIQUE INDEX family_children_pkey ON public.family_children USING btree (id);

CREATE UNIQUE INDEX individuals_gedcom_id_key ON public.individuals USING btree (gedcom_id);

CREATE UNIQUE INDEX individuals_pkey ON public.individuals USING btree (id);

CREATE UNIQUE INDEX names_pkey ON public.names USING btree (id);

CREATE UNIQUE INDEX place_types_pkey ON public.place_types USING btree (id);

CREATE UNIQUE INDEX individual_event_types_pkey ON public.individual_event_types USING btree (id);

CREATE UNIQUE INDEX family_event_types_pkey ON public.family_event_types USING btree (id);

CREATE UNIQUE INDEX places_pkey ON public.places USING btree (id);

CREATE UNIQUE INDEX individual_events_pkey ON public.individual_events USING btree (id);

CREATE UNIQUE INDEX family_events_pkey ON public.family_events USING btree (id);

alter table "public"."families" add constraint "families_pkey" PRIMARY KEY using index "families_pkey";

alter table "public"."family_children" add constraint "family_children_pkey" PRIMARY KEY using index "family_children_pkey";

alter table "public"."individuals" add constraint "individuals_pkey" PRIMARY KEY using index "individuals_pkey";

alter table "public"."names" add constraint "names_pkey" PRIMARY KEY using index "names_pkey";

alter table "public"."place_types" add constraint "place_types_pkey" PRIMARY KEY using index "place_types_pkey";

alter table "public"."individual_event_types" add constraint "individual_event_types_pkey" PRIMARY KEY using index "individual_event_types_pkey";

alter table "public"."family_event_types" add constraint "family_event_types_pkey" PRIMARY KEY using index "family_event_types_pkey";

alter table "public"."places" add constraint "places_pkey" PRIMARY KEY using index "places_pkey";

alter table "public"."individual_events" add constraint "individual_events_pkey" PRIMARY KEY using index "individual_events_pkey";

alter table "public"."family_events" add constraint "family_events_pkey" PRIMARY KEY using index "family_events_pkey";

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

alter table "public"."places" add constraint "places_parent_id_fkey" FOREIGN KEY (parent_id) REFERENCES places(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."places" validate constraint "places_parent_id_fkey";

alter table "public"."places" add constraint "places_type_id_fkey" FOREIGN KEY (type_id) REFERENCES place_types(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."places" validate constraint "places_type_id_fkey";

alter table "public"."individual_events" add constraint "individual_events_individual_id_fkey" FOREIGN KEY (individual_id) REFERENCES individuals(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."individual_events" validate constraint "individual_events_individual_id_fkey";

alter table "public"."individual_events" add constraint "individual_events_place_id_fkey" FOREIGN KEY (place_id) REFERENCES places(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."individual_events" validate constraint "individual_events_place_id_fkey";

alter table "public"."individual_events" add constraint "individual_events_type_id_fkey" FOREIGN KEY (type_id) REFERENCES individual_event_types(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."individual_events" validate constraint "individual_events_type_id_fkey";

alter table "public"."family_events" add constraint "family_events_family_id_fkey" FOREIGN KEY (family_id) REFERENCES families(id) ON UPDATE CASCADE ON DELETE CASCADE not valid;

alter table "public"."family_events" validate constraint "family_events_family_id_fkey";

alter table "public"."family_events" add constraint "family_events_place_id_fkey" FOREIGN KEY (place_id) REFERENCES places(id) ON UPDATE CASCADE ON DELETE SET NULL not valid;

alter table "public"."family_events" validate constraint "family_events_place_id_fkey";

alter table "public"."family_events" add constraint "family_events_type_id_fkey" FOREIGN KEY (type_id) REFERENCES family_event_types(id) ON UPDATE CASCADE ON DELETE RESTRICT not valid;

alter table "public"."family_events" validate constraint "family_events_type_id_fkey";

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

grant delete on table "public"."places" to "anon";

grant insert on table "public"."places" to "anon";

grant references on table "public"."places" to "anon";

grant select on table "public"."places" to "anon";

grant trigger on table "public"."places" to "anon";

grant truncate on table "public"."places" to "anon";

grant update on table "public"."places" to "anon";

grant delete on table "public"."places" to "authenticated";

grant insert on table "public"."places" to "authenticated";

grant references on table "public"."places" to "authenticated";

grant select on table "public"."places" to "authenticated";

grant trigger on table "public"."places" to "authenticated";

grant truncate on table "public"."places" to "authenticated";

grant update on table "public"."places" to "authenticated";

grant delete on table "public"."places" to "service_role";

grant insert on table "public"."places" to "service_role";

grant references on table "public"."places" to "service_role";

grant select on table "public"."places" to "service_role";

grant trigger on table "public"."places" to "service_role";

grant truncate on table "public"."places" to "service_role";

grant update on table "public"."places" to "service_role";

grant delete on table "public"."individual_events" to "anon";

grant insert on table "public"."individual_events" to "anon";

grant references on table "public"."individual_events" to "anon";

grant select on table "public"."individual_events" to "anon";

grant trigger on table "public"."individual_events" to "anon";

grant truncate on table "public"."individual_events" to "anon";

grant update on table "public"."individual_events" to "anon";

grant delete on table "public"."individual_events" to "authenticated";

grant insert on table "public"."individual_events" to "authenticated";

grant references on table "public"."individual_events" to "authenticated";

grant select on table "public"."individual_events" to "authenticated";

grant trigger on table "public"."individual_events" to "authenticated";

grant truncate on table "public"."individual_events" to "authenticated";

grant update on table "public"."individual_events" to "authenticated";

grant delete on table "public"."individual_events" to "service_role";

grant insert on table "public"."individual_events" to "service_role";

grant references on table "public"."individual_events" to "service_role";

grant select on table "public"."individual_events" to "service_role";

grant trigger on table "public"."individual_events" to "service_role";

grant truncate on table "public"."individual_events" to "service_role";

grant update on table "public"."individual_events" to "service_role";

grant delete on table "public"."family_events" to "anon";

grant insert on table "public"."family_events" to "anon";

grant references on table "public"."family_events" to "anon";

grant select on table "public"."family_events" to "anon";

grant trigger on table "public"."family_events" to "anon";

grant truncate on table "public"."family_events" to "anon";

grant update on table "public"."family_events" to "anon";

grant delete on table "public"."family_events" to "authenticated";

grant insert on table "public"."family_events" to "authenticated";

grant references on table "public"."family_events" to "authenticated";

grant select on table "public"."family_events" to "authenticated";

grant trigger on table "public"."family_events" to "authenticated";

grant truncate on table "public"."family_events" to "authenticated";

grant update on table "public"."family_events" to "authenticated";

grant delete on table "public"."family_events" to "service_role";

grant insert on table "public"."family_events" to "service_role";

grant references on table "public"."family_events" to "service_role";

grant select on table "public"."family_events" to "service_role";

grant trigger on table "public"."family_events" to "service_role";

grant truncate on table "public"."family_events" to "service_role";

grant update on table "public"."family_events" to "service_role";

grant update on table "public"."family_event_types" to "service_role";

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

create policy "Enable read access for all users"
on "public"."family_children"
as permissive
for select
to public
using (true);

create policy "Enable read access for all users"
on "public"."places"
as permissive
for select
to public
using (true);

create policy "Enable read access for all users"
on "public"."individual_events"
as permissive
for select
to public
using (true);

create policy "Enable read access for all users"
on "public"."family_events"
as permissive
for select
to public
using (true);

create policy "Enable read access for all users"
on "public"."place_types"
as permissive
for select
to public
using (true);

create policy "Enable read access for all users"
on "public"."individual_event_types"
as permissive
for select
to public
using (true);

create policy "Enable read access for all users"
on "public"."family_event_types"
as permissive
for select
to public
using (true);

grant truncate on table "public"."family_events" to "service_role";

grant update on table "public"."family_events" to "service_role";

grant delete on table "public"."place_types" to "anon";
grant insert on table "public"."place_types" to "anon";
grant references on table "public"."place_types" to "anon";
grant select on table "public"."place_types" to "anon";
grant trigger on table "public"."place_types" to "anon";
grant truncate on table "public"."place_types" to "anon";
grant update on table "public"."place_types" to "anon";
grant delete on table "public"."place_types" to "authenticated";
grant insert on table "public"."place_types" to "authenticated";
grant references on table "public"."place_types" to "authenticated";
grant select on table "public"."place_types" to "authenticated";
grant trigger on table "public"."place_types" to "authenticated";
grant truncate on table "public"."place_types" to "authenticated";
grant update on table "public"."place_types" to "authenticated";
grant delete on table "public"."place_types" to "service_role";
grant insert on table "public"."place_types" to "service_role";
grant references on table "public"."place_types" to "service_role";
grant select on table "public"."place_types" to "service_role";
grant trigger on table "public"."place_types" to "service_role";
grant truncate on table "public"."place_types" to "service_role";
grant update on table "public"."place_types" to "service_role";

grant delete on table "public"."individual_event_types" to "anon";
grant insert on table "public"."individual_event_types" to "anon";
grant references on table "public"."individual_event_types" to "anon";
grant select on table "public"."individual_event_types" to "anon";
grant trigger on table "public"."individual_event_types" to "anon";
grant truncate on table "public"."individual_event_types" to "anon";
grant update on table "public"."individual_event_types" to "anon";
grant delete on table "public"."individual_event_types" to "authenticated";
grant insert on table "public"."individual_event_types" to "authenticated";
grant references on table "public"."individual_event_types" to "authenticated";
grant select on table "public"."individual_event_types" to "authenticated";
grant trigger on table "public"."individual_event_types" to "authenticated";
grant truncate on table "public"."individual_event_types" to "authenticated";
grant update on table "public"."individual_event_types" to "authenticated";
grant delete on table "public"."individual_event_types" to "service_role";
grant insert on table "public"."individual_event_types" to "service_role";
grant references on table "public"."individual_event_types" to "service_role";
grant select on table "public"."individual_event_types" to "service_role";
grant trigger on table "public"."individual_event_types" to "service_role";
grant truncate on table "public"."individual_event_types" to "service_role";
grant update on table "public"."individual_event_types" to "service_role";

grant delete on table "public"."family_event_types" to "anon";
grant insert on table "public"."family_event_types" to "anon";
grant references on table "public"."family_event_types" to "anon";
grant select on table "public"."family_event_types" to "anon";
grant trigger on table "public"."family_event_types" to "anon";
grant truncate on table "public"."family_event_types" to "anon";
grant update on table "public"."family_event_types" to "anon";
grant delete on table "public"."family_event_types" to "authenticated";
grant insert on table "public"."family_event_types" to "authenticated";
grant references on table "public"."family_event_types" to "authenticated";
grant select on table "public"."family_event_types" to "authenticated";
grant trigger on table "public"."family_event_types" to "authenticated";
grant truncate on table "public"."family_event_types" to "authenticated";
grant update on table "public"."family_event_types" to "authenticated";
grant delete on table "public"."family_event_types" to "service_role";
grant insert on table "public"."family_event_types" to "service_role";
grant references on table "public"."family_event_types" to "service_role";
grant select on table "public"."family_event_types" to "service_role";
grant trigger on table "public"."family_event_types" to "service_role";
grant truncate on table "public"."family_event_types" to "service_role";
grant update on table "public"."family_event_types" to "service_role";
