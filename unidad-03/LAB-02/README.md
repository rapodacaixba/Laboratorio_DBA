# LAB-02 — Trazabilidad en MongoDB Community

## Información general

- **Materia:** Gestión de Seguridad y Desempeño de Bases de Datos
- **Unidad:** III — Auditoría, trazabilidad y gobierno práctico de datos
- **Motor:** MongoDB Community Edition
- **Versión del servidor:** MongoDB 7.0.48
- **Cliente:** mongosh 2.14.2
- **Sistema operativo:** Windows 11
- **Despliegue:** Contenedor Docker
- **Nombre del contenedor:** dba-u3-mongo
- **Base de datos:** comercial

## Despliegue del servidor

Para realizar el laboratorio utilicé Docker Desktop en Windows 11 y un contenedor basado en la imagen oficial mongo:7. El servidor se inició con la opción --auth, que habilita la autenticación y el control de acceso.

El comando de despliegue indicado en el Anexo A es:

docker run --name dba-u3-mongo -p 27017:27017 -d mongo:7 --auth

El parámetro -p 27017:27017 publica el puerto del servidor para permitir conexiones desde el equipo local, mientras que --auth habilita la autorización de MongoDB.

El contenedor utilizado durante las actividades fue dba-u3-mongo.

### Acceso al servidor

Para ingresar como administrador utilicé:

docker exec -it dba-u3-mongo mongosh "mongodb://admin:<CONTRASEÑA_ADMIN>@127.0.0.1:27017/comercial?authSource=admin"

Para ejecutar operaciones como el usuario de la aplicación:

docker exec dba-u3-mongo mongosh "mongodb://app_ventas:<CONTRASEÑA_APP>@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find().toArray()'

Las contraseñas se omiten de este documento para evitar exponer credenciales.

### Reinicio del servidor

Al utilizar un contenedor Docker, el reinicio se realiza mediante:

docker restart dba-u3-mongo

### Verificación de la versión y edición

La versión del servidor se verificó desde mongosh mediante:

db.version()
db.adminCommand({ buildInfo: 1 }).modules

Resultados obtenidos:

- db.version(): 7.0.48
- buildInfo.modules: arreglo vacío ([]).

El resultado confirma que el servidor utilizado corresponde a MongoDB Community Edition y no a una compilación Enterprise.

También se revisó la configuración de arranque mediante:

db.serverCmdLineOpts().parsed

La configuración permitió verificar que el control de acceso estaba habilitado.