-- create sequence for PAIS
CREATE SEQUENCE pais_seq START WITH 1 INCREMENT BY 1 MAXVALUE 193;

-- create pais
CREATE TABLE PAIS (
  paisId NUMERIC(3) PRIMARY KEY DEFAULT nextval('pais_seq'),
  nombrePais TEXT NOT NULL,
  continente TEXT NOT NULL
);

-- add check constraint to continente
ALTER TABLE PAIS
ADD CONSTRAINT chk_continente
CHECK (continente IN ('Af', 'As', 'Am', 'Eu', 'Oc'));


-- create sequence for SUBASTADORA
CREATE SEQUENCE subastadora_seq START WITH 1 INCREMENT BY 1;

-- create subastadora
CREATE TABLE SUBASTADORA (
  subastadoraId NUMERIC PRIMARY KEY DEFAULT nextval('subastadora_seq'),
  nombreSubastadora TEXT NOT NULL,
  idPais NUMERIC NOT NULL
);

-- add foreign key constraint
ALTER TABLE SUBASTADORA
ADD CONSTRAINT fk_idPais_subastadora
FOREIGN KEY (idPais)
REFERENCES PAIS(paisId);


-- create sequence for PRODUCTORAS
CREATE SEQUENCE productoras_seq START WITH 1 INCREMENT BY 1;

-- create productoras
CREATE TABLE PRODUCTORAS (
  productoraId NUMERIC PRIMARY KEY DEFAULT nextval('productoras_seq'),
  nombreProductora VARCHAR NOT NULL,
  paginaWeb VARCHAR NOT NULL,
  idPais NUMERIC NOT NULL
);

-- add foreign key constraint
ALTER TABLE PRODUCTORAS
ADD CONSTRAINT fk_idPais_productoras
FOREIGN KEY (idPais)
REFERENCES PAIS(paisId);


-- create sequence for FLORISTERIAS
CREATE SEQUENCE floristerias_seq START WITH 1 INCREMENT BY 1;

-- create floristerias
CREATE TABLE FLORISTERIAS (
  floristeriaId NUMERIC PRIMARY KEY DEFAULT nextval('floristerias_seq'),
  nombre VARCHAR NOT NULL,
  email VARCHAR NOT NULL,
  paginaWeb VARCHAR NOT NULL,
  idPais NUMERIC NOT NULL
);

-- add foreign key constraint
ALTER TABLE FLORISTERIAS
ADD CONSTRAINT fk_idPais_floristerias
FOREIGN KEY (idPais)
REFERENCES PAIS(paisId);


-- create sequence for CLIENTE_NATURAL
CREATE SEQUENCE cliente_natural_seq START WITH 1 INCREMENT BY 1;

-- create CLIENTE_NATURAL
CREATE TABLE CLIENTE_NATURAL (
  cliNaturalId NUMERIC PRIMARY KEY DEFAULT nextval('cliente_natural_seq'),
  documentoIdentidad NUMERIC NOT NULL,
  primernombre VARCHAR NOT NULL,
  primerApellido VARCHAR NOT NULL,
  segundoApellido VARCHAR NOT NULL,
  segundonombre VARCHAR
);


-- create sequence for CLIENTE_JURIDICO
CREATE SEQUENCE cliente_juridico_seq START WITH 1 INCREMENT BY 1;

-- create CLIENTE_JURIDICO
CREATE TABLE CLIENTE_JURIDICO (
  cliJuridicoId NUMERIC PRIMARY KEY DEFAULT nextval('cliente_juridico_seq'),
  RIF NUMERIC NOT NULL UNIQUE,
  nombre VARCHAR NOT NULL
);


-- create sequence for FLOR_CORTES
CREATE SEQUENCE flor_cortes_seq START WITH 1 INCREMENT BY 1;

-- create FLOR_CORTES
CREATE TABLE FLOR_CORTES (
  corteId NUMERIC PRIMARY KEY DEFAULT nextval('flor_cortes_seq'),
  nombreComun VARCHAR NOT NULL,
  Descripcion VARCHAR NOT NULL,
  genero_especie VARCHAR NOT NULL,
  etimologia VARCHAR NOT NULL,
  colores VARCHAR NOT NULL,
  temperatura NUMERIC NOT NULL
);


-- create sequence for SIGNIFICADO
CREATE SEQUENCE significado_seq START WITH 1 INCREMENT BY 1;

