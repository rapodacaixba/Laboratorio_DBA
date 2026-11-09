# Informe — LAB-01: Bitácoras y auditoría del dato en PostgreSQL

## 1. Despliegue y situación inicial

Para realizar el laboratorio se utilizó un equipo con sistema operativo Windows 11, se hizo uso de PostgreSQL 17.11. El servidor se configuró para trabajar mediante el puerto 5433 y se utilizó la base de datos `comercial`.

La conexión con el servidor se realizó mediante la herramienta `psql`, además de utilizar pgAdmin 4 para la administración y consulta de la base de datos. Para ejecutar comandos de terminal y organizar los archivos del laboratorio se utilizó PowerShell.

La instalación se realizó directamente en el sistema operativo, sin utilizar contenedores Docker ni máquinas virtuales.

Al revisar la configuración inicial se identificó que el colector de bitácoras estaba habilitado (`logging_collector = on`), pero el registro de conexiones y desconexiones se encontraba desactivado (`log_connections = off` y `log_disconnections = off`). También se observó que `log_statement = none`, por lo que PostgreSQL no registraba de manera general las sentencias SQL ejecutadas correctamente.

El prefijo inicial de las líneas de registro era `%t`, que únicamente permitía identificar la fecha y hora del evento, sin mostrar información como el usuario, la base de datos, la aplicación o la dirección del cliente.

Esta configuración dificultaba investigar el incidente reportado por el área de facturación, debido a que no existía suficiente información para determinar quién había modificado el RFC de una clienta, cuándo se había realizado el cambio ni cuál era el valor anterior.

Por lo tanto, se comprobó que contar con permisos y roles correctamente definidos no garantiza que exista evidencia suficiente para reconstruir las operaciones realizadas en una base de datos.

## 2. Configuración aplicada

Para mejorar la trazabilidad del servidor se modificaron distintos parámetros mediante la instrucción `ALTER SYSTEM`.
Los parámetros principales trabajados fueron los siguientes:

| Parámetro | Valor configurado | Propósito |
|---|---|---|
| `logging_collector` | `on` | Permitir que PostgreSQL almacene los registros en archivos. |
| `log_connections` | `on` | Registrar los intentos y conexiones exitosas. |
| `log_disconnections` | `on` | Registrar las desconexiones de las sesiones. |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h ` | Identificar fecha, proceso, usuario, base de datos, aplicación y cliente. |
| `log_statement` | `mod` | Registrar sentencias que modifican datos, además de las sentencias DDL. |

El parámetro `logging_collector` ya se encontraba habilitado desde la configuración inicial, por lo que no fue necesario modificarlo.
Para los parámetros de registro que admiten recarga se utilizó:
```
SELECT pg_reload_conf();
```

La recarga permitió aplicar los cambios sin reiniciar el servicio. En cambio, los parámetros que requieren reinicio, como `logging_collector` o `shared_preload_libraries`, deben tratarse de manera distinta y verificarse mediante `pending_restart`.
El parámetro `log_line_prefix` fue especialmente importante porque permitió asociar los eventos con información de la sesión que los originó. De esta manera, las líneas de la bitácora pudieron proporcionar más contexto para interpretar las operaciones realizadas.

**Configuración final verificada:** 
| name | setting | source |
|---|---|---|
| `logging_collector` | `on` | configuration file |
| `log_connections` | `on` | configuration file |
| `log_disconnections` | `on` | configuration file |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h ` | configuration file |
| `log_statement` | `mod` | configuration file |
| `log_destination` | `stderr` | configuration file |
| `log_directory` | `log` | default |
| `log_filename` | `postgresql-%Y-%m-%d_%H%M%S.log` | default |
| `log_timezone` | `America/Los_Angeles` | configuration file |

## 3. Eventos observados

Durante las pruebas se analizaron diferentes tipos de eventos para comprobar qué información puede proporcionar la bitácora del servidor.

### 3.1 Accesos exitosos y fallidos

Se realizaron conexiones con los roles existentes y también intentos de autenticación fallidos, incluyendo una prueba con un usuario inexistente.

Los registros de autenticación permiten distinguir entre una conexión autorizada y un intento rechazado. Cuando la autenticación falla, la bitácora puede mostrar el usuario solicitado, la dirección del cliente y el motivo del rechazo.

