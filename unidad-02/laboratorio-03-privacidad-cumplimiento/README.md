**Laboratorio 03 — Privacidad y cumplimiento**

**1\. Introducción**  
El objetivo de este laboratorio es analizar cómo se pueden aplicar los principios de privacidad, seguridad y gobierno de los datos en una base de datos PostgreSQL.  
Durante las actividades se trabajó con un escenario de una empresa que almacena información de clientes, como nombres, correos electrónicos, teléfonos, rfc, edad, ciudad, código postal y fecha de alta, estos datos son útiles para realizar actividades operativas, pero su tratamiento también implica responsabilidades relacionadas con el acceso, la protección, la conservación y el uso adecuado de la información personal.  
El laboratorio permitió relacionar las decisiones técnicas de una base de datos con principios como la minimización de datos, la limitación de la finalidad, la confidencialidad, la limitación de la conservación y la responsabilidad.

**2\. Inventario de datos**  
El inventario permite identificar qué información se almacena, para qué puede utilizarse, quién necesita acceder a ella y qué protección requiere.

| Dato | Clasificación general | Finalidad posible | Consideración de privacidad |
| :---: | :---: | :---: | :---: |
| **id(del cliente)** | Identificador | Distinguir registros y relacionar información | Limitar su uso y evitar que se exponga innecesariamente |
| **nombre** | Dato personal identificativo | Identificar y atender a los clientes | Acceso solo para funciones que lo requieran |
| **correo** | Dato personal de contacto | Comunicaciones y atención | Justificar los usos y controlar el acceso |
| **telefono** | Dato personal de contacto | Comunicación con el cliente | Recopilarlo si resulta necesario y restringir su consulta |
| **rfc** | Dato personal de identificación fiscal | Facturación y obligaciones fiscales, cuando corresponda | Acceso restringido y conservación justificada |
| **edad** | Dato personal | Estadísticas o servicios que requieran conocerla | Evaluar si basta con un rango de edad |
| **ciudad** | Dato de ubicación general | Operación y estadísticas geográficas | Limitar su uso a las finalidades definidas |
| **codigo\_postal** | Dato de ubicación | Entregas, cobertura o estadísticas | Evaluar si se necesita el código completo |
| **fecha\_alta** | Dato relacionado con el registro del cliente | Seguimiento de la relación y administración | Definir su conservación según la finalidad |

La clasificación es general y debe ajustarse al contexto de la organización. Algunos datos pueden requerir controles adicionales según el uso, la combinación con otros campos y las obligaciones aplicables, el inventario debe complementarse con un responsable, los usuarios autorizados, las medidas de protección y el plazo de conservación de cada categoría.

**3\. Finalidades del tratamiento de los datos**  
Cada dato personal debe tener una finalidad definida y justificada, no es suficiente conservarlo bajo el argumento de que podría ser útil en el futuro.  
Las principales finalidades identificadas son:

- Operación y atención: utilizar los datos estrictamente necesarios para registrar clientes y atender sus solicitudes  
- Facturación y obligaciones fiscales: utilizar el rfc y otros datos necesarios cuando exista una necesidad justificada  
- Analítica: generar estadísticas sobre clientes, ciudades o rangos de edad utilizando preferentemente información agregada  
- Comunicaciones: utilizar los datos de contacto para comunicaciones relacionadas con una finalidad definida y bajo los requisitos aplicables  
- Auditoría y seguridad: mantener registros de accesos y operaciones relevantes para investigar incidentes y comprobar el cumplimiento de los controles

Los usos secundarios, como las campañas promocionales, deben evaluarse por separado y se debe determinar si son compatibles con la finalidad original, si existe una base jurídica adecuada y si se cumplen los requisitos de información, autorización u oposición que correspondan.

**4\. Minimización de datos**  
La minimización consiste en recopilar y utilizar únicamente los datos adecuados, pertinentes y necesarios para cumplir una finalidad determinada, ahora enfocándonos en el escenario analizado, los datos de salario, estado civil, ocupación, fecha de nacimiento o dirección completa no deberían incorporarse automáticamente a una aplicación si no existe una necesidad demostrada. También se identificó que el área de analítica no necesita necesariamente acceder a nombres, correos electrónicos, teléfonos y rfc para generar estadísticas mensuales, en su lugar, se pueden proporcionar vistas limitadas o resultados agregados. La minimización no significa eliminar indiscriminadamente toda la información, sino conservar y utilizar únicamente la que esté justificada para cada propósito.

