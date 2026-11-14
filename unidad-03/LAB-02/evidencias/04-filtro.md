**Actividad 4 — Reducir el volumen con un filtro**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se desactivo el perfilador nivel 0, se elimino el historial anterior de system.profile y se reactivó en nivel 1 con un filtro para registrar únicamente operaciones de escritura, posteriormente se ejecutó una consulta y una actualización desde la aplicación app-ventas-web, comprobando que solo la modificación quedó registrada en la auditoría y omitiendo las lecturas para ahorrar espacio y ruido.

1. ¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?

Se perdió el registro de las operaciones de lectura, las consultas find y una que otra operación que no esté incluida en el filtro. Se ganó una reducción del volumen de registros permitiendo concentrar la evidencia en las modificaciones de datos y facilitar su revisión. 

2. ¿Qué filtro usarías si solo interesaran operaciones sobre la colección clientes?

Se podría usar el campo ns que identifica la db y la colección, este filtro limitaría los registros a las operaciones cuyo espacio de nombres corresponde a la colección clientes de la base comercial.  
