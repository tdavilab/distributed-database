/*
MCIC-BD-PROYECTO FINAL
Christopher Giovanny Ortiz Montero		Código: 20201495006
Joaquín Eduardo Caicedo Navarro			Código: 20201495001
Thomas Daniel Ávila Blenkey			Código: 20151020012
--------------------------
--FACULTAD DE INGENIERIA--
--------------------------
*/

set search_path to public;
show search_path;

--Cree los esquemas correspondientes a cada proyecto curricular
create schema ing_catastral;
create schema ing_industrial;
create schema ing_sistemas;
create schema ing_electrica;
create schema ing_electronica;
create schema mcic;

-----------------------------------------------------
-- CREACIÓN DE TABLAS DE LA FACULTAD DE INGENIERIA --
-----------------------------------------------------
-- Se ubica en el esquema "public" para la creación de las tablas generales de la facultad.
set search_path to public;
show search_path;

--Instale la extension dblink
create extension dblink;

----------------------
--Entidad profesores--
----------------------
create table profesores (
    id_p bigint check(id_p >= 0) primary key,
    nom_p varchar(70) not null,
    dir_p varchar(70) not null,
    tel_p int null check (tel_p >= 0),
    profesion varchar(70) not null
);
	
--------------------
--Entidad carreras--
--------------------
create table carreras(
	id_carr bigint check (id_carr >= 0) primary key,
	nom_carr varchar(70) not null unique,
	reg_cal bigint not null unique check (reg_cal >= 0)
);

-----------------------	
--Entidad asignaturas--
-----------------------
create table asignaturas(
	cod_a bigint check (cod_a >= 0) primary key,
	nom_a varchar(70) not null unique,
	int_h smallint not null check (int_h >= 0),
	creditos int not null check (creditos >= 0)
);

------------------
--Entidad libros--
------------------
create table libros(
	isbn bigint check (isbn >= 0) primary key,
	titulo varchar(70) not null,
	edicion smallint not null check (edicion >= 0),
	editorial varchar(70) not null
);

-------------------
--Entidad autores--
-------------------
create table autores(
	id_a bigint check (id_a >= 0) primary key,
	nom_autor varchar(70) not null,
	nacionalidad varchar(70) not null
);

--------------------
--Relación imparte--
--------------------
create table imparte(
	id_p bigint references profesores (id_p),
	cod_a bigint references asignaturas (cod_a),
	grupo smallint not null check (grupo >= 0),
	salon smallint not null check (salon >= 0),
	horario varchar(70) not null,
	primary key (id_p, cod_a, grupo)
);

-----------------------	
--Relación referencia--
-----------------------
create table referencia(
	cod_a bigint references asignaturas (cod_a),
	isbn bigint references public.libros (isbn),
	primary key (cod_a, isbn)
);

--------------------
--Relación escribe--
--------------------
create table escribe(
	id_a bigint references autores (id_a),
	isbn bigint references libros (isbn),
	primary key (isbn, id_a)
);

----------------------
--Entidad ejemplares--
----------------------
create table ejemplares(
	num_ej int check (num_ej >= 0),
	isbn bigint references libros (isbn),
	primary key (num_ej, isbn)
);

-------------------
--Relación presta--
-------------------
create table presta(
	cod_e bigint,
	num_ej int,
	isbn bigint,
	fech_p date not null check (fech_p between '1900-01-01' and now()),
	fech_d date null check (fech_d >= fech_p),
	primary key (cod_e, isbn, num_ej, fech_p),
	foreign key (num_ej, isbn) references ejemplares (num_ej, isbn)
);

--------------------
--Tabla: log_notas--
--------------------
create table log_notas(
    timestamp_ TIMESTAMP WITH TIME ZONE default NOW(),
    comando text not null,
    usuario varchar(50) not null,
    cod_e integer not null,
    id_p bigint not null,
    cod_a bigint not null,
    grupo smallint not null,
    n1_old numeric,
    n2_old numeric,
    n3_old numeric,
    n1_new numeric,
    n2_new numeric,
    n3_new numeric
);

--En cada esquema ejecute la creacion de las siguientes funciones
--------------------------------
--Funcion: crear_estudiantes()--
--------------------------------
create or replace function crear_estudiantes(esquema varchar) returns text as $$
declare
	msg_out text default 'Tabla estudiantes creada con exito';
