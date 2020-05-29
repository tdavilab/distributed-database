-- MCIC-BD-PROYECTO FINAL

-- Christopher Giovanny Ortiz Montero 	Código: 20201495006
-- Joaquín Eduardo Caicedo Navarro		Código: 20201495001
-- Thomas Daniel Ávila Blenkey			Código: 20151020012

--------------------------------
-- FACULTAD DE MEDIO AMBIENTE --
--------------------------------

-- Se crean los esquemas de los proyectos curriculares.
CREATE SCHEMA ing_ambiental;
CREATE SCHEMA ing_forestal;
CREATE SCHEMA ing_sanitaria;
CREATE SCHEMA ing_topografica;

-- Se instala la extensión dblink
CREATE EXTENSION dblink;

-- DBLINK INGENIERIA
SELECT dblink_connect('fac_ingenieria','dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret');

---------------------------------------------------------
-- CREACIÓN DE TABLAS DE LA FACULTAD DE MEDIO AMBIENTE --
---------------------------------------------------------

-- Se ubica en el esquema "public" para la creación de las tablas generales de la facultad.
set search_path to public;

CREATE TABLE carreras (
	id_carr bigint PRIMARY KEY CHECK (id_carr >= 0),
	nom_carr varchar(70) NOT NULL UNIQUE,
	reg_cal bigint NOT NULL CHECK (reg_cal >= 0) UNIQUE
);

CREATE TABLE asignaturas (
	cod_a bigint PRIMARY KEY CHECK (cod_a >= 0),
	nom_a varchar(70) NOT NULL UNIQUE,
	int_h smallint NOT NULL CHECK (int_h >= 0),
	creditos smallint NOT NULL CHECK (creditos >= 0)
);

CREATE TABLE profesores (
	id_p bigint PRIMARY KEY CHECK (id_p >= 0),
	nom_p varchar(70) NOT NULL,
	dir_p varchar(70) NOT NULL,
	tel_p int NULL CHECK (tel_p >= 0),
	profesion varchar(70) NOT NULL
);

CREATE TABLE imparte (
	id_p bigint REFERENCES profesores (id_p),
	cod_a bigint REFERENCES asignaturas (cod_a),	
	grupo smallint CHECK (grupo >= 0),
    salon smallint NOT NULL CHECK (salon >= 0),
	horario varchar(70) NOT NULL,
	PRIMARY KEY (id_p, cod_a, grupo)
);

CREATE TABLE referencia (
	cod_a bigint REFERENCES asignaturas (cod_a),
	isbn bigint,
	PRIMARY KEY (cod_a, isbn)
);

