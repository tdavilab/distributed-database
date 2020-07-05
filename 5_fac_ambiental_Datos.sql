---------------------------------------------------------------------
-- INGRESO DE DATOS EN LAS TABLAS DE LA FACULTAD DE MEDIO AMBIENTE --
---------------------------------------------------------------------

set search_path to public;

insert into carreras (id_carr, nom_carr, reg_cal)values 
	(20001,'Ingenieria de Ambiental', 205031),
	(20002,'Ingenieria Forestal', 205032),
	(20003,'Ingenieria Sanitaria', 205033),
	(20004,'Ingenieria Topografica', 205034);

insert into asignaturas(cod_a, nom_a, int_h, creditos) values
	(2001,'Bioquimica',4,3),
	(2002,'Microbiologia',3,2),
	(2003,'Biotecnologia',4,5),
	(2004,'Botanica Taxonomica',2,4),
	(2005,'Suelos I',1,2),
	(2006,'Acueductos',2,3),
	(2007,'Emisiones Atmostfericas',4,3),
	(2008,'Sistemas de Información Geografica',4,4),
	(2009,'Cartografia',4,3); 

insert into profesores(id_p, nom_p, dir_p, tel_p, profesion) values 
	(110031,'Profesor Ambiental 1','Direccion P31', 1212122, 'P31'),
	(110032,'Profesor Ambiental 2','Direccion P32', 3543445, 'P32'),
	(110033,'Profesor Ambiental 3','Direccion P33', 6541166, 'P33'),
	(110034,'Profesor Ambiental 4','Direccion P34', 5555555, 'P34'),
	(110035,'Profesor Ambiental 5','Direccion P35', 6666666, 'P35'),
	(110036,'Profesor Ambiental 6','Direccion P36', 1212121, 'P36'),
	(110037,'Profesor Ambiental 7','Direccion P37', 5455544, 'P37'),
	(110038,'Profesor Ambiental 8','Direccion P38', 6665554, 'P38'),
	(110039,'Profesor Ambiental 9','Direccion P39', 1234778, 'P39');

insert into imparte(id_p, cod_a, grupo, salon, horario) values
	(110031,2001,1,212,'L-8-10 J-10-12'),
	(110032,2001,2,304,'L-3-4 J-12-2'),
	(110032,2002,1,101,'L-4-5 J-11-12'),
	(110033,2003,1,303,'L-12-14 R-14-16 V-13-14'),
	(110031,2003,2,402,'L-10-12 R-16-18'),
	(110034,2004,1,500,'L-8-10 J-10-12'),
	(110035,2005,1,401,'V-8-10 S-10-12'),
	(110036,2006,1,123,'L-2-4 L 4-6'),
	(110037,2006,2,412,'L-10-12 M-8-10'),
	(110038,2007,1,344,'L-3-4 J-12-2'),
	(110039,2008,1,301,'L-4-5 J-11-12'),
	(110039,2009,1,302,'L-12-14 R-14-16 V-13-14');

INSERT INTO referencia (cod_a, isbn) VALUES
	(2001, 100100900),
	(2001, 100111000),
	(2002, 100100700);


--------------------------
-- Tablas Ing Ambiental --
--------------------------

insert into ing_ambiental.estudiantes (cod_e , nom_e, dir_e, tel_e, id_carr, fech_nac) values 
	(200011,'Estudiante Ambiental 1','direccion E20',null,20001,'12/11/1997'),
	(200012,'Estudiante Ambiental 2','direccion E21',2121210,20001,'30/03/1999'),
	(200013,'Estudiante Ambiental 3','direccion E21',2121210,20001,'30/03/1999'),
	(200014,'Estudiante Ambiental 4','direccion E21',2121210,20001,'30/03/1999');

insert into ing_ambiental.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) values
	(200011,110031,2001,1,1.0,5.0,5.0),
	(200012,110031,2001,1,3.2,2.5,3.0),
	(200013,110032,2001,2,1.0,3.2,2.3),
	(200011,110032,2002,1,3.8,3.0,5.0),
	(200013,110032,2002,1,4.6,3.5,5.0),
	(200014,110032,2002,1,3.3,4.0,1.5),
	(200011,110033,2003,1,2.6,4.0,2.5),
	(200012,110031,2003,2,1.3,5.0,3.0),
	(200014,110031,2003,2,5.0,1.0,1.0);


--------------------------
-- Tablas Ing Forestal --
--------------------------

insert into ing_forestal.estudiantes (cod_e , nom_e, dir_e, tel_e, id_carr, fech_nac) values 
	(200015,'Estudiante Forestal 1','direccion E5',null,20002,'12/11/1997'),
	(200016,'Estudiante Forestal 2','direccion E6',2121210,20002,'30/03/1999'),
	(200017,'Estudiante Forestal 3','direccion E7',2121210,20002,'30/03/1999'),
	(200018,'Estudiante Forestal 4','direccion E8',2121210,20002,'30/03/1999');
	
insert into ing_forestal.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) values
	(200015,110034,2004,1,1.0,5.0,5.0),
	(200016,110034,2004,1,3.2,2.5,3.0),
	(200017,110034,2004,1,1.0,3.2,2.3),
	(200016,110035,2005,1,3.8,3.0,5.0),
	(200018,110035,2005,1,4.6,3.5,5.0);


--------------------------
-- Tablas Ing Sanitaria --
--------------------------

insert into ing_sanitaria.estudiantes (cod_e , nom_e, dir_e, tel_e, id_carr, fech_nac) values 
	(200019,'Estudiante Sanitaria 1','direccion E9',null,20003,'12/11/1997'),
	(2000110,'Estudiante Sanitaria 2','direccion E10',2121210,20003,'30/03/1999'),
	(2000111,'Estudiante Sanitaria 3','direccion E11',2121210,20003,'30/03/1999'),
	(2000112,'Estudiante Sanitaria 4','direccion E12',2121210,20003,'30/03/1999');
	
insert into ing_sanitaria.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) values
	(200019,110036,2006,1,1.0,5.0,5.0),
	(2000110,110036,2006,1,3.2,2.5,3.0),
	(2000111,110036,2006,1,1.0,3.2,2.3),
	(2000112,110037,2006,2,1.0,3.2,2.3),
	(2000110,110038,2007,1,3.8,3.0,5.0),
	(2000111,110038,2007,1,4.6,3.5,5.0),
	(2000112,110038,2007,1,4.6,3.5,5.0);



----------------------------
-- Tablas Ing Topografica --
----------------------------

insert into ing_topografica.estudiantes (cod_e , nom_e, dir_e, tel_e, id_carr, fech_nac) values 
	(2000113,'Estudiante Topografica 1','direccion E13',null,20004,'12/11/1997'),
	(2000114,'Estudiante Topografica 2','direccion E14',2121210,20004,'30/03/1999'),
	(2000115,'Estudiante Topografica 3','direccion E15',2121210,20004,'30/03/1999'),
	(2000116,'Estudiante Topografica 4','direccion E16',2121210,20004,'30/03/1999');
	
insert into ing_topografica.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) values
	(2000113,110039,2008,1,1.0,5.0,5.0),
	(2000114,110039,2008,1,3.2,2.5,3.0),
	(2000115,110039,2008,1,1.0,3.2,2.3),
	(2000113,110039,2009,1,1.0,3.2,2.3),
	(2000115,110039,2009,1,3.8,3.0,5.0),
	(2000116,110039,2009,1,4.6,3.5,5.0);


