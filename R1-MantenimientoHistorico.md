# Mantenimiento Histórico de Precios de Flores

## Introducción

El mantenimiento histórico de precios es una funcionalidad esencial para gestionar de manera eficiente y transparente los cambios en los precios de las flores en una floristería. Este documento describe las funciones, vistas y triggers implementados para asegurar la integridad de los datos, facilitar la trazabilidad de los cambios y cumplir con las políticas de actualización de precios.

## Estructura General

- **Tablas Principales:**
    - `FLORISTERIAS`
    - `CATALOGO_FLORISTERIA`
    - `HISTORICO_PRECIO_FLOR`

- **Funciones:**
    - `cambiar_precio_flor_super()`
    - `cambiar_precio_flor_floristeria()`
    - `obtener_flores_precio_activo()`
    - `obtener_flores_precio_activo_floristeria()`

- **Vistas:**
    - `vista_detalles_historico_precio_flor_floristeria`
    - `vista_auditoria_cambios_precios`

- **Auditoría:**
    - Tabla `AUDITORIA_CAMBIOS_PRECIOS`
    - Trigger `trg_auditoria_cambios_precios()`

## Funciones

### 1. `cambiar_precio_flor_super()`

**Descripción:**  
Esta función está destinada al usuario Administrador y permite cambiar el precio de cualquier flor en el catálogo de la floristería. No está restringida a una floristería específica, lo que ofrece al Administrador la flexibilidad para realizar cambios globales.

**Parámetros:**
- `p_nombreFloristeria TEXT`: Nombre de la floristería.
- `p_nuevo_precio NUMERIC`: Nuevo precio a establecer.
- `p_idCatalogocodigo NUMERIC DEFAULT NULL`: Código del catálogo de la flor.
- `p_nombreFlor TEXT DEFAULT NULL`: Nombre de la flor.
- `p_idCorteFlor NUMERIC DEFAULT NULL`: ID del corte de la flor.

**Funcionamiento:**
1. Valida que al menos uno de los parámetros de identificación (código, nombre, corte) esté presente.
2. Obtiene el ID de la floristería basada en el nombre proporcionado.
3. Determina el `idCatalogocodigo` según el método de identificación.
4. Verifica si han pasado al menos 7 días desde la última actualización de precio.
5. Actualiza el `fechaFin` del registro anterior y crea un nuevo registro con el nuevo precio.

**Uso:**
```sql
SELECT cambiar_precio_flor_super(
    p_nombreFloristeria => 'FloraPrima',
    p_nuevo_precio      => 60.00,
    p_nombreFlor        => 'Rosa Imperial'
);
```

### 2. `cambiar_precio_flor_floristeria()`

**Descripción:**  
Esta función está diseñada para usuarios específicos de una floristería. Permite cambiar el precio de las flores solo dentro de la floristería asociada al usuario conectado, restringiendo así los privilegios para evitar cambios no autorizados.

**Parámetros:**
- `p_nuevo_precio NUMERIC`: Nuevo precio a establecer.
- `p_idCatalogocodigo NUMERIC DEFAULT NULL`: Código del catálogo de la flor.
- `p_nombreFlor TEXT DEFAULT NULL`: Nombre de la flor.
- `p_idCorteFlor NUMERIC DEFAULT NULL`: ID del corte de la flor.

**Funcionamiento:**
1. Valida que al menos uno de los parámetros de identificación (código, nombre, corte) esté presente.
2. Obtiene el ID de la floristería basada en el usuario conectado (CURRENT_USER).
3. Determina el `idCatalogocodigo` según el método de identificación.
4. Verifica si han pasado al menos 7 días desde la última actualización de precio.
5. Actualiza el `fechaFin` del registro anterior y crea un nuevo registro con el nuevo precio.

**Uso:**
```sql
SELECT cambiar_precio_flor_floristeria(
    p_nuevo_precio => 60.00,
    p_nombreFlor   => 'Rosa Imperial'
);
```

### 3. `obtener_flores_precio_activo()`

**Descripción:**  
Esta función retorna una tabla con las flores activas y expiradas, sin filtrar por ninguna floristería específica. Es útil para obtener una visión global del estado de los precios en todas las floristerías.

**Retorno:**
- `floristeria_nombre VARCHAR`
- `flor_nombre VARCHAR`
- `precio_actual NUMERIC`
- `dias_para_expirar INTEGER`
- `estado VARCHAR`

**Uso:**
```sql
SELECT * FROM obtener_flores_precio_activo();
```

### 4. `obtener_flores_precio_activo_floristeria()`

**Descripción:**  
Similar a `obtener_flores_precio_activo()`, esta función filtra los resultados para mostrar únicamente las flores asociadas a la floristería del usuario conectado. Además, incluye una validación adicional para mostrar solo los precios activos (sin `fechaFin`).

