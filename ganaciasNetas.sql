CREATE OR REPLACE FUNCTION ganancias_del_mes(
  p_idFloristeria NUMERIC,
  p_mes DATE
)
RETURNS NUMERIC AS $$
DECLARE
  fecha_inicio DATE := DATE_TRUNC('month', p_mes);
  fecha_fin DATE := (DATE_TRUNC('month', p_mes) + INTERVAL '1 month') - INTERVAL '1 day';
  ganancias_brutas NUMERIC;
  costos NUMERIC;
BEGIN
  SELECT COALESCE(SUM(montoTotal), 0)
    INTO ganancias_brutas
    FROM FACTURA_FINAL
    WHERE idFloristeria = p_idFloristeria
      AND fechaEmision >= fecha_inicio
      AND fechaEmision <= fecha_fin;

  SELECT COALESCE(SUM(montoTotal), 0)
    INTO costos
    FROM FACTURA
    WHERE idAfiliacionFloristeria = p_idFloristeria
      AND fechaEmision >= fecha_inicio
      AND fechaEmision <= fecha_fin;

  RETURN ganancias_brutas - costos;
END;
$$ LANGUAGE plpgsql;