-- create SIGNIFICADO
CREATE TABLE SIGNIFICADO (
  SignificadoId NUMERIC PRIMARY KEY DEFAULT nextval('significado_seq'),
  Tipo VARCHAR NOT NULL,
  Descripcion VARCHAR NOT NULL
);

-- Agregar restricción CHECK a la columna Tipo en la tabla SIGNIFICADO
ALTER TABLE SIGNIFICADO
ADD CONSTRAINT chk_tipo CHECK (Tipo IN ('Oc', 'Se'));



-- create sequence for COLOR
CREATE SEQUENCE color_seq START WITH 1 INCREMENT BY 1;

-- create COLOR
CREATE TABLE COLOR (
  colorId NUMERIC PRIMARY KEY DEFAULT nextval('color_seq'),
  Nombre VARCHAR NOT NULL,
  Descripcion VARCHAR NOT NULL
);


-- create sequence for ENLACES
CREATE SEQUENCE enlaces_seq START WITH 1 INCREMENT BY 1;

-- create ENLACES
CREATE TABLE ENLACES (
  IdSignificado NUMERIC NOT NULL,
  enlaceId NUMERIC NOT NULL DEFAULT nextval('enlaces_seq'),
  Descripcion VARCHAR NOT NULL,
  idColor NUMERIC,
  idCorte NUMERIC,
  PRIMARY KEY (IdSignificado, enlaceId)
);

-- Agregar clave foránea
ALTER TABLE ENLACES
ADD CONSTRAINT fk_IdSignificado FOREIGN KEY (IdSignificado) REFERENCES SIGNIFICADO(SignificadoId),
ADD CONSTRAINT FK1 FOREIGN KEY (idColor) REFERENCES COLOR(colorId),
ADD CONSTRAINT FK2 FOREIGN KEY (idCorte) REFERENCES FLOR_CORTES(corteId);

ALTER TABLE ENLACES
ADD CONSTRAINT chk_enlaces CHECK (idColor IS NOT NULL OR idCorte IS NOT NULL);



-- create CATALOGOPRODUCTOR
CREATE TABLE CATALOGOPRODUCTOR (
  idProductora NUMERIC NOT NULL,
  idCorte NUMERIC NOT NULL,
  vbn NUMERIC NOT NULL,
  nombrepropio VARCHAR NOT NULL,
  descripcion VARCHAR,
  PRIMARY KEY (idProductora, idCorte, vbn)
);

-- Agregar claves foráneas y restricción UNIQUE
ALTER TABLE CATALOGOPRODUCTOR
ADD CONSTRAINT FK1 FOREIGN KEY (idCorte) REFERENCES FLOR_CORTES(corteId),
ADD CONSTRAINT FK2 FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS(productoraId),
ADD CONSTRAINT unique_vbn UNIQUE (vbn);


-- Crear la tabla
CREATE TABLE CONTRATO (
  idSubastadora NUMERIC NOT NULL,
  idProductora NUMERIC NOT NULL,
  nContrato NUMERIC NOT NULL,
  fechaemision DATE NOT NULL,
  porcentajeProduccion NUMERIC(3,2) NOT NULL,
  tipoProductor VARCHAR NOT NULL,
  idrenovS NUMERIC,
  idrenovP NUMERIC,
  ren_nContrato NUMERIC,
  cancelado DATE,
  PRIMARY KEY (idSubastadora, idProductora, nContrato)
);

-- Agregar claves foráneas y check
ALTER TABLE CONTRATO
ADD CONSTRAINT fk_idSubastadora_contrato FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId),
ADD CONSTRAINT fk_idProductora_contrato FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS (productoraId),
ADD CONSTRAINT fk_renovacion_contrato FOREIGN KEY (idrenovS, idrenovP, ren_nContrato) REFERENCES CONTRATO(idSubastadora, idProductora, nContrato),
ADD CONSTRAINT check_tipoProductor CHECK (tipoProductor IN ('Ca', 'Cb', 'Cc', 'Cg', 'Ka')),
ADD CONSTRAINT check_porcentajeProduccion CHECK (
  (tipoProductor = 'Ca' AND porcentajeProduccion > 0.50) OR
  (tipoProductor = 'Cb' AND porcentajeProduccion > 0.20 AND porcentajeProduccion < 0.50) OR
  (tipoProductor = 'Cc' AND porcentajeProduccion < 0.20) OR
  (tipoProductor = 'Ka' AND porcentajeProduccion = 1.00)
);


