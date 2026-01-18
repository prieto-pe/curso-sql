-- ESTADOS
INSERT INTO Estado_Viaje (descripcion)
VALUES ('Planificado'), ('En curso'), ('Finalizado');

-- CHOFERES
INSERT INTO Chofer (nombre, apellido, dni, telefono)
VALUES 
('Juan', 'Perez', '30111222', '1122334455'),
('Ana', 'Gomez', '28999888', '1166778899');

-- CAMIONES
INSERT INTO Camion (patente, modelo, capacidad_tn)
VALUES 
('AA123BB', 'Scania', 25),
('CC456DD', 'Volvo', 30);

-- PRODUCTOS
INSERT INTO Producto (descripcion, unidad)
VALUES 
('Aceite', 'Litros'),
('Harina', 'Kg');

-- STOCK INICIAL
INSERT INTO Movimiento_Deposito (fecha, tipo, cantidad, id_producto, observaciones)
VALUES
(CURDATE(), 'INGRESO', 1000, 1, 'Stock inicial'),
(CURDATE(), 'INGRESO', 2000, 2, 'Stock inicial');

-- VIAJE
INSERT INTO Viaje (fecha, origen, destino, carga_tn, id_chofer, id_camion, id_estado)
VALUES ('2025-01-10', 'Buenos Aires', 'Rosario', 10, 1, 1, 1);

-- PRODUCTOS EN VIAJE
INSERT INTO Viaje_Producto (id_viaje, id_producto, cantidad)
VALUES 
(1, 1, 100),
(1, 2, 200);
