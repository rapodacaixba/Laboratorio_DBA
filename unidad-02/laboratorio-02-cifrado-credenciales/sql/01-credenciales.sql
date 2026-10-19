--Laboratorio 02: Cifrado, credenciales y comunicaciones seguras
--Base de datos: db_20242123_raquel_apodaca
--Proteccion de credenciales
--Objetivo: Crear tabla de clientes que permita llevar a cabo
--pruebas de clasificación, enmascaramiento, tokenización y control de acceso

--Crear una tabla insegura
CREATE TABLE usuarios_insegura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL,
	--Almacena la contraseña directamente
    password VARCHAR(100) NOT NULL
);

--Insercion de usuario de prueba
INSERT INTO usuarios_insegura (usuario, password)
VALUES ('juan', 'Password123');

--Consulta de datos 
SELECT *
FROM usuarios_insegura;

--Generar representacion no reversible
SELECT crypt(
    'Password123',
    gen_salt('bf')
);

--Crear la tabla de credenciales protegidas
CREATE TABLE usuarios_segura (
    id BIGSERIAL PRIMARY KEY,
    usuario VARCHAR(50) UNIQUE NOT NULL,
    password_hash TEXT NOT NULL
);

--Insertar usuario
INSERT INTO usuarios_segura (usuario, password_hash)
VALUES (
    'juan',
    crypt('Password123', gen_salt('bf'))
);

--Consultar contenido
SELECT *
FROM usuarios_segura;

--Verificar contraseña correcta
SELECT
    usuario,
    password_hash = crypt('Password123', password_hash)
        AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';

--Contraseña incorrecta
SELECT
    usuario,
    password_hash = crypt('OtraPassword', password_hash)
        AS contraseña_correcta
FROM usuarios_segura
WHERE usuario = 'juan';