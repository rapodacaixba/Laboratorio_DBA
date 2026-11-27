# LAB-03 — Políticas prácticas, gobierno de datos y evidencias

**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** III — Auditoría, trazabilidad y gobierno práctico de datos  
**Organización del escenario:** Comercializadora Norte S.A. de C.V.

## 1. Descripción

Este laboratorio integra los mecanismos de auditoría desarrollados en LAB-01 y LAB-02 con elementos de gobierno práctico de datos. Incluye verificaciones de calidad, responsables, catálogo, diccionario, conservación de bitácoras, políticas y conciliación de cambios.

El resultado principal es un expediente de auditoría interna que reúne las evidencias técnicas y documentales de los dos motores de bases de datos.

## 2. Entorno de trabajo

| Componente | Versión o configuración |
|---|---|
| Sistema operativo | Windows |
| Motor principal | PostgreSQL 17.11 |
| Base de datos PostgreSQL | comercial |
| Usuario administrador PostgreSQL | postgres |
| Puerto PostgreSQL | 5433 |
| Directorio de datos PostgreSQL | C:/Program Files/PostgreSQL/17/data |
| Servicio de Windows | postgresql-x64-17 |
| Motor complementario | MongoDB 7.0.48 |
| Contenedor MongoDB | dba-u3-mongo |
| Base de datos MongoDB | comercial |
| Colección principal | clientes |
| Herramienta de consola MongoDB | mongosh 2.14.2 |

## 3. Despliegue de PostgreSQL

Se utilizó la instalación local de PostgreSQL 17 en Windows, conservando el servidor configurado en los laboratorios anteriores.

El servicio de Windows utilizado es postgresql-x64-17. El servidor trabaja en el puerto 5433 y contiene la base de datos comercial, donde se encuentran los objetos creados durante LAB-01 y LAB-03.

**Datos de conexión:**

- Host: localhost
- Puerto: 5433
- Base de datos: comercial
- Usuario: postgres

Para conectarse desde PowerShell o una terminal que tenga disponible psql:

psql -U postgres -p 5433 -d comercial

Para comprobar la versión del servidor:

SELECT version();


La versión utilizada es PostgreSQL 17.11, compilada para Windows de 64 bits.

## 4. Despliegue de MongoDB

Se reutilizó el entorno preparado en LAB-02 mediante Docker Desktop en Windows.

El contenedor utilizado es dba-u3-mongo, con MongoDB 7.0.48. La base de datos de trabajo es comercial y la colección principal utilizada para las actividades de trazabilidad es clientes.

La herramienta de consola utilizada es mongosh 2.14.2.

Se reutilizaron los archivos y resultados de LAB-02 relacionados con el perfilador, la bitácora de mongod, las instantáneas de privilegios y la comparación de mecanismos de auditoría.

## 5. Verificación del entorno

Para verificar la conexión de PostgreSQL:

SELECT current_database(), current_user, inet_server_port();

El resultado esperado en este entorno identifica:

- Base de datos: comercial
- Usuario: postgres
- Puerto: 5433

Para comprobar la versión:

SELECT version();

Para verificar los esquemas utilizados por el laboratorio:

\dn

Los esquemas relevantes son public, auditoria, dba y, después de la Actividad 7, gobierno.


## 6. Consideraciones

- Se reutilizó el servidor PostgreSQL instalado para LAB-01; no se realizó una instalación nueva para LAB-03.
- Se utilizó PostgreSQL 17.11 en lugar de PostgreSQL 16, conservando las sentencias SQL de la guía y adaptando únicamente el puerto de conexión.
- MongoDB se reutilizó del entorno preparado en LAB-02.
- Las evidencias deben corresponder a los resultados reales obtenidos durante las actividades.
- Las bitácoras deben revisarse para evitar divulgar contraseñas, secretos o datos personales.
- Los periodos de conservación documentados son propuestas académicas y no sustituyen la validación de obligaciones legales.

## 8. Resultado

El laboratorio integra los resultados de PostgreSQL y MongoDB en un expediente de auditoría interna. Se documentan los responsables de los datos, la calidad de la información, los mecanismos de auditoría, las políticas prácticas y la conciliación de cambios.

El expediente permite identificar los controles existentes, las evidencias disponibles y las limitaciones que requieren seguimiento.
