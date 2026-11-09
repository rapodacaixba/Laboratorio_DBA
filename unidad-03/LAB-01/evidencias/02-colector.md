**Actividad 2 — Que el servidor administre su propia bitácora**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad configure y automatice la lectura de la bitácora interna de postgresql, se omitio la reactivación de logging\_collector debido a que ya se encontraba activo, también se consultó la ruta del archivo de registro en ejecución utilizando la función pg\_current\_logfile(), la cual devolvió la ubicación dentro del directorio de datos del servidor y se leyó el contenido completo de la bitácora directamente desde el motor con pg\_read\_file() y se dividió el texto en filas por salto de línea (E'\\n') usando regexp\_split\_to\_table(). Para optimizar el análisis y evitar repetir consultas complejas se creó el esquema reservado CREATE SCHEMA dba; y se restringió el acceso público ejecutando REVOKE ALL ON SCHEMA dba FROM PUBLIC; para garantizar que solo el rol administrador pueda consultar los registros y se definió la vista dba.bitacora incorporando WITH ORDINALITY para asignar de forma dinámica un número consecutivo a cada línea (num), facilitando el ordenamiento y la referencia precisa de eventos. Con la vista activa se consultaron los 10 registros más recientes, se hizo un filtrado de sentencias de modificación con insensibilidad a mayúsculas/minúsculas y se filtraron los eventos críticos y fallos mediante expresiones regulares.

1. ¿Por qué logging\_collector requiere reinicio y log\_statement solo recarga?

Porque logging\_collector controla la arquitectura de procesos de postgresql a nivel de infraestructura, activar el colector implica que el proceso principal del motor debe crear y gestionar un proceso secundario en segundo plano, crear o destruir este proceso en memoria requiere detener e iniciar el servicio por completo, mientras que log\_statement es un parámetro que solo cambia el nivel de filtro de los mensajes de texto que genera la sesión existente, solo cambia una regla lógica que los procesos ya activos consultan antes de escribir una línea en la bitácora.

2. ¿Qué ventaja tiene que la bitácora se lea con SQL y no con una herramienta del sistema operativo o del contenedor? ¿Qué riesgo introduce?

Las ventajas son que permite realizar consultas complejas, ordenamientos, agrupaciones, entre otras cosas con expresiones regulares directamente sobre las bitácoras usando lenguaje sql estándar y que no necesita dar acceso ssh o permisos de administrador del sistema operativo a un usuario para auditar la bd ya que basta con conceder acceso a la vista dentro de postgresql. Y los riesgos son que consultar archivos de texto grandes dentro del motor consume memoria, cpu y lecturas de disco, lo cual puede ralentizar las operaciones de las bd en producción y que si el archivo contiene caracteres inválidos para la codificación del cliente o la bd, las consultas sobre la vista fallaran.

3. ¿Quién debería poder consultar dba.bitacora?

Solamente los administradores de bd y el equipo de auditoría de seguridad ya que las bitácoras pueden contener información sensible.  
