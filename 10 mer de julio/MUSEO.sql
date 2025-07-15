-- ===========================================
-- BASE DE DATOS: museo
-- ===========================================

DROP DATABASE IF EXISTS museo;
CREATE DATABASE museo;
USE museo;

-- ===========================================
-- TABLAS PRINCIPALES
-- ===========================================

CREATE TABLE Visitante (
  id_visitante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  correo VARCHAR(100)
);

CREATE TABLE Exposicion (
  id_exposicion INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100),
  fecha_inicio DATE,
  fecha_fin DATE
);

CREATE TABLE Sala (
  id_sala INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  ubicacion VARCHAR(100)
);

CREATE TABLE Guia (
  id_guia INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  especialidad VARCHAR(100)
);

CREATE TABLE Boleto (
  id_boleto INT AUTO_INCREMENT PRIMARY KEY,
  id_visitante INT,
  fecha DATE,
  precio DECIMAL(10,2),
  FOREIGN KEY (id_visitante) REFERENCES Visitante(id_visitante)
);

CREATE TABLE Compra (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,
  id_boleto INT,
  metodo_pago VARCHAR(50),
  fecha DATE,
  FOREIGN KEY (id_boleto) REFERENCES Boleto(id_boleto)
);

CREATE TABLE Artista (
  id_artista INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  pais_origen VARCHAR(50)
);

CREATE TABLE Obra (
  id_obra INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(100),
  anio INT
);

CREATE TABLE Donacion (
  id_donacion INT AUTO_INCREMENT PRIMARY KEY,
  monto DECIMAL(12,2),
  fecha DATE
);

CREATE TABLE Patrocinador (
  id_patrocinador INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100),
  contacto VARCHAR(100)
);

-- ===========================================
-- TABLAS PIVOTE
-- ===========================================

CREATE TABLE Exposicion_Obra (
  id_exposicion INT,
  id_obra INT,
  PRIMARY KEY (id_exposicion, id_obra),
  FOREIGN KEY (id_exposicion) REFERENCES Exposicion(id_exposicion),
  FOREIGN KEY (id_obra) REFERENCES Obra(id_obra)
);

CREATE TABLE Obra_Artista (
  id_obra INT,
  id_artista INT,
  PRIMARY KEY (id_obra, id_artista),
  FOREIGN KEY (id_obra) REFERENCES Obra(id_obra),
  FOREIGN KEY (id_artista) REFERENCES Artista(id_artista)
);

-- ===========================================
-- INSERT (5 por entidad clave)
-- ===========================================

INSERT INTO Visitante (nombre, correo) VALUES
('Luis Pérez', 'luis@museo.com'),
('María Gómez', 'maria@museo.com'),
('Juan Rodríguez', 'juan@museo.com'),
('Ana López', 'ana@museo.com'),
('Pedro Sánchez', 'pedro@museo.com');

INSERT INTO Exposicion (titulo, fecha_inicio, fecha_fin) VALUES
('Arte Moderno', '2025-11-01', '2025-12-31'),
('Escultura Clásica', '2025-09-01', '2025-10-15'),
('Fotografía Urbana', '2025-07-01', '2025-08-30'),
('Pintura Contemporánea', '2025-06-01', '2025-07-30'),
('Arte Latinoamericano', '2025-05-01', '2025-06-30');

INSERT INTO Sala (nombre, ubicacion) VALUES
('Sala A', 'Primer Piso'),
('Sala B', 'Segundo Piso'),
('Sala C', 'Tercer Piso'),
('Sala D', 'Cuarto Piso'),
('Sala E', 'Quinto Piso');

INSERT INTO Guia (nombre, especialidad) VALUES
('Carlos Ruiz', 'Arte Moderno'),
('Laura Torres', 'Escultura'),
('Miguel Ramírez', 'Fotografía'),
('Sandra Díaz', 'Pintura'),
('Julio Herrera', 'Arte Latinoamericano');

INSERT INTO Boleto (id_visitante, fecha, precio) VALUES
(1, '2025-06-10', 15000),
(2, '2025-06-11', 15000),
(3, '2025-06-12', 15000),
(4, '2025-06-13', 15000),
(5, '2025-06-14', 15000);