-- Crear la tabla
CREATE TABLE CANTIDAD_OFRECIDA (
  idContratoSubastadora NUMERIC NOT NULL,
  idContratoProductora NUMERIC NOT NULL,
  idNContrato NUMERIC NOT NULL,
  idCatalogoProductora NUMERIC NOT NULL,
  idCatalogoCorte NUMERIC NOT NULL,
  idVnb NUMERIC NOT NULL,
  cantidad NUMERIC NOT NULL,
  PRIMARY KEY (idContratoSubastadora, idContratoProductora, idNContrato, idCatalogoProductora, idCatalogoCorte, idVnb)
);

-- Agregar claves foráneas compuestas
ALTER TABLE CANTIDAD_OFRECIDA
ADD CONSTRAINT fk_Contrato_CantidadOfrecida FOREIGN KEY (idContratoSubastadora, idContratoProductora, idNContrato) 
REFERENCES CONTRATO (idSubastadora, idProductora, nContrato),
ADD CONSTRAINT fk_CatalogoProductor_CantidadOfrecida FOREIGN KEY (idCatalogoProductora, idCatalogoCorte, idVnb) 
REFERENCES CATALOGOPRODUCTOR (idProductora, idCorte, vbn);

ALTER TABLE CANTIDAD_OFRECIDA
ADD CONSTRAINT chk_idCatalogoProductora_equals_idContratoProductora
CHECK (idCatalogoProductora = idContratoProductora);


-- Crear la secuencia para PAGOS
CREATE SEQUENCE pagos_seq START WITH 1 INCREMENT BY 1;

-- Crear la tabla
CREATE TABLE PAGOS(
  idContratoSubastadora NUMERIC NOT NULL,
  idContratoProductora NUMERIC NOT NULL,
  idNContrato NUMERIC NOT NULL,
  pagoId NUMERIC NOT NULL DEFAULT nextval('pagos_seq'),
  fechaPago DATE NOT NULL,
  montoComision NUMERIC NOT NULL,
  tipo VARCHAR NOT NULL,
  PRIMARY KEY (idContratoSubastadora, idContratoProductora, idNContrato, pagoId)
);

-- Agregar claves foráneas y check
ALTER TABLE PAGOS
ADD CONSTRAINT fk_Contrato_Pagos FOREIGN KEY (idContratoSubastadora, idContratoProductora, idNContrato) 
REFERENCES CONTRATO (idSubastadora, idProductora, nContrato),
ADD CONSTRAINT check_tipoProductor CHECK (tipo IN ('membresia', 'pago','multa'));


-- Crear la tabla
CREATE TABLE CONTACTOS(
  idFloristeria NUMERIC NOT NULL,
  contactoId NUMERIC NOT NULL,
  documentoIdentidad NUMERIC NOT NULL,
  primerNombre VARCHAR NOT NULL,
  primerApellido VARCHAR NOT NULL,
  segundoApellido VARCHAR Not Null,
  segundoNombre VARCHAR,
  PRIMARY KEY (idFloristeria, contactoId)
);

-- Agregar claves foráneas
ALTER TABLE CONTACTOS
ADD CONSTRAINT fk_idFloristeria_contactos FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId);


-- Crear la tabla
CREATE TABLE AFILIACION(
  idFloristeria NUMERIC NOT NULL,
  idSubastadora NUMERIC NOT NULL,
  PRIMARY KEY (idFloristeria, idSubastadora)
);

-- Agregar claves foráneas
ALTER TABLE AFILIACION
ADD CONSTRAINT fk_idFloristeria_afiliacion FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idSubastadora_afiliacion FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId);


-- Crear la tabla
CREATE TABLE FACTURA(
  facturaId NUMERIC NOT NULL,
  idAfiliacionFloristeria NUMERIC NOT NULL,
  idAfiliacionSubastadora NUMERIC NOT NULL,
  fechaEmision DATE NOT NULL,
  montoTotal NUMERIC NOT NULL,
  numeroEnvio NUMERIC,
  PRIMARY KEY (facturaId)
);

-- Agregar claves foráneas
ALTER TABLE FACTURA
ADD CONSTRAINT fk_afiliacion_factura FOREIGN KEY (idAfiliacionFloristeria,idAfiliacionSubastadora) REFERENCES AFILIACION (idFloristeria, idSubastadora);


