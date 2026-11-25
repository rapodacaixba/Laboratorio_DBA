## 1. Despliegue, edición y limitación

El laboratorio se realizó en Windows 11 utilizando Docker Desktop y un contenedor basado en la imagen oficial mongo:7. El contenedor utilizado fue dba-u3-mongo, al cual se publicó el puerto 27017 para permitir conexiones desde el equipo local.

El servidor se inició con la opción --auth, habilitando el control de acceso. Se utilizaron dos cuentas: admin, con privilegios administrativos, y app_ventas, con el rol readWrite sobre la base de datos comercial.

La versión del servidor se verificó mediante db.version(), obteniendo como resultado **MongoDB 7.0.48**. También se consultó db.adminCommand({ buildInfo: 1 }).modules, que devolvió un arreglo vacío ([]). Esta evidencia permitió identificar que se estaba utilizando MongoDB Community Edition.

La principal limitación identificada es que **MongoDB Community no incluye auditoría nativa**. Esta funcionalidad está disponible en MongoDB Enterprise y en MongoDB Atlas bajo las condiciones indicadas en la documentación del laboratorio. Por lo tanto, no fue posible utilizar un mecanismo nativo que registre de forma integral los eventos de seguridad y autorización.

En su lugar, se trabajó con el perfilador de base de datos y la bitácora de mongod, reconociendo que ambos mecanismos aportan trazabilidad, pero no sustituyen la auditoría nativa.

## 2. Perfilador

El perfilador de MongoDB registra información sobre las operaciones ejecutadas en una base de datos dentro de la colección system.profile.

Se identificaron tres niveles de configuración:

- **Nivel 0:** perfilador desactivado.
- **Nivel 1:** registra operaciones que superan el umbral slowms o que cumplen un filtro.
- **Nivel 2:** registra todas las operaciones.

Inicialmente, el perfilador se encontraba desactivado (was: 0). Esto permitió comprobar que una modificación realizada por la aplicación no generaba un registro en system.profile.

Posteriormente, se habilitó el nivel 2 en la base comercial. Con ello se registraron operaciones de consulta, actualización y eliminación ejecutadas por app_ventas.

Entre los datos observados se encontraron:

- Tipo de operación (op).
- Colección afectada (ns).
- Comando ejecutado (command).
- Usuario autenticado (user).
- Cliente (client).
- Aplicación (appName).
- Fecha y hora (ts).
- Duración y cantidad de documentos afectados, cuando estaban disponibles.

En la Actividad 4 se aplicó un filtro para registrar únicamente operaciones insert, update y remove. Se comprobó que una consulta find dejó de aparecer, mientras que la actualización del teléfono de un cliente sí quedó registrada.

El filtro redujo el volumen de información, pero también provocó que ciertas operaciones dejaran de generar evidencia en el perfilador.

**Interpretación del costo:** el nivel 2 ofrece mayor visibilidad, pero puede afectar el rendimiento y aumentar el consumo de almacenamiento porque registra todas las operaciones. Por esta razón, no debe mantenerse sin evaluar la carga del servidor, la sensibilidad de los datos y las necesidades de seguimiento de la organización.

Además, system.profile es una colección limitada de tamaño predeterminado de 1 MB. Cuando se llena, los documentos antiguos pueden sobrescribirse. Esto significa que la evidencia puede desaparecer por el funcionamiento normal del mecanismo, sin que alguien la elimine manualmente.

## 3. Bitácora de mongod

La bitácora de mongod registra eventos relacionados con el funcionamiento del servidor, las conexiones, las autenticaciones y los cambios de configuración.

En este despliegue con contenedor Docker, se identificó que la bitácora se encontraba disponible en la salida estándar del proceso, por lo que podía consultarse mediante los registros del contenedor. También se utilizó el comando getLog desde mongosh para recuperar los eventos recientes:

db.adminCommand({ getLog: "global" })

Para facilitar su análisis se definió la función auxiliar bitacora(), que convierte las líneas JSON en objetos consultables.

Durante la Actividad 5 se generaron dos intentos fallidos de autenticación:

1. Un intento con el usuario app_ventas y una contraseña incorrecta. La bitácora mostró el error AuthenticationFailed, con código de resultado 18.
2. Un intento con el usuario usuario_inexistente. La bitácora mostró UserNotFound, con código de resultado 11.

También se identificó un acceso exitoso de app_ventas, asociado con la aplicación app-ventas-web.

Estos resultados demostraron que la bitácora permite distinguir accesos exitosos y fallidos, así como consultar el usuario, el cliente, la aplicación y el contexto de conexión cuando esos atributos están disponibles.

En la Actividad 6 se analizaron eventos Profiler settings changed. Estos eventos mostraron el cambio de configuración del perfilador, pero no incluían directamente el nombre del usuario. Para identificar al posible responsable se relacionó el campo ctx con el evento de autenticación de la misma conexión.

