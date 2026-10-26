--Laboratorio 04: Hardening y configuración segura de PostgreSQL
--Base de datos: db_20242123_raquel_apodaca

-- 1.Información del servidor
SELECT version();

-- 2.Configuración de red y autenticación
SHOW port;
SHOW listen_addresses;
SHOW password_encryption;

-- 3.Parámetros de seguridad y conexiones
SHOW ssl;
SHOW ssl_min_protocol_version;
SHOW max_connections;
SHOW superuser_reserved_connections;
SHOW statement_timeout;
SHOW idle_in_transaction_session_timeout;

-- 4.Reglas de acceso configuradas
SELECT
    type,
    database,
    user_name,
    address,
    auth_method
FROM pg_hba_file_rules;

-- 5.Roles y privilegios
SELECT
    rolname,
    rolsuper,
    rolcreaterole,
    rolcreatedb,
    rolcanlogin
FROM pg_roles
ORDER BY rolname;

-- 6.Extensiones instaladas
SELECT
    extname,
    extversion
FROM pg_extension
ORDER BY extname;

-- 7.Estado TLS de la conexión actual
SELECT
    pid,
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();