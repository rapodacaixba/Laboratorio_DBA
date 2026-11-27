**POL-02 — Respaldo**

Objetivo: Reducir el riesgo de pérdida de información y asegurar que existan copias de los datos necesarios para continuar las operaciones después de una falla.

Alcance: Aplica a las bases de datos PostgreSQL y MongoDB, incluyendo las colecciones de clientes, las tablas de auditoría, las solicitudes de cambio y las configuraciones necesarias para recuperar los servicios.

Regla:

1. Las bases de datos y los registros necesarios para la operación y auditoría deberán respaldarse de acuerdo con su importancia y frecuencia de actualización.  
2. Los respaldos deberán almacenarse en una ubicación protegida, con acceso restringido y separada del servidor principal.  
3. El responsable técnico deberá verificar periódicamente que los respaldos se hayan generado correctamente y que puedan utilizarse para una recuperación.

Responsable: El DBA será responsable de PostgreSQL y el administrador de MongoDB de sus respectivas bases de datos, el propietario de los datos deberá validar qué información requiere respaldo.

Excepciones: Cualquier exclusión de un conjunto de datos del respaldo deberá justificarse y ser aprobada por su propietario, considerando los riesgos de pérdida.

Evidencia: Registro de ejecuciones de respaldo, fecha de generación, resultado de la verificación, ubicación de almacenamiento y reportes de pruebas de recuperación, el procedimiento técnico se definirá en la Unidad V.

Revisión: Cada seis meses y después de cambios importantes en la infraestructura o en los datos.