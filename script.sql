CREATE DATABASE tienda_ropa;
USE tienda_ropa;

CREATE TABLE clientes(
id_cliente INT PRIMARY KEY,
nombre VARCHAR (50), 
apellido VARCHAR (50), 
direccion VARCHAR(150), 
correo_electronico VARCHAR(100),
telefono VARCHAR(20)
);

CREATE TABLE productos(
id_producto INT PRIMARY KEY,
nombre VARCHAR(100),
descripcion VARCHAR(255),
precio DECIMAL(10,2), 
categoria VARCHAR(50),
stock INT
);

CREATE TABLE pedidos(
id_pedido INT PRIMARY KEY,
id_cliente INT,
fecha DATE,
estado VARCHAR(30),
total DECIMAL(10,2),
FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE ventas(
id_venta INT PRIMARY KEY,
id_pedido INT,
id_producto INT,
cantidad INT,
precio_venta DECIMAL(10,2),
FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO clientes(id_cliente, nombre, apellido, direccion, correo_electronico, telefono)
VALUES (1,'ana','perez','santa rosa','ana567@gmail.com','0230-233-5123'),
	   (2,'brayan','perdomo','el cuji','elbrayan123@ejemplo.com','1241-856-3466'),
       (3,'samuel','asuaje','villa del sol','asuaje777@gmail.com','9984-623-9172'),
       (4,'karly','torrez','carorita','torrez532@gmail.com','5235-977-3792');

INSERT INTO productos (id_producto, nombre, descripcion, precio, categoria, stock)
VALUES (1, 'Camiseta básica', 'Camiseta de algodón manga corta', 15.50, 'Camisetas', 40),
	   (2,'pantalon jeans','Pantalon ancho gris',20.02,'Pantalones',10),
       (3,'Zapato','Zapatos Nike',30.05,'Zapatos',15),
       (4,'Camiseta vestir','Camiseta manga larga',15.60,'Camisetas',35),
       (5,'Chaqueta','Chaqueta cuerina',30.20,'Chaquetas',10);
       
INSERT INTO pedidos (id_pedido, id_cliente, fecha, estado, total)
VALUES (1, 1, '2026-10-20', 'Entregado', 46.50),
	   (2,3,'2026-02-19','Entregado',50.20),
       (3,3,'2026-10-25','Pendiente',90.02),
       (4,2,'2026-09-12','Entregado',46.64),
       (5,3,'2026-10-15','Enviado',50.32),
       (6,4,'2026-10-19','Pendiente',60.32);

INSERT INTO ventas (id_venta, id_pedido, id_producto, cantidad, precio_venta)
VALUES (1, 1, 1, 2, 15.50),
	   (2, 3, 5, 3, 30.20),
       (3, 2, 1, 2, 15.50),
       (4, 1, 2, 6, 20.02),
       (5, 4, 3, 4, 30.05),
       (6, 5, 5, 2, 30.20),
       (7, 2, 1, 1, 15.50),
       (8, 1, 4, 2, 15.60);

-- Consulta 1: clientes con pedidos en los últimos 30 días
SELECT DISTINCT CONCAT (nombre,' ', apellido) AS nombre_completo, direccion, correo_electronico
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente 
WHERE fecha >= CURDATE() - INTERVAL 30 DAY;

-- Consulta 2: productos más vendidos del último mes
SELECT productos.nombre, SUM(ventas.cantidad) AS total_vendido
FROM ventas
JOIN productos ON ventas.id_producto = productos.id_producto
JOIN pedidos ON ventas.id_pedido = pedidos.id_pedido
WHERE pedidos.fecha >= CURDATE() - INTERVAL 1 MONTH
GROUP BY productos.nombre
ORDER BY total_vendido DESC;

-- Consulta 3: clientes con más pedidos en el último año
SELECT CONCAT(clientes.nombre, ' ', clientes.apellido) AS nombre_completo, COUNT(pedidos.id_pedido) AS total_pedidos
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente
WHERE pedidos.fecha >= CURDATE() - INTERVAL 1 YEAR
GROUP BY clientes.id_cliente, nombre_completo
ORDER BY total_pedidos DESC;

UPDATE productos SET precio = precio * 1.10 WHERE categoria = 'Camisetas' AND id_producto > 0;

SELECT * FROM productos;

-- Eliminación 2: eliminar pedidos sin ventas
-- Se desactiva temporalmente el modo seguro de Workbench (SQL_SAFE_UPDATES)
-- porque el DELETE usa una subconsulta y el modo seguro lo bloquea (error 1175)
SET SQL_SAFE_UPDATES = 0;
DELETE FROM pedidos
WHERE id_pedido NOT IN (SELECT id_pedido FROM ventas);
-- Se vuelve a activar el modo seguro
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM pedidos;

-- Vista 1: vista_clientes_pedidos
CREATE VIEW vista_clientes_pedidos AS
SELECT CONCAT(clientes.nombre, ' ', clientes.apellido) AS nombre_completo, pedidos.fecha, pedidos.total
FROM clientes
JOIN pedidos ON clientes.id_cliente = pedidos.id_cliente;

SELECT * FROM vista_clientes_pedidos;