**5\. Control de acceso**  
El control de acceso debe relacionar los permisos de la base de datos con las funciones de cada usuario, se identificó que otorgar acceso directo a la tabla completa aumenta la exposición de los datos personales. La propuesta consiste en aplicar el principio de mínimo privilegio mediante roles, permisos específicos y vistas que presenten únicamente la información necesaria.

| Rol o área | Acceso propuesto |
| :---: | :---: |
| Operación | Datos necesarios para registrar y atender clientes |
| Facturación | Datos necesarios para las operaciones fiscales autorizadas |
| Analítica | Vistas limitadas, conjuntos minimizados y estadísticas agregadas |
| Auditoría | Registros relevantes para verificar accesos y operaciones |
| DBA | Permisos técnicos necesarios para administrar, mantener y proteger la base de datos, con trazabilidad y controles apropiados |
| Desarrollo y pruebas | Datos ficticios o sintéticos; acceso excepcional a información real solo si se justifica y se autoriza adecuadamente |

En postgresql, los roles permiten agrupar permisos y las vistas pueden limitar las columnas que se exponen, estas medidas deben acompañarse de revisiones periódicas de los accesos, protección de credenciales y registros de operaciones relevantes. La administración técnica de la base de datos no debe confundirse con una autorización para utilizar todos los datos para cualquier finalidad.

**6\. Derechos ARCO**  
Los derechos ARCO son los derechos de acceso: localizar la información relacionada con la persona y facilitar una respuesta conforme al procedimiento aplicable, rectificación: verificar la solicitud y actualizar los datos incorrectos cuando proceda, dejando trazabilidad del cambio, cancelación: evaluar si corresponde eliminar los datos o aplicar las medidas procedentes, considerando las obligaciones que puedan exigir conservar determinada información y oposición: evaluar el tratamiento al que se opone la persona y detener o limitar el uso cuando corresponda, su aplicación puede requerir cambios técnicos y coordinación entre las áreas responsables.  
Desde el punto de vista técnico, es importante poder localizar los datos de un cliente, identificar sus relaciones con otras tablas y conocer dónde existen copias, exportaciones o respaldos, también se requiere un procedimiento para verificar la solicitud, documentar las acciones, controlar los permisos y comunicar el resultado a las áreas responsables. La decisión sobre la procedencia de una solicitud no corresponde exclusivamente al dba; debe coordinarse con el responsable de privacidad y, cuando sea necesario, con el área jurídica.

**7\. Retención de datos**  
La retención debe determinarse de acuerdo con la finalidad de cada dato, las necesidades operativas y las obligaciones legales o contractuales aplicables. Conservar información durante muchos años sin una política documentada puede aumentar la exposición ante incidentes y dificultar la justificación de su almacenamiento, sin embargo, tampoco es correcto eliminar datos automáticamente sin comprobar si existe una obligación válida de conservación, la eliminación debe formar parte del ciclo de vida de los datos, desde su recopilación hasta el momento en que dejan de ser necesarios.

**8\. Gobierno de datos**  
El gobierno de datos establece las responsabilidades y reglas para gestionar la información de manera controlada.  
La siguiente matriz resume la propuesta:

| Dato o categoría | Finalidad | Responsable principal | Usuarios autorizados | Protección | Acción al finalizar la necesidad |
| :---: | :---: | :---: | :---: | :---: | :---: |
| **nombre** | Identificación y atención | Operación | Personal autorizado para atención | Control por roles y permisos | Eliminar o restringir cuando corresponda |
| **correo electrónico** | Contacto y comunicaciones justificadas | Operación o área responsable de comunicaciones | Usuarios autorizados según la finalidad | Acceso restringido y gestión de preferencias | Actualizar, eliminar o restringir cuando proceda |
| **telefono** | Contacto | Operación | Personal que necesite comunicarse con el cliente | Acceso por función | Eliminar o restringir cuando deje de ser necesario |
| **rfc** | Facturación y obligaciones fiscales | Facturación  | Personal autorizado para esas tareas | Acceso restringido y auditoría | Conservar mientras exista una obligación válida y después aplicar la disposición correspondiente |
| **edad** | Estadísticas o servicios justificados | Analítica o área propietaria del proceso | Personal autorizado para la finalidad | Preferir rangos y resultados agregados | Eliminar o transformar en estadísticas cuando sea adecuado |
| **ciudad** | Operación y estadísticas geográficas | Operación o analítica | Usuarios autorizados según la finalidad | Vistas limitadas y acceso por función | Eliminar o agregar cuando proceda |
| **codigo\_postal** | Entregas, cobertura o análisis geográfico | Área operativa correspondiente | Personal que necesite ese nivel de detalle | Limitar el acceso y la precisión cuando sea suficiente | Eliminar, restringir o agregar cuando corresponda |

