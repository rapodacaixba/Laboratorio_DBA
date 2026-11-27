**POL-01 — Acceso**

Objetivo: Reducir el riesgo de accesos no autorizados y evitar que los usuarios tengan permisos superiores a los necesarios para realizar sus actividades.

Alcance: Aplica a las bases de datos PostgreSQL y MongoDB utilizadas en el laboratorio, incluyendo los datos de clientes, las tablas de auditoría, las bitácoras y los ambientes de desarrollo, pruebas y producción.

Regla:

1. Todo acceso deberá solicitarse indicando el usuario, los recursos requeridos, los privilegios necesarios y la justificación del acceso.  
2. El propietario del conjunto de datos deberá aprobar el acceso antes de que el DBA o administrador del motor otorgue los permisos.  
3. Los accesos deberán revisarse al menos cada tres meses y cuando una persona cambie de puesto o deje de requerirlos. Los permisos que ya no sean necesarios deberán retirarse.

Responsable: El propietario del dato decide y aprueba; el DBA o administrador de MongoDB ejecuta los cambios de permisos. Seguridad TI o Auditoría puede revisar el cumplimiento.

Excepciones: Los accesos de emergencia podrán otorgarse cuando exista un incidente que requiera atención inmediata. Deberán ser autorizados por el responsable de guardia o autoridad designada y documentarse posteriormente.

Evidencia: Solicitudes y aprobaciones de acceso, privilegios registrados en PostgreSQL y MongoDB, bitácoras de comandos GRANT y REVOKE de LAB-01 y resultados de la revisión periódica de permisos.

Revisión: Cada tres meses o cuando exista un cambio importante en los responsables, sistemas o necesidades de acceso.