-- Crear la tabla
CREATE TABLE LOTE(
  idCantidadContratoSubastadora NUMERIC NOT NULL,
  idCantidadContratoProductora NUMERIC NOT NULL,
  idCantidad_NContrato NUMERIC NOT NULL,
  idCantidadCatalogoProductora NUMERIC NOT NULL,
  idCantidadCorte NUMERIC NOT NULL,
  idCantidadvnb NUMERIC NOT NULL,
  NumLote NUMERIC NOT NULL,
  bi NUMERIC NOT NULL,
  cantidad NUMERIC NOT NULL,
  precioInicial NUMERIC NOT NULL,
  precioFinal NUMERIC NOT NULL,
  idFactura NUMERIC NOT NULL,
  PRIMARY KEY (idCantidadContratoSubastadora, idCantidadContratoProductora, idCantidad_NContrato, idCantidadCatalogoProductora, idCantidadCorte, idCantidadvnb, NumLote)
);

-- Agregar claves foráneas
ALTER TABLE LOTE
ADD CONSTRAINT fk_CantidadOfrecida_Lote FOREIGN KEY (idCantidadContratoSubastadora, idCantidadContratoProductora, idCantidad_NContrato, idCantidadCatalogoProductora, idCantidadCorte, idCantidadvnb) 
REFERENCES CANTIDAD_OFRECIDA (idContratoSubastadora, idContratoProductora, idNContrato, idCatalogoProductora, idCatalogoCorte, idVnb),
ADD CONSTRAINT fk_idFactura_lote FOREIGN KEY (idFactura) REFERENCES FACTURA (facturaId);


-- Crear la tabla
CREATE TABLE CATALOGO_FLORISTERIA(
  idFloristeria NUMERIC NOT NULL,
  codigo NUMERIC NOT NULL,
  idCorteFlor NUMERIC NOT NULL,
  idColor NUMERIC NOT NULL,
  nombrePropio VARCHAR NOT NULL,
  descripcion VARCHAR,
  PRIMARY KEY (idFloristeria,codigo)
);

-- Agregar claves foráneas
ALTER TABLE CATALOGO_FLORISTERIA
ADD CONSTRAINT fk_idFloristeria_catalogofloristeria FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idCorteFlor_catalogofloristeria FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId),
ADD CONSTRAINT fk_idCodigo_catalogofloristeria FOREIGN KEY (idColor) REFERENCES COLOR (colorId);


-- Crear la tabla
CREATE TABLE HISTORICO_PRECIO_FLOR(
  idCatalogoFloristeria NUMERIC NOT NULL,
  idCatalogocodigo NUMERIC NOT NULL, 
  fechaInicio DATE NOT NULL,
  fechaFin DATE,
  precio NUMERIC NOT NULL,
  tamanoTallo NUMERIC ,
  PRIMARY KEY (idCatalogoFloristeria, idCatalogocodigo, fechaInicio)
);

-- Agregar claves foráneas
ALTER TABLE HISTORICO_PRECIO_FLOR
ADD Constraint fk_Catalogo_historicoPrecioFlor FOREIGN KEY (idCatalogoFloristeria, idCatalogocodigo) REFERENCES CATALOGO_FLORISTERIA (idFloristeria, codigo),
ADD Constraint check_fechaIni_fin CHECK (fechaFin IS NULL OR fechaInicio < fechaFin);


-- Crear la tabla
CREATE TABLE DETALLE_BOUQUET(
  idCatalogoFloristeria NUMERIC NOT NULL,
  idCatalogocodigo NUMERIC NOT NULL,
  bouquetId NUMERIC NOT NULL,
  cantidad NUMERIC NOT NULL,
  talloTamano NUMERIC,
  descripcion VARCHAR,
  PRIMARY KEY (idCatalogoFloristeria, idCatalogocodigo, bouquetId)
);

-- Agregar claves foráneas
ALTER TABLE DETALLE_BOUQUET
ADD Constraint fk_Catalogo_DetalleBouquet FOREIGN KEY (idCatalogoFloristeria, idCatalogocodigo) REFERENCES CATALOGO_FLORISTERIA (idFloristeria, codigo);


-- Crear la tabla 
CREATE TABLE FACTURA_FINAL(
  idFloristeria NUMERIC NOT NULL,
  numFactura NUMERIC NOT NULL,
  fechaEmision DATE NOT NULL,
  montoTotal NUMERIC NOT NULL,
  idClienteNatural NUMERIC,
  idClienteJuridico NUMERIC,
  PRIMARY KEY (idFloristeria, numFactura)
);


