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