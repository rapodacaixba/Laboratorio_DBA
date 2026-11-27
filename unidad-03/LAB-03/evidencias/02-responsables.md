**Actividad 2 — Propietarios, custodios y usuarios**

| Conjunto de datos | Propietario | Custodio | Usuarios autorizados | Quien aprueba accesos | Quien aprueba correcciones |
| :---- | :---- | :---- | :---- | :---- | :---- |
| comercial.public.clientes(PostgreSQL) | Gerencia comercial | DBA | Atención al cliente, facturación, analítica y aplicación de ventas, según sus permisos | Gerencia comercial | Responsable del dato correspondiente |
| auditoria.cambios\_clientes(PostgreSQL) | Auditoría interna | DBA | Personal de auditoría autorizado y seguridad | Auditoria interna | Auditoría interna, respecto a la integridad del registro |
| Bitácora de PostgreSQL | Seguridad TI/ Auditoria interna | DBA | DBA y personal autorizado de auditoría | Seguridad TI | No aplica; se conserva como evidencia |
| comercial.clientes(MongoDB) | Gerencia comercial | Administrador de MongoDB | Atención al cliente, facturación y aplicación de ventas, según sus permisos | Gerencia comercial | Responsable del dato correspondiente |
| comercial.system.profile(MongoDB) | Seguridad TI/ Auditoria interna | Administrador de MongoDB | DBA y personal de auditoría autorizado | Seguridad TI | No aplica; se conserva como evidencia técnica |

1. ¿Por qué el propietario de auditoria.cambios\_clientes no debería ser el mismo que opera clientes?

Porque debe existir separación de responsabilidades, el propietario de los datos de auditoría debe poder supervisar los cambios realizados sin depender exclusivamente de la persona que administra la tabla original, esto ayuda a reducir conflictos de interés y facilita las revisiones internas.

2. ¿Quién debería poder leer las bitácoras y la vista dba.bitacora? Relaciónalo con lo observado en el LAB-01 (secretos en la bitácora).

El acceso debe limitarse al DBA y al personal autorizado de auditoría y seguridad, en el LAB-01 se observó que las bitácoras pueden contener información sensible, como contraseñas incluidas en determinadas sentencias, por esta razón no deben estar disponibles para todos los usuarios.

3. ¿Qué ocurre con la responsabilidad sobre un dato cuando nadie la tiene asignada? Relaciónalo con el problema inicial de la unidad.

Cuando no existe un propietario asignado, no hay una persona o área que pueda decidir sobre el uso, acceso, corrección o eliminación de los datos, esto provoca falta de responsabilidad y dificulta demostrar que las decisiones tomadas fueron autorizadas.  
