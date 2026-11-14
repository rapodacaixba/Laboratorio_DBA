**Actividad 8 — Conservación: exportar antes de perder**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

En esta actividad se reinició el contenedor dba-u3-mongo para verificar la volatilidad de la auditoría; el nivel del perfilador regresó a 0 y el búfer en memoria de getLog se vació, mientras que los documentos previamente guardados en system.profile sí persistieron, después se exportó el contenido de system.profile a system-profile.json, la bitácora del servidor a bitacora-mongod.log y se generaron sus respectivos hashes en hashes.sha256 para garantizar la integridad de la evidencia.

1. Menciona tres formas en que la evidencia del perfilador o de la bitácora puede perderse sin que nadie la borre deliberadamente.

Por un reinicio del servicio o del contenedor al vaciar por completo el búfer en memoria de getLog y restablecer el nivel del perfilador a 0 si no está configurado en el archivo de configuración, también por sobrescritura circular en system.profile ya que al ser una colección limitada por defecto, cuando se llena con operaciones nuevas, mongo elimina automáticamente los documentos más antiguos, y desbordamiento del búfer circular de getLog debido a que el comando getLog: "global" conserva únicamente los últimos 1024 eventos en memoria; en un servidor con tráfico activo, los eventos antiguos se van descartando conforme entran nuevos.

2. ¿Por qué el tamaño de 1 MB de system.profile es un problema de conservación y no solo de espacio?

Porque al ser una capped collection, el límite de 1 MB impone una ventana de retención temporal muy corta bajo carga real, si ocurre un incidente de seguridad o una modificación no autorizada y el sistema recibe miles de consultas posteriores antes de que se revise, los registros nuevos sobrescribirán y destruirán irreversiblemente la evidencia del incidente.

3. ¿Por qué getLog sirve para interpretar pero no para conservar?

Porque getLog lee un búfer volátil en memoria RAM limitado a los últimos 1024 eventos en formato json estructurado, pero no escribe en disco de forma persistente; ante cualquier reinicio del servidor o alta actividad, el historial previo desaparece, para conservar evidencia a largo plazo es indispensable configurar systemLog.destination: file o exportar los registros externamente.  
