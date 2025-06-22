DROP DATABASE IF EXISTS biblioteca;
CREATE DATABASE biblioteca;
USE biblioteca;

-- Tablas principales
CREATE TABLE Biblioteca (
  id_biblioteca INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL
);

CREATE TABLE Libro (
  id_libro INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(150) NOT NULL,
  autor VARCHAR(100) NOT NULL,
  anio_publicacion YEAR NOT NULL
);

CREATE TABLE Socio (
  id_socio INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  documento VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  cargo VARCHAR(100) NOT NULL
);

CREATE TABLE Prestamo (
  id_prestamo INT AUTO_INCREMENT PRIMARY KEY,
  id_socio INT,
  id_empleado INT,
  fecha_prestamo DATE NOT NULL,
  fecha_devolucion DATE,
  FOREIGN KEY (id_socio) REFERENCES Socio(id_socio),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

-- Pivote: libros en préstamo
CREATE TABLE Prestamo_Libro (
  id_prestamo INT,
  id_libro INT,
  PRIMARY KEY (id_prestamo, id_libro),
  FOREIGN KEY (id_prestamo) REFERENCES Prestamo(id_prestamo),
  FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

-- Pivote: biblioteca - libro (en qué biblioteca está disponible un libro)
CREATE TABLE Biblioteca_Libro (
  id_biblioteca INT,
  id_libro INT,
  stock INT DEFAULT 1,
  PRIMARY KEY (id_biblioteca, id_libro),
  FOREIGN KEY (id_biblioteca) REFERENCES Biblioteca(id_biblioteca),
  FOREIGN KEY (id_libro) REFERENCES Libro(id_libro)
);

-- INSERTS (5 por tabla relevante)
INSERT INTO Biblioteca (nombre, direccion) VALUES
('Central', 'Calle 1 #10-20'),
('Sur', 'Calle 50 #30-10'),
('Norte', 'Calle 100 #50-60'),
('Occidente', 'Av 68 #20-40'),
('Oriente', 'Calle 20 #5-15');

INSERT INTO Libro (titulo, autor, anio_publicacion) VALUES
('Cien Años de Soledad', 'Gabriel García Márquez', 1967),
('El Principito', 'Antoine de Saint-Exupéry', 1943),
('1984', 'George Orwell', 1949),
('Don Quijote', 'Miguel de Cervantes', 1605),
('La Odisea', 'Homero', 800);

INSERT INTO Socio (nombre, documento) VALUES
('Carlos Pérez', '1001'),
('Ana Gómez', '1002'),
('Luis Torres', '1003'),
('Marta Ruiz', '1004'),
('Jorge Díaz', '1005');

INSERT INTO Empleado (nombre, cargo) VALUES
('Laura Hernández', 'Bibliotecaria'),
('Andrés Morales', 'Auxiliar'),
('Sofía Londoño', 'Bibliotecaria'),
('Pedro Sánchez', 'Auxiliar'),
('Camila Restrepo', 'Bibliotecaria');

INSERT INTO Prestamo (id_socio, id_empleado, fecha_prestamo, fecha_devolucion) VALUES
(1, 1, '2025-07-01', NULL),
(2, 2, '2025-07-02', NULL),
(3, 3, '2025-07-03', NULL),
(4, 4, '2025-07-04', NULL),
(5, 5, '2025-07-05', NULL);

INSERT INTO Prestamo_Libro VALUES
(1, 1), (1, 2), (2, 3), (3, 4), (4, 5);

INSERT INTO Biblioteca_Libro VALUES
(1, 1, 3), (1, 2, 2), (2, 3, 4), (3, 4, 1), (4, 5, 5);

-- UPDATE (5)
UPDATE Biblioteca SET direccion = 'Calle 1 #10-30' WHERE id_biblioteca = 1;
UPDATE Libro SET anio_publicacion = 1968 WHERE id_libro = 1;
UPDATE Socio SET nombre = 'Carlos A. Pérez' WHERE id_socio = 1;
UPDATE Empleado SET cargo = 'Jefe de biblioteca' WHERE id_empleado = 1;
UPDATE Biblioteca_Libro SET stock = 10 WHERE id_biblioteca = 1 AND id_libro = 1;

-- DELETE (5)
DELETE FROM Prestamo_Libro WHERE id_prestamo = 1 AND id_libro = 2;
DELETE FROM Biblioteca_Libro WHERE id_biblioteca = 4 AND id_libro = 5;
DELETE FROM Prestamo WHERE id_prestamo = 5;
DELETE FROM Socio WHERE id_socio = 5;
DELETE FROM Empleado WHERE id_empleado = 5;

-- SELECT (5)
SELECT * FROM Biblioteca;
SELECT titulo, autor FROM Libro WHERE anio_publicacion < 1950;
SELECT nombre FROM Socio WHERE documento = '1001';
SELECT nombre, cargo FROM Empleado WHERE cargo LIKE '%Bibliotecaria%';
SELECT P.id_prestamo, S.nombre AS socio, E.nombre AS empleado FROM Prestamo P
JOIN Socio S ON P.id_socio = S.id_socio
JOIN Empleado E ON P.id_empleado = E.id_empleado;

-- FUNCIONES (10 ejemplos)
SELECT COUNT(*) AS total_libros FROM Libro;
SELECT AVG(stock) AS promedio_stock FROM Biblioteca_Libro;
SELECT MAX(anio_publicacion) AS libro_mas_reciente FROM Libro;
SELECT MIN(anio_publicacion) AS libro_mas_antiguo FROM Libro;
SELECT B.nombre, COALESCE(BL.stock, 0) AS stock FROM Biblioteca B
LEFT JOIN Biblioteca_Libro BL ON B.id_biblioteca = BL.id_biblioteca AND BL.id_libro = 1;
SELECT L.titulo, CASE
  WHEN BL.stock > 3 THEN 'Buen stock'
  ELSE 'Poco stock'
END AS estado_stock
FROM Libro L
JOIN Biblioteca_Libro BL ON L.id_libro = BL.id_libro;
SELECT S.nombre FROM Socio S
WHERE EXISTS (
  SELECT 1 FROM Prestamo P WHERE P.id_socio = S.id_socio
);
SELECT E.nombre, COUNT(P.id_prestamo) AS prestamos_hechos
FROM Empleado E
LEFT JOIN Prestamo P ON E.id_empleado = P.id_empleado
GROUP BY E.id_empleado;
SELECT L.titulo FROM Libro L
WHERE id_libro IN (
  SELECT id_libro FROM Prestamo_Libro
  GROUP BY id_libro
  HAVING COUNT(*) >= 1
);
SELECT B.nombre, SUM(BL.stock) AS total_stock
FROM Biblioteca B
JOIN Biblioteca_Libro BL ON B.id_biblioteca = BL.id_biblioteca
GROUP BY B.id_biblioteca;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE prestamos_por_socio(IN socio_id INT)
BEGIN
  SELECT P.id_prestamo, P.fecha_prestamo, P.fecha_devolucion
  FROM Prestamo P
  WHERE P.id_socio = socio_id;
END //
DELIMITER ;

-- EJECUCIÓN DEL PROCEDIMIENTO
CALL prestamos_por_socio(1);