INSERT INTO Compra (id_boleto, metodo_pago, fecha) VALUES
(1, 'Efectivo', '2025-06-10'),
(2, 'Tarjeta', '2025-06-11'),
(3, 'Transferencia', '2025-06-12'),
(4, 'Tarjeta', '2025-06-13'),
(5, 'Efectivo', '2025-06-14');

INSERT INTO Artista (nombre, pais_origen) VALUES
('Diego Rivera', 'México'),
('Frida Kahlo', 'México'),
('Fernando Botero', 'Colombia'),
('Tarsila do Amaral', 'Brasil'),
('Oswaldo Guayasamín', 'Ecuador');

INSERT INTO Obra (titulo, anio) VALUES
('Sueño de una tarde dominical', 1947),
('Las dos Fridas', 1939),
('La Mona Lisa de Botero', 1978),
('Abaporu', 1928),
('El grito', 1983);

INSERT INTO Donacion (monto, fecha) VALUES
(5000000, '2025-06-10'),
(6000000, '2025-06-11'),
(7000000, '2025-06-12'),
(8000000, '2025-06-13'),
(9000000, '2025-06-14');

INSERT INTO Patrocinador (nombre, contacto) VALUES
('Fundación Arte Vivo', 'contacto@artevivo.org'),
('Empresas Creativas', 'info@empresascreativas.com'),
('Mecenas del Arte', 'mecenas@museo.com'),
('Cultura Global', 'cultura@global.org'),
('Arte Internacional', 'arte@internacional.com');

INSERT INTO Exposicion_Obra VALUES
(1, 1), (1, 2), (2, 3), (3, 4), (4, 5);

INSERT INTO Obra_Artista VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

-- ===========================================
-- UPDATE
-- ===========================================

UPDATE Visitante SET correo = 'nuevo_luis@museo.com' WHERE id_visitante = 1;
UPDATE Exposicion SET fecha_fin = '2025-12-15' WHERE id_exposicion = 1;
UPDATE Sala SET ubicacion = 'Planta Baja' WHERE id_sala = 1;
UPDATE Guia SET especialidad = 'Historia del Arte' WHERE id_guia = 1;
UPDATE Obra SET anio = 1950 WHERE id_obra = 1;

-- ===========================================
-- DELETE
-- ===========================================

DELETE FROM Exposicion_Obra WHERE id_exposicion = 1 AND id_obra = 2;
DELETE FROM Obra_Artista WHERE id_obra = 1 AND id_artista = 1;
DELETE FROM Compra WHERE id_compra = 1;
DELETE FROM Boleto WHERE id_boleto = 1;
DELETE FROM Visitante WHERE id_visitante = 1;

-- ===========================================
-- SELECT & FUNCIONES
-- ===========================================

-- JOIN
SELECT V.nombre, B.fecha
FROM Visitante V
JOIN Boleto B ON V.id_visitante = B.id_visitante;

SELECT E.titulo, O.titulo
FROM Exposicion E
JOIN Exposicion_Obra EO ON E.id_exposicion = EO.id_exposicion
JOIN Obra O ON EO.id_obra = O.id_obra;

SELECT O.titulo, A.nombre
FROM Obra O
JOIN Obra_Artista OA ON O.id_obra = OA.id_obra
JOIN Artista A ON OA.id_artista = A.id_artista;

-- SUBCONSULTA
SELECT nombre FROM Visitante
WHERE id_visitante IN (
  SELECT id_visitante FROM Boleto WHERE precio > 10000
);

-- FUNCIONES
SELECT COUNT(*) FROM Obra;
SELECT AVG(precio) FROM Boleto;
SELECT MAX(monto) FROM Donacion;
SELECT MIN(monto) FROM Donacion;
SELECT SUM(monto) FROM Donacion;

SELECT titulo,
  CASE WHEN anio < 1950 THEN 'Clásica' ELSE 'Moderna' END AS estilo
FROM Obra;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE obras_exposicion(IN exposicionId INT)
BEGIN
  SELECT O.titulo
  FROM Exposicion_Obra EO
  JOIN Obra O ON EO.id_obra = O.id_obra
  WHERE EO.id_exposicion = exposicionId;
END //
DELIMITER ;

CALL obras_exposicion(1);
