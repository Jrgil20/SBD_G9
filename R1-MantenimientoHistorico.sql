-----------------------------------------------------------------------
-- REQUERIMIENTO 1 - MANTENIMIENTO DE HISTORICO DE PRECIOS DE FLORES --
-----------------------------------------------------------------------
CREATE OR REPLACE FUNCTION cambiar_precio_flor(
    p_idCatalogoFloristeria NUMERIC,
    p_idCatalogocodigo NUMERIC,   --Verificar si es mas eficiente con el id del corte de la flor
    p_nuevo_precio NUMERIC
)
RETURNS TEXT AS $$
DECLARE
    last_fechaInicio DATE;
    last_tamanotallo NUMERIC;
    today DATE := CURRENT_DATE;
    dias_transcurridos INTEGER;
BEGIN
    -- Obtener la fecha de inicio y el tamaño del tallo del último registro de precio
    SELECT fechaInicio, tamanotallo INTO last_fechaInicio, last_tamanotallo
    FROM HISTORICO_PRECIO_FLOR
    WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
      AND idCatalogocodigo = p_idCatalogocodigo
    ORDER BY fechaInicio DESC
    LIMIT 1;

    IF last_fechaInicio IS NULL THEN
        RETURN 'No existen registros de precio para esta flor en la floristería especificada.';
    END IF;

    -- Calcular los días transcurridos desde la fecha de inicio
    dias_transcurridos := today - last_fechaInicio;

    IF dias_transcurridos >= 7 THEN
        -- Actualizar la fechaFin del último registro al día actual
        UPDATE HISTORICO_PRECIO_FLOR
        SET fechaFin = today
        WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
          AND idCatalogocodigo = p_idCatalogocodigo
          AND fechaInicio = last_fechaInicio;

        -- Insertar el nuevo registro con el nuevo precio y el mismo tamaño de tallo
        INSERT INTO HISTORICO_PRECIO_FLOR (
            idCatalogoFloristeria,
            idCatalogocodigo,
            fechaInicio,
            fechaFin,
            precio,
            tamanotallo
        ) VALUES (
            p_idCatalogoFloristeria,
            p_idCatalogocodigo,
            today,
            NULL,
            p_nuevo_precio,
            last_tamanotallo
        );

        RETURN 'Precio actualizado exitosamente.';
    ELSE
        RETURN 'No es posible cambiar el precio por las políticas de la floristería que permiten un máximo de 7 días por precio.';
    END IF;
END;
$$ LANGUAGE plpgsql;

----------------------------------------------------------------------
-- Posible superfuncion del requerimiento 1 --
----------------------------------------------------------------------
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

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocurrió un error: %', SQLERRM;
        RETURN 'Ocurrió un error al intentar cambiar el precio de la flor: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;

/* Ejemplos de solicitud
SELECT cambiar_precio_flor_super(
    p_nombreFloristeria := 'FloraPrima',
    p_nuevo_precio := 30.00,
    p_nombreFlor := 'Peonía Rosa',
	p_tamanotallo := 65
);*/ 

