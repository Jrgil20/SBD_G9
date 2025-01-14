CREATE OR REPLACE FUNCTION ganancias_floristeria(
  p_idFloristeria NUMERIC,
  p_mes DATE
)
RETURNS TABLE(
  ganancias_brutas NUMERIC,
  costos NUMERIC,
  ganancias_netas NUMERIC
)
AS $$
DECLARE
  fecha_inicio DATE := DATE_TRUNC('month', p_mes);
  fecha_fin DATE := (DATE_TRUNC('month', p_mes) + INTERVAL '1 month') - INTERVAL '1 day';
  _ganancias_brutas NUMERIC;
  _costos NUMERIC;
BEGIN

  IF fecha_fin > CURRENT_DATE THEN
    fecha_fin := CURRENT_DATE;
    RAISE EXCEPTION 'se calcula las ganancias netas hasta el dia de hoy';
  END IF;

  IF fecha_inicio > CURRENT_DATE THEN
    RAISE NOTICE 'No se puede calcular aun';
  END IF;

  SELECT COALESCE(SUM(montoTotal), 0)
    INTO _ganancias_brutas
    FROM FACTURA_FINAL
    WHERE idFloristeria = p_idFloristeria
      AND fechaEmision >= fecha_inicio
      AND fechaEmision <= fecha_fin;

  SELECT COALESCE(SUM(montoTotal), 0)
    INTO _costos
    FROM FACTURA
    WHERE idAfiliacionFloristeria = p_idFloristeria
      AND fechaEmision >= fecha_inicio
      AND fechaEmision <= fecha_fin;

  RETURN QUERY SELECT _ganancias_brutas, _costos, _ganancias_brutas - _costos;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM ganancias_floristeria(2, '2023-01-01');

CREATE OR REPLACE FUNCTION fn_ganancias_por_anio(
  p_idFloristeria NUMERIC,
  p_anio INT
)
RETURNS TABLE(
  ganancias_brutas NUMERIC,
  costos NUMERIC,
  ganancias_netas NUMERIC,
  mesdelanio VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
  mes INT;
  anioActual INT := EXTRACT(YEAR FROM CURRENT_DATE);
  mesActual INT := EXTRACT(MONTH FROM CURRENT_DATE);
  r RECORD;
  meses TEXT[] := ARRAY['ene','feb','marzo','abr','may','jun','jul','ago','sep','oct','nov','dic'];
BEGIN
  IF p_anio < anioActual THEN
    mesActual := 12;
  ELSIF p_anio > anioActual THEN
    RAISE NOTICE 'El año es mayor al actual, no se calcula.';
    RETURN;
  END IF;

  FOR mes IN 1..mesActual LOOP
    SELECT * INTO r
    FROM ganancias_floristeria(
      p_idFloristeria,
      TO_DATE(p_anio::text || '-' || mes::text || '-01','YYYY-MM-DD')
    );

    ganancias_brutas := r.ganancias_brutas;
    costos := r.costos;
    ganancias_netas := r.ganancias_netas;
    mesdelanio := meses[mes];

    RETURN NEXT;
  END LOOP;
END;
$$;

SELECT * FROM fn_ganancias_por_anio(2,2023);

CREATE OR REPLACE FUNCTION fn_ganancias_usuario_actual(
  p_anio INT
)
RETURNS TABLE(
  ganancias_brutas NUMERIC,
  costos NUMERIC,
  ganancias_netas NUMERIC,
  mesdelanio VARCHAR
)
LANGUAGE plpgsql
AS $$
DECLARE
  es_floristeria BOOLEAN;
BEGIN
  -- Verificar si el usuario actual es una floristeria
  SELECT EXISTS (
    SELECT 1
    FROM pg_roles r
    JOIN pg_auth_members m ON r.oid = m.roleid
    JOIN pg_roles u ON u.oid = m.member
    WHERE u.rolname = current_user
      AND r.rolname LIKE 'floristeria%'
  ) INTO es_floristeria;

  IF NOT es_floristeria THEN
    RAISE EXCEPTION 'El usuario actual no es una floristeria.';
  END IF;

  -- Ejecutar la función fn_ganancias_por_anio
  RETURN QUERY
  SELECT * FROM fn_ganancias_por_anio(
    CAST(substring(current_user FROM length(current_user) FOR 1) AS INTEGER),
    p_anio
  );
END;
$$;

SELECT * FROM fn_ganancias_usuario_actual(2023);

CREATE OR REPLACE FUNCTION fn_ganancias_usuario_actual_mes(
  p_mes DATE
)
RETURNS TABLE(
  ganancias_brutas NUMERIC,
  costos NUMERIC,
  ganancias_netas NUMERIC
)
LANGUAGE plpgsql
AS $$
DECLARE
  es_floristeria BOOLEAN;
BEGIN
  -- Verificar si el usuario actual es una floristeria
  SELECT EXISTS (
    SELECT 1
    FROM pg_roles r
    JOIN pg_auth_members m ON r.oid = m.roleid
    JOIN pg_roles u ON u.oid = m.member
    WHERE u.rolname = current_user
      AND r.rolname LIKE 'floristeria%'
  ) INTO es_floristeria;

  IF NOT es_floristeria THEN
    RAISE EXCEPTION 'El usuario actual no es una floristeria.';
  END IF;

  -- Ejecutar la función ganancias_floristeria
  RETURN QUERY
  SELECT * FROM ganancias_floristeria(
    CAST(substring(current_user FROM length(current_user) FOR 1) AS INTEGER),
    p_mes
  );
END;
$$;

SELECT * FROM fn_ganancias_usuario_actual_mes('2023-01-01');