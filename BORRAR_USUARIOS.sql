-- MCIC-BD-PROYECTO FINAL

-- Christopher Giovanny Ortiz Montero 		Código: 20201495006
-- Joaquín Eduardo Caicedo Navarro		Código: 20201495001
-- Thomas Daniel Ávila Blenkey			Código: 20151020012

--------------------------------------
-- BORRAR TODOS LOS ROLES NUMERICOS --
--------------------------------------

-- Borra los usuarios que son de forma numérica (estudiantes, profesores, coordinadores)
-- Ejecutar esto después de haber borrado las 3 bases de datos ambiental, ciencias e ingeniería

CREATE OR REPLACE FUNCTION borrar_roles ()
	RETURNS void
	AS $$
	DECLARE
		rol text;
	BEGIN
		FOR rol IN (
			select rolname::text from pg_roles
		)LOOP	
		IF (select rol ~ '^[0-9\.]+$')
		THEN
			EXECUTE 'drop role "'||rol||'"';
		END IF;
		END LOOP;
END; $$	LANGUAGE plpgsql;

select * from borrar_roles();

DROP ROLE coordinador;
DROP ROLE bibliotecario;
DROP ROLE estudiante;
DROP ROLE profesor;