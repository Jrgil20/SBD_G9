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
    - `abrir_nuevo_periodo_precio()`

- **Vistas:**
    - `vista_detalles_historico_precio_flor_floristeria`
    - `vista_auditoria_cambios_precios`

- **Auditoría:**
    - Tabla `AUDITORIA_CAMBIOS_PRECIOS`
    - Trigger `trg_auditoria_cambios_precios()`

## Triggers

### Auditoría de Cambios

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

### Función Trigger `trg_auditoria_cambios_precios()`

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

### Triggers en `HISTORICO_PRECIO_FLOR`

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
WHERE f.nombre ILIKE LEFT(CURRENT_USER, LENGTH(CURRENT_USER) - 1)
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

## Superfunción del Requerimiento 1

### `cambiar_precio_flor_super()`

**Descripción:**  
Esta función está destinada al usuario Administrador y permite cambiar el precio de cualquier flor en el catálogo de la floristería. No está restringida a una floristería específica, lo que ofrece al Administrador la flexibilidad para realizar cambios globales.

**Parámetros:**
- `p_nombreFloristeria TEXT`: Nombre de la floristería.
- `p_nuevo_precio NUMERIC`: Nuevo precio a establecer.
- `p_idCatalogocodigo NUMERIC DEFAULT NULL`: Código del catálogo de la flor.
- `p_nombreFlor TEXT DEFAULT NULL`: Nombre de la flor.
- `p_idCorteFlor NUMERIC DEFAULT NULL`: ID del corte de la flor.
- `p_tamanoTallo NUMERIC DEFAULT NULL`: Tamaño del tallo.

**Funcionamiento:**
1. Valida que al menos uno de los parámetros de identificación (código, nombre, corte) esté presente.
2. Obtiene el ID de la floristería basada en el nombre proporcionado.
3. Determina el `idCatalogocodigo` según el método de identificación.
4. Verifica si han pasado al menos 7 días desde la última actualización de precio.
5. Actualiza el `fechaFin` del registro anterior y crea un nuevo registro con el nuevo precio.

