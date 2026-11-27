**POL-06 — Cambios en producción**

Objetivo: Evitar modificaciones no autorizadas o no controladas en producción que puedan afectar la integridad, seguridad o disponibilidad de las bases de datos.

Alcance: Aplica a los cambios realizados en producción sobre las bases de datos PostgreSQL y MongoDB, incluyendo modificaciones de estructura, datos, usuarios, roles, privilegios, configuraciones y objetos de base de datos.

Regla:

1. Antes de ejecutar un cambio en producción deberá existir una solicitud documentada con folio, descripción, solicitante, responsable de aprobación, ambiente y ventana de ejecución, el cambio deberá ser aprobado por el propietario del dato o por el Comité de cambios, según corresponda.  
2. Durante la ventana autorizada, el DBA o administrador responsable ejecutará únicamente las acciones aprobadas y registrará cualquier desviación o problema presentado.  
3. Después del cambio se deberá verificar el resultado, registrar la evidencia técnica y conciliar la ejecución con la solicitud aprobada, los cambios no autorizados deberán reportarse como hallazgos.

Responsable: El solicitante documenta el cambio; el propietario del dato o Comité de cambios lo aprueba; el DBA o administrador del motor lo ejecuta, auditoría Interna o Seguridad TI revisará la conciliación.

Excepciones: Los cambios de emergencia podrán realizarse cuando sean necesarios para atender incidentes críticos, deberán contar con autorización de emergencia y documentarse con su justificación, acciones realizadas y revisión posterior.

Evidencia: Registro de solicitudes de cambio de la Actividad 7, bitácoras de PostgreSQL y MongoDB, registros de modificaciones de estructura y privilegios, y conciliación entre los cambios ejecutados y las solicitudes aprobadas.

Revisión: Cada seis meses y después de incidentes o cambios importantes en el proceso de administración de producción.