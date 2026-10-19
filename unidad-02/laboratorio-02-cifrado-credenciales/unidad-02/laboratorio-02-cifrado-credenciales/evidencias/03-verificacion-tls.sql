--Laboratorio 02: Cifrado, credenciales y comunicaciones seguras
--Base de datos: db_20242123_raquel_apodaca
--Verificacion del estado de TLS en PostgreSQL

--Consultar si TLS esta habilitado en el servidor
SHOW ssl;

--Consultar la version minima de protocolo
SHOW ssl_min_protocol_version;

--Consultar el puerto
SHOW port;

--Consultar las direcciones de escucha
SHOW listen_addresses;

--Consultar la direccion del cliente
SELECT
    inet_client_addr(),--devuelve direccion IP del cliente
    inet_client_port();--devuelve el puerto de origen de la conexion del cliente

--Comprobar si la sesión utiliza TLS
SELECT
    ssl,
    version,
    cipher
FROM pg_stat_ssl
WHERE pid = pg_backend_pid();