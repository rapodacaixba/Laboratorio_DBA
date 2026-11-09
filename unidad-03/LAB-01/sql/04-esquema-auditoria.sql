--Nombre: Raquel Apodaca Caixba
--Laboratorio: LAB-01 — Bitácoras y auditoría del dato en PostgreSQL
--Actividad: Actividad 10 — Diseñar y crear el registro de auditoría

--crear esquema separado sin acceso publico
CREATE SCHEMA auditoria;
REVOKE ALL ON SCHEMA auditoria FROM PUBLIC;

--crear tabla
CREATE TABLE auditoria.cambios_clientes (
    id_evento        BIGSERIAL PRIMARY KEY,
    momento          TIMESTAMPTZ NOT NULL DEFAULT now(),
    usuario_sesion   TEXT        NOT NULL DEFAULT session_user,
    usuario_efectivo TEXT        NOT NULL DEFAULT current_user,
    aplicacion       TEXT        DEFAULT current_setting('application_name'),
    ip_cliente       INET        DEFAULT inet_client_addr(),
    operacion        TEXT        NOT NULL,
    id_cliente       BIGINT,
    valores_antes    JSONB,
    valores_despues  JSONB
);

SELECT COUNT(*) AS total_eventos
FROM auditoria.cambios_clientes;