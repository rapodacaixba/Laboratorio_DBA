**Actividad 11 — Crear la función y el disparador**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se implementó una función pl/pgsql enlazada a un disparador AFTER por fila (trg\_auditoria\_clientes), automatizando la captura de cambios en la tabla clientes, también se aseguró la escritura en la tabla de auditoría mediante SECURITY DEFINER, permitiendo que el motor inserte el registro con los permisos del propietario, manteniendo bloqueado el acceso directo de la aplicación al esquema auditoria, mediante to\_jsonb old y to\_jsonb new se capturó la foto exacta del registro antes y después del cambio. Además, se verificó mediante pg\_trigger el estado habilitado del disparador y se confirmó el registro en la bitácora de toda la infraestructura DDL creada.

1. ¿Por qué se ejecuta REVOKE ALL ON FUNCTION ... FROM PUBLIC si el disparador seguirá funcionando para app\_ventas?

Al ejecutar REVOKE ALL, se impide que usuarios o roles sin privilegios puedan invocar directamente la función desde una consulta sql estándar, el disparador se ejecuta automáticamente a nivel del motor en el contexto de la tabla clientes, aunque el usuario app\_ventas no tenga permiso para llamar directamente a la función como si fuera una rutina de consulta, el trigger sí la activa sin problemas cuando se realiza un INSERT, UPDATE o DELETE.

2. ¿Qué pasaría si la función no fuera SECURITY DEFINER? Formula una hipótesis antes de la Actividad 12\.

Si la función fuera SECURITY INVOKER se ejecutaría con los privilegios del usuario que realiza la modificación, al momento en que app\_ventas intente hacer un UPDATE en la tabla clientes, el disparador intentará insertar un registro en auditoria.cambios\_clientes. Como la tabla de auditoría se encuentra protegida dentro del esquema auditoría y app\_ventas no tiene permisos de escritura sobre ella, la transacción fallará arrojando un error de permission denied for table cambios\_clientes, impidiendo incluso realizar la modificación en la tabla clientes, al declarar la función con SECURITY DEFINER, esta se ejecuta temporalmente con los privilegios de su creador, permitiendo registrar el cambio en la tabla de auditoría sin necesidad de otorgarle a app\_ventas permisos directos sobre el esquema de auditoria.

3. Consulta dba.bitacora. ¿Quedó registrada la creación del esquema, la tabla, la función y el disparador? ¿Por qué?

Sí, todas estas operaciones quedan registradas en la bitacora porque en la actividad 7 se configuró el parámetro log\_statement o previamente log\_statement. Todas las sentencias ejecutadas en esta actividad pertenecen a la categoría de DDL, como el motor audita las operaciones DDL, cada instrucción fue capturada con su respectiva estampa de tiempo, usuario y detalle.

**Actividad 12 — El incidente auditado**

En esta actividad se comprobó que el disparador capturó de manera transparente la sentencia UPDATE realizada por app\_ventas, registrando tanto la identidad de la sesión como la dirección ip y el contexto de la aplicación, se validó que el rol app\_ventas es capaz de provocar el registro del cambio a través de SECURITY DEFINER, pero no tiene autorización para leer ni alterar la tabla de auditoría, mediante el uso de jsonb\_each() y IS DISTINCT FROM, se extrajo de manera exacta la diferencia entre valores\_antes y valores\_despues, aislando únicamente la columna alterada para permitir una restauración limpia y precisa del dato.

1. Compara tu hipótesis de la Actividad 11 con este resultado.

La hipótesis planteada fue correcta, en el primer comando, app\_ventas ejecutó exitosamente el UPDATE a pesar de no tener permisos de escritura sobre la tabla auditoria.cambios\_clientes. Esto fue posible gracias a que la función fue definida con SECURITY DEFINER, ejecutándose temporalmente con los privilegios del propietario, como evidencia la columna usuario\_efectivo \= postgres.  
En el segundo comando, cuando app\_ventas intentó directamente consultar la auditoría, postgresql bloqueó el acceso con ERROR, esto demuestra que la seguridad y el aislamiento del esquema de auditoría se mantuvieron intactos sin comprometer la ejecución del disparador.

2. Escribe la sentencia UPDATE que restauraría el valor anterior.

Utilizando la información forense recuperada con la consulta JSONB, la sentencia para revertir el cambio es:  
UPDATE clientes   
SET rfc \= 'GAMA780912XYZ'   
WHERE id \= 3;

3. ¿Qué columna conserva más valor para una investigación: aplicacion o ip\_cliente? ¿Cuál puede falsificar el cliente con más facilidad?

ip\_cliente representa la dirección del host de red a nivel de capa de transporte/red negociada en la conexión y es el identificador técnico clave para rastrear el equipo físico, contenedor o segmento de red de donde proviene la conexión, mientras que aplicacion es un parámetro informativo puramente cliente que cualquier usuario o script puede modificar a voluntad en la cadena de conexión, no ofrece garantías de autenticidad por sí solo.  
