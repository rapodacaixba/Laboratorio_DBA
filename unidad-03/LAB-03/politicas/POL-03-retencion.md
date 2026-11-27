**POL-03 — Retención**

Objetivo: Evitar la conservación innecesaria de información y, al mismo tiempo, mantener los registros requeridos para auditoría, operación y cumplimiento de obligaciones.

Alcance: Aplica a los datos personales de clientes, las tablas de auditoría, las bitácoras de PostgreSQL y MongoDB, las solicitudes de cambio y los registros de perfilado.

Regla:

1. Cada conjunto de datos deberá tener un periodo de conservación documentado, definido de acuerdo con su finalidad, sensibilidad y obligaciones aplicables.  
2. Los periodos de conservación deberán ser aprobados por el propietario del dato y revisados con el área jurídica cuando exista una obligación normativa o fiscal.  
3. Al vencer el periodo, el responsable deberá revisar si existen investigaciones, obligaciones o necesidades justificadas pendientes. Si no existen, se realizará la eliminación, anonimización o depuración autorizada, dejando evidencia de la acción.

Responsable: El propietario del dato determina la necesidad de conservación; el DBA o administrador del motor ejecuta las acciones técnicas autorizadas, el área jurídica deberá confirmar los plazos relacionados con obligaciones legales.

Excepciones: La eliminación podrá suspenderse cuando exista una investigación, auditoría u obligación de conservación pendiente, siempre que la decisión quede justificada y autorizada.

Evidencia: Catálogo de datos de la Actividad 4, tabla de conservación de la Actividad 5, autorizaciones de eliminación o depuración y registros de las acciones realizadas.

Revisión: Cada seis meses o cuando cambie la finalidad del tratamiento, la clasificación de los datos o una obligación aplicable.