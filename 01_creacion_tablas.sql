CREATE DATABASE LogisticaDB;
USE LogisticaDB;

-- =========================
-- TABLA: Chofer
-- =========================
CREATE TABLE Chofer (
    id_chofer INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    dni VARCHAR(20) UNIQUE,
    telefono VARCHAR(20)
);

-- =========================
-- TABLA: Camion
-- =========================
CREATE TABLE Camion (
    id_camion INT PRIMARY KEY AUTO_INCREMENT,
    patente VARCHAR(20) UNIQUE,
    modelo VARCHAR(50),
    capacidad_tn DECIMAL(5,2)
);

-- =========================
-- TABLA: Estado_Viaje
-- =========================
CREATE TABLE Estado_Viaje (
    id_estado INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(50)
);

-- =========================
-- TABLA: Viaje
-- =========================
CREATE TABLE Viaje (
    id_viaje INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    origen VARCHAR(100),
    destino VARCHAR(100),
    carga_tn DECIMAL(5,2),
    id_chofer INT,
    id_camion INT,
    id_estado INT,
    FOREIGN KEY (id_chofer) REFERENCES Chofer(id_chofer),
    FOREIGN KEY (id_camion) REFERENCES Camion(id_camion),
    FOREIGN KEY (id_estado) REFERENCES Estado_Viaje(id_estado)
);

-- =========================
-- TABLA: Producto
-- =========================
CREATE TABLE Producto (
    id_producto INT PRIMARY KEY AUTO_INCREMENT,
    descripcion VARCHAR(80),
    unidad VARCHAR(20)
);

-- =========================
-- TABLA: Viaje_Producto (CORRECCIÓN CLAVE)
-- =========================
CREATE TABLE Viaje_Producto (
    id_viaje INT,
    id_producto INT,
    cantidad DECIMAL(10,2),
    PRIMARY KEY (id_viaje, id_producto),
    FOREIGN KEY (id_viaje) REFERENCES Viaje(id_viaje),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- =========================
-- TABLA: Movimiento_Deposito
-- =========================
CREATE TABLE Movimiento_Deposito (
    id_mov INT PRIMARY KEY AUTO_INCREMENT,
    fecha DATE,
    tipo VARCHAR(20),
    cantidad DECIMAL(10,2),
    id_producto INT,
    observaciones VARCHAR(200),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
