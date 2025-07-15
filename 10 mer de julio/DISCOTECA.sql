-- ===========================================
-- BASE DE DATOS: discoteca
-- ===========================================

DROP DATABASE IF EXISTS discoteca;
CREATE DATABASE discoteca;
USE discoteca;

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

CREATE TABLE ReservaMesa (
  id_reserva INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  fecha DATE,
  cantidad_personas INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Evento (
  id_evento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha DATE
);

CREATE TABLE Bebida (
  id_bebida INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2),
  stock INT
);

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_reserva INT,
  total DECIMAL(10,2),
  fecha DATE,
  FOREIGN KEY (id_reserva) REFERENCES ReservaMesa(id_reserva)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT,
  monto DECIMAL(10,2),
  fecha_pago DATE,
  metodo VARCHAR(50),
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura)
);

CREATE TABLE Promocion (
  id_promocion INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(200),
  descuento DECIMAL(5,2)
);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  contacto VARCHAR(100)
);

CREATE TABLE Almacen (
  id_almacen INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Evento_Empleado (
  id_evento INT,
  id_empleado INT,
  PRIMARY KEY (id_evento, id_empleado),
  FOREIGN KEY (id_evento) REFERENCES Evento(id_evento),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Factura_Bebida (
  id_factura INT,
  id_bebida INT,
  cantidad INT,
  PRIMARY KEY (id_factura, id_bebida),
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura),
  FOREIGN KEY (id_bebida) REFERENCES Bebida(id_bebida)
);

-- ===========================================
-- INSERT
-- ===========================================

INSERT INTO Cliente (nombre, telefono) VALUES
('Andrés Gómez', '3001234567'),
('Paula Díaz', '3009876543'),
('Miguel Torres', '3012223333'),
('Karen Ríos', '3023334444'),
('Oscar Mendoza', '3035556666');

INSERT INTO Empleado (nombre, cargo) VALUES
('Luisa Moreno', 'Mesera'),
('Javier López', 'DJ'),
('Valentina Cruz', 'Gerente'),
('Camilo Pardo', 'Barman'),
('Natalia Castro', 'Mesera');

INSERT INTO Bebida (nombre, precio, stock) VALUES
('Ron', 50000, 100),
('Whisky', 120000, 80),
('Tequila', 75000, 90),
('Cerveza', 8000, 200),
('Vodka', 60000, 70);

INSERT INTO Evento (nombre, fecha) VALUES
('Noche Latina', '2025-08-01'),
('Electro Night', '2025-08-05'),
('Reggaeton Party', '2025-08-10'),
('Retro 80s', '2025-08-15'),
('Fiesta Blanca', '2025-08-20');

INSERT INTO ReservaMesa (id_cliente, fecha, cantidad_personas) VALUES
(1, '2025-08-01', 4),
(2, '2025-08-05', 6),
(3, '2025-08-10', 2),
(4, '2025-08-15', 5),
(5, '2025-08-20', 8);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Cliente SET telefono = '3100000000' WHERE id_cliente = 1;
UPDATE Empleado SET cargo = 'Administrador' WHERE id_empleado = 3;
UPDATE Bebida SET precio = 55000 WHERE id_bebida = 1;
UPDATE Evento SET fecha = '2025-08-25' WHERE id_evento = 5;
UPDATE ReservaMesa SET cantidad_personas = 10 WHERE id_reserva = 5;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Factura_Bebida WHERE id_factura = 1 AND id_bebida = 1;
DELETE FROM Evento_Empleado WHERE id_evento = 1 AND id_empleado = 1;
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Factura WHERE id_factura = 1;
DELETE FROM ReservaMesa WHERE id_reserva = 1;

-- ===========================================
-- SELECT & FUNCIONES
-- ===========================================

-- JOINs
SELECT C.nombre, R.fecha
FROM Cliente C
JOIN ReservaMesa R ON C.id_cliente = R.id_cliente;

SELECT F.id_factura, B.nombre, FB.cantidad
FROM Factura_Bebida FB
JOIN Bebida B ON FB.id_bebida = B.id_bebida
JOIN Factura F ON FB.id_factura = F.id_factura;

SELECT E.nombre, EM.nombre AS empleado
FROM Evento Ev
JOIN Evento_Empleado EE ON Ev.id_evento = EE.id_evento
JOIN Empleado EM ON EE.id_empleado = EM.id_empleado;

-- SUBCONSULTA
SELECT nombre FROM Cliente WHERE id_cliente IN (
  SELECT id_cliente FROM ReservaMesa WHERE cantidad_personas > 5
);

-- FUNCIONES
SELECT COUNT(*) FROM ReservaMesa;
SELECT AVG(precio) FROM Bebida;
SELECT MAX(precio) FROM Bebida;
SELECT MIN(precio) FROM Bebida;
SELECT SUM(precio) FROM Bebida;

SELECT nombre,
  CASE WHEN precio > 50000 THEN 'Premium' ELSE 'Económica' END AS tipo
FROM Bebida;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE bebidas_factura(IN facturaId INT)
BEGIN
  SELECT B.nombre, FB.cantidad
  FROM Factura_Bebida FB
  JOIN Bebida B ON FB.id_bebida = B.id_bebida
  WHERE FB.id_factura = facturaId;
END //
DELIMITER ;

CALL bebidas_factura(1);
