CREATE SEQUENCE numFactura_seq
  START WITH 100
  INCREMENT BY 1;



WITH FloresIndividuales AS (
  SELECT 
      cf.nombrePropio AS NombreFlor,
      hp.precio AS Precio,
      df.cantidad AS Cantidad,
      CASE WHEN df.valoracionPrecio IS NULL THEN NULL ELSE df.valoracionPrecio END AS ValoracionPrecio,
      CASE WHEN df.valorancionCalidad IS NULL THEN NULL ELSE df.valorancionCalidad END AS ValoracionCalidad,
      CASE WHEN df.valoracionPromedio IS NULL THEN NULL ELSE df.valoracionPromedio END AS ValoracionPromedio,
      'Flor Individual' AS Tipo
  FROM 
      DETALLE_FACTURA df
  JOIN 
      FACTURA_FINAL ff ON df.idFActuraFloristeria = ff.idFloristeria AND df.idNumFactura = ff.numFactura
  JOIN 
      CATALOGO_FLORISTERIA cf ON df.catalogoFloristeria = cf.idFloristeria AND df.catalogoCodigo = cf.codigo
  JOIN 
      HISTORICO_PRECIO_FLOR hp ON df.catalogoFloristeria = hp.idCatalogoFloristeria AND df.catalogoCodigo = hp.idCatalogocodigo
  WHERE 
      ff.numFactura = 21 
      AND ff.fechaEmision BETWEEN hp.fechaInicio AND COALESCE(hp.fechaFin, ff.fechaEmision)
      AND df.bouquetId IS NULL
),
Bouquets AS (
  SELECT 
      CONCAT('Bouquet: ', cf.nombrePropio) AS NombreFlor, 
      SUM(hp.precio * db.cantidad) AS Precio,
      SUM(db.cantidad) AS Cantidad,
      CASE WHEN AVG(df.valoracionPrecio) IS NULL THEN NULL ELSE AVG(df.valoracionPrecio) END AS ValoracionPrecio,
      CASE WHEN AVG(df.valorancionCalidad) IS NULL THEN NULL ELSE AVG(df.valorancionCalidad) END AS ValoracionCalidad,
      CASE WHEN AVG(df.valoracionPromedio) IS NULL THEN NULL ELSE AVG(df.valoracionPromedio) END AS ValoracionPromedio,
      'Bouquet' AS Tipo
  FROM 
      DETALLE_FACTURA df
  JOIN 
      FACTURA_FINAL ff ON df.idFActuraFloristeria = ff.idFloristeria AND df.idNumFactura = ff.numFactura
  JOIN 
      DETALLE_BOUQUET db ON df.bouquetFloristeria = db.idCatalogoFloristeria AND df.bouquetcodigo = db.idCatalogocodigo AND df.bouquetId = db.bouquetId
  JOIN 
      HISTORICO_PRECIO_FLOR hp ON db.idCatalogoFloristeria = hp.idCatalogoFloristeria AND db.idCatalogocodigo = hp.idCatalogocodigo
  JOIN 
      CATALOGO_FLORISTERIA cf ON db.idCatalogoFloristeria = cf.idFloristeria AND db.idCatalogocodigo = cf.codigo 
  WHERE 
      ff.numFactura = 21 
      AND ff.fechaEmision BETWEEN hp.fechaInicio AND COALESCE(hp.fechaFin, ff.fechaEmision)
      AND df.bouquetId IS NOT NULL
  GROUP BY cf.nombrePropio, ff.numFactura
)
SELECT 
    NombreFlor, Precio, Cantidad, 
    CASE WHEN ValoracionPrecio IS NULL THEN 'No calificado' ELSE ValoracionPrecio::text END AS ValoracionPrecio, 
    CASE WHEN ValoracionCalidad IS NULL THEN 'No calificado' ELSE ValoracionCalidad::text END AS ValoracionCalidad,
    CASE WHEN ValoracionPromedio IS NULL THEN 'No calificado' ELSE ValoracionPromedio::text END AS ValoracionPromedio,
    Tipo
FROM FloresIndividuales
UNION ALL
SELECT 
    NombreFlor, Precio, Cantidad, 
    CASE WHEN ValoracionPrecio IS NULL THEN 'No calificado' ELSE ValoracionPrecio::text END AS ValoracionPrecio, 
    CASE WHEN ValoracionCalidad IS NULL THEN 'No calificado' ELSE ValoracionCalidad::text END AS ValoracionCalidad,
    CASE WHEN ValoracionPromedio IS NULL THEN 'No calificado' ELSE ValoracionPromedio::text END AS ValoracionPromedio,
    Tipo
FROM Bouquets;


