# Informe final — LAB-02: Cifrado, credenciales y comunicaciones seguras

## 1. Introducción

En esta práctica se trabajó con mecanismos de seguridad para proteger las credenciales, los datos sensibles y las comunicaciones de una base de datos PostgreSQL. El objetivo fue comprender los riesgos de almacenar contraseñas en texto claro, conocer la diferencia entre hash y cifrado, verificar el estado de las conexiones mediante TLS y reconocer la importancia de administrar correctamente las claves criptográficas.

Estas medidas son importantes porque una base de datos puede contener información confidencial que debe protegerse tanto cuando está almacenada como cuando se transmite entre el cliente y el servidor.

## 2. Protección de credenciales

Una contraseña no debe almacenarse directamente en la base de datos, ya que una persona que obtenga acceso a los registros podría conocerla y utilizarla.

Existen tres formas de representar o proteger esta información:

- **Texto claro:** la contraseña se almacena tal como fue escrita, por lo que puede leerse directamente.
- **Hash:** la contraseña pasa por una función que genera un resultado utilizado para comprobarla sin necesidad de guardar su valor original. Para las contraseñas se deben utilizar mecanismos especializados de derivación de claves, con sal y un costo de cálculo adecuado.
- **Cifrado:** transforma la información mediante una clave para que pueda recuperarse posteriormente mediante el descifrado correspondiente.

Durante la práctica se utilizaron funciones de PostgreSQL para generar hashes de contraseñas y verificar si una contraseña proporcionada coincidía con el valor almacenado. También se comprobó que una misma contraseña puede producir hashes diferentes cuando se utiliza una sal aleatoria.

### Pregunta: ¿Una contraseña debe cifrarse o protegerse mediante un mecanismo de derivación de claves para contraseñas?

Una contraseña debe protegerse mediante un mecanismo especializado de derivación de claves para contraseñas, como bcrypt, Argon2id o scrypt. Estos mecanismos dificultan que un atacante pruebe grandes cantidades de contraseñas. Normalmente no se necesita recuperar la contraseña original, sino verificar si la que proporciona el usuario es correcta.

## 3. Protección de datos sensibles

En la práctica se protegió un RFC de ejemplo mediante cifrado simétrico con las funciones `pgp_sym_encrypt()` y `pgp_sym_decrypt()` de PostgreSQL. El dato cifrado se almacenó en una columna de tipo `BYTEA` y posteriormente se realizó una consulta para recuperar el valor original utilizando la clave correspondiente.

El cifrado permite proteger información que necesita recuperarse posteriormente, siempre que se disponga de la clave correcta. Sin embargo, utilizar cifrado no elimina la necesidad de controlar quién puede consultar la tabla ni quién puede acceder a las claves.

También es importante distinguir los siguientes conceptos:

- **Enmascaramiento:** oculta total o parcialmente un dato para limitar lo que se muestra. Por ejemplo, presentar un RFC como `LOPA******ABC`.
- **Seudonimización:** sustituye los identificadores directos por otros valores, como un token, de manera que la identidad pueda relacionarse nuevamente mediante información adicional protegida.
- **Cifrado:** transforma el dato mediante un algoritmo y una clave para que su contenido no pueda interpretarse directamente sin el procedimiento y la clave adecuados.

### Pregunta: ¿Qué diferencia existe entre enmascaramiento, seudonimización y cifrado?

El enmascaramiento limita la información visible; la seudonimización reemplaza los identificadores por otros valores y mantiene separada la información que permite relacionarlos; y el cifrado transforma los datos para proteger su confidencialidad. Cada mecanismo tiene un propósito distinto y puede combinarse con controles de acceso.

## 4. TLS

TLS es un protocolo que protege las comunicaciones entre un cliente y un servidor. Su función es proporcionar confidencialidad e integridad a los datos transmitidos y, cuando se configura y valida correctamente el certificado, permitir verificar la identidad del servidor.

En PostgreSQL se revisaron parámetros y consultas relacionados con la configuración SSL/TLS, entre ellos:

- `SHOW ssl;`
- `SHOW ssl_min_protocol_version;`
- `SHOW port;`
- `SHOW listen_addresses;`
- `SELECT inet_client_addr(), inet_client_port();`
- `SELECT ssl, version, cipher FROM pg_stat_ssl WHERE pid = pg_backend_pid();`

Estas comprobaciones permiten consultar la configuración del servidor, el protocolo mínimo permitido, el puerto, las direcciones de escucha y los datos de seguridad de la sesión actual.

La consulta a `pg_stat_ssl` es especialmente importante porque permite comprobar si la conexión actual utiliza SSL/TLS y, si está cifrada, consultar la versión del protocolo y el cifrado negociado. Que el parámetro `ssl` esté activado en el servidor no demuestra por sí solo que la sesión actual esté cifrada.

### Pregunta: ¿Qué problema resuelve TLS?

TLS protege los datos mientras viajan entre el cliente y el servidor, reduciendo el riesgo de que sean leídos o modificados durante la transmisión. No sustituye los permisos de PostgreSQL ni protege por sí solo los datos que ya están almacenados en la base de datos.

