**Actividad 6 — Cambios de privilegios y de estructura**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se comprobó que con log\_statement, postgresql registra automáticamente modificaciones de estructura, asignación o revocación de permisos y gestión de roles, también se evidenció que la creación directa de roles con contraseñas en texto claro deja la credencial expuesta de forma permanente en el archivo de bitácora, incluso tras eliminar el rol y se contrastó la exposición en texto plano contra la alternativa segura \\password, la cual procesa el algoritmo SCRAM-SHA-256 en el cliente y solo registra la cadena resumida.

1. ¿Qué tipo de evento es cada una de las tres primeras sentencias (privilegio o estructura)?

El primero de REVOKE UPDATE es un evento de privilegio, el segundo de GRANT UPDATE también es evento de privilegio y el tercero ALTER TABLE es evento de estructura.

2. ¿Por qué GRANT y REVOKE quedan registrados con log\_statement \= 'ddl'?

Porque en la arquitectura de auditoría de postgresql, las sentencias de control de acceso forman parte de la definición del esquema y la seguridad del motor, postgresql clasifica GRANT, REVOKE, CREATE ROLE, ALTER ROLE y DROP ROLE bajo la categoría de DDL para fines del parámetro log\_statement, lo que garantiza que cualquier alteración en el modelo de permisos o roles sea auditada sin necesidad de registrar todas las operaciones sobre los datos.

3. Si la bitácora contiene contraseñas, ¿quién debería poder leerla? Relaciónalo con la gestión de secretos de la Unidad II.

Solo deberían poder leerla los DBAs y el equipo de auditoría de seguridad, manteniendo el acceso al archivo en el sistema operativo restringido exclusivamente a la cuenta del sistema postgres.  
Relación con la gestión de secretos: principio de mínimo privilegio y separación de funciones, como la bitácora puede exponer secretos en texto plano cuando se crean roles con PASSWORD, no se debe permitir que desarrolladores o usuarios de aplicaciones tengan lectura del archivo o de la vista dba.bitacora, buenas prácticas en la gestión de credenciales: demuestra por qué nunca deben enviarse contraseñas escritas directamente en consultas DDL en texto plano y se debe usar el comando \\password o herramientas que generen el hash cliente antes de la transmisión, evitando así la fuga de credenciales en los archivos de registro.  
