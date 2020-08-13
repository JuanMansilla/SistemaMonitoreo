--- Creamos la base de datos ----

CREATE DATABASE Geotec
    ON PRIMARY
    (NAME = 'GeotecV0p2', --! Nombre logico del archivo
    FILENAME = 'F:\SqlDB\GeotecV0p2.mdf', -- Cambiar la direccion de la base de datos
    SIZE =10, -- Por defecto esta en MB, GB Son entros
    MAXSIZE =1GB, -- Tama;o max de la DB
    FILEGROWTH =5); --Crecimiento del archivo, por defecto en MB

-- Si quieres Borrar la DB
DROP DATABASE Geotec;

-- Si queremos Modificar el tama;o
ALTER DATABASE Geotec
MODIFY FILE
(NAME = GeotecV0p2,
MAXSIZE = 10GB); -- Debido a ser una distribucion express