## 5. Gestión de claves

Las claves criptográficas son necesarias para cifrar y descifrar información. Si se guardan directamente dentro de los scripts, existe el riesgo de que sean expuestas al compartir archivos, publicar el repositorio, generar registros o mostrar capturas de pantalla.

En la práctica se analizó el riesgo de escribir una clave directamente en una consulta SQL. Aunque esto sirve como ejemplo didáctico, en un entorno real las claves deben almacenarse separadas del código y de la base de datos, utilizando un gestor de secretos o un sistema de administración de claves con controles de acceso.

También se deben proteger las copias de seguridad de las claves, limitar quién puede utilizarlas y establecer procedimientos para rotarlas o reemplazarlas cuando exista una sospecha de exposición.

### Pregunta: ¿Dónde debería almacenarse una clave criptográfica en un entorno real?

Una clave debe almacenarse en un sistema seguro de gestión de claves o secretos, separado del código fuente y de la base de datos, con acceso restringido a las identidades autorizadas. En entornos que lo requieran, puede utilizarse un servicio de gestión de claves o un módulo de seguridad de hardware (HSM).

## 6. Resultados

Durante el laboratorio se realizaron ejercicios para comprender y comprobar diferentes mecanismos de protección:

- Se comparó el almacenamiento de una contraseña en texto claro con el almacenamiento de su hash.
- Se utilizaron funciones de PostgreSQL para generar hashes y verificar contraseñas.
- Se cifró un RFC de ejemplo y se realizó su descifrado con la clave correspondiente.
- Se revisó el riesgo de incluir claves criptográficas directamente en los scripts SQL.
- Se consultaron parámetros de PostgreSQL relacionados con SSL/TLS y se revisó el estado de seguridad de la sesión actual.
- Se analizó la diferencia entre la protección de los datos almacenados y la protección de los datos transmitidos.
- Se revisaron posibles exposiciones de contraseñas y claves en el repositorio antes de compartir el proyecto.
- Se elaboró una propuesta de reglas para la gestión segura de claves.

Estos ejercicios permitieron identificar que la seguridad de una base de datos requiere varias medidas complementarias. No basta con utilizar un algoritmo criptográfico: también es necesario proteger las claves, limitar los permisos y verificar la configuración de las comunicaciones.

## 7. Problemas encontrados

Durante el desarrollo pueden presentarse dificultades relacionadas con la configuración de PostgreSQL, las conexiones o las herramientas utilizadas. En mi caso, debo documentar únicamente los problemas que realmente encontré y cómo los resolví.

Por ejemplo, si se presentó un problema al utilizar `psql`, se puede explicar que fue necesario revisar los datos de conexión, como el host, el puerto, el nombre de la base de datos y el usuario. Si apareció un error relacionado con SSL, fue necesario comprobar si el servidor admitía conexiones cifradas y si el modo de conexión solicitado era compatible con su configuración.

También es importante distinguir entre tener SSL habilitado en el servidor y utilizar realmente una conexión cifrada. La consulta a `pg_stat_ssl` permite revisar el estado de la sesión actual.

**Nota:** conserva en este apartado solamente los problemas que efectivamente ocurrieron durante tu práctica. Si no tuviste algún error, no es necesario inventarlo.

## 8. Conclusiones

Con esta práctica aprendí que las credenciales y los datos sensibles requieren mecanismos de protección diferentes según su uso. Las contraseñas deben almacenarse mediante funciones especializadas de derivación de claves, mientras que otros datos confidenciales pueden necesitar cifrado cuando deben recuperarse posteriormente.

También comprendí que TLS protege la información durante la transmisión, pero no sustituye los permisos de PostgreSQL ni el cifrado de los datos almacenados. De igual manera, las claves criptográficas deben mantenerse protegidas y separadas de los scripts para reducir el riesgo de exposición.

En un entorno productivo aplicaría controles de acceso con privilegios mínimos, hashes seguros para las contraseñas, cifrado de datos sensibles cuando sea necesario, conexiones TLS con validación adecuada de certificados, administración segura de claves y respaldos cifrados. Además, revisaría el repositorio antes de publicar cambios y establecería procedimientos para actuar ante la exposición de algún secreto.

## 9. Preguntas iniciales

### 9.1 Credenciales

**¿Una contraseña debe cifrarse o protegerse mediante un mecanismo de derivación de claves para contraseñas?**

Debe protegerse mediante un mecanismo especializado de derivación de claves para contraseñas, como Argon2id, bcrypt o scrypt. Estos mecanismos dificultan los intentos masivos de adivinar contraseñas y permiten verificarlas sin almacenar el valor original. El cifrado reversible normalmente no es la opción apropiada para almacenar contraseñas de usuarios.

### 9.2 Datos sensibles

**¿Qué diferencia existe entre enmascaramiento, seudonimización y cifrado?**

El enmascaramiento oculta parte de la información visible; la seudonimización sustituye identificadores por otros valores y conserva por separado la información que permite relacionarlos; y el cifrado transforma los datos mediante una clave para proteger su contenido. Son mecanismos diferentes que pueden complementarse.