CREATE TABLE presta (
	cod_e bigint,
	num_ej smallint,
	isbn bigint,
	fech_p date CHECK (fech_p BETWEEN '1900-01-01' AND NOW()),
	fech_d date NULL CHECK (fech_d >= fech_p),
	PRIMARY KEY (cod_e, num_ej, isbn, fech_p)
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


---------------------------------------------------------------------------
-- Función para crear la tabla "estudiantes" de cada proyecto curricular --
---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION crear_estudiantes(esquema text) RETURNS text AS $$
	DECLARE
		msg_out text DEFAULT 'Tabla estudiantes creada con éxito';
	BEGIN
		EXECUTE 'SET search_path TO ' || esquema;
		CREATE TABLE estudiantes (
			cod_e bigint PRIMARY KEY CHECK (cod_e >= 0),
			nom_e varchar NOT NULL,	
			dir_e varchar NOT NULL,
			tel_e int NULL CHECK (tel_e >= 0),
			fech_nac date NOT NULL CHECK (fech_nac BETWEEN '1900-01-01' AND NOW()),
			id_carr bigint NOT NULL REFERENCES public.carreras (id_carr)
		);
		SET search_path TO public;
		RETURN msg_out;
	END;
	$$ LANGUAGE plpgsql;

---------------------------------------------------------------------------
-- Función para crear la tabla "inscribe" de cada proyecto curricular --
---------------------------------------------------------------------------

CREATE OR REPLACE FUNCTION crear_inscribe(esquema varchar) RETURNS text AS $$
	DECLARE
		msg_out text DEFAULT 'Tabla inscribe creada con éxito';
	BEGIN
		EXECUTE 'SET search_path TO ' || esquema;
		CREATE TABLE inscribe (
			cod_e bigint REFERENCES estudiantes (cod_e),
			id_p bigint,
			cod_a bigint,
			grupo smallint,
			n1 numeric(2,1) NULL CHECK (n1 BETWEEN 0 AND 5),
			n2 numeric(2,1) NULL CHECK (n2 BETWEEN 0 AND 5),
			n3 numeric(2,1) NULL CHECK (n3 BETWEEN 0 AND 5),
			PRIMARY KEY (cod_e, id_p, cod_a, grupo),
			FOREIGN KEY (id_p, cod_a, grupo) REFERENCES public.imparte (id_p, cod_a, grupo) ON UPDATE CASCADE ON DELETE CASCADE,
			UNIQUE(cod_e, cod_a)
		);
		SET search_path TO public;
		RETURN msg_out;
	END;
	$$ LANGUAGE plpgsql;

------------------------------------
-- Tablas de ingeniería ambiental --
------------------------------------
-- Se crean las tablas "estudiantes" e "inscribe" con las funciones creadas.
SELECT * FROM crear_estudiantes('ing_ambiental');
SELECT * FROM crear_inscribe('ing_ambiental');

-----------------------------------
-- Tablas de ingeniería forestal --
-----------------------------------
-- Se crean las tablas "estudiantes" e "inscribe" con las funciones creadas.
SELECT * FROM crear_estudiantes('ing_forestal');
SELECT * FROM crear_inscribe('ing_forestal');

------------------------------------
-- Tablas de ingeniería sanitaria --
------------------------------------
-- Se crean las tablas "estudiantes" e "inscribe" con las funciones creadas.
SELECT * FROM crear_estudiantes('ing_sanitaria');
SELECT * FROM crear_inscribe('ing_sanitaria');

--------------------------------------
-- Tablas de ingeniería topográfica --
--------------------------------------
-- Se crean las tablas "estudiantes" e "inscribe" con las funciones creadas.
SELECT * FROM crear_estudiantes('ing_topografica');
SELECT * FROM crear_inscribe('ing_topografica');

---------------------------------------------------------------

---------------------------------------------------------
-- CREACIÓN DE VISTAS DE LA FACULTAD DE MEDIO AMBIENTE --
---------------------------------------------------------
--------------------------------
--Vista informacion profesores--
--------------------------------
create view info_profes as
	select * from profesores
	where id_p::varchar = current_user;

-----------------------
-- Vista Estudiantes --
-----------------------
-- Vista de todos los estudiantes (medio ambiente).
create view estudiantes_ambiental as
	select * from ing_ambiental.estudiantes
	union
	select * from ing_forestal.estudiantes
	union
	select * from ing_sanitaria.estudiantes
	union
	select * from ing_topografica.estudiantes;

--------------------
-- Vista Inscribe --
--------------------
-- Vista de las materias inscritas por todos los estudiantes (medio ambiente).
create view inscribe_ambiental as
	select * from ing_ambiental.inscribe
	union
	select * from ing_forestal.inscribe
	union
	select * from ing_sanitaria.inscribe
	union
	select * from ing_topografica.inscribe;

-----------------
-- Vista Notas --
-----------------
-- Para que cada estudiante pueda ver sus propias notas
create view notas_ambiental as
	select cod_e, nom_e, id_carr, cod_a, nom_a, grupo, n1, n2, n3, 
	coalesce(n1,0)*.35+coalesce(n2,0)*.35+coalesce(n3,0)*.3 def, 
	case coalesce(n1,0)*.35+coalesce(n2,0)*.35+coalesce(n3,0)*.3>=3 when true then 'aprobado' else 'reprobado' end as concepto
	from inscribe_ambiental natural join estudiantes_ambiental natural join asignaturas
	where cod_e::text = (select current_user) ;
	
------------------------
-- Vista Lista Clases --
------------------------
-- Para que cada profesor pueda ver las clases que tiene asignadas
create view lista_clases_ambiental as
	select id_p, nom_p, cod_a, nom_a, grupo, id_carr, cod_e, nom_e, n1, n2, n3
	from profesores natural join inscribe_ambiental natural join estudiantes_ambiental natural join asignaturas
	where id_p::text = (select current_user) ;

----------------------------------------------------
-- Consulta Coordinador: Profesores de la Carrera --
----------------------------------------------------
-- Para que el coordinador pueda ver la lista de los profesores de la carrera
create view lista_coordinador as
	select id_p, nom_p, cod_a, nom_a, grupo, id_carr, cod_e, nom_e, n1, n2, n3
	from profesores natural join inscribe_ambiental natural join estudiantes_ambiental natural join asignaturas
	where id_carr::text = (select current_user);

-----------------------------------------------------
-- Consulta Coordinador: Referencias de la Carrera --
-----------------------------------------------------
-- Vista con las asignaturas, libros y referencias específicas para la carrera del coordinador
create view referencias_coordinador as
	select distinct cod_a, nom_a, isbn, id_carr from inscribe_ambiental natural join asignaturas 
	natural join referencia natural join estudiantes_ambiental natural join carreras
	where id_carr::text = (select current_user);

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
	from profesores natural join inscribe_ambiental natural join estudiantes_ambiental natural join asignaturas;

----------------------------------------------------------------
-- Vista para obtener los libros de la facultad de ingenieria --
----------------------------------------------------------------
create view libros as
	select e.* from
	dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
		'select * from public.libros') e (isbn bigint, titulo varchar, edicion smallint, editorial varchar);

