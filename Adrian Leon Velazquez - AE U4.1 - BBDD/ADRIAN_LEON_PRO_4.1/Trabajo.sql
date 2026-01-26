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
    CONSTRAINT ck_Genero CHECK (Genero IN ('Hombre', 'Mujer')),
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
    IdSituacion_Laboral number(14) PRIMARY KEY,
    IdCiudadano number(14) NOT NULL,
    Experiencia_Laboral varchar2(100) UNIQUE NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    MotivoDesempleo varchar2(50),
    TipoContrato varchar2(10),
    DisponibilidadHoraria varchar2(6),
    Estado varchar2(12) NOT NULL,
    CONSTRAINT fk_Situacion_Ciudadano FOREIGN KEY (IdCiudadano) REFERENCES Ciudadano(IdCiudadano) ON DELETE CASCADE,
    CONSTRAINT ck_Disponibilidad_Horaria CHECK (DisponibilidadHoraria IN ('Mañana', 'Tarde', 'Noche')),
    CONSTRAINT ck_TipoContrato_Laboral CHECK (TipoContrato IN ('Temporal', 'Indefinido', 'Prácticas')),
    CONSTRAINT ck_Estado_Laboral CHECK (Estado IN ('Empleado', 'Desempleado'))
);


CREATE TABLE FormacionAvanzada (
    IdFormacionAvanzada number(14) PRIMARY KEY
);
-- Creo la tabla de formacion  avanzada para poder hacer referencia en la tabla formacion y asi poder hacer la relacion recursiva

CREATE TABLE Formacion (
    IdFormacion NUMBER(14) PRIMARY KEY,
    IdCiudadano NUMBER(14) NOT NULL,
    IdFormacionAvanzada NUMBER(14) NOT NULL,
    Nombre VARCHAR2(32) NOT NULL,
    AreaEspecializada VARCHAR2(20) NOT NULL,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    Nivel VARCHAR2(8) NOT NULL,
    Modalidad VARCHAR2(14) NOT NULL,
    HorasSemanales NUMBER(2) NOT NULL,
    CONSTRAINT fk_Formacion_Ciudadano FOREIGN KEY (IdCiudadano) REFERENCES Ciudadano (IdCiudadano),
    CONSTRAINT fk_Formacion_FormacionAvanzada FOREIGN KEY (IdFormacionAvanzada) REFERENCES FormacionAvanzada (IdFormacionAvanzada),
    CONSTRAINT ck_Nivel CHECK (Nivel IN ('Basico', 'Avanzado')),
    CONSTRAINT ck_Modalidad CHECK (Modalidad IN ('Presencial', 'Online', 'SemiPresencial')), 
    CONSTRAINT ck_HorasSemanales CHECK (HorasSemanales BETWEEN 1 AND 60)
);


CREATE TABLE Matricula (
    IdMatricula number(14) PRIMARY KEY,
    IdCiudadano number(14) NOT NULL,
    IdFormacion number(14) NOT NULL,
    FechaMatricula DATE UNIQUE,
    NotaFinal number(2),
    Estado varchar2(12) NOT NULL,
    CONSTRAINT fk_Matricula_Ciudadano FOREIGN KEY (IdCiudadano) REFERENCES Ciudadano(IdCiudadano) ON DELETE CASCADE,
    CONSTRAINT fk_Matricula_Formacion FOREIGN KEY (IdFormacion) REFERENCES Formacion(IdFormacion) ON DELETE CASCADE,
    CONSTRAINT ck_Estado_Matricula CHECK (Estado IN ('Matriculado', 'Finalizado', 'Abandonado', 'En curso'))
    -- He añadido la opcion de 'En curso' ya que pensandolo bien, tiene que haber una eleccion la cual sepa que estas cursando la formacion
);

CREATE TABLE Empresa (
    IdEmpresa number(14) PRIMARY KEY
);

CREATE TABLE BolsaEmpleo (
    IdBolsa number(14) PRIMARY KEY,
    IdEmpresa number(14) NOT NULL,
    EmpresaOfertante varchar2(30) NOT NULL,
    Candidato varchar2(32),
    TipoOferta varchar2(11) NOT NULL,
    TipoBolsa varchar2(9) NOT NULL,
    CONSTRAINT fk_Bolsa_Empresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa) ON DELETE CASCADE,
    CONSTRAINT ck_TipoOferta CHECK (TipoOferta IN ('Temporal', 'Permanente', 'Practicas')),
    CONSTRAINT ck_TipoBolsa CHECK (TipoBolsa IN ('Interna', 'Externa'))
);

