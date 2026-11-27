**POL-05 — Uso de datos sensibles**

Objetivo: Proteger los datos personales y la información sensible contra consultas, divulgación, modificación o uso no autorizado.

Alcance: Aplica a los datos personales almacenados en public.clientes, auditoria.cambios\_clientes, la colección de clientes de MongoDB, las bitácoras y cualquier otro conjunto de datos que pueda contener información personal o sensible.

Regla:

1. Los usuarios sólo podrán consultar datos personales cuando exista una finalidad de trabajo justificada y autorización del propietario del dato.  
2. El acceso a información como RFC, correo y teléfono deberá limitarse al personal que la necesite para sus funciones, cuando sea posible, se utilizarán vistas, datos agrupados o información anonimizada.  
3. Las consultas y modificaciones relevantes sobre datos personales deberán quedar registradas mediante los mecanismos de auditoría disponibles, los registros también deberán protegerse porque pueden contener datos personales.

Responsable: El propietario del dato autoriza su utilización; el DBA o administrador del motor aplica los controles técnicos, seguridad TI y Auditoría Interna podrán revisar los accesos y el cumplimiento de esta política.

Excepciones: El acceso excepcional podrá autorizarse cuando exista una necesidad operativa, de seguridad o legal debidamente justificada, deberá limitarse al tiempo y a la información estrictamente necesarios.

Evidencia: Matriz de gobierno de datos de la Unidad II, catálogo de la Actividad 4, registros de privilegios, bitácoras de acceso y cambios, y solicitudes de autorización.

Revisión: Cada seis meses y cuando se incorporen nuevos datos personales o cambien sus finalidades de uso.