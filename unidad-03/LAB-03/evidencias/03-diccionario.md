**Actividad 3 — Diccionario de datos operativo dentro del motor**

En esta actividad documenté la tabla y las columnas de clientes usando COMMENT, consulté information\_schema.columns junto con col\_description y exporté el diccionario a CSV. Además, complementé el diccionario con información de gobierno que el motor no conoce por sí solo.

| Columna | Clasificación(Unidad II) | Finalidad | Control aplicado | ¿Cambios auditados? | Regla de calidad |
| :---- | :---- | :---- | :---- | :---- | :---- |
| rfc | Dato personal | Facturación | Vista enmascarada para soporte (U2) | Sí, LAB-01 Parte B | Formato RFC |
| correo | Dato personal | Contacto y notificación al cliente | Acceso restringido, protección de credenciales y registro de accesos relevantes | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Obligatorio (NOT NULL), longitud máxima de 150 caracteres y formato de correo electrónico |
| nombre | Dato personal (identificador directo) | Identificación y atención del cliente | Control de acceso por roles y permisos mínimos | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Obligatorio (NOT NULL) y longitud máxima de 120 caracteres |
| telefono | Dato personal  | Contacto y atención al cliente  | Permisos por rol y acceso limitado  | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Longitud máxima de 20 caracteres (varchar(20)) y formato telefónico válido cuando no es nulo |
| edad | Dato personal  | Estadísticas y segmentación justificada  | Uso de rangos de edad y acceso restringido a datos individuales  | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Entero (integer) dentro de un rango de edad válido cuando no es nulo |
| ciudad | Dato personal/ ubicación | Estadísticas geográficas y atención cuando se requiera  | Vistas específicas y permisos por finalidad  | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Longitud máxima de 80 caracteres (varchar(80)) y texto no vacío cuando no es nulo |
| codigo\_postal | Dato de ubicacion | Ubicación geográfica para procesos justificados  | Acceso restringido y uso de regiones o prefijos cuando sea suficiente  | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Longitud máxima de 10 caracteres (varchar(10)) y formato de código postal válido cuando no es nulo |
| fecha\_alta | Dato operativo / temporal  | Registro de alta del cliente en el sistema  | Valor por omisión (CURRENT\_DATE) y control de escritura por aplicación | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Fecha válida (date), no posterior a la fecha actual y con valor por omisión CURRENT\_DATE |
| segmento | Dato comercial / clasificación  | Clasificación comercial del cliente  | Permisos por rol según proceso comercial  | No en auditoria.cambios\_clientes (registrado en bitácora / log\_statement \= mod) | Longitud máxima de 20 caracteres (varchar(20)) y valor dentro del catálogo de segmentos permitido |

1. ¿Qué ventaja tiene guardar el significado en COMMENT en lugar de solo en un documento aparte?

Mantiene la documentación pegada a la estructura real de la base de datos evitando que un archivo externo quede desactualizado cuando cambia el esquema.

2. ¿Quedaron registrados los COMMENT en la bitácora? ¿Con qué nivel de log\_statement?

Sí, al ser cambios de metadatos/DDL quedan registrados en el servidor con log\_statement \= mod que registra sentencias de modificación de datos y comandos DDL/administración, a diferencia de ddl que excluye INSERT/UPDATE/DELETE.

3. ¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?

Las reglas de negocio, propietarios, políticas de eliminación y criterios transversales entre sistemas, un COMMENT es texto libre ligado a un objeto y no sustituye acuerdos organizacionales ni políticas que abarcan varios motores.