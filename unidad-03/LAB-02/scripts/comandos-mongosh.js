//LAB-02 — Trazabilidad en MongoDB Community
//Servidor: MongoDB Community 7.0.48
//Base de datos: comercial

//Actividad 1 — Lo que no existe en esta edición

//Consultar versión del servidor
db.version()

//Consultar módulos de la compilación
db.adminCommand({ buildInfo: 1 }).modules

// Consultar configuración de arranque:
db.serverCmdLineOpts().parsed

//Actividad 2 — El incidente sin perfilado

//En la sesión del dba
// Consultar estado del perfilador:
db.getProfilingStatus()

//Preparar función de bitacora
function bitacora() {
  return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l))
}

//Operacion de la aplicacion: Modificar el rfc de id = 3 fuera de mongosh
mongosh "mongodb://app_ventas:Ventas_Practica_2026@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XXX" } })'

//Buscar evidencia
//Consultar registros existentes
db.system.profile.countDocuments()
//Consultar si la bitácora contiene el RFC modificado
bitacora().filter(e => JSON.stringify(e).includes("GAMA780912XXX")).length
//Consultar actividad de la aplicacion
bitacora().filter(e => JSON.stringify(e).includes("app-ventas-web")).map(e => ({ t: e.t, c: e.c, ctx: e.ctx, msg: e.msg }))


//Actividad 3 — Activar el perfilador y registrar operaciones

//Activar el perfilador
db.setProfilingLevel(2)

// Verificar configuración
db.getProfilingStatus()

//Operacion de la aplicacion: consulta, actualizacion y eliminacion
mongosh "mongodb://app_ventas:Ventas_Practica_2026@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ ciudad: "Culiacán" }, { nombre: 1, ciudad: 1 }).toArray(); db.clientes.updateOne({ _id: 3 }, { $set: { rfc: "GAMA780912XYZ" } }); db.clientes.deleteOne({ _id: 2 });'

//Consultar el perfilador
db.system.profile.find(
  { ns: "comercial.clientes" },
  { op: 1, ns: 1, command: 1, user: 1, client: 1, appName: 1, ts: 1, millis: 1, nreturned: 1, docsExamined: 1, nModified: 1, ndeleted: 1 }
).sort({ ts: 1 })

//Actividad 4 — Reducir el volumen con un filtro

//Desactiva perfilador
db.setProfilingLevel(0)
//Elimina coleccion
db.system.profile.drop()
// Registrar únicamente inserciones, actualizaciones y eliminaciones
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })
// Verificar filtro
db.getProfilingStatus();

//Operacion de la aplicacion: consulta y actualizacion de cliente id = 1
mongosh "mongodb://app_ventas:Ventas_Practica_2026@127.0.0.1:27017/comercial?appName=app-ventas-web" --quiet --eval 'db.clientes.find({ _id: 1 }).toArray(); db.clientes.updateOne({ _id: 1 }, { $set: { telefono: "6670000000" } })'

//Consultar registros del perfilador
db.system.profile.find({}, { op: 1, ns: 1, user: 1, appName: 1, "command.q": 1, "command.u": 1, ts: 1 })

//Actividad 5 — Accesos en la bitácora de mongod

//Generar intentos fallidos 
mongosh "mongodb://app_ventas:incorrecta@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"
mongosh "mongodb://usuario_inexistente:x@127.0.0.1:27017/comercial" --quiet --eval "db.clientes.countDocuments()"

//definir nuevamente funcion bitacora()
function bitacora() {
  return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l))
}

//Consultar intentos fallidos
bitacora()
  .filter(e => e.c === "ACCESS" && e.msg === "Failed to authenticate")
  .map(e => ({ t: e.t, id: e.id, ctx: e.ctx, user: e.attr.user, client: e.attr.client, error: e.attr.error, result: e.attr.result, app: e.attr.doc.application.name }))

//Consultar último acceso exitoso de app_ventas
bitacora()
  .filter(e => e.msg === "Successfully authenticated" && e.attr.user === "app_ventas")
  .slice(-1)
  .map(e => ({ t: e.t, id: e.id, ctx: e.ctx, client: e.attr.client, result: e.attr.result, app: e.attr.doc.application.name }))


//Actividad 6 — Correlacionar un cambio de configuración con su autor

// Consultar cambios de configuración del perfilador
bitacora()
  .filter(e => e.msg === "Profiler settings changed")
  .map(e => ({ t: e.t, ctx: e.ctx, msg: e.msg, attr: e.attr }))

//Identificar quien hizo el cambio
bitacora()
  .filter(e => e.ctx === "conn13" && e.msg === "Successfully authenticated")
  .map(e => ({ t: e.t, ctx: e.ctx, user: e.attr.user, db: e.attr.db, client: e.attr.client }))

//Actividad 7 — Cambios de privilegios: el límite más importante

//Tomar instantánea de privilegios actuales
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles }))
})

//Comprobar que se guardo
db.getSiblingDB("auditoria").instantaneas_privilegios.find().pretty()

//Activar perfilador nivel 2
db.setProfilingLevel(2)

//Agregar temporalmente el rol dbAdmin a app_ventas
db.grantRolesToUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])

//Buscar evidencia del cambio en system.profile
db.system.profile.countDocuments({ "command.grantRolesToUser": { $exists: true } })

// Buscar evidencia del cambio en la bitácora:
bitacora().filter(e => JSON.stringify(e).includes("grantRoles")).length

//Tomar segunda instantánea
db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
  momento: new Date(),
  tomada_por: db.runCommand({ connectionStatus: 1 }).authInfo.authenticatedUsers,
  usuarios: db.getUsers().users.map(u => ({ user: u.user, db: u.db, roles: u.roles }))
})

// Consultar y comparar instantáneas
db.getSiblingDB("auditoria").instantaneas_privilegios.find({}, { _id: 0 }).sort({ momento: 1 })

// Revocar rol temporal
db.revokeRolesFromUser("app_ventas", [{ role: "dbAdmin", db: "comercial" }])

// Restablecer filtro de la Actividad 4
db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } })

//Verificar configuración final
db.getProfilingStatus()

//Actividad 8 — Conservación: exportar antes de perder

//Consultar estado del perfilador después del reinicio
db.getProfilingStatus()

//Consultar cantidad de registros conservados
db.system.profile.countDocuments()

//Volver a definir la función bitacora
function bitacora() {
  return db.adminCommand({ getLog: "global" }).log.map(l => JSON.parse(l))
}

//Consultar cantidad de eventos recientes
bitacora().length;

// Exportar system.profile, bitacora y generar hash
//system.profile
mongosh "mongodb://admin:Admin_Practica_2026@127.0.0.1:27017/comercial?authSource=admin" --quiet --eval 'EJSON.stringify(db.system.profile.find({}, { op: 1, ns: 1, user: 1, client: 1, appName: 1, ts: 1, "command.q": 1, "command.u": 1 }).toArray(), null, 2)' > evidencias/system-profile.json
//bitacora
mongosh "mongodb://admin:Admin_Practica_2026@127.0.0.1:27017/comercial?authSource=admin" --quiet --eval 'db.adminCommand({ getLog: "global" }).log.join("\n")' > evidencias/bitacora-mongod.log
//hashes
Get-FileHash evidencias\system-profile.json, evidencias\bitacora-mongod.log -Algorithm SHA256 | Format-Table Hash, Path -AutoSize | Out-File -Encoding utf8 evidencias\hashes.sha256

