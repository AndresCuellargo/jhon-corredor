-- ===========================================
-- BASE DE DATOS: inmobiliaria
-- ===========================================

DROP DATABASE IF EXISTS inmobiliaria;
CREATE DATABASE inmobiliaria;
USE inmobiliaria;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Agente (
  id_agente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  correo VARCHAR(100)
);

CREATE TABLE Propiedad (
  id_propiedad INT AUTO_INCREMENT PRIMARY KEY,
  direccion VARCHAR(200),
  precio DECIMAL(12,2),
  estado VARCHAR(50)
);

CREATE TABLE Visita (
  id_visita INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_propiedad INT,
  fecha DATE,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_propiedad) REFERENCES Propiedad(id_propiedad)
);

CREATE TABLE Contrato (
  id_contrato INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_agente INT,
  fecha DATE,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_agente) REFERENCES Agente(id_agente)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_contrato INT,
  monto DECIMAL(12,2),
  fecha_pago DATE,
  FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato)
);

CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

CREATE TABLE Ciudad (
  id_ciudad INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100)
);

CREATE TABLE Propietario (
  id_propietario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  telefono VARCHAR(20)
);

CREATE TABLE Oficina (
  id_oficina INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Propiedad_Servicio (
  id_propiedad INT,
  servicio VARCHAR(100),
  PRIMARY KEY (id_propiedad, servicio),
  FOREIGN KEY (id_propiedad) REFERENCES Propiedad(id_propiedad)
);

CREATE TABLE Contrato_Propiedad (
  id_contrato INT,
  id_propiedad INT,
  PRIMARY KEY (id_contrato, id_propiedad),
  FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato),
  FOREIGN KEY (id_propiedad) REFERENCES Propiedad(id_propiedad)
);

-- ===========================================
-- INSERT (5 por entidad clave)
-- ===========================================

INSERT INTO Cliente (nombre, telefono) VALUES
('Juan Gómez', '3111234567'),
('María López', '3129876543'),
('Pedro Pérez', '3132223333'),
('Laura Herrera', '3143334444'),
('Andrés Ramírez', '3155556666');

INSERT INTO Agente (nombre, correo) VALUES
('Lucía Torres', 'lucia@inmo.com'),
('Camilo Duarte', 'camilo@inmo.com'),
('Sandra Ruiz', 'sandra@inmo.com'),
('Jorge León', 'jorge@inmo.com'),
('Paula Gómez', 'paula@inmo.com');

INSERT INTO Propiedad (direccion, precio, estado) VALUES
('Cra 10 #20-30', 300000000, 'Disponible'),
('Cl 15 #25-40', 450000000, 'Vendida'),
('Cra 5 #50-10', 380000000, 'Disponible'),
('Cl 80 #30-60', 600000000, 'Reservada'),
('Av 68 #70-90', 500000000, 'Disponible');

INSERT INTO Propietario (nombre, telefono) VALUES
('Carlos Restrepo', '3115556666'),
('Julián Orozco', '3126667777'),
('Natalia Salazar', '3137778888'),
('Esteban Cárdenas', '3148889999'),
('Lorena Duarte', '3159990000');

INSERT INTO Ciudad (nombre) VALUES
('Bogotá'),
('Medellín'),
('Cali'),
('Barranquilla'),
('Bucaramanga');

INSERT INTO Visita (id_cliente, id_propiedad, fecha) VALUES
(1, 1, '2025-10-01'),
(2, 2, '2025-10-02'),
(3, 3, '2025-10-03'),
(4, 4, '2025-10-04'),
(5, 5, '2025-10-05');

INSERT INTO Contrato (id_cliente, id_agente, fecha) VALUES
(1, 1, '2025-10-06'),
(2, 2, '2025-10-07'),
(3, 3, '2025-10-08'),
(4, 4, '2025-10-09'),
(5, 5, '2025-10-10');

INSERT INTO Pago (id_contrato, monto, fecha_pago) VALUES
(1, 50000000, '2025-10-11'),
(2, 75000000, '2025-10-12'),
(3, 60000000, '2025-10-13'),
(4, 80000000, '2025-10-14'),
(5, 70000000, '2025-10-15');

INSERT INTO Sucursal (nombre, direccion) VALUES
('Sucursal Norte', 'Cl 50 #10-20'),
('Sucursal Sur', 'Cl 60 #15-25'),
('Sucursal Este', 'Cl 70 #20-30'),
('Sucursal Oeste', 'Cl 80 #25-35'),
('Sucursal Centro', 'Cl 90 #30-40');

INSERT INTO Oficina (nombre, direccion) VALUES
('Oficina Central', 'Av Principal #10-20'),
('Oficina Norte', 'Av Norte #20-30'),
('Oficina Sur', 'Av Sur #30-40'),
('Oficina Este', 'Av Este #40-50'),
('Oficina Oeste', 'Av Oeste #50-60');

INSERT INTO Propiedad_Servicio VALUES
(1, 'Parqueadero'),
(1, 'Piscina'),
(2, 'Gimnasio'),
(3, 'Salón Comunal'),
(4, 'Zona BBQ');

INSERT INTO Contrato_Propiedad VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Propiedad SET estado = 'Reservada' WHERE id_propiedad = 1;
UPDATE Cliente SET telefono = '3200000000' WHERE id_cliente = 1;
UPDATE Agente SET correo = 'nuevo@inmo.com' WHERE id_agente = 1;
UPDATE Contrato SET fecha = '2025-10-20' WHERE id_contrato = 1;
UPDATE Pago SET monto = 55000000 WHERE id_pago = 1;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Contrato_Propiedad WHERE id_contrato = 1 AND id_propiedad = 1;
DELETE FROM Propiedad_Servicio WHERE id_propiedad = 1 AND servicio = 'Piscina';
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Contrato WHERE id_contrato = 1;
DELETE FROM Visita WHERE id_visita = 1;

-- ===========================================
-- SELECT & FUNCIONES
-- ===========================================

-- JOINs
SELECT C.nombre, V.fecha
FROM Cliente C
JOIN Visita V ON C.id_cliente = V.id_cliente;

SELECT P.direccion, PS.servicio
FROM Propiedad P
JOIN Propiedad_Servicio PS ON P.id_propiedad = PS.id_propiedad;

SELECT Cl.nombre, Co.fecha
FROM Cliente Cl
JOIN Contrato Co ON Cl.id_cliente = Co.id_cliente;

-- SUBCONSULTA
SELECT nombre FROM Cliente WHERE id_cliente IN (
  SELECT id_cliente FROM Contrato WHERE id_contrato IN (
    SELECT id_contrato FROM Pago WHERE monto > 60000000
  )
);

-- FUNCIONES
SELECT COUNT(*) FROM Propiedad;
SELECT AVG(precio) FROM Propiedad;
SELECT MAX(precio) FROM Propiedad;
SELECT MIN(monto) FROM Pago;
SELECT SUM(monto) FROM Pago;

SELECT direccion,
  CASE WHEN precio > 400000000 THEN 'Alta Gama' ELSE 'Económica' END AS categoria
FROM Propiedad;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE propiedades_cliente(IN clienteId INT)
BEGIN
  SELECT P.direccion
  FROM Contrato_Propiedad CP
  JOIN Propiedad P ON CP.id_propiedad = P.id_propiedad
  JOIN Contrato C ON CP.id_contrato = C.id_contrato
  WHERE C.id_cliente = clienteId;
END //
DELIMITER ;

CALL propiedades_cliente(1);
