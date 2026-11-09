# LAB-01 — Bitácoras y auditoría del dato en PostgreSQL

## Descripción

Laboratorio de la Unidad III, enfocado en la configuración de bitácoras, auditoría de eventos y trazabilidad de modificaciones realizadas en una base de datos PostgreSQL.

El objetivo es identificar quién realizó una operación, cuándo ocurrió, qué sentencia se ejecutó y qué valores tenía un registro antes y después de una modificación.

## Entorno de trabajo

- **Sistema gestor de bases de datos:** PostgreSQL 17.11.
- **Puerto de conexión:** 5433.
- **Base de datos:** `comercial`.
- **Usuario administrador:** `postgres`.

## Despliegue del servidor

El laboratorio se realizó mediante una instalación local de PostgreSQL. Se utilizó el servicio correspondiente a PostgreSQL 17, configurado para escuchar en el puerto 5433.

Se trabajó con la base de datos `comercial` y los roles `postgres`, `app_ventas` y `soporte_ana`, utilizados para comprobar los permisos, accesos y operaciones de auditoría.

No se utilizó Docker ni una máquina virtual para desplegar el servidor.

Para conectarse a la base de datos desde una terminal, se utilizó:

```
psql -h localhost -p 5433 -U postgres -d comercial
```

Para comprobar la versión y los datos de conexión:

```
SELECT version();

SELECT current_database(), current_user, inet_server_port();

SHOW data_directory;

SHOW config_file;
```

## Configuración de bitácoras y auditoría

Durante el laboratorio se revisó la configuración inicial del servidor y posteriormente se modificaron los parámetros de registro mediante `ALTER SYSTEM`.

Entre los parámetros trabajados se encuentran:

- `logging_collector`
- `log_connections`
- `log_disconnections`
- `log_line_prefix`
- `log_statement`

También se creó una vista para consultar las líneas de la bitácora y se implementó un mecanismo de auditoría a nivel de dato mediante un esquema, una tabla, una función y un disparador.

## Evidencias

En la carpeta `evidencias` se encuentran los resultados e interpretaciones de las actividades realizadas, así como la bitácora exportada y su correspondiente hash SHA-256 para comprobar su integridad.

## Consideraciones

- Las contraseñas utilizadas durante las pruebas no deben incluirse en los archivos del repositorio.
- La bitácora debe revisarse antes de compartirla, debido a que puede contener información sensible.
- No se deben publicar volcados completos de la tabla de auditoría si contienen datos personales.
- El servidor y la base de datos se conservan para continuar con las siguientes prácticas de la unidad.
