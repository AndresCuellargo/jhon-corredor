-- ===========================================
-- BASE DE DATOS: lavado_autos_motos
-- ===========================================

DROP DATABASE IF EXISTS lavado_autos_motos;
CREATE DATABASE lavado_autos_motos;
USE lavado_autos_motos;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Tipo_Vehiculo (
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(50)
);

CREATE TABLE Vehiculo (
  id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10),
  marca VARCHAR(50),
  id_cliente INT,
  id_tipo INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_tipo) REFERENCES Tipo_Vehiculo(id_tipo)
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  turno VARCHAR(50)
);

CREATE TABLE Servicio (
  id_servicio INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100),
  precio DECIMAL(10,2)
);

CREATE TABLE Turno (
  id_turno INT AUTO_INCREMENT PRIMARY KEY,
  hora_inicio TIME,
  hora_fin TIME
);

CREATE TABLE Factura (
  id_factura INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  total DECIMAL(12,2),
  fecha DATE,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_factura INT,
  metodo VARCHAR(50),
  monto DECIMAL(12,2),
  fecha DATE,
  FOREIGN KEY (id_factura) REFERENCES Factura(id_factura)
);

CREATE TABLE Producto (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50),
  cantidad INT
);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  contacto VARCHAR(100)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Servicio_Vehiculo (
  id_servicio INT,
  id_vehiculo INT,
  PRIMARY KEY (id_servicio, id_vehiculo),
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio),
  FOREIGN KEY (id_vehiculo) REFERENCES Vehiculo(id_vehiculo)
);

CREATE TABLE Producto_Proveedor (
  id_producto INT,
  id_proveedor INT,
  PRIMARY KEY (id_producto, id_proveedor),
  FOREIGN KEY (id_producto) REFERENCES Producto(id_producto),
  FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

-- ===========================================
-- INSERT (5 por entidad clave)
-- ===========================================

INSERT INTO Cliente (nombre, telefono) VALUES
('Luis Pérez', '3001112233'),
('Ana Torres', '3012223344'),
('Pedro Gómez', '3023334455'),
('Carla Ruiz', '3034445566'),
('Marta Díaz', '3045556677');

INSERT INTO Tipo_Vehiculo (descripcion) VALUES
('Carro'),
('Moto'),
('Camioneta'),
('Pickup'),
('Van');

INSERT INTO Vehiculo (placa, marca, id_cliente, id_tipo) VALUES
('ABC123', 'Toyota', 1, 1),
('XYZ987', 'Honda', 2, 2),
('JKL456', 'Chevrolet', 3, 3),
('MNO789', 'Ford', 4, 4),
('QRS321', 'Hyundai', 5, 5);

INSERT INTO Empleado (nombre, turno) VALUES
('Carlos López', 'Mañana'),
('Laura Torres', 'Tarde'),
('Diego Martínez', 'Noche'),
('Sofía Ramírez', 'Mañana'),
('Andrés Rojas', 'Tarde');

INSERT INTO Servicio (descripcion, precio) VALUES
('Lavado Básico', 20000),
('Lavado Premium', 35000),
('Polichado', 50000),
('Aspirado', 15000),
('Desinfección', 30000);

INSERT INTO Turno (hora_inicio, hora_fin) VALUES
('08:00:00', '12:00:00'),
('12:00:00', '16:00:00'),
('16:00:00', '20:00:00'),
('20:00:00', '00:00:00'),
('00:00:00', '04:00:00');

INSERT INTO Factura (id_cliente, total, fecha) VALUES
(1, 20000, '2025-07-15'),
(2, 35000, '2025-07-15'),
(3, 50000, '2025-07-15'),
(4, 15000, '2025-07-15'),
(5, 30000, '2025-07-15');

INSERT INTO Pago (id_factura, metodo, monto, fecha) VALUES
(1, 'Efectivo', 20000, '2025-07-15'),
(2, 'Tarjeta', 35000, '2025-07-15'),
(3, 'Transferencia', 50000, '2025-07-15'),
(4, 'Efectivo', 15000, '2025-07-15'),
(5, 'Tarjeta', 30000, '2025-07-15');

INSERT INTO Producto (nombre, cantidad) VALUES
('Shampoo Auto', 50),
('Cera Líquida', 30),
('Desinfectante', 40),
('Aspiradora', 5),
('Toallas', 100);

INSERT INTO Proveedor (nombre, contacto) VALUES
('Insumos CarWash', 'contacto@carwash.com'),
('Distribuidora Autos', 'ventas@autos.com'),
('Limpieza Total', 'info@limpiezatotal.com'),
('Higiene Express', 'servicio@higiene.com'),
('Equipos Carros', 'equipos@carros.com');

INSERT INTO Servicio_Vehiculo VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO Producto_Proveedor VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Cliente SET telefono = '3009998888' WHERE id_cliente = 1;
UPDATE Vehiculo SET marca = 'Nissan' WHERE id_vehiculo = 1;
UPDATE Empleado SET turno = 'Noche' WHERE id_empleado = 1;
UPDATE Servicio SET precio = 22000 WHERE id_servicio = 1;
UPDATE Producto SET cantidad = 60 WHERE id_producto = 1;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Servicio_Vehiculo WHERE id_servicio = 1 AND id_vehiculo = 1;
DELETE FROM Producto_Proveedor WHERE id_producto = 1 AND id_proveedor = 1;
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Factura WHERE id_factura = 1;
DELETE FROM Cliente WHERE id_cliente = 1;

-- ===========================================
-- SELECT, JOIN, SUBCONSULTA, FUNCIONES
-- ===========================================

-- JOIN
SELECT C.nombre, V.placa
FROM Cliente C
JOIN Vehiculo V ON C.id_cliente = V.id_cliente;

SELECT V.placa, S.descripcion
FROM Vehiculo V
JOIN Servicio_Vehiculo SV ON V.id_vehiculo = SV.id_vehiculo
JOIN Servicio S ON SV.id_servicio = S.id_servicio;

SELECT P.nombre, Pr.nombre
FROM Producto P
JOIN Producto_Proveedor PP ON P.id_producto = PP.id_producto
JOIN Proveedor Pr ON PP.id_proveedor = Pr.id_proveedor;

-- SUBCONSULTA
SELECT nombre FROM Cliente
WHERE id_cliente IN (
  SELECT id_cliente FROM Factura WHERE total > 20000
);

-- FUNCIONES
SELECT COUNT(*) FROM Vehiculo;
SELECT AVG(precio) FROM Servicio;
SELECT MAX(total) FROM Factura;
SELECT MIN(monto) FROM Pago;
SELECT SUM(total) FROM Factura;

SELECT descripcion,
  CASE WHEN precio > 30000 THEN 'Premium' ELSE 'Económico' END AS tipo_servicio
FROM Servicio;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE servicios_por_vehiculo(IN vehiculoId INT)
BEGIN
  SELECT S.descripcion
  FROM Servicio_Vehiculo SV
  JOIN Servicio S ON SV.id_servicio = S.id_servicio
  WHERE SV.id_vehiculo = vehiculoId;
END //
DELIMITER ;

CALL servicios_por_vehiculo(1);
