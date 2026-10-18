--Laboratorio 01: Protección y privacidad de datos
--Base de datos: db_20242123_raquel_apodaca
--Objetivo: Crear tabla de clientes que permita llevar a cabo
--pruebas de clasificación, enmascaramiento, tokenización y control de acceso

--Crear tabla de clientes
CREATE TABLE clientes (
	--Identificador unico generado automaticamente
    id BIGSERIAL PRIMARY KEY,
	--Nombre del cliente, dato identificable
    nombre VARCHAR(120) NOT NULL,
	--Correo electronico, dato identificable
    correo VARCHAR(150) NOT NULL,
	--Telefono de contacto, dato identificable
    telefono VARCHAR(20),
	--Rfc del cliente, dato identificable
    rfc VARCHAR(13),
	--Edad, dato cuasi-identificador
    edad INTEGER,
	--Ciudad de residencia, dato cuasi-identificador
    ciudad VARCHAR(80),
	--Codigo postal asociado al domicilio, dato cuasi-identificador
    codigo_postal VARCHAR(10),
	--Fecha en que se dio de alta al cliente, dato administrativo
    fecha_alta DATE DEFAULT CURRENT_DATE
);

--Datos para probar las consultas y los mecanismos de proteccionde la informacion
INSERT INTO clientes
(nombre, correo, telefono, rfc, edad, ciudad, codigo_postal)
VALUES
('Ana López',
 'ana.lopez@example.test',
 '6671234567',
 'LOAA850315ABC',
 41,
 'Culiacán',
 '80000'),

('Carlos Pérez',
 'carlos.perez@example.test',
 '6672345678',
 'PECA900720DEF',
 35,
 'Culiacán',
 '80100'),

('María García',
 'maria.garcia@example.test',
 '6673456789',
 'GAMA780912GHI',
 47,
 'Mazatlán',
 '82000'),

('Luis Torres',
 'luis.torres@example.test',
 '6674567890',
 'TOLU920201JKL',
 34,
 'Los Mochis',
 '81200'),

('Laura Sánchez',
 'laura.sanchez@example.test',
 '6675678901',
 'SALA880525MNO',
 38,
 'Culiacán',
 '80200');

--Mostrar todos los clientes registrados
--Verificar que los datos se inserten correctamente
SELECT *
FROM clientes;