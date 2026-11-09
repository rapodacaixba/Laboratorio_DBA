**Actividad 13 — Altas y bajas**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se verificó la capacidad del sistema de auditoría basado en triggers para rastrear el ciclo de vida completo de un registro, registrando con precisión el estado inicial en la creación y la captura del estado final en la supresión, se reconfirmó la distinción entre las conexiones de red y las conexiones por sockets locales de administración, se identificó la tensión existente entre las leyes de privacidad de datos y la integridad de los registros de auditoría.

1. El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?

En la tabla auditoria.cambios\_clientes, aunque la fila fue eliminada físicamente de la tabla operacional clientes, el disparador registró tanto el evento de inserción como el de eliminación, el documento JSONB conserva la totalidad de los atributos del cliente exactamente como existían antes de la baja.

2. ¿Por qué ip\_cliente está vacía en los eventos 2 y 3?

Porque los comandos se ejecutaron directamente en la sesión del administrador utilizando un socket de dominio UNIX local, en conexiones locales mediante socket, la comunicación no pasa por la pila del protocolo de red, por lo que la función inet\_client\_addr() devuelve NULL. Solo las conexiones remotas o simuladas por bucle invertido tcp/ip asignan una dirección ip.

3. La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?

Por un lado, las normativas de protección de datos personales exigen la eliminación definitiva de la información personal cuando deja de ser necesaria y por otro lado, los marcos de seguridad y cumplimiento financiero/legal exigen mantener bitácoras e historiales de auditoría inalterables para garantizar la trazabilidad y el no repudio de las operaciones, quien debe resolverlo es el oficial de cumplimiento legal en conjunto con el equipo de auditoría e infraestructura de TI.