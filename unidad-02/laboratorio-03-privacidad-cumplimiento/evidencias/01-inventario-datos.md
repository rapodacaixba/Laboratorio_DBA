**01 \- Inventario y finalidad de los datos**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

El objetivo del inventario es identificar los datos personales almacenados en la tabla clientes, determinar para que se utilizan y establecer qué áreas deberían tener acceso.

| Campo | ¿Es dato personal? | Finalidad | ¿Es necesario? | Nivel de acceso | Retención |
| :---- | :---- | :---- | :---- | :---- | :---- |
| id | Si, permite relacionar el registro con una persona | Identificar al cliente dentro del sistema | Si, para relacionar sus registros | Controlado por rol | Mientras exista la relación con el cliente y se requiera el registro |
| nombre | Si | Identificar al cliente y atender sus solicitudes | Si, para atención y facturación | Atención y facturación | Mientras sea necesario para la relación y las obligaciones aplicables |
| correo | Si | Contactar al cliente | Si, cuando se utiliza como medio de contacto | Atención al cliente | Mientras sea necesario para el servicio |
| telefono | Si | Contactar al cliente | Si, si se utiliza para la atención | Atención al cliente | Mientras sea necesario para el servicio |
| rfc | Si | Identificación fiscal y facturación | Si para facturación, no necesariamente para soporte | Facturación autorizada | Según las obligaciones fiscales y de conservación aplicables |
| edad | Si, si está relacionada con una persona identificable | Obtener estadísticas por grupos de edad | No es indispensable para atención básica, puede servir para analítica | Acceso restringido, analítica mediante rangos | Mientras exista una finalidad justificada |
| ciudad | Puede ser dato personal cuando se relaciona con un cliente identificable | Ubicación general y estadística | Si, para estadísticas geográficas | Acceso según finalidad | Mientras sea necesaria para la finalidad |
| codigo\_postal | Puede ser dato personal cuando se vincula con un cliente | Ubicación geográfica y análisis por región | No siempre, depende de la finalidad | Acceso restringido según necesidad | Mientras sea necesario para la finalidad |
| fecha\_alta | Puede ser dato personal al relacionarse con el cliente | Conocer cuando se registró | Si, para administrar el registro y su antigüedad | Personal autorizado | Mientras se requiera para la operación y las obligaciones aplicables |

Se identificaron los campos de la tabla clientes, sus finalidades, la necesidad de utilizarlos, los niveles de acceso y los periodos de retención propuestos. Se observó que el acceso debe depender de las funciones de cada área.

**02 \- Principio de minimización**

1. ¿Todos los campos son necesarios para atención al cliente?

No, para atender solicitudes básicas se necesita principalmente el identificador del cliente, su nombre y sus medios de contacto y los demás campos no son indispensables para todas las tareas de soporte.

2. ¿Por qué soporte necesitaría conocer el RFC?

En una atención básica normalmente no se necesita consultarlo ya que el rfc corresponde principalmente a procesos de facturación e identificación fiscal, por lo que su acceso debe limitarse al personal que lo requiera.

3. ¿Necesita conocer la edad?

No necesariamente ya que la edad puede utilizarse para análisis estadísticos, pero no es indispensable para contactar a un cliente o resolver una consulta general.

4. ¿Necesita conocer el código postal?

Depende del servicio, si se necesita para verificar una dirección o atender una solicitud de entrega, podría justificarse, para soporte general no es necesario tenerlo disponible.

5. ¿Qué principio de privacidad está relacionado con esta decisión?

El principio de minimización de datos, porque busca utilizar únicamente la información adecuada, relevante y necesaria para una finalidad específica.

Se creó la tabla clientes\_soporte con id, nombre, correo y teléfono, después se copiaron los registros seleccionados desde clientes y se consultaron los resultados. La finalidad fue evitar que el área de soporte tuviera acceso innecesario a información fiscal o demográfica.

**Conclusión de la actividad 2**  
La tabla clientes\_soporte limita la información a los datos necesarios para atender al cliente, esto hace que se disminuya la exposición de información personal y aplica el principio de minimización además de que facilita que cada área trabaje con una estructura que vaya de acuerdo con sus responsabilidades.

**03 \- Separación por finalidad**

**¿Por qué esta información puede ser más apropiada para analítica que entregar directamente la tabla completa de clientes?**  
Porque permite analizar tendencias y cantidades sin exponer directamente los datos que puedan identificar a los clientes, de esta forma, el área de analítica puede obtener información útil para sus estadísticas y se reduce la cantidad de datos personales a los que necesita acceder. Sin embargo, los datos agrupados no siempre son completamente anónimos, especialmente cuando existen grupos muy pequeños.

Se ejecutaron consultas para contar clientes por ciudad y agruparlos por rangos de edad. Estas consultas permiten generar estadísticas sin mostrar directamente los datos identificativos de los clientes. 

**Conclusión de la actividad 3**  
Las consultas permiten obtener estadísticas utilizando solo los datos necesarios para el análisis, separar la información operativa de los resultados analíticos ayuda a reducir la exposición de datos personales y favorece el cumplimiento del principio de limitación de finalidad.

**04 \- Control de acceso relacionado con la finalidad**

El objetivo fue crear un rol que pueda consultar la información preparada para analítica, pero que no tenga acceso directo a la tabla completa de clientes.

Primero se hizo un intento de crear el rol analista sin permitirle iniciar sesión directamente, pero como anteriormente se había creado, dio error indicando justo esto, este rol se utiliza para definir permisos que después pueden asignarse a usuarios autorizados. Después se creó una vista llamada v\_analitica\_clientes que muestra la ciudad y el rango de edad de cada registro, la vista permite consultar información preparada para analítica sin exponer directamente columnas como el nombre, correo, teléfono o rfc, hecho eso se otorgaron permisos para consultar únicamente la información preparada para analítica y por último se consultó la vista del catálogo para revisar los privilegios de tablas y vistas otorgados al rol analista.

**Conclusión de la actividad 4**  
La creación del rol y de la vista permite separar los permisos de acceso según la responsabilidad de cada área, de esta manera, analítica puede consultar la información que necesita sin tener acceso automático a todos los datos personales. Esto contribuye a la privacidad por defecto y al control de acceso.

1. ¿Qué información puede consultar el rol?

Puede consultar la ciudad y el rango de edad de los registros mediante la vista v\_analitica\_clientes.

2. ¿Puede consultar directamente clientes?

No, siempre que no tenga permisos directos o heredados de otros roles que le permitan acceder a esa tabla, el bloque de permisos de esta práctica no le concede ese acceso.

3. ¿Puede obtener nombre, correo y RFC?

No porque esas columnas no están incluidas, tampoco puede consultarlas directamente en clientes con los permisos otorgados en esta actividad.

4. ¿Qué principio de privacidad estás aplicando?

La minimización de datos y la limitación de finalidad, porque el rol solo recibe la información que necesita para realizar análisis.

5. ¿Qué principio de seguridad estás aplicando?

El de mínimo privilegio, ya que se conceden únicamente los permisos necesarios para la función asignada.  