**Retorno:**
- `floristeria_nombre VARCHAR`
- `flor_nombre VARCHAR`
- `precio_actual NUMERIC`
- `dias_para_expirar INTEGER`
- `estado VARCHAR`

**Modificación Realizada:**  
Agregada la condición `AND h.fechaFin IS NULL` para filtrar solo los precios activos.

**Uso:**
```sql
SELECT * FROM obtener_flores_precio_activo_floristeria();
```

## Vistas

### `vista_detalles_historico_precio_flor_floristeria`

**Descripción:**  
Esta vista muestra el historial de precios de las flores filtrado por la floristería del usuario conectado. Permite visualizar los precios actuales y pasados junto con detalles relevantes.

**Definición:**
```sql
CREATE OR REPLACE VIEW vista_detalles_historico_precio_flor_floristeria AS
SELECT 
    f.nombre AS floristeria_nombre,
    c.nombrePropio AS flor_nombre,
    h.precio,
    h.fechaInicio,
    h.fechaFin,
    h.tamanoTallo
FROM HISTORICO_PRECIO_FLOR h
JOIN CATALOGO_FLORISTERIA c ON c.codigo = h.idCatalogocodigo
    AND c.idFloristeria = h.idCatalogoFloristeria
JOIN FLORISTERIAS f ON f.floristeriaId = c.idFloristeria
WHERE f.nombre ILIKE CURRENT_USER
ORDER BY f.nombre, c.nombrePropio, h.fechaInicio DESC;
```

**Uso:**
```sql
SELECT * FROM vista_detalles_historico_precio_flor_floristeria;
```

### `vista_auditoria_cambios_precios`

**Descripción:**  
Esta vista muestra el historial de auditoría de los cambios realizados en los precios de las flores, incluyendo detalles sobre quién realizó el cambio, qué acción se llevó a cabo, y los valores anteriores y nuevos.

**Definición:**
```sql
CREATE OR REPLACE VIEW vista_auditoria_cambios_precios AS
SELECT 
    a.auditoria_id,
    a.usuario,
    a.accion,
    f.nombre AS nombreFloristeria,
    a.nombreFlor,
    a.idCatalogoFloristeria,
    a.idCatalogocodigo,
    a.precio_anterior,
    a.precio_nuevo,
    a.tamanoTallo_anterior,
    a.tamanoTallo_nuevo,
    a.fecha,
    a.fechaInicio,
    a.fechaFin,
    a.descripcion
FROM AUDITORIA_CAMBIOS_PRECIOS a
JOIN CATALOGO_FLORISTERIA c ON a.idCatalogoFloristeria = c.idFloristeria 
                            AND a.idCatalogocodigo = c.codigo
JOIN FLORISTERIAS f ON c.idFloristeria = f.floristeriaId
ORDER BY a.fecha DESC;
```

**Uso:**
```sql
SELECT * FROM vista_auditoria_cambios_precios;
```

## Auditoría de Cambios

### 1. Tabla `AUDITORIA_CAMBIOS_PRECIOS`

**Descripción:**  
Esta tabla almacena un registro detallado de todos los cambios realizados en los precios de las flores, incluyendo quién realizó el cambio, qué acción se llevó a cabo, y los valores anteriores y nuevos.

**Definición:**
```sql
CREATE TABLE IF NOT EXISTS AUDITORIA_CAMBIOS_PRECIOS (
    auditoria_id SERIAL PRIMARY KEY,
    usuario VARCHAR NOT NULL,
    accion VARCHAR NOT NULL, -- INSERT, UPDATE, DELETE
    idCatalogoFloristeria NUMERIC,
    idCatalogocodigo NUMERIC,
    nombreFlor VARCHAR,
    precio_anterior NUMERIC,
    precio_nuevo NUMERIC,
    tamanoTallo_anterior NUMERIC,
    tamanoTallo_nuevo NUMERIC,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fechaInicio DATE,
    fechaFin DATE,
    descripcion TEXT
);
```

### 2. Función Trigger `trg_auditoria_cambios_precios()`

**Descripción:**  
Esta función se ejecuta automáticamente cada vez que se realiza una operación `INSERT`, `UPDATE` o `DELETE` en la tabla `HISTORICO_PRECIO_FLOR`. Registra los cambios en la tabla de auditoría `AUDITORIA_CAMBIOS_PRECIOS`.

