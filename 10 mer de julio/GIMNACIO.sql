-- ===========================================
-- BASE DE DATOS: gimnasio_fitness
-- ===========================================

DROP DATABASE IF EXISTS gimnasio_fitness;
CREATE DATABASE gimnasio_fitness;
USE gimnasio_fitness;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Socio (
  id_socio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  correo VARCHAR(100)
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  puesto VARCHAR(50)
);

CREATE TABLE Membresia (
  id_membresia INT AUTO_INCREMENT PRIMARY KEY,
  tipo VARCHAR(50),
  precio DECIMAL(10,2)
);

CREATE TABLE Plan_Entrenamiento (
  id_plan INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(200),
  duracion_semanas INT
);

CREATE TABLE Clase (
  id_clase INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  horario VARCHAR(50)
);

CREATE TABLE Instructor (
  id_instructor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especialidad VARCHAR(50)
);

CREATE TABLE Equipo (
  id_equipo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  estado VARCHAR(50)
);

CREATE TABLE Mantenimiento (
  id_mantenimiento INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE,
  descripcion VARCHAR(200)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_socio INT,
  monto DECIMAL(10,2),
  fecha DATE,
  metodo VARCHAR(50),
  FOREIGN KEY (id_socio) REFERENCES Socio(id_socio)
);

CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Socio_Clase (
  id_socio INT,
  id_clase INT,
  PRIMARY KEY (id_socio, id_clase),
  FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
  FOREIGN KEY (id_clase) REFERENCES Clase(id_clase)
);

CREATE TABLE Equipo_Mantenimiento (
  id_equipo INT,
  id_mantenimiento INT,
  PRIMARY KEY (id_equipo, id_mantenimiento),
  FOREIGN KEY (id_equipo) REFERENCES Equipo(id_equipo),
  FOREIGN KEY (id_mantenimiento) REFERENCES Mantenimiento(id_mantenimiento)
);

-- ===========================================
-- INSERT (5 por entidad clave)
-- ===========================================

INSERT INTO Socio (nombre, correo) VALUES
('Pedro López', 'pedro@gym.com'),
('Ana Torres', 'ana@gym.com'),
('Luis Díaz', 'luis@gym.com'),
('Marta Ruiz', 'marta@gym.com'),
('Carlos Gómez', 'carlos@gym.com');

INSERT INTO Empleado (nombre, puesto) VALUES
('Laura Martínez', 'Recepcionista'),
('Diego Torres', 'Gerente'),
('Sofía Ramírez', 'Nutricionista'),
('Andrés Rojas', 'Entrenador'),
('Paula Jiménez', 'Mantenimiento');

INSERT INTO Membresia (tipo, precio) VALUES
('Mensual', 100000),
('Trimestral', 270000),
('Semestral', 500000),
('Anual', 900000),
('VIP', 1200000);

INSERT INTO Plan_Entrenamiento (descripcion, duracion_semanas) VALUES
('Bajar de peso', 12),
('Ganar masa muscular', 16),
('Tonificar', 8),
('Resistencia', 10),
('Full Body', 6);

INSERT INTO Clase (nombre, horario) VALUES
('Yoga', '6:00 AM'),
('Spinning', '7:00 AM'),
('Crossfit', '6:00 PM'),
('Pilates', '8:00 AM'),
('Zumba', '7:00 PM');

INSERT INTO Instructor (nombre, especialidad) VALUES
('Julio Pérez', 'Yoga'),
('María Torres', 'Spinning'),
('Luis Ramírez', 'Crossfit'),
('Paola Gómez', 'Pilates'),
('Camilo Ruiz', 'Zumba');

INSERT INTO Equipo (nombre, estado) VALUES
('Caminadora', 'Operativo'),
('Bicicleta estática', 'Mantenimiento'),
('Pesas', 'Operativo'),
('Banco de pesas', 'Operativo'),
('Elíptica', 'Mantenimiento');

INSERT INTO Mantenimiento (fecha, descripcion) VALUES
('2025-07-10', 'Cambio de piezas'),
('2025-07-11', 'Lubricación'),
('2025-07-12', 'Revisión general'),
('2025-07-13', 'Reparación'),
('2025-07-14', 'Limpieza');

INSERT INTO Pago (id_socio, monto, fecha, metodo) VALUES
(1, 100000, '2025-07-10', 'Efectivo'),
(2, 270000, '2025-07-11', 'Tarjeta'),
(3, 500000, '2025-07-12', 'Transferencia'),
(4, 900000, '2025-07-13', 'Cheque'),
(5, 1200000, '2025-07-14', 'Tarjeta');

INSERT INTO Sucursal (nombre, direccion) VALUES
('Sucursal Norte', 'Calle 10 #5-67'),
('Sucursal Sur', 'Carrera 20 #15-30'),
('Sucursal Este', 'Avenida 1 #2-3'),
('Sucursal Oeste', 'Calle 8 #8-8'),
('Sucursal Centro', 'Cra 4 #4-4');

INSERT INTO Socio_Clase VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO Equipo_Mantenimiento VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Socio SET correo = 'nuevo_pedro@gym.com' WHERE id_socio = 1;
UPDATE Empleado SET puesto = 'Entrenador Personal' WHERE id_empleado = 1;
UPDATE Membresia SET precio = 110000 WHERE id_membresia = 1;
UPDATE Equipo SET estado = 'Reparado' WHERE id_equipo = 2;
UPDATE Pago SET monto = 105000 WHERE id_pago = 1;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Socio_Clase WHERE id_socio = 1 AND id_clase = 1;
DELETE FROM Equipo_Mantenimiento WHERE id_equipo = 1 AND id_mantenimiento = 1;
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Socio WHERE id_socio = 1;
DELETE FROM Empleado WHERE id_empleado = 1;

-- ===========================================
-- SELECT, JOIN, SUBCONSULTA, FUNCIONES
-- ===========================================

-- JOIN
SELECT S.nombre, C.nombre
FROM Socio S
JOIN Socio_Clase SC ON S.id_socio = SC.id_socio
JOIN Clase C ON SC.id_clase = C.id_clase;

SELECT E.nombre, M.descripcion
FROM Equipo E
JOIN Equipo_Mantenimiento EM ON E.id_equipo = EM.id_equipo
JOIN Mantenimiento M ON EM.id_mantenimiento = M.id_mantenimiento;

-- SUBCONSULTA
SELECT nombre FROM Socio
WHERE id_socio IN (
  SELECT id_socio FROM Pago WHERE monto > 200000
);

-- FUNCIONES
SELECT COUNT(*) FROM Socio;
SELECT AVG(precio) FROM Membresia;
SELECT MAX(monto) FROM Pago;
SELECT MIN(monto) FROM Pago;
SELECT SUM(monto) FROM Pago;

SELECT tipo,
  CASE WHEN precio > 500000 THEN 'Premium' ELSE 'Básica' END AS tipo_membresia
FROM Membresia;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE clases_por_socio(IN socioId INT)
BEGIN
  SELECT C.nombre
  FROM Socio_Clase SC
  JOIN Clase C ON SC.id_clase = C.id_clase
  WHERE SC.id_socio = socioId;
END //
DELIMITER ;

CALL clases_por_socio(2);
