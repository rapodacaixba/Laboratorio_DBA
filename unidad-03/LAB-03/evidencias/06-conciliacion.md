**Actividad 7 — Registro de cambios y conciliación**

| Momento (bitácora) | Usuario | Sentencia | Folio que lo autoriza | ¿Autorización? | Hallazgo |
| :---- | :---- | :---- | :---- | :---- | :---- |
| 2026-11-26 21:27:58.275 | postgres | ALTER TABLE clientes ADD COLUMN canal\_alta VARCHAR(20); | CAM-2026-014 | Si | Cambio autorizado y trazable |
| 2026-11-26 21:28:22.052 | postgres | ALTER TABLE clientes DISABLE TRIGGER trg\_auditoria\_clientes | Ninguno | No | Hallazgo grave de auditoría: deshabilita el disparador de auditoría de clientes, dejando cambios posteriores sin registro en auditoria.cambios\_clientes mientras esté inactivo |
| 2026-11-26 21:27:58.254 | postgres | INSERT INTO gobierno.solicitudes\_cambio VALUES   31 \|         ('CAM-2026-014', …); | CAM-2026-014  | Si | Cambio con folio autorizado (CAM-2026-014) dentro de ventana; se observa que el INSERT del folio ocurrió 21 ms antes del ALTER TABLE en la misma ejecución. |

1. ¿Qué cambios de la bitácora no tienen folio? Clasifícalos: ¿son de preparación del laboratorio o representan hallazgos?

Los cambios sin folio en la bitácora se dividen entre la preparación del laboratorio y los hallazgos reales, como ALTER TABLE clientes DISABLE TRIGGER trg\_auditoria\_clientes.

2. La desactivación del disparador del LAB-01 (Actividad 14), ¿qué tan grave es como hallazgo? ¿Por qué? ¿Qué distingue la línea 163 de la 169?

Desactivar trg\_auditoria\_clientes es un hallazgo de gravedad alta o crítica porque apaga la captura de cambios hacia auditoria.cambios\_clientes, dejando modificaciones posteriores sobre clientes sin rastro de auditoría. Las líneas 163 y 169 se distinguen por el momento y el evento registrado en cada una.

3. ¿Qué limitación tiene esta conciliación si log\_statement estuvo en none durante algún periodo?

Si log\_statement estuvo en none durante un periodo, PostgreSQL no registró las sentencias SQL ejecutadas en ese lapso, por lo que la ausencia de una sentencia en dba.bitacora no garantiza que no haya habido cambios ni permite verificar si ocurrieron modificaciones sin folio.

4. ¿Quién debería realizar la conciliación: el DBA que hizo los cambios u otra persona?

Debe realizarla otra persona independiente y no quien ejecutó los cambios, para mantener la segregación de funciones y evitar conflicto de interés; el DBA solo aporta la evidencia técnica.  