-----------------------------------------------------------------------------------
-- FUNCION PARA RETORNAR UNA TABLA QUE ME MUESTRE LAS FLORES ACTIVAS Y EXPIRADAS --
-----------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION obtener_flores_precio_activo()
RETURNS TABLE (
    floristeria_nombre VARCHAR,
    flor_nombre VARCHAR,
    precio_actual NUMERIC,
    dias_para_expirar INTEGER,
    estado VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.nombre AS floristeria_nombre,
        c.nombrePropio AS flor_nombre,
        h.precio AS precio_actual,
        7 - (CURRENT_DATE - h.fechaInicio) AS dias_para_expirar,
        CASE 
            WHEN 7 - (CURRENT_DATE - h.fechaInicio) > 0 THEN 
                CONCAT('Activo: ', 7 - (CURRENT_DATE - h.fechaInicio), ' días restantes')::VARCHAR
            ELSE 
                'Necesita actualización'::VARCHAR
        END AS estado
    FROM HISTORICO_PRECIO_FLOR h
    JOIN CATALOGO_FLORISTERIA c 
        ON h.idCatalogoFloristeria = c.idFloristeria
        AND h.idCatalogocodigo = c.codigo
    JOIN FLORISTERIAS f 
        ON c.idFloristeria = f.floristeriaId
    WHERE h.fechaFin IS NULL;
END;
$$ LANGUAGE plpgsql;


/* FIN DEL REQUERIMIENTO 1 */

/* FUNCION DEL REQUERIMIENTO 1 PARA CUANDO LA FLORISTERIA TENGA SU USER */

CREATE OR REPLACE FUNCTION cambiar_precio_flor_floristeria(
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
    v_idCatalogoCodigo NUMERIC;

    last_fechaInicio TIMESTAMP;
    last_tamanoTallo NUMERIC;
    today TIMESTAMP := CURRENT_TIMESTAMP;

    dias_transcurridos INTEGER;
BEGIN
    -- Validar que se proporcione al menos un método de identificación
    IF p_idCatalogocodigo IS NULL AND p_nombreFlor IS NULL AND p_idCorteFlor IS NULL THEN
        RETURN 'Debe proporcionar al menos uno de los siguientes parámetros para identificar la flor: p_idCatalogocodigo, p_nombreFlor, o p_idCorteFlor.';
    END IF;


    IF p_tamanoTallo IS NULL THEN
        RETURN 'Debe especificar un tamaño de tallo para identificar la flor.';
    END IF;


    -- Obtener el idFloristeria a partir del usuario actual
    SELECT floristeriaId
      INTO v_idFloristeria
      FROM FLORISTERIAS
     WHERE nombre ILIKE CURRENT_USER
     LIMIT 1;

    IF NOT FOUND THEN
        RETURN 'No se encontró la floristería asociada al usuario actual.';
    END IF;

    -- Obtener un idCatalogoFloristeria de referencia (aunque sea para validaciones)
    SELECT codigo
      INTO v_idCatalogoFloristeria
      FROM CATALOGO_FLORISTERIA
     WHERE idFloristeria = v_idFloristeria
     LIMIT 1;

    IF NOT FOUND THEN
        RETURN 'No se encontró catálogo asignado a la floristería del usuario actual.';
    END IF;

    -- Determinar v_idCatalogoCodigo según el método de identificación
    IF p_idCatalogocodigo IS NOT NULL THEN
        v_idCatalogoCodigo := p_idCatalogocodigo;
        RAISE NOTICE 'Método de identificación: idCatalogocodigo=%', v_idCatalogoCodigo;
    ELSIF p_nombreFlor IS NOT NULL THEN
        SELECT codigo
          INTO v_idCatalogoCodigo
          FROM CATALOGO_FLORISTERIA
         WHERE nombrePropio ILIKE p_nombreFlor
           AND idFloristeria = v_idFloristeria
         ORDER BY codigo DESC
         LIMIT 1;
        IF NOT FOUND THEN
            RETURN 'No se encontró la flor con el nombre especificado en la floristería del usuario actual.';
        END IF;
        RAISE NOTICE 'Método de identificación: nombreFlor=% con idCatalogocodigo=%', p_nombreFlor, v_idCatalogoCodigo;
    ELSIF p_idCorteFlor IS NOT NULL THEN
        SELECT codigo
          INTO v_idCatalogoCodigo
          FROM CATALOGO_FLORISTERIA
         WHERE idCorteFlor = p_idCorteFlor
           AND idFloristeria = v_idFloristeria
         LIMIT 1;
        IF NOT FOUND THEN
            RETURN 'No se encontró la flor con el idCorteFlor especificado en la floristería del usuario actual.';
        END IF;
        RAISE NOTICE 'Método de identificación: idCorteFlor=% con idCatalogocodigo=%', p_idCorteFlor, v_idCatalogoCodigo;
    END IF;

    IF v_idCatalogoCodigo IS NULL THEN
        RETURN 'No se pudo determinar el idCatalogocodigo de la flor especificada.';
    END IF;

    -- Obtener la última fechaInicio y tamanoTallo del historial
    SELECT fechaInicio, tamanoTallo
      INTO last_fechaInicio, last_tamanoTallo
      FROM HISTORICO_PRECIO_FLOR
     WHERE idCatalogoFloristeria = v_idCatalogoFloristeria
       AND idCatalogocodigo = v_idCatalogoCodigo
       AND tamanoTallo = p_tamanoTallo

     ORDER BY fechaInicio DESC
     LIMIT 1;

    IF last_fechaInicio IS NULL THEN
        RETURN 'No existen registros de precio para esta flor en la floristería del usuario actual.';
    END IF;

    RAISE NOTICE 'Último registro encontrado: fechaInicio=%, tamanoTallo=%', last_fechaInicio, last_tamanoTallo;

    -- Si tamanoTallo es NULL, buscar el último valor válido
    IF last_tamanoTallo IS NULL THEN
        RAISE NOTICE 'El tamanoTallo del último registro es NULL, buscando el último valor válido.';
        SELECT tamanoTallo
          INTO last_tamanoTallo
          FROM HISTORICO_PRECIO_FLOR
         WHERE idCatalogoFloristeria = v_idCatalogoFloristeria
           AND idCatalogocodigo = v_idCatalogoCodigo
           AND tamanoTallo IS NOT NULL
         ORDER BY fechaInicio DESC
         LIMIT 1;
        IF last_tamanoTallo IS NULL THEN
            RETURN 'No se encontró un valor válido para tamanoTallo en los registros anteriores.';
        END IF;
        RAISE NOTICE 'Último tamanoTallo válido encontrado: tamanoTallo=%', last_tamanoTallo;
    END IF;

    -- Calcular días transcurridos
    dias_transcurridos := today - last_fechaInicio;
    RAISE NOTICE 'Días transcurridos desde la última actualización: %', dias_transcurridos;

    IF dias_transcurridos >= 7 THEN
        UPDATE HISTORICO_PRECIO_FLOR
           SET fechaFin = today
         WHERE idCatalogoFloristeria = v_idCatalogoFloristeria
           AND idCatalogocodigo = v_idCatalogoCodigo
           AND fechaFin IS NULL
           AND fechaInicio = last_fechaInicio;

        RAISE NOTICE 'Actualizado fechaFin del último registro a %', today;

        INSERT INTO HISTORICO_PRECIO_FLOR (
            idCatalogoFloristeria,
            idCatalogocodigo,
            fechaInicio,
            fechaFin,
            precio,
            tamanoTallo
        ) VALUES (
            v_idCatalogoFloristeria,
            v_idCatalogoCodigo,
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

EXCEPTION
    WHEN OTHERS THEN
        RAISE NOTICE 'Ocurrió un error: %', SQLERRM;
        RETURN 'Ocurrió un error al intentar cambiar el precio de la flor: ' || SQLERRM;
END;
$$ LANGUAGE plpgsql;


/*
SELECT cambiar_precio_flor_floristeria(
    p_nuevo_precio := 30.00,
    p_nombreFlor := 'Peonía Rosa',
	p_tamanotallo := 65
);*/


/* COMO HICE LA CONEXION DE UN NUEVO USER QUE SE LLAME COMO UNA FLORISTERIA DE LA TABLA

-- 1. Crear usuario "FloraPrima" con contraseña
CREATE ROLE "FloraPrima" WITH
    LOGIN
    ENCRYPTED PASSWORD 'FloraPrimaPass';

-- 2. Otorgar permisos básicos para que pueda conectarse a la base de datos
GRANT CONNECT ON DATABASE "SubastaHolandesa" TO "FloraPrima";
GRANT USAGE ON SCHEMA public TO "FloraPrima";

-- Opcional: otorgar permisos para manipular tablas en public
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO "FloraPrima";

-- Te valida que user es el que esta conectado
SELECT floristeriaId
FROM FLORISTERIAS
WHERE nombre ILIKE CURRENT_USER;
*/

/* VISTA PARA VER EL HISTORICO DE LA FLORISTERIA CONECTADA */
-- VISTA para historial de flores según la floristería del usuario activo
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

-- FUNCIÓN para flores activas (obtener_flores_precio_activo) filtrada por la floristería del usuario
CREATE OR REPLACE FUNCTION obtener_flores_precio_activo_floristeria()
RETURNS TABLE (
    floristeria_nombre VARCHAR,
    flor_nombre VARCHAR,
    precio_actual NUMERIC,
    dias_para_expirar INTEGER,
    estado VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        f.nombre AS floristeria_nombre,
        c.nombrePropio AS flor_nombre,
        h.precio AS precio_actual,
        7 - (CURRENT_DATE - h.fechaInicio) AS dias_para_expirar,
        CASE 
            WHEN 7 - (CURRENT_DATE - h.fechaInicio) > 0 THEN 
                CONCAT('Activo: ', 7 - (CURRENT_DATE - h.fechaInicio), ' días restantes')::VARCHAR
            ELSE 
                'Necesita actualización'::VARCHAR
        END AS estado
    FROM HISTORICO_PRECIO_FLOR h
    JOIN CATALOGO_FLORISTERIA c 
      ON c.codigo = h.idCatalogocodigo
     AND c.idFloristeria = h.idCatalogoFloristeria
    JOIN FLORISTERIAS f
      ON f.floristeriaId = c.idFloristeria
    WHERE f.nombre ILIKE CURRENT_USER
    ORDER BY f.nombre, c.nombrePropio;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM obtener_flores_precio_activo_floristeria();

-- VALIDAR LO SIGUIENTE

-- 1. Crear tabla de auditoría con todas las columnas necesarias
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

-- 2. Crear función trigger para auditoría con las nuevas columnas y descripción
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

-- 3. Crear la vista de auditoría con los nuevos cambios
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

-- 4. Crear triggers en la tabla HISTORICO_PRECIO_FLOR para usar la función de auditoría actualizada
DROP TRIGGER IF EXISTS trg_auditoria_insert ON HISTORICO_PRECIO_FLOR;
CREATE TRIGGER trg_auditoria_insert
AFTER INSERT ON HISTORICO_PRECIO_FLOR
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_cambios_precios();

DROP TRIGGER IF EXISTS trg_auditoria_update ON HISTORICO_PRECIO_FLOR;
CREATE TRIGGER trg_auditoria_update
AFTER UPDATE ON HISTORICO_PRECIO_FLOR
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_cambios_precios();

DROP TRIGGER IF EXISTS trg_auditoria_delete ON HISTORICO_PRECIO_FLOR;
CREATE TRIGGER trg_auditoria_delete
AFTER DELETE ON HISTORICO_PRECIO_FLOR
FOR EACH ROW
EXECUTE FUNCTION trg_auditoria_cambios_precios();

/* SELECT * FROM AUDITORIA_CAMBIOS_PRECIOS
ORDER BY fecha DESC; */


-- Función para abrir un nuevo período de precios
CREATE OR REPLACE FUNCTION abrir_nuevo_periodo_precio(
    p_nombreFloristeria TEXT,
    p_idCatalogocodigo NUMERIC,
    p_nuevo_precio NUMERIC,
    p_tamanoTallo NUMERIC,
    p_fechaInicio TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
RETURNS TEXT AS $$
DECLARE
    v_idFloristeria NUMERIC;
BEGIN
    -- Obtener el ID de la floristería
    SELECT floristeriaId INTO v_idFloristeria
    FROM FLORISTERIAS
    WHERE nombre ILIKE p_nombreFloristeria
    LIMIT 1;

    IF v_idFloristeria IS NULL THEN
        RETURN 'No se encontró una floristería con el nombre especificado.';
    END IF;

    -- Validar que el registro exista en Catalogo_floristeria
    IF NOT EXISTS (
        SELECT 1 FROM CATALOGO_FLORISTERIA
        WHERE idFloristeria = v_idFloristeria
          AND codigo = p_idCatalogocodigo
    ) THEN
        RETURN 'El registro no existe en Catalogo_floristeria.';
    END IF;

    -- Insertar el nuevo registro en el histórico de precios
    INSERT INTO HISTORICO_PRECIO_FLOR (
        idCatalogoFloristeria,
        idCatalogocodigo,
        fechaInicio,
        fechaFin,
        precio,
        tamanoTallo
    ) VALUES (
        v_idFloristeria,
        p_idCatalogocodigo,
        p_fechaInicio,
        NULL,
        p_nuevo_precio,
        p_tamanoTallo
    );

    RETURN 'Nuevo período de precio abierto exitosamente.';
END;
$$ LANGUAGE plpgsql;

/*
SELECT abrir_nuevo_periodo_precio(
    p_nombreFloristeria => 'FloraPrima',
    p_idCatalogocodigo  => 1,
    p_nuevo_precio      => 25.00,
    p_tamanoTallo       => 50,
    p_fechaInicio       => '2025-01-01 09:00:00'
);*/

