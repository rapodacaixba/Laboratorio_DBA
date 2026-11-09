**Actividad 4 — Configurar la bitácora**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se aplicaron nuevos parámetros de auditoría mediante ALTER SYSTEM y se aplicaron sin reiniciar el servidor ejecutando SELECT pg\_reload\_conf(). La consulta a pg\_settings confirmó que los valores ahora provienen del archivo postgresql.auto.conf y all revisar dba.bitacora, se comprobó que el servidor registró inmediatamente la aplicación de los nuevos parámetros y la conexión activa, enriqueciendo el prefijo de cada línea con el usuario, la base de datos y el origen de la conexión.

1. ¿Por qué el proceso que registra el cambio es el principal y no tu sesión?

Porque cuando se ejecuta SELECT pg\_reload\_conf(), la sesión únicamente le envía una señal al proceso principal del servidor, este proceso principal es el encargado de releer los archivos de configuración, aplicar los nuevos parámetros a nivel global y escribir los mensajes de cambio en la bitácora.

2. ¿Qué pasaría si alguien ejecutara ALTER SYSTEM SET log\_statement \= 'none'? ¿Quedaría rastro?

Sí quedaría rastro ya que la sentencia ALTER SYSTEM como tal podría no registrarse si log\_statement estaba en ddl, sin embargo, al ejecutar pg\_reload\_conf(), el proceso principal registrará obligatoriamente la línea, lo cual deja una evidencia clara e inalterable de cuándo y qué parámetro de auditoría fue modificado.

3. ¿Por qué no se recomienda editar postgresql.auto.conf a mano?

Porque es un archivo gestionado exclusivamente por el motor de postgresql para aplicar los comandos ALTER SYSTEM, si ejecutas un nuevo ALTER SYSTEM, postgresql reescribirá todo el archivo, perdiendo cualquier comentario o edición manual previa y porque los errores de sintaxis al editarlo a mano pueden impedir que el servidor inicie o causar comportamientos inconsistentes con postgresql.conf.