**Actividad 7 — Cambios de privilegios: el límite más importante**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se comprobó que mongoDB no registra los cambios de roles ni en system.profile ni en la bitácora de mongod, tras otorgar temporalmente el rol dbAdmin al usuario app\_ventas y verificar que ambas fuentes arrojaron 0 coincidencias; como control compensatorio, se tomaron instantáneas manuales en la colección auditoria.instantaneas\_privilegios antes y después de la modificación, demostrando que este método permite detectar qué privilegio cambió y en qué ventana de tiempo, aunque sin identificar automáticamente al autor ni el instante exacto; finalmente, se revocó el rol adicional y se restableció el filtro de escritura en el perfilador.

1. ¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?

Porque otorga o revoca capacidades críticas sobre la db, una escalada de privilegios permite a un usuario o atacante leer información confidencial, modificar estructuras, alterar o borrar datos masivamente, o incluso desactivar los propios mecanismos de seguridad y auditoría.

2. ¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?

Se toman instantáneas diariamente o cada pocas horas de forma automatizada, además de tomar una instantánea manual obligatoria antes y después de cada ventana de mantenimiento o cambio administrativo.  
Influye la criticidad y sensibilidad de los datos almacenados, la cantidad de administradores con acceso de gestión de usuarios, los requisitos normativos o de cumplimiento y el nivel de riesgo de la operación.

3. ¿Quién debería poder escribir en auditoria.instantaneas\_privilegios?

Únicamente una cuenta de servicio dedicada exclusivamente a la tarea automatizada de auditoría; con permiso insert de solo escritura, sin permisos de update ni delete, o el rol de dba bajo estricto control, los usuarios de aplicación no deberían tener ningún permiso sobre la db auditoria, y ni siquiera los administradores operativos deberían poder modificar o eliminar instantáneas ya registradas para garantizar la integridad de la evidencia.

4. Redacta en tres líneas cómo comunicarías esta limitación a Dirección.

En MongoDB Community, los cambios en los permisos de los usuarios no quedan registrados de forma nativa en las bitácoras ni en el perfilador de operaciones. Para mitigar este riesgo, implementamos un control compensatorio mediante instantáneas periódicas de los roles asignados, lo que nos permite detectar qué privilegios cambiaron y en qué ventana de tiempo. Como limitación técnica de esta edición, el sistema no identifica por sí solo qué administrador ejecutó el cambio ni el segundo exacto, por lo que recomendamos restringir estrictamente el acceso administrativo y formalizar una bitácora externa de autorizaciones.  
