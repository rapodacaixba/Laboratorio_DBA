--Laboratorio 04: Hardening y configuración segura de PostgreSQL
--Base de datos: db_20242123_raquel_apodaca
--Actividad 1: Identificar la superficie de ataque

--Version del servidor
SELECT version();

SHOW port;--puerto configurado
SHOW listen_addresses;--interfaces en las que escucha postgreSQL
SHOW ssl;--si ssl/tls esta habilitado
SHOW password_encryption;--mecanismo configurado para las nuevas contraseñas

--Muestra información sobre las conexiones
SELECT
    pid,
    usename,
    datname,
    client_addr,
    client_port,
    application_name
FROM pg_stat_activity;--sesiones, usuarios, bd y direcciones de conexion

--Actividad 3: Revisar listen_addresses
SHOW listen_addresses;
