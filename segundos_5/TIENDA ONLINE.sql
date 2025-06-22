DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda;
USE tienda;

-- TABLAS PRINCIPALES
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) UNIQUE
);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME NOT NULL,
  id_cliente INT,
  id_empleado INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- PIVOTE: Pedido - Producto
CREATE TABLE Pedido_Producto (
  id_pedido INT,
  id_producto INT,
  cantidad INT,
  PRIMARY KEY (id_pedido, id_producto),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);

-- PIVOTE: Producto - Categoria
CREATE TABLE Producto_Categoria (
  id_producto INT,
  id_categoria INT,
  PRIMARY KEY (id_producto, id_categoria),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- INSERTS
INSERT INTO Cliente (nombre, correo) VALUES
('Carlos Pérez', 'carlos@correo.com'),
('Ana Gómez', 'ana@correo.com'),
('Luis Torres', 'luis@correo.com'),
('Marta Ruiz', 'marta@correo.com'),
('Jorge Díaz', 'jorge@correo.com');

INSERT INTO Empleado (nombre) VALUES
('Laura Hernández'),
('Andrés Morales'),
('Sofía Londoño'),
('Pedro Sánchez'),
('Camila Restrepo');

INSERT INTO Producto (nombre, precio) VALUES
('Laptop', 3500000),
('Mouse', 80000),
('Teclado', 120000),
('Monitor', 900000),
('Impresora', 600000);

INSERT INTO Categoria (nombre) VALUES
('Electrónica'),
('Oficina'),
('Gaming'),
('Accesorios'),
('Impresión');

INSERT INTO Pedido (fecha, id_cliente, id_empleado) VALUES
('2025-07-01 10:00:00', 1, 1),
('2025-07-02 11:00:00', 2, 2),
('2025-07-03 12:00:00', 3, 3),
('2025-07-04 13:00:00', 4, 4),
('2025-07-05 14:00:00', 5, 5);

INSERT INTO Pedido_Producto VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 1),
(3, 4, 1),
(4, 5, 1);

INSERT INTO Producto_Categoria VALUES
(1, 1), (1, 3), (2, 4), (3, 3), (4, 1);

-- UPDATE
UPDATE Cliente SET correo = 'carlos_new@correo.com' WHERE id_cliente = 1;
UPDATE Producto SET precio = 3600000 WHERE id_producto = 1;
UPDATE Categoria SET nombre = 'Electrónica y Tecnología' WHERE id_categoria = 1;
UPDATE Empleado SET nombre = 'Laura H.' WHERE id_empleado = 1;
UPDATE Pedido SET fecha = '2025-07-01 11:00:00' WHERE id_pedido = 1;

-- DELETE
DELETE FROM Pedido_Producto WHERE id_pedido = 1 AND id_producto = 2;
DELETE FROM Producto_Categoria WHERE id_producto = 1 AND id_categoria = 3;
DELETE FROM Pedido WHERE id_pedido = 5;
DELETE FROM Cliente WHERE id_cliente = 5;
DELETE FROM Empleado WHERE id_empleado = 5;

-- SELECT
SELECT * FROM Cliente;
SELECT nombre, precio FROM Producto WHERE precio > 500000;
SELECT nombre FROM Categoria WHERE nombre LIKE '%Electrónica%';
SELECT nombre FROM Empleado WHERE nombre LIKE 'Laura%';
SELECT P.id_pedido, C.nombre AS cliente, E.nombre AS empleado
FROM Pedido P
JOIN Cliente C ON P.id_cliente = C.id_cliente
JOIN Empleado E ON P.id_empleado = E.id_empleado;

-- FUNCIONES
SELECT COUNT(*) AS total_pedidos FROM Pedido;
SELECT AVG(precio) AS precio_promedio FROM Producto;
SELECT MAX(precio) AS producto_mas_caro FROM Producto;
SELECT MIN(precio) AS producto_mas_barato FROM Producto;
SELECT C.nombre, COALESCE(P.fecha, 'Sin pedido') AS ultima_compra
FROM Cliente C
LEFT JOIN Pedido P ON C.id_cliente = P.id_cliente;
SELECT Pr.nombre, CASE
  WHEN Pr.precio > 1000000 THEN 'Costoso'
  ELSE 'Económico'
END AS tipo_producto
FROM Producto Pr;
SELECT C.nombre FROM Cliente C
WHERE EXISTS (
  SELECT 1 FROM Pedido P WHERE P.id_cliente = C.id_cliente
);
SELECT E.nombre, COUNT(P.id_pedido) AS pedidos_atendidos
FROM Empleado E
LEFT JOIN Pedido P ON E.id_empleado = P.id_empleado
GROUP BY E.id_empleado;
SELECT nombre FROM Producto
WHERE id_producto IN (
  SELECT id_producto FROM Pedido_Producto
  GROUP BY id_producto
  HAVING COUNT(*) >= 1
);
SELECT Ca.nombre, COUNT(PC.id_producto) AS productos_asociados
FROM Categoria Ca
LEFT JOIN Producto_Categoria PC ON Ca.id_categoria = PC.id_categoria
GROUP BY Ca.id_categoria;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE productos_por_pedido(IN pedido_id INT)
BEGIN
  SELECT Pr.nombre, PP.cantidad
  FROM Pedido_Producto PP
  JOIN Producto Pr ON PP.id_producto = Pr.id_producto
  WHERE PP.id_pedido = pedido_id;
END //
DELIMITER ;

-- EJECUCIÓN DEL PROCEDIMIENTO
CALL productos_por_pedido(1);
