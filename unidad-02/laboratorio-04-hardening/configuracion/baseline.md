Baseline

Objetivo
Definir una configuración de referencia que permita reducir la exposición de PostgreSQL, proteger las credenciales, limitar los privilegios y mantener la seguridad del servidor.

Red
Interfaces autorizadas: configurar listen_addresses para utilizar únicamente las interfaces necesarias.
Puerto: documentar el puerto real de la instancia y mantenerlo registrado.
Firewall: permitir conexiones al puerto de PostgreSQL solo desde equipos y redes autorizados.
Redes permitidas: restringir las reglas de pg_hba.conf a los orígenes, usuarios y bases de datos necesarios. Evitar reglas generales cuando no sean necesarias.

Autenticación
Método: preferir scram-sha-256 cuando sea compatible con los clientes y el entorno.
Credenciales: utilizar contraseñas únicas y robustas, proteger los secretos y evitar almacenarlos directamente en el código fuente.
Cuentas administrativas: limitar las cuentas con privilegios elevados y utilizarlas únicamente para tareas administrativas.

Autorización
Roles: separar las funciones administrativas, de aplicación y de consulta.
Privilegios: conceder únicamente los permisos necesarios para cada función.
Cuentas de aplicación: utilizar cuentas exclusivas para las aplicaciones y evitar que tengan el atributo SUPERUSER.

Configuración
Parámetros: revisar listen_addresses, port, password_encryption, max_connections, superuser_reserved_connections, statement_timeout e idle_in_transaction_session_timeout.
Extensiones: mantener únicamente las extensiones necesarias y justificar su utilización.
Conexiones: revisar límites, tiempos de espera y registros para controlar el consumo de recursos y facilitar la detección de actividad sospechosa.

Sistema operativo
Propietario de archivos: comprobar que los archivos y directorios pertenezcan a la cuenta de servicio o al administrador autorizado, según el sistema operativo.
Permisos: restringir la lectura y modificación de archivos de configuración a las cuentas autorizadas.
Directorio de datos: impedir el acceso de usuarios no autorizados y proteger la información almacenada.

Cifrado
TLS: configurar TLS según los requisitos del entorno y verificar que las conexiones que lo requieren estén cifradas.
Credenciales: proteger contraseñas y secretos mediante mecanismos apropiados.
Información sensible: aplicar controles de acceso y cifrado cuando corresponda según el tipo de información y los requisitos del entorno.

Mantenimiento
Actualizaciones: revisar periódicamente las actualizaciones de seguridad y aplicarlas mediante un procedimiento controlado.
Revisión periódica: auditar reglas de acceso, roles, privilegios, extensiones, conexiones y permisos.
Documentación: registrar la configuración, los cambios, las justificaciones y las evidencias.

Estado de implementación
Esta baseline constituye una propuesta de referencia. Cada control deberá marcarse como implementado únicamente después de aplicarlo y verificarlo en el entorno correspondiente.