-----------------------------------------------------------------
-- Vista para obtener los autores de la facultad de ingenieria --
-----------------------------------------------------------------
create view autores as
	select e.* from
	dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
		'select * from public.autores') e (id_a bigint, nom_autor varchar, nacionalidad varchar);

----------------------------------------------------------------------
-- Vista para obtener la tabla escribe de la facultad de ingenieria --
----------------------------------------------------------------------
create view escribe as
	select e.* from
	dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
		'select * from public.escribe') e (id_a bigint, isbn bigint);

-----------------------------------------------------
-- Vista para obtener los prestamos del estudiante --
-----------------------------------------------------
create view prestamos_estudiante as
	select e.* from
	dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
		'select * from public.prestamos_estudiante')
		e (cod_e bigint, isbn bigint, titulo varchar, num_ej integer, fecha_p date, fecha_d date);
	where cod_e::text=(select current_user);

-----------------------------------------------------------------------------

-----------------------------------------------------------------------
-- CREACIÓN DE USUARIOS Y ACCESOS PARA LA FACULTAD DE MEDIO AMBIENTE --
-----------------------------------------------------------------------

---------
--Roles--
---------
-- Se crean los roles de usuario genéricos.
CREATE OR REPLACE FUNCTION crear_roles_genericos() RETURNS VOID
AS $crear_roles_genericos$
DECLARE
	codigos RECORD;
BEGIN
	IF (
		SELECT count(rolname) from pg_roles 
		where rolname='estudiante' 
	) = 0
	THEN	
	EXECUTE 'CREATE ROLE estudiante LOGIN';
	END IF;
	
	IF (
		SELECT count(rolname) from pg_roles where rolname='profesor'  
	) = 0
	THEN
	EXECUTE 'CREATE ROLE profesor LOGIN';
	END IF;
	
	IF (
		SELECT count(rolname) from pg_roles where rolname='coordinador'  
	) = 0
	THEN
	EXECUTE 'CREATE ROLE coordinador WITH LOGIN CREATEROLE';
	END IF;
	IF (
		SELECT count(rolname) from pg_roles where rolname='bibliotecario'  
	) = 0
	THEN
	EXECUTE 'CREATE USER bibliotecario PASSWORD ''bibliotecario''';	
	END IF;
END;
$crear_roles_genericos$ LANGUAGE plpgsql;

-----------------------
--Politicas de acceso--
-----------------------
------------------
--Rol Profesores--
------------------
--Concede acceso al profesor en vista/tabla libros
grant select on libros to profesor;
--Concede acceso al profesor en vista/tabla autores
grant select on autores to profesor;
--Concede acceso al profesor en vista/tabla escribe
grant select on escribe to profesor;
--Concede acceso al profesor en vista escribe
grant select on lista_clases_ambiental to profesor;
--Consultar datos del profesor
grant select on info_profes to profesor;
--Consultar y actualizar su informacion personal
grant update (dir_p, tel_p) on profesores to profesor;
--Politica de acceso profesores (actualiza)
create policy info_profes_upd on profesores for update to profesor using (id_p::varchar = current_user);
alter table profesores enable row level security;

