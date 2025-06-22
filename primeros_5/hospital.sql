DROP DATABASE IF EXISTS hospital;
CREATE DATABASE hospital;
USE hospital;

CREATE TABLE Hospital (
  id_hospital INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL
);

CREATE TABLE Departamento (
  id_departamento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_hospital INT,
  FOREIGN KEY (id_hospital) REFERENCES Hospital(id_hospital)
);

CREATE TABLE Medico (
  id_medico INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  especialidad VARCHAR(100) NOT NULL,
  id_departamento INT,
  FOREIGN KEY (id_departamento) REFERENCES Departamento(id_departamento)
);

CREATE TABLE Paciente (
  id_paciente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  fecha_nacimiento DATE NOT NULL
);

CREATE TABLE Cita (
  id_cita INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATETIME NOT NULL,
  id_paciente INT,
  id_medico INT,
  FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
  FOREIGN KEY (id_medico) REFERENCES Medico(id_medico)
);

CREATE TABLE Tratamiento (
  id_tratamiento INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(150) NOT NULL
);

CREATE TABLE Medicamento (
  id_medicamento INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  dosis VARCHAR(50) NOT NULL
);

CREATE TABLE Cita_Tratamiento (
  id_cita INT,
  id_tratamiento INT,
  PRIMARY KEY (id_cita, id_tratamiento),
  FOREIGN KEY (id_cita) REFERENCES Cita(id_cita),
  FOREIGN KEY (id_tratamiento) REFERENCES Tratamiento(id_tratamiento)
);

CREATE TABLE Tratamiento_Medicamento (
  id_tratamiento INT,
  id_medicamento INT,
  PRIMARY KEY (id_tratamiento, id_medicamento),
  FOREIGN KEY (id_tratamiento) REFERENCES Tratamiento(id_tratamiento),
  FOREIGN KEY (id_medicamento) REFERENCES Medicamento(id_medicamento)
);

INSERT INTO Hospital (nombre, direccion) VALUES 
('Hospital Central', 'Av. Salud 123'),
('Clínica Norte', 'Calle 45 #30-10');

INSERT INTO Departamento (nombre, id_hospital) VALUES 
('Cardiología', 1),
('Pediatría', 2);

INSERT INTO Medico (nombre, especialidad, id_departamento) VALUES 
('Dr. López', 'Cardiólogo', 1),
('Dra. Gómez', 'Pediatra', 2);

INSERT INTO Paciente (nombre, fecha_nacimiento) VALUES 
('Juan Pérez', '1980-05-12'),
('María Ruiz', '2010-08-20');

INSERT INTO Cita (fecha, id_paciente, id_medico) VALUES 
('2025-07-01 10:00:00', 1, 1),
('2025-07-02 11:00:00', 2, 2);

INSERT INTO Tratamiento (descripcion) VALUES 
('Control de presión arterial'),
('Revisión pediátrica');

INSERT INTO Medicamento (nombre, dosis) VALUES 
('Losartán', '50mg'),
('Paracetamol', '500mg');

INSERT INTO Cita_Tratamiento VALUES 
(1, 1),
(2, 2);

INSERT INTO Tratamiento_Medicamento VALUES 
(1, 1),
(2, 2);

UPDATE Medicamento
SET dosis = '650mg'
WHERE nombre = 'Paracetamol';

DELETE FROM Cita_Tratamiento
WHERE id_cita = 2 AND id_tratamiento = 2;

SELECT C.id_cita, P.nombre AS paciente, M.nombre AS medico
FROM Cita C
INNER JOIN Paciente P ON C.id_paciente = P.id_paciente
INNER JOIN Medico M ON C.id_medico = M.id_medico;

SELECT T.descripcion, CT.id_cita
FROM Tratamiento T
LEFT JOIN Cita_Tratamiento CT ON T.id_tratamiento = CT.id_tratamiento;

SELECT M.nombre AS medicamento, TM.id_tratamiento
FROM Tratamiento_Medicamento TM
RIGHT JOIN Medicamento M ON TM.id_medicamento = M.id_medicamento;

SELECT nombre 
FROM Paciente
WHERE id_paciente = (
  SELECT id_paciente FROM Cita
  ORDER BY fecha DESC
  LIMIT 1
);

SELECT T.descripcion
FROM Tratamiento T
JOIN Cita_Tratamiento CT ON T.id_tratamiento = CT.id_tratamiento
WHERE CT.id_cita = (
  SELECT id_cita FROM Cita
  ORDER BY fecha DESC
  LIMIT 1
);
