**LAB-04 — Informe de hardening y configuración segura de PostgreSQL 16**

1. ¿Cuál era la principal superficie de ataque?

La superficie de ataque estaba formada por las interfaces de escucha, el puerto de PostgreSQL, las reglas de pg\_hba.conf, las cuentas de usuario, los privilegios, los métodos de autenticación y los archivos de configuración. Estos componentes deben revisarse porque pueden permitir conexiones o accesos no autorizados si están configurados de manera inadecuada.

2. ¿Qué configuración representaba el mayor riesgo?

Una configuración que permitiera conexiones desde cualquier dirección, combinada con una aplicación que utilizara una cuenta administrativa, representaría un riesgo elevado, esto aumentaría la exposición del servidor y el impacto de una posible vulnerabilidad o filtración de credenciales.

3. ¿Qué cambio produjo la mayor reducción de exposición?

Restringir las conexiones a las interfaces y redes necesarias puede reducir considerablemente la exposición del servicio cuando existen accesos demasiado amplios, esta medida debe acompañarse de reglas de acceso adecuadas y de privilegios mínimos.

4. ¿Qué diferencia existe entre firewall y pg\_hba.conf?

El firewall controla qué conexiones de red pueden llegar al servidor y a su puerto, por su parte, pg\_hba.conf determina qué conexiones pueden autenticarse en PostgreSQL según el tipo de conexión, la base de datos, el usuario, el origen y el método de autenticación. Ambos controles se complementan.

5. ¿Qué diferencia existe entre autenticación y autorización?

La autenticación verifica la identidad del usuario que intenta conectarse, la autorización determina qué operaciones puede realizar después de autenticarse, como consultar tablas, insertar registros o modificar información.

6. ¿Por qué una cuenta de aplicación no debe ser SUPERUSER?

Una aplicación normalmente solo necesita permisos para realizar operaciones específicas sobre determinadas tablas o esquemas, si su cuenta tiene privilegios de superusuario y la aplicación es comprometida, el atacante podría obtener un nivel de acceso mucho mayor del necesario, por eso se recomienda utilizar cuentas de aplicación con privilegios mínimos.

7. ¿Por qué cambiar el puerto de PostgreSQL no constituye hardening suficiente?

Cambiar el puerto puede reducir algunos intentos automáticos dirigidos al puerto predeterminado, pero no elimina las vulnerabilidades ni restringe por sí mismo los privilegios o los orígenes autorizados, la seguridad requiere controles de red, autenticación, autorización y configuración.

8. ¿Por qué listen\_addresses='\*' puede ser innecesario?

Este valor hace que PostgreSQL escuche en todas las interfaces disponibles, si el servicio solo necesita aceptar conexiones locales o desde una red específica, escuchar en otras interfaces puede aumentar innecesariamente la exposición del servidor.

9. ¿Qué papel tiene el sistema operativo en la seguridad de PostgreSQL?

El sistema operativo controla los permisos de los archivos de configuración, el directorio de datos y los procesos del servicio, una asignación correcta de propietarios y permisos ayuda a impedir que usuarios no autorizados lean, modifiquen o eliminen archivos sensibles.

10. ¿Qué controles deberían revisarse periódicamente?

Se deben revisar las reglas de pg\_hba.conf, las interfaces de escucha, el puerto, los roles y privilegios, las cuentas administrativas y de aplicación, la autenticación, TLS, las extensiones instaladas, los límites de conexiones, los registros, los permisos del sistema operativo y las actualizaciones de seguridad.

**Reflexión**  
Si recibiera la responsabilidad de asegurar un servidor PostgreSQL que ya se encuentra funcionando en producción, primero evaluaría su exposición de red, las cuentas existentes y los privilegios asignados, antes de modificar la configuración, identificaría las dependencias de las aplicaciones, los requisitos de disponibilidad y los procedimientos de respaldo y recuperación, si detectara que el servidor acepta conexiones desde orígenes que no necesita, priorizaría planificar una restricción de acceso para permitir únicamente las conexiones autorizadas, este cambio puede reducir la exposición, pero tendría que probarse y aplicarse de forma controlada para evitar bloquear a usuarios o aplicaciones legítimas. También revisaría si las aplicaciones utilizan cuentas administrativas, porque ese problema puede aumentar considerablemente el impacto de un incidente, la autenticación fuerte debe complementarse con privilegios mínimos, controles de red, protección de archivos y monitoreo, elegiría este orden porque primero necesito conocer el riesgo y el impacto de cada cambio, reducir la exposición sin afectar la continuidad del servicio y mantener una forma de recuperación si ocurre un problema, documentaría los resultados y verificaría que las aplicaciones continúen funcionando correctamente, esta propuesta considera el riesgo, la exposición, el impacto, la disponibilidad, la continuidad, los privilegios, la autenticación y la red.  
