--Laboratorio 02: Cifrado, credenciales y comunicaciones seguras
--Base de datos: db_20242123_raquel_apodaca
--Cifrado de datos
--Objetivo: Crear escenario para mostrar como proteger un dato para
--su posterior recuperacion

--Crear tabla de demostracion
CREATE TABLE clientes_protegidos (
    id BIGSERIAL PRIMARY KEY,
    nombre VARCHAR(120) NOT NULL,
    rfc_cifrado BYTEA NOT NULL
);

--Insertar registro cifrado
INSERT INTO clientes_protegidos (
    nombre,
    rfc_cifrado
)
VALUES (
    'Ana López',
    pgp_sym_encrypt('LOPA900101ABC', 'CLAVE-DE-PRUEBA')
);

--Consultar tabla
SELECT *
FROM clientes_protegidos;

--Recuperar el dato
SELECT
    id,
    nombre,
    pgp_sym_decrypt(
        rfc_cifrado,
        'CLAVE-DE-PRUEBA'
    ) AS rfc
FROM clientes_protegidos;