**Actividad 15 — Límites: lecturas y volumen**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se analizó cómo un único comando masivo a nivel de aplicación genera una sola entrada en el log del servidor, pero dispara tantas escrituras de auditoría como filas afectadas existan en la tabla, se confirmó que la consulta de datos sensibles mediante SELECT no activa disparadores y no deja rastro bajo log\_statement \= 'mod', resaltando la necesidad de mecanismos avanzados como la extensión pgaudit para auditar lecturas a nivel de objeto/columna, se evidenció que soluciones simplistas como activar log\_statement \= 'all' para capturar lecturas provocan problemas graves de rendimiento y convierten los registros del servidor en un almacén inseguro de datos sensibles.

1. Si clientes tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un UPDATE sin WHERE?

Al ejecutarse el UPDATE masivo, el disparador FOR EACH ROW se activaría un millón de veces dentro de la misma transacción, lo que generaría un millón de inserciones adicionales en auditoria.cambios\_clientes, construyendo y serializando un millón de documentos JSONB para valores\_antes y valores\_despues.

2. Propón quién podría autorizar la depuración de auditoria.cambios\_clientes.

La depuración de registros de auditoría debe ser un proceso formalizado que cumpla con el principio de separación de funciones, el DPO es quien debe autorizar esto y no debe autorizarlo de manera unilateral el DBA ni el equipo de desarrollo, requiere la firma formal de un acta de expiración conforme a la política de retención legal y antes de eliminar las filas de la base de datos, el equipo de infraestructura debe generar y validar un respaldo cifrado de solo lectura para custodia a largo plazo.

3. ¿Por qué log\_statement \= 'all' puede convertir la bitácora en un nuevo depósito de datos sensibles?

Con log\_statement \= all, PostgreSQL graba en los archivos de texto de la bitácora el texto exacto de cada consulta, incluyendo las variables literales enviadas en las cláusulas como WHERE y VALUES, si una aplicación consulta o inserta datos sensibles, toda esa información personal o confidencial queda guardada en texto claro dentro de los archivos de registro, los archivos de log del servidor raramente cuentan con los mismos esquemas de cifrado a nivel de columna o restricciones de acceso que la base de datos, convirtiendo la bitácora en un objetivo prioritario para exfiltración de datos no autorizada.