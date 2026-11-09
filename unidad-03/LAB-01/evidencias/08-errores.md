**Actividad 8 — Errores y operaciones rechazadas**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se comprobó que las operaciones rechazadas por el motor se registran automáticamente gracias al parámetro log\_min\_error\_statement, el cual captura el fallo independientemente del valor de log\_statement, al consultar dba.bitacora, el servidor guardó tanto la línea de ERROR, el STATEMENT y el DETAIL, permitiendo auditar intentos de borrado sin permiso y fallos en la administración de roles, se demostró la importancia de capturar las acciones rechazadas para detectar anomalías operativas o comportamientos sospechosos dentro de las sesiones activas de la bd.

1. ¿El intento de soporte\_ana causó algún daño? ¿Por qué debe auditarse de todos modos?

No causó daño, el motor abortó la transacción inmediatamente arrojando permission denied, por lo que la tabla clientes permaneció intacta.  
Debe auditarse porque constituye un evento de seguridad e intento de violación de políticas de acceso, en auditoría forense, acumular múltiples errores de autorización de un usuario o rol puede indicar un intento de escalación de privilegios, un usuario actuando fuera de sus funciones asignadas o un software comprometido realizando escaneo de permisos.

2. ¿Qué diferencia hay entre un error de autorización (esta actividad) y uno de autenticación (Actividad 5)?

El error de autenticación ocurre antes de ingresar al sistema, es la falla al validar la identidad del usuario y el error de autorización ocurre dentro de la sesión activa, la identidad del usuario fue validada con éxito, pero la cuenta intenta ejecutar una operación para la cual no tiene permisos o privilegios suficientes.

3. ¿Qué indica el error de DROP ROLE sobre el orden correcto para dar de baja a un usuario?

Indica que en postgresql no se puede eliminar un rol si aún posee objetos o privilegios asignados sobre cualquier objeto de la base de datos.