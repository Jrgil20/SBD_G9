# Diseño de Seguridad de la Base de Datos

## Crear Tablespace

El primer paso sería crear un tablespace con el siguiente SQL:

```sql
-- Tablespace: SistemasBasedeDatos
-- DROP TABLESPACE IF EXISTS SistemasBasedeDatos;

CREATE TABLESPACE "SistemasBasedeDatos"
  OWNER postgres
  LOCATION D:\SBD_G9\tablespace;

ALTER TABLESPACE "SistemasBasedeDatos"
  OWNER TO postgres;
```


## Super Role
Iniciamos creando un rol super usuario, debería quedar con el siguiente SQL:

```sql
-- Role: "Administrador "
-- DROP ROLE IF EXISTS "Administrador ";

CREATE ROLE "Administrador " WITH
  NOLOGIN
  SUPERUSER
  INHERIT
  CREATEDB
  CREATEROLE
  NOREPLICATION
  BYPASSRLS;
```
### Crear super usuario a partir del rol 

```sql
-- Role: "Admin_Sbd-G9"
-- DROP ROLE IF EXISTS "Admin_Sbd-G9";

CREATE ROLE "Admin_Sbd-G9" WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:v/RA7+YDl3WMi2Ls/gGzxw==$Th38jQzjzgfrqcMmijNOGcgevlJJnTwdXE3u+L+Dx7A=:hdL4l3GP7pjBgQ8vtB21CjEyz0pMClIwvvPpbnwZsyk=';

GRANT "Administrador " TO "Admin_Sbd-G9";
``` 
> para efectos practicos la contrasena es 'admin'

## Crear Base de Datos

Creamos la base de datos enel tablespace creado y con el nuevo usuario, debería quedar con el siguiente SQL:

```sql
-- Database: SubastaHolandesa
-- DROP DATABASE IF EXISTS "SubastaHolandesa";

CREATE DATABASE "SubastaHolandesa"
    WITH
    OWNER = "Admin_Sbd-G9"
    ENCODING = 'UTF8'
    LC_COLLATE = 'Spanish_Spain.1252'
    LC_CTYPE = 'Spanish_Spain.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = "SistemasBasedeDatos"
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
```

## Crear Rol de Desarrollador

Creamos el rol de desarrollador con el siguiente SQL:

```sql
-- Role: "Desarrollador"
-- DROP ROLE IF EXISTS "Desarrollador";

CREATE ROLE "Desarrollador" WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  CREATEROLE
  NOREPLICATION
  NOBYPASSRLS;
```

### creamos el usuario desarrollador 
 creamo el suario a partir de rol con el sig sql:

 ```sql
-- Role: "dev_Sbd-g9"
-- DROP ROLE IF EXISTS "dev_Sbd-g9";

CREATE ROLE "dev_Sbd-g9" WITH
  LOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS
  ENCRYPTED PASSWORD 'SCRAM-SHA-256$4096:c3QPr7UNtrtW5kTIM+neRQ==$Qav3wu8hYmaajaLs7YafKDDAB8JnGi58DsIH3mGLiFc=:feN840+3rInUuVlQSapcV4zhXC+7LIU9VfKgjN0u+VU='
  VALID UNTIL '2026-01-13 00:00:00-04';

GRANT "Desarrollador" TO "dev_Sbd-g9";
```
> para efectos practicos la contrasena es 'dev'


## Conectate como administrador 

### verificar usuario:

```sql
SELECT current_user;
```

### cambiar propiedad del schema public

```sql
ALTER SCHEMA public
    OWNER TO "Admin_Sbd-G9";
```

### concede permisos al usuario desarrolador:

```sql
-- Concede todos los privilegios en la base de datos
GRANT ALL PRIVILEGES ON DATABASE "SubastaHolandesa" TO "dev_Sbd";

-- Concede todos los privilegios en todas las tablas de la base de datos
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO "dev_Sbd";

-- Concede todos los privilegios en todas las secuencias de la base de datos
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO "dev_Sbd";

-- Concede todos los privilegios en todas las funciones de la base de datos
GRANT ALL PRIVILEGES ON ALL FUNCTIONS IN SCHEMA public TO "dev_Sbd";
```

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

## creamos lso roles usuario

### floriteria

```sql
-- Role: "Floristeria "
-- DROP ROLE IF EXISTS "Floristeria ";

CREATE ROLE "Floristeria " WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS;
```

### Subastadora

```sql
-- Role: "Subastadora"
-- DROP ROLE IF EXISTS "Subastadora";

CREATE ROLE "Subastadora" WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS;
```

### Productora

```sql
-- Role: "Productora"
-- DROP ROLE IF EXISTS "Productora";

CREATE ROLE "Productora" WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS;
```

### cliente

```sql
-- Role: cliente
-- DROP ROLE IF EXISTS cliente;

CREATE ROLE cliente WITH
  NOLOGIN
  NOSUPERUSER
  INHERIT
  NOCREATEDB
  NOCREATEROLE
  NOREPLICATION
  NOBYPASSRLS;
```