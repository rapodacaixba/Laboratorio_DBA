--Laboratorio 03: Privacidad, cumplimiento y gobierno de los datos
--Base de datos: db_20242123_raquel_apodaca
--Principio de minimización
--Objetivo: Crea una tabla que contenga únicamente los datos necesarios
--para la finalidad de soporte


--Crear nueva tabla por la solicitud del área de atención al cliente
CREATE TABLE clientes_soporte (
    id BIGSERIAL,
    nombre VARCHAR(120),
    correo VARCHAR(150),
    telefono VARCHAR(20),
    rfc VARCHAR(13),
    edad INTEGER,
    ciudad VARCHAR(80),
    codigo_postal VARCHAR(10),
    fecha_alta DATE
); --No se ejecuto: solo es para la simulacion y analización de la actividad 2

--Crear tabla con datos necesarios para soporte
CREATE TABLE clientes_soporte (
    id BIGINT PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    telefono VARCHAR(20)
);

--Carga informacion a partir de clientes
INSERT INTO clientes_soporte (
    id,
    nombre,
    correo,
    telefono
)
SELECT
    id,
    nombre,
    correo,
    telefono
FROM clientes;

--Consulta los registros de la nueva tabla
SELECT *
FROM clientes_soporte;
