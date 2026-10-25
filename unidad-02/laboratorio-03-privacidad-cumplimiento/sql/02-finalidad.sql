--Laboratorio 03: Privacidad, cumplimiento y gobierno de los datos
--Base de datos: db_20242123_raquel_apodaca
--Separacion por finalidad
--Objetivo: Preparación de consultas para generar estadísticas sin entregar
--directamente los datos identificativos de cada cliente

--Consulta que proporciona informacion agregada
SELECT
    ciudad,
    COUNT(*) AS cantidad_clientes
FROM clientes
GROUP BY ciudad
ORDER BY cantidad_clientes DESC;

--Crea rangos de edad
SELECT
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END AS rango_edad,
    COUNT(*) AS cantidad
FROM clientes
GROUP BY
    CASE
        WHEN edad < 18 THEN 'Menor de 18'
        WHEN edad BETWEEN 18 AND 29 THEN '18-29'
        WHEN edad BETWEEN 30 AND 44 THEN '30-44'
        WHEN edad BETWEEN 45 AND 59 THEN '45-59'
        ELSE '60 o más'
    END
ORDER BY rango_edad;