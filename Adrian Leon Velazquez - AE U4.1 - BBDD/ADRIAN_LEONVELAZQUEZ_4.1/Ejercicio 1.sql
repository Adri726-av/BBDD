CREATE TABLE Sede (
    IdSede number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Direccion varchar2(64) NOT NULL,
    Ciudad varchar2(32),
    Telefono varchar2(15),
    Email varchar2(32)
);

CREATE TABLE CicloFormativo (
    IdCicloFormativo number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Nivel varchar2(20),
    Duracion number(3),
    IdSede number(14),
    CONSTRAINT fk_CicloSede FOREIGN KEY (IdSede)
        REFERENCES Sede(IdSede) ON DELETE CASCADE
);

CREATE TABLE Docente (
    IdDocente number(14) PRIMARY KEY,
    DNI varchar2(9) UNIQUE NOT NULL,
    Nombre varchar2(32) NOT NULL,
    Apellidos varchar2(64) NOT NULL,
    Email varchar2(32),
    Curso varchar2(20)
);

CREATE TABLE Modulo (
    IdModulo number(14) PRIMARY KEY,
    Codigo_Modulo varchar2(20) UNIQUE NOT NULL,
    Nombre varchar2(64) NOT NULL,
    Horas_Totales number(4),
    Curso varchar2(20),
    IdCicloFormativo number(14),
    IdDocente number(14),
    CONSTRAINT fk_ModuloCiclo FOREIGN KEY (IdCicloFormativo) REFERENCES CicloFormativo(IdCicloFormativo) ON DELETE CASCADE,
    CONSTRAINT fk_ModuloDocente FOREIGN KEY (IdDocente) REFERENCES Docente(IdDocente) ON DELETE CASCADE
);

CREATE TABLE Estudiante (
    IdEstudiante number(14) PRIMARY KEY,
    DNI varchar2(9) UNIQUE NOT NULL,
    Nombre varchar2(32) NOT NULL,
    Apellidos varchar2(64) NOT NULL,
    Curso varchar2(20),
    IdCicloFormativo number(14),
    CONSTRAINT fk_EstudianteCiclo FOREIGN KEY (IdCicloFormativo) REFERENCES CicloFormativo(IdCicloFormativo) ON DELETE CASCADE
);

CREATE TABLE Matricula (
    IdMatricula number(14) PRIMARY KEY,
    FechaMatricula DATE DEFAULT SYSDATE,
    Curso varchar2(20),
    Estado varchar2(20) NOT NULL,
    IdEstudiante number(14),
    CONSTRAINT fk_MatriculaEstudiante FOREIGN KEY (IdEstudiante) REFERENCES Estudiante(IdEstudiante) ON DELETE CASCADE,
    CONSTRAINT ck_EstadoMatricula CHECK (Estado IN ('Pendiente', 'Activa', 'Finalizada'))
);

DROP TABLE Matricula CASCADE CONSTRAINTS PURGE;
DROP TABLE Estudiante CASCADE CONSTRAINTS PURGE;
DROP TABLE Modulo CASCADE CONSTRAINTS PURGE;
DROP TABLE Docente CASCADE CONSTRAINTS PURGE;
DROP TABLE CicloFormativo CASCADE CONSTRAINTS PURGE;
DROP TABLE Sede CASCADE CONSTRAINTS PURGE;