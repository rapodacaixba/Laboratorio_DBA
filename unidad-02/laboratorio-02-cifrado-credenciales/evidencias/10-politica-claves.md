**10 \- Crear una política mínima de protección de claves**

Nombre: Raquel Apodaca Caixba  
Grupo: 4-4

Reglas

1\. Generación de claves: Las claves deben generarse mediante mecanismos criptográficos seguros y con una longitud apropiada para el algoritmo utilizado. No deben elegirse valores fáciles de adivinar.

2\. Almacenamiento seguro: Las claves deben guardarse en un sistema seguro de gestión de secretos o claves, separado de las bases de datos y del código fuente que las utiliza.

3\. Control de acceso: Solamente las personas y aplicaciones autorizadas deben tener acceso a las claves. Los permisos deben limitarse a lo estrictamente necesario.

4\. Rotación periódica: Las claves deben renovarse de acuerdo con la política de seguridad de la organización, los riesgos identificados y las recomendaciones del mecanismo criptográfico utilizado.

5\. Respaldo protegido: Cuando sea necesario respaldar claves, los respaldos deben almacenarse de forma segura y contar con controles de acceso y protección adecuados para evitar su pérdida o exposición.

6\. Revocación: Las claves que hayan sido comprometidas, que ya no sean necesarias o que deban retirarse deben revocarse o deshabilitarse oportunamente. También se debe evaluar si es necesario volver a cifrar los datos afectados.

7\. Exposición accidental: Si una clave aparece en un repositorio, una captura, un registro o un archivo compartido, debe considerarse comprometida hasta que se evalúe el incidente. Se debe restringir su uso, sustituirla cuando corresponda y revisar el alcance de la exposición.

8\. Eliminación segura: Las claves que ya no se necesiten deben eliminarse mediante procedimientos adecuados, considerando las copias de respaldo y los sistemas donde pudieran permanecer almacenadas.

Conclusión

Una gestión adecuada de claves permite reducir el riesgo de acceso no autorizado a la información cifrada. Por eso, su protección debe incluir todo su ciclo de vida, desde la generación hasta la eliminación, y no solamente el momento en que se utilizan para cifrar datos.