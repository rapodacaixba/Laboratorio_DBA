**Actividad 1 — Lo que no existe en esta edición**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se verificó la versión y edición de mongoDB utilizada, así como la configuración con la que se inició el servidor. Se comprobó que mongoDB no dispone de auditoría nativa, por lo que se deberán utilizar mecanismos alternativos de trazabilidad.

1. ¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra?  
     
   Se utiliza mongoDB, versión 7, la evidencia se obtiene mediante db.version() y db.adminCommand({ buildInfo: 1}).modules, cuyo resultado es un arreglo vacío (\[ \]), esto indica que no se encuentra instalado el módulo enterprise.  
     
2. ¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes?  
     
   La ubicación de la bitácora se identificó mediante db.serverCmdLineOpts().parsed, revisando la configuración systemLog. En este despliegue, al no establecerse un destino de archivo, los mensajes se envían a la salida estándar del contenedor docker, que puede consultarse mediante docker logs.  
     
3. Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa?  
     
   Cambios de esquema (DDL), eventos de conjuntos de réplicas y clústeres fragmentados, eventos de autenticación y autorización, operaciones CRUD, cuando se habilita auditAuthorizationSuccess: true.   
     
4. ¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?  
     
   Tendría que evaluar los costos de licenciamiento o migración, las necesidades de seguridad y auditoría, el volumen de operaciones, los requisitos de conservación de evidencias y el impacto que tendría el cambio de plataforma en su infraestructura, también debería comparar los beneficios de la auditoría nativa con los controles alternativos disponibles.