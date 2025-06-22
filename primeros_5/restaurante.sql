DROP DATABASE IF EXISTS restaurante;
CREATE DATABASE restaurante;
USE restaurante;

CREATE TABLE Restaurante (
  id_restaurante INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  cargo VARCHAR(100) NOT NULL,
  id_restaurante INT,
  FOREIGN KEY (id_restaurante) REFERENCES Restaurante(id_restaurante)
);

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL
);

CREATE TABLE Pedido (
  id_pedido INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  id_cliente INT,
  id_empleado INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Plato (
  id_plato INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE Bebida (
  id_bebida INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL
);

CREATE TABLE Promocion (
  id_promocion INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(150) NOT NULL
);

CREATE TABLE Pedido_Plato (
  id_pedido INT,
  id_plato INT,
  PRIMARY KEY (id_pedido, id_plato),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_plato) REFERENCES Plato(id_plato)
);

CREATE TABLE Pedido_Bebida (
  id_pedido INT,
  id_bebida INT,
  PRIMARY KEY (id_pedido, id_bebida),
  FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
  FOREIGN KEY (id_bebida) REFERENCES Bebida(id_bebida)
);

INSERT INTO Restaurante (nombre, direccion) VALUES 
('El Buen Sabor', 'Calle 50 #30-10'),
('Delicias Express', 'Av. 10 #15-40');

INSERT INTO Empleado (nombre, cargo, id_restaurante) VALUES 
('Mario Díaz', 'Mesero', 1),
('Lucía Ramírez', 'Chef', 2);

INSERT INTO Cliente (nombre, telefono) VALUES 
('Juan Martínez', '3216549870'),
('Sofía López', '3129876543');

INSERT INTO Pedido (fecha, id_cliente, id_empleado) VALUES 
('2025-07-01', 1, 1),
('2025-07-02', 2, 2);

INSERT INTO Plato (nombre, precio) VALUES 
('Bandeja Paisa', 25000),
('Hamburguesa', 18000);

INSERT INTO Bebida (nombre, precio) VALUES 
('Gaseosa', 4000),
('Jugo Natural', 5000);

INSERT INTO Promocion (descripcion) VALUES 
('2x1 en bebidas'),
('10% descuento en platos');

INSERT INTO Pedido_Plato VALUES 
(1, 1),
(2, 2);

INSERT INTO Pedido_Bebida VALUES 
(1, 1),
(2, 2);

UPDATE Plato
SET precio = 19000
WHERE nombre = 'Hamburguesa';

DELETE FROM Pedido_Bebida
WHERE id_pedido = 2 AND id_bebida = 2;

SELECT P.id_pedido, C.nombre AS cliente, PL.nombre AS plato
FROM Pedido P
INNER JOIN Cliente C ON P.id_cliente = C.id_cliente
INNER JOIN Pedido_Plato PP ON P.id_pedido = PP.id_pedido
INNER JOIN Plato PL ON PP.id_plato = PL.id_plato;

SELECT PL.nombre AS plato, PP.id_pedido
FROM Plato PL
LEFT JOIN Pedido_Plato PP ON PL.id_plato = PP.id_plato;

SELECT B.nombre AS bebida, PB.id_pedido
FROM Pedido_Bebida PB
RIGHT JOIN Bebida B ON PB.id_bebida = B.id_bebida;

SELECT nombre 
FROM Cliente
WHERE id_cliente = (
  SELECT id_cliente FROM Pedido
  ORDER BY fecha DESC
  LIMIT 1
);

SELECT PL.nombre
FROM Plato PL
JOIN Pedido_Plato PP ON PL.id_plato = PP.id_plato
WHERE PP.id_pedido = (
  SELECT id_pedido FROM Pedido
  ORDER BY fecha DESC
  LIMIT 1
);
