**08 \- Derecho de cancelación y ciclo de vida**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

Cuando una solicitud de cancelación ha sido autorizada por el área responsable, no basta con eliminar el registro de la tabla principal, primero es necesario identificar dónde se encuentra almacenada o relacionada la información del titular dentro de la organización.

Revisamos los siguientes elementos:

- Tablas relacionadas: Pueden contener información del mismo cliente mediante identificadores o relaciones  
- Respaldos: Pueden conservar copias anteriores de la base de datos  
- Réplicas: Pueden mantener copias de los datos para disponibilidad o recuperación  
- Reportes: Pueden incluir información personal obtenida de la base de datos  
- Registros de auditoría: Pueden conservar referencias a operaciones realizadas sobre los datos, de acuerdo con las políticas y obligaciones aplicables  
- Copias utilizadas para analítica: Pueden contener registros individuales o información derivada de los datos originales  
- Archivos exportados: pueden existir archivos CSV, Excel u otros documentos con datos del cliente  
- Sistemas externos: Otras aplicaciones o proveedores pueden recibir información

Mapa del ciclo de vida  
Clientes  
\+--------------------------\|--------------------------+  
\|                                \|                                \|  
Respaldos                  Réplicas                  Reportes  
\|                                                                 .  
                        Exportaciones  
\|                                                                 .  
                     Sistemas externos

Este mapa representa posibles ubicaciones de la información que deben investigarse, no significa que todos estos elementos existan necesariamente en la organización, incluso otros elementos que podrían y deben revisarse son tablas relacionadas, copias utilizadas para analítica y registros de auditoría.

¿Por qué eliminar un registro de una tabla no necesariamente significa que toda la información relacionada con esa persona haya desaparecido de la organización?  
Porque los datos pueden encontrarse en otras tablas, respaldos, réplicas, reportes, archivos exportados o sistemas externos. Eliminar un registro de la tabla principal no elimina automáticamente todas esas copias, por eso la organización debe identificar dónde se encuentra la información y aplicar el procedimiento de cancelación correspondiente, considerando las obligaciones de conservación y los controles aplicables.

**Conclusión de la actividad 8**  
El derecho de cancelación debe analizarse considerando todo el ciclo de vida de los datos, antes de realizar una eliminación, es necesario identificar las copias existentes, las relaciones con otros sistemas y las obligaciones que podrían requerir conservar cierta información y de esta forma, se evita asumir que una sola operación sql resuelve todo el proceso.

**09 \- Derecho de oposición**

En esta actividad se analiza qué sucede cuando un cliente solicita que sus datos no se utilicen para una finalidad secundaria, como las promociones personalizadas.

¿Es necesario eliminar inmediatamente todos sus datos de la base?  
No exactamente ya que el derecho de oposición se relaciona con solicitar que determinado tratamiento deje de realizarse cuando proceda, no significa que todos los datos deban eliminarse automáticamente, ya que podrían seguir siendo necesarios para atender pedidos, realizar facturación o cumplir obligaciones aplicables.

¿Qué información podría necesitar mantenerse?  
Se puede conservar datos relacionados con operaciones comerciales, facturas o registros que deban mantenerse por obligaciones legales o por otras finalidades válidas, la información conservada debe limitarse a lo necesario y contar con controles de acceso adecuados.

¿Qué información podría dejar de utilizarse para determinada finalidad?  
Si la oposición procede, los datos que se utilizan para enviar promociones podrían dejar de utilizarse para ese propósito, por ejemplo, el correo electrónico y las preferencias de compra podrían excluirse de las campañas de marketing, aunque continúen utilizándose para otras finalidades justificadas.

¿Qué mecanismos técnicos podrían separar finalidades?  
Se pueden utilizar roles y permisos específicos, vistas con acceso limitado, tablas separadas por finalidad y mecanismos que permitan registrar y respetar las solicitudes de oposición, también se pueden implementar listas de exclusión para evitar que un cliente vuelva a ser incluido en campañas cuando corresponda.

¿Por qué la decisión final no debe ser tomada únicamente por el DBA?  
Porque el dba es responsable de administrar técnicamente la base de datos, pero no necesariamente tiene la autoridad para determinar si la oposición procede jurídicamente o qué información debe conservarse, esa decisión debe coordinarse con las áreas responsables de privacidad, cumplimiento o asesoría jurídica.

**Conclusión de la actividad 9**  
El derecho de oposición demuestra que los datos pueden seguir siendo necesarios para una finalidad y dejar de utilizarse para otra, es importante separar los usos de la información, controlar los accesos y registrar las solicitudes para evitar que los datos se sigan utilizando de manera inadecuada.

