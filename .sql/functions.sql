-- Función para actualizar únicamente la página web de la productora
CREATE OR REPLACE FUNCTION actualizar_paginaweb_productora(
  p_productoraId NUMERIC,
  p_paginaWeb TEXT
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si la productora existe y si el usuario actual tiene permiso para actualizar
  IF NOT EXISTS (
    SELECT 1 FROM PRODUCTORAS 
    WHERE productoraId = p_productoraId 
      AND CAST(substring(current_user FROM length(current_user) FOR 1) AS INTEGER) = p_productoraId
  ) THEN
    RETURN 'No tiene permiso para actualizar esta productora o la productora no existe.';
  END IF;

  -- Actualizar la página web de la productora
  UPDATE PRODUCTORAS
  SET paginaWeb = p_paginaWeb
  WHERE productoraId = p_productoraId;

  RETURN 'Página web de la productora actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;
-- Crear una vista para ejecutar la función actualizar_paginaweb_productora
CREATE VIEW vista_actualizar_paginaweb_productora AS
SELECT 
    p_productoraId,
    p_paginaWeb,
    actualizar_paginaweb_productora(p_productoraId, p_paginaWeb) AS resultado
FROM 
    (VALUES 
        (1, 'nuevaweb1.com'),
        (2, 'nuevaweb2.com'),
        (3, 'nuevaweb3.com')
    ) AS datos(p_productoraId, p_paginaWeb);