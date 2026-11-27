--Nombre: Raquel Apodaca Caixba
--Laboratorio: LAB-03 — Políticas prácticas, gobierno de datos y evidencias
--Actividad: Diccionario de datos operativo dentro del motor

COMMENT ON TABLE clientes IS 'Clientes de Comercializadora Norte. Propietario: Gerencia Comercial. Custodio: DBA. Clasificación: confidencial (contiene datos personales).';
COMMENT ON COLUMN clientes.id IS 'Identificador interno del cliente. Generado por el sistema.';
COMMENT ON COLUMN clientes.nombre IS 'Nombre completo. Dato personal identificador directo.';
COMMENT ON COLUMN clientes.correo IS 'Correo de contacto. Dato personal. Uso: notificaciones al cliente.';
COMMENT ON COLUMN clientes.rfc IS 'RFC del cliente. Dato personal. Uso: facturación. Cambios auditados en auditoria.cambios_clientes.';
COMMENT ON COLUMN clientes.edad IS 'Edad en años cumplidos. Dato personal. Uso: analítica agregada.';
COMMENT ON COLUMN clientes.telefono IS 'Teléfono de contacto del cliente (varchar(20), nullable). Dato personal. Responsable: Atención al cliente.';
COMMENT ON COLUMN clientes.ciudad IS 'Ciudad de residencia del cliente (varchar(80), nullable). Dato personal / ubicación. Responsable: Analítica.';
COMMENT ON COLUMN clientes.codigo_postal IS 'Código postal del cliente (varchar(10), nullable). Dato de ubicación. Responsable: Área operativa y analítica.';
COMMENT ON COLUMN clientes.fecha_alta IS 'Fecha de alta del registro en el sistema (date, por omisión CURRENT_DATE).';
COMMENT ON COLUMN clientes.segmento IS 'Segmento o clasificación comercial del cliente (varchar(20), nullable).';

--Consultar el diccionario
SELECT c.ordinal_position          AS pos,
       c.column_name               AS columna,
       c.data_type                 AS tipo,
       c.character_maximum_length  AS longitud,
       c.is_nullable               AS acepta_nulos,
       c.column_default            AS valor_por_defecto,
       col_description('public.clientes'::regclass, c.ordinal_position) AS descripcion
FROM information_schema.columns c
WHERE c.table_schema = 'public'
  AND c.table_name = 'clientes'
ORDER BY c.ordinal_position;
