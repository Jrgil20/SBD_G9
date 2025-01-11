# Diseño de Seguridad de la Base de Datos

## Crear Tablespace

El primer paso sería crear un tablespace con el siguiente SQL:

```sql
CREATE TABLESPACE "SistemasBasedeDatos"
    OWNER postgres
    LOCATION E'F:\\tablespace';

ALTER TABLESPACE "SistemasBasedeDatos"
    OWNER TO postgres;
```

### **Parámetros Explicados**

1. **CREATE TABLESPACE "SistemasBasedeDatos"**
     - Crea un nuevo tablespace en PostgreSQL con el nombre `SistemasBasedeDatos`. El nombre del tablespace está entre comillas dobles, lo que permite el uso de caracteres especiales y mayúsculas.

2. **OWNER postgres**
     - Especifica que el propietario del tablespace es el usuario `postgres`. El propietario tiene todos los privilegios sobre el tablespace.

3. **LOCATION E'F:\\tablespace'**
     - Define la ubicación física del tablespace en el sistema de archivos. En este caso, el tablespace se almacenará en la ruta `F:\\tablespace`.

4. **ALTER TABLESPACE "SistemasBasedeDatos" OWNER TO postgres**
     - Cambia el propietario del tablespace `SistemasBasedeDatos` al usuario `postgres`. Esto asegura que el usuario `postgres` tenga control total sobre el tablespace.

#### **Resumen**

Este comando crea un tablespace llamado `SistemasBasedeDatos` en la ubicación especificada y asigna al usuario `postgres` como propietario. El tablespace es una estructura de almacenamiento que permite organizar los datos en diferentes ubicaciones físicas en el sistema de archivos.

## Super Usuario
Iniciamos creando un rol super usuario, debería quedar con el siguiente SQL:

```sql
CREATE ROLE "ADMINISTRADOR" WITH
    LOGIN
    SUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    NOREPLICATION
    BYPASSRLS
    CONNECTION LIMIT -1
    VALID UNTIL '2025-12-29T00:00:00-04:00'
    PASSWORD 'xxxxxx';
```

### **Parámetros Explicados**

1. **CREATE ROLE "ADMINISTRADOR "**
   - Crea un nuevo rol (usuario) en PostgreSQL con el nombre `ADMINISTRADOR `. El nombre del rol está entre comillas dobles, lo que permite el uso de caracteres especiales y mayúsculas.

2. **LOGIN**
   - Permite que el rol se use para iniciar sesión en la base de datos. Sin este atributo, el rol no puede autenticarse en PostgreSQL.

3. **SUPERUSER**
   - Otorga al rol todos los privilegios del superusuario. Esto significa que el rol tiene permisos completos para realizar cualquier operación en la base de datos, incluyendo la capacidad de sobrepasar todas las restricciones de acceso.

4. **CREATEDB**
   - Autoriza al rol a crear nuevas bases de datos. Este privilegio es útil para administradores y desarrolladores que necesitan crear entornos de prueba o nuevas bases de datos.

5. **CREATEROLE**
   - Permite al rol crear, modificar y eliminar otros roles. Esto es esencial para la administración de usuarios y roles en el sistema de bases de datos.

6. **INHERIT**
   - Indica que el rol puede heredar los privilegios de otros roles a los que pertenece. Esto permite que los permisos se transmitan a través de una jerarquía de roles.

7. **NOREPLICATION**
   - Especifica que el rol no tiene privilegios de replicación. Los privilegios de replicación son necesarios para roles que gestionan la replicación de datos entre servidores PostgreSQL.

8. **BYPASSRLS**
   - Permite al rol omitir las políticas de seguridad a nivel de fila (Row Level Security, RLS). Esto es particularmente poderoso y debe usarse con precaución, ya que permite al rol ver y modificar filas que normalmente estarían restringidas por políticas de seguridad.

9. **CONNECTION LIMIT -1**
   - Define el número máximo de conexiones simultáneas que el rol puede tener. Un valor de `-1` significa que no hay límite en el número de conexiones.

