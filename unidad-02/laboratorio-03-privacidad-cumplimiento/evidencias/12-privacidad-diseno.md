**12 \- Privacidad por diseño**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

Una aplicación nueva requiere registrar clientes, el desarrollador propone almacenar diferentes datos personales bajo la justificación de que podrían necesitarse posteriormente.

1. ¿Qué problemas identificas?

Se propone almacenar demasiados datos sin demostrar que sean necesarios, no se define la finalidad específica de cada dato, se incrementa la cantidad de información que podría quedar expuesta ante un acceso no autorizado, no se especifica cuánto tiempo se conservarán los datos, no se explica cómo se protegerán los datos sensibles y no se establece qué ocurrirá cuando un dato deje de ser necesario. Guardar datos por si algún día se necesitan puede generar riesgos innecesarios y dificulta el control de la información.

2. ¿Qué principio de privacidad se está ignorando?

Principalmente se ignora el principio de minimización de datos, también está la limitación de la finalidad, porque no basta con almacenar información para un posible uso futuro sin definir para qué se utilizará, además, deben considerarse la limitación del plazo de conservación y la protección de los datos desde el diseño.

3. ¿Qué preguntas realizarías antes de aprobar el diseño?

Principalmente, se ignora el principio de minimización de datos, también se relaciona con la limitación de la finalidad, porque no basta con almacenar información para un posible uso futuro sin definir para qué se utilizará, además, deben considerarse la limitación del plazo de conservación y la protección de los datos desde el diseño.

4\. ¿Qué preguntas realizaría antes de aprobar el diseño?  
Las siguientes preguntas: ¿cuál es la finalidad principal de la aplicación?, ¿qué datos son indispensables para registrar y atender a cada cliente?, ¿por qué se necesita cada dato y qué función cumple?, ¿quién podrá consultar, modificar o exportar la información?, ¿cómo se protegerán los datos personales y cuáles requieren controles adicionales?, ¿durante cuánto tiempo se conservará cada categoría de datos?, ¿cómo se atenderán las solicitudes de acceso, rectificación, cancelación u oposición cuando correspondan?, ¿qué se hará cuando la información deje de ser necesaria?

4. ¿Qué datos eliminarías?

Eliminaría del diseño inicial los datos que no tengan una finalidad definida ni una necesidad demostrada, por ejemplo, no incluiría automáticamente salario, estado civil, ocupación, dirección o fecha de nacimiento si la aplicación no los necesita para realizar sus funciones, la decisión definitiva dependería de los requisitos reales del sistema, no significa que esos datos nunca puedan recopilarse, sino que cada uno debe justificarse antes de incorporarlo.

5. ¿Qué datos requerirían una justificación adicional?

Para el rfc sería justificar su necesidad, especialmente si la aplicación no realiza facturación ni trámites que lo requieran, del salario explicar por qué se necesita un dato económico y quién debe acceder a él, para fecha de nacimiento y edad determinar si basta con conocer un rango de edad o si existe una necesidad concreta de conservar la fecha completa, explicar la relación directa de estado civil con la finalidad del sistema, ocupación sería precisar qué función requiere esta información, para dirección y código postal es comprobar si se necesita la dirección completa o si basta con una ubicación menos precisa, justificar la necesidad del telefono si ya existe otro medio de contacto suficiente, el correo electrónico y el nombre también deben recopilarse únicamente cuando sean necesarios para la finalidad definida.

6. ¿Cómo aplicarías privacidad por defecto?

Solicitaría únicamente los datos indispensables para utilizar la aplicación, configuraría los permisos para que cada usuario acceda solo a la información que necesita, evitaría que todos los empleados pudieran consultar directamente la tabla completa, utilizaría vistas con información limitada para las tareas de analítica, establecería plazos de conservación y procedimientos para eliminar o restringir datos cuando corresponda, protegería los datos mediante controles de acceso, auditoría y medidas de seguridad adecuadas, evitaría utilizar información personal real en ambientes de desarrollo y pruebas, y documentaría las finalidades, los responsables y las reglas de tratamiento de cada categoría de datos.

**Conclusión de la actividad 12**  
La privacidad por diseño implica considerar la protección de los datos desde la etapa de planificación de una aplicación. Antes de crear una tabla, se deben definir las finalidades, justificar cada dato y establecer controles de acceso, protección y conservación. De esta manera, se reduce la exposición de información personal y se evita recopilar datos que no sean necesarios.

**13 \- Diferenciar controles técnicos y administrativos**

La clasificación distingue entre las herramientas que aplican medidas de seguridad y las reglas que establecen cómo deben administrarse, algunas medidas aparecen en ambas categorías porque necesitan una configuración técnica y una política organizacional un ejemplo es una política de acceso que define quién debe consultar la información, mientras que los roles y permisos de postgresql permiten aplicar esa decisión en la base de datos.

| Medida | Técnico | Administrativo | Justificación |
| :---: | :---: | :---: | :---: |
| Crear roles de PostgreSQL | Si |  | Permite asignar permisos a los usuarios y limitar el acceso a los objetos de la db |
| Política de retención |  | Si | Define durante cuánto tiempo deben conservarse los datos y bajo qué condiciones deben eliminarse o restringirse, puede implementarse mediante controles técnicos. |
| Cifrado de datos | Si |  | Es una medida técnica que protege la confidencialidad de la información, su uso debe acompañarse de reglas para administrar las claves. |
| Procedimiento para solicitudes ARCO |  | Si | Define como recibir, verificar, atender y documentar las solicitudes de acceso, rectificación, cancelación y oposición cuando corresponda.  |
| Vista con información limitada | Si |  | Permite presentar únicamente los campos necesarios para una función determinada y reducir la exposición de datos. |
| Clasificación de información |  | Si | Establece categorías para identificar el nivel de sensibilidad de los datos y las medidas de protección que requieren. |
| Registro de auditoría | Si | Si | Técnicamente registra operaciones y accesos; administrativamente requiere reglas sobre revisión, responsables, conservación y atención de alertas. |
| Política de control de acceso | Si | Si | Administrativamente define quién puede acceder y bajo qué condiciones; técnicamente se aplica mediante roles, permisos y otros mecanismos de seguridad. |

**Conclusión de la actividad 13**  
Los controles técnicos y administrativos se complementan, las herramientas técnicas permiten aplicar restricciones y proteger la información, mientras que las políticas y los procedimientos determinan cómo deben utilizarse estos mecanismos y quién es responsable de supervisarlos.

