**15 \- Propuesta de arquitectura de datos protegidos**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

El objetivo es proponer una arquitectura conceptual que permita separar los datos de los clientes de acuerdo con su finalidad, limitar el acceso a información personal y establecer controles para todo su ciclo de vida, la propuesta busca aplicar los principios de minimización, confidencialidad, limitación de la finalidad, seguridad y responsabilidad.  
La arquitectura que propongo es la siguiente:

Base de datos  
\|  
Control de acceso y auditoría general  
\|  
\+------------------------------------+------------------------------------+  
\|                                             \|                                             \|  
Operación                                Analítica                                Auditoría  
\|                                             \|                                             \|  
Datos necesarios para              Datos agregados y              Registros de accesos y  
         atender a los clientes          estadísticas mensuales                cambios relevantes  
\|                                             \|                                             \|  
Acceso restringido               Sin identificadores               Acceso limitado y  
          por función                        innecesarios               conservación definida

Los ambientes de desarrollo y pruebas deben permanecer separados de producción y utilizar datos ficticios o sintéticos siempre que sea posible.

- Separación de la información por finalidad

1\. Operación: Esta área utiliza los datos necesarios para registrar clientes y atender las actividades operativas autorizadas, puede incluir nombre y datos de contacto cuando sean necesarios para la atención, otros campos sólo deben estar disponibles para las funciones que los requiera justificadamente.

2\. Analítica: Esta área genera estadísticas mensuales, por lo que debe utilizar datos agregados o conjuntos minimizados en lugar de consultar directamente toda la información de los clientes, por ejemplo, puede recibir cantidades de clientes por ciudad o por rango de edad, sin nombres, correos, teléfonos ni rfc cuando estos no sean necesarios.

3\. Auditoría: Esta área conserva registros que permiten revisar accesos y operaciones relevantes sobre la información, registros que deben permitir investigar incidentes sin convertirse en una copia innecesaria de los datos personales de los clientes. Los registros de auditoría también pueden contener datos personales, por lo que deben protegerse y conservarse de manera justificada.

- Controles generales de privacidad

Acceso: Crear roles específicos para operación, analítica, auditoría y administración técnica y aplicar el principio de mínimo privilegio, de modo que cada rol tenga únicamente los permisos necesarios para realizar sus funciones.

Minimización: Antes de incorporar un campo o compartir un conjunto de datos, verificar su finalidad y necesidad, evitar entregar tablas completas cuando una vista limitada o un resultado agregado sea suficiente.

Protección de información sensible: restringir el acceso a datos como el rfc y a otros que requieran protección adicional y aplicar medidas adecuadas de cifrado, control de permisos, protección de copias y manejo seguro de credenciales.

Retención: Definir cuánto tiempo se conserva cada categoría de datos, por qué se necesita y quién es responsable de revisar el plazo, considerar las obligaciones legales y contractuales aplicables antes de establecer la eliminación.

Trazabilidad: Registrar las consultas, modificaciones, exportaciones y cambios de permisos que sean relevantes para la seguridad y establecer responsables para revisar los registros y dar seguimiento a posibles incidentes.

Eliminación: Cuando los datos dejen de ser necesarios y no exista una obligación válida para conservarlos, aplicar un procedimiento de eliminación o restricción. Incluir en la revisión las copias de desarrollo, exportaciones y demás ubicaciones controladas por la organización. Las copias de seguridad deben contar con reglas propias de conservación y eliminación; borrar un registro de la base principal no garantiza que desaparezca inmediatamente de todas las copias.

Atención de solicitudes: Establecer un procedimiento para recibir, verificar, atender y documentar las solicitudes de acceso, rectificación, cancelación u oposición que correspondan y coordinar a las áreas responsables para localizar la información y aplicar las acciones procedentes.

- Responsabilidades

| Responsable o área | Función principal |
| ----- | ----- |
| Operación | Consultar y actualizar los datos necesarios para atender a los clientes |
| Analítica | Elaborar estadísticas utilizando información minimizada o agregada |
| Administración de bases de datos | Configurar permisos, respaldos, registros y controles técnicos |
| Seguridad | Supervisar medidas de protección y atender riesgos o incidentes |
| Responsable de privacidad o área designada | Coordinar la revisión de finalidades, solicitudes y obligaciones aplicables |
| Dirección | Aprobar políticas, asignar responsabilidades y supervisar su cumplimiento |

**Conclusión de la actividad 15**  
La arquitectura propuesta separa los datos según su finalidad y evita que todas las áreas tengan acceso a la misma información, la operación conserva los datos necesarios para sus funciones, analítica utiliza información agregada y auditoría mantiene registros protegidos para la trazabilidad. La propuesta combina controles técnicos y administrativos para limitar accesos, reducir la exposición de datos personales, establecer periodos de conservación y atender las solicitudes de los clientes, de esta manera, los principios de privacidad se convierten en decisiones concretas de diseño y administración de la base de datos.