begin
	execute 'set search_path to ' || esquema;
	create table estudiantes (
		cod_e bigint check (cod_e >= 0) primary key,
		nom_e varchar(70) not null,
		dir_e varchar(70) not null,
		tel_e int unique not null check (tel_e >= 0),
		fech_nac date not null check (fech_nac between '1900-01-01' and now()),
		id_carr bigint references public.carreras (id_carr) not null
	);
	set search_path to public;
	return msg_out;
end;
$$ language plpgsql;

-----------------------------
--Funcion: crear_inscribe()--
-----------------------------
create or replace function crear_inscribe(esquema varchar) returns text as $$
declare
	msg_out text default 'Tabla incribe creada con exito';
begin
	execute 'set search_path to ' || esquema;
	create table inscribe(
		cod_e bigint references estudiantes (cod_e),
		id_p bigint,
		cod_a bigint,
		grupo smallint,
		n1 numeric(2,1) null check (n1 between 0 and 5),
		n2 numeric(2,1) null check (n2 between 0 and 5),
		n3 numeric(2,1) null check (n3 between 0 and 5),
		primary key (cod_e, id_p, cod_a, grupo),
		foreign key (id_p, cod_a, grupo) references 
			public.imparte (id_p, cod_a, grupo) ON UPDATE CASCADE ON DELETE CASCADE,
		constraint uq_code_coda unique (cod_e, cod_a)
	);
	set search_path to public;
	return msg_out;
end;
$$ language plpgsql;

-----------------------------------
--Ingenieria Catastral y Geodesia--
-----------------------------------
--Ejecute las siguientes funciones
select * from crear_estudiantes('ing_catastral');
select * from crear_inscribe('ing_catastral');

-------------------------	
--Ingenieria Industrial--
-------------------------
--Ejecute las siguientes funciones
select * from crear_estudiantes('ing_industrial');
select * from crear_inscribe('ing_industrial');

--------------------------	
--Ingenieria de Sistemas--
--------------------------
--Ejecute las siguientes funciones
select * from crear_estudiantes('ing_sistemas');
select * from crear_inscribe('ing_sistemas');

------------------------
--Ingenieria Electrica--
------------------------
--Ejecute las siguientes funciones
select * from crear_estudiantes('ing_electrica');
select * from crear_inscribe('ing_electrica');

--------------------------	
--Ingenieria Electronica--
--------------------------
--Ejecute las siguientes funciones
select * from crear_estudiantes('ing_electronica');
select * from crear_inscribe('ing_electronica');

--------
--MCIC--
--------
--Ejecute las siguientes funciones
select * from crear_estudiantes('mcic');
select * from crear_inscribe('mcic');

/*Borre las funciones de crear_estudiantes() y crear_inscribe()*/

drop function crear_estudiantes(varchar);
drop function crear_inscribe(varchar);

--------------------------------
--Vista informacion profesores--
--------------------------------
create view info_profes as
	select * from profesores
	where id_p::varchar = current_user;

------------------------------------------
--Vista estudiantes: Facultad Ingenieria--
------------------------------------------
create view est_ing as
	select * from ing_catastral.estudiantes
	union
	select * from ing_sistemas.estudiantes
	union
	select * from ing_electrica.estudiantes
	union
	select * from ing_electronica.estudiantes
	union
	select * from ing_industrial.estudiantes
	union
	select * from mcic.estudiantes;

---------------------------------------
--Vista inscribe: Facultad Ingenieria--
---------------------------------------
create view insc_ing as
	select * from ing_catastral.inscribe
	union
	select * from ing_sistemas.inscribe
	union
	select * from ing_electrica.inscribe
	union
	select * from ing_electronica.inscribe
	union
	select * from ing_industrial.inscribe
	union
	select * from mcic.inscribe;

------------------------------------
--Vista notas: Facultad Ingenieria--
------------------------------------
create view notas_ing as
	select cod_e, nom_e, cod_a, nom_a, id_carr, n1::numeric(2,1), n2::numeric(2,1), n3::numeric(2,1), 
			(coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3)::numeric(2,1) definitiva,
	case coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3 >= 3.0
		when true then 'aprobado' else 'reprobado'
	end as concepto
	from insc_ing natural join est_ing natural join asignaturas
	where cod_e::varchar = current_user;
	
