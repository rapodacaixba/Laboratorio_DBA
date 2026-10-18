--Laboratorio 01: Protección y privacidad de datos
--Enmascaramiento
--Objetivo: Crear un rol que permita controlar los permisos
--de acceso a la informacion de los clientes

--Impide que el rol se use directamente para iniciar sesion, es para administrar permisos
CREATE ROLE soporte NOLOGIN;

--Mostrar informacion con ciertos datos personales enmascarados
CREATE VIEW v_clientes_soporte AS
SELECT
    id,
    nombre,

    CONCAT(
        LEFT(correo, 2),
        '*****',
        SUBSTRING(correo FROM POSITION('@' IN correo))
    ) AS correo,

    CONCAT(
        '******',
        RIGHT(telefono, 4)
    ) AS telefono,

    CONCAT(
        '*********',
        RIGHT(rfc, 4)
    ) AS rfc

FROM clientes;

--Consultar los datos que presenta la vista enmascarada
SELECT *
FROM v_clientes_soporte;

--Permite al rol soporte utilizar el esquema public
GRANT USAGE
ON SCHEMA public
TO soporte;

--Permite al rol soporte consultar la vista v_clientes_soporte
GRANT SELECT
ON v_clientes_soporte
TO soporte;

--Revoca los permisos directos del rol soporte
--sobre la tabla clientes
REVOKE ALL
ON clientes
FROM soporte;


--Consultar los permisos registrados para el rol soporte
SELECT
    grantee,
    table_schema,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'soporte'
  AND table_schema = 'public'
  AND table_name IN ('v_clientes_soporte', 'clientes')
ORDER BY table_name, privilege_type;

--Consultar la vista de acceso restringido
SELECT *
FROM v_clientes_soporte;

--Cambiar temporalmente al rol soporte para comprobar sus permisos
SET ROLE soporte;
--Consulta para intentar consultar directamente la tabla original
SELECT *
FROM clientes;


--Regresar al usuario con el que se inició la sesión
RESET ROLE;