**Evidencia obtenida:** 

*Conexión exitosa:* 
2026-11-08 15:40:57.836 PST [3684] user=postgres db=comercial app=[desconocido] client=::1 LOG:  conexión autenticada: identidad=«postgres» método=scram-sha-256 (C:/Program Files/PostgreSQL/17/data/pg_hba.conf:117)


*Autenticación fallida:* 
2026-11-08 11:45:33 PST FATAL:  la autentificación password falló para el usuario «postgres»


### 3.2 Cambios de privilegios y estructura

Se realizaron operaciones `GRANT`, `REVOKE` y `ALTER TABLE` para modificar permisos y estructura de la tabla `clientes`.

Estas operaciones permiten observar cambios en los privilegios asignados a los roles y modificaciones realizadas en la estructura de la base de datos.

**Evidencia obtenida:** 

2026-10-25 22:50:09.341 UTC [119] user=postgres db=comercial app=psql client=[local] LOG:  statement: REVOKE UPDATE ON clientes FROM soporte_ana


### 3.3 Modificaciones de datos

Se realizaron actualizaciones sobre registros de la tabla `clientes`, utilizando el rol `app_ventas`.

Con la configuración de `log_statement`, las sentencias de modificación pudieron quedar registradas junto con la información de la sesión.

Sin embargo, la bitácora registra principalmente la sentencia ejecutada y no necesariamente conserva una representación estructurada del valor anterior y del nuevo valor de cada campo.

**Evidencia obtenida:** 

2026-10-25 22:50:20.601 UTC [145] user=app_ventas db=comercial app=app-ventas-web client=127.0.0.1 LOG: statement: UPDATE clientes SET telefono = '6679990000' WHERE id = 3

### 3.4 Errores y operaciones rechazadas

Se realizaron pruebas con operaciones que excedían los permisos de determinados roles y se intentó ejecutar una operación de administración que no podía completarse debido a dependencias existentes.

Los errores registrados permiten identificar qué operación fue rechazada y, dependiendo de la configuración, la sentencia que provocó el problema.

**Evidencia obtenida:** 

ERROR: no se puede eliminar el rol «soporte_ana» porque hay objetos que dependen de él

### 3.5 Estado de las sesiones

También se utilizó `pg_stat_activity` para consultar las sesiones activas, identificando información como el usuario, la aplicación, el proceso, la dirección del cliente y la consulta en ejecución.

Esto permitió observar que la vista proporciona información del estado actual de las conexiones, mientras que la bitácora conserva registros históricos de los eventos que se han producido.

## 4. Auditoría del dato

Para conservar información detallada sobre las modificaciones realizadas en la tabla `clientes`, se creó un esquema denominado `auditoria` y una tabla llamada `auditoria.cambios_clientes`.

La tabla contiene los siguientes datos:

- Identificador del evento.
- Fecha y hora de la operación.
- Usuario de la sesión.
- Usuario efectivo.
- Aplicación que originó la operación.
- Dirección IP del cliente.
- Tipo de operación.
- Identificador del cliente afectado.
- Valores anteriores y posteriores almacenados en formato JSONB.

Posteriormente, se creó la función `auditoria.registrar_cambio_cliente()` y el disparador `trg_auditoria_clientes`, encargado de ejecutar la función después de realizar operaciones `INSERT`, `UPDATE` o `DELETE` sobre la tabla `clientes`.

### 4.1 Importancia de SECURITY DEFINER

La función se configuró utilizando `SECURITY DEFINER`, lo que significa que se ejecuta con los privilegios de su propietario y no con los privilegios del usuario que inició la operación.

Esto permite que el disparador pueda insertar registros en la tabla de auditoría sin conceder directamente permisos de escritura sobre dicha tabla a los usuarios de la aplicación.

También se configuró un `search_path` controlado para reducir el riesgo de que objetos con nombres similares alteren el comportamiento de la función.

### 4.2 Diferencia entre session_user y current_user

Se utilizaron dos campos para identificar el contexto de ejecución:

- `session_user`: representa el usuario que inició la sesión y permite identificar el rol con el que se autenticó la conexión.
- `current_user`: representa el usuario efectivo durante la ejecución de la función.

