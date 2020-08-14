USE Geotec;
---------------------------------------------
----------Llenamos las tablas ---------------
---------------------------------------------
--
-- Tabla SistCoor: Sistema de medida
--
INSERT INTO SistCoor
VALUES (1, 'WGS-84');
INSERT INTO SistCoor
VALUES (2, 'PSAD-56');
--
-- Tabla Ubicacion: Donde se encuentran instalados los prismas
--
INSERT INTO Ubicacion
VALUES ('Tajo Norte', 'Mina');
INSERT INTO Ubicacion
VALUES ('Tajo Sur', 'Mina');
INSERT INTO Ubicacion
VALUES ('Pad 1', 'Pad');
INSERT INTO Ubicacion
VALUES ('Pad 2', 'Pad');
INSERT INTO Ubicacion
VALUES ('Dique 1', 'Dique_Pad');
INSERT INTO Ubicacion
VALUES ('Dique 2', 'Dique_Pad');
INSERT INTO Ubicacion
VALUES ('Botadero Este', 'Botadero');
INSERT INTO Ubicacion
VALUES ('Botadero Norte', 'Botadero');
--
-- Tabla Ubicacion: Donde se encuentran instalados los prismas
--
INSERT INTO NombrePrism
VALUES (
		'PR01PAD-15',
		3,
		'Ubicado en el lift N 03',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR02PAD-15',
		3,
		'Ubicado en el lift N 03',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR03PAD-15',
		3,
		'Ubicado en el lift N 03',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR04PAD-15',
		3,
		'Ubicado en el lift N 03',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR05PAD-15',
		3,
		'Ubicado en el lift N� 06',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR06PAD-15',
		3,
		'Ubicado en el lift N 06',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR07PAD-15',
		3,
		'Ubicado en el lift N 06',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR08PAD-15',
		3,
		'Ubicado en el lift N 09',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR09PAD-15',
		3,
		'Ubicado en el lift N 09',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR10PAD-15',
		3,
		'Ubicado en el lift N 09',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR11PAD-15',
		3,
		'Ubicado en el lift N 09',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES (
		'PR12PAD-15',
		3,
		'Ubicado en el lift N 09',
		1,
		'12/23/2019'
	)
INSERT INTO NombrePrism
VALUES ('PR01PAD-16', 5, 'Dique de Pad', 1, '2/23/2019')
INSERT INTO NombrePrism
VALUES ('PR02PAD-16', 5, 'Dique de Pad', 1, '2/23/2019')
INSERT INTO NombrePrism
VALUES ('PR03PAD-16', 5, 'Dique de Pad', 1, '2/23/2019') --
	-- Tabla EquipoMedicion: Donde se encuentran instalados los prismas
	--
INSERT INTO EquipoMedicion
VALUES ('1301304', 'LEICA	', 'TS09 1"');
--
-- Tabla EquipoMedicion: Donde se encuentran instalados los prismas
-- Debido a que tenemos ya creado un valor por defaul y queremos usarlo.
INSERT INTO Responsables (IdResponsable, Nombres, Apellidos)
VALUES (1, 'JUAN MANUEL', 'MANSILLA OLIVAS');
-- Si hemos llenado mal el nombre, no nos permirte usar un TRUNCATE ya que las llaves foraneas no nos lo permite
-- Limpiamos la tabla
DELETE FROM Responsables;
--
-- Tabla EquipoMedicion: Donde se encuentran instalados los prismas
--
INSERT INTO PuntosControl
VALUES (
		'E-1',
		315328.276,
		9100849.480,
		4297.794,
		2,
		'NN'
	);
INSERT INTO PuntosControl
VALUES (
		'E-2',
		315306.087,
		9100888.894,
		4294.695,
		2,
		'NN'
	);
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
SELECT *
FROM RegistroPrisma ------------------------------------------------
	--------- Insertamos el archivo CSV ---------
	------------------------------------------------
	BULK
INSERT Geotec.dbo.RegistroPrisma
FROM 'C:\Users\Juan Mansilla\Desktop\Curso_SQLExcel\2_SQL\Project_A\Data1_5.csv' WITH (
		FORMAT = 'csv',
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		ROWTERMINATOR = '\n'
	);