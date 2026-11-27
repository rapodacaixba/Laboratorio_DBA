**Actividad 1 — Calidad de datos desde la operación**

Se insertaron dos registros de prueba en la tabla clientes, con el propósito de simular errores de captura y evaluar la calidad de los datos.

| ID | Hallazgo | Registros | Regla de calidad | ¿Quién decide la corrección? | Acción propuesta |
| :---- | :---- | :---- | :---- | :---- | :---- |
| C1 | Posible cliente duplicado | 1, 7 | Unicidad del correo | Gerencia comercial | Verificar si corresponden al mismo cliente antes de consolidar registros |
| C2 | RFC incompleto | 7 | Formato del RFC | Gerencia comercial | Solicitar y validar el RFC correcto |
| C3 | Correo con formato invalido | 8 | Formato del correo | Gerencia comercial | Solicitar la corrección del correo |
| C4 | Edad fuera de rango | 8 | Edad entre 18 y 120 años | Gerencia comercial | Verificar el dato con la fuente autorizada |

1. ¿Por qué el DBA no debe corregir por su cuenta el RFC del registro 7?

Porque el DBA es el custodio de los datos y no el propietario, su responsabilidad es proteger y administrar la información, pero no decidir cuál es el RFC correcto de un cliente ya que esa decisión corresponde a la Gerencia Comercial.

2. ¿Qué restricción (CHECK, UNIQUE) habría evitado cada hallazgo? ¿Quién debería aprobar agregarla?

Una restricción UNIQUE podría evitar correos duplicados y una restricción CHECK podría validar el formato del correo, el RFC y el rango de edad, la aprobación debe corresponder al propietario del dato, con participación del DBA para evaluar su implementación.

3. Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) dejará   
   evidencia del cambio?

El mecanismo de auditoría mediante el disparador trg\_auditoria\_clientes, que registra las modificaciones en auditoria.cambios\_clientes.  
