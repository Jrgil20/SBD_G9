# Resumen de Secuencias y Tablas

## CREATE SEQUENCE
- pais_seq
- subastadora_seq
- productoras_seq
- floristerias_seq
- cliente_natural_seq
- cliente_juridico_seq
- flor_cortes_seq
- significado_seq
- color_seq
- enlaces_seq
- pagos_seq

## CREATE TABLE
### PAIS
| paisId | nombrePais | continente |
|--------|-------------|------------|

### SUBASTADORA
| subastadoraId | nombreSubastadora | idPais |
|---------------|-------------------|--------|

### PRODUCTORAS
| productoraId | nombreProductora | paginaWeb | idPais |
|--------------|------------------|-----------|--------|

### FLORISTERIAS
| floristeriaId | nombre | email | paginaWeb | idPais |
|---------------|--------|-------|-----------|--------|

### CLIENTE_NATURAL
| cliNaturalId | documentoIdentidad | primernombre | primerApellido | segundoApellido | segundonombre |
|--------------|--------------------|--------------|----------------|-----------------|---------------|

### CLIENTE_JURIDICO
| cliJuridicoId | RIF | nombre |
|---------------|-----|--------|

### FLOR_CORTES
| corteId | nombreComun | Descripcion | genero_especie | etimologia | colores | temperatura |
|---------|-------------|-------------|----------------|------------|--------|-------------|

### SIGNIFICADO
| SignificadoId | Tipo | Descripcion |
|---------------|------|-------------|

### COLOR
| colorId | Nombre | Descripcion |
|---------|--------|-------------|

### ENLACES
| IdSignificado | enlaceId | Descripcion | idColor | idCorte |
|---------------|----------|-------------|---------|---------|

### CATALOGOPRODUCTOR
| idProductora | idCorte | vbn | nombrepropio | descripcion |
|--------------|---------|-----|--------------|-------------|

### CONTRATO
| idSubastadora | idProductora | nContrato | fechaemision | porcentajeProduccion | tipoProductor | idrenovS | idrenovP | ren_nContrato | cancelado |
|---------------|--------------|-----------|--------------|----------------------|--------------|----------|----------|---------------|-----------|

### CANTIDAD_OFRECIDA
| idContratoSubastadora | idContratoProductora | idNContrato | idCatalogoProductora | idCatalogoCorte | idVnb | cantidad |
|-----------------------|----------------------|-------------|----------------------|-----------------|-------|---------|

### PAGOS
| idContratoSubastadora | idContratoProductora | idNContrato | pagoId | fechaPago | montoComision | tipo |
|-----------------------|----------------------|-------------|--------|-----------|---------------|------|

### CONTACTOS
| idFloristeria | contactoId | documentoIdentidad | primerNombre | primerApellido | segundoApellido | segundoNombre |
|---------------|------------|--------------------|--------------|----------------|-----------------|---------------|

### AFILIACION
| idFloristeria | idSubastadora |
|---------------|---------------|

### FACTURA
| facturaId | idAfiliacionFloristeria | idAfiliacionSubastadora | fechaEmision | montoTotal | numeroEnvio |
|-----------|-------------------------|-------------------------|--------------|------------|-------------|

### LOTE
| idCantidadContratoSubastadora | idCantidadContratoProductora | idCantidad_NContrato | idCantidadCatalogoProductora | idCantidadCorte | idCantidadvnb | NumLote | bi | cantidad | precioInicial | precioFinal | idFactura |
|-------------------------------|-----------------------------|----------------------|-----------------------------|-----------------|--------------|--------|----|---------|--------------|------------|----------|

### CATALOGO_FLORISTERIA
| idFloristeria | codigo | idCorteFlor | idColor | nombrePropio | descripcion |
|---------------|--------|-------------|---------|--------------|-------------|

### HISTORICO_PRECIO_FLOR
| idCatalogoFloristeria | idCatalogocodigo | fechaInicio | fechaFin | precio | tamanoTallo |
|-----------------------|------------------|-------------|----------|-------|-------------|

### DETALLE_BOUQUET
| idCatalogoFloristeria | idCatalogocodigo | bouquetId | cantidad | talloTamano | descripcion |
|-----------------------|------------------|-----------|---------|-------------|-------------|

### FACTURA_FINAL
| idFloristeria | numFactura | fechaEmision | montoTotal | idClienteNatural | idClienteJuridico |
|---------------|------------|--------------|------------|------------------|-------------------|

### DETALLE_FACTURA
| idFActuraFloristeria | idNumFactura | detalleId | catalogoFloristeria | catalogoCodigo | bouquetFloristeria | bouquetcodigo | bouquetId | cantidad | valoracionPrecio | valorancionCalidad | valoracionPromedio | detalles |
|----------------------|-------------|-----------|---------------------|----------------|--------------------|---------------|-----------|---------|------------------|-------------------|--------------------|---------|

### TELEFONOS
| codPais | codArea | numero | idSubastadora | idProductora | idFloristeria |
|---------|---------|--------|---------------|--------------|---------------|
