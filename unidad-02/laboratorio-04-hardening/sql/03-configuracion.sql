--Laboratorio 04: Hardening y configuración segura de PostgreSQL
--Base de datos: db_20242123_raquel_apodaca
--Actividad 2: Identificar los archivos de configuración
--rutas de los archivos de configuracion
SHOW config_file;
SHOW hba_file;
SHOW ident_file;

SHOW data_directory;--ubicacion de los datos
--configuracion relacionada con los registros
SHOW log_directory;
SHOW log_connections;
SHOW log_disconnections;

--Actividad 4: Revisar pg_hba.conf
--Consultar las reglas configuradas
SELECT
    type,--tipo de conexion
    database,--db a la que aplica la regla
    user_name,--usuarios a los que aplica
    address,--direccion de origen permitida
    auth_method--metodo de autenticacion configurado
FROM pg_hba_file_rules;

-- Actividad 10: Revisar extensiones
SELECT
    extname,
    extversion
FROM pg_extension
ORDER BY extname;

--Actividad 11: Revisar configuración relacionada con conexiones

SHOW max_connections;--máximo de conexiones simultáneas permitidas al servidor
SHOW superuser_reserved_connections;--reserva un número de conexiones para que superusuarios puedan acceder
SHOW statement_timeout;--define el tiempo máximo permitido para ejecutar una sentencia sql
SHOW idle_in_transaction_session_timeout;--define cuánto tiempo puede permanecer inactiva una sesión

--Actividad 12: Revisar permisos del sistema operativo
SHOW data_directory;--directorio donde PostgreSQL almacena los datos
SHOW config_file;--ruta del archivo principal de configuración
SHOW hba_file;--ruta del archivo que contiene las reglas de autenticación

--Actividad 15: Revisar TLS
--consultar la configuracion
SHOW ssl;
SHOW ssl_min_protocol_version;

--consultar la conexión actual
SELECT
    pid,
    usename,
    client_addr,
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();