-----------------------------------------------
--Vista lista profesores: Facultad Ingenieria--
-----------------------------------------------
create view lista_prof_ing as
	select id_p, nom_p, cod_e, nom_e, cod_a, nom_a, grupo, id_carr, n1::numeric(2,1), n2::numeric(2,1), n3::numeric(2,1), 
			(coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3)::numeric(2,1) definitiva, 
	case coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3 >= 3.0
		when true then 'aprobado' else 'reprobado'
	end as concepto 
	from insc_ing natural join est_ing natural join asignaturas natural join profesores
	where id_p::varchar = current_user;

----------------------------
-- Vistas del coordinador --
----------------------------
-- Para que el coordinador pueda ver la lista de los profesores de la carrera
create view lista_coordinador as
	select id_p, nom_p, cod_e, nom_e, cod_a, nom_a, grupo, id_carr, n1::numeric(2,1), n2::numeric(2,1), n3::numeric(2,1), 
			(coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3)::numeric(2,1) definitiva, 
	case coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3 >= 3.0
		when true then 'aprobado' else 'reprobado'
	end as concepto 
	from insc_ing natural join est_ing natural join asignaturas natural join profesores
	where id_carr::text = current_user;

-- Vista con las asignaturas, libros y referencias específicas para la carrera del coordinador
create view referencias_coordinador as
	select distinct cod_a, nom_a, isbn, titulo, id_carr from insc_ing natural join asignaturas 
	natural join referencia natural join est_ing natural join carreras natural join libros
	where id_carr::text = current_user;

-------------------------
--Vista: ref_ingenieria--
-------------------------
create view ref_ingenieria as
	select distinct cod_a, nom_a, isbn, id_carr from insc_ing natural join asignaturas 
	natural join referencia natural join est_ing natural join carreras;

------------------------------------------------
-- Consulta Decano: Profesores de la Facultad --
------------------------------------------------
-- Para que el decano pueda ver la lista de los profesores de la facultad
create view lista_profesores as
	select id_p, nom_p, cod_e, nom_e, cod_a, nom_a, grupo, id_carr, n1::numeric(2,1), n2::numeric(2,1), n3::numeric(2,1), 
			(coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3)::numeric(2,1) definitiva, 
	case coalesce(n1,0)*0.35 + coalesce(n2,0)*0.35 + coalesce(n3,0)*0.3 >= 3.0
		when true then 'aprobado' else 'reprobado'
	end as concepto 
	from insc_ing natural join est_ing natural join asignaturas natural join profesores;
	
--------------------------------------------
--Vista estudiantes: Universidad Distrital--
--------------------------------------------
create view est_udistrital as
	select * from est_ing
	union
	select est_cienc.* from
	dblink('dbname=fac_ciencias host= 0.tcp.ngrok.io port= 19670 user=postgres password=postgres',
	'select * from estudiantes_ciencias')
	est_cienc (cod_e bigint,nom_e varchar,dir_e varchar,tel_est bigint,fech_nac date,id_carr bigint)
	union
	select est_medio_amb.* from
	dblink('dbname=fac_ambiental host = 0.tcp.ngrok.io port= 10338 user=postgres password=postgres',
	'select * from estudiantes_ambiental') 
	est_medio_amb (cod_e bigint,nom_e varchar,dir_e varchar,tel_est bigint,fech_nac date,id_carr bigint);

-----------------------------------------
--Vista inscribe: Universidad Distrital--
-----------------------------------------
create view insc_udistrital as
	select * from insc_ing
	union
	select est_cienc.* from
	dblink('dbname=fac_ciencias host= 0.tcp.ngrok.io port= 19670 user=postgres password=postgres',
	'select * from inscribe_ciencias')
	est_cienc (cod_e bigint,id_p bigint,cod_a bigint,grupo smallint,n1 numeric,n2 numeric,n3 numeric)
	union
	select est_medio_amb.* from
	dblink('dbname=fac_ambiental host = 0.tcp.ngrok.io port= 10338 user=postgres password=postgres',
	'select * from inscribe_ambiental') 
	est_medio_amb (cod_e bigint,id_p bigint,cod_a bigint,grupo smallint,n1 numeric,n2 numeric,n3 numeric);

---------------------------------
--Vista global usuario postgres--
---------------------------------
create view vista_global as
	select * from lista_profesores
	union
	select lista_cienc.* from
	dblink('dbname=fac_ciencias host= 0.tcp.ngrok.io port= 19670 user=postgres password=postgres',
	'select * from lista_profesores')
	lista_cienc (id_p bigint,nom_p varchar,cod_e bigint,nom_e varchar,
		cod_a bigint,nom_a varchar,grupo smallint,id_carr bigint,n1 numeric,n2 numeric,n3 numeric,
		definitiva numeric, concepto text)
	union
	select lista_ambiental.* from
	dblink('dbname=fac_ambiental host = 0.tcp.ngrok.io port= 10338 user=postgres password=postgres',
	'select * from lista_profesores')
	lista_ambiental (id_p bigint,nom_p varchar,cod_e bigint,nom_e varchar,
		cod_a bigint,nom_a varchar,grupo smallint,id_carr bigint,n1 numeric,n2 numeric,n3 numeric,
		definitiva numeric, concepto text);