**Definición:**
```sql
CREATE OR REPLACE FUNCTION cambiar_precio_flor_super(
    p_nombreFloristeria TEXT,
    p_nuevo_precio NUMERIC,
    p_idCatalogocodigo NUMERIC DEFAULT NULL,
    p_nombreFlor TEXT DEFAULT NULL,
    p_idCorteFlor NUMERIC DEFAULT NULL,
    p_tamanoTallo NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
    v_idFloristeria NUMERIC;
    v_idCatalogoFloristeria NUMERIC;
    v_idCatalogocodigo NUMERIC;
    last_fechaInicio TIMESTAMP;
    last_tamanoTallo NUMERIC;
    today TIMESTAMP := current_timestamp AT TIME ZONE 'GMT-4';
    dias_transcurridos INTEGER;
BEGIN
    -- Validar que se proporcione al menos uno de los métodos de identificación adicionales
    IF p_idCatalogocodigo IS NULL AND p_nombreFlor IS NULL AND p_idCorteFlor IS NULL THEN
        RETURN 'Debe proporcionar al menos uno de los siguientes parámetros para identificar la flor: p_idCatalogocodigo, p_nombreFlor, o p_idCorteFlor.';
    END IF;

    IF p_tamanoTallo IS NULL THEN
        RETURN 'Debe especificar un tamaño de tallo para identificar la flor.';
    END IF;

    -- Obtener floristeriaId basado en p_nombreFloristeria
    SELECT floristeriaId INTO v_idFloristeria
    FROM FLORISTERIAS
    WHERE nombre ILIKE p_nombreFloristeria
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN 'No se encontró la floristería especificada.';
    END IF;

    -- Obtener idCatalogoFloristeria basado en floristeriaId
    SELECT codigo INTO v_idCatalogoFloristeria
    FROM CATALOGO_FLORISTERIA
    WHERE idFloristeria = v_idFloristeria
    LIMIT 1;

    IF NOT FOUND THEN
        RETURN 'No se encontró el catálogo para la floristería especificada.';
    END IF;

    -- Determinar el idCatalogocodigo basado en los parámetros opcionales
    IF p_idCatalogocodigo IS NOT NULL THEN
        -- Método 1: Identificación por idCatalogocodigo
        v_idCatalogocodigo := p_idCatalogocodigo;
        RAISE NOTICE 'Método de identificación: idCatalogocodigo=%', v_idCatalogocodigo;
    ELSIF p_nombreFlor IS NOT NULL THEN
        -- Método 2: Identificación por nombreFlor
        SELECT codigo INTO v_idCatalogocodigo
        FROM CATALOGO_FLORISTERIA
        WHERE nombrePropio ILIKE p_nombreFlor
          AND idFloristeria = v_idFloristeria
        ORDER BY codigo DESC
        LIMIT 1;

        IF NOT FOUND THEN
            RETURN 'No se encontró la flor con el nombre especificado en la floristería.';
        END IF;

        RAISE NOTICE 'Método de identificación: nombreFlor=% con idCatalogocodigo=%', p_nombreFlor, v_idCatalogocodigo;
    ELSIF p_idCorteFlor IS NOT NULL THEN
        -- Método 3: Identificación por idCorteFlor
        SELECT codigo INTO v_idCatalogocodigo
        FROM CATALOGO_FLORISTERIA
        WHERE idCorteFlor = p_idCorteFlor
          AND idFloristeria = v_idFloristeria
        LIMIT 1;

        IF NOT FOUND THEN
            RETURN 'No se encontró la flor con el idCorteFlor especificado en la floristería.';
        END IF;

        RAISE NOTICE 'Método de identificación: idCorteFlor=% con idCatalogocodigo=%', p_idCorteFlor, v_idCatalogocodigo;
    END IF;

    -- Verificar que v_idCatalogocodigo haya sido determinado
    IF v_idCatalogocodigo IS NULL THEN
        RETURN 'No se pudo determinar el idCatalogocodigo de la flor especificada.';
    END IF;

    -- Obtener la última fechaInicio y tamanoTallo del historial de precios
    SELECT fechaInicio, tamanoTallo INTO last_fechaInicio, last_tamanoTallo
    FROM HISTORICO_PRECIO_FLOR
    WHERE idCatalogoFloristeria = v_idCatalogoFloristeria
      AND idCatalogocodigo = v_idCatalogocodigo
      AND tamanoTallo = p_tamanoTallo
    ORDER BY fechaInicio DESC
    LIMIT 1;

    IF last_fechaInicio IS NULL THEN
        RETURN 'No existen registros de precio para esta flor en la floristería especificada.';
    END IF;

    RAISE NOTICE 'Último registro encontrado: fechaInicio=%, tamanoTallo=%', last_fechaInicio, last_tamanoTallo;

    -- Verificar si tamanoTallo es NULL y obtener el último valor válido si es necesario
    IF last_tamanoTallo IS NULL THEN
        RAISE NOTICE 'El tamanoTallo del último registro es NULL, buscando el último valor válido.';
        SELECT tamanoTallo INTO last_tamanoTallo
        FROM HISTORICO_PRECIO_FLOR
        WHERE idCatalogoFloristeria = v_idCatalogoFloristeria
          AND idCatalogocodigo = v_idCatalogocodigo
          AND tamanoTallo IS NOT NULL
        ORDER BY fechaInicio DESC
        LIMIT 1;

        IF last_tamanoTallo IS NULL THEN
            RETURN 'No se encontró un valor válido para tamanoTallo en los registros anteriores.';
        END IF;

        RAISE NOTICE 'Último tamanoTallo válido encontrado: tamanoTallo=%', last_tamanoTallo;
    END IF;

    -- Calcular los días transcurridos desde la última fecha de inicio
    dias_transcurridos := EXTRACT(DAY FROM AGE(today, last_fechaInicio));

    RAISE NOTICE 'Días transcurridos desde la última actualización: %', dias_transcurridos;

    IF dias_transcurridos >= 7 THEN
        -- Actualizar la fechaFin del último registro al día actual
        UPDATE HISTORICO_PRECIO_FLOR
        SET fechaFin = today
        WHERE idCatalogoFloristeria = v_idCatalogoFloristeria
          AND idCatalogocodigo = v_idCatalogocodigo
          AND fechaInicio = last_fechaInicio;

        RAISE NOTICE 'Actualizado fechaFin del último registro a %', today;

        -- Insertar el nuevo registro con el nuevo precio y el mismo tamaño de tallo
        INSERT INTO HISTORICO_PRECIO_FLOR (
            idCatalogoFloristeria,
            idCatalogocodigo,
            fechaInicio,
            fechaFin,
            precio,
            tamanoTallo
        ) VALUES (
            v_idCatalogoFloristeria,
            v_idCatalogocodigo,
            today,
            NULL,
            p_nuevo_precio,
            p_tamanoTallo
        );

        RAISE NOTICE 'Insertado nuevo registro con precio=% y tamanoTallo=%', p_nuevo_precio, p_tamanoTallo;

        RETURN 'Precio actualizado exitosamente.';
    ELSE
        RETURN 'No es posible cambiar el precio por las políticas de la floristería que permiten un máximo de 7 días por precio.';
    END IF;
END;
$$ LANGUAGE plpgsql;
```

## Otros

### Caso de Prueba para "agregar_o_cambiar_precio_flor"
Utilizando la función "agregar_o_cambiar_precio_flor", se puede insertar un nuevo histórico si no existe registro previo o cambiarlo si ya existe. Ejemplo:
```sql
SELECT agregar_o_cambiar_precio_flor(
    p_nombreFloristeria => 'FloraPrima',
    p_nuevo_precio      => 29.90,
    p_nombreFlor        => 'Rosa Blanca',
    p_tamanoTallo       => 55,
    p_fechaInicio       => '2025-01-01 09:00:00',
    p_esFloristeria     => FALSE
);
```

### Caso de Prueba para "abrir_nuevo_periodo_precio"
Utilizando la función "abrir_nuevo_periodo_precio", se puede insertar un nuevo registro en el histórico de precios si el registro existe en `Catalogo_floristeria`. Ejemplo:
```sql
SELECT abrir_nuevo_periodo_precio(
    p_nombreFloristeria => 'FloraPrima',
    p_idCatalogocodigo  => 1,
    p_nuevo_precio      => 25.00,
    p_tamanoTallo       => 50,
    p_fechaInicio       => '2025-01-01 09:00:00'
);
```