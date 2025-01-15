-- Privilegios para el usuario "Floristeria"
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.contactos TO "Floristeria";
GRANT SELECT ON TABLE public.vista_afiliacion TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_afiliacion TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalle_bouquet TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_factura TO "Floristeria";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.vista_detalles_historico_precio_flor_floristeria TO "Floristeria";
GRANT INSERT, SELECT, UPDATE ON TABLE public.factura_final TO "Floristeria";
GRANT INSERT, SELECT, UPDATE ON TABLE public.historico_precio_flor TO "Floristeria";
GRANT INSERT, SELECT, UPDATE ON TABLE public.catalogo_floristeria TO "Floristeria";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.detalle_bouquet TO "Floristeria";
GRANT INSERT, SELECT, UPDATE ON TABLE public.detalle_factura TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_catalogo_floristeria TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_cliente_juridico TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_cliente_natural TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_contactos TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_floristerias TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_historico_precio_flor TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_historico_precio_flor_floristeria TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_lote TO "Floristeria";
GRANT SELECT ON TABLE public.vista_detalles_subastadora TO "Floristeria";
GRANT INSERT, SELECT ON TABLE public.telefonos TO "Floristeria";

-- Privilegios para el usuario "Productora"
GRANT SELECT ON TABLE public.contactos TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_factura TO "Productora";
GRANT SELECT ON TABLE public.contrato TO "Productora";
GRANT SELECT ON TABLE public.pagos TO "Productora";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.catalogoproductor TO "Productora";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.cantidad_ofrecida TO "Productora";
GRANT SELECT ON TABLE public.lote TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_cantidad_ofrecida TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_catalogoproductor TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_cliente_juridico TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_cliente_natural TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_contrato TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_lote TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_pagos TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_productoras TO "Productora";
GRANT SELECT ON TABLE public.vista_detalles_subastadora TO "Productora";
GRANT INSERT, SELECT ON TABLE public.telefonos TO "Productora";

-- Privilegios para el usuario "Subastadora"
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.vista_afiliacion TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_afiliacion TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_factura TO "Subastadora";
GRANT INSERT, UPDATE, SELECT ON TABLE public.contrato TO "Subastadora";
GRANT INSERT, SELECT, UPDATE ON TABLE public.pagos TO "Subastadora";
GRANT SELECT, DELETE ON TABLE public.cantidad_ofrecida TO "Subastadora";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.lote TO "Subastadora";
GRANT INSERT, SELECT, UPDATE, DELETE ON TABLE public.factura TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_cantidad_ofrecida TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_catalogoproductor TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_contrato TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_lote TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_pagos TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_productoras TO "Subastadora";
GRANT SELECT ON TABLE public.vista_detalles_subastadora TO "Subastadora";
GRANT INSERT, SELECT ON TABLE public.telefonos TO "Subastadora";

-- Privilegios para el usuario "Cliente"
GRANT SELECT ON TABLE public.vista_detalle_bouquet TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_factura TO cliente;
GRANT SELECT ON TABLE public.cliente_juridico TO cliente;
GRANT SELECT ON TABLE public.cliente_natural TO cliente;
GRANT SELECT ON TABLE public.factura_final TO cliente;
GRANT SELECT ON TABLE public.detalle_bouquet TO cliente;
GRANT SELECT, UPDATE ON TABLE public.detalle_factura TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_catalogo_floristeria TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_cliente_juridico TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_cliente_natural TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_detalle_bouquet TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_detalle_factura TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_factura_final TO cliente;
GRANT SELECT ON TABLE public.vista_detalles_floristerias TO cliente;

-- Privilegios para el usuario "Public"
GRANT SELECT ON TABLE public.catalogo_floristeria TO PUBLIC;
GRANT SELECT ON TABLE public.catalogoproductor TO PUBLIC;
GRANT INSERT, SELECT, UPDATE, DELETE, REFERENCES, TRIGGER ON TABLE public.pais TO "Desarrollador";
GRANT SELECT ON TABLE public.pais TO PUBLIC;
GRANT SELECT ON TABLE public.telefonos TO PUBLIC;
GRANT INSERT, SELECT, UPDATE, DELETE, REFERENCES, TRIGGER ON TABLE public.significado TO PUBLIC;
GRANT INSERT, SELECT, UPDATE, DELETE, REFERENCES, TRIGGER ON TABLE public.enlaces TO PUBLIC;
GRANT INSERT, SELECT, UPDATE, DELETE, REFERENCES, TRIGGER ON TABLE public.color TO PUBLIC;
GRANT SELECT ON TABLE public.vista_detalles_color TO PUBLIC;
GRANT SELECT ON TABLE public.vista_detalles_enlaces TO PUBLIC;
GRANT SELECT ON TABLE public.vista_detalles_significado TO PUBLIC;
GRANT SELECT ON TABLE public.vista_detalles_flor_cortes TO PUBLIC;
GRANT SELECT ON TABLE public.vista_detalles_telefonos TO PUBLIC;

-- Row Level Security (RLS)
-- Habilitar Row Level Security en la tabla PRODUCTORAS
ALTER TABLE PRODUCTORAS ENABLE ROW LEVEL SECURITY;

-- Crear una función para extraer el ID de la productora del nombre de usuario
CREATE OR REPLACE FUNCTION get_productora_id_from_user() RETURNS NUMERIC AS $$
DECLARE
    productora_id NUMERIC;
BEGIN
    -- Suponiendo que el nombre de usuario tiene el formato 'NombreProductoraID'
    productora_id := CAST(REGEXP_REPLACE(current_user, '^[^0-9]*', '') AS NUMERIC);
    RETURN productora_id;
END;
$$ LANGUAGE plpgsql;

-- Crear la política de seguridad para permitir acceso solo a los registros de la propia productora
CREATE POLICY productora_policy ON PRODUCTORAS
USING (productoraId = get_productora_id_from_user())
WITH CHECK (productoraId = get_productora_id_from_user());

-- Aplicar la política de seguridad a la tabla PRODUCTORAS
ALTER TABLE PRODUCTORAS ENABLE ROW LEVEL SECURITY;
ALTER TABLE PRODUCTORAS FORCE ROW LEVEL SECURITY;

-- Conectar como usuario 'Anthura1'
-- Suponiendo que el usuario 'Anthura1' tiene el ID de productora 1

-- Intentar actualizar la página web de la productora con ID 2 (debería fallar)
UPDATE PRODUCTORAS
SET paginaWeb = 'http://nueva-pagina-web.com'
WHERE productoraId = 2;

-- Actualizar la página web de la productora con ID 1 (debería tener éxito)
UPDATE PRODUCTORAS
SET paginaWeb = 'http://nueva-pagina-web.com'
WHERE productoraId = 1;