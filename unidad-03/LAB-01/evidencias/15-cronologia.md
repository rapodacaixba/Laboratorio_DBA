**Actividad 16 — Exportar y conservar la bitácora**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se ejecutó la extracción de la bitácora activa del servidor sanitizando el secreto expuesto en la actividad 6 mediante la función replace(), evitando la propagación de credenciales sensibles en el reporte final, se generó el resumen criptográfico del archivo de evidencia para establecer una línea base de integridad que permita validar en cualquier momento que la bitácora no ha sido alterada, y se concluyó la necesidad de exportar y centralizar de forma automatizada las bitácoras hacia repositorios externos inalterables, desvinculando la custodia de la evidencia del servidor que la produce.

1. Un resumen SHA-256, ¿impide que alguien modifique la bitácora? ¿Qué permite demostrar?

No, un resumen hash no impide que alguien modifique la bitácora, es un mecanismo de comprobación pasivo, no añade permisos ni protección contra escritura sobre el archivo en el sistema de archivos, permite demostrar la integridad de los datos, funciona como un sello de evidencia, si se calcula el hash del archivo en el momento de la extracción y posteriormente se vuelve a calcular, ambos valores deben coincidir exactamente y si difieren en un solo carácter o espacio, demuestra técnicamente que el archivo fue alterado, dañado o manipulado tras su exportación.

2. ¿Dónde debería guardarse el hash para que sea útil como control de integridad?

En un repositorio externo, inalterable y fuera del control del administrador del servidor de base de datos, si el archivo de bitácora y su hash SHA-256 se guardan en el mismo servidor o bajo el control del mismo usuario, un usuario malicioso podría alterar la bitácora y regenerar el archivo .sha256 para ocultar la manipulación. 

3. La guía NIST SP 800-92 trata la conservación y protección de bitácoras (REF-U3-03). ¿Qué riesgos tiene conservar la bitácora solo en el servidor que la produce?

Si el servidor sufre un fallo masivo de hardware, daño en el sistema de archivos o una reinstalación, los registros de auditoría se pierden de forma irreversible, los motores de base de datos y sistemas operativos rotan y eliminan archivos de registro antiguos automáticamente para evitar llenar el disco, eliminando el historial, si un atacante compromete el servidor o un administrador interno actúa de forma maliciosa, puede borrar o alterar los archivos de registro locales para eliminar las huellas de sus acciones, y reservar grandes cantidades de espacio en disco de alto rendimiento para mantener logs antiguos degrada la capacidad y el costo de la base de datos.

4. Propón durante cuánto tiempo conservarías esta bitácora y justifica tu criterio. No existe una cifra única correcta.

Una propuesta estructurada y justificable es mantener la bitácora durante 1 a 5 años, dividida en niveles de almacenamiento, 30 a 90 días en almacenamiento activo y de 1 a 5 años en almacenamiento de archivo ya que en la mayoría de los marcos regulatorios y fiscales las obligaciones tributarias o de responsabilidad legal prescriben habitualmente entre los 3 y 5 años, muchos ataques cibernéticos se descubren meses después de la intrusión inicial; contar con al menos 1 año de registros permite a los equipos forenses reconstruir la línea de tiempo original del vector de ataque.

**Actividad 17 — Reconstruir la cronología y responder a Dirección**

|  | Fecha y hora | Usuario | Cliente | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| 1 | 2026-10-25 22:50:09.341 UTC | postgres  | \[local\] / psql | Privilegio  | Revocación de permiso UPDATE sobre la tabla clientes al rol soporte\_ana  | Si | Bitácora (statement: REVOKE UPDATE...)  |
| 2 | 2026-10-25 22:50:09.367 UTC  | postgres  | \[local\] / psql  | Privilegio  | Otorgamiento de permiso UPDATE sobre la tabla clientes al rol app\_ventas  | Si | Bitácora (statement: GRANT UPDATE...)  |
| 3 | 2026-10-25 22:50:09.372 UTC  | postgres  | \[local\] / psql  | Estructura  | Adición de la nueva columna segmento VARCHAR(20) a la tabla clientes  | Si | Bitácora (statement: ALTER TABLE clientes ADD...)  |
| 4 | 2026-10-25 22:50:09.375 UTC  | postgres  | \[local\] / psql  | Privilegio / Secrecia  | Creación del usuario rol\_temporal especificando contraseña sensible en texto claro  | Si | Bitácora (statement: CREATE ROLE...)  |
| 5 | 2026-10-25 22:50:09.382 UTC  | postgres  | \[local\] / psql  | Privilegio | Eliminación del usuario temporal rol\_temporal del sistema  | Si | Bitácora (statement: DROP ROLE...)  |
| 6 | 2026-10-25 22:50:09.390 UTC | postgres  | \[local\] / psql  | Configuración  | Modificación/actualización de la contraseña del usuario app\_ventas usando SCRAM-SHA-256  | Si | Bitácora (statement: ALTER USER app\_ventas...)  |
| 7 | 2026-11-08 16:47:39.916 PST  | app\_ventas  | 127.0.0.1 / app-ventas-web  | Acceso | Autenticación de sesión exitosa mediante método scram-sha-256  | Si | Bitácora (conexión autenticada...)  |
| 8 | 2026-11-08 16:47:39.929 PST  | app\_ventas  | 127.0.0.1 / app-ventas-web  | Acceso | Cierre de sesión normal tras una duración total de 0.038 segundos  | Si | Bitácora (desconexión: duración...)  |

1. ¿Quién cambió el RFC la primera vez (Actividad 3)? ¿Y en las Actividades 7, 12 y 14?

En la actividad 3 no hay evidencia ya que el parámetro log\_statement no auditaba sentencias DML y la infraestructura de disparadores aún no había sido creada. En la actividad 7 tampoco hay evidencia ya que el UPDATE ejecutado por app\_ventas modificó la columna rfc al valor 'GAMA780912XYZ'. Sin embargo, log\_statement estaba configurado únicamente en 'ddl', la bitácora solo capturó los eventos de conexión y desconexión, omitiendo la instrucción de modificación de datos. En la actividad 12 fue el usuario app\_ventas, registrado explícitamente en la tabla auditoria.cambios\_clientes y en la actividad 14 fue el usuario postgres, el cambio se realizó evadiendo la tabla de auditoría, pero quedó registrado en la bitácora del servidor.

2. ¿Quién cambió el teléfono?

El usuario app\_ventas capturado en la bitácora del servidor tras activar log\_statement \= 'mod'.

3. ¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?

No, en los extractos de la bitácora evaluados durante las actividades de la práctica no aparecen eventos de falla de autenticación y intentos de acceso fallidos a nivel de autorización sí, existieron dos intentos registrados uno fue el intentó de ejecutar DELETE FROM clientes WHERE id \= 5, siendo rechazado por falta de permisos. y el otro fue el intento de consultar la tabla de auditoría y desactivar el disparador, siendo rechazado en ambos casos por falta de privilegios.

4. ¿Qué valor tenía el RFC antes de cada cambio?

Antes del cambio de la actividad 12 era  'GAMA780912XYZ' y antes del cambio de la Actividad 14 era 'GAMA780912ZZZ' que corresponde al valor guardado en el estado de la base de datos tras la ejecución de la actividad 12, ya que en la actividad 14 la desactivación del trigger impidió capturar valores\_antes en la tabla de auditoría.