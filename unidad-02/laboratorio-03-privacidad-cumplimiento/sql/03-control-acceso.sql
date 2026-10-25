--Laboratorio 03: Privacidad, cumplimiento y gobierno de los datos
--Base de datos: db_20242123_raquel_apodaca
--Control de acceso relacionado con la finalidad
--Objetivo: Crear un rol que pueda consultar la información preparada para
--analítica, pero que no tenga acceso directo a la tabla completa de clientes

--Crea el rol analista
CREATE ROLE analista NOLOGIN;

--Crear vista para analitica
CREATE VIEW v_analitica_clientes AS
SELECT
    ciudad,
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad
FROM clientes;

--Otorgar permisos
--Permite al rol acceder a los objetos del esquema public
GRANT USAGE ON SCHEMA public TO analista;
--Permite consultar la vista
GRANT SELECT
ON v_analitica_clientes
TO analista;

--Verificar los privilegios
SELECT
    grantee,
    table_name,
    privilege_type
FROM information_schema.role_table_grants
WHERE grantee = 'analista';