CREATE TABLE NumOfertasActivas (
    OfertasActivas number(14) PRIMARY KEY,
    IdBolsa number(14) NOT NULL,
    CONSTRAINT fk_Ofertas_Bolsa FOREIGN KEY (IdBolsa) REFERENCES BolsaEmpleo(IdBolsa) ON DELETE CASCADE
);
-- Creo la tabla para el atributo multivaluado

CREATE TABLE InscripcionBolsa (
    IdInscripcion number(14) PRIMARY KEY,
    IdCiudadano number(14) NOT NULL,
    IdBolsa number(14) NOT NULL,
    FechaInscripcion DATE UNIQUE,
    Prioridad number(3),
    Estado varchar2(10) NOT NULL,
    CONSTRAINT fk_Inscripcion_Ciudadano FOREIGN KEY (IdCiudadano) REFERENCES Ciudadano(IdCiudadano) ON DELETE CASCADE,
    CONSTRAINT fk_Inscripcion_Bolsa FOREIGN KEY (IdBolsa) REFERENCES BolsaEmpleo(IdBolsa) ON DELETE CASCADE,
    CONSTRAINT ck_Estado_Inscripcion CHECK (Estado IN ('Activa', 'Suspendida', 'Baja'))
);

CREATE TABLE Oferta (
    IdOferta number(14) PRIMARY KEY,
    IdBolsa number(14) NOT NULL,
    TituloOferta varchar2(20) UNIQUE,
    Descripcion varchar2(30),
    EmpresaOfertante varchar2(30) NOT NULL,
    TipoContrato varchar2(17) NOT NULL,
    Estado varchar2(10) NOT NULL,
    CONSTRAINT fk_Oferta_Bolsa FOREIGN KEY (IdBolsa) REFERENCES BolsaEmpleo(IdBolsa) ON DELETE CASCADE,
    CONSTRAINT ck_TipoContrato_Oferta CHECK (TipoContrato IN ('Temporal', 'Indefinido', 'Contrato por obra')),
    CONSTRAINT ck_Estado_Oferta CHECK (Estado IN ('Abierta', 'Cerrada', 'EnProceso'))
);

CREATE TABLE Requisitos (
    Requisitos number(14) PRIMARY KEY,
    IdOferta number(14) NOT NULL,
    CONSTRAINT fk_Requisitos_Oferta FOREIGN KEY (IdOferta) REFERENCES Oferta(IdOferta) ON DELETE CASCADE
);

CREATE TABLE Postulacion (
    IdPostulacion number(14) PRIMARY KEY,
    IdOferta number(14) NOT NULL,
    FechaPostulacion DATE UNIQUE,
    Observaciones varchar2(32),
    Estado varchar2(10) NOT NULL,
    CONSTRAINT fk_Postulacion_Oferta FOREIGN KEY (IdOferta) REFERENCES Oferta(IdOferta) ON DELETE CASCADE,
    CONSTRAINT ck_Estado_Postulacion CHECK (Estado IN ('Enviada', 'EnProceso', 'Aceptada', 'Rechazada'))
);

DROP TABLE Postulacion CASCADE CONSTRAINTS PURGE;
DROP TABLE Requisitos CASCADE CONSTRAINTS PURGE;
DROP TABLE Oferta CASCADE CONSTRAINTS PURGE;
DROP TABLE InscripcionBolsa CASCADE CONSTRAINTS PURGE;
DROP TABLE NumOfertasActivas CASCADE CONSTRAINTS PURGE;
DROP TABLE BolsaEmpleo CASCADE CONSTRAINTS PURGE;
DROP TABLE Empresa CASCADE CONSTRAINTS PURGE;
DROP TABLE Matricula CASCADE CONSTRAINTS PURGE;
DROP TABLE Formacion CASCADE CONSTRAINTS PURGE;
DROP TABLE FormacionAvanzada CASCADE CONSTRAINTS PURGE;
DROP TABLE Situacion_Laboral CASCADE CONSTRAINTS PURGE;
DROP TABLE Email CASCADE CONSTRAINTS PURGE;
DROP TABLE Telefono CASCADE CONSTRAINTS PURGE;
DROP TABLE Ciudadano CASCADE CONSTRAINTS PURGE;

