--Laboratorio 04: Hardening y configuración segura de PostgreSQL
--Base de datos: db_20242123_raquel_apodaca
--Actividad 8: Revisar usuarios y privilegios

--Roles existentes y atributos administrativos
SELECT
    rolname,
    rolsuper,--si el rol es superusuario
    rolinherit,--si hereda privilegios de otros roles
    rolcreaterole,--si puede crear, modificar o administrar roles según sus privilegios
    rolcreatedb,--si puede crear bases de datos
    rolcanlogin--si puede iniciar sesión
FROM pg_roles
ORDER BY rolname;

--Actividad 9: Separar cuentas administrativas y de aplicación
--Revision de cuentas con inicio de sesion
SELECT
    rolname,
    rolsuper,
    rolcreatedb,
    rolcreaterole,
    rolcanlogin
FROM pg_roles
WHERE rolcanlogin = TRUE
ORDER BY rolname;