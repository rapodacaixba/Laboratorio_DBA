**Actividad 2 — El incidente sin perfilado**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se realizó una modificación al rfc de María García mientras el perfilador de mongoDB se encontraba desactivado, posteriormente se consultaron system.profile y la bitácora del servidor para comprobar que evidencia quedó registrada.

1. ¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora?  
   No es posible demostrar directamente que dato cambio mediante las fuentes consultadas, debido a que el perfilador estaba desactivado y la bitácora no registró la operación CRUD, sin embargo, la bitácora permite identificar que el usuario app\_ventas se conecto y auténtico correctamente en el servidor.  
     
2. ¿Por qué mongosh abre varias conexiones (conn8, conn9, …) para una sola instrucción? ¿Cuál es la que se autentica?  
   MongoDB puede establecer varias conexiones durante la comunicación entre mongosh y el servidor para intercambiar metadatos y realizar la autenticación. La conexión que se autentica es la que presenta el evento successfully authenticated en la bitácora, no necesariamente la primera conexión establecida.  
   