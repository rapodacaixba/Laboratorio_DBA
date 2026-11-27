**Actividad 4 — Catálogo mínimo de datos**

| ID | Conjunto de datos | Motor | Ubicación | Propietario | Custodio | Clasificación | Contiene datos personales | Finalidad | Conservación | Diccionario |
| :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- | :---- |
| CAT-01 | Clientes | PostgreSQL 17 | \<servidor-pg\>/ comercial / public.clientes | Gerencia Comercial | DBA | Confidencial | Si | Gestión de clientes, atención, facturación y actividades comerciales | Mientras sean necesarios para la finalidad y las obligaciones aplicables. Plazo específico por confirmar con el área jurídica | diccionario-clientes.csv |
| CAT-02 | Auditoría de clientes | PostgreSQL 17 | \<servidor-pg\> / comercial / auditoria.cambios\_clientes | Auditoría Interna | DBA | Confidencial | Si | Registrar y consultar los cambios realizados sobre los datos de clientes para fines de auditoría y trazabilidad | Conforme a la política de conservación de auditorías. Plazo por confirmar con el área jurídica | Estructura de auditoria.cambios\_clientes |
| CAT-03 | Registro de cambios | PostgreSQL 17 | \<servidor-pg\> / comercial / gobierno.solicitudes\_cambio | Comité de Cambios | DBA | Interno | Puede contener datos personales de los solicitantes y aprobadores | Registrar las solicitudes, autorizaciones y ventanas de cambios en producción | Conforme a POL-03, una vez definida y aprobada | Estructura de gobierno.solicitudes\_cambio |
| CAT-04 | Clientes (tienda)	 | MongoDB 7 | \<servidor-mongo\> / comercial / clientes | Gerencia Comercial | Administrador MongoDB | Confidencial | Si | Almacenar información de clientes utilizada por la aplicación de tienda | Conforme a la política de retención de datos de clientes | Estructura de la colección clientes |
| CAT-05 | Perfilado | MongoDB 7 | \<servidor-mongo\> / comercial / system.profile | Seguridad TI o Auditoría Interna | Administrador MongoDB | Confidencial | Puede contener datos personales o información sensible de consultas | Analizar operaciones y actividad de la base de datos para identificar problemas de desempeño y comportamiento | Conforme a la política de conservación de registros técnicos. Plazo por definir | Estructura de system.profile |

1. ¿Por qué CAT-02 y CAT-05 contienen datos personales aunque su propósito sea la auditoría?

Porque registran la actividad real sobre los datos de negocio: auditoria.cambios\_clientes conserva el rastro de modificaciones vinculadas a clientes y sus atributos, y system.profile captura operaciones ejecutadas que pueden incluir filtros, valores o parámetros con información personal o identificadores identificables, el propósito de auditoría no borra la naturaleza del dato registrado.

2. ¿Qué pasa si CAT-01 y CAT-04 tienen propietarios distintos y el RFC de un cliente difiere entre ambos motores?

Se genera una inconsistencia de datos y una ambigüedad de autoridad: al haber dos propietarios distintos, no queda claro de entrada cuál es la fuente de verdad ni quién tiene la facultad de corregir o unificar el RFC, esto exige escalar el hallazgo entre los propietarios correspondientes y el custodio para definir la fuente autorizada y la corrección trazable.

3. ¿Qué información del catálogo cambia con más frecuencia y quién debe actualizarla?

Cambian con mayor frecuencia los atributos operativos frente a la identidad del activo, debe actualizarla el custodio en coordinación con los propietarios cada vez que se incorporen activos, cambien esquemas o se actualicen políticas y diccionarios.  