El área de administración de bases de datos aplica los controles técnicos, como permisos, respaldos, auditoría y protección de la información, el responsable de privacidad coordina la evaluación de las finalidades y los derechos de las personas; el área jurídica interpreta las obligaciones aplicables, y los responsables de cada proceso justifican las necesidades operativas, la dirección debe aprobar las políticas y asignar recursos para que estas responsabilidades se cumplan.

**9\. Evaluación integral**  
En el escenario de la empresa con 50,000 clientes se identificaron los siguientes riesgos principales:

| Problema | Riesgo | Control propuesto |
| :---- | :---- | :---- |
| Acceso directo de analítica a la tabla completa | Exposición innecesaria de datos personales | Roles y vistas limitadas |
| Conservación de datos durante 12 años sin una política documentada | Almacenamiento prolongado sin justificación clara | Política de retención por finalidad y categoría |
| Copias completas de producción para desarrollo | Aumento de los lugares donde se expone la información | Datos ficticios o sintéticos para pruebas |
| Uso de información real en desarrollo | Accesos indebidos o incidentes fuera del entorno productivo | Separación de ambientes y controles reforzados para cualquier excepción autorizada |
| Campañas promocionales sin finalidades documentadas claramente | Uso de datos no justificado o incompatible con los requisitos aplicables | Documentar finalidad, base jurídica y requisitos de comunicación |
| Falta de documentación sobre la finalidad de cada dato | Dificultad para demostrar la necesidad de recopilar y conservar información | Inventario de datos y registro de finalidades |
| Falta de revisión periódica de permisos | Accesos que permanecen activos sin necesidad | Revisiones de permisos y revocación oportuna |
| Falta de trazabilidad suficiente | Dificultad para investigar accesos o cambios indebidos | Registros de auditoría protegidos y revisados |
| Falta de procedimiento documentado para solicitudes ARCO | Respuestas tardías o acciones técnicas incompletas | Proceso coordinado entre las áreas responsables |
| Falta de reglas para eliminar copias y exportaciones | Persistencia de datos personales después de terminar las pruebas | Inventario de copias y procedimiento de eliminación |

La evaluación muestra que la privacidad requiere más que proteger la tabla principal: también se deben controlar los accesos, los usos secundarios, las copias y los periodos de conservación.

**10\. Conclusiones**  
Este laboratorio permitió comprender que la privacidad, la seguridad y la administración de bd están relacionadas, pero no son exactamente lo mismo. Una bd necesita controles técnicos para proteger la información, así como políticas que determinen qué datos se pueden recopilar, para qué se utilizan, quién puede acceder a ellos y durante cuánto tiempo deben conservarse. También aprendí que el principio de mínimo privilegio ayuda a reducir la exposición de datos personales, que la minimización evita recopilar información innecesaria y que las copias de desarrollo deben tratarse como posibles fuentes de riesgo.  
Los derechos ARCO requieren que la organización pueda localizar y gestionar la información de cada persona, pero las acciones técnicas deben coordinarse con los responsables de privacidad y las áreas correspondientes, de la misma manera, la retención y eliminación deben planificarse desde el diseño, incluyendo copias y respaldos.  
En conclusión, una administración responsable de bases de datos no consiste únicamente en mantener el sistema funcionando, también implica proteger la información, justificar su uso, limitar los accesos y establecer responsabilidades claras durante todo su ciclo de vida.

**Preguntas de reflexión**

1. ¿Una base de datos técnicamente segura necesariamente cumple con todos los requisitos de privacidad?