-- Agregar claves foráneas
ALTER TABLE FACTURA_FINAL
ADD CONSTRAINT fk_idFloristeria_facturaFinal FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idCLienteNAatural_facturaFinal FOREIGN KEY (idClienteNatural) REFERENCES CLIENTE_NATURAL (cliNaturalId),
ADD CONSTRAINT fk_idClienteJuridico_facturaFinal FOREIGN KEY (idClienteJuridico) REFERENCES CLIENTE_JURIDICO (cliJuridicoId);

-- Agregar restricción CHECK para asegurar que solo uno de los campos idClienteNatural o idClienteJuridico tenga un valor y el otro sea NULL
ALTER TABLE FACTURA_FINAL
ADD CONSTRAINT chk_FacturaFinal_ArcoExclusivo CHECK (
  (idClienteNatural IS NOT NULL AND idClienteJuridico IS NULL) OR 
  (idClienteNatural IS NULL AND idClienteJuridico IS NOT NULL)
);


-- Crear la tabla
CREATE TABLE DETALLE_FACTURA(
  idFActuraFloristeria NUMERIC NOT NULL,
  idNumFactura NUMERIC NOT NULL,
  detalleId NUMERIC NOT NULL,
  catalogoFloristeria NUMERIC,
  catalogoCodigo NUMERIC,
  bouquetFloristeria NUMERIC,
  bouquetcodigo NUMERIC,
  bouquetId NUMERIC,
  cantidad NUMERIC NOT NULL,
  valoracionPrecio NUMERIC,
  valorancionCalidad NUMERIC,
  valoracionPromedio NUMERIC,
  detalles VARCHAR,
  PRIMARY KEY (idFActuraFloristeria, idNumFactura, detalleId)
);

-- Agregar claves foráneas
ALTER TABLE DETALLE_FACTURA
ADD CONSTRAINT fk_idFactura_detalleFactura FOREIGN KEY (idFActuraFloristeria,idNumFactura) REFERENCES FACTURA_FINAL (idFloristeria, numFactura),
ADD CONSTRAINT fk_codigoCatalogo_detalleFactura FOREIGN KEY (catalogoFloristeria, catalogoCodigo) REFERENCES CATALOGO_FLORISTERIA (idFloristeria, codigo),
ADD CONSTRAINT fk_idBouquet_detalleFactura FOREIGN KEY (bouquetFloristeria, bouquetcodigo, bouquetId) REFERENCES DETALLE_BOUQUET (idCatalogoFloristeria, idCatalogocodigo, bouquetId);

-- Agregar restricción CHECK para asegurar que solo uno de los campos catalogoFloristeria/catalogoCodigo o bouquetFloristeria/bouquetcodigo/bouquetId tenga un valor y los otros sean NULL
ALTER TABLE DETALLE_FACTURA
ADD CONSTRAINT chk_detalle_ArcoExclusivo CHECK (
  (catalogoFloristeria IS NOT NULL AND catalogoCodigo IS NOT NULL AND bouquetFloristeria IS NULL AND bouquetcodigo IS NULL AND bouquetId IS NULL) OR 
  (catalogoFloristeria IS NULL AND catalogoCodigo IS NULL AND bouquetFloristeria IS NOT NULL AND bouquetcodigo IS NOT NULL AND bouquetId IS NOT NULL)
);


-- Crear la tabla
CREATE TABLE TELEFONOS(
  codPais NUMERIC NOT NULL,
  codArea NUMERIC NOT NULL,
  numero NUMERIC NOT NULL,
  idSubastadora NUMERIC,
  idProductora NUMERIC,
  idFloristeria NUMERIC,
  PRIMARY KEY (codPais, codArea, numero)
);

-- Agregar claves foráneas
ALTER TABLE TELEFONOS
ADD CONSTRAINT fk_idSubastadora_telefonos FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId),
ADD CONSTRAINT fk_idProductora_telefonos FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS (productoraId),
ADD CONSTRAINT fk_idFloristeria_telefonos FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId);

-- Agregar restricción CHECK para asegurar que solo uno de los campos idSubastadora, idProductora o idFloristeria tenga un valor y los otros sean NULL
ALTER TABLE TELEFONOS
ADD CONSTRAINT chk_telefono_ArcoExclusivo CHECK (
  (idSubastadora IS NOT NULL AND idProductora IS NULL AND idFloristeria IS NULL) OR 
  (idSubastadora IS NULL AND idProductora IS NOT NULL AND idFloristeria IS NULL) OR 
  (idSubastadora IS NULL AND idProductora IS NULL AND idFloristeria IS NOT NULL)
);
