/*
Creamos Proveedor
*/

CREATE TABLE Proveedor(
	IdProveedor number(14) PRIMARY KEY,
	Nombre varchar2(32) NOT NULL,
    -- Tenemos en cuenta los VAT internacionales (ES-CIF)
	CIF varchar2(16) NOT NULL UNIQUE,
    -- Dejamos abierto el campo dirección
	Direccion varchar2(128) NOT NULL,
	Correo varchar2(32),
    -- Usamos la norma europea de los teléfonos internacionales
    Telefono varchar2(15),
    -- IBAN internacional de 34 valores
    CuentaBancaria varchar2(36)
);

/*
Creamos Tienda
*/

CREATE TABLE Tienda(
	IdTienda number(14) PRIMARY KEY,
	Nombre varchar2(32) NOT NULL,
    -- Tenemos en cuenta los VAT internacionales (ES-CIF)
	CIF varchar2(16) NOT NULL UNIQUE,
    -- Dejamos abierto el campo dirección
	Direccion varchar2(128) NOT NULL,
	Correo varchar2(32),
    -- Usamos la norma europea de los teléfonos internacionales
    Telefono varchar2(15),
    -- IBAN internacional de 34 valores
    CuentaBancaria varchar2(36),
    Tipo varchar2(14) NOT NULL,
    CONSTRAINT ck_TipoTienda CHECK(Tipo IN('On-line','Física')) 
);

/*
Creamos Producto
*/

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
    CONSTRAINT ck_CategoriaProducto CHECK(Categoria IN('Móviles','Carcasas','Cargadores','Tarjetas SIM', 'Accesorios')) 
);

/*
Creamos Compra
*/

CREATE TABLE Compra(
    IdCompra number(14),
    IdProveedor number(14),
    IdTienda number(14),
    Fecha DATE DEFAULT SYSDATE,
    CONSTRAINT pk_compra PRIMARY KEY(IdCompra, IdProveedor, IdTienda),
    CONSTRAINT fk_CompraProveedor FOREIGN KEY (IdProveedor) REFERENCES Proveedor(IdProveedor) ON DELETE CASCADE,
    CONSTRAINT fk_CompraTienda FOREIGN KEY (IdTienda) REFERENCES Tienda(IdTienda) ON DELETE CASCADE
);


/*
Creamos Linea de Compra
*/



CREATE TABLE LineaCompra(
   IdLinComp number(14) NOT NULL,
   IdCompra number(14) NOT NULL,
   IdProveedor number(14) NOT NULL,
   IdTienda number(14) NOT NULL,
   IdProducto number(14) NOT NULL,
   Cantidad number(5) DEFAULT 0,
   IVA number(2) DEFAULT 21,
   Descuento number(3),
   PrecioUnitario number(6,2),
   -- PrecioUnitario- (Precio Unitario * (Descuento/100)) * Cantidad
   TotalLinea number(6,2),
   TotalIVALinea number(6,2),
   CONSTRAINT pk_lineaCompra PRIMARY KEY(IdLinComp, IdCompra, IdProducto),
   CONSTRAINT fk_compra FOREIGN KEY (IdCompra,IdProveedor,IdTienda) REFERENCES Compra(IdCompra,IdProveedor,IdTienda) ON DELETE CASCADE,
   CONSTRAINT fk_producto FOREIGN KEY (IdProducto) REFERENCES Producto(IdProducto) ON DELETE CASCADE,
   CONSTRAINT ck_IVA CHECK (IVA IN (0,4,10,21))
);


