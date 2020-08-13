USE Geotec;
-- Creamos la base de datos para el registro de los prismas
CREATE TABLE BaseMedicion (
    -- Base de medicion
    IdBase INT IDENTITY,
    BaseName VARCHAR(15) UNIQUE NOT NULL,
    Em FLOAT NOT NULL,
    Nm FLOAT NOT NULL,
    ELEVm FLOAT NOT NULL,
    PRIMARY KEY (IdBase)
);
CREATE TABLE PuntosControl (
    -- puntos de control
    IdControl INT IDENTITY,
    ControlName VARCHAR(15) UNIQUE NOT NULL,
    Em FLOAT NOT NULL,
    Nm FLOAT NOT NULL,
    ELEVm FLOAT NOT NULL,
    PRIMARY KEY (ControlName)
);
-- Agregamos una columna ya q se puede trabajar
-- con diversos sistemas de posicionamiento
ALTER TABLE BaseMedicion
ADD SistCoor int null;
ALTER TABLE PuntosControl
ADD SistCoor int null;
ALTER TABLE PuntosControl
ADD BaseMedicion VARCHAR(15) null;
-- Y si queremos borrar  ## NO ejecutar
ALTER TABLE dbo.BaseMedicion DROP COLUMN SistCoor;
--
-- Tabla de sistemas coordenados
CREATE TABLE SistCoor (
    IdSist int unique,
    NameSist VARCHAR(10) UNIQUE NOT NULL,
    PRIMARY KEY (IdSist)
);
-- Creamos la tabla de prismas
CREATE TABLE NombrePrism (
    NamePris VARCHAR(10),
    Ubicacion int NOT NULL,
    Comentarios VARCHAR(250) NULL,
    IdSist INT NOT NULL,
    FechaInstalacion SMALLDATETIME NOT NULL PRIMARY KEY (NamePris)
);
-- Registro Prisma
CREATE TABLE RegistroPrisma (
    IdRegistro BIGINT IDENTITY,
    NamePrism VARCHAR(10) NOT NULL,
    TomaIdex INT DEFAULT 1,
    Fecha DATETIME NOT NULL,
    Em DECIMAL(11, 4) NOT NULL,
    Nm DECIMAL(11, 4) NOT NULL,
    Elev DECIMAL(11, 4) NOT NULL,
);
-- Revisamos el tipo de dato que mas nos combiene
DECLARE @TestNumero DECIMAL(11, 4) = 8000121.1423;
SELECT @TestNumero AS COORDENADA;
-- Creamos estados para poder hacer seguimiento de las coordenadas y quien lo esta tomando y con q equipo
ALTER TABLE RegistroPrisma
ADD ESTADO INT DEFAULT 1;
ALTER TABLE RegistroPrisma
ADD Responsable INT not null;
ALTER TABLE RegistroPrisma
ADD EquipoRegistro INT not null;
-- Debemos saber se encuentra
CREATE TABLE EstadosPrisma (
    IdEstado INT IDENTITY,
    Estado VARCHAR(10) UNIQUE
)
ALTER TABLE EstadosPrisma
ADD PRIMARY KEY (IdEstado);
CREATE TABLE Responsables(
    IdResponsable INT,
    Nombres VARCHAR(20) NOT NULL,
    Apellidos VARCHAR(20) NOT NULL,
    FechaRegistro datetime2 default FORMAT (getdate(), 'dd-MM-yy HH:mm'),
    PRIMARY KEY (IdResponsable)
);
CREATE TABLE ZonasMina (
    IdSubZonas int IDENTITY,
    SubZonas VARCHAR(15) UNIQUE,
    Zonas VARCHAR(10),
    primary key (IdSubZonas)
);
-- Cuando hay un error en los nombres de las tablas y de la columna aun podemos modeficarlas
USE Geotec;
EXEC sp_rename 'ZonasMina',
'Ubicacion';
EXEC sp_rename 'Ubicacion.IdSubZonas',
'IdUbicacion',
'COLUMN';
CREATE TABLE EquipoMedicion (
    IdEquReg INT IDENTITY UNIQUE,
    SERIE VARCHAR(20) NOT NULL UNIQUE,
    MARCA VARCHAR(15) NOT NULL,
    Modelo VARCHAR(15) NOT NULL
);
--------------------------------------------------
---- CREAMOS LAS RELACIONES ENTRE LAS TABLAS -----
--------------------------------------------------
ALTER TABLE NombrePrism
ADD CONSTRAINT FK_NombrePrism_SistCoor FOREIGN KEY(IdSist) REFERENCES SistCoor (IdSist)
ALTER TABLE NombrePrism
ADD CONSTRAINT FK_NombrePrism_Ubicacion FOREIGN KEY(Ubicacion) REFERENCES Ubicacion (IdUbicacion) ON UPDATE CASCADE
ALTER TABLE RegistroPrisma
ADD CONSTRAINT FK_RegistroPrisma_EquipoMedicion FOREIGN KEY(EquipoRegistro) REFERENCES EquipoMedicion(IdEquReg)
ALTER TABLE RegistroPrisma
ADD CONSTRAINT FK_RegistroPrisma_NombrePrism FOREIGN KEY(NamePrism) REFERENCES NombrePrism(NamePris) ON UPDATE CASCADE
ALTER TABLE RegistroPrisma
ADD CONSTRAINT FK_RegistroPrisma_Responsables FOREIGN KEY(Responsable) REFERENCES Responsables(IdResponsable) ON UPDATE CASCADE