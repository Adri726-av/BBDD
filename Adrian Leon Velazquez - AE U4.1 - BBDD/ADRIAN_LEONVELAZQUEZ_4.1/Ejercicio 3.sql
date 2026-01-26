CREATE TABLE Proveedor(
    IdProveedor number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    -- Tenemos en cuenta los VAT internacionales (ES-CIF)
    CIF varchar2(16) NOT NULL UNIQUE,
    -- Dejamos abierto el campo dirección (Sin poner el compuesto todavía)
    Direccion varchar2(128) NOT NULL,
    Correo varchar2(32),
    -- Usamos la norma europea 
    Telefono varchar2(15),
    -- IBAN internacional de 34 valores(2+ por si acaso)
    CuentaBancaria varchar(36)
);

CREATE TABLE Tienda(
    IdTienda number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    -- Tenemos en cuenta los VAT internacionales (ES-CIF)
    CIF varchar2(16) NOT NULL UNIQUE,
    -- Dejamos abierto el campo dirección (Sin poner el compuesto todavía)
    Direccion varchar2(128) NOT NULL,
    Correo varchar2(32),
    -- Usamos la norma europea 
    Telefono varchar2(15),
    -- IBAN internacional de 34 valores(2+ por si acaso)
    CuentaBancaria varchar(36),
    Tipo varchar2(14) NOT NULL,
    CONSTRAINT ck_Tipotienda CHECK(Tipo IN ('On-line', 'Física'))
);

CREATE TABLE Producto(
	IdProducto number(14) PRIMARY KEY,
	Nombre varchar2(32) NOT NULL,
    -- Tenemos en cuenta los VAT internacionales (ES-CIF)
	SKU varchar2(32) NOT NULL UNIQUE,
	Marca varchar2(32) NOT NULL,
	Modelo varchar2(32) NOT NULL,
    -- Precio estándar de 6 dígitos + 2 decimales
	Precio number(6,2),
    Categoria varchar2(32) DEFAULT 'Móviles',
    -- Los estados posibles son: 'B' Borrador (por defecto), 'P' Publicado y 'E' Eliminado
    Estado char(1) DEFAULT 'B',
    UltimaModificacion DATE DEFAULT SYSDATE,
    CONSTRAINT ck_CategoriaProducto CHECK(Categoria IN('Móviles','Carcasas','Cargadores','Tarjetas SIM', 'Accesorios')),
    CONSTRAINT ck_EstadoProducto CHECK(Estado IN('B','P','E'))
);

CREATE TABLE Compra (
    IdCompra number(14),
    IdProveedor number(14),
    IdTienda number(14),
    Fecha DATE DEFAULT SYSDATE,
    CONSTRAINT pk_compra PRIMARY KEY (IdCompra, IdProveedor, IdTienda),
    CONSTRAINT fk_CompraProveedor FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor) ON DELETE CASCADE,
    CONSTRAINT fk_Compratienda FOREIGN KEY (IdTienda) REFERENCES Tienda(IdTienda) ON DELETE CASCADE
);

CREATE TABLE LineaCompra(
   IdLineaCompra number(14) NOT NULL,
   IdCompra number(14) NOT NULL,
   IdProducto number(14) NOT NULL,
   IdProveedor number(14) NOT NULL,
   IdTienda number(14) NOT NULL,
   Cantidad number(5) DEFAULT 0,
   IVA number(2) DEFAULT 21,
   Descuento number(3) DEFAULT 0,
   PrecioUnitario number(6,2),
   -- PrecioUnitario- (Precio Unitario * (Descuento/100)) * Cantidad
   TotalLinea number(6,2),
   TotalIVALinea number(6,2),
   -- He añadido estos cambios en la etapa lógica y la etapa conceptual
   CONSTRAINT pk_lineaCompra PRIMARY KEY(IdLineaCompra, IdCompra, IdProducto, IdProveedor, IdTienda),
   CONSTRAINT fk_compra FOREIGN KEY (IdCompra) REFERENCES Compra(IdCompra, IdProveedor, IdTienda) ON DELETE CASCADE,
   CONSTRAINT fk_producto FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto) ON DELETE CASCADE,
   CONSTRAINT ck_IVA CHECK (IVA IN (0,4,10,21))
);

