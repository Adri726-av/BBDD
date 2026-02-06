CREATE TABLE Ciudadano (
    IdCiudadano number(14) PRIMARY KEY,
    DNI varchar2(10) UNIQUE,
    --Considerando tambien los DNI extranjeros, ya que tienen como maximo 9 (1 letra + 7 numeros + 1 letra)
    Nombre varchar2(32) NOT NULL,
    Apellido1 varchar2(32) NOT NULL,
    Apellido2 varchar2(32),
    FechaNacimiento varchar2(8) NOT NULL,
    --Lo convierto en un CHECK, lo cambio tambien en el modelo relacional y en el modelo lógico
    Genero varchar2(20),
    Calle varchar2(32),
    Numero number(5),
    Ciudad varchar2(32),
    CodigoPostal number(6),
    CONSTRAINT ck_Genero CHECK (Genero IN ('Hombre', 'Mujer'))
    CONSTRAINT ck_Fecha_Nacimiento CHECK (REGEXP_LIKE (FechaNacimiento, '^(0[1-9]|1[0-2])\/(0[1-9]|1\d|2\d|3[01])\/(0[1-9]|1[1-9]|2[1-9])$'))
    -- He pensado en hacer otro CHECK para el DNI con otra expresion regular, pero creo que ya es demasiado
);

CREATE TABLE Telefono (
    NumTelefono varchar2(15) PRIMARY KEY,
    IdCiudadano number(14),
    CONSTRAINT fk_Telefono_Ciudadano FOREIGN KEY (IdCiudadano) REFERENCES Ciudadano(IdCiudadano) ON DELETE CASCADE,
    CONSTRAINT ck_NumTelefono CHECK (REGEXP_LIKE (NumTelefono, '^\+[1-9][0-9]{7,14}$'))
    -- El numTelefono le he hecho un CHECK a nivel internacional ya que nuestra base de datos se mueve a nivel internacional, si quisieramos hacerlo a nvel españa, seria esta: '^(\+34)[0-9]{9}$'
);

CREATE TABLE Email (
    Correo varchar2(64) PRIMARY KEY,
    IdCiudadano number(14),
    CONSTRAINT fk_Email_Ciudadano FOREIGN KEY (IdCiudadano) REFERENCES Ciudadano(IdCiudadano) ON DELETE CASCADE,
    CONSTRAINT ck_Correo CHECK (REGEXP_LIKE (Correo, '^[A-Za-z0-9]+@[A-Za-z0-9]+\.[A-Za-z]{2,}$'))
);

CREATE TABLE Situacion_Laboral (
    IdSituacion_Laboral number(14) PRIMARY KEY
    IdCiudadano number(14) NOT NULL,
    Experiencia_Laboral varchar2(100) UNIQUE NOT NULL,
    FechaInicio varchar2(8) NOT NULL,
    FechaFin varchar2(8),
    MotivoDesempleo varchar2(50),
    TipoContrato varchar2(10),
    DisponibilidadHoraria varchar2(6),
    Estado varchar2(12) NOT NULL,
    CONSTRAINT fk_Situacion_Ciudadano FOREIGN KEY (IdCiudadano) REFERENCES Ciudadano(IdCiudadano) ON DELETE CASCADE,
    CONSTRAINT ck_Disponibilidad_Horaria CHECK (DisponibilidadHoraria IN ('Mañana', 'Tarde', 'Noche')),
    CONSTRAINT ck_TipoContrato CHECK (TipoContrato IN ('Temporal', 'Indefinido', 'Prácticas')),
    CONSTRAINT ck_Estado CHECK (Estado IN ('Empleado', 'Desempleado'))
);

CREATE TABLE Formacion (
    IdFormacion number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    AreaEspecializada varchar2(20) NOT NULL,
    Nivel varchar2(8) NOT NULL,
    CONSTRAINT ck_
);

DROP TABLE Situacion_Laboral CASCADE CONSTRAINTS PURGE;
DROP TABLE Email CASCADE CONSTRAINTS PURGE;
DROP TABLE Telefono CASCADE CONSTRAINTS PURGE;
DROP TABLE Ciudadano CASCADE CONSTRAINTS PURGE;