CREATE OR REPLACE FUNCTION registrar_valoracion(
    p_idFActuraFloristeria NUMERIC,
    p_idNumFactura NUMERIC,
    p_detalleId NUMERIC,
    p_valoracionPrecio NUMERIC,
    p_valorancionCalidad NUMERIC
)
RETURNS void AS $$
BEGIN
    -- Verificar si el detalle de la factura existe
    IF NOT EXISTS (
        SELECT 1
        FROM DETALLE_FACTURA
        WHERE idFActuraFloristeria = p_idFActuraFloristeria
          AND idNumFactura = p_idNumFactura
          AND detalleId = p_detalleId
    ) THEN
        RAISE EXCEPTION 'El detalle de la factura no existe.';
    END IF;

    -- Verificar si el detalle ya ha sido calificado
    IF EXISTS (
        SELECT 1
        FROM DETALLE_FACTURA
        WHERE idFActuraFloristeria = p_idFActuraFloristeria
          AND idNumFactura = p_idNumFactura
          AND detalleId = p_detalleId
          AND (valoracionPrecio IS NOT NULL OR valorancionCalidad IS NOT NULL OR valoracionPromedio IS NOT NULL)
    ) THEN
        RAISE EXCEPTION 'El detalle ya ha sido calificado.';
    END IF;

    -- Verificar que las valoraciones estén entre 1 y 5
    IF p_valoracionPrecio < 1 OR p_valoracionPrecio > 5 THEN
        RAISE EXCEPTION 'La valoración de precio debe estar entre 1 y 5.';
    END IF;
    IF p_valorancionCalidad < 1 OR p_valorancionCalidad > 5 THEN
        RAISE EXCEPTION 'La valoración de calidad debe estar entre 1 y 5.';
    END IF;

    -- Actualizar las valoraciones
    UPDATE DETALLE_FACTURA
    SET
        valoracionPrecio = ROUND(p_valoracionPrecio, 2),
        valorancionCalidad = ROUND(p_valorancionCalidad, 2),
        valoracionPromedio = ROUND((p_valoracionPrecio + p_valorancionCalidad) / 2, 2)
    WHERE
        idFActuraFloristeria = p_idFActuraFloristeria
        AND idNumFactura = p_idNumFactura
        AND detalleId = p_detalleId;
END;
$$ LANGUAGE plpgsql;


Do
$$
BEGIN
    -- Llamar a la función usando PERFORM
     Perform registrar_valoracion(1, 21, 3, 4.8, 5);
END $$;



-- FUNCTION: public.generar_factura(numeric, numeric, numeric, jsonb[], jsonb[])

-- DROP FUNCTION IF EXISTS public.generar_factura(numeric, numeric, numeric, jsonb[], jsonb[]);

CREATE OR REPLACE FUNCTION public.generar_factura(
	p_idfloristeria numeric,
	p_idcliente numeric,
	p_idclientejuridico numeric,
	p_flores jsonb[],
	p_bouquets jsonb[])
    RETURNS void
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE
    v_numFactura NUMERIC;
    v_monto_total NUMERIC := 0;
    v_precio_flor NUMERIC;
    v_cantidad_flores_bouquet NUMERIC;
    v_precio_bouquet NUMERIC;
    v_flor JSONB;
    v_bouquet JSONB;
    v_detalle_id INTEGER := 1;
    v_cantidad_en_detalle NUMERIC;
	v_codigo_flor NUMERIC; 
    v_idFloristeria_flor NUMERIC;
