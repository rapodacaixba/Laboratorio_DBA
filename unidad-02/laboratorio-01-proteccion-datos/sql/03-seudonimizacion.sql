--Laboratorio 01: Protección y privacidad de datos
--Seudonimizacion
--Objetivo: Crear identificadores sustitutos llamados tokens para analizar informacion 
--de los clientes sin incluir directamente datos identificadores

--Almacenara la tabla que relaciona los tokens con los identificadores originales
CREATE SCHEMA pii;

--Almacenara los datos que se usaran para realizar analisis
CREATE SCHEMA analitica;

--Crear la tabla de correspondencia
CREATE TABLE pii.mapa_cliente (
    token UUID PRIMARY KEY,
    cliente_id BIGINT UNIQUE
        REFERENCES public.clientes(id)
);

--Habilitar pgcrypto
CREATE EXTENSION IF NOT EXISTS pgcrypto;

--Generar un token para cada cliente
INSERT INTO pii.mapa_cliente
(token, cliente_id)
SELECT
    gen_random_uuid(),
    id
FROM clientes;

--Consulta para verificar que se generaron los tokens para cada cliente
SELECT *
FROM pii.mapa_cliente;

--Crear el conjunto de datos para analitica
CREATE TABLE analitica.clientes AS
SELECT
    m.token AS cliente_token,
    c.edad,
    c.ciudad,
    c.codigo_postal,
    c.fecha_alta
FROM pii.mapa_cliente m
JOIN clientes c
    ON c.id = m.cliente_id;

--Consulta para verificar el resultado
SELECT *
FROM analitica.clientes;