Debido a que se utilizó `SECURITY DEFINER`, el valor de `current_user` dentro de la función corresponde al propietario de esta, mientras que `session_user` permite conservar la identidad del rol que originó la operación.

Esta distinción es importante porque, si únicamente se almacenara `current_user`, los cambios realizados por distintos usuarios podrían parecer ejecutados por el mismo propietario de la función.

### 4.3 Resultado del incidente auditado

Se realizó una modificación del RFC de un registro de la tabla `clientes` mediante el usuario `app_ventas`.

El disparador almacenó el evento en `auditoria.cambios_clientes`, conservando los valores anteriores y posteriores del registro.

La consulta de auditoría permitió identificar el campo modificado y comparar ambos valores mediante las operaciones JSONB.

**Resultado real del incidente:**

- Usuario de sesión: app_ventas
- Usuario efectivo: app_ventas
- Aplicación: app-ventas-web
- Cliente afectado: María García (id = 3)
- Campo modificado: rfc
- Valor anterior: 'GAMA780912XYZ'
- Valor nuevo: 'GAMA780912ZZZ'

Este resultado demuestra la utilidad de combinar la bitácora del servidor con una auditoría a nivel de dato, ya que ambas proporcionan información complementaria sobre las operaciones realizadas.

## 5. Limitaciones

Aunque la implementación permitió mejorar considerablemente la trazabilidad, se identificaron algunas limitaciones.

### 5.1 Lecturas de información

Los disparadores utilizados registran operaciones `INSERT`, `UPDATE` y `DELETE`, pero no registran consultas `SELECT`.

Por esta razón, una lectura de información sensible, como el RFC o el teléfono de un cliente, no genera un registro en la tabla de auditoría creada.

Para registrar este tipo de operaciones se requieren mecanismos adicionales, como `pgaudit`, una configuración más amplia de sentencias o funciones específicas que controlen el acceso a los datos.

### 5.2 Volumen de registros

Cuando se realiza una modificación masiva, el disparador se ejecuta por cada fila afectada. Por lo tanto, un `UPDATE` sin una cláusula `WHERE` puede generar una gran cantidad de registros en la tabla de auditoría.

Esto puede incrementar el tamaño de la base de datos y afectar el rendimiento de las operaciones.

Por esta razón, es necesario establecer políticas de conservación, respaldo y depuración de los registros.

### 5.3 Administrador con control total

Un usuario con privilegios suficientes para administrar el servidor puede modificar la configuración de registro, alterar objetos o desactivar disparadores.

Esto significa que la auditoría interna no representa una protección absoluta frente a un administrador malintencionado.

Para reducir este riesgo, las organizaciones deben separar las funciones de administración y custodia de evidencias, además de enviar las bitácoras a un sistema externo controlado por otra área.

## 6. Riesgos de la bitácora

Las bitácoras representan una fuente importante de evidencia, pero también pueden convertirse en un punto de exposición de información sensible.

Entre los riesgos identificados se encuentran:

- **Exposición de contraseñas:** determinadas sentencias o configuraciones pueden contener información confidencial.
- **Exposición de datos personales:** una sentencia registrada puede incluir RFC, teléfonos, correos u otros datos de clientes.
- **Acceso no autorizado:** si los archivos de bitácora no cuentan con permisos adecuados, terceros podrían consultar información interna.
- **Pérdida de evidencia:** la eliminación, modificación o falta de respaldo de los archivos puede impedir reconstruir un incidente.
- **Manipulación de registros:** un administrador con control total del servidor podría alterar la configuración o los archivos de registro.

Durante el laboratorio se exportó la bitácora a un archivo y se generó un hash SHA-256 para contar con una comprobación básica de integridad.

También se realizó una revisión para retirar información sensible antes de considerar compartir el archivo.

El hash permite detectar cambios posteriores en el archivo comparándolo con el valor calculado originalmente, aunque no impide que una persona con acceso al archivo y al hash pueda reemplazar ambos.

## 7. Cronología y conclusión

La cronología del laboratorio se construyó relacionando los registros de la bitácora del servidor con los eventos almacenados en la tabla `auditoria.cambios_clientes`.

