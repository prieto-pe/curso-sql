USE LogisticaDB;

-- =====================================================
-- ======================= VISTAS ======================
-- =====================================================

-- Vista 1: Detalle completo de viajes, choferes, camiones y productos
CREATE VIEW vw_detalle_viajes_productos AS
SELECT 
    v.id_viaje,
    v.fecha,
    v.origen,
    v.destino,
    c.nombre AS nombre_chofer,
    c.apellido AS apellido_chofer,
    cam.patente AS camion,
    p.descripcion AS producto,
    vp.cantidad
FROM Viaje v
JOIN Chofer c ON v.id_chofer = c.id_chofer
JOIN Camion cam ON v.id_camion = cam.id_camion
JOIN Viaje_Producto vp ON v.id_viaje = vp.id_viaje
JOIN Producto p ON vp.id_producto = p.id_producto;


-- Vista 2: Stock actual por producto
CREATE VIEW vw_stock_actual_producto AS
SELECT 
    p.id_producto,
    p.descripcion,
    SUM(md.cantidad) AS stock_actual
FROM Producto p
JOIN Movimiento_Deposito md ON p.id_producto = md.id_producto
GROUP BY p.id_producto, p.descripcion;


-- =====================================================
-- ===================== FUNCIONES =====================
-- =====================================================

DELIMITER $$

-- Función 1: Total de productos transportados en un viaje
CREATE FUNCTION fn_total_producto_viaje(p_id_viaje INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);

    SELECT SUM(cantidad)
    INTO total
    FROM Viaje_Producto
    WHERE id_viaje = p_id_viaje;

    RETURN IFNULL(total, 0);
END$$


-- Función 2: Stock actual de un producto
CREATE FUNCTION fn_stock_producto(p_id_producto INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE stock DECIMAL(10,2);

    SELECT SUM(cantidad)
    INTO stock
    FROM Movimiento_Deposito
    WHERE id_producto = p_id_producto;

    RETURN IFNULL(stock, 0);
END$$

DELIMITER ;


-- =====================================================
-- ================= STORED PROCEDURES =================
-- =====================================================

DELIMITER $$

-- SP 1: Crear un viaje
CREATE PROCEDURE sp_crear_viaje (
    IN p_fecha DATE,
    IN p_origen VARCHAR(100),
    IN p_destino VARCHAR(100),
    IN p_carga DECIMAL(5,2),
    IN p_id_chofer INT,
    IN p_id_camion INT,
    IN p_id_estado INT
)
BEGIN
    INSERT INTO Viaje (fecha, origen, destino, carga_tn, id_chofer, id_camion, id_estado)
    VALUES (p_fecha, p_origen, p_destino, p_carga, p_id_chofer, p_id_camion, p_id_estado);
END$$


-- SP 2: Registrar movimiento de depósito
CREATE PROCEDURE sp_registrar_movimiento_deposito (
    IN p_fecha DATE,
    IN p_tipo VARCHAR(20),
    IN p_cantidad DECIMAL(10,2),
    IN p_id_producto INT,
    IN p_observaciones VARCHAR(200)
)
BEGIN
    INSERT INTO Movimiento_Deposito (fecha, tipo, cantidad, id_producto, observaciones)
    VALUES (p_fecha, p_tipo, p_cantidad, p_id_producto, p_observaciones);
END$$

DELIMITER ;


-- =====================================================
-- ====================== TRIGGER ======================
-- =====================================================

DELIMITER $$

-- Trigger: Descuenta stock automáticamente al asignar productos a un viaje
CREATE TRIGGER tr_descuento_stock_viaje
AFTER INSERT ON Viaje_Producto
FOR EACH ROW
BEGIN
    INSERT INTO Movimiento_Deposito (fecha, tipo, cantidad, id_producto, observaciones)
    VALUES (
        CURDATE(),
        'EGRESO',
        -NEW.cantidad,
        NEW.id_producto,
        CONCAT('Salida por viaje ID ', NEW.id_viaje)
    );
END$$

DELIMITER ;