10. **VALID UNTIL '2025-12-29T00:00:00-04:00'**
    - Establece una fecha y hora de expiración para el rol. Después de esta fecha, el rol no podrá iniciar sesión. La fecha y hora están en formato de zona horaria específica (`-04:00`).

11. **PASSWORD 'xxxxxx'**
    - Define la contraseña del rol para la autenticación. Esta contraseña es necesaria para que el rol pueda iniciar sesión en la base de datos.

#### **Resumen**

Este comando configura un rol `ADMINISTRADOR ` con privilegios de superusuario, permitiendo la creación de bases de datos y roles, y ciertas capacidades adicionales como ignorar las políticas de seguridad a nivel de fila. También se establece un límite de tiempo para la validez del rol y se define una contraseña para la autenticación.

## Crear Base de Datos

Creamos la base de datos, debería quedar con el siguiente SQL:

```sql
CREATE DATABASE "SubastaHolandesa"
    WITH
    OWNER = "ADMINISTRADOR"
    ENCODING = 'UTF8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = "SistemasBasedeDatos"
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```

### **Parámetros Explicados**

1. **CREATE DATABASE "SubastaHolandesa"**
   - Crea una nueva base de datos en PostgreSQL con el nombre `SubastaHolandesa`. El nombre de la base de datos está entre comillas dobles, lo que permite el uso de caracteres especiales y mayúsculas.

2. **OWNER = "ADMINISTRADOR"**
   - Especifica que el propietario de la base de datos es el rol `ADMINISTRADOR`. El propietario tiene todos los privilegios sobre la base de datos.

3. **ENCODING = 'UTF8'**
   - Define la codificación de caracteres para la base de datos. `UTF8` es una codificación de caracteres ampliamente utilizada que soporta una amplia gama de caracteres.

4. **LOCALE_PROVIDER = 'libc'**
   - Especifica el proveedor de configuración regional para la base de datos. `libc` es el proveedor de configuración regional estándar en muchos sistemas operativos.

5. **TABLESPACE = "SistemasBasedeDatos"**
   - Define el tablespace donde se almacenará la base de datos. En este caso, la base de datos se almacenará en el tablespace `SistemasBasedeDatos`.

6. **CONNECTION LIMIT = -1**
   - Define el número máximo de conexiones simultáneas que la base de datos puede tener. Un valor de `-1` significa que no hay límite en el número de conexiones.

7. **IS_TEMPLATE = False**
   - Indica que la base de datos no se puede utilizar como plantilla para crear otras bases de datos.

#### **Resumen**

Este comando crea una base de datos llamada `SubastaHolandesa` con el propietario `ADMINISTRADOR`, utilizando la codificación `UTF8` y almacenada en el tablespace `SistemasBasedeDatos`. No hay límite en el número de conexiones y la base de datos no se puede usar como plantilla.

## Crear Rol de Desarrollador

Creamos el rol de desarrollador con el siguiente SQL:

```sql
CREATE ROLE "DESARROLLADOR" WITH
    LOGIN
    NOSUPERUSER
    CREATEDB
    CREATEROLE
    INHERIT
    NOREPLICATION
    NOBYPASSRLS
    CONNECTION LIMIT -1
    VALID UNTIL '2025-12-29T00:00:00-04:00'
    PASSWORD 'xxxxxx';
```

### **Parámetros Explicados**

1. **CREATE ROLE "DESARROLLADOR"**
   - Crea un nuevo rol (usuario) en PostgreSQL con el nombre `DESARROLLADOR`. El nombre del rol está entre comillas dobles, lo que permite el uso de caracteres especiales y mayúsculas.

2. **LOGIN**
   - Permite que el rol se use para iniciar sesión en la base de datos. Sin este atributo, el rol no puede autenticarse en PostgreSQL.

3. **NOSUPERUSER**
   - Especifica que el rol no tiene privilegios de superusuario. Esto limita las capacidades del rol para realizar operaciones administrativas críticas.

4. **CREATEDB**
   - Autoriza al rol a crear nuevas bases de datos. Este privilegio es útil para desarrolladores que necesitan crear entornos de prueba o nuevas bases de datos.

