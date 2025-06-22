DROP DATABASE IF EXISTS transporte;
CREATE DATABASE transporte;
USE transporte;

-- TABLAS PRINCIPALES
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  documento VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  cargo VARCHAR(100) NOT NULL
);

CREATE TABLE Vehiculo (
  id_vehiculo INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10) UNIQUE NOT NULL,
  tipo VARCHAR(50) NOT NULL,
  capacidad DECIMAL(10,2) NOT NULL
);

CREATE TABLE Ruta (
  id_ruta INT AUTO_INCREMENT PRIMARY KEY,
  origen VARCHAR(100) NOT NULL,
  destino VARCHAR(100) NOT NULL,
  distancia_km DECIMAL(10,2) NOT NULL
);

CREATE TABLE Carga (
  id_carga INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(200) NOT NULL,
  peso DECIMAL(10,2) NOT NULL
);

CREATE TABLE Envio (
  id_envio INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_empleado INT,
  fecha_envio DATE NOT NULL,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- PIVOTE: Envio - Carga
CREATE TABLE Envio_Carga (
  id_envio INT,
  id_carga INT,
  PRIMARY KEY (id_envio, id_carga),
  FOREIGN KEY (id_envio) REFERENCES Envio(id_envio),
  FOREIGN KEY (id_carga) REFERENCES Carga(id_carga)
);

-- PIVOTE: Envio - Vehiculo - Ruta
CREATE TABLE Envio_Vehiculo_Ruta (
  id_envio INT,
  id_vehiculo INT,
  id_ruta INT,
  PRIMARY KEY (id_envio, id_vehiculo, id_ruta),
  FOREIGN KEY (id_envio) REFERENCES Envio(id_envio),
  FOREIGN KEY (id_vehiculo) REFERENCES Vehiculo(id_vehiculo),
  FOREIGN KEY (id_ruta) REFERENCES Ruta(id_ruta)
);

-- INSERTS
INSERT INTO Cliente (nombre, documento) VALUES
('Carlos Pérez', '1001'),
('Ana Gómez', '1002'),
('Luis Torres', '1003'),
('Marta Ruiz', '1004'),
('Jorge Díaz', '1005');

INSERT INTO Empleado (nombre, cargo) VALUES
('Laura Hernández', 'Conductor'),
('Andrés Morales', 'Operador'),
('Sofía Londoño', 'Conductor'),
('Pedro Sánchez', 'Supervisor'),
('Camila Restrepo', 'Conductor');

INSERT INTO Vehiculo (placa, tipo, capacidad) VALUES
('ABC123', 'Camión', 5000),
('DEF456', 'Camión', 7000),
('GHI789', 'Furgón', 3000),
('JKL321', 'Furgón', 3500),
('MNO654', 'Camión', 8000);

INSERT INTO Ruta (origen, destino, distancia_km) VALUES
('Bogotá', 'Medellín', 420),
('Bogotá', 'Cali', 480),
('Bogotá', 'Barranquilla', 1000),
('Bogotá', 'Bucaramanga', 400),
('Bogotá', 'Cartagena', 1100);

INSERT INTO Carga (descripcion, peso) VALUES
('Muebles', 2000),
('Electrodomésticos', 1500),
('Alimentos', 1000),
('Ropa', 500),
('Material de construcción', 3000);

INSERT INTO Envio (id_cliente, id_empleado, fecha_envio) VALUES
(1, 1, '2025-07-01'),
(2, 2, '2025-07-02'),
(3, 3, '2025-07-03'),
(4, 4, '2025-07-04'),
(5, 5, '2025-07-05');

INSERT INTO Envio_Carga VALUES
(1, 1), (1, 2), (2, 3), (3, 4), (4, 5);

INSERT INTO Envio_Vehiculo_Ruta VALUES
(1, 1, 1), (2, 2, 2), (3, 3, 3), (4, 4, 4), (5, 5, 5);

-- UPDATE
UPDATE Cliente SET nombre = 'Carlos A. Pérez' WHERE id_cliente = 1;
UPDATE Empleado SET cargo = 'Jefe de Conductores' WHERE id_empleado = 1;
UPDATE Vehiculo SET capacidad = 6000 WHERE id_vehiculo = 1;
UPDATE Ruta SET distancia_km = 425 WHERE id_ruta = 1;
UPDATE Carga SET peso = 2100 WHERE id_carga = 1;

-- DELETE
DELETE FROM Envio_Carga WHERE id_envio = 1 AND id_carga = 2;
DELETE FROM Envio_Vehiculo_Ruta WHERE id_envio = 1 AND id_vehiculo = 1 AND id_ruta = 1;
DELETE FROM Envio WHERE id_envio = 5;
DELETE FROM Cliente WHERE id_cliente = 5;
DELETE FROM Empleado WHERE id_empleado = 5;

-- SELECT
SELECT * FROM Cliente;
SELECT nombre, cargo FROM Empleado WHERE cargo LIKE '%Conductor%';
SELECT placa, tipo FROM Vehiculo WHERE capacidad > 5000;
SELECT origen, destino FROM Ruta WHERE distancia_km > 500;
SELECT E.id_envio, C.nombre AS cliente, EM.nombre AS empleado
FROM Envio E
JOIN Cliente C ON E.id_cliente = C.id_cliente
JOIN Empleado EM ON E.id_empleado = EM.id_empleado;

-- FUNCIONES
SELECT COUNT(*) AS total_envios FROM Envio;
SELECT AVG(capacidad) AS promedio_capacidad FROM Vehiculo;
SELECT MAX(distancia_km) AS ruta_mas_larga FROM Ruta;
SELECT MIN(peso) AS carga_mas_ligera FROM Carga;
SELECT C.nombre, COALESCE(E.fecha_envio, 'No envios') AS ultima_fecha
FROM Cliente C
LEFT JOIN Envio E ON C.id_cliente = E.id_cliente;
SELECT V.placa, CASE
  WHEN V.capacidad > 5000 THEN 'Alta capacidad'
  ELSE 'Baja capacidad'
END AS tipo_capacidad
FROM Vehiculo V;
SELECT C.nombre FROM Cliente C
WHERE EXISTS (
  SELECT 1 FROM Envio E WHERE E.id_cliente = C.id_cliente
);
SELECT EM.nombre, COUNT(E.id_envio) AS total_envios
FROM Empleado EM
LEFT JOIN Envio E ON EM.id_empleado = E.id_empleado
GROUP BY EM.id_empleado;
SELECT descripcion FROM Carga
WHERE id_carga IN (
  SELECT id_carga FROM Envio_Carga
  GROUP BY id_carga
  HAVING COUNT(*) >= 1
);
SELECT R.origen, SUM(R.distancia_km) AS total_distancia
FROM Ruta R
GROUP BY R.origen;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE envios_por_cliente(IN cliente_id INT)
BEGIN
  SELECT id_envio, fecha_envio FROM Envio
  WHERE id_cliente = cliente_id;
END //
DELIMITER ;

-- EJECUCIÓN DEL PROCEDIMIENTO
CALL envios_por_cliente(1);
