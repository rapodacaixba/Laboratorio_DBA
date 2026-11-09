**Actividad 3 — El incidente sin bitácora**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se modificó la tabla clientes desde un cliente remoto usando el usuario app\_ventas, al consultar la vista dba.bitacora, la búsqueda no devuelve nada ya que no se registró ni el inicio de sesión ni la sentencia ejecutada debido a que log\_statement estaba en none y log\_connections en off. La falta de registros impide demostrar técnicamente quién realizó el cambio o exonerar a otros usuarios, demostrando que los permisos de usuario por sí solos no garantizan la seguridad sin una configuración activa de auditoría.

1. ¿Puedes demostrar quién modificó el RFC?

No es posible demostrarlo ya que al estar los parámetros log\_statement \= 'none' y log\_connections \= 'off', el servidor no registró la sentencia UPDATE ni la conexión del usuario app\_ventas.

2. ¿Puedes demostrar que el cambio no lo hizo soporte\_ana?

No porque al no registrarse las conexiones ni los eventos de modificación, la ausencia de soporte\_ana en el registro no prueba que no haya realizado el cambio, simplemente refleja que el servidor no estaba capturando la actividad de ningún usuario.

3. Los privilegios de la Unidad II, ¿impidieron el cambio? ¿Debían impedirlo?

No impidieron el cambio, el comando devolvió UPDATE 1 lo que significa que la modificación fue exitosa, los privilegios no debían impedirlo porque la cuenta app\_ventas es el rol asignado a la aplicación de ventas para operar sobre la base de datos comercial, para cumplir con el principio de mínimo privilegio y sus funciones operativas, app\_ventas debe contar legítimamente con permisos de actualización sobre la tabla clientes. El problema en este escenario no es un fallo en el control de acceso, sino la falta de auditabilidad.

4. ¿Qué tendría que haber estado configurado antes del incidente?

Para haber tenido evidencia completa del incidente antes de que sucediera, el servidor debía tener activos los siguientes parámetros: log\_connections para registrar cada inicio de sesión exitoso, incluyendo el usuario, la dirección ip y el parámetro de la aplicación, log\_statement para auditar todas las sentencias de modificación de datos y log\_line\_prefix para asegurar que cada línea registrada identifique claramente quién ejecutó la acción y desde dónde.