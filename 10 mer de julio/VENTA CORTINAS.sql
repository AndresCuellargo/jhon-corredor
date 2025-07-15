-- ===========================================
-- BASE DE DATOS: ventas_cortinas
-- ===========================================

DROP DATABASE IF EXISTS ventas_cortinas;
CREATE DATABASE ventas_cortinas;
USE ventas_cortinas;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) UNIQUE
);

CREATE TABLE Vendedor (
  id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20)
);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  stock INT
);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  contacto VARCHAR(100)
);

CREATE TABLE Pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  id_cliente INT,
  id_vendedor INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  total DECIMAL(12,2),
  fecha_emision DATE,
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT,
  monto DECIMAL(12,2),
  fecha_pago DATE,
  metodo VARCHAR(50),
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura)
);

CREATE TABLE Almacen (
  id_almacen INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150)
);

CREATE TABLE Envio (
  id_envio INT AUTO_INCREMENT PRIMARY KEY,
  id_pedido INT,
  direccion_envio VARCHAR(200),
  fecha_envio DATE,
  estado VARCHAR(50),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);

CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
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

INSERT INTO Cliente (nombre, correo) VALUES
('Carlos López', 'carlos@correo.com'),
('Ana Torres', 'ana@correo.com'),
('Luis Pérez', 'luis@correo.com'),
('Marta Gómez', 'marta@correo.com'),
('Pedro Ruiz', 'pedro@correo.com');

INSERT INTO Vendedor (nombre, telefono) VALUES
('Laura Martínez', '3001234567'),
('Jorge Díaz', '3009876543'),
('Sofía Ramírez', '3012223333'),
('Diego Torres', '3023334444'),
('Camila Rojas', '3035556666');

INSERT INTO Producto (nombre, precio, stock) VALUES
('Persiana enrollable', 120000, 50),
('Cortina blackout', 90000, 70),
('Persiana vertical', 80000, 60),
('Cortina romana', 110000, 40),
('Persiana de madera', 150000, 30);

INSERT INTO Proveedor (nombre, contacto) VALUES
('Proveedora S.A.', 'proveedora@correo.com'),
('Distribuciones Cortinas', 'ventas@distcortinas.com'),
('Importadora Persinas', 'importadora@correo.com'),
('PersiDecor', 'contacto@persidecor.com'),
('Cortinas Express', 'info@cortinasexpress.com');

INSERT INTO Pedido (fecha, id_cliente, id_vendedor) VALUES
('2025-07-10', 1, 1),
('2025-07-11', 2, 2),
('2025-07-12', 3, 3),
('2025-07-13', 4, 4),
('2025-07-14', 5, 5);

INSERT INTO Factura (id_pedido, total, fecha_emision) VALUES
(1, 350000, '2025-07-10'),
(2, 200000, '2025-07-11'),
(3, 300000, '2025-07-12'),
(4, 250000, '2025-07-13'),
(5, 150000, '2025-07-14');

INSERT INTO Pago (id_factura, monto, fecha_pago, metodo) VALUES
(1, 350000, '2025-07-10', 'Tarjeta'),
(2, 200000, '2025-07-11', 'Efectivo'),
(3, 300000, '2025-07-12', 'Transferencia'),
(4, 250000, '2025-07-13', 'Cheque'),
(5, 150000, '2025-07-14', 'Tarjeta');

INSERT INTO Almacen (nombre, direccion) VALUES
('Central Bodega', 'Av. Principal 123'),
('Bodega Norte', 'Calle 45 #12-34'),
('Bodega Sur', 'Cra 9 #56-78'),
('Bodega Oriente', 'Cl 100 #45-67'),
('Bodega Occidente', 'Transv 23 #89-10');

INSERT INTO Envio (id_pedido, direccion_envio, fecha_envio, estado) VALUES
(1, 'Calle 10 #5-67', '2025-07-11', 'Entregado'),
(2, 'Carrera 15 #20-30', '2025-07-12', 'Pendiente'),
(3, 'Avenida 1 #2-3', '2025-07-13', 'Entregado'),
(4, 'Calle 8 #8-8', '2025-07-14', 'En ruta'),
(5, 'Cra 4 #4-4', '2025-07-15', 'Pendiente');

