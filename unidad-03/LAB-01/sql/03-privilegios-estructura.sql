--Nombre: Raquel Apodaca Caixba
--Laboratorio: LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
--Actividad: Actividad 6 — Cambios de privilegios y de estructura

--modificar privilegios y estructura
REVOKE UPDATE ON clientes FROM soporte_ana;
GRANT UPDATE ON clientes TO app_ventas;
ALTER TABLE clientes ADD COLUMN segmento VARCHAR(20);

--crear rol desechable con contraseña en la sentencia
CREATE ROLE rol_temporal LOGIN PASSWORD 'Temporal_Practica_2026';
--eliminar rol
DROP ROLE rol_temporal;

--consultar las sentencias registradas
SELECT linea FROM dba.bitacora WHERE linea LIKE '%statement:%' ORDER BY num;