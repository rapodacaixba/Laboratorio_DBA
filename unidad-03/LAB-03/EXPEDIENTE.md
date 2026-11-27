# Expediente de auditoría interna — Base comercial

**Organización:** Comercializadora Norte S.A. de C.V.  
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** III — Auditoría, trazabilidad y gobierno práctico de datos  
**Laboratorio:** LAB-03  
**Responsable del expediente:** Administrador de bases de datos (DBA)  
**Periodo revisado:** Actividades realizadas en LAB-01, LAB-02 y LAB-03 durante octubre y noviembre de 2026


## 1. Alcance

El presente expediente integra las evidencias técnicas y documentales de la base comercial de Comercializadora Norte S.A. de C.V. Su propósito es demostrar qué datos existen, quién es responsable de ellos, qué mecanismos de auditoría se utilizan, qué cambios se realizaron y cuáles son las limitaciones conocidas de los controles.

Los sistemas considerados son:

| Sistema | Versión y despliegue | Base de datos |
|---|---|---|
| PostgreSQL | 17.11 — Instalación local en Windows (puerto 5433) | comercial |
| MongoDB | 7.0.48 — Contenedor Docker en Windows (dba-u3-mongo) | comercial |

Las herramientas y versiones auxiliares (como mongosh 2.14.2 y el servicio postgresql-x64-17) se documentan en el README.md.

El alcance incluye las tablas de clientes, auditoría de cambios, solicitudes de cambio, bitácoras de PostgreSQL y MongoDB, y los registros del perfilador de MongoDB.

- **Periodo de revisión:** octubre y noviembre de 2026, de acuerdo con las evidencias disponibles de los laboratorios.
- **Limitación:** este expediente corresponde al entorno académico y no representa una auditoría completa de un sistema productivo real.


## 2. Configuración de auditoría (A3)

### PostgreSQL

En PostgreSQL se utilizaron los mecanismos configurados en LAB-01:

- Registro de eventos mediante el colector de bitácoras (logging_collector)
- Configuración de log_statement para registrar sentencias de modificación, de acuerdo con la configuración aplicada en LAB-01
- Prefijo de las líneas de registro (log_line_prefix) para identificar fecha y hora
- Vista dba.bitacora para consultar y analizar las líneas de la bitácora
- Tabla auditoria.cambios_clientes y disparador trg_auditoria_clientes para registrar modificaciones realizadas sobre los datos de clientes

**Evidencias relacionadas:**
- evidencias/E1-configuracion-registro.txt: configuración vigente de registro
- evidencias/E3-disparadores.txt: estado de los disparadores
- evidencias/E4-muestra-auditoria.txt: muestra de eventos de auditoría
- evidencias/E5-bitacora-postgresql.log: bitácora exportada y sanitizada
- evidencias/E5-bitacora-postgresql.sha256: hash SHA-256 del archivo exportado

### MongoDB

En MongoDB se utilizaron los mecanismos preparados en LAB-02:

- Bitácora del servidor mongod (bitacora-mongod.log)
- Perfilador de operaciones mediante system.profile (system-profile.json)
- Instantáneas de privilegios para comparar los permisos existentes
- Registros de autenticación y operaciones observadas durante las actividades

