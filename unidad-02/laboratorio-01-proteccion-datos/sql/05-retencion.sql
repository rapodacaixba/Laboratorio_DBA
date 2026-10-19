--Laboratorio 01: Protección y privacidad de datos
--Retención de datos
--Objetivo: Identificar los registros que hipoteticamente superan el
--periodo de conservacion de 5 años

--Consulta de identificacion de clientes con fecha de alta anterior a 5 años
SELECT *
FROM clientes
WHERE fecha_alta <
      CURRENT_DATE - INTERVAL '5 years';