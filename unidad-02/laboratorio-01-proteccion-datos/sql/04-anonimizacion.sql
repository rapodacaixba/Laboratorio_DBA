--Laboratorio 01: Protección y privacidad de datos
--Anonimización
--Objetivo: Obtener estadisticas generales de los clientes sin mostrar sus datos individuales

--Agrupar las edades en intervalos para evitar mostrar la edad individual de cada cliente
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

--Generalizar region
SELECT
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1;

--Combinar dos caracteristicas de los clientes: edad y region
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,

    LEFT(codigo_postal, 2) AS region,

    COUNT(*) AS total

FROM clientes

GROUP BY 1, 2;

--Suprimir grupos pequeños conservando la agrupacion por edad y region
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 30 THEN '18-30'
        WHEN edad BETWEEN 31 AND 45 THEN '31-45'
        ELSE '46+'
    END AS rango_edad,
    LEFT(codigo_postal, 2) AS region,
    COUNT(*) AS total
FROM clientes
GROUP BY 1, 2
HAVING COUNT(*) >= 5;


--Reto: reducir el riesgo de reidentificacion
--El cambio es la utilizacion de edades mas amplias y eliminacion
--de region como criterio de agrupacion
SELECT
    CASE
        WHEN edad BETWEEN 18 AND 45 THEN '18-45'
        ELSE '46+'
    END AS rango_edad,
    COUNT(*) AS total
FROM clientes
GROUP BY 1
HAVING COUNT(*) >= 5;