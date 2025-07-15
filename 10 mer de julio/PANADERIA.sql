-- ===========================================
-- BASE DE DATOS: panaderia_dulcehogar
-- ===========================================

DROP DATABASE IF EXISTS panaderia_dulcehogar;
CREATE DATABASE panaderia_dulcehogar;
USE panaderia_dulcehogar;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  correo VARCHAR(100)
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  puesto VARCHAR(50)
);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2),
  stock INT
);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  contacto VARCHAR(100)
);

CREATE TABLE Pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE,
  id_cliente INT,
  id_empleado INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  total DECIMAL(12,2),
  fecha DATE,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT,
  metodo VARCHAR(50),
  monto DECIMAL(12,2),
  fecha DATE,
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura)
);

CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

CREATE TABLE Ingrediente (
  id_ingrediente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  unidad VARCHAR(50)
);

CREATE TABLE Produccion (
  id_produccion INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE,
  cantidad INT,
  id_producto INT,
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Pedido_Producto (
  id_pedido INT,
  id_producto INT,
  cantidad INT,
  PRIMARY KEY (id_pedido, id_producto),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

CREATE TABLE Producto_Ingrediente (
  id_producto INT,
  id_ingrediente INT,
  cantidad DECIMAL(10,2),
  PRIMARY KEY (id_producto, id_ingrediente),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  FOREIGN KEY (id_ingrediente) REFERENCES Ingrediente(id_ingrediente)
);

-- ===========================================
-- INSERT (5 por entidad clave)
-- ===========================================

INSERT INTO Cliente (nombre, correo) VALUES
('Carlos López', 'carlos@panaderia.com'),
('Ana Torres', 'ana@panaderia.com'),
('Luis Díaz', 'luis@panaderia.com'),
('Marta Ruiz', 'marta@panaderia.com'),
('Pedro Gómez', 'pedro@panaderia.com');

INSERT INTO Empleado (nombre, puesto) VALUES
('Laura Martínez', 'Panadera'),
('Diego Torres', 'Repostero'),
('Sofía Ramírez', 'Cajera'),
('Andrés Rojas', 'Administrador'),
('Paula Jiménez', 'Despachadora');

INSERT INTO Producto (nombre, precio, stock) VALUES
('Pan francés', 500, 100),
('Croissant', 2000, 50),
('Torta de chocolate', 25000, 20),
('Pastel de manzana', 8000, 30),
('Galletas surtidas', 5000, 40);

INSERT INTO Proveedor (nombre, contacto) VALUES
('Molinos del Valle', 'molinos@correo.com'),
('Distribuidora Harinas', 'ventas@harinas.com'),
('Lácteos Frescos', 'info@lacteos.com'),
('Huevos El Campo', 'contacto@huevos.com'),
('Azúcar y Miel', 'ventas@azucarmiel.com');

INSERT INTO Pedido (fecha, id_cliente, id_empleado) VALUES
('2025-07-10', 1, 1),
('2025-07-11', 2, 2),
('2025-07-12', 3, 3),
('2025-07-13', 4, 4),
('2025-07-14', 5, 5);

INSERT INTO Factura (id_pedido, total, fecha) VALUES
(1, 50000, '2025-07-10'),
(2, 30000, '2025-07-11'),
(3, 40000, '2025-07-12'),
(4, 35000, '2025-07-13'),
(5, 20000, '2025-07-14');

INSERT INTO Pago (id_factura, metodo, monto, fecha) VALUES
(1, 'Efectivo', 50000, '2025-07-10'),
(2, 'Tarjeta', 30000, '2025-07-11'),
(3, 'Transferencia', 40000, '2025-07-12'),
(4, 'Cheque', 35000, '2025-07-13'),
(5, 'Efectivo', 20000, '2025-07-14');

INSERT INTO Sucursal (nombre, direccion) VALUES
('Sucursal Norte', 'Calle 10 #5-67'),
('Sucursal Sur', 'Carrera 20 #15-30'),
('Sucursal Este', 'Avenida 1 #2-3'),
('Sucursal Oeste', 'Calle 8 #8-8'),
('Sucursal Centro', 'Cra 4 #4-4');

INSERT INTO Ingrediente (nombre, unidad) VALUES
('Harina', 'Kg'),
('Azúcar', 'Kg'),
('Leche', 'Litros'),
('Huevos', 'Docena'),
('Mantequilla', 'Kg');

INSERT INTO Produccion (fecha, cantidad, id_producto) VALUES
('2025-07-10', 100, 1),
('2025-07-11', 50, 2),
('2025-07-12', 20, 3),
('2025-07-13', 30, 4),
('2025-07-14', 40, 5);

INSERT INTO Pedido_Producto VALUES
(1, 1, 5), (2, 2, 10), (3, 3, 1), (4, 4, 2), (5, 5, 3);

INSERT INTO Producto_Ingrediente VALUES
(1, 1, 2), (2, 2, 0.5), (3, 3, 1), (4, 4, 0.2), (5, 5, 0.3);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Cliente SET correo = 'nuevo_carlos@panaderia.com' WHERE id_cliente = 1;
UPDATE Producto SET precio = 600 WHERE id_producto = 1;
UPDATE Empleado SET puesto = 'Encargado' WHERE id_empleado = 1;
UPDATE Factura SET total = 55000 WHERE id_factura = 1;
UPDATE Pago SET monto = 55000 WHERE id_pago = 1;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Pedido_Producto WHERE id_pedido = 1 AND id_producto = 1;
DELETE FROM Producto_Ingrediente WHERE id_producto = 1 AND id_ingrediente = 1;
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Factura WHERE id_factura = 1;
DELETE FROM Pedido WHERE id_pedido = 1;

-- ===========================================
-- SELECT, JOIN, SUBCONSULTA, FUNCIONES
-- ===========================================

-- JOIN
SELECT C.nombre, P.fecha
FROM Cliente C
JOIN Pedido P ON C.id_cliente = P.id_cliente;

SELECT Pr.nombre, I.nombre
FROM Producto Pr
JOIN Producto_Ingrediente PI ON Pr.id_producto = PI.id_producto
JOIN Ingrediente I ON PI.id_ingrediente = I.id_ingrediente;

-- SUBCONSULTA
SELECT nombre FROM Cliente
WHERE id_cliente IN (
  SELECT id_cliente FROM Pedido WHERE id_pedido IN (
    SELECT id_pedido FROM Factura WHERE total > 30000
  )
);

-- FUNCIONES
SELECT COUNT(*) FROM Pedido;
SELECT AVG(precio) FROM Producto;
SELECT MAX(total) FROM Factura;
SELECT MIN(monto) FROM Pago;
SELECT SUM(monto) FROM Pago;

SELECT nombre,
  CASE WHEN precio > 10000 THEN 'Costoso' ELSE 'Económico' END AS tipo_producto
FROM Producto;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE productos_por_pedido(IN pedidoId INT)
BEGIN
  SELECT Pr.nombre, PP.cantidad
  FROM Pedido_Producto PP
  JOIN Producto Pr ON PP.id_producto = Pr.id_producto
  WHERE PP.id_pedido = pedidoId;
END //
DELIMITER ;

CALL productos_por_pedido(2);
