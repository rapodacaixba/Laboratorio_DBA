**Actividad 7 — Modificaciones de datos: ddl frente a mod**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se confirmó que configurando log\_statement, las sentencias de manipulación de datos quedan omitidas, al cambiar el parámetro a mod mediante ALTER SYSTEM SET log\_statement \= 'mod' y ejecutar SELECT pg\_reload\_conf(), el motor comenzó a registrar las modificaciones de datos.Con mod, la bitácora capturó exitosamente la trazabilidad completa del UPDATE: el usuario, la base de datos, el origen ip, el nombre del aplicativo y la sentencia ejecutada. Con esto se evidenció que las lecturas de datos se ignoran bajo el nivel mod para no saturar el servidor, y que la bitácora registra la instrucción aplicada, pero no almacena el estado anterior del registro modificado.

1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?

El nivel log\_statement \= 'all' debido a que este parámetro obliga al motor a registrar absolutamente todas las sentencias ejecutadas, incluyendo las de consulta de datos.  
En un servidor en producción con miles de consultas por minuto, escribir en disco cada SELECT genera un cuello de botella masivo en la entrada y salida de datos, aumentando drásticamente la latencia de respuesta de las aplicaciones, se generan GB o TB de datos de registros en cuestión de horas o días, agotando rápidamente el almacenamiento en disco y complicando la retención histórica de las bitácoras y se genera ruido en los registros, haciendo extremadamente difícil localizar sentencias críticas o de error entre millones de lecturas cotidianas.

2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza? (Lo resolverás en la Parte B.)

Le falta el valor previo del dato modificado, las bitácoras de auditoría de sentencias sólo registran el texto literal de la consulta ejecutada, pero no guardan una captura del registro como estaba antes de la modificación. Para poder revertir un cambio no deseado o realizar una recuperación precisa a nivel de fila, se requieren mecanismos de auditoría más avanzados, como triggers de auditoría, o el uso del registro de escritura adelantada y replicación lógica.  
