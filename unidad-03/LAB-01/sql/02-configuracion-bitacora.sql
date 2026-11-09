--Nombre: Raquel Apodaca Caixba
--Laboratorio: LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
--Actividad: Actividad 4 — Configurar la bitácora


--configurar los parametros
ALTER SYSTEM SET log_connections = on;
ALTER SYSTEM SET log_disconnections = on;
ALTER SYSTEM SET log_line_prefix = '%m [%p] user=%u db=%d app=%a client=%h ';
ALTER SYSTEM SET log_statement = 'ddl';
SELECT pg_reload_conf();

--verificar los cambios
SELECT name, setting, source, sourcefile
FROM pg_settings
WHERE name IN ('log_connections', 'log_line_prefix', 'log_statement');

--revisar las ultimas lineas de la botacora
SELECT num, linea FROM dba.bitacora ORDER BY num DESC LIMIT 6;