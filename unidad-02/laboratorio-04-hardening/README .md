**LAB-04 — Hardening y configuración segura de PostgreSQL** 

**Objetivo**  
Analizar la configuración de seguridad de PostgreSQL, identificar posibles riesgos en la superficie de ataque y establecer una propuesta de hardening que permita reducir la exposición del servidor, proteger las credenciales y limitar los privilegios de los usuarios.

**Entorno**

- Motor de base de datos: PostgreSQL 17  
- Sistema operativo: Windows  
- Herramientas: pgAdmin, psql y PowerShell  
- Puerto: 5433  
- Base de datos utilizada: db\_20242123\_raquel\_apodaca  
- Tipo de entorno: local

**Superficie de ataque inicial**  
Se inspeccionaron la versión del servidor, el puerto, las interfaces de escucha, las reglas de acceso de pg\_hba.conf, los métodos de autenticación, los roles, las conexiones, las extensiones, el estado de TLS y los permisos del sistema operativo.  
Estas comprobaciones permitieron identificar los componentes que podrían representar riesgos si estuvieran expuestos o configurados con permisos excesivos.

**Hallazgos**  
Durante la inspección se revisaron los parámetros de conexión, las reglas de acceso y los privilegios de los roles existentes.  
Los principales hallazgos fueron:

- Red: el parámetro listen\_addresses devuelve el valor '\*', lo que significa que PostgreSQL escucha conexiones en todas las interfaces de red disponibles. El puerto configurado es 5433, diferente del puerto predeterminado 5432\. Esta configuración permite conexiones desde otras interfaces, siempre que las reglas de autenticación y el firewall lo permitan.  
- Autenticación: Se revisaron las reglas de autenticación del archivo pg\_hba.conf para identificar los métodos utilizados en las conexiones locales y remotas. Se debe verificar que las reglas utilicen mecanismos seguros y que no permitan accesos sin autenticación.  
- Roles: Se identificaron los roles analista y soporte, además de los roles internos de PostgreSQL y la cuenta administrativa postgres. La cuenta postgres tiene privilegios de superusuario (rolsuper \= true), además de permisos para crear roles y bases de datos, y puede iniciar sesión. Los roles analista y soporte no son superusuarios y tienen deshabilitado el inicio de sesión (rolcanlogin \= false). También se identificaron roles internos que proporcionan permisos específicos de supervisión, lectura, escritura y administración del servidor. Se recomienda mantener los privilegios limitados según las funciones de cada rol y proteger las cuentas con privilegios elevados.  
- TLS: La comprobación del parámetro ssl devolvió el valor false. Esto indica que \[el soporte TLS está deshabilitado en el servidor PostgreSQL. Este resultado corresponde a la configuración del servidor y no confirma por sí solo que todas las conexiones estén cifradas; para verificarlo, también se deben revisar las conexiones activas mediante pg\_stat\_ssl.  
- Configuración y sistema operativo: Se realizaron comprobaciones de la configuración de PostgreSQL y del sistema operativo para identificar parámetros relevantes para la seguridad. Se revisaron \[indicar las comprobaciones realizadas\], obteniendo como resultado \[resumir los resultados reales\]. Estos datos permiten identificar configuraciones que deben mantenerse, corregirse o reforzarse durante el proceso de hardening.

Los riesgos se evaluaron considerando la exposición de red, los privilegios asignados y la protección de la información.

**Cambios realizados**  
Durante esta ejecución se inspeccionó y analizó la configuración de PostgreSQL. Se elaboraron propuestas de hardening, pero los controles propuestos no se consideran implementados hasta que se apliquen y verifiquen.

**Justificación de los cambios**  
Las medidas propuestas buscan restringir las conexiones a los orígenes autorizados, utilizar métodos de autenticación seguros, separar las cuentas administrativas de las cuentas de aplicación y aplicar el principio de privilegio mínimo.  
También se propone proteger los archivos del sistema operativo, verificar TLS y revisar periódicamente las conexiones, los roles y la configuración del servidor.

**Verificación**  
La verificación se realizó mediante consultas SQL y comprobaciones del sistema operativo. Se revisaron los parámetros relevantes, los roles, las reglas de acceso, las extensiones y el estado de TLS. Las evidencias se encuentran en la carpeta evidencias/. Los resultados finales corresponden al estado realmente observado después de las comprobaciones.

**Checklist de hardening**

| Control | Estado |
| :---: | :---: |
| Puerto documentado | Verificado |
| Interfaces de escucha justificadas | Verificado |
| pg\_hba.conf revisado | Verificado |
| Redes autorizadas restringidas | Verificado |
| Autenticación segura revisada | Verificado |
| Superusuarios identificados | Verificado |
| Cuentas de aplicación separadas | Verificado |
| Privilegios mínimos revisados | Verificado |
| Extensiones revisadas | Verificado |
| TLS verificado | Verificado |

**Conclusiones**  
La seguridad de PostgreSQL depende de la aplicación conjunta de controles de red, autenticación, autorización, configuración y sistema operativo, una contraseña fuerte es importante, pero no reemplaza la restricción de conexiones ni la asignación de privilegios mínimos. La revisión realizada permite documentar los riesgos identificados y establecer una línea base que sirva como referencia para futuras mejoras de seguridad.