CREATE TABLE Cliente(
    IdCliente number(14) PRIMARY KEY,
    Nombre varchar2(32) NOT NULL,
    Apellido1 varchar2(30) NOT NULL,
    Apellido2 varchar2(30),
    Telefono varchar2(15),
    Email varchar2(32),
    Calle varchar2(20),
    Numero number(5),
    Ciudad varchar2(30),
    CodPostal number(6)
);

CREATE TABLE Empleado(
    IdEmpleado number(14),
    IdTienda number(14),
    DNI varchar2(9) UNIQUE,
    Apellido1 varchar2(30) NOT NULL,
    Apellido2 varchar2(30),
    Telefono varchar2(15) NOT NULL,
    Cargo varchar2(30),
    CONSTRAINT pk_Empleado PRIMARY KEY(IdEmpleado, IdTienda),
    CONSTRAINT fk_Tienda FOREIGN KEY (IdTienda) REFERENCES Tienda(IdTienda) ON DELETE CASCADE
);

CREATE TABLE Venta(
    IdVenta number(14),
    IdEmpleado number(14),
    IdCliente number(14),
    IdTienda number(14),
    FechaVenta DATE DEFAULT SYSDATE,
    Importe number(6,2) NOT NULL,
    MetodoPago varchar2(30) DEFAULT 'Efectivo',
    CONSTRAINT pk_Venta PRIMARY KEY(IdVenta, IdEmpleado, IdCliente, IdTienda),
    CONSTRAINT fk_Empleado FOREIGN KEY (IdEmpleado, IdTienda) REFERENCES Empleado(IdEmpleado, IdTienda) ON DELETE CASCADE,
    CONSTRAINT fk_Cliente FOREIGN KEY (IdCliente) REFERENCES Cliente(IdCliente) ON DELETE CASCADE,
    CONSTRAINT fk_TiendaVenta FOREIGN KEY (IdTienda) REFERENCES Tienda(IdTienda) ON DELETE CASCADE,
    CONSTRAINT ck_MetodoPago CHECK (MetodoPago IN ('Efectivo', 'Tarjeta', 'Digital'))
    -- Digital me refiero a Paypal y plataformas similares
);

CREATE TABLE LineaVenta(
    IdLineaVenta number(14) NOT NULL,
    IdVenta number(14) NOT NULL,
    IdProducto number(14) NOT NULL,
    IdEmpleado number(14) NOT NULL,
    IdCliente number(14) NOT NULL,
    IdTienda number(14) NOT NULL,
    IVA number(2) DEFAULT 21,
    Cantidad number(5) DEFAULT 0,
    Descuento number(3) DEFAULT 0,
    PrecioUnitario number(6,2),
    -- PrecioUnitario- (Precio Unitario * (Descuento/100)) * Cantidad
    TotalLinea number(6,2),
    TotalIVALinea number(6,2),
    -- He añadido estos cambios en la etapa lógica y la etapa conceptual
    CONSTRAINT pk_LineaVenta PRIMARY KEY (IdLineaVenta, IdVenta, IdProducto, IdEmpleado, IdCliente, IdTienda),
    CONSTRAINT fk_Venta FOREIGN KEY (IdVenta, IdEmpleado, IdCliente, IdTienda) REFERENCES Venta(IdVenta, IdEmpleado, IdCliente, IdTienda) ON DELETE CASCADE,
    CONSTRAINT fk_producto FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto) ON DELETE CASCADE,
    CONSTRAINT ck_IVA CHECK (IVA IN (0,4,10,21))
);

DROP TABLE LineaVenta CASCADE CONSTRAINTS PURGE;
DROP TABLE Venta CASCADE CONSTRAINTS PURGE;
DROP TABLE Empleado CASCADE CONSTRAINTS PURGE;
DROP TABLE Cliente CASCADE CONSTRAINTS PURGE;
DROP TABLE LineaCompra CASCADE CONSTRAINTS PURGE;
DROP TABLE Compra CASCADE CONSTRAINTS PURGE;
DROP TABLE Producto CASCADE CONSTRAINTS PURGE;
DROP TABLE Tienda CASCADE CONSTRAINTS PURGE;
DROP TABLE Proveedor CASCADE CONSTRAINTS PURGE;