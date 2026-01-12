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