**Evidencias relacionadas:**
- evidencias/E6-mongodb/system-profile.json`
- evidencias/E6-mongodb/bitacora-mongod.log
- Hashes de los archivos anteriores
- Comparación de la Actividad 9 del LAB-02

La disponibilidad de auditoría nativa de MongoDB Enterprise no se considera un mecanismo implementado en este laboratorio.



## 3. Bitácora interpretada (A3, A5)

Se revisaron eventos relacionados con modificaciones de datos, mecanismos de auditoría y operaciones realizadas en MongoDB.

### Evento 1. Modificación del RFC de María García

- **Quién:** Usuario administrador de PostgreSQL (`postgres`), de acuerdo con el escenario de manipulación de LAB-01 (confirmar en la bitácora real).
- **Cuándo:** `[PENDIENTE: fecha y hora exactas de la línea en dba.bitacora / E5-bitacora-postgresql.log]`
- **Desde dónde:** `[PENDIENTE: dirección IP, host o aplicación registrada en la bitácora]`
- **Qué ocurrió:** Se ejecutó una modificación del RFC del cliente identificado con `id = 3`, utilizando la sentencia `UPDATE clientes SET rfc='GAMA780912GHI' WHERE id=3`, mientras el disparador de auditoría estaba deshabilitado.
- **Tipo de evento:** Modificación de datos y manipulación del mecanismo de auditoría.
- **Qué prueba:** Bitácora de PostgreSQL y cronología de manipulación del LAB-01; consultar también `auditoria.cambios_clientes` para comprobar si existe un evento correspondiente.

**Interpretación:** La modificación representa un incidente importante porque el cambio del RFC se realizó mientras el disparador de auditoría estaba deshabilitado. Por lo tanto, la tabla `auditoria.cambios_clientes` puede no contener evidencia de esa modificación. La bitácora general de PostgreSQL permite investigar la sentencia ejecutada y relacionarla con la desactivación del disparador.

### Evento 2. Desactivación del disparador de auditoría

- **Quién:** `[PENDIENTE: usuario(s) en la bitácora real; en referencia de LAB-01 figuran app_ventas y postgres]`
- **Cuándo:** `[PENDIENTE: fecha y hora de las líneas reales en dba.bitacora / E5-bitacora-postgresql.log]`
- **Desde dónde:** `[PENDIENTE: aplicación o dirección registrada, si está disponible]`
- **Qué ocurrió:** Se ejecutó `ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes`.
- **Tipo de evento:** Cambio de estructura/configuración que afecta el mecanismo de auditoría.
- **Qué prueba:** Bitácora de PostgreSQL y evidencia del estado del disparador en `evidencias/E3-disparadores.txt`.

**Interpretación:** La desactivación del disparador es un hallazgo de severidad alta porque permite que se realicen modificaciones en los datos de clientes sin generar necesariamente los eventos esperados en la tabla de auditoría. Debe investigarse quién realizó la acción, por qué se ejecutó y si existía autorización. Los números de línea y usuarios definitivos deben verificarse en la bitácora del entorno revisado.

### Evento 3. Cambio autorizado CAM-2026-014

- **Quién:** Solicitado por Gerencia Comercial y aprobado por el Comité de cambios; ejecutor técnico: [PENDIENTE: usuario en bitácora]
- **Cuándo:** [PENDIENTE: fecha y hora real registrada en la bitácora, verificando que caiga dentro de ventana_inicio y ventana_fin]
- **Desde dónde:** [PENDIENTE: aplicación o dirección registrada, si está disponible]
- **Qué ocurrió:** Se registró la solicitud CAM-2026-014 para agregar la columna canal_alta a la tabla clientes (ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20))
- **Tipo de evento:** Cambio de estructura autorizado
- **Qué prueba:** Registro gobierno.solicitudes_cambio, comentario de la columna y línea ALTER TABLE en dba.bitacora

**Interpretación:** Este cambio cuenta con una solicitud documentada y una ventana de ejecución. Para considerarlo conciliado debe comprobarse que la sentencia ejecutada coincide con la descripción y que su hora corresponde a la ventana autorizada.

### Evento 4. Actualización de teléfono en MongoDB

- **Quién:** Usuario app_ventas, mediante la aplicación app-ventas-web
- **Cuándo:** 13 de noviembre de 2026, a las 22:02:47.543 UTC, según el registro del perfilador de LAB-02
- **Desde dónde:** Aplicación app-ventas-web ([PENDIENTE: completar dirección/conexión si figura en system-profile.json o bitacora-mongod.log])
- **Qué ocurrió:** Se actualizó el teléfono del cliente identificado con _id: 1 a 6670000000
- **Tipo de evento:** Modificación de datos en MongoDB
- **Qué prueba:** system-profile.json y bitacora-mongod.log del LAB-02

**Interpretación:** El perfilador permitió identificar la operación de actualización y relacionarla con la autenticación exitosa de `app_ventas`, registrada aproximadamente dos milisegundos antes. Esto demuestra la utilidad de combinar registros de autenticación y perfilado para reconstruir una operación.


## 4. Elementos de gobierno (A1, A2)

El gobierno práctico de datos se documentó mediante responsables, catálogo y diccionario.

### Responsables

- **Propietario:** decide la finalidad del dato, quién puede acceder y cuándo se corrige o elimina.
- **Custodio:** administra y protege técnicamente el dato.
- **Usuario:** utiliza la información para una finalidad autorizada.

Para los datos de clientes, la matriz de la Unidad II identifica a las áreas responsables según el campo (por ejemplo, Facturación para el RFC y Atención al cliente para los datos de contacto). El DBA actúa como custodio técnico y no como propietario de todos los datos.

- **Evidencia:** evidencias/02-responsables.md

### Catálogo de datos

Se identificaron cinco conjuntos de datos:

1. public.clientes — PostgreSQL.
2. auditoria.cambios_clientes — PostgreSQL.
3. gobierno.solicitudes_cambio — PostgreSQL.
4. Colección clientes — MongoDB.
5. Colección system.profile — MongoDB.

En PostgreSQL, el inventario técnico obtuvo los siguientes valores:

| Esquema.Tabla | Propietario técnico | Filas estimadas / Tamaño |
|---|---|---|
| auditoria.cambios_clientes | postgres | 10 filas / 32 kB |
| public.clientes | postgres | 7 filas / 24 kB |

La descripción de public.clientes identifica a Gerencia Comercial como propietaria, al DBA como custodio y clasifica la información como confidencial. El propietario técnico postgres no debe confundirse con el propietario organizacional.

- **Evidencia:** evidencias/04-catalogo.md.

### Diccionario de datos

Se documentó el significado de las columnas de public.clientes mediante comentarios COMMENT en PostgreSQL y se exportó el diccionario a CSV. Permite identificar nombres de columnas, tipos de datos, nulabilidad, longitud, descripciones funcionales, clasificación y finalidad de los campos.

- **Evidencias:** evidencias/03-diccionario.md, evidencias/diccionario-clientes.csv, sql/02-comentarios-diccionario.sql.


## 5. Conservación (A3)

Se elaboró un criterio de conservación para siete tipos de registros:

1. Accesos de PostgreSQL.
2. Cambios de privilegios y estructura.
3. Modificaciones de datos.
4. Tabla auditoria.cambios_clientes.
5. Bitácora de mongod.
6. Colección system.profile.
7. Instantáneas de privilegios de MongoDB.

Los periodos documentados son propuestas académicas internas y no plazos legales confirmados. Cuando exista una obligación normativa o fiscal, el periodo deberá confirmarse con el área jurídica.

Las bitácoras exportadas deberán protegerse mediante controles de acceso y mecanismos de integridad, como el hash SHA-256. La conservación de registros que contienen datos personales deberá coordinarse con las obligaciones de protección y eliminación de información.

- **Evidencia:** evidencias/05-conservacion.md.


## 6. Políticas (A4)

Se definieron seis políticas prácticas:

| Política | Tema | Propósito |
|---|---|---|
| POL-01 | Acceso a datos | Controlar solicitudes, autorizaciones y revisiones de permisos. |
| POL-02 | Respaldo de datos | Establecer qué información debe respaldarse y quién verifica los respaldos. |
| POL-03 | Retención | Definir criterios de conservación y acciones al vencer los periodos. |
| POL-04 | Restauración | Establecer autorización y verificación de recuperaciones. |
| POL-05 | Datos sensibles | Limitar el acceso y uso de información personal. |
| POL-06 | Cambios en producción | Exigir solicitudes, aprobaciones, ventanas y conciliación de cambios. |

Las políticas establecen reglas de decisión y evidencias verificables. Los procedimientos técnicos de respaldo y restauración se desarrollarán en la Unidad V.

- **Evidencias:** politicas/POL-01-acceso.md a politicas/POL-06-cambios-produccion.md.


## 7. Conciliación de cambios (A5)

Se creó el esquema gobierno y la tabla gobierno.solicitudes_cambio para documentar las modificaciones en producción. La solicitud CAM-2026-014 documenta la incorporación de la columna canal_alta a public.clientes, solicitada por Gerencia Comercial y aprobada por el Comité de cambios.

La conciliación compara:
- La solicitud y su folio.
- El usuario y la sentencia registrados en la bitácora.
- La fecha y hora de ejecución.
- La ventana autorizada.
- El resultado del cambio.

Los eventos sin folio deben revisarse y clasificarse como actividades de preparación, cambios autorizados con evidencia externa o posibles cambios no autorizados. La desactivación del disparador de auditoría requiere especial atención por su impacto en la trazabilidad.

- **Evidencias:** sql/04-registro-cambios.sql, evidencias/06-conciliacion.md, evidencias/E5-bitacora-postgresql.log.
- **Limitación:** La conciliación no puede garantizar que todos los cambios históricos estén registrados si hubo periodos en los que log_statement estuvo configurado en none.



## 8. Hallazgos

- **H-01 — Posible duplicidad de correo en registros de clientes** *(Fuente: Actividad 1, evidencias/01-calidad.md | Severidad: Media | Decisión: Gerencia Comercial)*: Puede provocar duplicidad de clientes y errores de comunicación. Revisar registros y establecer regla de unicidad con aprobación del propietario del dato.
- **H-02 — RFC ausente o con formato no válido** *(Fuente: Actividad 1, evidencias/01-calidad.md | Severidad: Alta | Decisión: Facturación)*: Puede afectar identificación y facturación. Solicitar validación y corrección al responsable de Facturación conservando evidencia del cambio.
- **H-03 — Desactivación del disparador de auditoría** *(Fuente: LAB-01, Actividad 14; bitácora PostgreSQL | Severidad: Alta | Decisión: Seguridad TI y Auditoría Interna)*: Puede permitir modificaciones sin registro en auditoria.cambios_clientes. Restringir quién puede alterar disparadores y revisar eventos de desactivación.
- **H-04 — Modificación del RFC de María García con disparador deshabilitado** *(Fuente: LAB-01, bitácora y cronología del incidente | Severidad: Alta | Decisión: Auditoría Interna y Facturación)*: Pérdida de trazabilidad en la tabla de auditoría para ese evento. Investigar, conservar bitácora y evitar desactivaciones no autorizadas.
- **H-05 — Cambios de privilegios o estructura sin folio asociado** *(Fuente: Actividad 7, evidencias/06-conciliacion.md | Severidad: Media o Alta según conciliación | Decisión: Comité de cambios)*: No se puede demostrar autorización previa únicamente por la bitácora. Exigir solicitudes previas y conciliación independiente; no asumir automáticamente que todo evento sin folio es no autorizado.
- **H-06 — Periodos sin registro suficiente por log_statement** *(Fuente: E1 y bitácora PostgreSQL | Severidad: Media | Decisión: DBA y Seguridad TI)*: Posible imposibilidad de reconstruir cambios históricos. Mantener configuración aprobada y conservar evidencia histórica de cambios de configuración.
- **H-07 — Limitaciones de auditoría de MongoDB Community** *(Fuente: LAB-02, comparación Actividad 9 | Severidad: Media | Decisión: Seguridad TI)*: Ausencia de auditoría nativa Enterprise. Documentar riesgo y evaluar controles complementarios.
- **H-08 — Riesgo de exposición de datos personales o secretos en bitácoras** *(Fuente: LAB-01 y E5 | Severidad: Alta | Decisión: DBA y Seguridad TI)*: Exportaciones sin revisión pueden divulgar secretos o datos personales. Restringir acceso, revisar y sanitizar antes de compartir.

**Nota:** Los hallazgos deben conservarse en el expediente aunque posteriormente sean corregidos.


## 9. Limitaciones conocidas y riesgos aceptados (A6)

| Limitación o riesgo | Situación | Aceptación formal requerida |
|---|---|---|
| Auditoría nativa de MongoDB Community | No se implementó auditoría Enterprise; se usaron bitácora y perfilador | Responsable del servicio y Seguridad TI |
| Lecturas no auditadas en PostgreSQL | No se implementó pgaudit; cobertura parcial de lecturas | Seguridad TI y propietario de los datos |
| Desactivación de disparadores | Roles con privilegios pueden desactivar trg_auditoria_clientes | Seguridad TI y Auditoría Interna |
| Huecos históricos de bitácora | Si log_statement estuvo en none, faltan sentencias históricas | Auditoría Interna y responsable del servicio |
| Datos sensibles en registros | Las bitácoras pueden contener datos personales o secretos | Protección de datos y Seguridad TI |
| Conservación pendiente de validación | Periodos propuestos sujetos a revisión jurídica | Área jurídica y propietarios de datos |

La auditoría nativa de MongoDB Enterprise y pgaudit no deben presentarse como implementadas. La existencia de una limitación no equivale a su aceptación institucional formal.


## Conclusión general

El laboratorio permitió integrar mecanismos de auditoría con elementos de gobierno práctico de datos. Se identificaron problemas de calidad, se documentaron responsables y conjuntos de datos, se establecieron criterios de conservación y se redactaron políticas para controlar accesos, respaldos, restauraciones, datos sensibles y cambios en producción.

La comparación entre las solicitudes de cambio y las bitácoras permite distinguir las modificaciones autorizadas de aquellas que requieren investigación. También se identificaron limitaciones relacionadas con la cobertura de auditoría, los privilegios administrativos y la conservación de información sensible.

El expediente constituye una base documental para futuras revisiones y debe mantenerse actualizado cada vez que cambien los datos, responsables, configuraciones, políticas o mecanismos de auditoría.