-------------------
--Rol Coordinador--
-------------------
--Concede acceso al coordinador en vista/tabla libros
grant select on libros to coordinador;
--Concede acceso al coordinador en vista/tabla autores
grant select on autores to coordinador;
--Concede acceso al coordinador en vista/tabla escribe
grant select on escribe to coordinador;
--Concede acceso al coordinador en tabla imparte
grant insert, update, delete,select on public.imparte to coordinador;
--Concede acceso al coordinador en vista estudiantes_ambiental
grant select on public.estudiantes_ambiental to coordinador;
--Concede acceso al coordinador en vista inscribe_ambiental
grant select on public.inscribe_ambiental to coordinador;
--Concede acceso al coordinador en vista lista_coordinador
grant select on public.lista_coordinador to coordinador;
--Concede acceso al coordinador en tabla referencia (puede actualizar, insertar y borrar, pero sólo las de su carrera. Esto es controlado con triggers)
grant update,insert, delete,select on public.referencia to coordinador; ----------- CAMBIO, SE QUITÓ EL GRANT ALL
--Concede acceso al coordinador en vista referencias_coordinador (ver las referencias sólo de su carrera)
grant select on public.referencias_coordinador to coordinador;
--Permiso para registrar actualizaciones en el log
grant insert on log_notas to coordinador;

-------------------
--Rol Estudiantes--
-------------------
--Concede acceso al estudiante en vista notas
GRANT SELECT ON notas_ambiental TO estudiante;
--Concede acceso al estudiante en vista/tabla libros
grant select on libros to estudiante;
--Concede acceso al estudiante en vista/tabla autores
grant select on autores to estudiante;
--Concede acceso al estudiante en vista/tabla escribe
grant select on escribe to estudiante;
--Concede acceso al estudiante en vista prestamos_estudiante
grant select on prestamos_estudiante to estudiante;

---------------------
--Rol Bibliotecario--
---------------------
--Concede acceso al estudiante en vista/tabla libros
grant select on libros to bibliotecario;
--Concede acceso al estudiante en vista/tabla autores
grant select on autores to bibliotecario;
--Concede acceso al estudiante en vista/tabla escribe
grant select on escribe to bibliotecario;
--INGENIERIA: grant select on ejemplares to bibliotecario;
--INGENIERIA: grant select on presta to bibliotecario;
--INGENIERIA: grant insert on autores to bibliotecario;
--INGENIERIA: grant insert on escribe to bibliotecario;
--INGENIERIA: grant insert on escribe to bibliotecario;

-----------------------------------------------
-- Trigger para crear roles de coordinadores --
-----------------------------------------------

