-- ===========================================
-- BASE DE DATOS: tienda_celulares
-- ===========================================

DROP DATABASE IF EXISTS tienda_celulares;
CREATE DATABASE tienda_celulares;
USE tienda_celulares;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  cargo VARCHAR(50)
);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  contacto VARCHAR(100)
);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2),
  stock INT
);

CREATE TABLE Venta (
  id_venta INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_empleado INT,
  fecha DATE,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_venta INT,
  total DECIMAL(12,2),
  fecha DATE,
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT,
  monto DECIMAL(12,2),
  fecha_pago DATE,
  metodo VARCHAR(50),
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura)
);

CREATE TABLE Garantia (
  id_garantia INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT,
  tiempo_meses INT,
  descripcion VARCHAR(200),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Tienda (
  id_tienda INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

CREATE TABLE Almacen (
  id_almacen INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Venta_Producto (
  id_venta INT,
  id_producto INT,
  cantidad INT,
  PRIMARY KEY (id_venta, id_producto),
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Proveedor_Producto (
  id_proveedor INT,
  id_producto INT,
  PRIMARY KEY (id_proveedor, id_producto),
  FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ===========================================
-- INSERT (5 por entidad clave)
-- ===========================================

INSERT INTO Cliente (nombre, telefono) VALUES
('Juan Pérez', '3101234567'),
('María López', '3109876543'),
('Carlos Díaz', '3112223333'),
('Paola Ruiz', '3123334444'),
('Andrés Mora', '3135556666');

INSERT INTO Empleado (nombre, cargo) VALUES
('Laura Torres', 'Vendedor'),
('Santiago Peña', 'Cajero'),
('Valeria Gómez', 'Gerente'),
('Camilo Restrepo', 'Técnico'),
('Lucía Mendoza', 'Asistente');

INSERT INTO Proveedor (nombre, contacto) VALUES
('Distribuidores Celulares', 'contacto@distcel.com'),
('Importadora Mobile', 'ventas@importadora.com'),
('TecnoProveedores', 'info@tecnoproveedores.com'),
('Celumarket', 'atencion@celumarket.com'),
('SmartGlobal', 'smart@global.com');

INSERT INTO Producto (nombre, precio, stock) VALUES
('iPhone 14', 4500000, 20),
('Samsung S23', 3200000, 25),
('Xiaomi Redmi Note 12', 1500000, 30),
('Motorola Edge', 1800000, 15),
('Huawei P50', 2800000, 10);

INSERT INTO Venta (id_cliente, id_empleado, fecha) VALUES
(1, 1, '2025-08-01'),
(2, 2, '2025-08-02'),
(3, 3, '2025-08-03'),
(4, 4, '2025-08-04'),
(5, 5, '2025-08-05');

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Cliente SET telefono = '3200000000' WHERE id_cliente = 1;
UPDATE Empleado SET cargo = 'Supervisor' WHERE id_empleado = 3;
UPDATE Producto SET precio = 4600000 WHERE id_producto = 1;
UPDATE Venta SET fecha = '2025-08-06' WHERE id_venta = 5;
UPDATE Garantia SET tiempo_meses = 24 WHERE id_garantia = 1;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Venta_Producto WHERE id_venta = 1 AND id_producto = 1;
DELETE FROM Proveedor_Producto WHERE id_proveedor = 1 AND id_producto = 1;
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Factura WHERE id_factura = 1;
DELETE FROM Venta WHERE id_venta = 1;

-- ===========================================
-- SELECT & FUNCIONES
-- ===========================================

-- JOINs
SELECT C.nombre, V.fecha
FROM Cliente C
JOIN Venta V ON C.id_cliente = V.id_cliente;

SELECT F.id_factura, P.nombre, VP.cantidad
FROM Venta_Producto VP
JOIN Producto P ON VP.id_producto = P.id_producto
JOIN Venta V ON VP.id_venta = V.id_venta
JOIN Factura F ON V.id_venta = F.id_venta;

SELECT Pr.nombre, P.nombre AS producto
FROM Proveedor Pr
JOIN Proveedor_Producto PP ON Pr.id_proveedor = PP.id_proveedor
JOIN Producto P ON PP.id_producto = P.id_producto;

-- SUBCONSULTA
SELECT nombre FROM Cliente WHERE id_cliente IN (
  SELECT id_cliente FROM Venta WHERE id_venta IN (
    SELECT id_venta FROM Factura WHERE total > 3000000
  )
);

-- FUNCIONES
SELECT COUNT(*) FROM Venta;
SELECT AVG(precio) FROM Producto;
SELECT MAX(precio) FROM Producto;
SELECT MIN(precio) FROM Producto;
SELECT SUM(precio) FROM Producto;

SELECT nombre,
  CASE WHEN precio > 2000000 THEN 'Alta Gama' ELSE 'Económico' END AS tipo
FROM Producto;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE productos_venta(IN ventaId INT)
BEGIN
  SELECT P.nombre, VP.cantidad
  FROM Venta_Producto VP
  JOIN Producto P ON VP.id_producto = P.id_producto
  WHERE VP.id_venta = ventaId;
END //
DELIMITER ;

CALL productos_venta(1);
