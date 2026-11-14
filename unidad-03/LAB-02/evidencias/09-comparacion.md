**Actividad 9 — Comparar los tres escenarios**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

| Evento auditable | PostgreSQL (bitácora \+ disparador) | MongoDB Community (perfilador \+ bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
| :---- | :---- | :---- | :---- |
| Acceso exitoso | Si(observado en log\_connections) | Si(observado en bitacora ACCESS / Successfully authenticated) | Documentado, no practicado |
| Acceso fallido | Si(observado en bitácora con intención de fallo) | Si(observado en bitacora ACCESS / Failed to authenticate) | Documentado, no practicado |
| Cambio de privilegios | Si(observado en bitacora de sentencias ddl/dcl) | No(no se registra en perfilador ni en bitácora, se requiere instantáneas como control compensatorio) | Documentado, no practicado |
| Cambio de estructura | Si(observado con log\_statement \= ‘ddl’) | Parcial(el perfilador en nivel 2 registra comandos como create o drop, pero no persiste después de reinicios ni guarda historial largo sin exportarse) | Documentado, no practicado |
| Modificación de datos | Si(observado mediante disparador de auditoría) | Si(observado en system.profile como insert, update y remove) | Documentado, no practicado |
| Valor anterior del dato | Si(observado mediante OLD en el disparador) | No(el perfilador solo registra el filtro q y la operación u enviada, nunca el estado previo del documento) | Documentado, no practicado |
| Lectura de datos sensibles | Parcial(puede registrarse con log\_statement \= ‘all’, pero genera alto volumen y no es práctico por tabla sin extensiones como pgaudit) | Parcial(observado sólo si el perfilador está en nivel 2 o sin filtro de escritura; se omite en nivel 1 con filtro de modificaciones) | Documentado, no practicado |
| Cambio de configuración del registro | Si(observado en bitácora al recargar/modificar parámetros) | Parcial(la bitácora registra Profiler settings changed con el ctx de conexión, pero obliga a correlacionar manualmente con la autenticación previa para saber el usuario) | Documentado, no practicado |

