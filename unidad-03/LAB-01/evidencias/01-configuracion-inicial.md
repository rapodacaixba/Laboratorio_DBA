**Actividad 1 — Revisar la configuración de registro por defecto**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

Resultados obtenidos de la consulta hecha:

| log\_connections | off | default |
| :---- | :---- | :---- |
| log\_destination | stderr | configuration file |
| log\_directory | log | default |
| log\_disconnections | off | default |
| log\_filename | postgresql-%Y-%m-%d\_%H%M%S.log | default |
| log\_line\_prefix | %t | configuration file |
| log\_min\_error\_statement | error | default |
| log\_statement | none | default |
| log\_timezone | America/Los\_Angeles | configuration file |
| logging\_collector | on | configuration file |

1. Con esta configuración, ¿se registra quién se conecta?

No ya que el parámetro log\_connections está en off lo que significa que postgresql no registrara en la bitácora los inicios de sesión ni las conexiones exitosas de los usuarios.

2. ¿Se registran las sentencias UPDATE?

No porque el parámetro log\_statement está en none y para que se registraran las sentencias de modificación de datos como UPDATE u otros, este parámetro tendría que estar configurado en mod o en all, pero una sentencia que provoque un error puede quedar registrada debido a log\_min\_error\_statement \= error.

3. ¿La línea de bitácora incluye el usuario o la dirección IP del cliente?

No porque la línea log\_line\_prefix está configurada solo como %t, lo cual incluye únicamente el tiempo, para que incluyera usuario o la dirección necesitaría otras etiquetas.

4. ¿En qué zona horaria se registran los eventos? ¿Por qué importa al reconstruir una cronología?

Se registran en América/Los Angeles, es importante reconstruir una cronología porque durante una auditoría o análisis forense es necesario correlacionar las estampas de tiempo de postgresql con los registros de otros sistemas, y si las zonas horarias no están claras o alineadas, es muy difícil establecer el orden exacto en el que sucedieron los eventos o incidentes.

5. Con logging\_collector \= off, ¿quién decide dónde termina la bitácora: PostgreSQL o el mecanismo con que se desplegó el servidor?

En esta configuración, postgresql recopila los mensajes y los almacena en archivos. El destino se determina mediante parámetros como log\_directory y log\_filename.

