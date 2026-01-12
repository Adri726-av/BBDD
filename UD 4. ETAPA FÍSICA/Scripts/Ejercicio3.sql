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