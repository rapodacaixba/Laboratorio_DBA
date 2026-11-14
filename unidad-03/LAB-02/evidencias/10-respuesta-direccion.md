**Actividad 10 — Responder a Dirección**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

1. ¿Quién cambió el RFC de María García en la Actividad 2? ¿Y en la Actividad 3?

En la actividad 2 no hubo evidencia  ya que en ese momento el perfilador estaba desactivado, entonces la actualización ejecutada quedó sin registro y en la actividad 3 con el perfilador activo en nivel 2, la evidencia de system.profile demuestra que el cambio fue realizado por el usuario de db app\_ventas@comercial.

2. ¿Cuándo y desde qué aplicación?

Desde la aplicación identificada como app-ventas-web el 2026-11-13T19:09:04.608Z.

3. ¿Qué valor tenía antes?

No hay evidencia, el perfilador de mongoDB registra únicamente el criterio de búsqueda; q: { \_id: 3 } y la instrucción de actualización aplicada u: { \$set: { rfc: "GAMA780912XYZ" } }, pero no captura ni almacena el estado previo del documento antes de ser modificado.

4. ¿Cambió alguien los privilegios de app\_ventas?

No hay evidencia con esta edición sobre quién ni cuándo exactamente ocurrió, el motor de mongoDB no audita ni registra comandos de administración de roles en system.profile ni en la bitácora de mongod, únicamente mediante auditoria.instantaneas\_privilegios se pudo observar que se agregó temporalmente el rol dbAdmin sobre comercial, el cual posteriormente fue revocado.  