### 9.3 Comunicaciones

**¿Qué problema resuelve TLS?**

TLS protege la confidencialidad y la integridad de los datos transmitidos entre el cliente y el servidor. Cuando se valida correctamente el certificado, también ayuda a comprobar la identidad del servidor y a reducir el riesgo de conexiones con servidores impostores.

### 9.4 Claves

**¿Dónde debería almacenarse una clave criptográfica en un entorno real?**

Debe almacenarse en un gestor de claves o secretos, separado del código fuente y de la base de datos, con acceso limitado y controles de seguridad. No debe escribirse directamente en los scripts ni publicarse en el repositorio.

### 9.5 Repositorio

**¿Es correcto subir una contraseña o clave real a GitLab aunque el repositorio sea privado?**

No.

Un repositorio privado reduce exposición, pero no convierte un secreto en información apropiada para almacenar dentro del código.

## 10. Preguntas de reflexión

### 1. ¿Por qué una contraseña no debe almacenarse como texto claro?

Porque cualquier persona que consiga acceso a la tabla o a una copia de seguridad podría leer las contraseñas directamente. Si una contraseña se reutiliza en otros servicios, la exposición también podría comprometer esas cuentas. Por eso se recomienda utilizar mecanismos especializados de derivación de claves para contraseñas.

### 2. ¿Por qué un hash no es equivalente a un cifrado?

Un hash está diseñado para producir una representación que permita verificar información sin recuperar directamente el valor original. El cifrado, en cambio, permite recuperar los datos mediante el descifrado y la clave correspondiente. Por eso los hashes se utilizan para proteger contraseñas y el cifrado se utiliza cuando es necesario recuperar información confidencial.

### 3. ¿Por qué el cifrado de una columna no sustituye al control de acceso?

Porque el cifrado protege el contenido de los datos, pero no determina por sí solo qué usuarios están autorizados para consultar o modificar la tabla. Los permisos permiten limitar el acceso según las funciones de cada usuario. Ambas medidas deben utilizarse de forma complementaria.

### 4. ¿Por qué TLS no sustituye a los mecanismos de autorización de PostgreSQL?

Porque TLS protege la comunicación entre el cliente y el servidor, pero no decide qué operaciones puede realizar un usuario después de conectarse. PostgreSQL necesita roles, permisos y políticas de acceso para impedir que una persona consulte o modifique información para la que no está autorizada.

### 5. ¿Qué ocurriría si una organización pierde una clave utilizada para cifrar información?

Si no existe una copia segura o un mecanismo de recuperación, la organización podría perder permanentemente el acceso a los datos cifrados con esa clave. Por eso es necesario contar con procedimientos de respaldo y recuperación de claves, protegidos con controles de acceso adecuados.

### 6. ¿Qué ocurriría si una clave criptográfica se publica accidentalmente en GitLab?

Una persona que obtenga la clave podría utilizarla para descifrar información protegida con ella, dependiendo de los datos y del algoritmo utilizados. El riesgo existe incluso si el repositorio es privado. La organización debería considerar la clave comprometida, restringir su uso, reemplazarla y evaluar qué información pudo quedar expuesta. También debe revisar el historial del repositorio, ya que borrar la clave del archivo actual no necesariamente la elimina de los commits anteriores.

### 7. ¿Por qué un repositorio privado no debe considerarse un almacén de secretos?

Porque los colaboradores autorizados, las cuentas comprometidas, las integraciones y el historial de Git pueden exponer su contenido. Además, los permisos del repositorio pueden cambiar y los archivos pueden copiarse o compartirse. Los secretos deben guardarse en un sistema especializado que permita controlar y auditar su acceso.

### 8. ¿Qué diferencia existe entre proteger información almacenada y proteger información durante su transmisión?

La protección de información almacenada busca evitar que los datos sean expuestos cuando están guardados en una base de datos, un disco o un respaldo. La protección durante la transmisión busca evitar que sean leídos o modificados mientras viajan por la red. El cifrado de datos almacenados y TLS son medidas complementarias para cubrir ambos escenarios.

### 9. ¿Por qué la gestión de claves es tan importante como el algoritmo criptográfico?

Porque la seguridad del cifrado depende de que las claves se mantengan protegidas. Un algoritmo sólido no puede evitar que una persona descifre la información si obtiene una clave válida. Por ello, las claves deben almacenarse de forma segura, tener acceso restringido, contar con respaldos controlados y reemplazarse cuando sea necesario.

### 10. ¿Qué mecanismo adicional implementarías en una organización para proteger los respaldos de las bases de datos?

Implementaría cifrado de los respaldos, almacenamiento en una ubicación separada y con acceso restringido, y administración de las claves fuera de los propios archivos de respaldo. También establecería políticas de retención, pruebas periódicas de restauración y controles para detectar accesos no autorizados. Así se reduciría el riesgo de exposición y se comprobaría que la información puede recuperarse cuando sea necesario.
