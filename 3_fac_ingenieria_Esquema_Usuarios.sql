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

set search_path to public;
show search_path;

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
		
--Conexion a bases de datos de otras facultades
select dblink_connect('fac_cienc','dbname=fac_ciencias port= 5432 user=postgres password=postgres');
select dblink_connect('fac_ambiente','dbname=fac_ambiental port= 5432 user=postgres password=postgres');

--------------------------------------------
--Tabla estudiantes: Universidad Distrital--
--------------------------------------------

create view est_udistrital as
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
	select * from mcic.estudiantes
	union
	select est_cienc.* from
	dblink('dbname=fac_ciencias port= 5432 user=postgres password=postgres',
	'select * from lic_biologia.estudiantes
	union
	select * from lic_c_sociales.estudiantes
	union
	select * from lic_fisica.estudiantes
	union
	select * from lic_matematicas.estudiantes
	union
	select * from lic_quimica.estudiantes') 
	est_cienc (cod_e bigint,nom_e varchar,dir_e varchar,tel_est bigint,fech_nac date,id_carr bigint)
	union
	select est_medio_amb.* from
	dblink('dbname=fac_ambiental port= 5432 user=postgres password=postgres',
	'select * from ing_ambiental.estudiantes
	union
	select * from ing_forestal.estudiantes
	union
	select * from ing_sanitaria.estudiantes
	union
	select * from ing_topografica.estudiantes') 
	est_medio_amb (cod_e bigint,nom_e varchar,dir_e varchar,tel_est bigint,fech_nac date,id_carr bigint);


-------------------
--Relación presta--
-------------------
create table presta(
	cod_e bigint,
	isbn bigint,
	num_ej int,
	fecha_p date not null check (fecha_p between '1900-01-01' and now()),
	fecha_d date null check (fecha_d >= fecha_p),
	primary key (cod_e, isbn, num_ej, fecha_p),
	foreign key (isbn, num_ej) references ejemplares (isbn, num_ej)
);



------------------------------------------
--Vista prestamos: Universidad Distrital--
------------------------------------------
create view prestamos_estudiante as
	select cod_e, isbn, titulo, num_ej, fecha_p, fecha_d 
	from presta natural join libros
	where cod_e::text = current_user;


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
	execute 'CREATE ROLE estudiante LOGIN';
	end if;
	
	if (
		select count(rolname) from pg_roles where rolname='profesor'  
	) = 0
	then
	execute 'CREATE ROLE profesor LOGIN';
	end if;
	
	if (
		select count(rolname) from pg_roles where rolname='coordinador'  
	) = 0
	then
	execute 'CREATE ROLE coordinador WITH LOGIN CREATEROLE';
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
--Politica de acceso profesores (consulta)
CREATE POLICY info_profes_sel ON profesores FOR SELECT TO profesor USING (id_p::varchar = CURRENT_USER);
--Politica de acceso profesores (actualiza)
CREATE POLICY info_profes_upd ON profesores FOR UPDATE TO profesor USING (id_p::varchar = CURRENT_USER);
--Habilito el RLS
ALTER TABLE profesores ENABLE ROW LEVEL SECURITY;
grant select on libros to profesor;
grant select on autores to profesor;
grant select on escribe to profesor;

------------------
--Rol Estudiante--
------------------
grant select on escribe to estudiante;
grant select on autores to estudiante;
grant select on libros to estudiante;
grant select on escribe to estudiante;
grant select on prestamos_estudiante to estudiante;
--grant select on notas_ambiental to estudiante;

---------------------
--Rol Bibliotecario--
---------------------
grant select on libros to bibliotecario;
grant select on autores to bibliotecario;
grant select on escribe to bibliotecario;

-------------------
--Rol Coordinador--
-------------------
grant insert, update, delete on public.imparte to coordinador;
--grant select on public.estudiantes_ambiental to coordinador;
--grant select on public.inscribe_ambiental to coordinador;
grant select on public.lista_coordinador to coordinador;
grant insert,update,delete on public.referencia to coordinador;
grant insert, select on public.libros to coordinador;
grant insert, select on public.autores to coordinador;
grant select on public.referencias_coordinador to coordinador;

------------
--Usuarios--
------------
CREATE OR REPLACE FUNCTION crear_rol_coordinador() RETURNS TRIGGER AS
	$crear_rol_coordinador$
	DECLARE
		proyecto text;
	BEGIN
		EXECUTE 'CREATE USER "' || NEW.id_carr::varchar || '"WITH CREATEROLE PASSWORD ''' || NEW.id_carr::varchar || '''';
		EXECUTE 'GRANT coordinador TO "' || NEW.id_carr::varchar  || '"';

		IF (lower(NEW.nom_carr) like '%electrica%') THEN
			proyecto := 'ing_electrica';
		ELSIF (lower(NEW.nom_carr) like '%electronica%') THEN
			proyecto := 'ing_electronica';
		ELSIF (lower(NEW.nom_carr) like '%catastral%') THEN
			proyecto := 'ing_catastral';
		ELSIF (lower(NEW.nom_carr) like '%sistemas%') THEN
			proyecto := 'ing_sistemas';
		ELSIF (lower(NEW.nom_carr) like '%maestria ciencias%') THEN
			proyecto := 'mcic';
		END IF;	
		EXECUTE 'GRANT USAGE ON SCHEMA '||proyecto||' to "'||NEW.id_carr::varchar||'"';
		EXECUTE 'GRANT SELECT, INSERT, DELETE, UPDATE ON '||proyecto||'.estudiantes TO "'||NEW.id_carr::varchar||'"';
		EXECUTE 'GRANT SELECT, UPDATE, DELETE ON '||proyecto||'.inscribe TO "'||NEW.id_carr::varchar||'"';
		RETURN NULL;
	END;
	$crear_rol_coordinador$ LANGUAGE plpgsql;

CREATE TRIGGER crear_rol_coordinador AFTER INSERT
	ON carreras FOR EACH ROW EXECUTE PROCEDURE crear_rol_coordinador();

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

CREATE OR REPLACE FUNCTION trigger_ingresar_prestamo ()
	RETURNS TRIGGER AS $trigger_ingresar_prestamo$
	BEGIN
		IF (	
			select count(*) from public.est_udistrital 
			where cod_e = new.cod_e
		) <> 0 
		THEN
			RETURN NEW;
		ELSE
			RETURN NULL;
		END IF;
	END;
	$trigger_ingresar_prestamo$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_ingresar_prestamo BEFORE INSERT OR UPDATE 
	ON public.presta FOR EACH ROW
	EXECUTE PROCEDURE trigger_ingresar_prestamo();

----------------------------------------------------------
-- Coordinador: Trigger para aministrar la tabla imparte --
-----------------------------------------------------------
--COORDINADOR: Administra la información de las asignaturas que imparten los profesores y los grupos
-- Verifica que el registro a modificar/borrar sea parte de la carrera del coordinador
CREATE OR REPLACE FUNCTION actualizar_imparte_coordinador ()
	RETURNS TRIGGER AS $actualizar_imparte_coordinador$
	BEGIN
		IF (	
			select count(id_p) from public.lista_coordinador 
			where id_p = old.id_p
			and cod_a = old.cod_a
			and grupo = old.grupo
		) <> 0 
		THEN
			IF TG_OP = 'UPDATE' THEN
				RETURN NEW;
			ELSIF TG_OP = 'DELETE' THEN
				RETURN OLD;
			END IF;
		ELSE
			RETURN NULL;
		END IF;
	END;
	$actualizar_imparte_coordinador$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_imparte_coordinador BEFORE UPDATE OR DELETE
	ON public.imparte FOR EACH ROW
	EXECUTE PROCEDURE actualizar_imparte_coordinador();

-----------------------------------------------------------
-- Coordinador: Trigger para administrar las referencias --
-----------------------------------------------------------
-- Verifica que el registro a modificar/borrar sea parte de referencias de las asignaturas del coordinador
CREATE OR REPLACE FUNCTION actualizar_referencias_coordinador ()
	RETURNS TRIGGER AS $actualizar_referencias_coordinador$
	BEGIN
		IF (	
			select count(id_p) from public.referencias_coordinador 
			where cod_a = old.cod_a
			and isbn = old.isbn
		) <> 0 
		THEN
			IF TG_OP = 'UPDATE' THEN
				RETURN NEW;
			ELSIF TG_OP = 'DELETE' THEN
				RETURN OLD;
			END IF;
		ELSE
			RETURN NULL;
		END IF;
	END;
	$actualizar_referencias_coordinador$ LANGUAGE plpgsql;

CREATE TRIGGER actualizar_referencias_coordinador BEFORE UPDATE OR DELETE
	ON referencia FOR EACH ROW
	EXECUTE PROCEDURE actualizar_referencias_coordinador();

----------------------------------------------
-- Trigger Verificar Ingreso de Referencia  --
----------------------------------------------
-- Trigger ejecutado cuando se ingresa una referencia, para verificar que el libro exista
CREATE OR REPLACE FUNCTION trigger_ingresar_referencia ()
	RETURNS TRIGGER AS $trigger_ingresar_referencia$
	BEGIN
		IF ( SELECT count(isbn) FROM libros WHERE isbn = NEW.isbn ) <> 0
			THEN
				RETURN NEW;
			ELSE
				RETURN NULL;
		END IF;

	END;
	$trigger_ingresar_referencia$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_ingresar_referencia BEFORE INSERT
	ON referencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_ingresar_referencia();