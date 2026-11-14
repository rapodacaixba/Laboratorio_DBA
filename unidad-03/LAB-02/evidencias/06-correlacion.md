**Actividad 6 — Correlacionar un cambio de configuración con su autor**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se rastreó en la bitácora el evento de modificación del perfilador, el cual registró el cambio de estado pero no incluyó directamente el nombre del usuario responsable, para identificar al autor, se extrajo el identificador de conexión y se cruzó con el evento previo de autenticación exitosa correspondiente a esa misma sesión, logrando atribuir el cambio de configuración al usuario admin.

1. ¿Qué usuario cambió la configuración del perfilador? ¿Qué dos eventos lo demuestran?

La correlación identifica al usuario admin como responsable del cambio, los dos eventos que permiten establecerlo son Profiler settings changed, que registra la modificación del perfilador, y Successfully authenticated, que identifica al usuario autenticado en la misma conexión conn13.

2. ¿Qué condición debe cumplirse para que esta correlación sea válida? (Piensa en qué pasa si el servidor se reinicia y los números de conexión vuelven a empezar.)

Ambos eventos deben pertenecer a la misma ejecución del servidor y al mismo contexto de conexión, no debe haber ocurrido un reinicio entre ellos, porque los identificadores de conexión pueden comenzar nuevamente y reutilizarse, también debe comprobarse que el contexto corresponde a la misma conexión y no a una conexión posterior que haya reutilizado el identificador.

3. ¿Por qué es relevante que quede registrado un cambio de configuración del propio mecanismo de registro?

Porque permite detectar cuándo se modifica el mecanismo encargado de generar evidencia, un cambio en la configuración puede reducir o alterar los registros disponibles, por lo que conocer quién lo realizó y cuándo ocurrió ayuda a identificar posibles intentos de ocultar actividades o modificar la trazabilidad.  