5. **CREATEROLE**
   - Permite al rol crear, modificar y eliminar otros roles. Esto es esencial para la administración de usuarios y roles en el sistema de bases de datos.

6. **INHERIT**
   - Indica que el rol puede heredar los privilegios de otros roles a los que pertenece. Esto permite que los permisos se transmitan a través de una jerarquía de roles.

7. **NOREPLICATION**
   - Especifica que el rol no tiene privilegios de replicación. Los privilegios de replicación son necesarios para roles que gestionan la replicación de datos entre servidores PostgreSQL.

8. **NOBYPASSRLS**
   - Indica que el rol no puede omitir las políticas de seguridad a nivel de fila (Row Level Security, RLS). Esto asegura que el rol esté sujeto a las políticas de seguridad definidas.

9. **CONNECTION LIMIT -1**
   - Define el número máximo de conexiones simultáneas que el rol puede tener. Un valor de `-1` significa que no hay límite en el número de conexiones.

10. **VALID UNTIL '2025-12-29T00:00:00-04:00'**
    - Establece una fecha y hora de expiración para el rol. Después de esta fecha, el rol no podrá iniciar sesión. La fecha y hora están en formato de zona horaria específica (`-04:00`).

11. **PASSWORD 'xxxxxx'**
    - Define la contraseña del rol para la autenticación. Esta contraseña es necesaria para que el rol pueda iniciar sesión en la base de datos.

#### **Resumen**

Este comando configura un rol `DESARROLLADOR` con privilegios para crear bases de datos y roles, pero sin privilegios de superusuario ni la capacidad de omitir políticas de seguridad a nivel de fila. También se establece un límite de tiempo para la validez del rol y se define una contraseña para la autenticación.


## Crear Base de Datos desde el Usuario Desarrollador

Para crear la base de datos utilizando los comandos de `commands.sql` desde el usuario `DESARROLLADOR`, primero asegúrate de que el usuario `DESARROLLADOR` tenga los permisos necesarios para ejecutar los comandos en el archivo `commands.sql`.

### **Pasos a Seguir**

1. **Iniciar Sesión como DESARROLLADOR**

    Inicia sesión en PostgreSQL utilizando el rol `DESARROLLADOR`:

    ```sh
    psql -U DESARROLLADOR -d postgres
    ```

2. **Ejecutar el Archivo commands.sql**

    Una vez que hayas iniciado sesión, ejecuta el archivo `commands.sql`:

    ```sh
    \i /ruta/a/commands.sql
    ```

    Asegúrate de reemplazar `/ruta/a/commands.sql` con la ruta real al archivo `commands.sql`.

### **Resumen**

Estos pasos permiten al usuario `DESARROLLADOR` crear la base de datos ejecutando los comandos contenidos en el archivo `commands.sql`. Asegúrate de que el archivo `commands.sql` contenga los comandos SQL necesarios para la creación de la base de datos y que el usuario `DESARROLLADOR` tenga los permisos adecuados para ejecutar dichos comandos.

## Crear Roles Específicos para Usuarios Operacionales

Creamos los roles específicos para usuarios operacionales con el siguiente SQL:

```sql
CREATE ROLE "USUARIO_SUBASTADORA";
CREATE ROLE "USUARIO_PRODUCTOR";
CREATE ROLE "USUARIO_FLORISTERIA";
```

### **Parámetros Explicados**

1. **CREATE ROLE "USUARIO_SUBASTADORA"**
    - Crea un nuevo rol en PostgreSQL con el nombre `USUARIO_SUBASTADORA`. Este rol puede ser utilizado para asignar permisos específicos a los usuarios que operan como subastadores.

2. **CREATE ROLE "USUARIO_PRODUCTOR"**
    - Crea un nuevo rol en PostgreSQL con el nombre `USUARIO_PRODUCTOR`. Este rol puede ser utilizado para asignar permisos específicos a los usuarios que operan como productores.

3. **CREATE ROLE "USUARIO_FLORISTERIA"**
    - Crea un nuevo rol en PostgreSQL con el nombre `USUARIO_FLORISTERIA`. Este rol puede ser utilizado para asignar permisos específicos a los usuarios que operan como floristerías.