No, puede tener cifrado, contraseñas seguras y controles de acceso, pero aun así utilizar los datos para finalidades no justificadas, recopilar información innecesaria o conservarla durante demasiado tiempo, la seguridad protege la información frente a determinados riesgos, mientras que la privacidad también requiere justificar el tratamiento y respetar los derechos de las personas.

2. ¿Por qué el principio de mínimo privilegio también contribuye a la privacidad?

Porque limita la información que cada usuario puede consultar o modificar según sus funciones, de esa forma se reduce la exposición innecesaria de datos personales y el impacto que podría tener un error, una cuenta comprometida o un uso indebido.

3. ¿Por qué el DBA no debería decidir por sí solo la finalidad del tratamiento de los datos?

Porque es responsable de administrar y proteger técnicamente la base de datos, pero no necesariamente conoce todas las necesidades del negocio ni tiene autoridad para determinar por sí solo las finalidades y bases jurídicas del tratamiento, estas decisiones deben involucrar a los responsables del proceso, al responsable de privacidad y, cuando sea necesario, al área jurídica.

4. ¿Por qué los desarrolladores no deberían recibir automáticamente copias completas de bases de datos productivas?

Porque normalmente necesitan datos para probar funciones específicas, no toda la información de los clientes, una copia completa aumenta el número de personas, sistemas y ubicaciones que pueden exponer los datos, se deben utilizar datos ficticios, sintéticos o conjuntos minimizados siempre que sea posible.

5. ¿Por qué una copia utilizada para desarrollo también puede representar un riesgo de privacidad?

Porque puede contener los mismos datos personales que producción, pero estar almacenada en un entorno con distintos permisos, herramientas y medidas de protección, si esa copia se filtra, se comparte sin autorización o permanece olvidada, la información de los clientes sigue estando expuesta.

6. ¿Por qué la retención debe formar parte del ciclo de vida de los datos?

Porque los datos no deben conservarse indefinidamente sin una razón, desde que se recopilan se debe definir para qué se necesitan, durante cuánto tiempo y qué ocurrirá cuando dejen de ser necesarios, esto ayuda a reducir la exposición y a cumplir las obligaciones de conservación o eliminación aplicables.

7. ¿Qué relación existe entre privacidad por diseño y diseño de bases de datos?

La privacidad por diseño significa considerar la protección de los datos desde la planificación del sistema, en una bd se refleja al elegir los campos necesarios, separar la información por finalidad, diseñar roles y vistas limitadas, establecer reglas de retención y evitar la exposición innecesaria de datos personales.

8. ¿Qué controles técnicos implementarías para reducir el riesgo de exposición de datos personales?

Implementaría roles y permisos de mínimo privilegio, vistas con información limitada, cifrado adecuado, protección de credenciales, separación entre producción y desarrollo, registros de auditoría y controles sobre exportaciones y respaldos, también utilizaría datos sintéticos para las pruebas y revisaría periódicamente los permisos concedidos.

9. ¿Qué información debería conocer un DBA para responder técnicamente a una solicitud ARCO?

Debería conocer dónde se encuentran los datos, qué tablas y relaciones los contienen, qué sistemas y copias los utilizan, qué permisos existen y qué mecanismos permiten consultar, actualizar, restringir o eliminar la información, también necesita conocer los respaldos, las exportaciones y los registros relacionados para ejecutar las acciones técnicas que hayan sido autorizadas.

10. ¿Qué responsabilidades deberían corresponder al DBA, al responsable de privacidad, al área jurídica y al propietario de los datos? 

El dba debe implementar y mantener controles técnicos, localizar datos, administrar permisos, apoyar las modificaciones autorizadas y mantener trazabilidad, el responsable de privacidad tiene que coordinar las finalidades, evaluar riesgos, supervisar los procedimientos y organizar la atención de solicitudes, área jurídica debe interpretar las obligaciones aplicables, evaluar los requisitos legales y asesorar sobre la procedencia de las decisiones y el propietario de los datos o responsable del proceso debe justificar la necesidad de la información, definir los usos operativos y participar en las decisiones sobre acceso y conservación. Estas responsabilidades deben coordinarse y quedar documentadas para evitar decisiones aisladas o contradictorias.