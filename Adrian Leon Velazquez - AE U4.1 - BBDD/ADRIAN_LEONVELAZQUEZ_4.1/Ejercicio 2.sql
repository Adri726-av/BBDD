CREATE TABLE Persona (
    IdPersona number(14) PRIMARY KEY,
    DNI varchar2(9) UNIQUE NOT NULL,
    Nombre varchar2(32) NOT NULL,
    Apellido1 varchar2(30) NOT NULL,
    Apellido2 varchar2(30)
);

CREATE TABLE Alumno (
    IdAlumno number(14) PRIMARY KEY,
    Email varchar2(32) UNIQUE NOT NULL,
    Tipo varchar2(32) NOT NULL,
    Bloqueado char(1) DEFAULT 'N',
    CONSTRAINT ck_TipoAlumno CHECK (Tipo IN ('Educación Secundaria', 'Grado', 'Máster'))
);

CREATE TABLE Personal (
    IdPersonal number(14) PRIMARY KEY,
    Cargo varchar2(32),
    Area varchar2(32) NOT NULL,
    CONSTRAINT ck_AreaPersonal CHECK (Area IN ('Biblioteca', 'Servicio Técnico'))
);

CREATE TABLE Bloqueo (
    IdBloqueo number(14) PRIMARY KEY,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    Motivo varchar2(128),
    IdPersonal number(14),
    IdAlumno number(14),
    CONSTRAINT fk_BloqueoPersonal FOREIGN KEY (IdPersonal) REFERENCES Personal(IdPersonal) ON DELETE CASCADE,
    CONSTRAINT fk_BloqueoAlumno FOREIGN KEY (IdAlumno) REFERENCES Alumno(IdAlumno) ON DELETE CASCADE
);

CREATE TABLE Aviso (
    IdAviso number(14) PRIMARY KEY,
    FechaAviso DATE DEFAULT SYSDATE,
    TipoAviso varchar2(32),
    IdPersonal number(14),
    IdAlumno number(14),
    CONSTRAINT fk_AvisoPersonal FOREIGN KEY (IdPersonal) REFERENCES Personal(IdPersonal) ON DELETE CASCADE,
    CONSTRAINT fk_AvisoAlumno FOREIGN KEY (IdAlumno) REFERENCES Alumno(IdAlumno) ON DELETE CASCADE
);

CREATE TABLE Gestion (
    IdGestion number(14) PRIMARY KEY,
    TipoGestion varchar2(32) NOT NULL,
    Fecha DATE DEFAULT SYSDATE,
    IdPersonal number(14),
    CONSTRAINT fk_GestionPersonal FOREIGN KEY (IdPersonal)
        REFERENCES Personal(IdPersonal) ON DELETE CASCADE,
    CONSTRAINT ck_TipoGestion CHECK (TipoGestion IN ('Alta', 'Baja', 'Bloqueo', 'Desbloqueo', 'Aviso'))
);

CREATE TABLE Sede (
    IdSede number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Direccion varchar2(64),
    CONSTRAINT ck_NombreSede CHECK (Nombre IN ('Porvenir', 'Cartuja'))
);

CREATE TABLE Material (
    IdMaterial number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Descripcion varchar2(128),
    FechaAdquisicion DATE,
    Estado varchar2(32) NOT NULL,
    Disponible char(1) DEFAULT 'S',
    CONSTRAINT ck_EstadoMaterial CHECK (Estado IN ('Nuevo', 'Seminuevo', 'En mal estado'))
);

CREATE TABLE Libro (
    IdLibro number(14) PRIMARY KEY,
    Nombre varchar2(64) NOT NULL,
    Autor varchar2(64),
    Editorial varchar2(64),
    Idioma varchar2(20) NOT NULL,
    NumPaginas number(5),
    Genero varchar2(32),
    DiasPermitidos number(3),
    IdSede number(14),
    CONSTRAINT fk_LibroSede FOREIGN KEY (IdSede) REFERENCES Sede(IdSede) ON DELETE CASCADE,
    CONSTRAINT ck_IdiomaLibro CHECK (Idioma IN ('Español', 'Inglés', 'Francés')),
    CONSTRAINT ck_GeneroLibro CHECK (Genero IN ('Terror', 'Fantasía', 'Comedia', 'Ciencia Ficción'))
);

CREATE TABLE Camara (
    IdCamara number(14) PRIMARY KEY,
    Marca varchar2(32),
    Modelo varchar2(32),
    Resolucion varchar2(20),
    Tipo varchar2(10),
    CONSTRAINT ck_TipoCamara CHECK (Tipo IN ('HD', '4K'))
);

CREATE TABLE Prestamo (
    IdPrestamo number(14) PRIMARY KEY,
    FechaReserva DATE NOT NULL,
    FechaDevolucion DATE,
    RetrasoDias number(4),
    IdGestion number(14),
    IdAlumno number(14),
    CONSTRAINT fk_PrestamoGestion FOREIGN KEY (IdGestion) REFERENCES Gestion(IdGestion) ON DELETE CASCADE,
    CONSTRAINT fk_PrestamoAlumno FOREIGN KEY (IdAlumno) REFERENCES Alumno(IdAlumno) ON DELETE CASCADE
);

DROP TABLE Prestamo CASCADE CONSTRAINTS PURGE;
DROP TABLE Camara CASCADE CONSTRAINTS PURGE;
DROP TABLE Libro CASCADE CONSTRAINTS PURGE;
DROP TABLE Material CASCADE CONSTRAINTS PURGE;
DROP TABLE Sede CASCADE CONSTRAINTS PURGE;
DROP TABLE Gestion CASCADE CONSTRAINTS PURGE;
DROP TABLE Aviso CASCADE CONSTRAINTS PURGE;
DROP TABLE Bloqueo CASCADE CONSTRAINTS PURGE;
DROP TABLE Personal CASCADE CONSTRAINTS PURGE;
DROP TABLE Alumno CASCADE CONSTRAINTS PURGE;
DROP TABLE Persona CASCADE CONSTRAINTS PURGE;