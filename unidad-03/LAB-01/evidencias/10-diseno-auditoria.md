**Actividad 10 — Diseñar y crear el registro de auditoría**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se diseñó una tabla de auditoría resiliente capaz de resolver las preguntas fundamentales de trazabilidad y también se garantizó la persistencia del estado en formato binario estructurado dentro de un esquema protegido contra accesos públicos.

| Campo propuesto | Tipo | ¿Qué pregunta responde? | ¿Puede ser nulo? ¿Por qué? |
| :---- | :---- | :---- | :---- |
| id\_evento | BIGSERIAL | ¿Cuál es el identificador único y secuencia cronológica de este evento de auditoría? | No porque es la clave primaria. |
| momento | TIMESTAMPTZ | ¿Cuándo ocurrió el cambio? | No porque todo registro de auditoría requiere una estampa de tiempo confiable. |
| usuario\_sesion | TEXT | ¿Con que cuenta se autenticó la conexión? | No porque garantiza el no repudio identificando la credencial original de la sesión. |
| usuario\_efectivo | TEXT | ¿Qué rol ejecutó realmente la acción? | No porque identifica el contexto de permisos bajo el cual se aplicó la modificación. |
| aplicacion | TEXT | ¿Desde qué aplicación o sistema se originó el cambio? | Si porque es opcional porque el cliente de red puede no haber definido la variable. |
| ip\_cliente | INET | ¿Desde que dirección ip o ubicación de red se realizó la conexión? | Si porque las conexiones locales por sockets no tienen una dirección ip asignada. |
| operacion | TEXT | ¿Qué tipo de acción se realizó? | No, porque es fundamental conocer la naturaleza de la transacción ejecutada. |
| id\_cliente | BIGINT | ¿A qué entidad o registro específico afectó el cambio? | Si porque depende de la estructura de la tabla destino o si la operación afecta múltiples registros sin id único. |
| valores\_antes | JSONB | ¿Cómo estaban los datos antes de la modificación? | Si porque en operaciones de inserción no existe un estado anterior. |
| valores\_despues | JSONB | ¿Cómo quedaron los datos después de la modificación? | Si porque en operaciones de borrado no existe un estado posterior. |

1. ¿Por qué momento usa TIMESTAMPTZ y no TIMESTAMP?

Porque TIMESTAMPTZ convierte internamente cualquier fecha ingresada a formato utc y guarda el valor normalizado y TIMESTAMP guarda únicamente la fecha y hora "pared" sin contexto de ubicación geográfica, si cambia el horario de verano o hay conexiones desde distintas regiones, es imposible determinar el orden cronológico real de los eventos.

2. ¿Por qué se guarda el registro completo en JSONB y no solo la columna que 

cambió?  
Porque guardar el estado completo mediante to\_jsonb y to\_jsonb desacopla la auditoría de la estructura de la tabla original, si en el futuro se agregan o eliminan columnas en clientes, la tabla de auditoría seguirá registrando la información sin romper su estructura ni requerir modificaciones mediante ALTER TABLE y porque permite reconstruir la fila completa exactamente como existía en un instante específico del tiempo, facilitando auditorías históricas profundas sin perder referencias de otros campos relacionados.

3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?

En la clasificación al almacenar el RFC, la tabla auditoria.cambios\_clientes pasa a custodiar información de identificación personal y datos de relevancia fiscal, referente a el control de acceso debe aplicarse aislamiento estricto mediante un esquema dedicado, asegurando que únicamente los roles de administración o auditores autorizados tengan acceso de lectura y los roles operativos no deben tener privilegios de consulta ni modificación directa sobre la tabla de auditoría, para prevenir la fuga de datos sensibles y garantizar la inalterabilidad de los registros.