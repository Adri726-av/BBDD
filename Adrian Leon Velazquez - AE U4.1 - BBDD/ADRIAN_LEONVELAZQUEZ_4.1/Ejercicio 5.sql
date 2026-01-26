CREATE TABLE Empresa (
    IdEmpresa number(14) PRIMARY KEY,
    CIF varchar2(16) UNIQUE NOT NULL,
    Nombre varchar2(32) NOT NULL,
    Calle varchar2(32),
    Ciudad varchar2(32),
    CodigoPostal number(6)
);

CREATE TABLE Curso (
    IdCurso number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Descripcion varchar2(128),
    FechaInicio DATE,
    FechaFin DATE,
    CentroFormacion varchar2(64)
);

CREATE TABLE Cliente (
    IdCliente number(14) PRIMARY KEY,
    DNI varchar2(9) UNIQUE NOT NULL,
    Nombre varchar2(32) NOT NULL,
    Apellido1 varchar2(30) NOT NULL,
    Apellido2 varchar2(30),
    Telefono varchar2(15),
    Email varchar2(32),   
    Calle varchar2(32),
    Numero number(5),
    Ciudad varchar2(32),
    CodigoPostal number(6)
);

CREATE TABLE Oficina (
    IdOficina number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL, 
    Calle varchar2(32),
    Numero number(5),
    Ciudad varchar2(32),
    CodigoPostal number(6),
    Horario varchar2(32)
);

CREATE TABLE Marca (
    IdMarca number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Descripcion varchar2(128),
    LugarOrigen varchar2(32),
    Historia varchar2(256)
);

CREATE TABLE Modelo (
    IdModelo number(14) PRIMARY KEY,
    FechaFabricacion DATE,
    TipoVehiculo varchar2(32),
    IdMarca number(14),
    CONSTRAINT fk_ModeloMarca FOREIGN KEY (IdMarca) REFERENCES Marca(IdMarca) ON DELETE CASCADE
);

CREATE TABLE Vehiculo (
    IdVehiculo number(14) PRIMARY KEY,
    Matricula varchar2(10) UNIQUE NOT NULL,
    Color varchar2(20),
    Kilometraje number(8),
    Estado varchar2(10) NOT NULL,
    IdModelo number(14),
    CONSTRAINT fk_VehiculoModelo FOREIGN KEY (IdModelo) REFERENCES Modelo(IdModelo) ON DELETE CASCADE,
    CONSTRAINT ck_EstadoVehiculo CHECK (Estado IN ('Nuevo', 'Usado'))
);

CREATE TABLE Empleado (
    IdEmpleado number(14) PRIMARY KEY,
    DNI varchar2(9) UNIQUE NOT NULL,
    Nombre varchar2(32) NOT NULL,
    Apellido1 varchar2(30) NOT NULL,
    Apellido2 varchar2(30),
    Telefono varchar2(15),
    Cargo varchar2(32),
    FechaContratacion DATE,
    IdEmpresa number(14),
    IdCurso number(14),
    CONSTRAINT fk_EmpleadoEmpresa FOREIGN KEY (IdEmpresa) REFERENCES Empresa(IdEmpresa) ON DELETE CASCADE,
    CONSTRAINT fk_EmpleadoCurso FOREIGN KEY (IdCurso) REFERENCES Curso(IdCurso) ON DELETE CASCADE
);

CREATE TABLE Alquiler (
    IdAlquiler number(14) PRIMARY KEY,
    FechaInicio DATE NOT NULL,
    FechaFin DATE,
    PrecioTotal number(8,2),
    TipoAlquiler varchar2(20) NOT NULL,
    IdCliente number(14),
    IdOficina number(14),
    IdEmpleado number(14),
    IdVehiculo number(14),
    CONSTRAINT fk_AlquilerCliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente) ON DELETE CASCADE,
    CONSTRAINT fk_AlquilerOficina FOREIGN KEY (IdOficina) REFERENCES Oficina(IdOficina) ON DELETE CASCADE,
    CONSTRAINT fk_AlquilerEmpleado FOREIGN KEY (IdEmpleado) REFERENCES Empleado(IdEmpleado) ON DELETE CASCADE,
    CONSTRAINT fk_AlquilerVehiculo FOREIGN KEY (IdVehiculo) REFERENCES Vehiculo(IdVehiculo) ON DELETE CASCADE,
    CONSTRAINT ck_TipoAlquiler CHECK (TipoAlquiler IN ('Diario', 'Semanal', 'Mensual'))
);

DROP TABLE Alquiler CASCADE CONSTRAINTS PURGE;
DROP TABLE Empleado CASCADE CONSTRAINTS PURGE;
DROP TABLE Vehiculo CASCADE CONSTRAINTS PURGE;
DROP TABLE Modelo CASCADE CONSTRAINTS PURGE;
DROP TABLE Marca CASCADE CONSTRAINTS PURGE;
DROP TABLE Oficina CASCADE CONSTRAINTS PURGE;
DROP TABLE Cliente CASCADE CONSTRAINTS PURGE;
DROP TABLE Curso CASCADE CONSTRAINTS PURGE;
DROP TABLE Empresa CASCADE CONSTRAINTS PURGE;