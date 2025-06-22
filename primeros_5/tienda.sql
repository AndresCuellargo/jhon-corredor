DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda;
USE tienda;

CREATE TABLE Tienda (
  id_tienda INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL
);

CREATE TABLE Empleado (
  id_empleado INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  cargo VARCHAR(100) NOT NULL,
  id_tienda INT,
  FOREIGN KEY (id_tienda) REFERENCES Tienda(id_tienda)
);

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  telefono VARCHAR(20) NOT NULL
);

CREATE TABLE Prenda (
  id_prenda INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(100) NOT NULL,
  talla VARCHAR(10) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  id_tienda INT,
  FOREIGN KEY (id_tienda) REFERENCES Tienda(id_tienda)
);

CREATE TABLE Venta (
  id_venta INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  id_cliente INT,
  id_empleado INT,
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_empleado) REFERENCES Empleado(id_empleado)
);

CREATE TABLE Promocion (
  id_promocion INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(150) NOT NULL
);

CREATE TABLE Proveedor (
  id_proveedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Venta_Prenda (
  id_venta INT,
  id_prenda INT,
  PRIMARY KEY (id_venta, id_prenda),
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
  FOREIGN KEY (id_prenda) REFERENCES Prenda(id_prenda)
);

CREATE TABLE Prenda_Proveedor (
  id_prenda INT,
  id_proveedor INT,
  PRIMARY KEY (id_prenda, id_proveedor),
  FOREIGN KEY (id_prenda) REFERENCES Prenda(id_prenda),
  FOREIGN KEY (id_proveedor) REFERENCES Proveedor(id_proveedor)
);

INSERT INTO Tienda (nombre, direccion) VALUES 
('Moda Joven', 'Calle 20 #10-30'),
('Fashion House', 'Av. 15 #25-50');

INSERT INTO Empleado (nombre, cargo, id_tienda) VALUES 
('Andrés López', 'Vendedor', 1),
('María Ruiz', 'Gerente', 2);

INSERT INTO Cliente (nombre, telefono) VALUES 
('Carlos García', '3216549870'),
('Luisa Martínez', '3129876543');

INSERT INTO Prenda (descripcion, talla, precio, id_tienda) VALUES 
('Camisa manga larga', 'M', 45000, 1),
('Jean azul', '32', 80000, 2);

INSERT INTO Venta (fecha, id_cliente, id_empleado) VALUES 
('2025-07-01', 1, 1),
('2025-07-02', 2, 2);

INSERT INTO Promocion (descripcion) VALUES 
('Descuento 20% en camisas'),
('Combo jean + camiseta');

INSERT INTO Proveedor (nombre) VALUES 
('Textiles S.A.'),
('RopaModa Ltda.');

INSERT INTO Venta_Prenda VALUES 
(1, 1),
(2, 2);

INSERT INTO Prenda_Proveedor VALUES 
(1, 1),
(2, 2);

UPDATE Prenda
SET precio = 85000
WHERE descripcion = 'Jean azul';

DELETE FROM Venta_Prenda
WHERE id_venta = 2 AND id_prenda = 2;

SELECT V.id_venta, C.nombre AS cliente, P.descripcion AS prenda
FROM Venta V
INNER JOIN Cliente C ON V.id_cliente = C.id_cliente
INNER JOIN Venta_Prenda VP ON V.id_venta = VP.id_venta
INNER JOIN Prenda P ON VP.id_prenda = P.id_prenda;

SELECT P.descripcion, VP.id_venta
FROM Prenda P
LEFT JOIN Venta_Prenda VP ON P.id_prenda = VP.id_prenda;

SELECT PR.nombre AS proveedor, PP.id_prenda
FROM Prenda_Proveedor PP
RIGHT JOIN Proveedor PR ON PP.id_proveedor = PR.id_proveedor;

SELECT nombre 
FROM Cliente
WHERE id_cliente = (
  SELECT id_cliente FROM Venta
  ORDER BY fecha DESC
  LIMIT 1
);

SELECT P.descripcion
FROM Prenda P
JOIN Venta_Prenda VP ON P.id_prenda = VP.id_prenda
WHERE VP.id_venta = (
  SELECT id_venta FROM Venta
  ORDER BY fecha DESC
  LIMIT 1
);
