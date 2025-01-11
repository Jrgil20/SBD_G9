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
    p_idCorteFlor NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
DECLARE
    v_idFloristeria NUMERIC;
    v_idCatalogoFloristeria NUMERIC;
    v_idCatalogocodigo NUMERIC;
    last_fechaInicio DATE;
    last_tamanoTallo NUMERIC;
    today DATE := CURRENT_DATE;
    dias_transcurridos INTEGER;
BEGIN
    -- Validar que se proporcione al menos uno de los métodos de identificación adicionales
    IF p_idCatalogocodigo IS NULL AND p_nombreFlor IS NULL AND p_idCorteFlor IS NULL THEN
        RETURN 'Debe proporcionar al menos uno de los siguientes parámetros para identificar la flor: p_idCatalogocodigo, p_nombreFlor, o p_idCorteFlor.';
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
    dias_transcurridos := today - last_fechaInicio;

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
            last_tamanoTallo
        );

        RAISE NOTICE 'Insertado nuevo registro con precio=% y tamanoTallo=%', p_nuevo_precio, last_tamanoTallo;

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
    p_nombreFloristeria := 'Floristería Central',
    p_nuevo_precio := 20.00,
    p_idCatalogocodigo := 1
);

SELECT cambiar_precio_flor_super(
    p_nombreFloristeria := 'Floristería Central',
    p_nuevo_precio := 25.00,
    p_nombreFlor := 'Rosa Roja'
);

SELECT cambiar_precio_flor_super(
    p_nombreFloristeria := 'Floristería Central',
    p_nuevo_precio := 30.00,
    p_idCorteFlor := 5
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