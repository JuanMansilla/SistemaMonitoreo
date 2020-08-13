USE Geotec;

SELECT * FROM RegistroPrisma
WHERE ESTADO = 1;


IF OBJECT_ID('tempdb..#Test') IS NOT NULL DROP TABLE #Test
CREATE TABLE #Test (IdRegistro int);

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
---
--- Creamo una vista para ver las coordenadas de los puntos
---
CREATE VIEW REGISTERPRISMAS AS
SELECT a.NamePrism, a.Em, a.Nm, a.Elev
FROM RegistroPrisma AS a
INNER JOIN PrimerRegistro AS b
ON a.NamePrism = b.NamePrism and a.IdRegistro = b.IdRegistro;