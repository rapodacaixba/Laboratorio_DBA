**05 \- Analizar una finalidad secundaria**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

La empresa propone utilizar los datos de los clientes para enviar promociones personalizadas según su edad, ciudad y comportamiento de compra, aunque la organización ya cuenta con esta información, es necesario analizar si su utilización está justificada y cumple con las condiciones aplicables.

1. ¿El hecho de que la organización ya tenga los datos significa automáticamente que puede utilizarlos para cualquier finalidad?

No, porque la organización debe revisar la finalidad para la que fueron recopilados, las condiciones informadas al titular y la base jurídica aplicable, si el nuevo uso requiere una autorización u otra condición específica, debe atenderse antes de implementarlo.

2. ¿Qué preguntas debería realizar la organización antes de implementar este tratamiento?

Creo que serian las siguientes:

- ¿La finalidad de enviar promociones fue informada a los clientes?  
- ¿Es necesario utilizar la edad, la ciudad y el comportamiento de compra?  
- ¿Se puede cumplir la finalidad utilizando menos información?  
- ¿Qué personal tendrá acceso a los datos?  
- ¿Durante cuánto tiempo se conservarán los datos utilizados para las promociones?  
- ¿Qué controles se utilizarán para evitar accesos no autorizados?

3. ¿Qué datos serían realmente necesarios?

Depende de cómo funcione la campaña, podría ser suficiente utilizar un identificador del cliente, un medio de contacto autorizado y las preferencias o categorías de compra estrictamente necesarias, la edad y la ciudad sólo deberían utilizarse si existe una justificación, no sería necesario entregar todos los datos personales almacenados en la base de datos.

4. ¿Necesitaría el área de marketing acceso directo a clientes?

No necesariamente puesto que marketing podría trabajar con una vista o un conjunto de datos preparado para las campañas, el acceso directo a la tabla completa debería limitarse a los casos en los que exista una necesidad justificada y una autorización adecuada.

5. ¿Qué controles técnicos podrían limitar la información entregada?

Crear vistas que incluyan únicamente los campos necesarios, asignar roles con permisos específicos para cada función, evitar conceder acceso directo a la tabla completa de clientes, utilizar información agregada o seudonimizada cuando sea suficiente, registrar los accesos y las modificaciones relevantes, limitar el tiempo de conservación de los datos utilizados para las campañas y revisar periódicamente los permisos otorgados.

**Conclusión de la actividad 5**  
Antes de utilizar los datos para promociones personalizadas, la empresa debe verificar que sea válido y justificado su uso, aplicar la minimización de datos, limitar los accesos y establecer controles técnicos permite reducir riesgos para la privacidad de los clientes.

**06 \- Derechos ARCO y la base de datos**

En esta actividad se trabajó el derecho de acceso que permite al titular conocer qué datos personales tiene registrados la organización y obtener información sobre su tratamiento conforme a las disposiciones aplicables.  
Se tomó en cuenta una consulta sql para localizar los datos de un cliente mediante su correo electrónico y se identificó que atender este derecho también requiere verificar la identidad del solicitante, localizar correctamente la información y coordinar una entrega segura.

¿Qué información adicional debería proporcionar la organización además del resultado de esta consulta?  
Además de los datos encontrados, la organización debería informar, según corresponda, las finalidades del tratamiento, las categorías de datos que utiliza, las condiciones relevantes de su tratamiento, las transferencias que procedan y los mecanismos disponibles para ejercer los derechos del titular, también debe seguir el procedimiento y los plazos aplicables para atender la solicitud, ahora desde el punto de vista técnico, se debe comprobar que la información corresponde al titular correcto, identificar los datos pertinentes en los sistemas y entregar únicamente la información que corresponda, mediante un procedimiento seguro.

**Conclusión de la actividad 6**  
El derecho de acceso no consiste únicamente en ejecutar una consulta sql, también implica localizar correctamente la información, verificar la identidad del solicitante mediante el procedimiento correspondiente y coordinar la entrega segura de los datos con las áreas responsables.

**07 \- Derecho de rectificación**

En esta actividad se simula la corrección del correo electrónico de un cliente, la consulta utilizada modifica un dato específico y después permite verificar el resultado. También se analiza la importancia de verificar la autorización y registrar quién realiza los cambios.

1. ¿Cómo podría comprobarse que el cambio fue autorizado?

Se puede verificar mediante una solicitud registrada del cliente, la validación de su identidad y la aprobación correspondiente según el procedimiento de la organización.

2. ¿Debería registrarse quién realizó el cambio?

Sí, es importante registrar quién modificó, cuándo, qué dato se modificó y cuál fue la solicitud que la originó, aplicando los controles de acceso necesarios para proteger esos registros.

3. ¿Por qué la trazabilidad será importante?

Porque permite conocer el origen de los cambios, detectar modificaciones no autorizadas, investigar incidentes y demostrar que se siguieron los procedimientos establecidos y también facilita las revisiones y auditorías de la base de datos.

**Conclusión de la actividad 7**  
La rectificación permite corregir datos personales que sean inexactos o estén desactualizados, cuando proceda, desde el punto de vista técnico, es necesario identificar correctamente el registro, modificar únicamente el campo correspondiente y verificar el resultado. Además, registrar quién realizó el cambio y por qué se hizo contribuye a la trazabilidad y al gobierno de los datos.

