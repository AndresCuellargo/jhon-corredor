DROP DATABASE IF EXISTS veterinaria;
CREATE DATABASE veterinaria;
USE veterinaria;

-- TABLAS PRINCIPALES
CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20)
);

CREATE TABLE Mascota (
  id_mascota INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  especie VARCHAR(50) NOT NULL,
  id_cliente INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente)
);

CREATE TABLE Veterinario (
  id_veterinario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  especialidad VARCHAR(100)
);

CREATE TABLE Cita (
  id_cita INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME NOT NULL,
  id_mascota INT,
  id_veterinario INT,
  FOREIGN KEY (id_mascota) REFERENCES Mascota(id_mascota),
  FOREIGN KEY (id_veterinario) REFERENCES Veterinario(id_veterinario)
);

CREATE TABLE Servicio (
  id_servicio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  costo DECIMAL(10,2)
);

CREATE TABLE Medicamento (
  id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  dosis VARCHAR(50)
);

-- PIVOTE: Cita - Servicio
CREATE TABLE Cita_Servicio (
  id_cita INT,
  id_servicio INT,
  PRIMARY KEY (id_cita, id_servicio),
  FOREIGN KEY (id_cita) REFERENCES Cita(id_cita),
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio)
);

-- PIVOTE: Servicio - Medicamento
CREATE TABLE Servicio_Medicamento (
  id_servicio INT,
  id_medicamento INT,
  PRIMARY KEY (id_servicio, id_medicamento),
  FOREIGN KEY (id_servicio) REFERENCES Servicio(id_servicio),
  FOREIGN KEY (id_medicamento) REFERENCES Medicamento(id_medicamento)
);

-- INSERTS
INSERT INTO Cliente (nombre, telefono) VALUES
('Juan Pérez', '3011002000'),
('Ana Gómez', '3011002001'),
('Luis Torres', '3011002002'),
('Marta Ruiz', '3011002003'),
('Jorge Díaz', '3011002004');

INSERT INTO Mascota (nombre, especie, id_cliente) VALUES
('Firulais', 'Perro', 1),
('Misu', 'Gato', 2),
('Rocky', 'Perro', 3),
('Luna', 'Gato', 4),
('Max', 'Conejo', 5);

INSERT INTO Veterinario (nombre, especialidad) VALUES
('Laura Hernández', 'Caninos'),
('Andrés Morales', 'Felinos'),
('Sofía Londoño', 'Exóticos'),
('Pedro Sánchez', 'General'),
('Camila Restrepo', 'Cirugía');

INSERT INTO Servicio (nombre, costo) VALUES
('Consulta general', 50000),
('Vacunación', 30000),
('Desparasitación', 40000),
('Cirugía menor', 150000),
('Baño y peluquería', 25000);

INSERT INTO Medicamento (nombre, dosis) VALUES
('Antibiótico X', '500mg'),
('Vacuna Y', '1 dosis'),
('Desparasitante Z', '2 tabletas'),
('Analgésico W', '50mg'),
('Suplemento V', '10ml');

INSERT INTO Cita (fecha, id_mascota, id_veterinario) VALUES
('2025-07-01 10:00:00', 1, 1),
('2025-07-02 11:00:00', 2, 2),
('2025-07-03 12:00:00', 3, 3),
('2025-07-04 13:00:00', 4, 4),
('2025-07-05 14:00:00', 5, 5);

INSERT INTO Cita_Servicio VALUES
(1, 1), (1, 2), (2, 2), (3, 3), (4, 4);

INSERT INTO Servicio_Medicamento VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- UPDATE
UPDATE Cliente SET telefono = '3011009999' WHERE id_cliente = 1;
UPDATE Mascota SET especie = 'Perro grande' WHERE id_mascota = 1;
UPDATE Veterinario SET especialidad = 'Caninos y felinos' WHERE id_veterinario = 1;
UPDATE Servicio SET costo = 55000 WHERE id_servicio = 1;
UPDATE Medicamento SET dosis = '750mg' WHERE id_medicamento = 1;

-- DELETE
DELETE FROM Cita_Servicio WHERE id_cita = 1 AND id_servicio = 2;
DELETE FROM Servicio_Medicamento WHERE id_servicio = 1 AND id_medicamento = 1;
DELETE FROM Cita WHERE id_cita = 5;
DELETE FROM Cliente WHERE id_cliente = 5;
DELETE FROM Veterinario WHERE id_veterinario = 5;

-- SELECT
SELECT * FROM Cliente;
SELECT nombre FROM Mascota WHERE especie LIKE '%Perro%';
SELECT nombre, especialidad FROM Veterinario WHERE especialidad LIKE '%Caninos%';
SELECT nombre, costo FROM Servicio WHERE costo > 40000;
SELECT C.id_cita, M.nombre AS mascota, V.nombre AS veterinario
FROM Cita C
JOIN Mascota M ON C.id_mascota = M.id_mascota
JOIN Veterinario V ON C.id_veterinario = V.id_veterinario;

-- FUNCIONES
SELECT COUNT(*) AS total_citas FROM Cita;
SELECT AVG(costo) AS promedio_costo FROM Servicio;
SELECT MAX(costo) AS servicio_mas_caro FROM Servicio;
SELECT MIN(costo) AS servicio_mas_barato FROM Servicio;
SELECT Cl.nombre, COALESCE(C.fecha, 'Sin cita') AS proxima_cita
FROM Cliente Cl
LEFT JOIN Mascota Ma ON Cl.id_cliente = Ma.id_cliente
LEFT JOIN Cita C ON Ma.id_mascota = C.id_mascota;
SELECT S.nombre, CASE
  WHEN S.costo > 50000 THEN 'Caro'
  ELSE 'Económico'
END AS tipo_servicio
FROM Servicio S;
SELECT Cl.nombre FROM Cliente Cl
WHERE EXISTS (
  SELECT 1 FROM Mascota Ma WHERE Ma.id_cliente = Cl.id_cliente
);
SELECT V.nombre, COUNT(C.id_cita) AS total_citas
FROM Veterinario V
LEFT JOIN Cita C ON V.id_veterinario = C.id_veterinario
GROUP BY V.id_veterinario;
SELECT nombre FROM Servicio
WHERE id_servicio IN (
  SELECT id_servicio FROM Cita_Servicio
  GROUP BY id_servicio
  HAVING COUNT(*) >= 1
);
SELECT M.nombre, COUNT(SM.id_servicio) AS veces_usado
FROM Medicamento M
LEFT JOIN Servicio_Medicamento SM ON M.id_medicamento = SM.id_medicamento
GROUP BY M.id_medicamento;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE citas_por_cliente(IN cliente_id INT)
BEGIN
  SELECT C.id_cita, C.fecha
  FROM Cita C
  JOIN Mascota M ON C.id_mascota = M.id_mascota
  WHERE M.id_cliente = cliente_id;
END //
DELIMITER ;

-- EJECUCIÓN DEL PROCEDIMIENTO
CALL citas_por_cliente(1);
