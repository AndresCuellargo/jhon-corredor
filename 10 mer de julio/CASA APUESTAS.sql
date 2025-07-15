-- ===========================================
-- BASE DE DATOS: casa_apuestas
-- ===========================================

DROP DATABASE IF EXISTS casa_apuestas;
CREATE DATABASE casa_apuestas;
USE casa_apuestas;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) UNIQUE
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  cargo VARCHAR(50)
);

CREATE TABLE Evento (
  id_evento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  fecha DATE,
  id_deporte INT
);

CREATE TABLE Deporte (
  id_deporte INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50)
);

CREATE TABLE Apuesta (
  id_apuesta INT AUTO_INCREMENT PRIMARY KEY,
  id_cliente INT,
  id_evento INT,
  monto DECIMAL(10,2),
  cuota DECIMAL(5,2),
  fecha TIMESTAMP,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
);

CREATE TABLE Pago (
  id_pago INT AUTO_INCREMENT PRIMARY KEY,
  id_apuesta INT,
  id_metodo INT,
  monto DECIMAL(10,2),
  fecha_pago DATE,
  FOREIGN KEY (id_apuesta) REFERENCES Apuesta(id_apuesta)
);

CREATE TABLE Metodo_Pago (
  id_metodo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50)
);

CREATE TABLE Resultado (
  id_resultado INT AUTO_INCREMENT PRIMARY KEY,
  id_evento INT,
  ganador VARCHAR(100),
  FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
);

CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  direccion VARCHAR(150)
);

CREATE TABLE Promocion (
  id_promocion INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(255),
  descuento DECIMAL(5,2)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Apuesta_Evento (
  id_apuesta INT,
  id_evento INT,
  PRIMARY KEY (id_apuesta, id_evento),
  FOREIGN KEY (id_apuesta) REFERENCES Apuesta(id_apuesta),
  FOREIGN KEY (id_evento) REFERENCES Evento(id_evento)
);

CREATE TABLE Cliente_Promocion (
  id_cliente INT,
  id_promocion INT,
  PRIMARY KEY (id_cliente, id_promocion),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_promocion) REFERENCES Promocion(id_promocion)
);

-- ===========================================
-- INSERT
-- ===========================================

INSERT INTO Cliente (nombre, correo) VALUES
('Juan Pérez', 'juan@correo.com'),
('Laura Méndez', 'laura@correo.com'),
('Pedro Ortiz', 'pedro@correo.com'),
('Ana Salazar', 'ana@correo.com'),
('Carlos Gómez', 'carlos@correo.com');

INSERT INTO Empleado (nombre, cargo) VALUES
('Mario Torres', 'Cajero'),
('Sofía Díaz', 'Supervisor'),
('Diego Ramírez', 'Gerente'),
('Natalia Ruiz', 'Cajero'),
('Felipe López', 'Analista');

INSERT INTO Deporte (nombre) VALUES
('Fútbol'), ('Tenis'), ('Baloncesto'), ('Beisbol'), ('Boxeo');

INSERT INTO Evento (nombre, fecha, id_deporte) VALUES
('Partido Fútbol Final', '2025-07-20', 1),
('Open Tenis', '2025-07-21', 2),
('NBA Playoffs', '2025-07-22', 3),
('Serie Mundial', '2025-07-23', 4),
('Pelea Título', '2025-07-24', 5);

INSERT INTO Metodo_Pago (nombre) VALUES
('Efectivo'), ('Tarjeta'), ('Transferencia'), ('Criptomoneda'), ('Cheque');

INSERT INTO Promocion (descripcion, descuento) VALUES
('Bono bienvenida', 10),
('Promo Verano', 15),
('Cashback', 5),
('Multiplica Apuesta', 20),
('Freebet', 25);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Cliente SET correo = 'nuevo_juan@correo.com' WHERE id_cliente = 1;
UPDATE Empleado SET cargo = 'Administrador' WHERE id_empleado = 3;
UPDATE Evento SET fecha = '2025-07-25' WHERE id_evento = 5;
UPDATE Promocion SET descuento = 30 WHERE id_promocion = 5;
UPDATE Metodo_Pago SET nombre = 'PayPal' WHERE id_metodo = 4;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Cliente_Promocion WHERE id_cliente = 1 AND id_promocion = 1;
DELETE FROM Apuesta_Evento WHERE id_apuesta = 1 AND id_evento = 1;
DELETE FROM Pago WHERE id_pago = 1;
DELETE FROM Resultado WHERE id_resultado = 1;
DELETE FROM Apuesta WHERE id_apuesta = 1;

-- ===========================================
-- SELECT & FUNCIONES
-- ===========================================

-- JOINs
SELECT C.nombre, A.monto
FROM Cliente C
JOIN Apuesta A ON C.id_cliente = A.id_cliente;

SELECT A.id_apuesta, E.nombre
FROM Apuesta A
JOIN Evento E ON A.id_evento = E.id_evento;

SELECT C.nombre, P.monto
FROM Cliente C
LEFT JOIN Apuesta A ON C.id_cliente = A.id_cliente
LEFT JOIN Pago P ON A.id_apuesta = P.id_apuesta;

SELECT C.nombre, COALESCE(P.monto, 0) AS pago
FROM Cliente C
LEFT JOIN Apuesta A ON C.id_cliente = A.id_cliente
LEFT JOIN Pago P ON A.id_apuesta = P.id_apuesta;

SELECT nombre, 
  CASE WHEN descuento >= 20 THEN 'Alta' ELSE 'Normal' END AS tipo_descuento
FROM Promocion;

-- SUBCONSULTA
SELECT nombre FROM Cliente WHERE id_cliente IN (
  SELECT id_cliente FROM Apuesta WHERE monto > 50000
);

-- FUNCIONES
SELECT COUNT(*) FROM Apuesta;
SELECT AVG(monto) FROM Apuesta;
SELECT MAX(monto) FROM Apuesta;
SELECT MIN(monto) FROM Apuesta;
SELECT SUM(monto) FROM Apuesta;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE apuestas_cliente(IN clienteId INT)
BEGIN
  SELECT A.id_apuesta, A.monto
  FROM Apuesta A
  WHERE A.id_cliente = clienteId;
END //
DELIMITER ;

CALL apuestas_cliente(1);