--------------------------------------------
--Vista referencias: Universidad Distrital--
--------------------------------------------
create view ref_udistrital as
	select * from ref_ingenieria
	union
	select ref_cienc.* from
	dblink('dbname=fac_ciencias host= 0.tcp.ngrok.io port= 19670 user=postgres password=postgres',
	'select * from ref_ciencias')
	ref_cienc (cod_a bigint,nom_a varchar,isbn bigint,id_carr bigint)
	union
	select ref_medio_amb.* from
	dblink('dbname=fac_ambiental host = 0.tcp.ngrok.io port= 10338 user=postgres password=postgres',
	'select * from ref_ambiental') 
	ref_medio_amb (cod_a bigint,nom_a varchar,isbn bigint,id_carr bigint);

------------------------------------------
--Vista prestamos: Universidad Distrital--
------------------------------------------
create view prestamos_estudiante_remoto as
	select cod_e, isbn, titulo, num_ej, fecha_p, fecha_d 
	from presta natural join libros;
	
--------------------------------
--Vista prestamos: Estudiantes--
--------------------------------
create view prestamos_estudiante as
	select cod_e, isbn, titulo, num_ej, fecha_p, fecha_d 
	from presta natural join libros
	where cod_e::varchar = current_user;

---------
--Roles--
---------
-- Se crean los roles de usuario genéricos.
create or replace function crear_roles_genericos() returns VOID
as $$
declare
	codigos record;
begin
	if (
		select count(rolname) from pg_roles 
		where rolname='estudiante' 
	) = 0
	then
	execute 'CREATE ROLE estudiante';
	end if;
	
	if (
		select count(rolname) from pg_roles where rolname='profesor'  
	) = 0
	then
	execute 'CREATE ROLE profesor';
	end if;
	
	if (
		select count(rolname) from pg_roles where rolname='coordinador'  
	) = 0
	then
	execute 'CREATE ROLE coordinador WITH CREATEROLE';
	end if;
	if (
		SELECT count(rolname) from pg_roles where rolname='bibliotecario'  
	) = 0
	then
	execute 'CREATE USER bibliotecario PASSWORD ''bibliotecario''';	
	end if;
end;
$$ language plpgsql;

select * from crear_roles_genericos();

-----------------------
--Politicas de acceso--
-----------------------
------------------
--Rol Profesores--
------------------
--Consultar lista de estudiantes y notas de sus cursos
grant select on lista_prof_ing to profesor;
--Consultar libros y autores
grant select on libros to profesor;
grant select on autores to profesor;
grant select on escribe to profesor;
--Permiso para registrar actualizaciones en el log
grant insert on log_notas to profesor;
--Consultar datos del profesor
grant select on info_profes to profesor;
--Consultar y actualizar su informacion personal
grant update (dir_p, tel_p) on profesores to profesor;
--Politica de acceso profesores (actualiza)
create policy info_profes_upd on profesores for update to profesor using (id_p::varchar = current_user);
alter table profesores enable row level security;

------------------
--Rol Estudiante--
------------------
--Consultar sus notas
grant select on notas_ing to estudiante;
--Consultar libros y autores
grant select on escribe to estudiante;
grant select on autores to estudiante;
grant select on libros to estudiante;
--Consultar sus prestamos
grant select on prestamos_estudiante to estudiante;

---------------------
--Rol Bibliotecario--
---------------------
--Administra info de los prestamos
grant select,insert,update on presta to bibliotecario;
--Administra info de ejemplares
grant all on ejemplares to bibliotecario;
--Administra info de libros y autores
grant all on libros to bibliotecario;
grant all on autores to bibliotecario;
grant all on escribe to bibliotecario;