CREATE OR REPLACE FUNCTION crear_rol_coordinador() RETURNS TRIGGER AS
	$crear_rol_coordinador$
	DECLARE
		proyecto text;
	BEGIN
		EXECUTE 'CREATE USER "' || NEW.id_carr::varchar || '" WITH CREATEROLE PASSWORD ''' || NEW.id_carr::varchar || '''';
		EXECUTE 'GRANT coordinador TO "' || NEW.id_carr::varchar  || '"';

		IF (lower(NEW.nom_carr) like '%ambiental%') THEN
			proyecto := 'ing_ambiental';
		ELSIF (lower(NEW.nom_carr) like '%forestal%') THEN
			proyecto := 'ing_forestal';
		ELSIF (lower(NEW.nom_carr) like '%sanitaria%') THEN
			proyecto := 'ing_sanitaria';
		ELSIF (lower(NEW.nom_carr) like '%topografica%') THEN
			proyecto := 'ing_topografica';
		ELSIF (lower(NEW.nom_carr) like '%quimica%') THEN
			proyecto := 'lic_quimica';
		END IF;	
		EXECUTE 'GRANT USAGE ON SCHEMA '||proyecto||' to "'||NEW.id_carr::varchar||'"';
		EXECUTE 'GRANT SELECT, INSERT, DELETE, UPDATE ON '||proyecto||'.estudiantes TO "'||NEW.id_carr::varchar||'"';
		EXECUTE 'GRANT SELECT ON '||proyecto||'.inscribe TO "'||NEW.id_carr::varchar||'"';
		EXECUTE 'GRANT UPDATE(n1) ON '||proyecto||'.inscribe TO "'||NEW.id_carr::varchar||'"';
		EXECUTE 'GRANT UPDATE(n2) ON '||proyecto||'.inscribe TO "'||NEW.id_carr::varchar||'"';
		EXECUTE 'GRANT UPDATE(n3) ON '||proyecto||'.inscribe TO "'||NEW.id_carr::varchar||'"';
		RETURN NULL;
	END;
	$crear_rol_coordinador$ LANGUAGE plpgsql;

CREATE TRIGGER crear_rol_coordinador AFTER INSERT
	ON carreras FOR EACH ROW EXECUTE PROCEDURE crear_rol_coordinador();

--------------------------------------------
-- Trigger para crear roles de profesores --
--------------------------------------------

CREATE OR REPLACE FUNCTION crear_rol_profesor() RETURNS TRIGGER AS
	$crear_rol_profesor$
	BEGIN
		EXECUTE 'CREATE USER "' || NEW.id_p::varchar || '" PASSWORD ''' || NEW.id_p::varchar || '''';
		EXECUTE 'GRANT profesor TO "' || NEW.id_p::varchar  || '"';
		RETURN NULL;
	END;
	$crear_rol_profesor$ LANGUAGE plpgsql;

CREATE TRIGGER crear_rol_profesor AFTER INSERT
	ON profesores FOR EACH ROW EXECUTE PROCEDURE crear_rol_profesor();
	
---------------------------------------------
-- Trigger para crear roles de estudiantes --
---------------------------------------------


CREATE OR REPLACE FUNCTION crear_rol_estudiante() RETURNS TRIGGER AS
	$crear_rol_estudiante$
	BEGIN
		EXECUTE 'CREATE USER "' || NEW.cod_e::varchar || '" PASSWORD ''' || NEW.cod_e::varchar || '''';
		EXECUTE 'GRANT estudiante TO "' || NEW.cod_e::varchar  || '"';
		RETURN NULL;
	END;
	$crear_rol_estudiante$ LANGUAGE plpgsql;

CREATE TRIGGER crear_rol_estudiante AFTER INSERT
	ON ing_ambiental.estudiantes FOR EACH ROW EXECUTE PROCEDURE crear_rol_estudiante();
	
CREATE TRIGGER crear_rol_estudiante AFTER INSERT
	ON ing_forestal.estudiantes FOR EACH ROW EXECUTE PROCEDURE crear_rol_estudiante();
	
CREATE TRIGGER crear_rol_estudiante AFTER INSERT
	ON ing_sanitaria.estudiantes FOR EACH ROW EXECUTE PROCEDURE crear_rol_estudiante();
	
CREATE TRIGGER crear_rol_estudiante AFTER INSERT
	ON ing_topografica.estudiantes FOR EACH ROW EXECUTE PROCEDURE crear_rol_estudiante();


-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- CREACIÓN DE PROCEDIMIENTOS ALMACENADOS PARA LA FACULTAD DE MEDIO AMBIENTE --
-------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- Función para registrar préstamos de libros desde facultades diferentes a ingeniería --
-----------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION registrar_prestamo (
	IN codigo bigint, IN ejemplar int, IN cod_libro bigint, IN fecha_p varchar) 
	RETURNS text AS $$
	BEGIN
		RETURN (
			SELECT e.* FROM
				dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
					   'INSERT INTO presta VALUES (' || codigo || ',' || ejemplar || ',' 
					   || cod_libro || ',''' || fecha_p || ''', NULL)') e(salida text)
		);
	END; $$
	LANGUAGE plpgsql;

--------------------------------------------------------------------------------------------
-- Función para registrar devoluciones de libros desde facultades diferentes a ingeniería --
--------------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION registrar_devolucion (
	IN codigo bigint, IN ejemplar int, IN cod_libro bigint, IN fecha_p varchar, IN fecha_d varchar) 
	RETURNS text AS $$
	BEGIN
		RETURN (
			SELECT e.* FROM
			dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
				   'UPDATE presta SET fech_d = ''' || fecha_d || 
				   ''' WHERE cod_e = ' || codigo || ' AND num_ej = ' || ejemplar || ' AND isbn = ' ||
				   cod_libro || ' AND fech_p = ''' || fecha_p || '''')  e(salida text)
		);
	END; $$
	LANGUAGE plpgsql;


----------------------------------------------------------
-- Coordinador: Trigger para aministrar la tabla imparte --
-----------------------------------------------------------
/*
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
			select count(*) from public.referencias_coordinador 
			where cod_a = old.cod_a
			and isbn = old.isbn
		) <> 0 
		THEN
			IF TG_OP = 'UPDATE' THEN
				IF ( SELECT count(isbn) FROM libros WHERE isbn = NEW.isbn ) <> 0
				THEN
					RETURN NEW;
				ELSE
					RETURN NULL;
				END IF;
			ELSIF TG_OP = 'DELETE' THEN
				RETURN OLD;
			END IF;
		ELSE
			RETURN NULL;
		END IF;
	END;
	$actualizar_referencias_coordinador$ LANGUAGE plpgsql;
CREATE TRIGGER actualizar_referencias_coordinador BEFORE UPDATE OR DELETE
	ON public.referencia FOR EACH ROW
	EXECUTE PROCEDURE actualizar_referencias_coordinador();
*/

-----------------------------------------------------------------------------------------
-- Trigger Verificar Ingreso de Referencia  --
-----------------------------------------------------------------------------------------

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
	ON public.referencia FOR EACH ROW
	EXECUTE PROCEDURE trigger_ingresar_referencia();



----------------------------------------------------------------------------
-- Función para agregar ejemplar desde facultades diferentes a ingeniería --
----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION agregar_ejemplar (
	IN i_num_ej bigint, IN cod_libro bigint) 
	RETURNS text AS $$
	BEGIN
		RETURN (
			SELECT e.* FROM
				dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
					   'INSERT INTO ejemplares (num_ej, isbn) VALUES (' || i_num_ej || ',' || cod_libro || ')') e(salida text)
		);
	END; $$
	LANGUAGE plpgsql;

-- PRUEBA:
--select * from agregar_ejemplar(3,100101601)

--------------------------------------------------------------------------
-- Función para borrar libros desde facultades diferentes a ingeniería --
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION borrar_libro (
	IN cod_libro bigint) 
	RETURNS text AS $$
	BEGIN
		RETURN (
			SELECT e.* FROM
				dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
					   'DELETE FROM libros WHERE isbn='||cod_libro) e(salida text)
		);
	END; $$
	LANGUAGE plpgsql;

-- PRUEBA:
-- select * from borrar_libro(100101999);

--------------------------------------------------------------------------
-- Función para borrar autores desde facultades diferentes a ingeniería --
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION borrar_autor (
	IN id_aut bigint) 
	RETURNS text AS $$
	BEGIN
		RETURN (
			SELECT e.* FROM
				dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
					   'DELETE FROM autores WHERE id_a='||id_aut) e(salida text)
		);
	END; $$
	LANGUAGE plpgsql;

-- PRUEBA:
--select * from borrar_autor(1000099)

--------------------------------------------------------------------------
-- Función para borrar escribe desde facultades diferentes a ingeniería --
--------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION borrar_escribe (
	IN id_aut bigint, IN cod_libro bigint) 
	RETURNS text AS $$
	BEGIN
		RETURN (
			SELECT e.* FROM
				dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
					   'DELETE FROM escribe WHERE isbn='||cod_libro||'AND id_a='||id_aut) e(salida text)
		);
	END; $$
	LANGUAGE plpgsql;

-- PRUEBA:
--select * from borrar_escribe(1000099,100101999)

---------------------------------------------------------------------------
-- Función para borrar ejemplar desde facultades diferentes a ingeniería --
---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION borrar_ejemplar (
	IN i_num_ej bigint, IN cod_libro bigint) 
	RETURNS text AS $$
	BEGIN
		RETURN (
			SELECT e.* FROM
				dblink('dbname=fac_ingenieria host=0.tcp.ngrok.io port=10012 user=postgres password=supersecret',
					   'DELETE FROM ejemplares WHERE isbn='||cod_libro||'AND num_ej='||i_num_ej) e(salida text)
		);
	END; $$
	LANGUAGE plpgsql;

-- PRUEBA:
--select * from borrar_ejemplar(3,100101601)


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
			SELECT count(*) FROM lista_clases_ambiental 
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
	ON ing_ambiental.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();

CREATE TRIGGER actualizar_notas BEFORE UPDATE
	ON ing_sanitaria.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();

CREATE TRIGGER actualizar_notas BEFORE UPDATE
	ON ing_forestal.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();

CREATE TRIGGER actualizar_notas BEFORE UPDATE
	ON ing_topografica.inscribe FOR EACH ROW
	EXECUTE PROCEDURE actualizar_notas();




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
	on ing_ambiental.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on ing_sanitaria.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on ing_forestal.inscribe for each row execute procedure actual_notas_log();
create trigger actual_notas_log after update
	on ing_topografica.inscribe for each row execute procedure actual_notas_log();

---------------------------------------------------------------------------------------------------------------


-----------------------------------------------
-- PRIVILEGIOS EN PROCEDIMIENTOS ALMACENADOS --
-----------------------------------------------

-------------------
-- BIBLIOTECARIO --
-------------------

grant execute on function registrar_prestamo(bigint, int, bigint, varchar) to bibliotecario;
grant execute on function registrar_devolucion(bigint, int, bigint, varchar, varchar) to bibliotecario;

grant execute on function agregar_libro(bigint,varchar,int,varchar) to bibliotecario;
grant execute on function agregar_autor(bigint,varchar,varchar) to bibliotecario;
grant execute on function agregar_escribe(bigint, bigint) to bibliotecario;

grant execute on function agregar_ejemplar(bigint, bigint) to bibliotecario;

grant execute on function borrar_libro(bigint) to bibliotecario;
grant execute on function borrar_autor(bigint) to bibliotecario;
grant execute on function borrar_escribe(bigint, bigint) to bibliotecario;
grant execute on function borrar_ejemplar(bigint, bigint) to bibliotecario;

grant execute on function actualizar_libro(bigint) to bibliotecario;
grant execute on function actualizar_autor(bigint) to bibliotecario;

-----------------
-- COORDINADOR --
-----------------
grant execute on function agregar_libro(bigint,varchar,int,varchar) to coordinador;
grant execute on function agregar_autor(bigint,varchar,varchar) to coordinador;
grant execute on function agregar_escribe(bigint, bigint) to coordinador;

grant execute on function actualizar_libro(bigint) to bibliotecario;
grant execute on function actualizar_autor(bigint) to bibliotecario;


-------------------------------------------------------------------------
-- Para el trigger actualizar_notas se requieren los siguientes permisos:

GRANT USAGE ON SCHEMA ing_ambiental to profesor;
GRANT USAGE ON SCHEMA ing_sanitaria to profesor;
GRANT USAGE ON SCHEMA ing_forestal to profesor;
GRANT USAGE ON SCHEMA ing_topografica to profesor;

GRANT SELECT(cod_e, cod_a, grupo) ON ing_ambiental.inscribe to profesor;
GRANT SELECT(cod_e, cod_a, grupo) ON ing_sanitaria.inscribe to profesor;
GRANT SELECT(cod_e, cod_a, grupo) ON ing_forestal.inscribe to profesor;
GRANT SELECT(cod_e, cod_a, grupo) ON ing_topografica.inscribe to profesor;

GRANT UPDATE(n1, n2, n3) ON ing_ambiental.inscribe to profesor;
GRANT UPDATE(n1, n2, n3) ON ing_sanitaria.inscribe to profesor;
GRANT UPDATE(n1, n2, n3) ON ing_forestal.inscribe to profesor;
GRANT UPDATE(n1, n2, n3) ON ing_topografica.inscribe to profesor;


GRANT SELECT ON carreras TO estudiante;
GRANT SELECT ON carreras TO profesor;
GRANT SELECT ON carreras TO coordinador;
GRANT SELECT ON carreras TO bibliotecario;