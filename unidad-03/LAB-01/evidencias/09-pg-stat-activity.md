**Actividad 9 — Sesiones activas con pg\_stat\_activity**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se contrastó la vista pg\_stat\_activity contra dba.bitacora y se confirmó que el pid actúa como la clave de correlación entre una sesión activa que ejecuta un proceso y las líneas registradas en la bitácora. Se evidenció que las herramientas de diagnóstico en tiempo real pierden la información al cerrar la sesión, reafirmando la necesidad de los archivos de registro para el análisis forense posterior.

1. ¿Qué columna permite relacionar una sesión con sus líneas de bitácora?

El PID, en la consulta a pg\_stat\_activity aparece en la columna pid, en la bitácora, este mismo identificador se registra entre corchetes dentro del prefijo de cada línea, esta coincidencia del PID permite correlacionar de forma directa una sesión activa en tiempo real con su historial de eventos en el archivo de registro.

2. Después de que termina el reporte, ¿qué fuente conserva evidencia de que existió?

Únicamente la bitácora en disco, la vista pg\_stat\_activity es volátil e in-memory, solo muestra las conexiones activas y en ejecución en el instante presente, una vez que la consulta o la sesión finaliza y el proceso se destruye, la fila desaparece por completo de pg\_stat\_activity y la evidencia histórica persistente queda únicamente en los archivos de registros capturados por el colector.

3. ¿Por qué client\_addr aparece vacío en la sesión del administrador?

Porque la conexión del administrador se realizó mediante un socket local unix o protocolo ipc local, no a través de una pila de red tcp/ip, ya que cuando te conectas localmente sin especificar una dirección ip de red, la conexión no utiliza un puerto tcp/ip, por lo que no existe una dirección ip de cliente, en contraste, la sesión de soporte\_ana se conectó explícitamente vía red en 127.0.0.1, haciendo que postgresql registre su dirección ip de origen.  