-------------------
--Rol Coordinador--
-------------------
--Administra info de las asignaturas que imparten los profesores y los grupos
grant all on imparte to coordinador;
--Consultar vista de estudiantes de la facultad
grant select on est_ing to coordinador;
--Consultar vista de inscipciones de la facultad
grant select on insc_ing to coordinador;
--Administra info de referencias
grant update,insert,delete on referencia to coordinador;
--Ingresa libros y autores
grant insert,delete,update on libros to coordinador;
grant insert,delete,update on autores to coordinador;
grant insert,delete,update on escribe to coordinador;
--Consultar listas de profesores con notas y estudiantes de su carrera
grant select on lista_coordinador to coordinador;
--Administra info de referencias
grant select on referencias_coordinador to coordinador;
--Permiso para registrar actualizaciones en el log
grant insert on log_notas to coordinador;

------------
--Usuarios--
------------
create or replace function usuario_coord() returns trigger as
$usuario_coord$
declare
	proyecto text;
begin
	execute 'CREATE USER "' || new.id_carr::varchar || '"WITH CREATEROLE PASSWORD ''' || new.id_carr::varchar || '''';
	execute 'GRANT coordinador TO "' || new.id_carr::varchar  || '"';
	if (lower(new.nom_carr) like '%electrica%') then
		proyecto := 'ing_electrica';
	elsif (lower(new.nom_carr) like '%electronica%') then
		proyecto := 'ing_electronica';
	elsif (lower(new.nom_carr) like '%catastral%') then
		proyecto := 'ing_catastral';
	elsif (lower(new.nom_carr) like '%sistemas%') then
		proyecto := 'ing_sistemas';
	elsif (lower(new.nom_carr) like '%industrial%') then
		proyecto := 'ing_industrial';
	elsif (lower(new.nom_carr) like '%maestria ciencias%') then
		proyecto := 'mcic';
	end if;	
	execute 'GRANT USAGE ON SCHEMA '||proyecto||' TO "'||new.id_carr::varchar||'"';
	--Administra info de estudiantes
	execute 'GRANT INSERT, DELETE, UPDATE (dir_e,tel_e) ON '||proyecto||'.estudiantes 
		TO "'||new.id_carr::varchar||'"';
	--Consulta las inscripciones y administra info de inscribe
	execute 'GRANT UPDATE (n1, n2, n3) ON '||proyecto||'.inscribe TO "'||new.id_carr::varchar||'"';
	return null;
end;
$usuario_coord$ language plpgsql;

create trigger usuario_coord after insert
	on carreras for each row execute procedure usuario_coord();

-------------------------------------
--Funcion y trigger: usuarios_est()--
-------------------------------------
create or replace function usuarios_est() returns trigger
as $usuarios_est$
declare
begin
	execute 'CREATE USER "' || new.cod_e::varchar || '" PASSWORD ''' || new.cod_e::varchar || '''';
	execute 'GRANT estudiante TO "' || new.cod_e::varchar  || '"';
	return null;
end;
$usuarios_est$ language plpgsql;

create trigger usuarios_est after insert
	on ing_catastral.estudiantes for each row execute procedure usuarios_est();

create trigger usuarios_est after insert
	on ing_electrica.estudiantes for each row execute procedure usuarios_est();

create trigger usuarios_est after insert
	on ing_electronica.estudiantes for each row execute procedure usuarios_est();

create trigger usuarios_est after insert
	on ing_sistemas.estudiantes for each row execute procedure usuarios_est();

create trigger usuarios_est after insert
	on ing_industrial.estudiantes for each row execute procedure usuarios_est();

create trigger usuarios_est after insert
	on mcic.estudiantes for each row execute procedure usuarios_est();

--------------------------------------
--Funcion y trigger: usuarios_prof()--
--------------------------------------
create or replace function usuarios_prof() returns trigger
as $usuarios_prof$
declare
begin
	execute 'CREATE USER "' || new.id_p::varchar || '" PASSWORD ''' || new.id_p::varchar || '''';
	execute 'GRANT profesor TO "' || new.id_p::varchar  || '"';	
	return null;
end;
$usuarios_prof$ language plpgsql;

create trigger usuarios_prof after insert
	on profesores for each row execute procedure usuarios_prof();

---------------------------------------------------------------------------
-- CREACIÓN DE PROCEDIMIENTOS ALMACENADOS PARA LA FACULTAD DE INGENIERIA --
---------------------------------------------------------------------------
--------------------------------------
--Trigger: trigger_ingresar_prestamo--
--------------------------------------
create or replace function trigger_ingresar_prestamo()
	returns trigger as $trigger_ingresar_prestamo$
	begin
		if (	
			select count(*) from public.est_udistrital 
			where cod_e = new.cod_e
		) <> 0 
		then
			return new;
		else
			return null;
		end if;
	end;
	$trigger_ingresar_prestamo$ language plpgsql;

create trigger trigger_ingresar_prestamo before insert or update 
	on public.presta for each row execute procedure trigger_ingresar_prestamo();
	
-------------------------------
--Trigger: actual_notas_log()--
-------------------------------
create or replace function actual_notas_log() returns
trigger as $actual_notas_log$
declare
begin
	if TG_OP = 'UPDATE' then
    insert into log_notas (comando, usuario, cod_e, id_p, cod_a, grupo, n1_old, n2_old, n3_old, n1_new, n2_new, n3_new)
    	values(TG_OP, cast(current_user as VARCHAR), new.cod_e, new.id_p, new.cod_a, new.grupo, old.n1, old.n2, old.n3, new.n1, new.n2, new.n3);
    end if;
	return null;
end;
$actual_notas_log$ language plpgsql;

create trigger actual_notas_log after update
	on ing_catastral.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on ing_sistemas.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on ing_industrial.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on ing_electrica.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on ing_electronica.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on mcic.inscribe for each row execute procedure actual_notas_log();
	
----------------------------------------------------------
-- Trigger Actualizar Notas (Profesores y Coordinadores)--
----------------------------------------------------------
CREATE OR REPLACE FUNCTION actualizar_notas() RETURNS TRIGGER AS $actualizar_notas$
BEGIN
	IF ( 
		-- Verifica si el usuario es un coordinador 
		SELECT count(*) FROM carreras where id_carr::varchar = current_user
	) <> 0
	THEN
		RETURN NEW;
	ELSE 
		-- Si no es un coordinador, entonces es un profesor
		IF ( 
			-- Verifica que el estudiante sea de la clase
			SELECT count(*) FROM lista_prof_ing 
			where cod_e=OLD.cod_e 
			and cod_a=OLD.cod_a 
			and grupo=OLD.grupo
		) <> 0 
		THEN
			RETURN NEW;
		ELSE
			RETURN NULL;
		END IF;	
	END IF;
END;
$actualizar_notas$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_notas BEFORE UPDATE
	ON ing_catastral.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();

CREATE TRIGGER actualizar_notas BEFORE UPDATE
	ON ing_sistemas.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();

CREATE TRIGGER actualizar_notas BEFORE UPDATE
	ON ing_electrica.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();

CREATE TRIGGER actualizar_notas BEFORE UPDATE
	ON ing_electronica.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();
	
-------------------------------------------------------------------------
-- Para el trigger actualizar_notas se requieren los siguientes permisos:
GRANT USAGE ON SCHEMA ing_catastral to profesor;
GRANT USAGE ON SCHEMA ing_sistemas to profesor;
GRANT USAGE ON SCHEMA ing_electrica to profesor;
GRANT USAGE ON SCHEMA ing_electronica to profesor;
GRANT USAGE ON SCHEMA ing_industrial to profesor;
GRANT USAGE ON SCHEMA mcic to profesor;

GRANT SELECT(cod_e,cod_a,grupo) ON ing_catastral.inscribe to profesor;
GRANT SELECT(cod_e,cod_a,grupo) ON ing_sistemas.inscribe to profesor;
GRANT SELECT(cod_e,cod_a,grupo) ON ing_electrica.inscribe to profesor;
GRANT SELECT(cod_e,cod_a,grupo) ON ing_electronica.inscribe to profesor;
GRANT SELECT(cod_e,cod_a,grupo) ON ing_industrial.inscribe to profesor;
GRANT SELECT(cod_e,cod_a,grupo) ON mcic.inscribe to profesor;

GRANT UPDATE(n1,n2,n3) ON ing_catastral.inscribe to profesor;
GRANT UPDATE(n1,n2,n3) ON ing_sistemas.inscribe to profesor;
GRANT UPDATE(n1,n2,n3) ON ing_electrica.inscribe to profesor;
GRANT UPDATE(n1,n2,n3) ON ing_electronica.inscribe to profesor;
GRANT UPDATE(n1,n2,n3) ON ing_industrial.inscribe to profesor;
GRANT UPDATE(n1,n2,n3) ON mcic.inscribe to profesor;

GRANT SELECT ON carreras TO estudiante;
GRANT SELECT ON carreras TO profesor;
GRANT SELECT ON carreras TO coordinador;
GRANT SELECT ON carreras TO bibliotecario;