INSERT INTO Sucursal (nombre, direccion) VALUES
('Sucursal Norte', 'Cl 50 #10-20'),
('Sucursal Sur', 'Cl 60 #15-25'),
('Sucursal Este', 'Cl 70 #20-30'),
('Sucursal Oeste', 'Cl 80 #25-35'),
('Sucursal Centro', 'Cl 90 #30-40');

INSERT INTO Pedido_Producto VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1),
(3, 4, 2),
(4, 5, 1);

INSERT INTO Proveedor_Producto VALUES
(1, 1), (1, 2), (2, 3), (3, 4), (4, 5);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Cliente SET correo = 'nuevo_carlos@correo.com' WHERE id_cliente = 1;
UPDATE Producto SET precio = 125000 WHERE id_producto = 1;
UPDATE Vendedor SET telefono = '3000000000' WHERE id_vendedor = 1;
UPDATE Factura SET total = 360000 WHERE id_factura = 1;
UPDATE Envio SET estado = 'Entregado' WHERE id_envio = 2;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Pedido_Producto WHERE id_pedido = 1 AND id_producto = 2;
DELETE FROM Proveedor_Producto WHERE id_proveedor = 1 AND id_producto = 2;
DELETE FROM Pago WHERE id_pago = 5;
DELETE FROM Factura WHERE id_factura = 5;
DELETE FROM Pedido WHERE id_pedido = 5;

-- ===========================================
-- SELECT & FUNCIONES (JOINs, SUBCONSULTAS, etc.)
-- ===========================================

-- INNER JOIN: Clientes y sus pedidos
SELECT C.nombre, P.id_pedido
FROM Cliente C
INNER JOIN Pedido P ON C.id_cliente = P.id_cliente;

-- LEFT JOIN: Productos y proveedores
SELECT Pr.nombre, Pro.nombre
FROM Producto Pr
LEFT JOIN Proveedor_Producto PP ON Pr.id_producto = PP.id_producto
LEFT JOIN Proveedor Pro ON PP.id_proveedor = Pro.id_proveedor;

-- RIGHT JOIN: Pedidos y pagos
SELECT P.id_pedido, Pg.monto
FROM Pago Pg
RIGHT JOIN Factura F ON Pg.id_factura = F.id_factura
RIGHT JOIN Pedido P ON F.id_pedido = P.id_pedido;

-- CROSS JOIN: Todos los productos y almacenes
SELECT Pr.nombre AS producto, A.nombre AS almacen
FROM Producto Pr
CROSS JOIN Almacen A;

-- FULL OUTER JOIN simulado
SELECT C.nombre, P.id_pedido
FROM Cliente C
LEFT JOIN Pedido P ON C.id_cliente = P.id_cliente
UNION
SELECT C.nombre, P.id_pedido
FROM Cliente C
RIGHT JOIN Pedido P ON C.id_cliente = P.id_cliente;

-- SUBCONSULTA: Clientes con pedidos mayores a 250000
SELECT nombre FROM Cliente
WHERE id_cliente IN (
  SELECT id_cliente FROM Pedido WHERE id_pedido IN (
    SELECT id_pedido FROM Factura WHERE total > 250000
  )
);

-- FUNCIONES agregadas
SELECT AVG(precio) AS precio_promedio FROM Producto;
SELECT MAX(total) AS factura_mayor FROM Factura;
SELECT MIN(monto) AS pago_menor FROM Pago;
SELECT COUNT(*) AS total_pedidos FROM Pedido;
SELECT SUM(total) AS ventas_totales FROM Factura;

-- CASE
SELECT nombre, 
  CASE WHEN precio > 100000 THEN 'Alta gama' ELSE 'Económico' END AS tipo
FROM Producto;

-- COALESCE
SELECT C.nombre, COALESCE(F.total, 0) AS total_factura
FROM Cliente C
LEFT JOIN Pedido P ON C.id_cliente = P.id_cliente
LEFT JOIN Factura F ON P.id_pedido = F.id_pedido;

-- GROUP BY
SELECT id_vendedor, COUNT(*) AS total_pedidos
FROM Pedido
GROUP BY id_vendedor;

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

CALL productos_por_pedido(1);

