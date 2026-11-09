**Actividad 5 — Accesos exitosos y fallidos**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se verificó la capacidad de postgresql para auditar intentos de acceso exitosos y fallidos desde la red, con log\_connections y log\_disconnections, el log capturó la dirección ip de origen, la identidad alegada, la regla aplicada de pg\_hba.conf y el método de cifrado y se evidenció la diferencia entre el detalle confidencial que postgresql guarda en su bitácora interna y la respuesta genérica enviada al cliente para evitar la enumeración de usuarios.

1. La bitácora registra el usuario app\_ventas en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?

No prueba que la aplicacion real intento entrar, pero si prueba que alguien llamado app\_ventas intento iniciar sesión desde la ip 127.0.0.1, cualquier persona puede escribir el nombre de un usuario válido en su cliente de conexión, por lo tanto, un intento fallido no autenticado solo demuestra una pretensión de identidad, no la autoría del sistema

2. ¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?

La información adicional en la bitácora registra una línea especificando exactamente que la causa del fallo fue la inexistencia del usuario. Aparece en la bitácora por principios de seguridad y prevención de reconocimiento, si el servidor le respondiera al cliente "el usuario no existe", un atacante sabría qué nombres probados son inválidos y cuáles sí existen. Al devolverle al cliente un mensaje genérico, el servidor no da pistas sobre la validez de los nombres de usuario.

3. ¿Por qué app=\[unknown\] en el intento fallido, pero app=app-ventas-web en la desconexión?

Porque el parámetro application\_name es transmitido como parte del paquete de negociación del protocolo postgresql durante el proceso de autenticación. Como la autenticación falló antes de validar la sesión, la variable de aplicación no llegó a establecerse dentro del contexto de la sesión, al completar exitosamente la autenticación, postgresql establece las variables de sesión, incluyendo el application\_name, por ello, al cerrar la conexión, el servidor registra la desconexión asociándola formalmente a app-ventas-web.

4. ¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.

Muchos eventos consecutivos con severidad FATAL y mensaje password authentication failed... provenientes de la misma ip cliente en un intervalo de tiempo reducido, ya sea probando el mismo usuario repetidamente o variando nombres de usuario.

Consulta para contar intentos fallidos por usuario:

SELECT   
  substring(linea from 'user=(\[^ \]+)') AS usuario,  
  count(\*) AS intentos\_fallidos  
FROM dba.bitacora  
WHERE linea LIKE '%password authentication failed%'  
GROUP BY usuario  
ORDER BY intentos\_fallidos DESC;  
