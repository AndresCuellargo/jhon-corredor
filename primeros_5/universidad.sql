DROP DATABASE IF EXISTS universidad;
CREATE DATABASE universidad;
USE universidad;

CREATE TABLE Universidad (
  id_universidad INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL
);

CREATE TABLE Facultad (
  id_facultad INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_universidad INT,
  FOREIGN KEY (id_universidad) REFERENCES Universidad(id_universidad)
);

CREATE TABLE Carrera (
  id_carrera INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_facultad INT,
  FOREIGN KEY (id_facultad) REFERENCES Facultad(id_facultad)
);

CREATE TABLE Estudiante (
  id_estudiante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  documento VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Profesor (
  id_profesor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Materia (
  id_materia INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_carrera INT,
  FOREIGN KEY (id_carrera) REFERENCES Carrera(id_carrera)
);

CREATE TABLE Curso (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  id_materia INT,
  id_profesor INT,
  FOREIGN KEY (id_materia) REFERENCES Materia(id_materia),
  FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor)
);

CREATE TABLE Curso_Estudiante (
  id_curso INT,
  id_estudiante INT,
  PRIMARY KEY (id_curso, id_estudiante),
  FOREIGN KEY (id_curso) REFERENCES Curso(id_curso),
  FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante)
);

INSERT INTO Universidad (nombre, direccion) VALUES 
('Universidad Nacional', 'Calle 45 #30-00'),
('Universidad Central', 'Av. 19 #14-15');

INSERT INTO Facultad (nombre, id_universidad) VALUES 
('Ingeniería', 1),
('Ciencias', 2);

INSERT INTO Carrera (nombre, id_facultad) VALUES 
('Sistemas', 1),
('Biología', 2);

INSERT INTO Estudiante (nombre, documento) VALUES 
('Carlos Peña', '100200300'),
('Laura Torres', '123456789');

INSERT INTO Profesor (nombre) VALUES 
('Dr. Ramírez'),
('Dra. Gómez');

INSERT INTO Materia (nombre, id_carrera) VALUES 
('Programación', 1),
('Genética', 2);

INSERT INTO Curso (id_materia, id_profesor) VALUES 
(1, 1),
(2, 2);

INSERT INTO Curso_Estudiante VALUES 
(1, 1),
(2, 2);

UPDATE Carrera
SET nombre = 'Ingeniería de Sistemas'
WHERE nombre = 'Sistemas';

DELETE FROM Curso_Estudiante
WHERE id_curso = 2 AND id_estudiante = 2;

SELECT C.id_curso, M.nombre AS materia, P.nombre AS profesor
FROM Curso C
INNER JOIN Materia M ON C.id_materia = M.id_materia
INNER JOIN Profesor P ON C.id_profesor = P.id_profesor;

SELECT M.nombre AS materia, CA.nombre AS carrera
FROM Materia M
LEFT JOIN Carrera CA ON M.id_carrera = CA.id_carrera;

SELECT P.nombre AS profesor, C.id_curso
FROM Curso C
RIGHT JOIN Profesor P ON C.id_profesor = P.id_profesor;

SELECT nombre 
FROM Estudiante
WHERE id_estudiante = (
  SELECT id_estudiante FROM Curso_Estudiante
  ORDER BY id_curso DESC
  LIMIT 1
);

SELECT M.nombre
FROM Materia M
JOIN Curso C ON M.id_materia = C.id_materia
WHERE C.id_curso = (
  SELECT id_curso FROM Curso
  ORDER BY id_curso DESC
  LIMIT 1
);