Esta comparación permite distinguir los accesos, las sentencias ejecutadas y las modificaciones concretas realizadas sobre los registros de clientes.

Para reconstruir el incidente del RFC se debe considerar la primera modificación realizada antes de habilitar la auditoría a nivel de dato y compararla con los cambios posteriores que sí quedaron almacenados en la tabla de auditoría.

Cuando una operación ocurrió antes de configurar un mecanismo de registro, no es posible recuperar retroactivamente información que nunca fue almacenada. En esos casos, la investigación debe reconocer las limitaciones de la evidencia disponible.

## Conclusión

El laboratorio permitió comprobar que la administración de permisos y roles no es suficiente para garantizar la trazabilidad de las operaciones realizadas en una base de datos.
La configuración de bitácoras proporciona información sobre conexiones, sentencias, errores y eventos del servidor. Por otra parte, la implementación de una tabla de auditoría con un disparador permite conservar los valores anteriores y posteriores de los registros modificados. La combinación de ambos mecanismos mejora la capacidad de investigar incidentes, identificar el rol que originó una operación y conocer qué información fue modificada.

Sin embargo, también se comprobó que existen limitaciones relacionadas con las lecturas de datos, el volumen de registros y el control que conserva el administrador del servidor.
Por lo tanto, para contar con una auditoría confiable en un entorno real es necesario complementar los mecanismos técnicos con políticas de acceso, respaldos, conservación de evidencias y separación de funciones.

### Preguntas de reflexión

## 1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?

Porque la auditoría registra los eventos a partir del momento en que se encuentra habilitada y si ocurre un incidente antes de configurar los mecanismos de registro, los valores anteriores, las sentencias ejecutadas y la identidad de quien realizó la operación podrían no haberse conservado. No es posible recuperar automáticamente información que nunca fue registrada.

## 2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?

Porque el servidor es quien conoce directamente los eventos que ocurren durante las conexiones y operaciones, al administrar la bitácora desde el propio motor se puede mantener un registro centralizado y consistente de las actividades, independientemente de la aplicación o herramienta utilizada para conectarse. El mecanismo de despliegue no necesariamente tiene visibilidad de todas las operaciones realizadas después de iniciar el servicio.

## 3. ¿Por qué el prefijo de línea es tan importante como el nivel de log_statement?

Porque `log_statement` determina qué sentencias se registran, mientras que `log_line_prefix` proporciona el contexto necesario para interpretarlas, una sentencia registrada sin usuario, base de datos, aplicación o dirección del cliente puede ser difícil de atribuir a una sesión específica. Ambos parámetros se complementan para generar evidencia útil.

## 4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?

Registrar una sentencia permite conocer qué instrucción SQL se ejecutó, por ejemplo, un `UPDATE` sobre la tabla `clientes`. Sin embargo, no siempre permite identificar de manera estructurada el valor anterior y el nuevo de cada campo, mientras que registrar el cambio en el dato permite conservar información específica del registro afectado, incluyendo sus valores anteriores y posteriores. Esto facilita determinar exactamente qué información fue modificada.

## 5. ¿Qué evidencia ofrece pg_stat_activity que no ofrece la bitácora, y viceversa?

`pg_stat_activity` permite consultar el estado actual de las sesiones, incluyendo usuarios conectados, consultas en ejecución, aplicaciones y procesos activos. Sin embargo, no está diseñada para conservar un historial permanente de todas las operaciones.

La bitácora, en cambio, conserva eventos que ocurrieron anteriormente, lo que permite revisar conexiones, desconexiones, sentencias y errores registrados. Por lo tanto, `pg_stat_activity` sirve para observar el estado actual del servidor, mientras que la bitácora permite investigar eventos pasados.

## 6. Si el administrador puede cambiar log_statement a none y desactivar el disparador, ¿quién audita al administrador?

La actividad del administrador debe ser supervisada mediante controles independientes de su propia administración. Una alternativa es enviar las bitácoras a un servidor externo o sistema centralizado administrado por otra área, de manera que el administrador de la base de datos no tenga control total sobre las evidencias. También se deben aplicar políticas de separación de funciones, revisiones periódicas y controles de acceso para evitar que una sola persona pueda administrar la base de datos y modificar libremente los registros que permiten supervisar sus actividades.
