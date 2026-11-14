**Actividad 5 — Accesos en la bitácora de mongod**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se simularon dos intentos de conexión fallidos desde terminal; uno con contraseña incorrecta para un usuario válido y otro con un usuario inexistente, confirmando que el cliente recibe el mismo error de Authentication failed por seguridad. Luego, se consultó la bitácora interna de mongod filtrando por la categoría ACCESS para diferenciar los detalles reales de cada fallo interno y contrastarlos contra el último inicio de sesión exitoso de la aplicación.

1. ¿Qué campo distingue un acceso fallido de uno exitoso?

El campo msg permite distinguirlos; un acceso fallido aparece como Failed to authenticate y uno exitoso aparece como Successfully authenticated. El campo result también deja identificar el resultado: los intentos fallidos muestran los códigos 18 y 11, los exitosos muestran 0\.

2. ¿Qué diferencia hay entre el error de contraseña incorrecta y el de usuario inexistente? ¿Por qué el cliente recibe el mismo mensaje en ambos casos?

Cuando la contraseña es incorrecta, se registra un error de autenticación scram con código 18 y cuando el usuario no existe se registra UserNotFound con código 11  
Aunque los errores son diferentes, el cliente recibe el mismo mensaje de Authentication failed, esto evita revelar información sobre la existencia de usuarios y dificulta que alguien pueda enumerar cuentas válidas del servidor.

3. ¿Por qué el nombre de la aplicación del intento fallido es mongosh 2.10.0 y no app-ventas-web?

Porque los intentos fallidos se ejecutan directamente desde la terminal usando mongosh, sin especificar el parámetro appName=app-ventas-web, por eso mongo identifica al cliente como mongosh 2.14.2.