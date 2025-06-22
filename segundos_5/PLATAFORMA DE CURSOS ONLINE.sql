DROP DATABASE IF EXISTS cursos;
CREATE DATABASE cursos;
USE cursos;

-- TABLAS PRINCIPALES
CREATE TABLE Usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  correo VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Instructor (
  id_instructor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  especialidad VARCHAR(100) NOT NULL
);

CREATE TABLE Curso (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(150) NOT NULL,
  descripcion TEXT,
  id_instructor INT,
  FOREIGN KEY (id_instructor) REFERENCES Instructor(id_instructor)
);

CREATE TABLE Categoria (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Leccion (
  id_leccion INT AUTO_INCREMENT PRIMARY KEY,
  titulo VARCHAR(150) NOT NULL,
  contenido TEXT,
  id_curso INT,
  FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- PIVOTE: Curso - Categoria
CREATE TABLE Curso_Categoria (
  id_curso INT,
  id_categoria INT,
  PRIMARY KEY (id_curso, id_categoria),
  FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
  FOREIGN KEY (id_categoria) REFERENCES Categoria(id_categoria)
);

-- PIVOTE: Usuario - Curso (inscripción)
CREATE TABLE Usuario_Curso (
  id_usuario INT,
  id_curso INT,
  fecha_inscripcion DATE NOT NULL,
  PRIMARY KEY (id_usuario, id_curso),
  FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario),
  FOREIGN KEY (id_curso) REFERENCES Curso(id_curso)
);

-- INSERTS
INSERT INTO Usuario (nombre, correo) VALUES
('Carlos Pérez', 'carlos@example.com'),
('Ana Gómez', 'ana@example.com'),
('Luis Torres', 'luis@example.com'),
('Marta Ruiz', 'marta@example.com'),
('Jorge Díaz', 'jorge@example.com');

INSERT INTO Instructor (nombre, especialidad) VALUES
('Laura Hernández', 'Matemáticas'),
('Andrés Morales', 'Programación'),
('Sofía Londoño', 'Diseño'),
('Pedro Sánchez', 'Inglés'),
('Camila Restrepo', 'Historia');

INSERT INTO Curso (titulo, descripcion, id_instructor) VALUES
('Álgebra Básica', 'Curso de introducción al álgebra', 1),
('Java desde cero', 'Aprende Java paso a paso', 2),
('Photoshop avanzado', 'Diseño gráfico profesional', 3),
('Inglés conversacional', 'Mejora tu inglés hablado', 4),
('Historia Universal', 'Recorrido por la historia del mundo', 5);

INSERT INTO Categoria (nombre) VALUES
('Matemáticas'),
('Programación'),
('Diseño'),
('Idiomas'),
('Humanidades');

INSERT INTO Leccion (titulo, contenido, id_curso) VALUES
('Introducción al álgebra', 'Contenido de la lección 1', 1),
('Variables en Java', 'Contenido de la lección 1', 2),
('Capas en Photoshop', 'Contenido de la lección 1', 3),
('Saludos en inglés', 'Contenido de la lección 1', 4),
('La Edad Antigua', 'Contenido de la lección 1', 5);

INSERT INTO Curso_Categoria VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5);

INSERT INTO Usuario_Curso VALUES
(1, 1, '2025-07-01'),
(2, 2, '2025-07-02'),
(3, 3, '2025-07-03'),
(4, 4, '2025-07-04'),
(5, 5, '2025-07-05');

-- UPDATE
UPDATE Usuario SET nombre = 'Carlos A. Pérez' WHERE id_usuario = 1;
UPDATE Instructor SET especialidad = 'Matemáticas Avanzadas' WHERE id_instructor = 1;
UPDATE Curso SET descripcion = 'Álgebra desde cero hasta avanzado' WHERE id_curso = 1;
UPDATE Categoria SET nombre = 'Matemáticas y Estadística' WHERE id_categoria = 1;
UPDATE Leccion SET contenido = 'Actualización de contenido' WHERE id_leccion = 1;

-- DELETE
DELETE FROM Usuario_Curso WHERE id_usuario = 1 AND id_curso = 1;
DELETE FROM Curso_Categoria WHERE id_curso = 1 AND id_categoria = 1;
DELETE FROM Leccion WHERE id_leccion = 1;
DELETE FROM Curso WHERE id_curso = 5;
DELETE FROM Instructor WHERE id_instructor = 5;

-- SELECT
SELECT * FROM Usuario;
SELECT nombre, especialidad FROM Instructor WHERE especialidad LIKE '%Programación%';
SELECT titulo, descripcion FROM Curso WHERE id_instructor = 2;
SELECT nombre FROM Categoria WHERE nombre LIKE '%Matemáticas%';
SELECT U.nombre AS usuario, C.titulo AS curso FROM Usuario U
JOIN Usuario_Curso UC ON U.id_usuario = UC.id_usuario
JOIN Curso C ON UC.id_curso = C.id_curso;

-- FUNCIONES
SELECT COUNT(*) AS total_cursos FROM Curso;
SELECT AVG(id_curso) AS promedio_id_curso FROM Curso;
SELECT MAX(id_curso) AS curso_mas_alto FROM Curso;
SELECT MIN(id_curso) AS curso_mas_bajo FROM Curso;
SELECT U.nombre, COALESCE(UC.fecha_inscripcion, 'No inscrito') AS fecha_inscripcion
FROM Usuario U
LEFT JOIN Usuario_Curso UC ON U.id_usuario = UC.id_usuario;
SELECT C.titulo, CASE
  WHEN C.id_curso <= 2 THEN 'Curso popular'
  ELSE 'Curso estándar'
END AS tipo_curso
FROM Curso C;
SELECT U.nombre FROM Usuario U
WHERE EXISTS (
  SELECT 1 FROM Usuario_Curso UC WHERE UC.id_usuario = U.id_usuario
);
SELECT I.nombre, COUNT(C.id_curso) AS total_cursos
FROM Instructor I
LEFT JOIN Curso C ON I.id_instructor = C.id_instructor
GROUP BY I.id_instructor;
SELECT titulo FROM Curso
WHERE id_curso IN (
  SELECT id_curso FROM Usuario_Curso
  GROUP BY id_curso
  HAVING COUNT(*) >= 1
);
SELECT CA.nombre, COUNT(CC.id_curso) AS total_cursos
FROM Categoria CA
LEFT JOIN Curso_Categoria CC ON CA.id_categoria = CC.id_categoria
GROUP BY CA.id_categoria;

-- PROCEDIMIENTO
DELIMITER //
CREATE PROCEDURE cursos_por_usuario(IN usuario_id INT)
BEGIN
  SELECT C.titulo, UC.fecha_inscripcion
  FROM Usuario_Curso UC
  JOIN Curso C ON UC.id_curso = C.id_curso
  WHERE UC.id_usuario = usuario_id;
END //
DELIMITER ;

-- EJECUCIÓN DEL PROCEDIMIENTO
CALL cursos_por_usuario(1);