Esta correlación debe interpretarse con precaución: solo es válida si ambos eventos pertenecen al mismo periodo de ejecución del servidor y no hubo un reinicio que pudiera provocar la reutilización de identificadores de conexión.

La bitácora también tiene limitaciones de conservación. El comando getLog devuelve los 1024 eventos más recientes que el servidor mantiene en memoria y esa memoria se vacía al reiniciar. Por ello, no debe confundirse la consulta de eventos recientes con un sistema de conservación permanente.

## 4. Privilegios

Uno de los principales límites identificados en MongoDB Community fue la falta de evidencia directa y completa sobre los cambios de privilegios.

El perfilador registra operaciones de base de datos, pero no debe suponerse que registra todos los cambios administrativos de autorización. De igual forma, la bitácora de mongod no proporcionó en las pruebas realizadas un evento directo que permitiera identificar el cambio de rol de app_ventas.

Como control compensatorio, el laboratorio propone utilizar instantáneas periódicas de privilegios. Estas almacenan el estado de los usuarios y sus roles en distintos momentos, permitiendo comparar las diferencias entre una captura y otra.

Este mecanismo puede demostrar que un privilegio cambió y qué rol apareció o desapareció entre dos instantáneas. Sin embargo, no permite identificar con certeza quién realizó el cambio ni el momento exacto en que ocurrió: únicamente permite delimitar que sucedió entre las dos capturas.

**Estado de esta sección:** falta incorporar los resultados de la Actividad 7, incluyendo las dos instantáneas, la comprobación de los registros del perfilador y de la bitácora, y la revocación del rol temporal. No se debe afirmar que el control compensatorio quedó aplicado hasta verificar esas evidencias.

## 5. Conservación

La conservación de evidencia es importante porque los registros pueden perderse por el funcionamiento normal del servidor o por acciones administrativas.

Durante el laboratorio se identificaron los siguientes riesgos:

- La colección system.profile tiene un tamaño limitado y puede sobrescribir los documentos más antiguos.
- El perfilador configurado mediante db.setProfilingLevel() no conserva necesariamente su nivel después de reiniciar el servidor.
- La memoria consultada mediante getLog contiene únicamente los eventos recientes y se vacía al reiniciar.
- Aplicar filtros puede impedir que determinadas operaciones queden registradas.
- Eliminar system.profile antes de exportarla provoca la pérdida de los documentos que contenía.

Para conservar evidencia, el laboratorio establece la exportación de system.profile a JSON y de la bitácora de mongod a un archivo de texto. También solicita calcular el hash SHA-256 de los archivos exportados para comprobar su integridad.

**Estado de esta sección:** deben incorporarse los nombres y resultados reales de los archivos exportados (system-profile.json y bitacora-mongod.log), así como los hashes obtenidos en hashes.sha256. Hasta verificar que esos archivos existen y contienen los registros esperados, no se considera terminada la exportación.

## 6. Comparación

La comparación entre PostgreSQL, MongoDB Community y MongoDB Enterprise/Atlas permite observar que la capacidad de auditoría depende de los mecanismos disponibles en cada edición y de la configuración aplicada.

| Evento | PostgreSQL (bitácora y disparador) | MongoDB Community | MongoDB Enterprise/Atlas |
|---|---|---|---|
| Acceso exitoso | Pendiente de integrar con LAB-01 | Sí, observado en la bitácora | Documentado, no practicado |
| Acceso fallido | Pendiente de integrar con LAB-01 | Sí, observado en la bitácora | Documentado, no practicado |
| Cambio de privilegios | Pendiente de integrar con LAB-01 | Parcial: requiere instantáneas; no se obtuvo evento directo | Documentado, no practicado |
| Cambio de estructura | Pendiente de integrar con LAB-01 | No demostrado en las pruebas realizadas | Documentado, no practicado |
| Modificación de datos | Pendiente de integrar con LAB-01 | Sí, observado mediante system.profile | Documentado, no practicado |
| Valor anterior del dato | Pendiente de integrar con LAB-01 | No: el perfilador no conserva por sí solo el valor anterior | Depende del evento y de la configuración de auditoría |
| Lectura de datos sensibles | Pendiente de integrar con LAB-01 | Parcial: se registraron consultas con nivel 2, pero no constituye auditoría de seguridad | Documentado, no practicado |
| Cambio de configuración del registro | Pendiente de integrar con LAB-01 | Parcial: se observó el cambio del perfilador y se correlacionó mediante ctx | Documentado, no practicado |

En MongoDB Community se comprobó que el perfilador y la bitácora aportan información útil para reconstruir ciertas operaciones y accesos. Sin embargo, no proporcionan una cobertura completa de los eventos de seguridad.

