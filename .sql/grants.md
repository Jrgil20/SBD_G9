# Otorgar permisos de vista

Para otorgar permisos de vista a todos los usuarios en las vistas principales, puedes utilizar los siguientes comandos SQL:

```sql
GRANT SELECT ON vista_pais TO PUBLIC;
GRANT SELECT ON vista_subastadora TO PUBLIC;
GRANT SELECT ON vista_productoras TO PUBLIC;
GRANT SELECT ON vista_floristerias TO PUBLIC;
GRANT SELECT ON vista_cliente_natural TO PUBLIC;
GRANT SELECT ON vista_cliente_juridico TO PUBLIC;
GRANT SELECT ON vista_flor_cortes TO PUBLIC;
GRANT SELECT ON vista_significado TO PUBLIC;
GRANT SELECT ON vista_color TO PUBLIC;
GRANT SELECT ON vista_enlaces TO PUBLIC;
GRANT SELECT ON vista_catalogoproductor TO PUBLIC;
GRANT SELECT ON vista_contrato TO PUBLIC;
GRANT SELECT ON vista_cantidad_ofrecida TO PUBLIC;
GRANT SELECT ON vista_pagos TO PUBLIC;
GRANT SELECT ON vista_contactos TO PUBLIC;
GRANT SELECT ON vista_afiliacion TO PUBLIC;
GRANT SELECT ON vista_factura TO PUBLIC;
GRANT SELECT ON vista_lote TO PUBLIC;
GRANT SELECT ON vista_catalogo_floristeria TO PUBLIC;
GRANT SELECT ON vista_historico_precio_flor TO PUBLIC;
GRANT SELECT ON vista_detalle_bouquet TO PUBLIC;
GRANT SELECT ON vista_factura_final TO PUBLIC;
GRANT SELECT ON vista_detalle_factura TO PUBLIC;
GRANT SELECT ON vista_telefonos TO PUBLIC;
```

Para otorgar permisos de vista a la cuenta `cuenta1` en las vistas de detalles, puedes utilizar los siguientes comandos SQL:

```sql
GRANT SELECT ON vista_detalles_subastadora TO Subastadora;
GRANT SELECT ON vista_detalles_productoras TO productora;
GRANT SELECT ON vista_detalles_floristerias TO floristeria;
GRANT SELECT ON vista_detalles_cliente_natural TO floristeria;
GRANT SELECT ON vista_detalles_cliente_juridico TO floristeria;
GRANT SELECT ON vista_detalles_flor_cortes TO PUBLIC;
GRANT SELECT ON vista_detalles_significado TO floristeria;
GRANT SELECT ON vista_detalles_color TO floristeria;
GRANT SELECT ON vista_detalles_enlaces TO floristeria;
GRANT SELECT ON vista_detalles_catalogoproductor TO Subastadora, productora;
GRANT SELECT ON vista_detalles_contrato TO Subastadora, productora;
GRANT SELECT ON vista_detalles_cantidad_ofrecida TO ubastadora, productora;
GRANT SELECT ON vista_detalles_pagos TO subastadora, productora;
GRANT SELECT ON vista_detalles_contactos TO subastadora, floristeria;
GRANT SELECT ON vista_detalles_afiliacion TO ubastadora, floristeria;
GRANT SELECT ON vista_detalles_factura TO floristeria;
GRANT SELECT ON vista_detalles_lote TO subastadora, productora;
GRANT SELECT ON vista_detalles_catalogo_floristeria TO floristeria
GRANT SELECT ON vista_detalles_historico_precio_flor TO floristeria;
GRANT SELECT ON vista_detalles_detalle_bouquet TO floristeria;
GRANT SELECT ON vista_detalles_factura_final TO floristeria;
GRANT SELECT ON vista_detalles_detalle_factura TO floristeria;
GRANT SELECT ON vista_detalles_telefonos TO cuenta1;
```