BEGIN
    -- Insertar la factura con monto total inicializado en cero
    INSERT INTO FACTURA_FINAL (
        idFloristeria, 
        numFactura, 
        fechaEmision, 
        montoTotal,         
        idClienteNatural, 
        idClienteJuridico
    )
    VALUES (
        p_idFloristeria, 
        nextval('numFactura_seq'), 
        NOW(), 
        v_monto_total, 
        p_idCliente, 
        p_idClienteJuridico
    )
	RETURNING numFactura INTO v_numFactura;

    -- Insertar detalles de flores y calcular el valor total
    FOREACH v_flor IN ARRAY p_flores LOOP
        -- Consultar el precio histórico de la flor
            SELECT precio INTO v_precio_flor
            FROM historico_precio_flor
            WHERE idcatalogofloristeria = (v_flor->>'idFloristeria')::NUMERIC
            AND idcatalogocodigo = (v_flor->>'codigo')::NUMERIC
            AND fechaInicio <= now()
            AND fechaFin IS NULL;
			  IF NOT FOUND THEN
	            RAISE NOTICE 'No se encontró precio histórico para la flor. Saltando al siguiente elemento.';
	            CONTINUE;
        	  END IF;

        -- Calcular el precio total de las flores y actualizar el monto total
        v_monto_total := v_monto_total + v_precio_flor * (v_flor->>'cantidad')::NUMERIC;
		 RAISE NOTICE 'Antes de insertar en DETALLE_FACTURA (flor):';
        RAISE NOTICE '  v_numFactura: %', v_numFactura;
        RAISE NOTICE '  v_detalle_id: %', v_detalle_id;
        RAISE NOTICE '  idFloristeria: %', (v_flor->>'idFloristeria')::NUMERIC;
        RAISE NOTICE '  codigo: %', (v_flor->>'codigo')::NUMERIC;
        RAISE NOTICE '  cantidad: %', (v_flor->>'cantidad')::NUMERIC;
        RAISE NOTICE '  v_precio_flor: %', v_precio_flor;
		RAISE NOTICE 'Monto total después de agregar la flor: %', v_monto_total;

        INSERT INTO DETALLE_FACTURA (
            idFActuraFloristeria, idNumFactura, detalleId, catalogoFloristeria, catalogoCodigo, cantidad
        )
        VALUES (
            p_idFloristeria, 
            v_numFactura, 
            v_detalle_id, 
            (v_flor->>'idFloristeria')::NUMERIC, 
            (v_flor->>'codigo')::NUMERIC, 
            (v_flor->>'cantidad')::NUMERIC
        );
        v_detalle_id := v_detalle_id + 1;
    END LOOP;

    -- Insertar detalles de bouquets y calcular el valor total
        FOREACH v_bouquet IN ARRAY p_bouquets LOOP
        -- Obtener información de la flor del bouquet
        SELECT c.codigo, c.idFloristeria, db.cantidad AS cantidad_en_detalle
        INTO v_codigo_flor, v_idFloristeria_flor, v_cantidad_en_detalle
        FROM CATALOGO_FLORISTERIA c
        JOIN DETALLE_BOUQUET db ON c.idFloristeria = db.idCatalogoFloristeria AND c.codigo = db.idCatalogocodigo
        WHERE db.bouquetId = (v_bouquet->>'bouquetId')::NUMERIC;
	 	
        -- Consultar el precio histórico de la flor
        SELECT precio INTO v_precio_flor
        FROM historico_precio_flor
        WHERE idcatalogofloristeria = v_idFloristeria_flor
          AND idcatalogocodigo = v_codigo_flor
          AND fechaInicio <= NOW()
          AND fechaFin IS NULL;
		 IF NOT FOUND THEN
            RAISE NOTICE 'No se encontró precio histórico para el bouquet. Saltando al siguiente elemento.';
            CONTINUE;
        END IF;
		
        -- Calcular el precio total del bouquet
        v_precio_bouquet := v_precio_flor * (v_bouquet->>'cantidad')::NUMERIC * v_cantidad_en_detalle;
		RAISE NOTICE 'Antes de insertar en DETALLE_FACTURA:';
    RAISE NOTICE '  v_numFactura: %', v_numFactura;
    RAISE NOTICE '  v_detalle_id: %', v_detalle_id;
    RAISE NOTICE '  bouquetFloristeria: %', (v_bouquet->>'bouquetFloristeria')::NUMERIC;
    RAISE NOTICE '  bouquetcodigo: %', (v_bouquet->>'bouquetcodigo')::NUMERIC;
    RAISE NOTICE '  bouquetId: %', (v_bouquet->>'bouquetId')::NUMERIC;
    RAISE NOTICE '  cantidad: %', (v_bouquet->>'cantidad')::NUMERIC;
    RAISE NOTICE '  v_precio_flor: %', v_precio_flor;
    RAISE NOTICE '  v_cantidad_en_detalle: %', v_cantidad_en_detalle;
    RAISE NOTICE '  v_precio_bouquet: %', v_precio_bouquet;
        INSERT INTO DETALLE_FACTURA (
        idFActuraFloristeria, idNumFactura, detalleId, bouquetFloristeria, bouquetcodigo, bouquetId, cantidad
    )
    VALUES (
        p_idFloristeria, 
        v_numFactura, 
        v_detalle_id, 
        (v_bouquet->>'bouquetFloristeria')::NUMERIC, 
        (v_bouquet->>'bouquetcodigo')::NUMERIC, 
        (v_bouquet->>'bouquetId')::NUMERIC, 
        (v_bouquet->>'cantidad')::NUMERIC
    );
    v_detalle_id := v_detalle_id + 1;
	v_monto_total := v_monto_total+v_precio_bouquet;
	RAISE NOTICE 'Monto total después de agregar la flor: %', v_monto_total;
	END LOOP;

    -- Actualizar el monto total en la tabla FACTURA_FINAL
    UPDATE FACTURA_FINAL
    SET montoTotal = v_monto_total
    WHERE numFactura = v_numFactura;
END;
$BODY$;

ALTER FUNCTION public.generar_factura(numeric, numeric, numeric, jsonb[], jsonb[])
    OWNER TO postgres;
