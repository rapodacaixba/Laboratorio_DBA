**POL-04 — Restauración**

Objetivo: Establecer condiciones para recuperar información y servicios ante fallas, pérdidas de datos o incidentes que afecten las bases de datos.

Alcance: Aplica a las bases de datos PostgreSQL y MongoDB, así como a sus respaldos, configuraciones y registros necesarios para recuperar los servicios.

Regla:

1. Toda restauración deberá contar con una solicitud que describa el incidente, la información que se necesita recuperar y el motivo de la restauración.  
2. La restauración deberá ser autorizada por el responsable del servicio o propietario de los datos y ejecutada por el DBA o administrador correspondiente.  
3. Después de restaurar, el responsable técnico deberá verificar la integridad y disponibilidad de la información, documentando el resultado y cualquier diferencia detectada.

Responsable: El propietario del dato o responsable del servicio autoriza la restauración; el DBA o administrador de MongoDB ejecuta el procedimiento y verifica el resultado.

Excepciones: En incidentes críticos que requieran recuperación inmediata, podrá aplicarse el procedimiento de emergencia autorizado, la justificación y las acciones realizadas deberán documentarse posteriormente.

Evidencia: Solicitud de restauración, autorización, identificación del respaldo utilizado, registro de ejecución, verificaciones posteriores y resultado de la recuperación, el procedimiento técnico se definirá en la Unidad V.

Revisión: Cada seis meses y después de cada restauración o cambio importante en los procedimientos de respaldo.