La auditoría nativa de Enterprise/Atlas está documentada en el material del laboratorio, pero no se practicó directamente en este entorno.

La columna de PostgreSQL debe completarse con los resultados y evidencias reales del LAB-01, evitando asumir que todos los eventos quedaron registrados.

## 7. Recomendación

Para una organización que necesita auditar cambios de privilegios en MongoDB, recomendaría utilizar una edición que disponga de auditoría nativa, como MongoDB Enterprise o MongoDB Atlas, después de evaluar sus costos, requisitos operativos y necesidades de seguridad.

La recomendación se basa en que MongoDB Community no dispone de auditoría nativa y las pruebas realizadas mostraron que el perfilador y la bitácora no proporcionan evidencia directa y completa de los cambios de privilegios.

Como medida complementaria, también recomendaría mantener un control de cambios de autorización, utilizar cuentas individuales para los administradores, restringir quién puede modificar roles y conservar los registros fuera del servidor mediante exportaciones periódicas y controles de integridad.

**Hechos verificados en el laboratorio:**

- El servidor utilizado fue MongoDB Community 7.0.48.
- La consulta de buildInfo.modules devolvió un arreglo vacío.
- Se observaron accesos exitosos y fallidos en la bitácora.
- El perfilador registró operaciones de consulta, actualización y eliminación cuando se utilizó el nivel 2.
- Los cambios de configuración del perfilador pudieron relacionarse con una conexión mediante ctx.
- No se obtuvo evidencia directa de cambios de privilegios en las fuentes consultadas.

**Aspectos que deben tratarse como recomendación y no como pruebas realizadas:**

- La adopción de Enterprise o Atlas.
- La implementación de un sistema externo de conservación y monitoreo.
- La periodicidad de las instantáneas y las políticas de aprobación de cambios.

La decisión final debe considerar el presupuesto, el volumen de operaciones, la sensibilidad de los datos y los requisitos de auditoría de la organización.

## 8. Preguntas de reflexión

### 1. ¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?

Porque fue diseñado principalmente para analizar el desempeño de las operaciones de la base de datos, no para registrar de manera integral los eventos de seguridad. Aunque permite conocer operaciones, usuarios y aplicaciones, no garantiza que todos los cambios administrativos o de autorización queden registrados. Por ello, presentarlo como auditoría de seguridad podría generar una falsa sensación de control.

### 2. ¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?

Porque conserva información que permite reconstruir parte de la actividad realizada en una base de datos. Por ejemplo, registra el tipo de operación, la colección afectada, el usuario, el cliente, la aplicación y el momento en que se ejecutó. Estos datos ayudan a investigar modificaciones y consultas, aunque no cubran todos los eventos que requiere una auditoría de seguridad.

### 3. ¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?

El nivel 2 registra todas las operaciones, incluyendo consultas cuyos filtros pueden contener información personal o sensible. Si esos documentos se almacenan sin protección, una persona con acceso a system.profile o a sus exportaciones podría conocer criterios de búsqueda, identificadores u otros datos que deberían mantenerse restringidos. Además, el registro de todas las operaciones aumenta el volumen de información y puede afectar el rendimiento.

### 4. ¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?

Detectar un cambio significa comprobar que un dato, una configuración o un privilegio es diferente respecto a un estado anterior. Atribuirlo significa contar con evidencia suficiente para identificar quién realizó la acción, cuándo ocurrió y desde qué conexión o aplicación. Las instantáneas de privilegios, por ejemplo, permiten detectar diferencias, pero no necesariamente identificar al responsable ni el momento exacto del cambio.

### 5. ¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?

Porque el DBA debe comunicar con honestidad qué puede demostrar el sistema y qué información no está disponible. Ocultar una limitación puede provocar decisiones incorrectas, investigaciones incompletas o una falsa confianza en los controles de seguridad. Reconocerla permite proponer medidas compensatorias, mejorar la configuración y recomendar herramientas adecuadas para las necesidades de la organización.

## 9. Conclusión

El laboratorio permitió comprobar que MongoDB Community dispone de mecanismos útiles para observar operaciones y eventos del servidor, principalmente mediante el perfilador y la bitácora de mongod. Estos mecanismos permiten obtener información sobre consultas, modificaciones, eliminaciones y autenticaciones.

Sin embargo, también se identificó que su alcance es limitado para fines de auditoría de seguridad, especialmente al investigar cambios de privilegios. Las instantáneas periódicas pueden funcionar como control compensatorio, pero no sustituyen una auditoría nativa porque no proporcionan por sí mismas una atribución completa del responsable y del momento del cambio.

Por lo tanto, la trazabilidad debe planearse antes de que ocurra un incidente, configurando los mecanismos disponibles, protegiendo la información registrada y estableciendo procedimientos de conservación. La elección de una edición con auditoría nativa debe considerarse cuando la organización necesite evidencia más completa de sus eventos de seguridad.