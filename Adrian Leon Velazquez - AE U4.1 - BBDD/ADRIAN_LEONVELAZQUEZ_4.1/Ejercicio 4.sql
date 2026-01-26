CREATE TABLE Sede (
    IdSede number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Direccion varchar2(64) NOT NULL
);

CREATE TABLE Departamento (
    IdDepartamento number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Descripcion varchar2(128),
    TipoDepartamento varchar2(20) NOT NULL,
    IdSede number(14) NOT NULL,
    CONSTRAINT fk_DepartamentoSede FOREIGN KEY (IdSede) REFERENCES Sede(IdSede) ON DELETE CASCADE,
    CONSTRAINT ck_TipoDepartamento CHECK (TipoDepartamento IN ('Desarrollo', 'Sistemas', 'Soporte'))
);

CREATE TABLE Programador (
    IdProgramador number(14) PRIMARY KEY,
    DNI varchar2(9) UNIQUE NOT NULL,
    Nombre varchar2(32) NOT NULL,
    Apellidos varchar2(64) NOT NULL,
    FechaNacimiento DATE,
    Edad number(3),
    Telefono varchar2(15),
    IdDepartamento number(14),
    CONSTRAINT fk_ProgramadorDepartamento FOREIGN KEY (IdDepartamento) REFERENCES Departamento(IdDepartamento) ON DELETE CASCADE
);

CREATE TABLE Equipo_Desarrollo (
    IdEquipoDesarrollo number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Descripcion varchar2(128),
    TecnologiasPrincipales varchar2(128)
);

    -- Pongo participa con la clave primaria compuesta ya que es una N:M y tiene las claves de las demas, pero no estoy seguro de si lo he hecho bien 
CREATE TABLE Participa (
    IdPrograma number(14),
    IdProgramador number(14),
    IdEquipoDesarrollo number(14),
    CONSTRAINT pk_Participa PRIMARY KEY (IdPrograma, IdProgramador, IdEquipoDesarrollo),
    CONSTRAINT fk_ParticipaProgramador FOREIGN KEY (IdProgramador) REFERENCES Programador(IdProgramador) ON DELETE CASCADE,
    CONSTRAINT fk_ParticipaEquipo FOREIGN KEY (IdEquipoDesarrollo) REFERENCES Equipo_Desarrollo(IdEquipoDesarrollo) ON DELETE CASCADE
);

CREATE TABLE Proyecto (
    IdProyecto number(14) PRIMARY KEY,
    Nombre varchar2(64) NOT NULL,
    Descripcion varchar2(128),
    FechaInicio DATE DEFAULT SYSDATE,
    FechaFin DATE,
    Presupuesto number(10,2),
    Cliente varchar2(64),
    EstadoProyecto varchar2(20) DEFAULT 'Pendiente',
    Duracion number(5),
    CONSTRAINT ck_EstadoProyecto CHECK (EstadoProyecto IN ('Pendiente', 'En curso', 'Finalizado'))
);

CREATE TABLE Senior (
    IdSenior number(14) PRIMARY KEY,
    AnosExperiencia number(2),
    Especialidad varchar2(64),
    Lenguajes varchar2(128),
    IdProgramador number(14) NOT NULL,
    IdJunior number(14),
    CONSTRAINT fk_SeniorProgramador FOREIGN KEY (IdProgramador) REFERENCES Programador(IdProgramador) ON DELETE CASCADE
);

CREATE TABLE Junior (
    IdJunior number(14) PRIMARY KEY,
    NivelJunior varchar2(20) NOT NULL,
    Certificaciones varchar2(128),
    Lenguajes varchar2(128),
    IdProgramador number(14) NOT NULL,
    IdSenior number(14),
    CONSTRAINT fk_JuniorProgramador FOREIGN KEY (IdProgramador) REFERENCES Programador(IdProgramador) ON DELETE CASCADE,
    CONSTRAINT ck_NivelJunior CHECK (NivelJunior IN ('Junior 1', 'Junior 2'))
);

DROP TABLE Junior CASCADE CONSTRAINTS PURGE;
DROP TABLE Senior CASCADE CONSTRAINTS PURGE;
DROP TABLE Proyecto CASCADE CONSTRAINTS PURGE;
DROP TABLE Participa CASCADE CONSTRAINTS PURGE;
DROP TABLE Equipo_Desarrollo CASCADE CONSTRAINTS PURGE;
DROP TABLE Programador CASCADE CONSTRAINTS PURGE;
DROP TABLE Departamento CASCADE CONSTRAINTS PURGE;
DROP TABLE Sede CASCADE CONSTRAINTS PURGE;