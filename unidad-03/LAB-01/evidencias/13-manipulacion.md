**Actividad 14 — Intentar manipular la auditoría**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se validó que una cuenta con permisos operativos limitados no puede vaciar la tabla de auditoría ni desactivar los disparadores, al ser rechazada por falta de privilegios, se demostró que un rol administrador puede evadir la auditoría de tablas desactivando temporalmente el disparador, y se evidenció que la bitácora del servidor actúa como control defensivo secundario al registrar la desactivación del trigger, reafirmando que la seguridad absoluta requiere exportar los registros a un sistema externo fuera del alcance del administrador de la base de datos.

1. ¿Qué evidencia permite detectar que hubo un cambio sin auditar?

El registro del evento DDL en la bitácora del servidor, aunque el cambio en la tabla clientes no se registró en la tabla auditoria.cambios\_clientes debido a que el disparador estaba desactivado, con log\_statement \= 'mod' o 'ddl' el motor registró las sentencias administrativas ejecutadas por la sesión del administrador, la discrepancia entre la presencia del UPDATE registrado en el archivo de registro y la ausencia correspondiente en la tabla de auditoría permite a un auditor detectar la manipulación y la ventana de evasión.

2. ¿Qué control administrativo (no técnico) reduciría este riesgo?

Envío y centralización de bitácoras en tiempo real a un servidor externo inalterable administrado por un equipo independiente, impedir que los administradores de bases de datos tengan acceso o privilegios sobre el servidor donde se almacenan y custodian los archivos de registro, requerir una solicitud de cambio formal aprobada por el área de seguridad antes de ejecutar tareas de mantenimiento o desactivación de triggers en entornos de producción y revisiones sorpresa y análisis de discrepancias entre las bitácoras del servidor y las tablas de auditoría por parte del equipo de seguridad de la información.

3. Relaciona esta actividad con el principio de separación de funciones de la Unidad II.

El principio de separación de funciones establece que ninguna persona o rol debe tener el control total sobre un ciclo completo de operaciones o sobre la custodia de la evidencia de sus propias acciones, esta actividad demuestra la limitación de la seguridad puramente técnica: un administrador supremo posee privilegios suficientes para apagar o desviar los controles internos. Para evitar el conflicto de interés y el abuso de privilegios, la función de operación de la base de datos debe estar estrictamente separada de la función de custodia y supervisión de la evidencia.