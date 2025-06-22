DROP DATABASE IF EXISTS motos;
CREATE DATABASE motos;
USE motos;

CREATE TABLE Sucursal (
  id_sucursal INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL
);

CREATE TABLE Moto (
  id_moto INT AUTO_INCREMENT PRIMARY KEY,
  modelo VARCHAR(100) NOT NULL,
  marca VARCHAR(100) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  id_sucursal INT,
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Vendedor (
  id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_sucursal INT,
  FOREIGN KEY (id_sucursal) REFERENCES Sucursal(id_sucursal)
);

CREATE TABLE Cliente (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  direccion VARCHAR(150) NOT NULL
);

CREATE TABLE Venta (
  id_venta INT AUTO_INCREMENT PRIMARY KEY,
  fecha DATE NOT NULL,
  id_moto INT,
  id_cliente INT,
  id_vendedor INT,
  FOREIGN KEY (id_moto) REFERENCES Moto(id_moto),
  FOREIGN KEY (id_cliente) REFERENCES Cliente(id_cliente),
  FOREIGN KEY (id_vendedor) REFERENCES Vendedor(id_vendedor)
);

CREATE TABLE Financiera (
  id_financiera INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL
);

CREATE TABLE Garantia (
  id_garantia INT AUTO_INCREMENT PRIMARY KEY,
  descripcion VARCHAR(150) NOT NULL
);

CREATE TABLE Venta_Financiera (
  id_venta INT,
  id_financiera INT,
  PRIMARY KEY (id_venta, id_financiera),
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
  FOREIGN KEY (id_financiera) REFERENCES Financiera(id_financiera)
);

CREATE TABLE Venta_Garantia (
  id_venta INT,
  id_garantia INT,
  PRIMARY KEY (id_venta, id_garantia),
  FOREIGN KEY (id_venta) REFERENCES Venta(id_venta),
  FOREIGN KEY (id_garantia) REFERENCES Garantia(id_garantia)
);

INSERT INTO Sucursal (nombre, direccion) VALUES 
('Sucursal Norte', 'Calle 100 #50-20'),
('Sucursal Sur', 'Av. 30 #10-15');

INSERT INTO Moto (modelo, marca, precio, id_sucursal) VALUES 
('X100', 'Yamaha', 15000.00, 1),
('Z200', 'Honda', 20000.00, 2);

INSERT INTO Vendedor (nombre, id_sucursal) VALUES 
('Carlos Ruiz', 1),
('Ana Torres', 2);

INSERT INTO Cliente (nombre, direccion) VALUES 
('Pedro Pérez', 'Cra 50 #20-10'),
('Laura Gómez', 'Cll 60 #15-30');

INSERT INTO Venta (fecha, id_moto, id_cliente, id_vendedor) VALUES 
('2025-07-01', 1, 1, 1),
('2025-07-02', 2, 2, 2);

INSERT INTO Financiera (nombre) VALUES 
('Banco A'),
('Banco B');

INSERT INTO Garantia (descripcion) VALUES 
('2 años cobertura total'),
('1 año motor');

INSERT INTO Venta_Financiera VALUES 
(1, 1),
(2, 2);

INSERT INTO Venta_Garantia VALUES 
(1, 1),
(2, 2);

UPDATE Moto
SET precio = 21000.00
WHERE id_moto = 2;

DELETE FROM Venta_Garantia
WHERE id_venta = 2 AND id_garantia = 2;

SELECT V.id_venta, C.nombre AS cliente, M.modelo AS moto
FROM Venta V
INNER JOIN Cliente C ON V.id_cliente = C.id_cliente
INNER JOIN Moto M ON V.id_moto = M.id_moto;

SELECT M.modelo, S.nombre AS sucursal
FROM Moto M
LEFT JOIN Sucursal S ON M.id_sucursal = S.id_sucursal;

SELECT F.nombre AS financiera, VF.id_venta
FROM Venta_Financiera VF
RIGHT JOIN Financiera F ON VF.id_financiera = F.id_financiera;

SELECT nombre 
FROM Cliente
WHERE id_cliente = (
  SELECT id_cliente FROM Venta
  ORDER BY fecha DESC
  LIMIT 1
);

SELECT modelo
FROM Moto
WHERE id_moto = (
  SELECT id_moto FROM Venta
  ORDER BY (SELECT precio FROM Moto WHERE id_moto = Venta.id_moto) DESC
  LIMIT 1
);
