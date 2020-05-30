-- MCIC-BD-PROYECTO FINAL

-- Christopher Giovanny Ortiz Montero 		Código: 20201495006
-- Joaquín Eduardo Caicedo Navarro		Código: 20201495001
-- Thomas Daniel Ávila Blenkey			Código: 20151020012

---------------------------------------------------------------------------
-- INGRESO DE DATOS EN LAS TABLAS DE LA FACULTAD DE CIENCIAS Y EDUCACIÓN --
---------------------------------------------------------------------------

INSERT INTO carreras (id_carr, nom_carr, reg_cal) VALUES
	(30001, 'Licenciatura en biologia', 202031),
	(30002,	'Licenciatura en ciencias sociales', 202032),
	(30003,	'Licenciatura en fisica', 202033),
	(30004, 'Licenciatura en matematicas', 202034),
	(30005, 'Licenciatura en quimica', 202035);

INSERT INTO asignaturas (cod_a, nom_a, int_h, creditos) VALUES
	(3001, 'Calculo', 4, 4),
	(3002, 'Biologia', 4, 4),
	(3003, 'Ecología', 4, 4),
	(3004, 'Microbiologia', 4, 4),
	(3005, 'Ciencias sociales escolares', 4, 5),
	(3006, 'Memoria social y colectiva', 4, 5),
	(3007, 'Termodinamica', 4, 3),
	(3008, 'Fisica moderna', 4, 4),
	(3009, 'Didactica de la geometria', 4, 4),
	(3010, 'Didactica del algebra', 4, 3),
	(3011, 'Quimica analitica', 4, 4),
	(3012, 'Historia de la quimica', 4, 2);

INSERT INTO profesores (id_p, nom_p, dir_p, tel_p, profesion) VALUES
	(11021, 'Profesor Ciencias 1', 'Direccion P21', 2121211, 'P21'),
	(11022,	'Profesor Ciencias 2', 'Direccion P22', 2222222, 'P22'),
	(11023,	'Profesor Ciencias 3', 'Direccion P23', 2323233, 'P23'),
	(11024,	'Profesor Ciencias 4', 'Direccion P24', 2424244, 'P24'),
	(11025,	'Profesor Ciencias 5', 'Direccion P25', 2525255, 'P25'),
	(11026,	'Profesor Ciencias 6', 'Direccion P26', 2626266, 'P26'),
	(11027,	'Profesor Ciencias 7', 'Direccion P27', 2727277, 'P27'),
	(11028,	'Profesor Ciencias 8', 'Direccion P28', 2828288, 'P28'),
	(11029,	'Profesor Ciencias 9', 'Direccion P29', 2929299, 'P29'),
	(11030,	'Profesor Ciencias 10', 'Direccion P30', 3030300, 'P30');

INSERT INTO imparte (id_p, cod_a, grupo, salon, horario) VALUES
	(11021,	3001, 1, 101, 'L-8-10 J-10-12'),
	(11021,	3001, 2, 201, 'L-10-12 J-8-10'),
	(11022,	3001, 3, 101, 'L-8-10 J-10-12'),
	(11022,	3001, 4, 302, 'L-10-12 J-8-10'),
	(11021,	3002, 1, 405, 'M-8-10 V-10-12'),
	(11023,	3002, 2, 506, 'M-10-12 V-8-10'),
	(11024,	3003, 1, 101, 'L-8-10 R-10-12 V-9-10'),
	(11025,	3004, 1, 506, 'M-7-9 V-8-10'),
	(11025,	3004, 2, 402, 'L-10-12 R-12-14 V-11-12'),
	(11026,	3003, 1, 401, 'L-12-14 R-14-16 V-13-14'),
	(11026,	3003, 2, 601, 'L-8-10 J-10-12'),
	(11027,	3003, 3, 602, 'L-10-12 J-8-10'),
	(11027,	3003, 4, 403, 'L-8-10 J-10-12'),
	(11028,	3005, 1, 505, 'L-10-12 J-8-10');

INSERT INTO referencia (cod_a, isbn) VALUES
	(3001, 100111100),
	(3001, 100222200),
	(3002, 100333300),
	(3003, 100333300),
	(3003, 100111100),
	(3004, 100222200),
	(3004, 100333300),
	(3005, 100111100),
	(3005, 100222200),
	(3006, 100444400),
	(3007, 100111100),
	(3008, 100222200),
	(3008, 100555500),
	(3009, 100555500),
	(3010, 100111100),
	(3011, 100222200),
	(3012, 100222200),
	(3012, 100111100);

-------------------------------------------
-- Tablas de la licenciatura en biología --
-------------------------------------------

INSERT INTO lic_biologia.estudiantes (cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr) VALUES
	(3000101, 'Estudiante Biologia 1', 'direccion EB1', 5555555, '1/08/1999', 30001),
	(3000102, 'Estudiante Biologia 2', 'direccion EB2',	6666666, '14/08/2003', 30001),
	(3000103, 'Estudiante Biologia 3', 'direccion EB3',	7777777, '13/02/1993', 30001),
	(3000104, 'Estudiante Biologia 4', 'direccion EB4',	8888888, '1/08/2000', 30001);

INSERT INTO lic_biologia.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) VALUES
	(3000101, 11021, 3002, 1, 2.5, 4, 1.3),
	(3000101, 11024, 3003, 1, 3.9, 3.8, 3.3),
	(3000102, 11024, 3003, 1, 3.8, 2.2, 3.8),
	(3000102, 11025, 3004, 2, 2, 4.6, 1.7),
	(3000102, 11021, 3001, 2, 3.5, 4.6, 3.3),
	(3000103, 11026, 3003, 1, 1.8, 1.1, 4),
	(3000103, 11025, 3004, 2, 1.7, 1.5, 4.5),
	(3000104, 11025, 3004, 2, 4.7, 1.5, 4.7);

