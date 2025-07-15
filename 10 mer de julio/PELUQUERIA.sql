-- ===========================================
-- BASE DE DATOS: peluqueria
-- ===========================================

DROP DATABASE IF EXISTS peluqueria;
CREATE DATABASE peluqueria;
USE peluqueria;

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

CREATE TABLE Servicio (
  id_servicio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  precio DECIMAL(10,2)
);

CREATE TABLE Cita (
  id_cita INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_empleado INT,
  fecha DATETIME,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_cita INT,
  monto DECIMAL(10,2),
  fecha_pago DATE,
  metodo VARCHAR(50),
  FOREIGN KEY (id_cita) REFERENCES Cita(id_cita)
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

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_pago INT,
  total DECIMAL(12,2),
  fecha DATE,
  FOREIGN KEY (id_pago) REFERENCES Pago(id_pago)
);

CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
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

CREATE TABLE Cita_Servicio (
  id_cita INT,
  id_servicio INT,
  PRIMARY KEY (id_cita, id_servicio),
  FOREIGN KEY (id_cita) REFERENCES Cita(id_cita),
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio)
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
('Camila Duarte', '3111234567'),
('Julián Orozco', '3129876543'),
('Tatiana Restrepo', '3132223333'),
('Oscar Herrera', '3143334444'),
('Daniela Morales', '3155556666');

INSERT INTO Empleado (nombre, cargo) VALUES
('Ana Torres', 'Estilista'),
('Mauricio Ruiz', 'Barbero'),
('Valentina López', 'Recepcionista'),
('Carlos Pérez', 'Colorista'),
('Luisa Ramírez', 'Gerente');

INSERT INTO Servicio (nombre, precio) VALUES
('Corte de Cabello', 35000),
('Barba', 20000),
('Coloración', 80000),
('Peinado', 30000),
('Manicure', 25000);

INSERT INTO Producto (nombre, precio, stock) VALUES
('Shampoo', 20000, 50),
('Acondicionador', 25000, 40),
('Tinte', 50000, 30),
('Laca', 15000, 60),
('Gel', 10000, 80);

INSERT INTO Proveedor (nombre, contacto) VALUES
('Distribuidora Belleza', 'ventas@belleza.com'),
('ProBeauty', 'info@probeauty.com'),
('Insumos Salon', 'contacto@insumosalon.com'),
('EstiloPro', 'estilo@pro.com'),
('CosmeticaTotal', 'ventas@cosmeticatotal.com');

INSERT INTO Cita (id_cliente, id_empleado, fecha) VALUES
(1, 1, '2025-09-01 10:00:00'),
(2, 2, '2025-09-02 11:00:00'),
(3, 3, '2025-09-03 12:00:00'),
(4, 4, '2025-09-04 13:00:00'),
(5, 5, '2025-09-05 14:00:00');

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Cliente SET telefono = '3200000000' WHERE id_cliente = 1;
UPDATE Empleado SET cargo = 'Supervisor' WHERE id_empleado = 5;
UPDATE Servicio SET precio = 37000 WHERE id_servicio = 1;
UPDATE Producto SET precio = 22000 WHERE id_producto = 1;
UPDATE Cita SET fecha = '2025-09-06 15:00:00' WHERE id_cita = 1;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Cita_Servicio WHERE id_cita = 1 AND id_servicio = 1;
DELETE FROM Proveedor_Producto WHERE id_proveedor = 1 AND id_producto = 1;
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Factura WHERE id_factura = 1;
DELETE FROM Cita WHERE id_cita = 1;

-- ===========================================
-- SELECT & FUNCIONES
-- ===========================================

-- JOINs
SELECT C.nombre, Ci.fecha
FROM Cliente C
JOIN Cita Ci ON C.id_cliente = Ci.id_cliente;

SELECT S.nombre, CS.id_cita
FROM Servicio S
JOIN Cita_Servicio CS ON S.id_servicio = CS.id_servicio;

SELECT P.nombre, Pr.nombre AS proveedor
FROM Producto P
JOIN Proveedor_Producto PP ON P.id_producto = PP.id_producto
JOIN Proveedor Pr ON PP.id_proveedor = Pr.id_proveedor;

-- SUBCONSULTA
SELECT nombre FROM Cliente WHERE id_cliente IN (
  SELECT id_cliente FROM Cita WHERE id_cita IN (
    SELECT id_cita FROM Pago WHERE monto > 50000
  )
);

-- FUNCIONES
SELECT COUNT(*) FROM Cita;
SELECT AVG(precio) FROM Servicio;
SELECT MAX(precio) FROM Servicio;
SELECT MIN(precio) FROM Servicio;
SELECT SUM(precio) FROM Servicio;

SELECT nombre,
  CASE WHEN precio > 30000 THEN 'Premium' ELSE 'Básico' END AS tipo
FROM Servicio;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE servicios_cita(IN citaId INT)
BEGIN
  SELECT S.nombre
  FROM Cita_Servicio CS
  JOIN Servicio S ON CS.id_servicio = S.id_servicio
  WHERE CS.id_cita = citaId;
END //
DELIMITER ;

CALL servicios_cita(1);