**Definición:**
```sql
CREATE OR REPLACE FUNCTION trg_auditoria_cambios_precios()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO AUDITORIA_CAMBIOS_PRECIOS (
            usuario,
            accion,
            idCatalogoFloristeria,
            idCatalogocodigo,
            nombreFlor,
            precio_nuevo,
            tamanoTallo_nuevo,
            fechaInicio,
            fechaFin,
            descripcion
        ) VALUES (
            CURRENT_USER,
            TG_OP,
            NEW.idCatalogoFloristeria,
            NEW.idCatalogocodigo,
            (SELECT nombrePropio FROM CATALOGO_FLORISTERIA 
             WHERE idFloristeria = NEW.idCatalogoFloristeria 
               AND codigo = NEW.idCatalogocodigo),
            NEW.precio,
            NEW.tamanoTallo,
            NEW.fechaInicio,
            NEW.fechaFin,
            'Inserción de nuevo precio.'
        );
        RETURN NEW;
    
    ELSIF TG_OP = 'UPDATE' THEN
        IF NEW.fechaFin IS DISTINCT FROM OLD.fechaFin 
           AND NEW.precio IS NOT DISTINCT FROM OLD.precio
           AND NEW.tamanoTallo IS NOT DISTINCT FROM OLD.tamanoTallo
           AND NEW.fechaInicio IS NOT DISTINCT FROM OLD.fechaInicio THEN
            -- Solo se cambió fechaFin
            INSERT INTO AUDITORIA_CAMBIOS_PRECIOS (
                usuario,
                accion,
                idCatalogoFloristeria,
                idCatalogocodigo,
                nombreFlor,
                precio_anterior,
                precio_nuevo,
                tamanoTallo_anterior,
                tamanoTallo_nuevo,
                fechaInicio,
                fechaFin,
                descripcion
            ) VALUES (
                CURRENT_USER,
                TG_OP,
                OLD.idCatalogoFloristeria,
                OLD.idCatalogocodigo,
                (SELECT nombrePropio FROM CATALOGO_FLORISTERIA 
                 WHERE idFloristeria = OLD.idCatalogoFloristeria 
                   AND codigo = OLD.idCatalogocodigo),
                OLD.precio,
                OLD.precio,
                OLD.tamanoTallo,
                OLD.tamanoTallo,
                OLD.fechaInicio,
                NEW.fechaFin,
                'Se cerró el periodo de tiempo del precio.'
            );
        ELSE
            -- Se cambió algún otro campo además de fechaFin
            INSERT INTO AUDITORIA_CAMBIOS_PRECIOS (
                usuario,
                accion,
                idCatalogoFloristeria,
                idCatalogocodigo,
                nombreFlor,
                precio_anterior,
                precio_nuevo,
                tamanoTallo_anterior,
                tamanoTallo_nuevo,
                fechaInicio,
                fechaFin,
                descripcion
            ) VALUES (
                CURRENT_USER,
                TG_OP,
                OLD.idCatalogoFloristeria,
                OLD.idCatalogocodigo,
                (SELECT nombrePropio FROM CATALOGO_FLORISTERIA 
                 WHERE idFloristeria = OLD.idCatalogoFloristeria 
                   AND codigo = OLD.idCatalogocodigo),
                OLD.precio,
                NEW.precio,
                OLD.tamanoTallo,
                NEW.tamanoTallo,
                NEW.fechaInicio,
                NEW.fechaFin,
                'Actualización de precio.'
            );
        END IF;
        RETURN NEW;
    
    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO AUDITORIA_CAMBIOS_PRECIOS (
            usuario,
            accion,
            idCatalogoFloristeria,
            idCatalogocodigo,
            nombreFlor,
            precio_anterior,
            precio_nuevo,
            tamanoTallo_anterior,
            tamanoTallo_nuevo,
            fechaInicio,
            fechaFin,
            descripcion
        ) VALUES (
            CURRENT_USER,
            TG_OP,
            OLD.idCatalogoFloristeria,
            OLD.idCatalogocodigo,
            (SELECT nombrePropio FROM CATALOGO_FLORISTERIA 
             WHERE idFloristeria = OLD.idCatalogoFloristeria 
               AND codigo = OLD.idCatalogocodigo),
            OLD.precio,
            NULL,
            OLD.tamanoTallo,
            NULL,
            OLD.fechaInicio,
            OLD.fechaFin,
            'Eliminación de precio.'
        );
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;
```

### 3. Triggers en `HISTORICO_PRECIO_FLOR`

**Descripción:**  
Se crean tres triggers que disparan la función de auditoría para cada operación `INSERT`, `UPDATE` y `DELETE` en la tabla `HISTORICO_PRECIO_FLOR`.

**Definición:**
```sql
-- Trigger para INSERT
CREATE TRIGGER trg_auditoria_insert
AFTER INSERT ON HISTORICO_PRECIO_FLOR
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_cambios_precios();

-- Trigger para UPDATE
CREATE TRIGGER trg_auditoria_update
AFTER UPDATE ON HISTORICO_PRECIO_FLOR
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_cambios_precios();

-- Trigger para DELETE
CREATE TRIGGER trg_auditoria_delete
AFTER DELETE ON HISTORICO_PRECIO_FLOR
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_cambios_precios();
```