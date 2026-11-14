**Actividad 3 — Activar el perfilador y registrar operaciones**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se habilitó el perfilador de mongoDB en nivel 2 para registrar todas las operaciones ejecutadas sobre la db comercial, se hicieron consultas, actualizaciones y eliminaciones desde el usuario app\_ventas, después se analizaron los registros almacenados en system.profile.

| op | Usuario | Cliente | Aplicación | Momento | Qué hizo | Documentos afectados |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| query | app\_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-13T19:09:04.592Z | Consulto los clientes de Culiacán | 3 devueltos de 5 examinados |
| update | app\_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-13T19:09:04.608Z | Modificó el rfc de id \= 3 | 1 modificado de 1 examinado |
| remove | app\_ventas@comercial | 127.0.0.1 | app-ventas-web | 2026-11-13T19:09:04.613Z | Eliminó el documento de id \= 2 | 1 eliminado de 1 examinado |

1. ¿Puedes saber cuál era el RFC antes del cambio con la información de system.profile?

No, el perfilador registra la operación de actualización y el valor nuevo proporcionado en el comando, pero no conserva automáticamente el valor anterior del documento.

2. ¿Puedes saber qué datos tenía el documento eliminado?

No exactamente, el perfilador permite identificar la operación de eliminación y su criterio de búsqueda, pero no conserva una copia completa del documento eliminado.

3. A diferencia de log\_statement \= 'mod' en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?

Lo bueno es que proporciona mayor trazabilidad al registrar también las operaciones de lectura, lo malo es que genera un mayor volumen de información, puede afectar el rendimiento y registrar datos sensibles contenidos en los filtros de las consultas.

4. ¿Por qué el campo user incluye @comercial?

Porque identifica tanto el nombre del usuario autenticado como la db en la que está definido, en este caso app\_ventas pertenece a la base comercial.