#### **Resumen**

Estos comandos crean tres roles específicos (`USUARIO_SUBASTADORA`, `USUARIO_PRODUCTOR`, `USUARIO_FLORISTERIA`) que pueden ser utilizados para gestionar permisos y accesos de diferentes tipos de usuarios operacionales en el sistema de bases de datos.

## Asignar Permisos a Roles Específicos

```sql
-- Asignar permisos al rol ADMINISTRADOR
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ADMINISTRADOR;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ADMINISTRADOR;

-- Asignar permisos al rol DESARROLLADOR
GRANT USAGE, SELECT, UPDATE, INSERT ON ALL TABLES IN SCHEMA public TO DESARROLLADOR;
GRANT EXECUTE ON ALL FUNCTIONS IN SCHEMA public TO DESARROLLADOR;

-- Asignar permisos específicos al rol USUARIO_SUBASTADORA
GRANT INSERT, UPDATE ON TABLE CONTRATO TO USUARIO_SUBASTADORA;
GRANT INSERT, UPDATE ON TABLE PAGOS TO USUARIO_SUBASTADORA;
GRANT INSERT, UPDATE ON TABLE LOTE TO USUARIO_SUBASTADORA;
GRANT INSERT, UPDATE ON TABLE FACTURA TO USUARIO_SUBASTADORA;
GRANT INSERT, UPDATE ON TABLE AFILIACION TO USUARIO_SUBASTADORA;

-- Asignar permisos específicos al rol USUARIO_PRODUCTOR
GRANT INSERT, UPDATE ON TABLE FLOR_CORTES TO USUARIO_PRODUCTOR;
GRANT INSERT, UPDATE ON TABLE CATALOGOPRODUCTOR TO USUARIO_PRODUCTOR;
GRANT INSERT, UPDATE ON TABLE CANTIDAD_OFRECIDA TO USUARIO_PRODUCTOR;

-- Asignar permisos específicos al rol USUARIO_FLORISTERIA
GRANT INSERT, UPDATE ON TABLE CATALOGO_FLORISTERIA TO USUARIO_FLORISTERIA;
GRANT INSERT, UPDATE ON TABLE COLOR TO USUARIO_FLORISTERIA;
GRANT INSERT, UPDATE ON TABLE DETALLEBOUQUET TO USUARIO_FLORISTERIA;
GRANT INSERT, UPDATE ON TABLE HISTORICOPRECIOFLOR TO USUARIO_FLORISTERIA;
GRANT INSERT, UPDATE ON TABLE DETALLEFACTURA TO USUARIO_FLORISTERIA;
GRANT INSERT, UPDATE ON TABLE FACTURAFINAL TO USUARIO_FLORISTERIA;
GRANT INSERT, UPDATE ON TABLE CLIENTE_NATURAL TO USUARIO_FLORISTERIA;
GRANT INSERT, UPDATE ON TABLE CLIENTE_JURIDICO TO USUARIO_FLORISTERIA;

-- Creación y asignación de permisos para vistas
CREATE VIEW V_CATALOGO_FLORISTERIA AS
SELECT *
FROM CATALOGO_FLORISTERIA
WHERE idFloristeria = CURRENT_USER_ID; -- Necesitas implementar una función para obtener el ID del usuario actual

GRANT SELECT ON V_CATALOGO_FLORISTERIA TO USUARIO_FLORISTERIA;

CREATE VIEW V_FACTURAS AS
SELECT *
FROM FACTURA
WHERE idAfiliacionFloristeria = CURRENT_USER_FLORISTERIA_ID; -- Implementa la lógica correspondiente

GRANT SELECT ON V_FACTURAS TO USUARIO_FLORISTERIA;
```

#### **Resumen**

Estos comandos asignan permisos específicos a los roles `ADMINISTRADOR`, `DESARROLLADOR`, `USUARIO_SUBASTADORA`, `USUARIO_PRODUCTOR` y `USUARIO_FLORISTERIA`. Además, se crean vistas y se asignan permisos de selección a las vistas para el rol `USUARIO_FLORISTERIA`.