----------------------------------------------------
-- Tablas de la licenciatura en ciencias sociales --
----------------------------------------------------

INSERT INTO lic_c_sociales.estudiantes (cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr) VALUES
	(3000201, 'Estudiante Sociales 1', 'direccion ES1',	9999222, '30/03/1997', 30002),
	(3000202, 'Estudiante Sociales 2', 'direccion ES2',	1111110, '12/11/1998', 30002),
	(3000203, 'Estudiante Sociales 3', 'direccion ES3',	1111011, '1/08/1996', 30002),
	(3000204, 'Estudiante Sociales 4', 'direccion ES4',	1111013, '30/03/1998', 30002);

INSERT INTO lic_c_sociales.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) VALUES
	(3000201, 11021, 3002, 1, 3.2, 3.6, 2.5),
	(3000201, 11024, 3003, 1, 4, 1.9, 3.1),
	(3000202, 11024, 3003, 1, 2.6, 3.1, 4.8),
	(3000202, 11025, 3004, 2, 4.2, 1.7, 2.7),
	(3000202, 11021, 3001, 2, 1.1, 4.8, 1),
	(3000203, 11026, 3003, 1, 3, 2.1, 3.5),
	(3000203, 11025, 3004, 2, 1.6, 3.3, 4.8),
	(3000204, 11025, 3004, 2, 3.1, 3, 2.2);

-----------------------------------------
-- Tablas de la licenciatura en física --
-----------------------------------------

INSERT INTO lic_fisica.estudiantes (cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr) VALUES
	(3000301, 'Estudiante Fisica 1', 'direccion EF1', NULL, '12/11/1999', 30003),
	(3000302, 'Estudiante Fisica 2', 'direccion EF2', 5555015, '1/08/1998', 30003),
	(3000303, 'Estudiante Fisica 3', 'direccion EF3', 2222016, '30/03/1999', 30003),
	(3000304, 'Estudiante Fisica 4', 'direccion EF4', 3333317, '12/11/2000', 30003);

INSERT INTO lic_fisica.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) VALUES
	(3000301, 11021, 3002, 1, 1.4, 4.7, 3),
	(3000301, 11024, 3003, 1, 3.7, 3.5, 2.7),
	(3000302, 11024, 3003, 1, 2, 3, 4),
	(3000302, 11025, 3004, 2, 1.3, 3.3, 1),
	(3000302, 11021, 3001, 2, 3.4, 4.4, 4.6),
	(3000303, 11026, 3003, 1, 4, 3, 4.7),
	(3000303, 11025, 3004, 2, 3.9, 3, 2.4),
	(3000304, 11025, 3004, 2, 4.2, 1.4, 3.8);
	
----------------------------------------------
-- Tablas de la licenciatura en matemáticas --
----------------------------------------------

INSERT INTO lic_matematicas.estudiantes (cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr) VALUES
	(3000401, 'Estudiante Matematicas 1', 'direccion EM1', 1234123, '2/01/1995', 30004),
	(3000402, 'Estudiante Matematicas 2', 'direccion EM2', 2050325, '9/09/2000', 30004),
	(3000403, 'Estudiante Matematicas 3', 'direccion EM3', 8523697, '30/01/1996', 30004),
	(3000404, 'Estudiante Matematicas 4', 'direccion EM4', 4563217, '20/06/2003', 30004);

INSERT INTO lic_matematicas.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) VALUES
	(3000401, 11021, 3002, 1, 3, 2.2, 3),
	(3000401, 11024, 3003, 1, 1.2, 1.4, 3.1),
	(3000402, 11024, 3003, 1, 3.6, 4.9, 1.6),
	(3000402, 11025, 3004, 2, 5, 2.6, 3.4),
	(3000402, 11021, 3001, 2, 3, 4.5, 3.1),
	(3000403, 11026, 3003, 1, 2.7, 3.4, 4),
	(3000403, 11025, 3004, 2, 4.4, 3.7, 2.7),
	(3000404, 11025, 3004, 2, 3.3, 4.9, 4.7);

------------------------------------------
-- Tablas de la licenciatura en química --
------------------------------------------

INSERT INTO lic_quimica.estudiantes (cod_e, nom_e, dir_e, tel_e, fech_nac, id_carr) VALUES
	(3000501, 'Estudiante Quimica 1', 'direccion EQ1', 3322665, '12/07/1997', 30005),
	(3000502, 'Estudiante Quimica 2', 'direccion EQ2', 7788445, '18/12/1999', 30005),
	(3000503, 'Estudiante Quimica 3', 'direccion EQ3', 1122445, '4/03/1995', 30005),
	(3000504, 'Estudiante Quimica 4', 'direccion EQ4', 9966554, '9/10/1999', 30005);

INSERT INTO lic_quimica.inscribe (cod_e, id_p, cod_a, grupo, n1, n2, n3) VALUES
	(3000501, 11021, 3002, 1, 4.7, 3.4, 2.4),
	(3000501, 11024, 3003, 1, 1.9, 2.9, 3.6),
	(3000502, 11024, 3003, 1, 2.1, 2.7, 3.3),
	(3000502, 11025, 3004, 2, 4, 4.1, 4),
	(3000502, 11021, 3001, 2, 1.4, 4.2, 3),
	(3000503, 11026, 3003, 1, 1.6, 3.9, 3.5),
	(3000503, 11025, 3004, 2, 3.3, 1.6, 3.2),
	(3000504, 11025, 3004, 2, 3.7, 2.3, 3.7);

---------------------------------------------------------------