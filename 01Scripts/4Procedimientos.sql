USE Geotec;
GO
SELECT * FROM RegistroPrisma
WHERE ESTADO = 1;
GO

IF OBJECT_ID('tempdb..#Test') IS NOT NULL DROP TABLE #Test
CREATE TABLE #Test (IdRegistro int);
GO
-- Devuelve los registros de
WITH PrismaUno
AS
(
	SELECT ROW_NUMBER() OVER (
		PARTITION BY NamePrism
		ORDER BY Fecha, TomaIdex ASC
	) AS OrderID, *
	FROM RegistroPrisma
)
SELECT IdRegistro, NamePrism into PrimerRegistro
FROM PrismaUno
WHERE OrderID =1;
GO
---
--- Creamo un procedimiento para cuando llenemos la base de datos desde un ascii
---
CREATE PROCEDURE ActualizarRegistros AS BEGIN IF OBJECT_ID('Geotec..PrimerRegistro') IS NOT NULL DROP TABLE PrimerRegistro;
--- Borramos la tabla PrimerRegistro si existe y la volvemos a poblar
WITH PrismaUno AS (
    SELECT ROW_NUMBER() OVER (
            PARTITION BY NamePrism
            ORDER BY Fecha,
                TomaIdex ASC
        ) AS OrderID,
        *
    FROM RegistroPrisma
)
SELECT IdRegistro,
    NamePrism into PrimerRegistro --- Creamos una tabla para guardar este registro
FROM PrismaUno
WHERE OrderID = 1;
END
GO
---
--- Creamo una vista para ver las coordenadas de los puntos
---
CREATE VIEW REGISTERPRISMAS 
AS
SELECT a.NamePrism, a.Em, a.Nm, a.Elev
FROM RegistroPrisma AS a
INNER JOIN PrimerRegistro AS b
ON a.NamePrism = b.NamePrism and a.IdRegistro = b.IdRegistro;
GO
---
---Agregamos un campo mas con Alter Table Fecha de registro
---
ALTER VIEW REGISTERPRISMAS 
AS
SELECT a.NamePrism,a.Fecha ,a.Em, a.Nm, a.Elev
FROM RegistroPrisma AS a
INNER JOIN PrimerRegistro AS b
ON a.NamePrism = b.NamePrism and a.IdRegistro = b.IdRegistro;
GO
---
--- Creamos el Bk
---
CREATE PROCEDURE BkDb_Geotec
AS
DECLARE @TIMEDATE DATE
DECLARE @PATH VARCHAR(100)
SET @TIMEDATE = GETDATE()
SET @PATH = CONCAT('F:\SqlDB\Bk\Geotec','_',CAST(@TIMEDATE AS VARCHAR(10)),'.BK')

BACKUP DATABASE Geotec
TO  DISK = @PATH
WITH CHECKSUM;
go
---
--- Que pasa si ya existe, creamos una funcion
---
CREATE FUNCTION dbo.fn_FileExists(@path varchar(512))
RETURNS BIT
AS
BEGIN
     DECLARE @result INT
     EXEC master.dbo.xp_fileexist @path, @result OUTPUT
     RETURN cast(@result as bit)
END;
go
---
--- Empleamos la funcion creada para ver si existe
---
DECLARE @TIMEDATE DATE
DECLARE @PATH VARCHAR(100)
SET @TIMEDATE = GETDATE()
SET @PATH = CONCAT('F:\SqlDB\Bk\Geotec','_',CAST(@TIMEDATE AS VARCHAR(10)),'.BK')
SELECT dbo.fn_FileExists(@PATH) AS FileExits
GO
-------
-- Revisando si existe el archivo
-------
CREATE PROCEDURE SaveBkGeotec
AS
DECLARE @TIMEDATE DATE
DECLARE @PATH VARCHAR(100)
DECLARE @Message int
SET @TIMEDATE = GETDATE()
SET @PATH = CONCAT('F:\SqlDB\Bk\Geotec','_',CAST(@TIMEDATE AS VARCHAR(10)),'.BK')
IF  dbo.fn_FileExists(@PATH) = 0 
	BEGIN
		EXECUTE BkDb_Geotec
		RETURN 1
	END
ELSE
	BEGIN
		RETURN 0
	END
GO
--------
--- Hay un error en la tabla PuntosControl
--------
select * from PuntosControl;
------
--- Actualizamos todo una columns
------
update PuntosControl set SistCoor = 1;
select * from PuntosControl;
GO
------
--- Actualizamos todo una columns
------
select * from Responsables;
GO
---
--- Este comando no llega a funcionar debido a que la DB ya esta estructurada
---
ALTER TABLE Responsables
ALTER COLUMN IdResponsable INT;
GO
---
--- Creamos un procedimiento teniendo en cuenta esto
---
select top 1 IdResponsable from Responsables order by IdResponsable desc;
GO
---
--- Creamos un procedimiento para el registro de los usuarios
---
CREATE PROCEDURE RegisterUser @Names VARCHAR(20),@LastNames VARCHAR(20)
AS
DECLARE @CountRegister int
SET @CountRegister = (select top 1 IdResponsable from Responsables order by IdResponsable desc) + 1
INSERT INTO Responsables 
VALUES (@CountRegister, UPPER(TRIM(@Names)), UPPER(TRIM(@LastNames)),getdate());
GO
---- Debido a que no se coloco un Identity
SELECT *  FROM Responsables;
DELETE Responsables WHERE IdResponsable >1 ;
GO
---- 
SELECT *  FROM Ubicacion;
SELECT *  FROM SistCoor;
SELECT *  FROM NombrePrism;
GO
---- 
---- CREAMOS EL PROCEDIMIENTO PARA CREAR UN PRISMA
---- 
CREATE PROCEDURE RegistarNewPrisma
@NamePris VARCHAR(10),
@Ubicacion int,
@Comentarios VARCHAR(250),
@IdSist int,
@FechaInstalacion smalldatetime
AS
INSERT INTO NombrePrism VALUES (TRIM(@NamePris), @Ubicacion, @Comentarios, @IdSist, @FechaInstalacion);
GO
---- 
---- CREAMOS EL PROCEDIMIENTO PARA REGISTRAR UN PUNTO MEDIDO
---- 
ALTER PROCEDURE RegistroMedido
@NamePris VARCHAR(10),
@TomaIdex int,
@Fecha datetime,
@Este DECIMAL(11,4),
@Norte DECIMAL(11,4),
@Elevacion DECIMAL(11,4),
@Estado int,
@Responsable int,
@EquipoRegistro int
AS
INSERT INTO RegistroPrisma (NamePrism, TomaIdex, Fecha, Em, Nm, Elev, ESTADO, Responsable, EquipoRegistro ) VALUES (TRIM(@NamePris), @TomaIdex, @Fecha, @Este, @Norte,@Elevacion,@Estado,@Responsable,@EquipoRegistro);
GO
EXECUTE RegistroMedido 'PR06PAD-15',1, '12/23/2019 9:20', 315220.543, 9100565.573, 4332.103, 1,1,1


INSERT INTO RegistroPrisma (NamePrism, TomaIdex, Fecha, Em, Nm, Elev, ESTADO ) VALUES (TRIM('PR06PAD-15'), 1, '12/23/2019 9:20', 315220.543, 9100565.573, 4332.103, 1)