-------------------------------------------------------------------------------------------------------------------
--  ===========================================================================================================  --
--  ================================== Tablas, secuencias y constrains ========================================  --
--  ===========================================================================================================  --
-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

-- create sequence for CLIENTE_JURIDICO
CREATE SEQUENCE cliente_juridico_seq START WITH 1 INCREMENT BY 1;

-- create CLIENTE_JURIDICO
CREATE TABLE CLIENTE_JURIDICO (
  cliJuridicoId NUMERIC PRIMARY KEY DEFAULT nextval('cliente_juridico_seq'),
  RIF NUMERIC NOT NULL UNIQUE,
  nombre VARCHAR NOT NULL
);

-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------------------------------------------

-- create sequence for COLOR
CREATE SEQUENCE color_seq START WITH 1 INCREMENT BY 1;

-- create COLOR
CREATE TABLE COLOR (
  colorId NUMERIC PRIMARY KEY DEFAULT nextval('color_seq'),
  Nombre VARCHAR NOT NULL,
  Descripcion VARCHAR NOT NULL
);

-------------------------------------------------------------------------------------------------------------------

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
ADD CONSTRAINT fk_IdSignificado FOREIGN KEY (IdSignificado) REFERENCES SIGNIFICADO(SignificadoId);

ALTER TABLE ENLACES
ADD CONSTRAINT FK_Enlaces_Color FOREIGN KEY (idColor) REFERENCES COLOR(colorId);

ALTER TABLE ENLACES
ADD CONSTRAINT FK_Enlaces_Corte FOREIGN KEY (idCorte) REFERENCES FLOR_CORTES(corteId);

ALTER TABLE ENLACES
ADD CONSTRAINT chk_enlaces CHECK (idColor IS NOT NULL OR idCorte IS NOT NULL);

--------------------------------------------------------------------------------------------------------------------

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
ADD CONSTRAINT FK_Catalogo_Corte FOREIGN KEY (idCorte) REFERENCES FLOR_CORTES(corteId);

ALTER TABLE CATALOGOPRODUCTOR
ADD CONSTRAINT FK_Catalogo_Productora FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS(productoraId);

ALTER TABLE CATALOGOPRODUCTOR
ADD CONSTRAINT unique_vbn UNIQUE (vbn);

--------------------------------------------------------------------------------------------------------------------

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
ADD CONSTRAINT fk_idSubastadora_contrato FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId);

ALTER TABLE CONTRATO
ADD CONSTRAINT fk_idProductora_contrato FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS (productoraId);

ALTER TABLE CONTRATO
ADD CONSTRAINT fk_renovacion_contrato FOREIGN KEY (idrenovS, idrenovP, ren_nContrato) REFERENCES CONTRATO(idSubastadora, idProductora, nContrato);

ALTER TABLE CONTRATO
ADD CONSTRAINT check_tipoProductor CHECK (tipoProductor IN ('Ca', 'Cb', 'Cc', 'Cg', 'Ka'));

ALTER TABLE CONTRATO
ADD CONSTRAINT check_porcentajeProduccion CHECK (
  (tipoProductor = 'Ca' AND porcentajeProduccion > 0.50) OR
  (tipoProductor = 'Cb' AND porcentajeProduccion > 0.20 AND porcentajeProduccion < 0.50) OR
  (tipoProductor = 'Cc' AND porcentajeProduccion < 0.20) OR
  (tipoProductor = 'Ka' AND porcentajeProduccion = 1.00)
);

-----------------------------------------------------------------------------------------------------------------

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
REFERENCES CONTRATO (idSubastadora, idProductora, nContrato);

ALTER TABLE CANTIDAD_OFRECIDA
ADD CONSTRAINT fk_CatalogoProductor_CantidadOfrecida FOREIGN KEY (idCatalogoProductora, idCatalogoCorte, idVnb) 
REFERENCES CATALOGOPRODUCTOR (idProductora, idCorte, vbn);

ALTER TABLE CANTIDAD_OFRECIDA
ADD CONSTRAINT chk_idCatalogoProductora_equals_idContratoProductora
CHECK (idCatalogoProductora = idContratoProductora);

-----------------------------------------------------------------------------------------------------------------

-- Crear la secuencia para PAGOS
CREATE SEQUENCE Pagos_seq START WITH 1 INCREMENT BY 1;

-- Crear la tabla
CREATE TABLE PAGOS(
  idContratoSubastadora NUMERIC NOT NULL,
  idContratoProductora NUMERIC NOT NULL,
  idNContrato NUMERIC NOT NULL,
  PagoId NUMERIC NOT NULL DEFAULT nextval('Pagos_seq'),
  fechaPago DATE NOT NULL,
  montoComision NUMERIC NOT NULL,
  tipo VARCHAR NOT NULL,
  PRIMARY KEY (idContratoSubastadora, idContratoProductora, idNContrato, PagoId)
);

-- Agregar claves foráneas y check
ALTER TABLE PAGOS
ADD CONSTRAINT fk_Contrato_Pagos FOREIGN KEY (idContratoSubastadora, idContratoProductora, idNContrato) 
REFERENCES CONTRATO (idSubastadora, idProductora, nContrato);

ALTER TABLE PAGOS
ADD CONSTRAINT check_tipoProductor CHECK (tipo IN ('membresia', 'Pago','multa'));

--------------------------------------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------------------------------

-- Crear la tabla
CREATE TABLE AFILIACION(
  idFloristeria NUMERIC NOT NULL,
  idSubastadora NUMERIC NOT NULL,
  PRIMARY KEY (idFloristeria, idSubastadora)
);

-- Agregar claves foráneas
ALTER TABLE AFILIACION
ADD CONSTRAINT fk_idFloristeria_afiliacion FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId);

ALTER TABLE AFILIACION
ADD CONSTRAINT fk_idSubastadora_afiliacion FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId);

--------------------------------------------------------------------------------------------------------------------

-- Crear la secuencia para FACTURA
CREATE SEQUENCE factura_seq START WITH 1 INCREMENT BY 1;

-- Crear la tabla
CREATE TABLE FACTURA(
  facturaId NUMERIC NOT NULL,
  idAfiliacionFloristeria NUMERIC NOT NULL,
  idAfiliacionSubastadora NUMERIC NOT NULL,
  fechaEmision TIMESTAMP NOT NULL,
  montoTotal NUMERIC NOT NULL,
  numeroEnvio NUMERIC,
  PRIMARY KEY (facturaId)
);

-- Modificar la tabla FACTURA para usar la secuencia
ALTER TABLE FACTURA
ALTER COLUMN facturaId SET DEFAULT nextval('factura_seq');

-- Agregar claves foráneas
ALTER TABLE FACTURA
ADD CONSTRAINT fk_afiliacion_factura FOREIGN KEY (idAfiliacionFloristeria,idAfiliacionSubastadora) REFERENCES AFILIACION (idFloristeria, idSubastadora);

--------------------------------------------------------------------------------------------------------------------

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
REFERENCES CANTIDAD_OFRECIDA (idContratoSubastadora, idContratoProductora, idNContrato, idCatalogoProductora, idCatalogoCorte, idVnb);

ALTER TABLE LOTE
ADD CONSTRAINT fk_idFactura_lote FOREIGN KEY (idFactura) REFERENCES FACTURA (facturaId);

--------------------------------------------------------------------------------------------------------------------

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
ADD CONSTRAINT fk_idFloristeria_catalogofloristeria FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId);

ALTER TABLE CATALOGO_FLORISTERIA
ADD CONSTRAINT fk_idCorteFlor_catalogofloristeria FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId);

ALTER TABLE CATALOGO_FLORISTERIA
ADD CONSTRAINT fk_idCodigo_catalogofloristeria FOREIGN KEY (idColor) REFERENCES COLOR (colorId);

--------------------------------------------------------------------------------------------------------------------

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
ADD Constraint fk_Catalogo_historicoPrecioFlor FOREIGN KEY (idCatalogoFloristeria, idCatalogocodigo) REFERENCES CATALOGO_FLORISTERIA (idFloristeria, codigo);

ALTER TABLE HISTORICO_PRECIO_FLOR
ADD Constraint check_fechaIni_fin CHECK (fechaFin IS NULL OR fechaInicio < fechaFin);

--------------------------------------------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------------------------------------------

-- Crear la secuencia para FACTURA_FINAL
CREATE SEQUENCE factura_final_seq START WITH 1 INCREMENT BY 1;

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
ADD CONSTRAINT fk_idFloristeria_facturaFinal FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId);

ALTER TABLE FACTURA_FINAL
ADD CONSTRAINT fk_idCLienteNAatural_facturaFinal FOREIGN KEY (idClienteNatural) REFERENCES CLIENTE_NATURAL (cliNaturalId);

ALTER TABLE FACTURA_FINAL
ADD CONSTRAINT fk_idClienteJuridico_facturaFinal FOREIGN KEY (idClienteJuridico) REFERENCES CLIENTE_JURIDICO (cliJuridicoId);

-- Agregar restricción CHECK para asegurar que solo uno de los campos idClienteNatural o idClienteJuridico tenga un valor y el otro sea NULL
ALTER TABLE FACTURA_FINAL
ADD CONSTRAINT chk_FacturaFinal_ArcoExclusivo CHECK (
  (idClienteNatural IS NOT NULL AND idClienteJuridico IS NULL) OR 
  (idClienteNatural IS NULL AND idClienteJuridico IS NOT NULL)
);

-- Modificar la tabla FACTURA_FINAL para usar la secuencia
ALTER TABLE FACTURA_FINAL
ALTER COLUMN numFactura SET DEFAULT nextval('factura_final_seq');

--------------------------------------------------------------------------------------------------------------------

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
ADD CONSTRAINT fk_idFactura_detalleFactura FOREIGN KEY (idFActuraFloristeria,idNumFactura) REFERENCES FACTURA_FINAL (idFloristeria, numFactura);

ALTER TABLE DETALLE_FACTURA
ADD CONSTRAINT fk_codigoCatalogo_detalleFactura FOREIGN KEY (catalogoFloristeria, catalogoCodigo) REFERENCES CATALOGO_FLORISTERIA (idFloristeria, codigo);

ALTER TABLE DETALLE_FACTURA
ADD CONSTRAINT fk_idBouquet_detalleFactura FOREIGN KEY (bouquetFloristeria, bouquetcodigo, bouquetId) REFERENCES DETALLE_BOUQUET (idCatalogoFloristeria, idCatalogocodigo, bouquetId);

-- Agregar restricción CHECK para asegurar que solo uno de los campos catalogoFloristeria/catalogoCodigo o bouquetFloristeria/bouquetcodigo/bouquetId tenga un valor y los otros sean NULL
ALTER TABLE DETALLE_FACTURA
ADD CONSTRAINT chk_detalle_ArcoExclusivo CHECK (
  (catalogoFloristeria IS NOT NULL AND catalogoCodigo IS NOT NULL AND bouquetFloristeria IS NULL AND bouquetcodigo IS NULL AND bouquetId IS NULL) OR 
  (catalogoFloristeria IS NULL AND catalogoCodigo IS NULL AND bouquetFloristeria IS NOT NULL AND bouquetcodigo IS NOT NULL AND bouquetId IS NOT NULL)
);

--------------------------------------------------------------------------------------------------------------------

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
ADD CONSTRAINT fk_idSubastadora_telefonos FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId);

ALTER TABLE TELEFONOS
ADD CONSTRAINT fk_idProductora_telefonos FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS (productoraId);

ALTER TABLE TELEFONOS
ADD CONSTRAINT fk_idFloristeria_telefonos FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId);

-- Agregar restricción CHECK para asegurar que solo uno de los campos idSubastadora, idProductora o idFloristeria tenga un valor y los otros sean NULL
ALTER TABLE TELEFONOS
ADD CONSTRAINT chk_telefono_ArcoExclusivo CHECK (
  (idSubastadora IS NOT NULL AND idProductora IS NULL AND idFloristeria IS NULL) OR 
  (idSubastadora IS NULL AND idProductora IS NOT NULL AND idFloristeria IS NULL) OR 
  (idSubastadora IS NULL AND idProductora IS NULL AND idFloristeria IS NOT NULL)
);



-------------------------------------------------------------------------------------------------------------------
--  ===========================================================================================================  --
--  ======================================== Triggers y Programas =============================================  --
--  ===========================================================================================================  --
-------------------------------------------------------------------------------------------------------------------

------------------------------------------------   Contratos  -----------------------------------------------------



-- Crear la función para verificar la nacionalidad del productor en el contrato
CREATE OR REPLACE FUNCTION check_nacionalidad_productor_contrato() RETURNS TRIGGER AS $$
DECLARE
  paisIdHolanda NUMERIC;
  productoraPaisId NUMERIC;
BEGIN
  SELECT paisId INTO paisIdHolanda FROM PAIS WHERE nombrePais = 'Holanda';
  
  IF NEW.tipoProductor = 'Ka' THEN
    SELECT idPais INTO productoraPaisId FROM PRODUCTORAS WHERE productoraId = NEW.idProductora;
    IF productoraPaisId = paisIdHolanda THEN
      RAISE EXCEPTION 'La productora no puede ser de Holanda para el tipo de productor Ka';
    END IF;
  ELSE
    SELECT idPais INTO productoraPaisId FROM PRODUCTORAS WHERE productoraId = NEW.idProductora;
    IF productoraPaisId <> paisIdHolanda THEN
      RAISE EXCEPTION 'La productora debe ser de Holanda para otros tipos de productor';
    END IF;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para verificar la nacionalidad del productor en el contrato antes de insertar o actualizar
CREATE TRIGGER check_nacionalidad_productor_contrato
BEFORE INSERT OR UPDATE ON CONTRATO
FOR EACH ROW
EXECUTE FUNCTION check_nacionalidad_productor_contrato();


-- Crear la función para verificar la cantidad de contratos activos de una productora
CREATE OR REPLACE FUNCTION verificar_contrato_activo(idContratante NUMERIC, fecha DATE, CG BOOLEAN) RETURNS BOOLEAN AS $$
DECLARE
  contratoActivo BOOLEAN;
BEGIN
  contratoActivo := FALSE;
  IF CG THEN
    IF EXISTS (
      SELECT 1 
      FROM CONTRATO 
      WHERE idProductora = idContratante 
        AND (tipoProductor <> 'Cg')
        AND (cancelado IS NULL AND fechaemision > fecha - INTERVAL '1 year')
    ) THEN
      contratoActivo := TRUE;
    END IF;
    IF EXISTS (
      SELECT 1 
      FROM CONTRATO 
      WHERE idProductora = NEW.idProductora 
        AND idSubastadora = NEW.idSubastadora
        AND (cancelado IS NULL AND fechaemision > fecha - INTERVAL '1 year')
    ) THEN
      RAISE NOTICE 'No se puede insertar el contrato porque ya existe un contrato activo entre la productora y la subastadora';
    END IF;  
  ELSE
    IF EXISTS (
      SELECT 1 
      FROM CONTRATO 
      WHERE idProductora = idContratante 
        AND (cancelado IS NULL AND fechaemision > fecha - INTERVAL '1 year')
    ) THEN
      contratoActivo := TRUE;
    END IF;
  END IF;
  RETURN contratoActivo;
END;
$$ LANGUAGE plpgsql;


-- Crear la función para verificar si existe un contrato activo para una productora
CREATE OR REPLACE FUNCTION check_contrato_activo() RETURNS TRIGGER AS $$
BEGIN
  IF verificar_contrato_activo(NEW.idProductora, NEW.fechaemision, (NEW.tipoProductor = 'Cg')) THEN
    RAISE EXCEPTION 'Ya existe un contrato activo para esta productora';
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para verificar si existe un contrato activo para una productora antes de insertar
CREATE TRIGGER check_contrato_activo
BEFORE INSERT ON CONTRATO
FOR EACH ROW
EXECUTE FUNCTION check_contrato_activo();

-- Funcion que verifica el porcentaje de produccion de contratos cg
CREATE OR REPLACE FUNCTION check_porcentaje_cg( Contratante NUMERIC, NuevoPorcentaje NUMERIC, fecha DATE) RETURNS BOOLEAN AS $$
DECLARE
  PorcentajeActual NUMERIC := 0.00;
BEGIN
  SELECT COALESCE(SUM(porcentajeProduccion), 0)
  INTO PorcentajeActual
  FROM CONTRATO
  WHERE idProductora = Contratante
    AND tipoProductor = 'Cg'
    AND (cancelado IS NULL AND fechaemision > fecha - INTERVAL '1 year');
  RETURN (PorcentajeActual + NuevoPorcentaje) <= 1.00;
END;
$$ LANGUAGE plpgsql;


-- Crear la función para crear un nuevo contrato
CREATE OR REPLACE FUNCTION crear_nuevo_contrato(
  p_idSubastadora NUMERIC,
  p_idProductora NUMERIC,
  p_nContrato NUMERIC,
  p_fechaemision DATE,
  p_porcentajeProduccion NUMERIC(3,2),
  p_tipoProductor VARCHAR,
  p_idrenovS NUMERIC,
  p_idrenovP NUMERIC,
  p_ren_nContrato NUMERIC,
  p_cancelado DATE
) RETURNS VOID AS $$
BEGIN
  -- Verificar si existe un contrato activo para la productora
  IF verificar_contrato_activo(p_idProductora, p_fechaemision, (p_tipoProductor = 'Cg')) THEN
    RAISE NOTICE 'Ya existe un contrato activo para esta productora';
  ELSE
    -- Verificar si el porcentaje de producción es válido para el tipo de productor Cg
    IF p_tipoProductor = 'Cg' AND NOT check_porcentaje_cg(p_idProductora, p_porcentajeProduccion, p_fechaemision) THEN
      RAISE NOTICE 'El porcentaje de producción excede el 100 para el tipo de productor Cg';
    ELSE
      -- Insertar el nuevo contrato en la tabla CONTRATO
      INSERT INTO CONTRATO (
        idSubastadora, idProductora, nContrato, fechaemision, porcentajeProduccion, tipoProductor, idrenovS, idrenovP, ren_nContrato, cancelado
      ) VALUES (
        p_idSubastadora, p_idProductora, p_nContrato, p_fechaemision, p_porcentajeProduccion, p_tipoProductor, p_idrenovS, p_idrenovP, p_ren_nContrato, p_cancelado
      );
       RAISE NOTICE 'Contrato creado exitosamente para la productora % con el contrato número %', p_idProductora, p_nContrato;
    END IF;
  END IF;
END;
$$ LANGUAGE plpgsql;


-- funcion para renovar los contratos
CREATE OR REPLACE FUNCTION renovar_contrato(
  R_Subastadora NUMERIC,
  R_idProductora NUMERIC,
  R_nContrato NUMERIC,
  Nuevo_nContrato NUMERIC,
  fechaRenovacion DATE
) RETURNS VOID AS $$
DECLARE
   R_porcentajeProduccion NUMERIC(3,2);
    R_tipoProductor VARCHAR;
    R_fechaEmision DATE;
    R_fechaCancelacion DATE;
  BEGIN
    SELECT porcentajeProduccion, tipoProductor, fechaemision, cancelado
    INTO  R_porcentajeProduccion, R_tipoProductor, R_fechaEmision, R_fechaCancelacion
    FROM CONTRATO
    WHERE idSubastadora = R_Subastadora AND idProductora = R_idProductora AND nContrato = R_nContrato;

    IF R_fechaCancelacion IS NULL THEN
      IF fechaRenovacion <= R_fechaEmision + INTERVAL '1 year' THEN
        RAISE EXCEPTION 'La fecha de renovación debe ser al menos un año mayor a la fecha de emisión del contrato anterior';
      END IF;
    ELSE
      IF fechaRenovacion <= R_fechaCancelacion THEN
        RAISE EXCEPTION 'La fecha de renovación debe ser mayor a la fecha de cancelación del contrato anterior';
      END IF;
    END IF;

    INSERT INTO CONTRATO (
      idSubastadora, idProductora, nContrato, fechaemision, porcentajeProduccion, tipoProductor, idrenovS, idrenovP, ren_nContrato, cancelado
    ) VALUES (
      R_Subastadora, R_idProductora, Nuevo_nContrato, fechaRenovacion, R_porcentajeProduccion, R_tipoProductor, R_Subastadora, R_idProductora, R_nContrato, NULL
    );
  END;
$$ LANGUAGE plpgsql;

-- Function to cancel a contract
CREATE OR REPLACE FUNCTION cancelar_contrato(
  p_idSubastadora NUMERIC,
  p_idProductora NUMERIC,
  p_nContrato NUMERIC,
  p_fecha_cancelacion DATE
) RETURNS VOID AS $$
BEGIN
  UPDATE CONTRATO
  SET cancelado = p_fecha_cancelacion
  WHERE idSubastadora = p_idSubastadora 
    AND idProductora = p_idProductora 
    AND nContrato = p_nContrato;
END;
$$ LANGUAGE plpgsql;

-- Crear la función para verificar que solo se puede modificar el atributo cancelado cuando es NULL
CREATE OR REPLACE FUNCTION verificar_update_contrato() RETURNS TRIGGER AS $$
BEGIN
  IF (TG_OP = 'UPDATE') THEN
    IF NEW.cancelado IS NOT NULL AND OLD.cancelado IS NULL THEN
      RETURN NEW;
    ELSE
      RAISE EXCEPTION 'Solo se puede modificar el atributo cancelado y solo cuando este es NULL';
    END IF;
    IF NEW.cancelado IS NOT NULL AND NEW.cancelado <= OLD.fechaemision THEN
      RAISE EXCEPTION 'La fecha de cancelación debe ser posterior a la fecha de emisión del contrato';
    END IF;
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para verificar la actualización del contrato
CREATE TRIGGER verificar_update_contrato
BEFORE UPDATE ON CONTRATO
FOR EACH ROW
EXECUTE FUNCTION verificar_update_contrato();

--------------------------------------------------   Pagos  -------------------------------------------------------

-- Crear la función para pagar un contrato ( insert en Pago )
CREATE OR REPLACE FUNCTION Pago_contrato(
  Pago_idContratoSubastadora NUMERIC,
  Pago_idContratoProductora NUMERIC,
  Pago_idNContrato NUMERIC,
  Pago_fechaPago DATE
) RETURNS VOID AS $$
BEGIN
  -- Obtener la fecha de emisión del contrato
  IF Pago_fechaPago IS NULL THEN
    SELECT fechaemision INTO Pago_fechaPago
    FROM CONTRATO
    WHERE idSubastadora = idContratoSubastadora
      AND idProductora = idContratoProductora
      AND nContrato = idNContrato;
  END IF;
  
  -- Insertar el Pago en la tabla PAGOS
  INSERT INTO PAGOS (idContratoSubastadora, idContratoProductora, idNContrato, fechaPago, montoComision, tipo)
  VALUES (Pago_idContratoSubastadora, Pago_idContratoProductora, Pago_idNContrato, Pago_fechaPago, 500.00, 'membresia');
END;
$$ LANGUAGE plpgsql;

-- Trigger para pagar un contrato después de insertar un contrato
CREATE OR REPLACE FUNCTION Pago_contrato_nuevo() RETURNS TRIGGER AS $$
BEGIN
  PERFORM Pago_contrato(NEW.idSubastadora, NEW.idProductora, NEW.nContrato, NEW.fechaemision);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER Pago_contrato_nuevo
AFTER INSERT ON CONTRATO
FOR EACH ROW
EXECUTE FUNCTION Pago_contrato_nuevo();

-- Crear la función para verificar la fecha de Pago
CREATE OR REPLACE FUNCTION check_fecha_Pago() RETURNS TRIGGER AS $$
DECLARE
  ultima_fecha_Pago DATE;
BEGIN
  SELECT MAX(fechaPago) INTO ultima_fecha_Pago
  FROM PAGOS
  WHERE idContratoSubastadora = NEW.idContratoSubastadora
    AND idContratoProductora = NEW.idContratoProductora
    AND idNContrato = NEW.idNContrato;

  IF ultima_fecha_Pago IS NOT NULL AND NEW.fechaPago <= ultima_fecha_Pago THEN
    RAISE EXCEPTION 'La fecha de Pago debe ser mayor a la última fecha de Pago registrada';
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para verificar la fecha de Pago antes de insertar
CREATE TRIGGER check_fecha_Pago
BEFORE INSERT ON PAGOS
FOR EACH ROW
EXECUTE FUNCTION check_fecha_Pago();

-- Insertar datos de prueba en la tabla PAGOS con condición de que el tipo sea diferente a 'membresia'
-- Crear la función para insertar Pagos con la condición de que el tipo no sea 'membresia'
CREATE OR REPLACE FUNCTION insertar_Pago(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_fechaPago DATE,
  p_montoComision NUMERIC,
  p_tipo VARCHAR
) RETURNS VOID AS $$
BEGIN
  IF p_tipo <> 'membresia' THEN
    IF p_tipo = 'Pago' THEN
      -- Calcular el monto de la comisión según la función MontoComision
      IF p_montoComision <> MontoComision(p_idNContrato, p_fechaPago) THEN
        RAISE EXCEPTION 'El monto de la comisión no coincide con el monto calculado';
      END IF;
    END IF;
      
    --IF p_tipo = 'multa' THEN


    INSERT INTO PAGOS (idContratoSubastadora, idContratoProductora, idNContrato, fechaPago, montoComision, tipo)
    VALUES (p_idContratoSubastadora, p_idContratoProductora, p_idNContrato, p_fechaPago, p_montoComision, p_tipo);
  
  ELSE
    RAISE NOTICE 'El Pago de menbresia se hara al registrar el contrato, como parte de este';
  END IF;
END;
$$ LANGUAGE plpgsql;





-------------------------------------------------------------------------------------------------------------------
--  ===========================================================================================================  --
--  ======================================= Programas y Reportes  =============================================  --
--  ===========================================================================================================  --
-------------------------------------------------------------------------------------------------------------------



-- Crear la función para obtener el total de ventas en un periodo
CREATE OR REPLACE FUNCTION ventas_periodo(NumContrato NUMERIC, InicioPeriodo DATE, FinPeriodo DATE)
RETURNS NUMERIC AS $$
DECLARE
  total_ventas NUMERIC := 0;
BEGIN
  SELECT COALESCE(SUM(precioFinal), 0)
  INTO total_ventas
  FROM LOTE
  WHERE idCantidad_NContrato = NumContrato
  AND idFactura IN (
    SELECT facturaId 
    FROM FACTURA 
    WHERE fechaEmision BETWEEN InicioPeriodo AND FinPeriodo
  );
  RETURN total_ventas;
END;
$$ LANGUAGE plpgsql;


-- Crear la función para obtener el monto de la comisión
CREATE OR REPLACE FUNCTION MontoComision(NumContrato NUMERIC, FechaComision DATE)
RETURNS NUMERIC AS $$
DECLARE
  monto NUMERIC := 0;
  tipo VARCHAR(2);
  inicioMes DATE;
  FinMes DATE;
BEGIN
  inicioMes := date_trunc('month', FechaComision);
  FinMes := date_trunc('month', FechaComision) + INTERVAL '1 month' - INTERVAL '1 day';

  SELECT tipoProductor INTO tipo
    FROM CONTRATO
    WHERE nContrato = NumContrato;

  -- Calcular el monto de la comisión según el tipo de productor
    IF tipo = 'Ca' THEN
      monto := ventas_periodo(NumContrato, inicioMes, FinMes) * 0.005;
    ELSIF tipo = 'Cb' THEN
      monto := ventas_periodo(NumContrato, inicioMes, FinMes) * 0.01;
    ELSIF tipo = 'Cc' THEN
      monto := ventas_periodo(NumContrato, inicioMes, FinMes) * 0.02;
    ELSIF tipo = 'Cg' THEN
      monto := ventas_periodo(NumContrato, inicioMes, FinMes) * 0.05;
    ELSIF tipo = 'Ka' THEN
      monto := ventas_periodo(NumContrato, inicioMes, FinMes) * 0.0025;
    END IF;

  RETURN monto;
END;
$$ LANGUAGE plpgsql;


-- Crear la función para verificar la fecha de Pago dentro del período de validez del contrato
CREATE OR REPLACE FUNCTION verificar_fecha_Pago_validez() RETURNS TRIGGER AS $$
DECLARE
  fecha_emision DATE;
  fecha_cancelacion DATE;
BEGIN
  IF NEW.tipo <> 'membresia' THEN
    -- Obtener la fecha de emisión y la fecha de cancelación del contrato
    SELECT fechaemision, cancelado INTO fecha_emision, fecha_cancelacion
    FROM CONTRATO
    WHERE idSubastadora = NEW.idContratoSubastadora
      AND idProductora = NEW.idContratoProductora
      AND nContrato = NEW.idNContrato;

    -- Verificar que la fecha de Pago esté dentro del período de validez del contrato
    IF NEW.fechaPago <= fecha_emision THEN
      RAISE EXCEPTION 'La fecha de Pago debe ser mayor a la fecha de emisión del contrato';
    ELSIF fecha_cancelacion IS NOT NULL AND NEW.fechaPago >= fecha_cancelacion THEN
      RAISE EXCEPTION 'La fecha de Pago debe ser menor a la fecha de cancelación del contrato';
    ELSIF fecha_cancelacion IS NULL AND NEW.fechaPago >= fecha_emision + INTERVAL '1 year' THEN
      RAISE EXCEPTION 'La fecha de Pago debe ser menor a un año desde la fecha de emisión del contrato';
    END IF;
  END IF;

  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger para verificar la fecha de Pago antes de insertar en PAGOS
CREATE TRIGGER verificar_fecha_Pago_validez
BEFORE INSERT ON PAGOS
FOR EACH ROW
EXECUTE FUNCTION verificar_fecha_Pago_validez();

-- Crear la función para insertar un Pago
CREATE OR REPLACE FUNCTION insertar_Pago(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_fechaPago DATE,
  p_montoComision NUMERIC,
  p_tipo VARCHAR
) RETURNS VOID AS $$
BEGIN
  -- Verificar que el tipo de Pago no sea 'membresia'
  IF p_tipo <> 'membresia' THEN
    -- Insertar el Pago en la tabla PAGOS
    IF p_tipo = 'Pago' THEN
      IF p_montoComision <> MontoComision(p_idNContrato, p_fechaPago) THEN
        RAISE NOTICE 'El monto de la comisión no coincide con el monto calculado';
      END IF;
    END IF;
    INSERT INTO PAGOS (idContratoSubastadora, idContratoProductora, idNContrato, fechaPago, montoComision, tipo)
    VALUES (p_idContratoSubastadora, p_idContratoProductora, p_idNContrato, p_fechaPago, p_montoComision, p_tipo);
  ELSE
    RAISE NOTICE 'El Pago de membresía se realiza al registrar el contrato, como parte de este';
  END IF;
END;
$$ LANGUAGE plpgsql;

------------------------------------------------  multas  ---------------------------------------------------------


-- Crear la función para obtener el monto de la multa
CREATE OR REPLACE FUNCTION MontoMulta(NumContrato NUMERIC, Fechamulta DATE)
RETURNS NUMERIC AS $$
DECLARE
  monto NUMERIC := 0;
  tipo VARCHAR(2);
  inicioMes DATE;
  FinMes DATE;
BEGIN
  inicioMes := date_trunc('month', Fechamulta);
  FinMes := date_trunc('month', Fechamulta) + INTERVAL '1 month' - INTERVAL '1 day';
  monto := ventas_periodo(NumContrato, inicioMes, FinMes) * 0.2;
  RETURN monto;
END;
$$ LANGUAGE plpgsql;

-- FUNCTION: public.obtener_valoraciones_por_floristeria(numeric)

-- DROP FUNCTION IF EXISTS public.obtener_valoraciones_por_floristeria(numeric);

CREATE OR REPLACE FUNCTION obtener_valoraciones_por_floristeria(p_idfloristeria NUMERIC)
RETURNS TABLE (
  corteid NUMERIC,
  nombrecomun VARCHAR,
  valoracion_promedio NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    fc.corteId,
    fc.nombrecomun,
    ROUND(AVG(df.valoracionPromedio), 2) AS valoracion_promedio
  FROM CATALOGO_FLORISTERIA cf
  JOIN FLOR_CORTES fc ON cf.idCorteFlor = fc.corteId
  LEFT JOIN DETALLE_FACTURA df
    ON df.catalogoFloristeria = cf.idFloristeria AND df.catalogoCodigo = cf.codigo
  WHERE cf.idFloristeria = p_idFloristeria
  GROUP BY fc.corteId, fc.nombrecomun
  ORDER BY COALESCE(valoracion_promedio, 0) DESC, fc.nombrecomun ASC;
END;
$$ LANGUAGE plpgsql;



-- Crear la función para verificar Pagos y generar multas
CREATE OR REPLACE FUNCTION reporte_multas_generadas_y_pagadas(
  p_idSubastadora NUMERIC,
  p_idProductora NUMERIC,
  p_idContrato NUMERIC
)
RETURNS TABLE (
  mes DATE,
  multa_generada BOOLEAN,
  fecha_generacion_multa DATE,
  monto_multa NUMERIC,
  multa_pagada BOOLEAN,
  fecha_Pago_multa DATE
) AS $$
DECLARE
  contrato_inicio DATE;
  contrato_fin DATE;
  fecha_actual DATE := CURRENT_DATE;
  fecha_fin DATE;
  fecha_mes DATE := NULL;
  existe_Pago BOOLEAN := FALSE;
BEGIN
  -- Obtener la fecha de inicio del contrato
  SELECT fechaemision INTO contrato_inicio
  FROM CONTRATO
  WHERE idSubastadora = p_idSubastadora
    AND idProductora = p_idProductora
    AND nContrato = p_idContrato;

  -- Establecer fecha fin (un año desde inicio o fecha actual, lo que sea menor)
  contrato_fin := contrato_inicio + INTERVAL '1 year';
  fecha_fin := LEAST(contrato_fin, fecha_actual);
  fecha_mes := date_trunc('month', contrato_inicio);

  WHILE fecha_mes <= fecha_fin LOOP
    -- Verificar si existe un Pago de comisión en los primeros 5 días del mes
    SELECT EXISTS (
      SELECT 1
      FROM PAGOS
      WHERE idContratoSubastadora = p_idSubastadora
        AND idContratoProductora = p_idProductora
        AND idNContrato = p_idContrato
        AND tipo = 'Pago'
        AND date_trunc('month', fechaPago) = fecha_mes
        AND EXTRACT(DAY FROM fechaPago) <= 5
    ) INTO existe_Pago;

    IF NOT existe_Pago THEN
      -- Multa generada
      multa_generada := TRUE;
      fecha_generacion_multa := fecha_mes + INTERVAL '5 days';
      monto_multa := MontoMulta(p_idContrato, fecha_mes);
      multa_pagada := FALSE;
      fecha_Pago_multa := NULL;
      RAISE NOTICE 'Se generó una multa para el mes %.', fecha_mes::DATE;
    ELSE
      -- No hay multa
      multa_generada := FALSE;
      fecha_generacion_multa := NULL;
      monto_multa := 0;
      multa_pagada := FALSE;
      fecha_Pago_multa := NULL;

      -- Verificar si se pagó una multa en el mes actual
      SELECT EXISTS (
        SELECT 1
        FROM PAGOS
        WHERE idContratoSubastadora = p_idSubastadora
          AND idContratoProductora = p_idProductora
          AND idNContrato = p_idContrato
          AND tipo = 'multa'
          AND date_trunc('month', fechaPago) = fecha_mes
      ) INTO multa_pagada;

      IF multa_pagada THEN
        fecha_Pago_multa := (
          SELECT fechaPago
          FROM PAGOS
          WHERE idContratoSubastadora = p_idSubastadora
            AND idContratoProductora = p_idProductora
            AND idNContrato = p_idContrato
            AND tipo = 'multa'
            AND date_trunc('month', fechaPago) = fecha_mes
          LIMIT 1
        );
        monto_multa := MontoMulta(p_idContrato, fecha_mes);
        RAISE NOTICE 'Se pagó una multa en el mes %.', fecha_mes::DATE;
      END IF;
    END IF;

    -- Retornar los detalles
    mes := fecha_mes::DATE;
    RETURN NEXT;

    fecha_mes := fecha_mes + INTERVAL '1 month';
  END LOOP;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION insertar_factura(
  p_facturaId NUMERIC,
  p_idAfiliacionFloristeria NUMERIC,
  p_idAfiliacionSubastadora NUMERIC,
  p_fechaEmision TIMESTAMP,
  p_montoTotal NUMERIC,
  p_numeroEnvio NUMERIC
) RETURNS VOID AS $$
BEGIN
  IF p_fechaEmision > NOW() THEN
    RAISE EXCEPTION 'La fecha de emisión no puede ser mayor a la fecha y hora actual';
  END IF;

  IF p_fechaEmision::date = CURRENT_DATE THEN
    IF CURRENT_TIME < '15:00:00' THEN
      RAISE EXCEPTION 'Las subastas no han terminado';
    END IF;
  END IF;

  IF EXTRACT(ISODOW FROM p_fechaEmision) > 5 THEN
    RAISE EXCEPTION 'Las facturas no pueden ser emitidas en sábado o domingo';
  END IF;

  IF p_fechaEmision::time < '15:00:00' OR p_fechaEmision::time > '19:00:00' THEN
    RAISE EXCEPTION 'La hora de emisión debe estar entre las 15:00 y las 19:00 horas';
  END IF;

  INSERT INTO FACTURA (
    facturaId,
    idAfiliacionFloristeria,
    idAfiliacionSubastadora,
    fechaEmision,
    montoTotal,
    numeroEnvio
  ) VALUES (
    p_facturaId,
    p_idAfiliacionFloristeria,
    p_idAfiliacionSubastadora,
    p_fechaEmision,
    p_montoTotal,
    p_numeroEnvio
  );
END;
$$ LANGUAGE plpgsql;


--------------------------------------------- REPORTE: FACTURA ----------------------------------------------------

CREATE OR REPLACE FUNCTION obtener_facturas()
RETURNS TABLE (
  numero_factura NUMERIC,
  nombreSubastadora TEXT,
  nombre TEXT,
  fecha_emision_formateada TEXT,
  montoTotal NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    f.facturaId AS numero_factura,
    s.nombreSubastadora,
    fl.nombre::TEXT,
    TO_CHAR(f.fechaEmision, 'MM/DD/YYYY') AS fecha_emision_formateada,
    f.montoTotal
  FROM FACTURA f
  INNER JOIN SUBASTADORA s ON f.idAfiliacionSubastadora = s.subastadoraId
  INNER JOIN FLORISTERIAS fl ON f.idAfiliacionFloristeria = fl.floristeriaId
  ORDER BY f.fechaEmision DESC;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_informacion_factura(factura_id NUMERIC)
RETURNS TABLE (
    id_afiliacion_floristeria NUMERIC,
    id_afiliacion_subastadora NUMERIC,
    floristeria_info JSONB,
    subastadora_info JSONB,
    telefonos JSONB
) AS $$
DECLARE
    id_afiliacion_floristeria NUMERIC;
    id_afiliacion_subastadora NUMERIC;
    floristeria_info JSONB;
    subastadora_info JSONB;
    telefonos JSONB;
BEGIN
    -- Obtener la información de la factura
    SELECT 
        FACTURA.idAfiliacionFloristeria,
        FACTURA.idAfiliacionSubastadora
    INTO 
        id_afiliacion_floristeria,
        id_afiliacion_subastadora
    FROM FACTURA
    WHERE FACTURA.facturaId = factura_id;

    -- Obtener la información de la floristeria
    SELECT row_to_json(FLORISTERIAS) 
    INTO floristeria_info
    FROM FLORISTERIAS
    WHERE FLORISTERIAS.floristeriaId = id_afiliacion_floristeria;

    -- Obtener la información de la subastadora
    SELECT row_to_json(SUBASTADORA) 
    INTO subastadora_info
    FROM SUBASTADORA
    WHERE SUBASTADORA.subastadoraId = id_afiliacion_subastadora;

    -- Obtener los teléfonos relacionados con la floristeria y la subastadora
    SELECT json_agg(t) 
    INTO telefonos
    FROM TELEFONOS t
    WHERE t.idFloristeria = id_afiliacion_floristeria OR t.idSubastadora = id_afiliacion_subastadora;

    RETURN QUERY
    SELECT 
        id_afiliacion_floristeria,
        id_afiliacion_subastadora,
        floristeria_info,
        subastadora_info,
        telefonos;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION informacion_de_productores()
RETURNS TABLE (
  productoraid NUMERIC,
  nombreproductora VARCHAR,
  paginaweb VARCHAR,
  pais TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT p.productoraid, p.nombreproductora, p.paginaweb, pa.nombrepais AS pais
  FROM productoras p
  JOIN pais pa ON p.idpais = pa.paisid;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION CatalogoProductoraById(productorId NUMERIC)
RETURNS TABLE (
  corteid NUMERIC,
  nombrecomun VARCHAR,
  nombrepropio VARCHAR,
  vbn NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    fc.corteid,
    fc.nombrecomun, 
    cp.nombrepropio, 
    cp.vbn
  FROM flor_cortes fc
  INNER JOIN catalogoproductor cp ON fc.corteid = cp.idcorte
  INNER JOIN productoras p ON cp.idproductora = p.productoraid
  WHERE p.productoraid = productorId
  ORDER BY fc.nombrecomun;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Obtener_DetalleFlores(productorId NUMERIC, florId NUMERIC)
RETURNS TABLE (
  nombrepropio VARCHAR,
  descripcion VARCHAR,
  colores VARCHAR,
  etimologia VARCHAR,
  genero_especie VARCHAR,
  temperatura NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT
    cp.nombrepropio, 
    cp.descripcion,
    fc.colores, 
    fc.etimologia, 
    fc.genero_especie,
    fc.temperatura
  FROM catalogoproductor cp
  INNER JOIN flor_cortes fc ON cp.idcorte = fc.corteid
  WHERE cp.idproductora = productorId AND fc.corteid = florId;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_floristeria()
RETURNS TABLE (
  floristeriaId NUMERIC,
  nombre VARCHAR,
  email VARCHAR,
  paginaWeb VARCHAR,
  pais VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT f.floristeriaId, f.nombre, f.email, f.paginaWeb, p.nombrePais::VARCHAR AS pais
  FROM floristerias f
  JOIN pais p ON f.idPais = p.paisId;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION obtener_informacion_de_flor(p_idFloristeria NUMERIC, p_idCorteFlor NUMERIC)
RETURNS TABLE (
  nombrepropio VARCHAR,
  nombre_color VARCHAR,
  talloTamano NUMERIC,
  cantidad NUMERIC,
  precio NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  WITH FlorInformacion AS (
    SELECT
      cf.nombrepropio,
      c.Nombre AS nombre_color,
      db.talloTamano,
      db.cantidad,
      hp.precio
    FROM CATALOGO_FLORISTERIA cf
    INNER JOIN COLOR c ON cf.idColor = c.colorId
    INNER JOIN DETALLE_BOUQUET db ON cf.idFloristeria = db.idCatalogoFloristeria AND cf.codigo = db.idCatalogocodigo
    INNER JOIN HISTORICO_PRECIO_FLOR hp ON cf.idFloristeria = hp.idCatalogoFloristeria AND cf.codigo = hp.idCatalogocodigo
    WHERE cf.idFloristeria = p_idFloristeria AND cf.idcorteflor = p_idCorteFlor
    AND hp.fechaInicio = (
      SELECT MAX(fechaInicio)
      FROM HISTORICO_PRECIO_FLOR hp2
      WHERE hp2.idCatalogoFloristeria = hp.idCatalogoFloristeria
      AND hp2.idCatalogocodigo = hp.idCatalogocodigo
      AND hp2.fechaInicio <= CURRENT_DATE
      AND hp2.fechaFin IS NULL
    )
  )
  SELECT * FROM FlorInformacion;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Traer_lotes(p_facturaId NUMERIC)
RETURNS TABLE (
  idCantidadContratoSubastadora NUMERIC,
  idCantidadContratoProductora NUMERIC,
  idCantidad_NContrato NUMERIC,
  idCantidadCatalogoProductora NUMERIC,
  idCantidadCorte NUMERIC,
  idCantidadvnb NUMERIC,
  NumLote NUMERIC,
  bi NUMERIC,
  cantidad NUMERIC,
  precioInicial NUMERIC,
  precioFinal NUMERIC,
  idFactura NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    l.idCantidadContratoSubastadora,
    l.idCantidadContratoProductora,
    l.idCantidad_NContrato,
    l.idCantidadCatalogoProductora,
    l.idCantidadCorte,
    l.idCantidadvnb,
    l.NumLote,
    l.bi,
    l.cantidad,
    l.precioInicial,
    l.precioFinal,
    l.idFactura
  FROM LOTE l
  WHERE l.idFactura = p_facturaId;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION Paises_floristerias()
RETURNS TABLE (
  nombrePais TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT p.nombrePais
  FROM FLORISTERIAS f
  JOIN PAIS p ON f.idPais = p.paisId;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION Paises_productoras()
RETURNS TABLE (
  nombrePais TEXT
) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT p.nombrePais
  FROM PRODUCTORAS pr
  JOIN PAIS p ON pr.idPais = p.paisId;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION floristerias_con_factura()
RETURNS TABLE (
  floristeriaId NUMERIC,
  nombre VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT f.floristeriaId, f.nombre
  FROM FLORISTERIAS f
  JOIN FACTURA fa ON f.floristeriaId = fa.idAfiliacionFloristeria;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION subastadoras_con_factura()
RETURNS TABLE (
  subastadoraId NUMERIC,
  nombreSubastadora VARCHAR
) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT s.subastadoraId, s.nombreSubastadora
  FROM SUBASTADORA s
  JOIN FACTURA fa ON s.subastadoraId = fa.idAfiliacionSubastadora;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION facturas_afiliacion(
  p_idAfiliacionFloristeria NUMERIC DEFAULT NULL,
  p_idAfiliacionSubastadora NUMERIC DEFAULT NULL
) RETURNS TABLE (
  facturaId NUMERIC,
  idAfiliacionFloristeria NUMERIC,
  idAfiliacionSubastadora NUMERIC,
  fechaEmision TIMESTAMP,
  montoTotal NUMERIC,
  numeroEnvio NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    facturaId,
    idAfiliacionFloristeria,
    idAfiliacionSubastadora,
    fechaEmision,
    montoTotal,
    numeroEnvio
  FROM FACTURA
  WHERE (p_idAfiliacionFloristeria IS NULL OR idAfiliacionFloristeria = p_idAfiliacionFloristeria)
    AND (p_idAfiliacionSubastadora IS NULL OR idAfiliacionSubastadora = p_idAfiliacionSubastadora);
END;
$$ LANGUAGE plpgsql;

/* FUNCIONES HECHAS POR GABO */ 

CREATE OR REPLACE FUNCTION obtener_flor_cortes()
RETURNS TABLE (
  corteId NUMERIC,
  nombreComun VARCHAR,
  Descripcion VARCHAR,
  genero_especie VARCHAR,
  etimologia VARCHAR,
  colores VARCHAR,
  temperatura NUMERIC
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    fc.corteId,
    fc.nombreComun,
    fc.Descripcion,
    fc.genero_especie,
    fc.etimologia,
    fc.colores,
    fc.temperatura
  FROM FLOR_CORTES fc;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION obtener_contratos_productora(
    p_productora_id NUMERIC
)
RETURNS TABLE (
    idSubastadora NUMERIC,
    idProductora NUMERIC,
    nContrato NUMERIC,
    fechaEmision DATE,
    porcentajeProduccion NUMERIC(3,2),
    tipoProductor VARCHAR,
    fechaRenovacion DATE,
    fechaCancelacion DATE,
    esActivo BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.idSubastadora,
        c.idProductora,
        c.nContrato,
        c.fechaEmision,
        c.porcentajeProduccion,
        c.tipoProductor,
        CASE 
            WHEN c.idrenovS IS NOT NULL AND c.idrenovS::VARCHAR LIKE '[0-9][0-9][0-9][0-9]' THEN TO_DATE(c.idrenovS::VARCHAR, 'YYYYMMDD')
            ELSE NULL
        END AS fechaRenovacion,
        CASE 
            WHEN c.cancelado IS NOT NULL AND c.cancelado::VARCHAR LIKE '[0-9][0-9][0-9][0-9]' THEN TO_DATE(c.cancelado::VARCHAR, 'YYYYMMDD')
            ELSE NULL
        END AS fechaCancelacion,
        CASE 
            WHEN c.cancelado IS NOT NULL THEN FALSE
            ELSE TRUE
        END AS esActivo
    FROM 
        contrato c
    WHERE 
        c.idProductora = p_productora_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION match_flowers(p_floristeria_id INTEGER, p_ocasion VARCHAR, p_emocion VARCHAR)
RETURNS TABLE (
    idFloristeria INTEGER,
    nombre_comun VARCHAR,
    color VARCHAR,
    significado VARCHAR,
    precio NUMERIC,
    desc_color VARCHAR,
    desc_enlace VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        cf.idFloristeria::INTEGER,
        fc.nombreComun,
        c.Nombre AS color,
        s.Descripcion AS significado,
        hpf.precio,
        c.descripcion AS desc_color,
        e.descripcion AS desc_enlace
    FROM 
        CATALOGO_FLORISTERIA cf
    JOIN 
        FLOR_CORTES fc ON cf.idCorteFlor = fc.corteId
    JOIN 
        COLOR c ON cf.idColor = c.colorId
    LEFT JOIN 
        ENLACES e ON c.colorId = e.idColor
    JOIN 
        SIGNIFICADO s ON e.IdSignificado = s.SignificadoId
    JOIN 
        HISTORICO_PRECIO_FLOR hpf ON cf.idFloristeria = hpf.idCatalogoFloristeria AND cf.codigo = hpf.idCatalogocodigo
    WHERE 
        cf.idFloristeria = p_floristeria_id
        AND (REGEXP_LIKE(s.Descripcion, p_ocasion, 'i')
            OR REGEXP_LIKE(e.Descripcion, p_emocion, 'i')
            OR REGEXP_LIKE(c.descripcion, p_ocasion, 'i')
            OR REGEXP_LIKE(c.descripcion, p_emocion, 'i')
            OR REGEXP_LIKE(e.descripcion, p_ocasion, 'i')
            OR REGEXP_LIKE(e.descripcion, p_emocion, 'i'));
END;
$$ LANGUAGE plpgsql;

-------------------------------------------------------------------------------------------------------------------
--  ===========================================================================================================  --
--  ======================================== Inserts y consultas ==============================================  --
--  ===========================================================================================================  --
-------------------------------------------------------------------------------------------------------------------

-- insert into pais
INSERT INTO PAIS (nombrePais, continente) VALUES ('Venezuela', 'Am');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Holanda', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Alemania', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Brasil', 'Am');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Dinamarca', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Polonia', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('España', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Colombia', 'Am');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Ecuador', 'Am');

SELECT * FROM PAIS;


-- Obtener el paisId de Holanda
SELECT paisId FROM PAIS WHERE nombrePais = 'Holanda';
-- Supongamos que el paisId de Holanda es 2

-- Insertar las subastadoras
INSERT INTO SUBASTADORA (nombreSubastadora, idPais) VALUES 
('Royal Flora Holland', 2),
('Plantion', 2),
('Dutch Flower Group', 2);

SELECT * FROM SUBASTADORA;


-- Obtener el paisId de Holanda (se repite porque es para las productoras)
SELECT paisId FROM PAIS WHERE nombrePais = 'Holanda';
-- Supongamos que el paisId de Holanda es 2

-- insertar las productoras 
INSERT INTO PRODUCTORAS (nombreProductora, paginaWeb, idPais) VALUES 
('Anthura', 'anthura.nl', 2),
('Van den bos', 'www.vandenbos.com', 2),
('Hilverda florist', 'www.hilverdaflorist.com', 2);

SELECT * FROM PRODUCTORAS;


-- Obtener el paisId de cada país
SELECT paisId FROM PAIS WHERE nombrePais = 'Alemania';
SELECT paisId FROM PAIS WHERE nombrePais = 'Brasil';
SELECT paisId FROM PAIS WHERE nombrePais = 'Polonia';
SELECT paisId FROM PAIS WHERE nombrePais = 'España'; -- Asumiendo que Herbs Barcelona es de España
SELECT paisId FROM PAIS WHERE nombrePais = 'Venezuela';
SELECT paisId FROM PAIS WHERE nombrePais = 'Dinamarca';

-- Supongamos que los paisId son los siguientes:
-- Alemania: 3
-- Brasil: 4
-- Polonia: 6
-- España: 7
-- Venezuela: 1
-- Dinamarca: 5

-- Insertar las floristerías
INSERT INTO FLORISTERIAS (nombre, email, paginaWeb, idPais) VALUES 
('FloraPrima', 'einkauf-nf@floraprima.de', 'www.floraprima.de', 3),
('Flowers for Brazil', 'example@gmail.com', 'www.flower4brazil.com', 4),
('Blooming', 'info@bloomingcopenhagen.dk', 'www.bloomingcopenhagen.dk', 5),
('Poczta kwiatowa', 'biuro@kwiatowaprzesylka.pl', 'www.kwiatowaprzesylka.pl', 6),
('Herbs Barcelona', 'info@herbs.es', 'www.herbs.es', 7),
('Toscana Flores', 'contacto@toscanaflores.com', 'toscanaflores.com', 1);

select * from FLORISTERIAS;


-- Insertar datos de prueba en CLIENTE_NATURAL
INSERT INTO CLIENTE_NATURAL (documentoIdentidad, primernombre, primerApellido, segundoApellido, segundonombre) VALUES 
(12345678, 'Juan', 'Pérez', 'García', 'Carlos'),
(87654321, 'María', 'López', 'Martínez', 'Isabel'),
(11223344, 'Carlos', 'Hernández', 'Sánchez', 'Ricardo'),
(44332211, 'Ana', 'Gómez', 'Fernández', NULL),
(55667788, 'Luis', 'Díaz', 'Torres', 'Eduardo'),
(33445566, 'Pedro', 'Ramírez', 'González', 'Antonio'),
(99887766, 'Lucía', 'Fernández', 'Pérez', 'María'),
(55664433, 'Miguel', 'Torres', 'López', 'Ángel'),
(22334455, 'Sofía', 'Martínez', 'Rodríguez', 'Elena');

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM CLIENTE_NATURAL;


-- Insertar datos de prueba en CLIENTE_JURIDICO
INSERT INTO CLIENTE_JURIDICO (RIF, nombre) VALUES 
(123456789, 'Eventos Elegantes'),
(987654321, 'Bodas y Más'),
(112233445, 'Fiestas Fantásticas'),
(554433221, 'Celebraciones Únicas'),
(667788990, 'Eventos de Ensueño'),
(223344556, 'Coordinadores de Bodas'),
(334455667, 'Fiestas y Eventos'),
(445566778, 'Eventos Especiales'),
(556677889, 'Organización de Eventos');

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM CLIENTE_JURIDICO;


-- Insertar datos de prueba en FLOR_CORTES
INSERT INTO FLOR_CORTES (nombreComun, Descripcion, genero_especie, etimologia, colores, temperatura) VALUES 
('Rosa', 'Flor ornamental popular', 'Rosa gallica', 'De la palabra latina "rosa"', 'Rojo, Blanco, Amarillo, Rosa', 18),
('Tulipán', 'Flor bulbosa de primavera', 'Tulipa gesneriana', 'Del turco "tülbend" que significa turbante', 'Rojo, Amarillo, Púrpura, Blanco', 15),
('Orquídea', 'Flor exótica y diversa', 'Orchidaceae', 'Del griego "orchis" que significa testículo', 'Púrpura, Blanco, Rosa, Amarillo', 20),
('Girasol', 'Flor alta que sigue al sol', 'Helianthus annuus', 'Del griego "helios" que significa sol y "anthos" que significa flor', 'Amarillo', 25),
('Lirio', 'Flor elegante y fragante', 'Lilium', 'Del griego "leirion"', 'Blanco, Rosa, Amarillo, Naranja', 22),
('Clavel', 'Flor popular en ramos y arreglos', 'Dianthus caryophyllus', 'Del griego "dios" que significa dios y "anthos" que significa flor', 'Rojo, Blanco, Rosa, Amarillo', 18),
('Margarita', 'Flor sencilla y alegre', 'Bellis perennis', 'Del latín "bellus" que significa hermoso', 'Blanco, Amarillo', 15),
('Hortensia', 'Flor ornamental en racimos', 'Hydrangea macrophylla', 'Del griego "hydor" que significa agua y "angos" que significa jarra', 'Rosa, Azul, Blanco', 20),
('Peonía', 'Flor grande y fragante', 'Paeonia lactiflora', 'Del griego "paionia" que significa curación', 'Rosa, Blanco, Rojo', 22);

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM FLOR_CORTES;


-- Insertar datos de prueba en SIGNIFICADO
INSERT INTO SIGNIFICADO (Tipo, Descripcion) VALUES 
('Oc', 'Boda'),
('Se', 'Amor'),
('Oc', 'Cumpleaños'),
('Se', 'Felicidad'),
('Oc', 'Aniversario'),
('Se', 'Tristeza'),
('Oc', 'Graduación'),
('Se', 'Amistad'),
('Oc', 'Nacimiento'),
('Se', 'Perdón'),
('Oc', 'Despedida'),
('Se', 'Agradecimiento'),
('Oc', 'San Valentín'),
('Se', 'Alegría'),
('Oc', 'Funeral'),
('Se', 'Paz'),
('Oc', 'Despedida'),
('Se', 'Perdón'),
('Oc', 'San Valentín'),
('Se', 'Alegría'),
('Oc', 'Funeral'),
('Oc', 'Navidad'),
('Se', 'Esperanza'),
('Oc', 'Año Nuevo'),
('Se', 'Compasión'),
('Oc', 'Día de la Madre'),
('Se', 'Gratitud'),
('Oc', 'Día del Padre'),
('Se', 'Inspiración'),
('Oc', 'Día del Niño'),
('Se', 'Confianza'),
('Oc', 'Día de la Mujer'),
('Se', 'Respeto'),
('Oc', 'Día del Maestro'),
('Se', 'Admiración'),
('Oc', 'Día del Amigo'),
('Se', 'Lealtad'),
('Oc', 'Día del Trabajo'),
('Se', 'Solidaridad'),
('Oc', 'Día de la Independencia'),('Se', 'Orgullo');

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM SIGNIFICADO;


-- Insertar datos de prueba en COLOR
INSERT INTO COLOR (Nombre, Descripcion) VALUES 
('Blanco', 'Las flores blancas son magníficas, únicas, y no tradicionales. Son perfectas para una nueva relación o para decir a tu pareja lo perfecta que es para ti. También son las flores para expresar la pureza de tu amor. Buenas ideas son rosas u orquídeas blancas.'),
('Rojo', 'El rojo es el color tradicional del amor y del romance. Una docena de rosas rojas es el clásico regalo romántico.'),
('Blanco y Rojo', 'Las flores rojas y blancas son una combinación llamativa y que encarnan todos los sentimientos y emociones de un verdadero vínculo.'),
('Rosado', 'Es el color femenino por excelencia. Las rosas rosadas son perfectas como regalo romántico, y representan la ingenuidad, bondad, ternura, buen sentimiento y ausencia de todo mal.'),
('Amarillo', 'Si quieres hacer las cosas más lentas es el color a enviar, el amarillo es el color de la amistad. Irradia siempre en todas partes y sobre toda las cosas, es el color de la luz.'),
('Amarillo y Rojo', 'El amarillo simboliza su amistad actual y el rojo indica que deseas avanzar hacia una nueva relación.'),
('Naranja', 'El naranja es un color fuerte, cálido que muestra la fascinación o intriga.'),
('Melocotón', 'El Melocotón es un tono de naranja y rosa que representan a la vez el romanticismo de las rosas y el calor y la gratitud del anaranjado. Se trata de un color perfecto para mostrar amor y reconocimiento.'),
('Verde', 'El verde es un color rico y fresco, perfecto para la pareja armoniosa. Es el color de la esperanza. Y puede expresar: naturaleza, juventud, deseo, descanso, equilibrio.'),
('Azul', 'El Azul es el color de la paz y la estabilidad. Es fresco y relajante. Es el color del cielo y del mar. Es un color reservado y que parece que se aleja. Puede expresar confianza, reserva, armonía, afecto, amistad, fidelidad y amor.'),
('Violeta', 'Es el color que indica ausencia de tensión. A menudo se le asocia con la nobleza, es un color perfecto para un amor de mucho tiempo.');

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM COLOR;


-- Insertar datos de prueba en ENLACES
INSERT INTO ENLACES (IdSignificado,Descripcion, IdColor, idCorte) VALUES 
(1, 'rosas rojas es el clásico regalo romántico', 2, 2),
(2, 'La rosa blanca es un símbolo de pureza, inocencia y amor puro', 2, 1),
(3, 'Las flores de cumpleaños son una forma especial de celebrar', 4, 3),
(4, 'Las flores de felicidad traen alegría y buenos deseos', 5, 4),
(5, 'Las flores de aniversario simbolizan el amor duradero', 6, 5),
(6, 'Las flores de tristeza expresan condolencias y apoyo', 7, 6),
(7, 'Las flores de graduación celebran logros y nuevos comienzos', 8, 7),
(8, 'Las flores de amistad fortalecen los lazos entre amigos', 9, 8),
(9, 'Las flores de nacimiento dan la bienvenida a un nuevo bebé', 10, 9);

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM ENLACES;


-- Insertar datos de prueba en CATALOGOPRODUCTOR
INSERT INTO CATALOGOPRODUCTOR (idProductora, idCorte, vbn, nombrepropio, descripcion) VALUES 
(1, 1, 1, 'Rosas', NULL),
(2, 2, 2, 'Tulipanes', 'Tulipanes amarillos brillantes'),
(3, 3, 3, 'Orquídeas', 'Orquídeas exóticas y elegantes'),
(1, 4, 4, 'Girasoles', 'Girasoles altos que siguen al sol'),
(2, 5, 5, 'Lirios', 'Lirios blancos elegantes y fragantes'),
(3, 6, 6, 'Claveles', 'Claveles populares en ramos y arreglos'),
(1, 7, 7, 'Margaritas', 'Margaritas sencillas y alegres'),
(2, 8, 8, 'Hortensias', 'Hortensias ornamentales en racimos'),
(3, 9, 9, 'Peonías', 'Peonías grandes y fragantes');

-- Verificar los datos insertados
SELECT * FROM CATALOGOPRODUCTOR;


-- Insertar datos de prueba en la tabla CONTRATO
SELECT crear_nuevo_contrato(1, 1, 1001, '2021-01-01', 0.60, 'Ca', NULL, NULL, NULL, NULL);
SELECT crear_nuevo_contrato(2, 2, 1002, '2021-02-01', 0.25, 'Cb', NULL, NULL, NULL, NULL);
SELECT crear_nuevo_contrato(3, 3, 1003, '2021-03-01', 0.15, 'Cc', NULL, NULL, NULL, NULL);

-- Cancelar todos los contratos, la fecha de cancelación es 3 días después de la fecha de emisión
UPDATE CONTRATO
SET cancelado = fechaemision + INTERVAL '6 months'
WHERE nContrato IN (1001, 1002, 1003);

-- Insertar nuevos contratos en la tabla CONTRATO
SELECT crear_nuevo_contrato(1, 1, 1004, '2022-01-01', 0.55, 'Ca', NULL, NULL, NULL, NULL);
SELECT crear_nuevo_contrato(2, 2, 1005, '2022-05-01', 0.30, 'Cb', NULL, NULL, NULL, NULL);
SELECT crear_nuevo_contrato(3, 3, 1006, '2022-06-01', 0.10, 'Cc', NULL, NULL, NULL, NULL);

SELECT renovar_contrato(1, 1, 1004, 1007, '2023-01-02');
SELECT renovar_contrato(2, 2, 1005, 1008, '2023-05-02');
SELECT renovar_contrato(3, 3, 1006, 1009, '2023-06-02');

-- Verificar los datos insertados
SELECT * FROM CONTRATO;

-- Insertar datos de prueba en la tabla CANTIDAD_OFRECIDA
INSERT INTO CANTIDAD_OFRECIDA (idContratoSubastadora, idContratoProductora, idNContrato, idCatalogoProductora,idCatalogoCorte, idVnb, cantidad) VALUES
(1, 1, 1001, 1, 1, 1, 100),
(2, 2, 1002, 2, 2, 2, 200),
(3, 3, 1003, 3, 3, 3 ,300),
(1, 1, 1004, 1, 1, 1, 150),
(2, 2, 1005, 2, 2, 2, 250),
(3, 3, 1006, 3, 3, 3, 350),
(1, 1, 1007, 1, 4, 4, 200),
(2, 2, 1008, 2, 5, 5, 300),
(3, 3, 1009, 3, 6, 6, 400),
(1, 1, 1004, 1, 7, 7, 180),
(2, 2, 1005, 2, 8, 8, 280),
(3, 3, 1006, 3, 9, 9, 380);
-- Verificar los datos insertados
SELECT * FROM CANTIDAD_OFRECIDA;


-- Insertar datos de prueba en la tabla CONTACTOS

INSERT INTO CONTACTOS (idFloristeria, contactoId, documentoIdentidad, primerNombre, primerApellido, segundoApellido, segundoNombre) VALUES 
(1, 5, 667788990, 'Charlie', 'Black', 'Taylor', 'James'),
(2, 4, 554433221, 'Bob', 'White', 'Jones', 'David'),
(3, 1, 123456789, 'John', 'Doe', 'Smith', 'Michael'),
(4, 2, 987654321, 'Jane', 'Doe', 'Johnson', 'Emily'),
(1, 6, 112233445, 'Alice', 'Brown', 'Williams', 'Sophia'),
(2, 5, 998877665, 'Eve', 'Green', 'Davis', 'Olivia'),
(3, 2, 443322110, 'Frank', 'Blue', 'Miller', 'Daniel'),
(4, 3, 556677889, 'Grace', 'Yellow', 'Wilson', 'Emma'),
(1, 7, 334455667, 'Hank', 'Purple', 'Moore', 'Liam');

-- Verificar los datos insertados
SELECT * FROM CONTACTOS;

-- Insertar datos de prueba en la tabla AFILIACION
INSERT INTO AFILIACION (idFloristeria, idSubastadora) VALUES 
(1, 1),
(2, 2),
(3, 3),
(4, 1),
(5, 2),
(6, 3),
(1, 2),
(2, 3),
(3, 1);

-- Verificar los datos insertados
SELECT * FROM AFILIACION;


-- Insertar datos de prueba en la tabla FACTURA
INSERT INTO FACTURA (idAfiliacionFloristeria, idAfiliacionSubastadora, fechaEmision, montoTotal, numeroEnvio) VALUES
(1, 1, '2023-04-10 16:00:00', 10010.00, 3262),
(1, 1, '2023-05-10 16:00:00', 10040.00, 3263),
(2, 2, '2023-05-01 16:00:00', 75000, 12346),
(1, 1, '2023-06-10 16:00:00', 10025.00, 3264),
(2, 3, '2023-06-04 16:00:00', 74000, 121237),
(3, 3, '2023-06-01 16:00:00', 1000.00, 12347),
(1, 1, '2023-07-10 16:00:00', 10035.00, 3265),
(2, 2, '2023-07-08 16:00:00', 75300, 123476),
(3, 3, '2023-07-11 16:00:00', 900.00, 12134),
(4, 1, '2023-07-01 16:00:00', 1250.70, 22348),
(1, 1, '2023-08-10 16:00:00', 10015.00, 3266),
(2, 3, '2023-08-11 16:00:00', 72500, 12546),
(3, 1, '2023-08-01 16:00:00', 1100.00, 12347),
(4, 1, '2023-08-01 16:00:00', 1239.00, 22349),
(5, 2, '2023-08-01 16:00:00', 500.00, 69349),
(6, 3, '2023-08-01 16:00:00', 1750.00, 42349),
(1, 1, '2023-09-10 16:00:00', 10045.00, 3267),
(2, 2, '2023-09-05 16:00:00', 80000, 12333),
(3, 3, '2023-09-11 16:00:00', 980.00, 12567),
(4, 1, '2023-09-01 16:00:00', 1250.50, 22350),
(5, 2, '2023-09-01 16:00:00', 900.00, 69350),
(6, 3, '2023-09-01 16:00:00', 1750.00, 42350),
(1, 1, '2023-10-10 16:00:00', 10050.00, 3268),
(1, 2, '2023-10-01 16:00:00', 2000.00, 12351),
(2, 3, '2023-10-03 16:00:00', 7200, 12556),
(3, 1, '2023-10-11 16:00:00', 1090.00, 12447),
(4, 1, '2023-10-01 16:00:00', 1245.30, 22351),
(5, 2, '2023-10-01 16:00:00', 15000.00, 69351),
(6, 3, '2023-10-01 16:00:00', 1750.00, 42351),
(1, 1, '2023-11-10 16:00:00', 10020.00, 3269),
(2, 2, '2023-11-01 16:00:00', 90000, 15246),
(3, 3, '2023-11-15 16:00:00', 800.00, 12347),
(4, 1, '2023-11-01 16:00:00', 1250.90, 22352),
(5, 2, '2023-11-01 16:00:00', 700.00, 69352),
(6, 3, '2023-11-01 16:00:00', 1750.00, 42352),
(1, 1, '2023-12-10 16:00:00', 10030.00, 3270),
(2, 2, '2023-12-09 16:00:00', 65000, 9246),
(3, 3, '2023-12-01 16:00:00', 1300.00, 12350),
(4, 1, '2023-12-01 16:00:00', 1248.20, 22353),
(5, 2, '2023-12-01 16:00:00', 750.00, 69353),
(6, 3, '2023-12-01 16:00:00', 1750.00, 42353),
(1, 1, '2024-01-20 16:00:00', 10010.00, 3271),
(2, 3, '2024-01-04 16:00:00', 7900, 19846),
(3, 1, '2024-01-01 16:00:00', 1600.00, 12353),
(4, 1, '2024-01-01 16:00:00', 1250.10, 22354),
(5, 2, '2024-01-01 16:00:00', 1200.00, 69354),
(6, 3, '2024-01-01 16:00:00', 1750.00, 42354),
(1, 1, '2024-02-20 16:00:00', 13010.00, 3272),
(2, 2, '2024-02-03 16:00:00', 7500, 123131),
(3, 1, '2024-02-01 16:00:00', 1400.00, 12351),
(4, 1, '2024-02-01 16:00:00', 1249.80, 22355),
(5, 2, '2024-02-01 16:00:00', 800.00, 69355),
(6, 3, '2024-02-01 16:00:00', 1750.00, 42355),
(1, 1, '2024-03-02 16:00:00', 19010.00, 3273),
(2, 3, '2024-03-07 16:00:00', 9500, 92546),
(3, 3, '2024-03-01 16:00:00', 1500.00, 12352),
(4, 1, '2024-03-01 16:00:00', 1250.60, 22356),
(5, 2, '2024-03-01 16:00:00', 350.00, 69356),
(6, 3, '2024-03-01 16:00:00', 1750.00, 412356),
(1, 1, '2024-04-10 16:00:00', 13010.00, 327423423),
(2, 3, '2024-04-08 16:00:00', 7520, 12372),
(3, 3, '2024-04-01 16:00:00', 1700.00, 12354),
(4, 1, '2024-04-01 16:00:00', 1247.40, 22357),
(5, 2, '2024-04-01 16:00:00', 900.00, 69357),
(6, 3, '2024-04-01 16:00:00', 1750.00, 42357),
(1, 1, '2024-05-26 16:00:00', 13010.00, 3271234234),
(2, 3, '2024-05-07 16:00:00', 7190, 12982),
(3, 1, '2024-05-01 16:00:00', 1800.00, 12355),
(4, 1, '2024-05-01 16:00:00', 1250.30, 22358),
(5, 2, '2024-05-01 16:00:00', 1500.00, 69358),
(6, 3, '2024-05-01 16:00:00', 1750.00, 42358),
(1, 1, '2024-06-19 16:00:00', 8000.00, 3271545),
(2, 2, '2024-06-09 16:00:00', 7550, 132146),
(3, 3, '2024-06-01 16:00:00', 1900.00, 12356),
(4, 1, '2024-06-01 16:00:00', 1246.50, 22359),
(5, 2, '2024-06-01 16:00:00', 400.00, 69359),
(6, 3, '2024-06-01 16:00:00', 1750.00, 42359),
(1, 1, '2024-07-14 16:00:00', 13010.00, 327142),
(2, 3, '2024-07-12 16:00:00', 6400, 121346),
(3, 1, '2024-07-01 16:00:00', 2000.00, 12357),
(4, 1, '2024-07-01 16:00:00', 1250.20, 22360),
(5, 2, '2024-07-01 16:00:00', 1100.00, 69360),
(6, 3, '2024-07-01 16:00:00', 1750.00, 42360),
(1, 1, '2024-08-12 16:00:00', 7010.00, 3271243),
(2, 2, '2024-08-15 16:00:00', 7580, 123216),
(3, 3, '2024-08-01 16:00:00', 2100.00, 12358),
(4, 1, '2024-08-01 16:00:00', 1249.70, 22361),
(5, 2, '2024-08-01 16:00:00', 600.00, 69361),
(6, 3, '2024-08-01 16:00:00', 1750.00, 42361),
(1, 1, '2024-09-04 16:00:00', 10310.00, 3271123),
(2, 3, '2024-09-02 16:00:00', 7520, 23216),
(3, 1, '2024-09-01 16:00:00', 2200.00, 12359),
(4, 1, '2024-09-01 16:00:00', 1250.40, 22362),
(5, 2, '2024-09-01 16:00:00', 320.00, 69362),
(6, 3, '2024-09-01 16:00:00', 1750.00, 42362),
(1, 1, '2024-10-08 16:00:00', 13090.00, 32715464),
(2, 2, '2024-10-09 16:00:00', 7450, 56346),
(3, 3, '2024-10-01 16:00:00', 2300.00, 12360),
(4, 1, '2024-10-01 16:00:00', 1248.90, 22363),
(5, 2, '2024-10-01 16:00:00', 1400.00, 69363),
(6, 3, '2024-10-01 16:00:00', 1750.00, 42363),
(1, 1, '2024-11-03 16:00:00', 14010.00, 32715464),
(2, 3, '20234-11-04 16:00:00', 7531.00, 43346),
(3, 1, '2024-11-01 16:00:00', 2400.00, 12361),
(4, 1, '2024-11-01 16:00:00', 1250.80, 22364),
(5, 2, '2024-11-01 16:00:00', 100.00, 69364),
(6, 3, '2024-11-01 16:00:00', 1750.00, 42364),
(6, 3, '2024-12-01 16:00:00', 1750.00, 42365),
(1, 1, '2024-12-09 16:00:00', 15010.00, 32715464),
(2, 2, '2024-12-08 16:00:00', 8000, 442432),
(3, 3, '2024-12-01 16:00:00', 2500.00, 12362),
(4, 1, '2024-12-01 16:00:00', 1247.60, 22365),
(5, 2, '2024-12-01 16:00:00', 270.00, 69365),
(5, 2, '2025-01-01 16:00:00', 13000.00, 69366),
(4, 1, '2025-01-02 16:00:00', 1250.00, 22366);

-- Verificar los datos insertados
SELECT * FROM FACTURA;


SELECT MontoComision( 1001, '2021-01-10');

-- Insertar datos de prueba en la tabla PAGOS 

-- contrato(1, 1, 1001) comienza  '2021-01-01' cancelado 6 meses despues 
SELECT insertar_Pago(1, 1, 1001, '2021-02-10', 50.00, 'Pago');
SELECT insertar_Pago(1, 1, 1001, '2021-03-03', 220.00, 'multa');
SELECT insertar_Pago(1, 1, 1001, '2021-03-15', 5.5, 'Pago');


-- Verificar los datos insertados
SELECT * FROM PAGOS;

-- Insertar datos de prueba en la tabla LOTE
INSERT INTO LOTE (idCantidadContratoSubastadora, idCantidadContratoProductora, idCantidad_NContrato, idCantidadCatalogoProductora, idCantidadCorte, idCantidadvnb, NumLote, bi, cantidad, precioInicial, precioFinal, idFactura) VALUES
(1, 1, 1001, 1, 1, 1, 1, 1, 50, 10.00, 15.00, 1),
(2, 2, 1002, 2, 2, 2, 2, 2, 100, 20.00, 25.00, 2),
(3, 3, 1003, 3, 3, 3, 3, 3, 150, 30.00, 35.00, 3),
(1, 1, 1004, 1, 1, 1, 4, 1, 60, 12.00, 18.00, 1),
(2, 2, 1005, 2, 2, 2, 5, 2, 120, 22.00, 28.00, 2),
(3, 3, 1006, 3, 3, 3, 6, 3, 180, 32.00, 38.00, 3),
(2, 2, 1008, 2, 5, 5, 8, 5, 140, 24.00, 30.00, 2),
(3, 3, 1009, 3, 6, 6, 9, 6, 210, 34.00, 40.00, 3),
(1, 1, 1004, 1, 7, 7, 10, 7, 80, 16.00, 22.00, 1),
(2, 2, 1005, 2, 8, 8, 11, 8, 160, 26.00, 32.00, 2),
(3, 3, 1006, 3, 9, 9, 12, 9, 240, 36.00, 42.00, 3);

-- Verificar los datos insertados
SELECT * FROM LOTE;


-- Insertar datos de prueba en la tabla CATALOGO_FLORISTERIA
INSERT INTO CATALOGO_FLORISTERIA (idFloristeria, codigo, idCorteFlor, idColor, nombrePropio, descripcion) VALUES
(1, 1, 1, 2, 'Rosa Roja', 'Rosa roja clásica para ocasiones románticas'),
(1, 7, 7, 1, 'Margarita Blanca', 'Margarita sencilla y alegre en color blanco'),
(1, 2, 2, 3, 'Tulipán Amarillo', 'Tulipán amarillo brillante para alegrar el día'),
(1, 8, 8, 10, 'Hortensia Azul', 'Hortensia ornamental en racimos de color azul'),
(1, 3, 3, 11, 'Orquídea Púrpura', 'Orquídea exótica y elegante en color púrpura'),
(1, 4, 4, 5, 'Girasol', 'Girasol alto y brillante que sigue al sol'),
(1, 9, 9, 4, 'Peonía Rosa', 'Peonía grande y fragante en color rosa'),
(1, 5, 5, 1, 'Lirio Blanco', 'Lirio blanco elegante y fragante para cualquier ocasión'),
(1, 6, 6, 2, 'Clavel Rojo', 'Clavel rojo popular en ramos y arreglos'),
(2, 2, 2, 3, 'Tulipán Amarillo', 'Tulipán amarillo brillante para alegrar el día'),
(3, 3, 3, 11, 'Orquídea Púrpura', 'Orquídea exótica y elegante en color púrpura'),
(4, 4, 4, 5, 'Girasol', 'Girasol alto y brillante que sigue al sol'),
(6, 6, 6, 2, 'Clavel Rojo', 'Clavel rojo popular en ramos y arreglos'),
(2, 8, 8, 10, 'Hortensia Azul', 'Hortensia ornamental en racimos de color azul'),
(2, 9, 9, 4, 'Peonía Rosa', 'Peonía grande y fragante en color rosa'),
(2, 5, 5, 1, 'Lirio Blanco', 'Lirio blanco elegante y fragante para cualquier ocasión'),
(2, 8, 8, 10, 'Hortensia Azul', 'Hortensia ornamental en racimos de color azul'),
(3, 3, 3, 11, 'Orquídea Púrpura', 'Orquídea exótica y elegante en color púrpura'),
(3, 1, 1, 2, 'Rosa Roja', 'Rosa roja clásica para ocasiones románticas'),
(3, 7, 7, 1, 'Margarita Blanca', 'Margarita sencilla y alegre en color blanco'),
(3, 2, 2, 3, 'Tulipán Amarillo', 'Tulipán amarillo brillante para alegrar el día'),
(3, 8, 8, 10, 'Hortensia Azul', 'Hortensia ornamental en racimos de color azul'),
(3, 9, 9, 4, 'Peonía Rosa', 'Peonía grande y fragante en color rosa'),
(4, 4, 4, 5, 'Girasol', 'Girasol alto y brillante que sigue al sol'),
(4, 1, 1, 2, 'Rosa Roja', 'Rosa roja clásica para ocasiones románticas'),
(4, 7, 7, 1, 'Margarita Blanca', 'Margarita sencilla y alegre en color blanco'),
(4, 2, 2, 3, 'Tulipán Amarillo', 'Tulipán amarillo brillante para alegrar el día'),
(4, 8, 8, 10, 'Hortensia Azul', 'Hortensia ornamental en racimos de color azul'),
(4, 9, 9, 4, 'Peonía Rosa', 'Peonía grande y fragante en color rosa'),
(5, 5, 5, 1, 'Lirio Blanco', 'Lirio blanco elegante y fragante para cualquier ocasión'),
(5, 2, 2, 3, 'Tulipán Amarillo', 'Tulipán amarillo brillante para alegrar el día'),
(5, 3, 3, 11, 'Orquídea Púrpura', 'Orquídea exótica y elegante en color púrpura'),
(5, 4, 4, 5, 'Girasol', 'Girasol alto y brillante que sigue al sol'),
(6, 8, 8, 10, 'Hortensia Azul', 'Hortensia ornamental en racimos de color azul'),
(6, 9, 9, 4, 'Peonía Rosa', 'Peonía grande y fragante en color rosa'),
(6, 4, 4, 5, 'Girasol', 'Girasol alto y brillante que sigue al sol'),
(6, 1, 1, 2, 'Rosa Roja', 'Rosa roja clásica para ocasiones románticas'),
(6, 7, 7, 1, 'Margarita Blanca', 'Margarita sencilla y alegre en color blanco'),
(6, 6, 6, 2, 'Clavel Rojo', 'Clavel rojo popular en ramos y arreglos');


-- Verificar los datos insertados
SELECT * FROM CATALOGO_FLORISTERIA;


-- Insertar datos de prueba en la tabla HISTORICO_PRECIO_FLOR
INSERT INTO HISTORICO_PRECIO_FLOR (idCatalogoFloristeria, idCatalogocodigo, fechaInicio, fechaFin, precio, tamanoTallo) VALUES
(1, 1, '2023-04-15', NULL, 10.00, 50),
(1, 7, '2023-05-01', NULL, 12.50, 55),
(1, 2, '2023-03-01', NULL, 15.00, 65),
(1, 8, '2023-04-01', NULL, 17.50, 70),
(1, 3, '2023-05-01', NULL, 20.00, 50),
(1, 4, '2023-06-01', NULL, 22.50, 55),
(1, 9, '2023-07-01', NULL, 25.00, 65),
(1, 5, '2023-08-01', NULL, 27.50, 70),
(1, 6, '2023-09-01', NULL, 30.00, 50),
(2, 2, '2023-10-01', NULL, 32.50, 55),
(2, 3, '2023-11-01', NULL, 35.00, 65),
(2, 4, '2023-12-01', NULL, 37.50, 70),
(2, 9, '2024-01-01', NULL, 40.00, 50),
(2, 5, '2024-02-01', NULL, 42.50, 55),
(2, 8, '2024-03-01', NULL, 45.00, 65),
(3, 3, '2024-04-01', NULL, 47.50, 70),
(3, 1, '2024-05-01', NULL, 10.00, 50),
(3, 7, '2024-06-01', NULL, 12.50, 55),
(3, 2, '2024-07-01', NULL, 15.00, 65),
(3, 8, '2024-08-01', NULL, 17.50, 70),
(3, 9, '2024-09-01', NULL, 20.00, 50),
(4, 4, '2024-10-01', NULL, 22.50, 55),
(4, 1, '2024-11-01', NULL, 25.00, 65),
(4, 7, '2024-12-01', NULL, 27.50, 70),
(4, 2, '2025-01-01', NULL, 30.00, 50),
(4, 8, '2024-02-01', NULL, 32.50, 55),
(4, 9, '2024-03-01', NULL, 35.00, 65),
(5, 5, '2024-04-01', NULL, 37.50, 70),
(5, 6, '2024-05-01', NULL, 40.00, 50),
(5, 2, '2024-06-01', NULL, 42.50, 55),
(5, 3, '2024-07-01', NULL, 45.00, 65),
(5, 4, '2024-08-01', NULL, 47.50, 70),
(6, 8, '2023-09-01', NULL, 10.00, 50),
(6, 9, '2023-09-01', NULL, 12.50, 55),
(6, 4, '2023-11-01', NULL, 15.00, 65),
(6, 1, '2023-12-01', NULL, 17.50, 70),
(6, 7, '2024-01-01', NULL, 20.00, 50),
(6, 6, '2024-02-01', NULL, 22.50, 55);


-- Verificar los datos insertados
SELECT * FROM HISTORICO_PRECIO_FLOR;


-- Insertar datos de prueba en la tabla DETALLE_BOUQUET
INSERT INTO DETALLE_BOUQUET (idCatalogoFloristeria, idCatalogocodigo, bouquetId, cantidad, talloTamano, descripcion) VALUES
(1, 1, 1, 10, 50, 'Bouquet de rosas rojas'),
(2, 2, 2, 15, 60, 'Bouquet de tulipanes amarillos'),
(3, 3, 3, 20, 70, 'Bouquet de orquídeas púrpuras'),
(4, 4, 4, 25, 80, 'Bouquet de girasoles'),
(5, 5, 5, 30, 90, 'Bouquet de lirios blancos'),
(6, 6, 7, 40, 105, 'Bouquet de claveles rojos y blancos'),
(1, 7, 8, 15, 60, 'Bouquet de margaritas blancas y amarillas'),
(2, 8, 9, 20, 70, 'Bouquet de hortensias azules y rosas'),
(3, 9, 10, 25, 80, 'Bouquet de peonías rosas y blancas');

-- Verificar los datos insertados
SELECT * FROM DETALLE_BOUQUET;
-- Verificar los datos insertados
SELECT * FROM DETALLE_BOUQUET;


INSERT INTO FACTURA_FINAL (idFloristeria, fechaEmision, montoTotal, idClienteNatural, idClienteJuridico) VALUES
(1, '2023-04-01', 11000.00, 1, NULL),
(2, '2023-05-01', 75000.00, NULL, 1),
(3, '2023-09-01', 1200.00, 2, NULL),
(4, '2023-10-01', 1250.00, NULL, 2),
(5, '2023-11-01', 15000.00, 3, NULL),
(2, '2023-12-01', 75050.00, NULL, 3),
(3, '2024-07-01', 14000.00, 4, NULL),
(4, '2024-08-01', 2250.00, NULL, 4),
(5, '2024-08-01', 2500.00, 5, NULL),
(1, '2023-05-01', 10500.00, NULL, 3),
(1, '2023-06-01', 10900.00, NULL, 3),
(1, '2023-07-01', 12000.00, NULL, 3),
(1, '2023-08-01', 11000.00, NULL, 3),
(1, '2023-09-15', 4000.00, NULL, 1),
(1, '2023-09-01', 700.00, 2, NULL),
(1, '2023-09-15', 8000.00, NULL, 2),
(1, '2023-10-01', 900.00, 3, NULL),
(1, '2023-10-15', 10000.00, NULL, 3),
(1, '2023-11-01', 1100.00, 4, NULL),
(1, '2023-11-15', 12000.00, NULL, 4),
(1, '2023-08-01', 1300.00, 5, NULL),
(1, '2023-08-15', 2000.00, NULL, 5),
(1, '2023-09-01', 500.00, 1, NULL),
(1, '2023-09-15', 600.00, NULL, 1),
(1, '2023-10-01', 700.00, 2, NULL),
(1, '2023-10-15', 800.00, NULL, 2),
(1, '2023-11-01', 900.00, 3, NULL),
(1, '2023-11-15', 1000.00, NULL, 3),
(1, '2023-12-01', 11000.00, 4, NULL),
(1, '2023-12-15', 1200.00, NULL, 4),
(1, '2024-01-01', 1300.00, 5, NULL),
(1, '2024-01-15', 99000.00, NULL, 5),
(1, '2024-02-01', 500.00, 1, NULL),
(1, '2024-02-15', 63000.00, NULL, 1),
(1, '2024-03-01', 1700.00, 2, NULL),
(1, '2024-03-15', 18000.00, NULL, 2),
(1, '2024-04-01', 900.00, 3, NULL),
(1, '2024-04-15', 10000.00, NULL, 3),
(1, '2024-05-01', 1100.00, 4, NULL),
(1, '2024-05-15', 12000.00, NULL, 4),
(1, '2024-06-01', 1300.00, 5, NULL),
(1, '2024-06-15', 9000.00, NULL, 5),
(1, '2024-07-01', 500.00, 1, NULL),
(1, '2024-07-15', 11000.00, NULL, 1),
(1, '2024-08-01', 700.00, 2, NULL),
(1, '2024-08-15', 8000.00, NULL, 2),
(1, '2024-09-01', 900.00, 3, NULL),
(1, '2024-09-15', 10000.00, NULL, 3),
(1, '2024-10-01', 1100.00, 4, NULL),
(1, '2024-10-15', 12000.00, NULL, 4),
(1, '2024-11-01', 1300.00, 5, NULL),
(1, '2024-11-15', 3000.00, NULL, 5),
(1, '2024-12-01', 1100.00, 1, NULL),
(1, '2024-12-15', 6000.00, NULL, 1),
(2, '2023-06-10', 700.00, 2, NULL),
(2, '2023-06-10', 70000.00, NULL, 1),
(2, '2023-07-01', 80000.00, NULL, 2),
(2, '2023-08-01', 900.00, 3, NULL),
(2, '2023-08-01', 50000.00, NULL, 1),
(2, '2023-09-01', 100000.00, NULL, 3),
(2, '2023-10-01', 1100.00, 4, NULL),
(2, '2023-11-01', 120000.00, NULL, 4),
(2, '2023-12-01', 1300.00, 5, NULL),
(2, '2024-01-01', 30000.00, NULL, 5),
(2, '2024-02-01', 500.00, 1, NULL),
(2, '2024-03-01', 60000.00, NULL, 1),
(2, '2024-04-01', 700.00, 2, NULL),
(2, '2024-05-01', 80000.00, NULL, 2),
(2, '2024-06-01', 9000.00, 3, NULL),
(2, '2024-07-01', 1000.00, NULL, 3),
(2, '2024-08-01', 1100.00, 4, NULL),
(2, '2024-09-01', 120000.00, NULL, 4),
(2, '2024-10-01', 1300.00, 5, NULL),
(2, '2024-11-01', 90000.00, NULL, 5),
(2, '2024-12-01', 500.00, 1, NULL),
(2, '2025-01-01', 60000.00, NULL, 1),
(3, '2023-06-10', 700.00, 2, NULL),
(3, '2023-07-01', 80000.00, NULL, 2),
(3, '2023-08-01', 900.00, 3, NULL),
(3, '2023-09-01', 10000.00, NULL, 3),
(3, '2023-10-01', 1100.00, 4, NULL),
(3, '2023-11-01', 1200.00, NULL, 4),
(3, '2023-12-01', 1300.00, 5, NULL),
(3, '2024-01-01', 3000.00, NULL, 5),
(3, '2024-02-01', 500.00, 1, NULL),
(3, '2024-03-01', 6000.00, NULL, 1),
(3, '2024-04-01', 700.00, 2, NULL),
(3, '2024-05-01', 800.00, NULL, 2),
(3, '2024-06-01', 900.00, 3, NULL),
(3, '2024-07-01', 1000.00, NULL, 3),
(3, '2024-08-01', 1100.00, 4, NULL),
(3, '2024-09-01', 1200.00, NULL, 4),
(3, '2024-10-01', 13000.00, 5, NULL),
(3, '2024-11-01', 3000.00, NULL, 5),
(3, '2024-12-01', 5000.00, 1, NULL),
(3, '2025-01-01', 6000.00, NULL, 1),
(4, '2023-06-10', 7000.00, 2, NULL),
(4, '2023-07-01', 800.00, NULL, 2),
(4, '2023-08-01', 900.00, 3, NULL),
(4, '2023-09-01', 10000.00, NULL, 3),
(4, '2023-10-01', 1100.00, 4, NULL),
(4, '2023-11-01', 1200.00, NULL, 4),
(4, '2023-12-01', 1300.00, 5, NULL),
(4, '2024-01-01', 300.00, NULL, 5),
(4, '2024-02-01', 500.00, 1, NULL),
(4, '2024-03-01', 600.00, NULL, 1),
(4, '2024-04-01', 700.00, 2, NULL),
(4, '2024-05-01', 800.00, NULL, 2),
(4, '2024-06-01', 900.00, 3, NULL),
(4, '2024-07-01', 1000.00, NULL, 3),
(4, '2024-08-01', 1100.00, 4, NULL),
(4, '2024-09-01', 1200.00, NULL, 4),
(4, '2024-10-01', 1300.00, 5, NULL),
(4, '2024-11-01', 300.00, NULL, 5),
(4, '2024-12-01', 500.00, 1, NULL),
(4, '2025-01-01', 600.00, NULL, 1),
(5, '2023-06-10', 700.00, 2, NULL),
(5, '2023-07-01', 800.00, NULL, 2),
(5, '2023-08-01', 900.00, 3, NULL),
(5, '2023-09-01', 1000.00, NULL, 3),
(5, '2023-10-01', 1100.00, 4, NULL),
(5, '2023-11-01', 1200.00, NULL, 4),
(5, '2023-12-01', 1300.00, 5, NULL),
(5, '2024-01-01', 300.00, NULL, 5),
(5, '2024-02-01', 500.00, 1, NULL),
(5, '2024-03-01', 600.00, NULL, 1),
(5, '2024-04-01', 700.00, 2, NULL),
(5, '2024-05-01', 800.00, NULL, 2),
(5, '2024-06-01', 900.00, 3, NULL),
(5, '2024-07-01', 1000.00, NULL, 3),
(5, '2024-08-01', 1100.00, 4, NULL),
(5, '2024-09-01', 1200.00, NULL, 4),
(5, '2024-10-01', 1300.00, 5, NULL),
(5, '2024-11-01', 300.00, NULL, 5),
(5, '2024-12-01', 500.00, 1, NULL),
(5, '2025-01-01', 600.00, NULL, 1),
(6, '2023-06-10', 700.00, 2, NULL),
(6, '2023-07-01', 800.00, NULL, 2),
(6, '2023-08-01', 900.00, 3, NULL),
(6, '2023-09-01', 1000.00, NULL, 3),
(6, '2023-10-01', 1100.00, 4, NULL),
(6, '2023-11-01', 1200.00, NULL, 4),
(6, '2023-12-01', 1300.00, 5, NULL),
(6, '2024-01-01', 300.00, NULL, 5),
(6, '2024-02-01', 500.00, 1, NULL),
(6, '2024-03-01', 600.00, NULL, 1),
(6, '2024-04-01', 700.00, 2, NULL),
(6, '2024-05-01', 800.00, NULL, 2),
(6, '2024-06-01', 900.00, 3, NULL),
(6, '2024-07-01', 1000.00, NULL, 3),
(6, '2024-08-01', 1100.00, 4, NULL),
(6, '2024-09-01', 1200.00, NULL, 4),
(6, '2024-10-01', 1300.00, 5, NULL),
(6, '2024-11-01', 300.00, NULL, 5),
(6, '2024-12-01', 500.00, 1, NULL),
(6, '2025-01-01', 600.00, NULL, 1);

-- Verificar los datos insertados
SELECT * FROM FACTURA_FINAL;


-- Insertar datos de prueba en la tabla DETALLE_FACTURA
INSERT INTO DETALLE_FACTURA (idFActuraFloristeria, idNumFactura, detalleId, catalogoFloristeria, catalogoCodigo, bouquetFloristeria, bouquetcodigo, bouquetId, cantidad, valoracionPrecio, valorancionCalidad, valoracionPromedio, detalles) VALUES
(1, 1, 1, 1, 1, NULL, NULL, NULL, 10, 0.5, 0.5, 0.5, 'Rosa Roja de alta calidad'),
(2, 2, 2, NULL, NULL, 2, 2, 2, 15, 1.0, 1.0, 1.0, 'Bouquet de tulipanes amarillos'),
(3, 3, 3, 3, 3, NULL, NULL, NULL, 20, 1.5, 1.5, 1.5, 'Orquídea Púrpura exótica'),
(4, 4, 4, NULL, NULL, 4, 4, 4, 25, 2.0, 2.0, 2.0, 'Bouquet de girasoles'),
(5, 5, 5, 5, 5, NULL, NULL, NULL, 30, 2.5, 2.5, 2.5, 'Lirio Blanco elegante'),
(1, 1, 6, 1, 1, NULL, NULL, NULL, 10, 3.0, 3.0, 3.0, 'Rosa Roja de alta calidad'),
(2, 2, 7, NULL, NULL, 2, 2, 2, 15, 3.5, 3.5, 3.5, 'Bouquet de tulipanes amarillos'),
(3, 3, 8, 3, 3, NULL, NULL, NULL, 20, 4.0, 4.0, 4.0, 'Orquídea Púrpura exótica'),
(4, 4, 9, NULL, NULL, 4, 4, 4, 25, 4.5, 4.5, 4.5, 'Bouquet de girasoles'),
(5, 5, 10, 5, 5, NULL, NULL, NULL, 30, 5.0, 5.0, 5.0, 'Lirio Blanco elegante');
-- Verificar los datos insertados
SELECT * FROM DETALLE_FACTURA;


-- Insertar datos de prueba en la tabla TELEFONOS
INSERT INTO TELEFONOS (codPais, codArea, numero, idSubastadora, idProductora, idFloristeria) VALUES
(31, 20, 1234567, 1, NULL, NULL), -- Royal Flora Holland
(31, 20, 2345678, 2, NULL, NULL), -- Plantion
(31, 20, 3456789, 3, NULL, NULL), -- Dutch Flower Group
(31, 20, 4567890, NULL, 1, NULL), -- Anthura
(31, 20, 5678901, NULL, 2, NULL), -- Van den bos
(31, 20, 6789012, NULL, 3, NULL), -- Hilverda florist
(49, 30, 7890123, NULL, NULL, 1), -- FloraPrima
(55, 21, 8901234, NULL, NULL, 2), -- Flowers for Brazil
(45, 31, 9012345, NULL, NULL, 3), -- Blooming
(48, 22, 1234568, NULL, NULL, 4), -- Poczta kwiatowa
(34, 93, 2345679, NULL, NULL, 5), -- Herbs Barcelona
(58, 212, 3456780, NULL, NULL, 6); -- Toscana Flores

-- Verificar los datos insertados
SELECT * FROM TELEFONOS;



-- Ejecutar la función para el periodo 2023-2024 para el contrato 1
SELECT ventas_periodo(1001, '2023-01-01', '2024-01-01');

SELECT MontoComision(1001, '2023-04-01');

-- Ejecutar la función para obtener el reporte de multas generadas y pagadas
SELECT * FROM reporte_multas_generadas_y_pagadas(1, 1, 1001);


SELECT * FROM obtener_facturas();


SELECT * FROM obtener_informacion_factura(1);

SELECT * FROM informacion_de_productores();

SELECT * FROM CatalogoProductoraById(1);

SELECT * FROM Obtener_DetalleFlores(1, 1);


SELECT * FROM obtener_floristeria();

SELECT * FROM obtener_informacion_de_flor(1, 1);

SELECT * FROM Traer_lotes(1);


-- Ejecutar la función para obtener los nombres de los países de las floristerías
SELECT * FROM Paises_floristerias();

-- Ejecutar la función para obtener los nombres de los países de las productoras
SELECT * FROM Paises_productoras();


-------------------------------------------------------------------------------------------------------------------
--  ===========================================================================================================  --
--  ==================================== Requerimientos individuales  =========================================  --
--  ===========================================================================================================  --
-------------------------------------------------------------------------------------------------------------------



-------------------------------------------------------------------------------------------------------------------
--  ===========================================================================================================  --
--  ========================================= vistas y grants  ================================================  --
--  ===========================================================================================================  --
-------------------------------------------------------------------------------------------------------------------
-- Issue: PAIS Vista principal (SELECT con columnas clave)
CREATE OR REPLACE VIEW vista_pais AS
SELECT 
  paisId,
  nombrePais,
  continente
FROM PAIS;

-- Issue: SUBASTADORA Vista principal (SELECT con columnas clave)
CREATE OR REPLACE VIEW vista_subastadora AS
SELECT 
  subastadoraId,
  nombreSubastadora,
  idPais
FROM SUBASTADORA;

-- Issue: SUBASTADORA, Vista de detalles (JOIN con PAIS y tablas relacionadas)
CREATE OR REPLACE VIEW vista_detalles_subastadora AS
SELECT 
  s.subastadoraId,
  s.nombreSubastadora,
  p.nombrePais,
  p.continente
FROM SUBASTADORA s
JOIN PAIS p ON s.idPais = p.paisId;

-- Issue: Función para actualizar Subastadora(UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_subastadora(
  p_subastadoraId NUMERIC,
  p_nombreSubastadora TEXT,
  p_idPais NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si la subastadora existe
  IF NOT EXISTS (SELECT 1 FROM SUBASTADORA WHERE subastadoraId = p_subastadoraId) THEN
    RETURN 'Subastadora no encontrada.';
  END IF;

  -- Actualizar la subastadora
  UPDATE SUBASTADORA
  SET nombreSubastadora = p_nombreSubastadora,
      idPais = p_idPais
  WHERE subastadoraId = p_subastadoraId;

  RETURN 'Subastadora actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_subastadora(1, 'Nueva Subastadora', 2);

-- Issue: Vista principal para PRODUCTORAS
CREATE OR REPLACE VIEW vista_productoras AS
SELECT 
  productoraId,
  nombreProductora,
  paginaWeb,
  idPais
FROM PRODUCTORAS;

-- Issue: Vista de detalles para PRODUCTORAS
CREATE OR REPLACE VIEW vista_detalles_productoras AS
SELECT 
  p.productoraId,
  p.nombreProductora,
  p.paginaWeb,
  pais.nombrePais,
  pais.continente
FROM PRODUCTORAS p
JOIN PAIS pais ON p.idPais = pais.paisId;

-- Issue: Función para actualizar Productoras (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_productora(
  p_productoraId NUMERIC,
  p_nombreProductora TEXT,
  p_paginaWeb TEXT,
  p_idPais NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si la productora existe
  IF NOT EXISTS (SELECT 1 FROM PRODUCTORAS WHERE productoraId = p_productoraId) THEN
    RETURN 'Productora no encontrada.';
  END IF;

  -- Verificar duplicidad de nombre
  IF EXISTS (SELECT 1 FROM PRODUCTORAS WHERE nombreProductora = p_nombreProductora AND productoraId <> p_productoraId) THEN
    RETURN 'El nombre de la productora ya está registrado.';
  END IF;

  -- Actualizar la productora
  UPDATE PRODUCTORAS
  SET nombreProductora = p_nombreProductora,
      paginaWeb = p_paginaWeb,
      idPais = p_idPais
  WHERE productoraId = p_productoraId;

  RETURN 'Productora actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_productora(1, 'Nueva Productora', 'http://nueva-productora.com', 2);

-- Issue: Vista principal para FLORISTERIAS
CREATE OR REPLACE VIEW vista_floristerias AS
SELECT 
  floristeriaId,
  nombre,
  email,
  paginaWeb,
  idPais
FROM FLORISTERIAS;

-- Issue: Vista de detalles para FLORISTERIAS
CREATE OR REPLACE VIEW vista_detalles_floristerias AS
SELECT 
  f.floristeriaId,
  f.nombre,
  f.email,
  f.paginaWeb,
  p.nombrePais,
  p.continente
FROM FLORISTERIAS f
JOIN PAIS p ON f.idPais = p.paisId;

-- Issue: Función para insertar Floristerias (INSERT con validaciones específicas)
CREATE OR REPLACE FUNCTION insertar_floristeria(
  p_nombre TEXT,
  p_email TEXT,
  p_paginaWeb TEXT,
  p_idPais NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el país exista
  IF NOT EXISTS (SELECT 1 FROM PAIS WHERE paisId = p_idPais) THEN
    RETURN 'País no encontrado.';
  END IF;

  -- Validar que no haya registros con el mismo nombre
  IF EXISTS (SELECT 1 FROM FLORISTERIAS WHERE nombre = p_nombre) THEN
    RETURN 'El nombre de la floristería ya está registrado.';
  END IF;

  -- Insertar la nueva floristería
  INSERT INTO FLORISTERIAS (nombre, email, paginaWeb, idPais)
  VALUES (p_nombre, p_email, p_paginaWeb, p_idPais);

  RETURN 'Floristería insertada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_floristeria('Floristeria Nueva', 'contacto@floristerianueva.com', 'http://floristerianueva.com', 1);

-- Issue: Función para actualizar Floristerias (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_floristeria(
  p_floristeriaId NUMERIC,
  p_nombre TEXT,
  p_email TEXT,
  p_paginaWeb TEXT,
  p_idPais NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si la floristería existe
  IF NOT EXISTS (SELECT 1 FROM FLORISTERIAS WHERE floristeriaId = p_floristeriaId) THEN
    RETURN 'Floristería no encontrada.';
  END IF;

  -- Validar que no haya registros con el mismo nombre
  IF EXISTS (SELECT 1 FROM FLORISTERIAS WHERE nombre = p_nombre AND floristeriaId <> p_floristeriaId) THEN
    RETURN 'El nombre de la floristería ya está registrado.';
  END IF;

  -- Actualizar la floristería
  UPDATE FLORISTERIAS
  SET nombre = p_nombre,
      email = p_email,
      paginaWeb = p_paginaWeb,
      idPais = p_idPais
  WHERE floristeriaId = p_floristeriaId;

  RETURN 'Floristería actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_floristeria(1, 'Floristeria Actualizada', 'nuevoemail@floristeria.com', 'http://floristeriaactualizada.com', 2);

-- Issue: Vista principal para CLIENTE_NATURAL
CREATE OR REPLACE VIEW vista_cliente_natural AS
SELECT 
  cliNaturalId,
  documentoIdentidad,
  primernombre,
  primerApellido,
  segundoApellido,
  segundonombre
FROM CLIENTE_NATURAL;

-- Issue: Vista de detalles para CLIENTE_NATURAL
CREATE OR REPLACE VIEW vista_detalles_cliente_natural AS
SELECT 
  cn.cliNaturalId,
  cn.documentoIdentidad,
  cn.primernombre,
  cn.primerApellido,
  cn.segundoApellido,
  cn.segundonombre,
  ff.numFactura,
  ff.fechaEmision,
  ff.montoTotal
FROM CLIENTE_NATURAL cn
JOIN FACTURA_FINAL ff ON cn.cliNaturalId = ff.idClienteNatural;

-- Issue: Función para insertar Cliente Natural (INSERT con validaciones específicas)
CREATE OR REPLACE FUNCTION insertar_cliente_natural(
  p_documentoIdentidad NUMERIC,
  p_primernombre VARCHAR,
  p_primerApellido VARCHAR,
  p_segundoApellido VARCHAR,
  p_segundonombre VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el documento de identidad no exista
  IF EXISTS (SELECT 1 FROM CLIENTE_NATURAL WHERE documentoIdentidad = p_documentoIdentidad) THEN
    RETURN 'El documento de identidad ya está registrado.';
  END IF;

  -- Insertar el nuevo cliente natural
  INSERT INTO CLIENTE_NATURAL (documentoIdentidad, primernombre, primerApellido, segundoApellido, segundonombre)
  VALUES (p_documentoIdentidad, p_primernombre, p_primerApellido, p_segundoApellido, p_segundonombre);

  RETURN 'Cliente natural insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_cliente_natural(12345678, 'Juan', 'Perez', 'Gomez', 'Carlos');

-- Issue: Función para actualizar Cliente Natural (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_cliente_natural(
  p_cliNaturalId NUMERIC,
  p_documentoIdentidad NUMERIC,
  p_primernombre VARCHAR,
  p_primerApellido VARCHAR,
  p_segundoApellido VARCHAR,
  p_segundonombre VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si el cliente natural existe
  IF NOT EXISTS (SELECT 1 FROM CLIENTE_NATURAL WHERE cliNaturalId = p_cliNaturalId) THEN
    RETURN 'Cliente natural no encontrado.';
  END IF;

  -- Validar que no haya otro registro con el mismo documento de identidad
  IF EXISTS (SELECT 1 FROM CLIENTE_NATURAL WHERE documentoIdentidad = p_documentoIdentidad AND cliNaturalId <> p_cliNaturalId) THEN
    RETURN 'El documento de identidad ya está registrado.';
  END IF;

  -- Actualizar el cliente natural
  UPDATE CLIENTE_NATURAL
  SET documentoIdentidad = p_documentoIdentidad,
      primernombre = p_primernombre,
      primerApellido = p_primerApellido,
      segundoApellido = p_segundoApellido,
      segundonombre = p_segundonombre
  WHERE cliNaturalId = p_cliNaturalId;

  RETURN 'Cliente natural actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_cliente_natural(1, 87654321, 'Carlos', 'Lopez', 'Martinez', 'Andres');

-- Issue: Vista principal para CLIENTE_JURIDICO
CREATE OR REPLACE VIEW vista_cliente_juridico AS
SELECT 
  cliJuridicoId,
  RIF,
  nombre
FROM CLIENTE_JURIDICO;

-- Issue: Vista de detalles para CLIENTE_JURIDICO
CREATE OR REPLACE VIEW vista_detalles_cliente_juridico AS
SELECT 
  cj.cliJuridicoId,
  cj.RIF,
  cj.nombre,
  ff.numFactura,
  ff.fechaEmision,
  ff.montoTotal
FROM CLIENTE_JURIDICO cj
JOIN FACTURA_FINAL ff ON cj.cliJuridicoId = ff.idClienteJuridico;

-- Issue: Función para insertar Cliente Juridico (INSERT con validaciones específicas)
CREATE OR REPLACE FUNCTION insertar_cliente_juridico(
  p_RIF NUMERIC,
  p_nombre VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el RIF no exista
  IF EXISTS (SELECT 1 FROM CLIENTE_JURIDICO WHERE RIF = p_RIF) THEN
    RETURN 'El RIF ya está registrado.';
  END IF;

  -- Insertar el nuevo cliente juridico
  INSERT INTO CLIENTE_JURIDICO (RIF, nombre)
  VALUES (p_RIF, p_nombre);

  RETURN 'Cliente juridico insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_cliente_juridico(123456789, 'Empresa XYZ');

-- Issue: Función para actualizar Cliente Juridico (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_cliente_juridico(
  p_cliJuridicoId NUMERIC,
  p_RIF NUMERIC,
  p_nombre VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si el cliente juridico existe
  IF NOT EXISTS (SELECT 1 FROM CLIENTE_JURIDICO WHERE cliJuridicoId = p_cliJuridicoId) THEN
    RETURN 'Cliente juridico no encontrado.';
  END IF;

  -- Validar que no haya otro registro con el mismo RIF
  IF EXISTS (SELECT 1 FROM CLIENTE_JURIDICO WHERE RIF = p_RIF AND cliJuridicoId <> p_cliJuridicoId) THEN
    RETURN 'El RIF ya está registrado.';
  END IF;

  -- Actualizar el cliente juridico
  UPDATE CLIENTE_JURIDICO
  SET RIF = p_RIF,
      nombre = p_nombre
  WHERE cliJuridicoId = p_cliJuridicoId;

  RETURN 'Cliente juridico actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_cliente_juridico(1, 987654321, 'Empresa ABC');

-- Issue: Vista principal para FLOR_CORTES
CREATE OR REPLACE VIEW vista_flor_cortes AS
SELECT 
  corteId,
  nombreComun,
  Descripcion,
  genero_especie,
  etimologia,
  colores,
  temperatura
FROM FLOR_CORTES;

-- Issue: Vista de detalles para FLOR_CORTES
CREATE OR REPLACE VIEW vista_detalles_flor_cortes AS
SELECT 
  fc.corteId,
  fc.nombreComun,
  fc.Descripcion,
  fc.genero_especie,
  fc.etimologia,
  fc.colores,
  fc.temperatura,
  e.Descripcion AS descripcionEnl,
  cp.nombrepropio AS nombrePropioCP
FROM FLOR_CORTES fc
LEFT JOIN ENLACES e ON fc.corteId = e.idCorte
LEFT JOIN CATALOGOPRODUCTOR cp ON fc.corteId = cp.idCorte;

-- Issue: Función para insertar Flor Cortes (INSERT con validaciones específicas)
CREATE OR REPLACE FUNCTION insertar_flor_cortes(
  p_nombreComun VARCHAR,
  p_Descripcion VARCHAR,
  p_genero_especie VARCHAR,
  p_etimologia VARCHAR,
  p_colores VARCHAR,
  p_temperatura NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el nombre común no exista
  IF EXISTS (SELECT 1 FROM FLOR_CORTES WHERE nombreComun = p_nombreComun) THEN
    RETURN 'El nombre común ya está registrado.';
  END IF;

  -- Insertar la nueva flor
  INSERT INTO FLOR_CORTES (nombreComun, Descripcion, genero_especie, etimologia, colores, temperatura)
  VALUES (p_nombreComun, p_Descripcion, p_genero_especie, p_etimologia, p_colores, p_temperatura);

  RETURN 'Flor insertada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_flor_cortes('Rosa', 'Flor roja', 'Rosae', 'Del latín rosa', 'Rojo', 20);

-- Issue: Función para actualizar Flor Cortes (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_flor_cortes(
  p_corteId NUMERIC,
  p_nombreComun VARCHAR,
  p_Descripcion VARCHAR,
  p_genero_especie VARCHAR,
  p_etimologia VARCHAR,
  p_colores VARCHAR,
  p_temperatura NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si la flor existe
  IF NOT EXISTS (SELECT 1 FROM FLOR_CORTES WHERE corteId = p_corteId) THEN
    RETURN 'Flor no encontrada.';
  END IF;

  -- Validar que no haya otra flor con el mismo nombre común
  IF EXISTS (SELECT 1 FROM FLOR_CORTES WHERE nombreComun = p_nombreComun AND corteId <> p_corteId) THEN
    RETURN 'El nombre común ya está registrado para otra flor.';
  END IF;

  -- Actualizar la flor
  UPDATE FLOR_CORTES
  SET nombreComun = p_nombreComun,
      Descripcion = p_Descripcion,
      genero_especie = p_genero_especie,
      etimologia = p_etimologia,
      colores = p_colores,
      temperatura = p_temperatura
  WHERE corteId = p_corteId;

  RETURN 'Flor actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_flor_cortes(1, 'Tulipán', 'Flor amarilla', 'Tulipa', 'Del turco tülbend', 'Amarillo', 15);

-- Issue: Función para eliminar Flor Cortes (DELETE con consideraciones de integridad referencial)
CREATE OR REPLACE FUNCTION eliminar_flor_cortes(
  p_corteId NUMERIC DEFAULT NULL,
  p_nombreComun VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar que al menos uno de los parámetros tenga un valor
  IF p_corteId IS NULL AND p_nombreComun IS NULL THEN
    RETURN 'Debe proporcionar un valor para corteId o nombreComun.';
  END IF;

  -- Verificar si la flor existe
  IF p_corteId IS NOT NULL THEN
    IF NOT EXISTS (SELECT 1 FROM FLOR_CORTES WHERE corteId = p_corteId) THEN
      RETURN 'Flor no encontrada por corteId.';
    END IF;
  ELSIF p_nombreComun IS NOT NULL THEN
    IF NOT EXISTS (SELECT 1 FROM FLOR_CORTES WHERE nombreComun = p_nombreComun) THEN
      RETURN 'Flor no encontrada por nombreComun.';
    END IF;
  END IF;

  -- Verificar si la flor está referenciada en otras tablas
  IF p_corteId IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM ENLACES WHERE idCorte = p_corteId) THEN
      RETURN 'No se puede eliminar la flor porque está referenciada en la tabla ENLACES.';
    END IF;

    IF EXISTS (SELECT 1 FROM CATALOGOPRODUCTOR WHERE idCorte = p_corteId) THEN
      RETURN 'No se puede eliminar la flor porque está referenciada en la tabla CATALOGOPRODUCTOR.';
    END IF;
  ELSIF p_nombreComun IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM ENLACES e JOIN FLOR_CORTES fc ON e.idCorte = fc.corteId WHERE fc.nombreComun = p_nombreComun) THEN
      RETURN 'No se puede eliminar la flor porque está referenciada en la tabla ENLACES.';
    END IF;

    IF EXISTS (SELECT 1 FROM CATALOGOPRODUCTOR cp JOIN FLOR_CORTES fc ON cp.idCorte = fc.corteId WHERE fc.nombreComun = p_nombreComun) THEN
      RETURN 'No se puede eliminar la flor porque está referenciada en la tabla CATALOGOPRODUCTOR.';
    END IF;
  END IF;

  -- Eliminar la flor
  IF p_corteId IS NOT NULL THEN
    DELETE FROM FLOR_CORTES WHERE corteId = p_corteId;
  ELSIF p_nombreComun IS NOT NULL THEN
    DELETE FROM FLOR_CORTES WHERE nombreComun = p_nombreComun;
  END IF;

  RETURN 'Flor eliminada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_flor_cortes(1);

-- Issue: Vista principal para SIGNIFICADO
CREATE OR REPLACE VIEW vista_significado AS
SELECT 
  SignificadoId,
  Tipo,
  Descripcion
FROM SIGNIFICADO;

-- Issue: Vista de detalles para SIGNIFICADO
CREATE OR REPLACE VIEW vista_detalles_significado AS
SELECT 
  s.SignificadoId,
  s.Tipo,
  s.Descripcion,
  e.Descripcion AS descripcionEnlace,
  c.Nombre AS nombreColor,
  fc.nombreComun AS nombreFlor
FROM SIGNIFICADO s
LEFT JOIN ENLACES e ON s.SignificadoId = e.IdSignificado
LEFT JOIN COLOR c ON e.idColor = c.colorId
LEFT JOIN FLOR_CORTES fc ON e.idCorte = fc.corteId;

-- Issue: Función para insertar Significado (INSERT con validaciones específicas)
CREATE OR REPLACE FUNCTION insertar_significado(
  p_Tipo VARCHAR,
  p_Descripcion VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el tipo sea válido
  IF p_Tipo NOT IN ('Oc', 'Se') THEN
    RETURN 'Tipo inválido. Debe ser "Oc" o "Se".';
  END IF;

  -- Insertar el nuevo significado
  INSERT INTO SIGNIFICADO (Tipo, Descripcion)
  VALUES (p_Tipo, p_Descripcion);

  RETURN 'Significado insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_significado('Oc', 'Ocasión especial');

-- Issue: Función para actualizar Significado (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_significado(
  p_SignificadoId NUMERIC,
  p_Tipo VARCHAR,
  p_Descripcion VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si el significado existe
  IF NOT EXISTS (SELECT 1 FROM SIGNIFICADO WHERE SignificadoId = p_SignificadoId) THEN
    RETURN 'Significado no encontrado.';
  END IF;

  -- Validar que el tipo sea válido
  IF p_Tipo NOT IN ('Oc', 'Se') THEN
    RETURN 'Tipo inválido. Debe ser "Oc" o "Se".';
  END IF;

  -- Actualizar el significado
  UPDATE SIGNIFICADO
  SET Tipo = p_Tipo,
      Descripcion = p_Descripcion
  WHERE SignificadoId = p_SignificadoId;

  RETURN 'Significado actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_significado(1, 'Se', 'Significado especial');

-- Issue: Función para eliminar Significado (DELETE con consideraciones de integridad referencial)
CREATE OR REPLACE FUNCTION eliminar_significado(
  p_SignificadoId NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si el significado existe
  IF NOT EXISTS (SELECT 1 FROM SIGNIFICADO WHERE SignificadoId = p_SignificadoId) THEN
    RETURN 'Significado no encontrado.';
  END IF;

  -- Verificar si el significado está referenciado en otras tablas
  IF EXISTS (SELECT 1 FROM ENLACES WHERE IdSignificado = p_SignificadoId) THEN
    RETURN 'No se puede eliminar el significado porque está referenciado en la tabla ENLACES.';
  END IF;

  -- Eliminar el significado
  DELETE FROM SIGNIFICADO WHERE SignificadoId = p_SignificadoId;

  RETURN 'Significado eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_significado(1);

-- Issue: Vista principal para COLOR
CREATE OR REPLACE VIEW vista_color AS
SELECT 
  colorId,
  Nombre,
  Descripcion
FROM COLOR;

-- Issue: Vista de detalles para COLOR
CREATE OR REPLACE VIEW vista_detalles_color AS
SELECT 
  c.colorId,
  c.Nombre,
  c.Descripcion,
  e.Descripcion AS descripcionEnlace,
  cf.nombrePropio AS nombreFlor
FROM COLOR c
LEFT JOIN ENLACES e ON c.colorId = e.idColor
LEFT JOIN CATALOGO_FLORISTERIA cf ON c.colorId = cf.idColor;

-- Issue: Función para insertar Color (INSERT con validaciones específicas)
CREATE OR REPLACE FUNCTION insertar_color(
  p_Nombre VARCHAR,
  p_Descripcion VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el nombre no exista
  IF EXISTS (SELECT 1 FROM COLOR WHERE Nombre = p_Nombre) THEN
    RETURN 'El nombre del color ya está registrado.';
  END IF;

  -- Insertar el nuevo color
  INSERT INTO COLOR (Nombre, Descripcion)
  VALUES (p_Nombre, p_Descripcion);

  RETURN 'Color insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_color('Azul', 'Color azul claro');

-- Issue: Función para actualizar Color (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_color(
  p_colorId NUMERIC,
  p_Nombre VARCHAR,
  p_Descripcion VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si el color existe
  IF NOT EXISTS (SELECT 1 FROM COLOR WHERE colorId = p_colorId) THEN
    RETURN 'Color no encontrado.';
  END IF;

  -- Validar que no haya otro registro con el mismo nombre
  IF EXISTS (SELECT 1 FROM COLOR WHERE Nombre = p_Nombre AND colorId <> p_colorId) THEN
    RETURN 'El nombre del color ya está registrado para otro color.';
  END IF;

  -- Actualizar el color
  UPDATE COLOR
  SET Nombre = p_Nombre,
      Descripcion = p_Descripcion
  WHERE colorId = p_colorId;

  RETURN 'Color actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_color(1, 'Verde', 'Color verde oscuro');

-- Issue: Función para eliminar Color (DELETE con consideraciones de integridad referencial)
CREATE OR REPLACE FUNCTION eliminar_color(
  p_colorId NUMERIC DEFAULT NULL,
  p_nombre VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar que al menos uno de los parámetros tenga un valor
  IF p_colorId IS NULL AND p_nombre IS NULL THEN
    RETURN 'Debe proporcionar un valor para colorId o nombre.';
  END IF;

  -- Verificar si el color existe
  IF p_colorId IS NOT NULL THEN
    IF NOT EXISTS (SELECT 1 FROM COLOR WHERE colorId = p_colorId) THEN
      RETURN 'Color no encontrado por colorId.';
    END IF;
  ELSIF p_nombre IS NOT NULL THEN
    IF NOT EXISTS (SELECT 1 FROM COLOR WHERE Nombre = p_nombre) THEN
      RETURN 'Color no encontrado por nombre.';
    END IF;
  END IF;

  -- Verificar si el color está referenciado en otras tablas
  IF p_colorId IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM ENLACES WHERE idColor = p_colorId) THEN
      RETURN 'No se puede eliminar el color porque está referenciado en la tabla ENLACES.';
    END IF;

    IF EXISTS (SELECT 1 FROM CATALOGO_FLORISTERIA WHERE idColor = p_colorId) THEN
      RETURN 'No se puede eliminar el color porque está referenciado en la tabla CATALOGO_FLORISTERIA.';
    END IF;
  ELSIF p_nombre IS NOT NULL THEN
    IF EXISTS (SELECT 1 FROM ENLACES e JOIN COLOR c ON e.idColor = c.colorId WHERE c.Nombre = p_nombre) THEN
      RETURN 'No se puede eliminar el color porque está referenciado en la tabla ENLACES.';
    END IF;

    IF EXISTS (SELECT 1 FROM CATALOGO_FLORISTERIA cf JOIN COLOR c ON cf.idColor = c.colorId WHERE c.Nombre = p_nombre) THEN
      RETURN 'No se puede eliminar el color porque está referenciado en la tabla CATALOGO_FLORISTERIA.';
    END IF;
  END IF;

  -- Eliminar el color
  IF p_colorId IS NOT NULL THEN
    DELETE FROM COLOR WHERE colorId = p_colorId;
  ELSIF p_nombre IS NOT NULL THEN
    DELETE FROM COLOR WHERE Nombre = p_nombre;
  END IF;

  RETURN 'Color eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_color(1);

-- Issue: Vista principal para ENLACES
CREATE OR REPLACE VIEW vista_enlaces AS
SELECT 
  IdSignificado,
  enlaceId,
  Descripcion,
  idColor,
  idCorte
FROM ENLACES;

-- Issue: Vista de detalles para ENLACES
CREATE OR REPLACE VIEW vista_detalles_enlaces AS
SELECT 
  e.IdSignificado,
  e.enlaceId,
  e.Descripcion,
  c.Nombre AS nombreColor,
  fc.nombreComun AS nombreFlor,
  s.Descripcion AS significado
FROM ENLACES e
LEFT JOIN COLOR c ON e.idColor = c.colorId
LEFT JOIN FLOR_CORTES fc ON e.idCorte = fc.corteId
LEFT JOIN SIGNIFICADO s ON e.IdSignificado = s.SignificadoId;

-- Issue: Función para insertar Enlaces (INSERT con validaciones específicas)
CREATE OR REPLACE FUNCTION insertar_enlace(
  p_IdSignificado NUMERIC,
  p_Descripcion VARCHAR,
  p_idColor NUMERIC DEFAULT NULL,
  p_idCorte NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que al menos uno de los campos idColor o idCorte tenga un valor
  IF p_idColor IS NULL AND p_idCorte IS NULL THEN
    RETURN 'Debe proporcionar al menos un valor para idColor o idCorte.';
  END IF;

  -- Insertar el nuevo enlace
  INSERT INTO ENLACES (IdSignificado, Descripcion, idColor, idCorte)
  VALUES (p_IdSignificado, p_Descripcion, p_idColor, p_idCorte);

  RETURN 'Enlace insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_enlace(1, 'Enlace de prueba', 1, NULL);

-- Issue: Función para actualizar Enlaces (UPDATE con lógica de negocio)
CREATE OR REPLACE FUNCTION actualizar_enlace(
  p_IdSignificado NUMERIC,
  p_enlaceId NUMERIC,
  p_Descripcion VARCHAR,
  p_idColor NUMERIC DEFAULT NULL,
  p_idCorte NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si el enlace existe
  IF NOT EXISTS (SELECT 1 FROM ENLACES WHERE IdSignificado = p_IdSignificado AND enlaceId = p_enlaceId) THEN
    RETURN 'Enlace no encontrado.';
  END IF;

  -- Validar que al menos uno de los campos idColor o idCorte tenga un valor
  IF p_idColor IS NULL AND p_idCorte IS NULL THEN
    RETURN 'Debe proporcionar al menos un valor para idColor o idCorte.';
  END IF;

  -- Actualizar el enlace
  UPDATE ENLACES
  SET Descripcion = p_Descripcion,
      idColor = p_idColor,
      idCorte = p_idCorte
  WHERE IdSignificado = p_IdSignificado AND enlaceId = p_enlaceId;

  RETURN 'Enlace actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_enlace(1, 1, 'Descripción actualizada', 2, NULL);

-- Issue: Función para eliminar Enlaces (DELETE con consideraciones de integridad referencial)
CREATE OR REPLACE FUNCTION eliminar_enlace(
  p_IdSignificado NUMERIC,
  p_enlaceId NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si el enlace existe
  IF NOT EXISTS (SELECT 1 FROM ENLACES WHERE IdSignificado = p_IdSignificado AND enlaceId = p_enlaceId) THEN
    RETURN 'Enlace no encontrado.';
  END IF;

  -- Eliminar el enlace
  DELETE FROM ENLACES WHERE IdSignificado = p_IdSignificado AND enlaceId = p_enlaceId;

  RETURN 'Enlace eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_enlace(1, 1);

-- Issue: Vista principal para CATALOGOPRODUCTOR
CREATE OR REPLACE VIEW vista_catalogoproductor AS
SELECT 
  idProductora,
  idCorte,
  vbn,
  nombrepropio,
  descripcion
FROM CATALOGOPRODUCTOR;

-- Issue: Vista de detalles para CATALOGOPRODUCTOR
CREATE OR REPLACE VIEW vista_detalles_catalogoproductor AS
SELECT 
  cp.idProductora,
  p.nombreProductora,
  cp.idCorte,
  fc.nombreComun AS nombreFlor,
  cp.vbn,
  cp.nombrepropio,
  cp.descripcion
FROM CATALOGOPRODUCTOR cp
JOIN PRODUCTORAS p ON cp.idProductora = p.productoraId
JOIN FLOR_CORTES fc ON cp.idCorte = fc.corteId;

-- Issue: Función para insertar CatalogoProductor
CREATE OR REPLACE FUNCTION insertar_catalogoproductor(
  p_idProductora NUMERIC,
  p_idCorte NUMERIC,
  p_vbn NUMERIC,
  p_nombrepropio VARCHAR,
  p_descripcion VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar referencias
  IF NOT EXISTS (SELECT 1 FROM PRODUCTORAS WHERE productoraId = p_idProductora) THEN
    RETURN 'Productora no encontrada.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM FLOR_CORTES WHERE corteId = p_idCorte) THEN
    RETURN 'Flor no encontrada.';
  END IF;

  INSERT INTO CATALOGOPRODUCTOR (idProductora, idCorte, vbn, nombrepropio, descripcion)
  VALUES (p_idProductora, p_idCorte, p_vbn, p_nombrepropio, p_descripcion);

  RETURN 'CatalogoProductor insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_catalogoproductor(1, 1, 123, 'Nombre Propio', 'Descripción');

-- Issue: Función para actualizar CatalogoProductor
CREATE OR REPLACE FUNCTION actualizar_catalogoproductor(
  p_idProductora NUMERIC,
  p_idCorte NUMERIC,
  p_vbn NUMERIC,
  p_nombrepropio VARCHAR,
  p_descripcion VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 
    FROM CATALOGOPRODUCTOR 
    WHERE idProductora = p_idProductora 
      AND idCorte = p_idCorte 
      AND vbn = p_vbn
  ) THEN
    RETURN 'Registro de CatalogoProductor no encontrado.';
  END IF;

  UPDATE CATALOGOPRODUCTOR
  SET nombrepropio = p_nombrepropio,
      descripcion = p_descripcion
  WHERE idProductora = p_idProductora
    AND idCorte = p_idCorte
    AND vbn = p_vbn;

  RETURN 'CatalogoProductor actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_catalogoproductor(1, 1, 123, 'Nombre Propio Actualizado', 'Descripción Actualizada');

-- Issue: Función para eliminar CatalogoProductor (consideraciones de integridad referencial)
CREATE OR REPLACE FUNCTION eliminar_catalogoproductor(
  p_idProductora NUMERIC,
  p_idCorte NUMERIC,
  p_vbn NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 
    FROM CATALOGOPRODUCTOR 
    WHERE idProductora = p_idProductora 
      AND idCorte = p_idCorte 
      AND vbn = p_vbn
  ) THEN
    RETURN 'Registro de CatalogoProductor no encontrado.';
  END IF;

  -- Verificar referencias en CANTIDAD_OFRECIDA
  IF EXISTS (
    SELECT 1 FROM CANTIDAD_OFRECIDA
    WHERE idCatalogoProductora = p_idProductora
      AND idCatalogoCorte = p_idCorte
      AND idVnb = p_vbn
  ) THEN
    RETURN 'No se puede eliminar porque está referenciado en la tabla CANTIDAD_OFRECIDA.';
  END IF;

  DELETE FROM CATALOGOPRODUCTOR
  WHERE idProductora = p_idProductora
    AND idCorte = p_idCorte
    AND vbn = p_vbn;

  RETURN 'CatalogoProductor eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_catalogoproductor(1, 1, 123);

-- Issue: Vista principal para CONTRATO
CREATE OR REPLACE VIEW vista_contrato AS
SELECT 
  idSubastadora,
  idProductora,
  nContrato,
  fechaemision,
  porcentajeProduccion,
  tipoProductor,
  idrenovS,
  idrenovP,
  ren_nContrato,
  cancelado
FROM CONTRATO;

-- Issue: Vista de detalles para CONTRATO
CREATE OR REPLACE VIEW vista_detalles_contrato AS
SELECT 
  c.idSubastadora,
  s.nombreSubastadora,
  c.idProductora,
  p.nombreProductora,
  c.nContrato,
  c.fechaemision,
  c.porcentajeProduccion,
  c.tipoProductor,
  c.idrenovS,
  c.idrenovP,
  c.ren_nContrato,
  c.cancelado
FROM CONTRATO c
JOIN SUBASTADORA s ON c.idSubastadora = s.subastadoraId
JOIN PRODUCTORAS p ON c.idProductora = p.productoraId;

-- Issue: Función para insertar Contrato
CREATE OR REPLACE FUNCTION insertar_contrato(
  p_idSubastadora NUMERIC,
  p_idProductora NUMERIC,
  p_nContrato NUMERIC,
  p_fechaemision DATE,
  p_porcentajeProduccion NUMERIC,
  p_tipoProductor VARCHAR,
  p_idrenovS NUMERIC DEFAULT NULL,
  p_idrenovP NUMERIC DEFAULT NULL,
  p_ren_nContrato NUMERIC DEFAULT NULL,
  p_cancelado DATE DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar subastadora y productora
  IF NOT EXISTS (SELECT 1 FROM SUBASTADORA WHERE subastadoraId = p_idSubastadora) THEN
    RETURN 'Subastadora no encontrada.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM PRODUCTORAS WHERE productoraId = p_idProductora) THEN
    RETURN 'Productora no encontrada.';
  END IF;

  INSERT INTO CONTRATO (
    idSubastadora, idProductora, nContrato, fechaemision, porcentajeProduccion, 
    tipoProductor, idrenovS, idrenovP, ren_nContrato, cancelado
  )
  VALUES (
    p_idSubastadora, p_idProductora, p_nContrato, p_fechaemision, p_porcentajeProduccion, 
    p_tipoProductor, p_idrenovS, p_idrenovP, p_ren_nContrato, p_cancelado
  );

  RETURN 'Contrato insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_contrato(1, 1, 123, '2023-01-01', 50, 'Tipo A', NULL, NULL, NULL, NULL);

-- Issue: Función para actualizar Contrato
CREATE OR REPLACE FUNCTION actualizar_contrato(
  p_idSubastadora NUMERIC,
  p_idProductora NUMERIC,
  p_nContrato NUMERIC,
  p_fechaemision DATE,
  p_porcentajeProduccion NUMERIC,
  p_tipoProductor VARCHAR,
  p_idrenovS NUMERIC DEFAULT NULL,
  p_idrenovP NUMERIC DEFAULT NULL,
  p_ren_nContrato NUMERIC DEFAULT NULL,
  p_cancelado DATE DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CONTRATO
    WHERE idSubastadora = p_idSubastadora
      AND idProductora = p_idProductora
      AND nContrato = p_nContrato
  ) THEN
    RETURN 'Contrato no encontrado.';
  END IF;

  UPDATE CONTRATO
  SET fechaemision = p_fechaemision,
      porcentajeProduccion = p_porcentajeProduccion,
      tipoProductor = p_tipoProductor,
      idrenovS = p_idrenovS,
      idrenovP = p_idrenovP,
      ren_nContrato = p_ren_nContrato,
      cancelado = p_cancelado
  WHERE idSubastadora = p_idSubastadora
    AND idProductora = p_idProductora
    AND nContrato = p_nContrato;

  RETURN 'Contrato actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_contrato(1, 1, 123, '2023-01-01', 60, 'Tipo B', NULL, NULL, NULL, NULL);

-- Issue: Función para eliminar Contrato (consideraciones de integridad referencial)
CREATE OR REPLACE FUNCTION eliminar_contrato(
  p_idSubastadora NUMERIC,
  p_idProductora NUMERIC,
  p_nContrato NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CONTRATO
    WHERE idSubastadora = p_idSubastadora
      AND idProductora = p_idProductora
      AND nContrato = p_nContrato
  ) THEN
    RETURN 'Contrato no encontrado.';
  END IF;

  -- Verificar referencias en CANTIDAD_OFRECIDA o PAGOS
  IF EXISTS (
    SELECT 1 FROM CANTIDAD_OFRECIDA
    WHERE idContratoSubastadora = p_idSubastadora
      AND idContratoProductora = p_idProductora
      AND idNContrato = p_nContrato
  ) THEN
    RETURN 'No se puede eliminar el contrato porque está referenciado en la tabla CANTIDAD_OFRECIDA.';
  END IF;

  IF EXISTS (
    SELECT 1 FROM PAGOS
    WHERE idContratoSubastadora = p_idSubastadora
      AND idContratoProductora = p_idProductora
      AND idNContrato = p_nContrato
  ) THEN
    RETURN 'No se puede eliminar el contrato porque está referenciado en la tabla PAGOS.';
  END IF;

  DELETE FROM CONTRATO
  WHERE idSubastadora = p_idSubastadora
    AND idProductora = p_idProductora
    AND nContrato = p_nContrato;

  RETURN 'Contrato eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_contrato(1, 1, 123);

-- Issue: CANTIDAD_OFRECIDA Vista principal
CREATE OR REPLACE VIEW vista_cantidad_ofrecida AS
SELECT 
  idContratoSubastadora,
  idContratoProductora,
  idNContrato,
  idCatalogoProductora,
  idCatalogoCorte,
  idVnb,
  cantidad
FROM CANTIDAD_OFRECIDA;

-- Issue: CANTIDAD_OFRECIDA Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_cantidad_ofrecida AS
SELECT 
    co.idContratoSubastadora,
    s.nombreSubastadora,
    co.idContratoProductora,
    p.nombreProductora,
    co.idNContrato,
    p.nombreProductora AS nombreProductoraCat,
    fc.nombreComun AS nombreFlor,
    co.idVnb,
    co.cantidad
FROM CANTIDAD_OFRECIDA co
JOIN CONTRATO c ON co.idContratoSubastadora = c.idSubastadora
    AND co.idContratoProductora = c.idProductora
    AND co.idNContrato = c.nContrato
JOIN CATALOGOPRODUCTOR cp ON co.idCatalogoProductora = cp.idProductora
    AND co.idCatalogoCorte = cp.idCorte
    AND co.idVnb = cp.vbn
JOIN SUBASTADORA s ON c.idSubastadora = s.subastadoraId
JOIN PRODUCTORAS p ON c.idProductora = p.productoraId
JOIN FLOR_CORTES fc ON cp.idCorte = fc.corteId;

-- Issue: Función para insertar CANTIDAD_OFRECIDA
CREATE OR REPLACE FUNCTION insertar_cantidad_ofrecida(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_idCatalogoProductora NUMERIC,
  p_idCatalogoCorte NUMERIC,
  p_idVnb NUMERIC,
  p_cantidad NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar contrato
  IF NOT EXISTS (
    SELECT 1 FROM CONTRATO
    WHERE idSubastadora = p_idContratoSubastadora
      AND idProductora = p_idContratoProductora
      AND nContrato = p_idNContrato
  ) THEN
    RETURN 'Contrato no encontrado.';
  END IF;

  -- Verificar catalogoproductor
  IF NOT EXISTS (
    SELECT 1 FROM CATALOGOPRODUCTOR
    WHERE idProductora = p_idCatalogoProductora
      AND idCorte = p_idCatalogoCorte
      AND vbn = p_idVnb
  ) THEN
    RETURN 'CatalogoProductor no encontrado.';
  END IF;

  INSERT INTO CANTIDAD_OFRECIDA (
    idContratoSubastadora, idContratoProductora, idNContrato,
    idCatalogoProductora, idCatalogoCorte, idVnb, cantidad
  ) VALUES (
    p_idContratoSubastadora, p_idContratoProductora, p_idNContrato,
    p_idCatalogoProductora, p_idCatalogoCorte, p_idVnb, p_cantidad
  );

  RETURN 'Cantidad_ofrecida insertada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_cantidad_ofrecida(1, 1, 123, 1, 1, 123, 100);

-- Issue: Función para actualizar CANTIDAD_OFRECIDA
CREATE OR REPLACE FUNCTION actualizar_cantidad_ofrecida(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_idCatalogoProductora NUMERIC,
  p_idCatalogoCorte NUMERIC,
  p_idVnb NUMERIC,
  p_cantidad NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CANTIDAD_OFRECIDA
    WHERE idContratoSubastadora = p_idContratoSubastadora
      AND idContratoProductora = p_idContratoProductora
      AND idNContrato = p_idNContrato
      AND idCatalogoProductora = p_idCatalogoProductora
      AND idCatalogoCorte = p_idCatalogoCorte
      AND idVnb = p_idVnb
  ) THEN
    RETURN 'Registro de CANTIDAD_OFRECIDA no encontrado.';
  END IF;

  UPDATE CANTIDAD_OFRECIDA
  SET cantidad = p_cantidad
  WHERE idContratoSubastadora = p_idContratoSubastadora
    AND idContratoProductora = p_idContratoProductora
    AND idNContrato = p_idNContrato
    AND idCatalogoProductora = p_idCatalogoProductora
    AND idCatalogoCorte = p_idCatalogoCorte
    AND idVnb = p_idVnb;

  RETURN 'Cantidad_ofrecida actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_cantidad_ofrecida(1, 1, 123, 1, 1, 123, 200);

-- Issue: Función para eliminar CANTIDAD_OFRECIDA
CREATE OR REPLACE FUNCTION eliminar_cantidad_ofrecida(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_idCatalogoProductora NUMERIC,
  p_idCatalogoCorte NUMERIC,
  p_idVnb NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CANTIDAD_OFRECIDA
    WHERE idContratoSubastadora = p_idContratoSubastadora
      AND idContratoProductora = p_idContratoProductora
      AND idNContrato = p_idNContrato
      AND idCatalogoProductora = p_idCatalogoProductora
      AND idCatalogoCorte = p_idCatalogoCorte
      AND idVnb = p_idVnb
  ) THEN
    RETURN 'Registro de CANTIDAD_OFRECIDA no encontrado.';
  END IF;

  DELETE FROM CANTIDAD_OFRECIDA
  WHERE idContratoSubastadora = p_idContratoSubastadora
    AND idContratoProductora = p_idContratoProductora
    AND idNContrato = p_idNContrato
    AND idCatalogoProductora = p_idCatalogoProductora
    AND idCatalogoCorte = p_idCatalogoCorte
    AND idVnb = p_idVnb;

  RETURN 'Cantidad_ofrecida eliminada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_cantidad_ofrecida(1, 1, 123, 1, 1, 123);

-- Issue: PAGOS Vista principal
CREATE OR REPLACE VIEW vista_pagos AS
SELECT
  idContratoSubastadora,
  idContratoProductora,
  idNContrato,
  pagoId,
  fechaPago,
  montoComision,
  tipo
FROM PAGOS;

-- Issue: PAGOS Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_pagos AS
SELECT
    p.idContratoSubastadora,
    s.nombreSubastadora AS subastadoraNombre,
    p.idContratoProductora,
    pr.nombreProductora,
    p.idNContrato,
    p.pagoId,
    p.fechaPago,
    p.montoComision,
    p.tipo
FROM PAGOS p
JOIN CONTRATO c ON p.idContratoSubastadora = c.idSubastadora
    AND p.idContratoProductora = c.idProductora
    AND p.idNContrato = c.nContrato
JOIN SUBASTADORA s ON c.idSubastadora = s.subastadoraId
JOIN PRODUCTORAS pr ON c.idProductora = pr.productoraId;

-- Issue: Función para insertar PAGOS
CREATE OR REPLACE FUNCTION insertar_pagos(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_pagoId NUMERIC,
  p_fechaPago DATE,
  p_montoComision NUMERIC,
  p_tipo VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CONTRATO
    WHERE idSubastadora = p_idContratoSubastadora
      AND idProductora = p_idContratoProductora
      AND nContrato = p_idNContrato
  ) THEN
    RETURN 'Contrato no encontrado.';
  END IF;

  INSERT INTO PAGOS (
    idContratoSubastadora, idContratoProductora, idNContrato,
    pagoId, fechaPago, montoComision, tipo
  )
  VALUES (
    p_idContratoSubastadora, p_idContratoProductora, p_idNContrato,
    p_pagoId, p_fechaPago, p_montoComision, p_tipo
  );

  RETURN 'Pago insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_pagos(1, 1, 123, 1, '2023-01-01', 1000, 'Tipo A');

-- Issue: Función para actualizar PAGOS
CREATE OR REPLACE FUNCTION actualizar_pagos(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_pagoId NUMERIC,
  p_fechaPago DATE,
  p_montoComision NUMERIC,
  p_tipo VARCHAR
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM PAGOS
    WHERE idContratoSubastadora = p_idContratoSubastadora
      AND idContratoProductora = p_idContratoProductora
      AND idNContrato = p_idNContrato
      AND pagoId = p_pagoId
  ) THEN
    RETURN 'Pago no encontrado.';
  END IF;

  UPDATE PAGOS
  SET fechaPago = p_fechaPago,
      montoComision = p_montoComision,
      tipo = p_tipo
  WHERE idContratoSubastadora = p_idContratoSubastadora
    AND idContratoProductora = p_idContratoProductora
    AND idNContrato = p_idNContrato
    AND pagoId = p_pagoId;

  RETURN 'Pago actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_pagos(1, 1, 123, 1, '2023-01-01', 2000, 'Tipo B');

-- Issue: Función para eliminar PAGOS
CREATE OR REPLACE FUNCTION eliminar_pagos(
  p_idContratoSubastadora NUMERIC,
  p_idContratoProductora NUMERIC,
  p_idNContrato NUMERIC,
  p_pagoId NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM PAGOS
    WHERE idContratoSubastadora = p_idContratoSubastadora
      AND idContratoProductora = p_idContratoProductora
      AND idNContrato = p_idNContrato
      AND pagoId = p_pagoId
  ) THEN
    RETURN 'Pago no encontrado.';
  END IF;

  DELETE FROM PAGOS
  WHERE idContratoSubastadora = p_idContratoSubastadora
    AND idContratoProductora = p_idContratoProductora
    AND idNContrato = p_idNContrato
    AND pagoId = p_pagoId;

  RETURN 'Pago eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_pagos(1, 1, 123, 1);

-- Issue: CONTACTOS Vista principal
CREATE OR REPLACE VIEW vista_contactos AS
SELECT
  idFloristeria,
  contactoId,
  documentoIdentidad,
  primerNombre,
  primerApellido,
  segundoApellido,
  segundoNombre
FROM CONTACTOS;

-- Issue: CONTACTOS Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_contactos AS
SELECT
  c.idFloristeria,
  f.nombre AS nombreFloristeria,
  c.contactoId,
  c.documentoIdentidad,
  c.primerNombre,
  c.primerApellido,
  c.segundoApellido,
  c.segundoNombre
FROM CONTACTOS c
JOIN FLORISTERIAS f ON c.idFloristeria = f.floristeriaId;

-- Issue: Función para insertar CONTACTOS
CREATE OR REPLACE FUNCTION insertar_contacto(
  p_idFloristeria NUMERIC,
  p_contactoId NUMERIC,
  p_documentoIdentidad NUMERIC,
  p_primerNombre VARCHAR,
  p_primerApellido VARCHAR,
  p_segundoApellido VARCHAR DEFAULT NULL,
  p_segundoNombre VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM FLORISTERIAS WHERE floristeriaId = p_idFloristeria) THEN
    RETURN 'Floristería no encontrada.';
  END IF;

  INSERT INTO CONTACTOS (
    idFloristeria, contactoId, documentoIdentidad, primerNombre,
    primerApellido, segundoApellido, segundoNombre
  )
  VALUES (
    p_idFloristeria, p_contactoId, p_documentoIdentidad, p_primerNombre,
    p_primerApellido, p_segundoApellido, p_segundoNombre
  );

  RETURN 'Contacto insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_contacto(1, 1, 12345678, 'Juan', 'Perez', 'Gomez', 'Carlos');

-- Issue: Función para actualizar CONTACTOS
CREATE OR REPLACE FUNCTION actualizar_contacto(
  p_idFloristeria NUMERIC,
  p_contactoId NUMERIC,
  p_documentoIdentidad NUMERIC,
  p_primerNombre VARCHAR,
  p_primerApellido VARCHAR,
  p_segundoApellido VARCHAR DEFAULT NULL,
  p_segundoNombre VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CONTACTOS
    WHERE idFloristeria = p_idFloristeria
      AND contactoId = p_contactoId
  ) THEN
    RETURN 'Contacto no encontrado.';
  END IF;

  UPDATE CONTACTOS
  SET documentoIdentidad = p_documentoIdentidad,
      primerNombre = p_primerNombre,
      primerApellido = p_primerApellido,
      segundoApellido = p_segundoApellido,
      segundoNombre = p_segundoNombre
  WHERE idFloristeria = p_idFloristeria
    AND contactoId = p_contactoId;

  RETURN 'Contacto actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_contacto(1, 1, 87654321, 'Carlos', 'Lopez', 'Martinez', 'Andres');

-- Issue: Función para eliminar CONTACTOS
CREATE OR REPLACE FUNCTION eliminar_contacto(
  p_idFloristeria NUMERIC,
  p_contactoId NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CONTACTOS
    WHERE idFloristeria = p_idFloristeria
      AND contactoId = p_contactoId
  ) THEN
    RETURN 'Contacto no encontrado.';
  END IF;

  DELETE FROM CONTACTOS
  WHERE idFloristeria = p_idFloristeria
    AND contactoId = p_contactoId;

  RETURN 'Contacto eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_contacto(1, 1);

-- Issue: AFILIACION Vista principal
CREATE OR REPLACE VIEW vista_afiliacion AS
SELECT
  idFloristeria,
  idSubastadora
FROM AFILIACION;

-- Issue: AFILIACION Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_afiliacion AS
SELECT
  a.idFloristeria,
  f.nombre AS nombreFloristeria,
  a.idSubastadora,
  s.nombreSubastadora
FROM AFILIACION a
JOIN FLORISTERIAS f ON a.idFloristeria = f.floristeriaId
JOIN SUBASTADORA s ON a.idSubastadora = s.subastadoraId;

-- Issue: Función para insertar AFILIACION
CREATE OR REPLACE FUNCTION insertar_afiliacion(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM FLORISTERIAS WHERE floristeriaId = p_idFloristeria) THEN
    RETURN 'Floristería no encontrada.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM SUBASTADORA WHERE subastadoraId = p_idSubastadora) THEN
    RETURN 'Subastadora no encontrada.';
  END IF;
  IF EXISTS (
    SELECT 1 FROM AFILIACION 
    WHERE idFloristeria = p_idFloristeria 
      AND idSubastadora = p_idSubastadora
  ) THEN
    RETURN 'Ya existe una afiliación entre la floristería y la subastadora.';
  END IF;

  INSERT INTO AFILIACION (
    idFloristeria, idSubastadora
  ) VALUES (
    p_idFloristeria, p_idSubastadora
  );

  RETURN 'Afiliación insertada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_afiliacion(1, 1, 1, '2023-01-01', 'Tipo A');

-- Issue: Función para actualizar AFILIACION
CREATE OR REPLACE FUNCTION actualizar_afiliacion(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM AFILIACION
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
  ) THEN
    RETURN 'Afiliación no encontrada.';
  END IF;

  -- Validar que no haya duplicidad
  IF EXISTS (
    SELECT 1 FROM AFILIACION
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
  ) THEN
    RETURN 'Ya existe una afiliación entre la floristería y la subastadora.';
  END IF;

  RETURN 'Afiliación actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_afiliacion(1, 1, 1, '2023-01-01', 'Tipo B');

-- Issue: Función para eliminar AFILIACION
CREATE OR REPLACE FUNCTION eliminar_afiliacion(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM AFILIACION
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
  ) THEN
    RETURN 'Afiliación no encontrada.';
  END IF;

  -- Verificar referencias en FACTURA (si aplica)
  IF EXISTS (
    SELECT 1 FROM FACTURA
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
  ) THEN
    RETURN 'No se puede eliminar la afiliación porque está referenciada en FACTURA.';
  END IF;

  DELETE FROM AFILIACION
  WHERE idFloristeria = p_idFloristeria
    AND idSubastadora = p_idSubastadora;

  RETURN 'Afiliación eliminada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_afiliacion(1, 1, 1);

-- Issue: FACTURA Vista principal
CREATE OR REPLACE VIEW vista_factura AS
SELECT
  idafiliacionfloristeria,
  idafiliacionsubastadora,
  facturaid,
  fechaEmision,
  montototal,
  numeroenvio
FROM FACTURA;

-- Issue: FACTURA Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_factura AS
SELECT
  f.idafiliacionfloristeria,
  fl.nombre AS nombreFloristeria,
  f.idafiliacionsubastadora,
  sb.nombreSubastadora,
  f.facturaid,
  f.fechaEmision,
  f.montoTotal
FROM FACTURA f
JOIN AFILIACION a ON f.idafiliacionfloristeria = a.idFloristeria
  AND f.idafiliacionsubastadora = a.idSubastadora
JOIN FLORISTERIAS fl ON a.idFloristeria = fl.floristeriaId
JOIN SUBASTADORA sb ON a.idSubastadora = sb.subastadoraId;

-- Issue: Función para insertar FACTURA
CREATE OR REPLACE FUNCTION insertar_factura(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC,
  p_idAfiliacion NUMERIC,
  p_numFactura NUMERIC,
  p_fechaEmision TIMESTAMP,
  p_montoTotal NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Validar formato de fecha
  IF p_fechaEmision::TEXT !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN
    RETURN 'Formato de fecha de emisión inválido. Debe ser "YYYY-MM-DD HH:MI:SS".';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM AFILIACION
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
      AND afiliacionId = p_idAfiliacion
  ) THEN
    RETURN 'Afiliación no encontrada.';
  END IF;

  INSERT INTO FACTURA (
    idFloristeria, idSubastadora, idAfiliacion,
    numFactura, fechaEmision, montoTotal
  ) VALUES (
    p_idFloristeria, p_idSubastadora, p_idAfiliacion,
    p_numFactura, p_fechaEmision, p_montoTotal
  );

  RETURN 'Factura insertada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_factura(1, 1, 1, 123, '2023-01-01', 1000);

-- Issue: Función para actualizar FACTURA
CREATE OR REPLACE FUNCTION actualizar_factura(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC,
  p_idAfiliacion NUMERIC,
  p_numFactura NUMERIC,
  p_fechaEmision TIMESTAMP,
  p_montoTotal NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  -- Validar formato de fecha
  IF p_fechaEmision::TEXT !~ '^\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}$' THEN
    RETURN 'Formato de fecha de emisión inválido. Debe ser "YYYY-MM-DD HH:MI:SS".';
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM FACTURA
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
      AND idAfiliacion = p_idAfiliacion
      AND numFactura = p_numFactura
  ) THEN
    RETURN 'Factura no encontrada.';
  END IF;

  UPDATE FACTURA
  SET fechaEmision = p_fechaEmision,
      montoTotal = p_montoTotal
  WHERE idFloristeria = p_idFloristeria
    AND idSubastadora = p_idSubastadora
    AND idAfiliacion = p_idAfiliacion
    AND numFactura = p_numFactura;

  RETURN 'Factura actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_factura(1, 1, 1, 123, '2023-01-01', 2000);

-- Issue: Función para eliminar FACTURA
CREATE OR REPLACE FUNCTION eliminar_factura(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC,
  p_idAfiliacion NUMERIC,
  p_numFactura NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM FACTURA
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
      AND idAfiliacion = p_idAfiliacion
      AND numFactura = p_numFactura
  ) THEN
    RETURN 'Factura no encontrada.';
  END IF;

  -- Verificar referencias en LOTE (si aplica)
  IF EXISTS (
    SELECT 1 FROM LOTE
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
      AND idAfiliacion = p_idAfiliacion
      AND idFactura = p_numFactura
  ) THEN
    RETURN 'No se puede eliminar la factura porque está referenciada en LOTE.';
  END IF;

  DELETE FROM FACTURA
  WHERE idFloristeria = p_idFloristeria
    AND idSubastadora = p_idSubastadora
    AND idAfiliacion = p_idAfiliacion
    AND numFactura = p_numFactura;

  RETURN 'Factura eliminada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_factura(1, 1, 1, 123);

-- Issue: LOTE Vista principal
CREATE OR REPLACE VIEW vista_lote AS
SELECT
  idCantidadContratoSubastadora,
  idCantidadContratoProductora,
  idCantidad_NContrato,
  idCantidadCatalogoProductora,
  idCantidadCorte,
  idCantidadvnb,
  NumLote,
  bi,
  cantidad,
  precioInicial,
  precioFinal,
  idFactura
FROM LOTE;

-- Issue: LOTE Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_lote AS
SELECT
  l.idCantidadContratoSubastadora,
  s.nombreSubastadora,
  l.idCantidadContratoProductora,
  p.nombreProductora,
  l.idCantidad_NContrato,
  l.idCantidadCatalogoProductora,
  p.nombreProductora AS nombreProductoraCat,
  l.idCantidadCorte,
  fc.nombreComun AS nombreFlor,
  l.idCantidadvnb,
  l.NumLote,
  l.bi,
  l.cantidad,
  l.precioInicial,
  l.precioFinal,
  l.idFactura,
  f.fechaEmision AS fechaFactura
FROM LOTE l
JOIN CANTIDAD_OFRECIDA co ON l.idCantidadContratoSubastadora = co.idContratoSubastadora
  AND l.idCantidadContratoProductora = co.idContratoProductora
  AND l.idCantidad_NContrato = co.idNContrato
  AND l.idCantidadCatalogoProductora = co.idCatalogoProductora
  AND l.idCantidadCorte = co.idCatalogoCorte
  AND l.idCantidadvnb = co.idVnb
JOIN CONTRATO c ON co.idContratoSubastadora = c.idSubastadora
  AND co.idContratoProductora = c.idProductora
  AND co.idNContrato = c.nContrato
JOIN SUBASTADORA s ON c.idSubastadora = s.subastadoraId
JOIN PRODUCTORAS p ON c.idProductora = p.productoraId
JOIN CATALOGOPRODUCTOR cp ON co.idCatalogoProductora = cp.idProductora
  AND co.idCatalogoCorte = cp.idCorte
  AND co.idVnb = cp.vbn
JOIN FLOR_CORTES fc ON cp.idCorte = fc.corteId
JOIN FACTURA f ON l.idFactura = f.facturaId;

-- Issue: Función para insertar LOTE
CREATE OR REPLACE FUNCTION insertar_lote(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC,
  p_idAfiliacion NUMERIC,
  p_idFactura NUMERIC,
  p_loteId NUMERIC,
  p_fechaLote DATE
)
RETURNS TEXT AS $$
BEGIN
  -- Verificar si existe la factura
  IF NOT EXISTS (
    SELECT 1 FROM FACTURA
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
      AND idAfiliacion = p_idAfiliacion
      AND numFactura = p_idFactura
  ) THEN
    RETURN 'Factura no encontrada para asociar al lote.';
  END IF;

  INSERT INTO LOTE (
    idFloristeria, idSubastadora, idAfiliacion,
    idFactura, loteId, fechaLote
  ) VALUES (
    p_idFloristeria, p_idSubastadora, p_idAfiliacion,
    p_idFactura, p_loteId, p_fechaLote
  );

  RETURN 'Lote insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT insertar_lote(1, 1, 1, 123, 1, '2023-01-01');

-- Issue: Función para actualizar LOTE
CREATE OR REPLACE FUNCTION actualizar_lote(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC,
  p_idAfiliacion NUMERIC,
  p_idFactura NUMERIC,
  p_loteId NUMERIC,
  p_fechaLote DATE
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM LOTE
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
      AND idAfiliacion = p_idAfiliacion
      AND idFactura = p_idFactura
      AND loteId = p_loteId
  ) THEN
    RETURN 'Lote no encontrado.';
  END IF;

  UPDATE LOTE
  SET fechaLote = p_fechaLote
  WHERE idFloristeria = p_idFloristeria
    AND idSubastadora = p_idSubastadora
    AND idAfiliacion = p_idAfiliacion
    AND idFactura = p_idFactura
    AND loteId = p_loteId;

  RETURN 'Lote actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT actualizar_lote(1, 1, 1, 123, 1, '2023-01-01');

-- Issue: Función para eliminar LOTE
CREATE OR REPLACE FUNCTION eliminar_lote(
  p_idFloristeria NUMERIC,
  p_idSubastadora NUMERIC,
  p_idAfiliacion NUMERIC,
  p_idFactura NUMERIC,
  p_loteId NUMERIC
)
RETURNS TEXT AS $$
DECLARE
  v_msg TEXT;
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM LOTE
    WHERE idFloristeria = p_idFloristeria
      AND idSubastadora = p_idSubastadora
      AND idAfiliacion = p_idAfiliacion
      AND idFactura = p_idFactura
      AND loteId = p_loteId
  ) THEN
    RETURN 'Lote no encontrado.';
  END IF;

  -- Ejemplo de verificación adicional e incluir nombre de la ref (si existiera)
  IF EXISTS (
    SELECT 1 FROM CANTIDAD_OFRECIDA
    WHERE idContratoSubastadora = p_idSubastadora
  ) THEN
    v_msg := 'No se puede eliminar el Lote porque está relacionado con la subastadora ' 
             || p_idSubastadora;
    RETURN v_msg;
  END IF;

  DELETE FROM LOTE
  WHERE idFloristeria = p_idFloristeria
    AND idSubastadora = p_idSubastadora
    AND idAfiliacion = p_idAfiliacion
    AND idFactura = p_idFactura
    AND loteId = p_loteId;

  RETURN 'Lote eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Caso de prueba:
-- SELECT eliminar_lote(1, 1, 1, 123, 1);

-- Issue: CATALOGO_FLORISTERIA Vista principal
CREATE OR REPLACE VIEW vista_catalogo_floristeria AS
SELECT
  idFloristeria,
  codigo,
  idCorteFlor,
  idColor,
  nombrePropio,
  descripcion
FROM CATALOGO_FLORISTERIA;

-- Issue: CATALOGO_FLORISTERIA Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_catalogo_floristeria AS
SELECT
  cf.idFloristeria,
  f.nombre AS nombreFloristeria,
  cf.codigo,
  fc.nombreComun AS nombreFlor,
  c.Nombre AS nombreColor,
  cf.nombrePropio,
  cf.descripcion
FROM CATALOGO_FLORISTERIA cf
JOIN FLORISTERIAS f ON cf.idFloristeria = f.floristeriaId
JOIN FLOR_CORTES fc ON cf.idCorteFlor = fc.corteId
JOIN COLOR c ON cf.idColor = c.colorId;

-- Issue: Función para insertar CATALOGO_FLORISTERIA
CREATE OR REPLACE FUNCTION insertar_catalogo_floristeria(
  p_idFloristeria NUMERIC,
  p_codigo NUMERIC,
  p_idCorteFlor NUMERIC,
  p_idColor NUMERIC,
  p_nombrePropio VARCHAR,
  p_descripcion VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que la floristería, corte y color existan
  IF NOT EXISTS (SELECT 1 FROM FLORISTERIAS WHERE floristeriaId = p_idFloristeria) THEN
    RETURN 'Floristería no encontrada.';
  END IF;
  IF NOT EXISTS (SELECT 1 FROM FLOR_CORTES WHERE corteId = p_idCorteFlor) THEN
    RETURN 'Flor no encontrada.';
  END IF;
  RETURN 'Histórico de precio de flor insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para actualizar CATALOGO_FLORISTERIA
CREATE OR REPLACE FUNCTION actualizar_catalogo_floristeria(
  p_idFloristeria NUMERIC,
  p_codigo NUMERIC,
  p_idCorteFlor NUMERIC,
  p_idColor NUMERIC,
  p_nombrePropio VARCHAR,
  p_descripcion VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CATALOGO_FLORISTERIA
    WHERE idFloristeria = p_idFloristeria
      AND codigo = p_codigo
  ) THEN
    RETURN 'Catálogo de floristería no encontrado.';
  END IF;
  UPDATE CATALOGO_FLORISTERIA
  SET idCorteFlor = p_idCorteFlor,
      idColor = p_idColor,
      nombrePropio = p_nombrePropio,
      descripcion = p_descripcion
  WHERE idFloristeria = p_idFloristeria
    AND codigo = p_codigo;
  RETURN 'Catálogo de floristería actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;
-- Issue: Función para eliminar CATALOGO_FLORISTERIA
CREATE OR REPLACE FUNCTION eliminar_catalogo_floristeria(
  p_idFloristeria NUMERIC,
  p_codigo NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM CATALOGO_FLORISTERIA
    WHERE idFloristeria = p_idFloristeria
      AND codigo = p_codigo
  ) THEN
    RETURN 'Catálogo de floristería no encontrado.';
  END IF;
  -- Verificar referencias en otras tablas
  IF EXISTS (
    SELECT 1 FROM DETALLE_BOUQUET
    WHERE idCatalogoFloristeria = p_idFloristeria
      AND idCatalogocodigo = p_codigo
  ) THEN
    RETURN 'No se puede eliminar el catálogo porque está referenciado en la tabla DETALLE_BOUQUET.';
  END IF;
  DELETE FROM CATALOGO_FLORISTERIA
  WHERE idFloristeria = p_idFloristeria
    AND codigo = p_codigo;
  RETURN 'Catálogo de floristería eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: HISTORICO_PRECIO_FLOR Vista principal
CREATE OR REPLACE VIEW vista_historico_precio_flor AS
SELECT
  idCatalogoFloristeria,
  idCatalogocodigo,
  fechaInicio,
  fechaFin,
  precio,
  tamanoTallo
FROM HISTORICO_PRECIO_FLOR;

-- Issue: HISTORICO_PRECIO_FLOR Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_historico_precio_flor AS
SELECT
  hp.idCatalogoFloristeria,
  f.nombre AS nombreFloristeria,
  hp.idCatalogocodigo,
  cf.nombrePropio AS nombreFlor,
  hp.fechaInicio,
  hp.fechaFin,
  hp.precio,
  hp.tamanoTallo
FROM HISTORICO_PRECIO_FLOR hp
JOIN CATALOGO_FLORISTERIA cf ON hp.idCatalogoFloristeria = cf.idFloristeria
  AND hp.idCatalogocodigo = cf.codigo
JOIN FLORISTERIAS f ON cf.idFloristeria = f.floristeriaId;

-- Issue: Función para insertar HISTORICO_PRECIO_FLOR
CREATE OR REPLACE FUNCTION insertar_historico_precio_flor(
  p_idCatalogoFloristeria NUMERIC,
  p_idCatalogocodigo NUMERIC,
  p_fechaInicio DATE,
  p_precio NUMERIC,
  p_fechaFin DATE DEFAULT NULL,
  p_tamanoTallo NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el catálogo de floristería exista
  IF NOT EXISTS (
    SELECT 1 FROM CATALOGO_FLORISTERIA
    WHERE idFloristeria = p_idCatalogoFloristeria
      AND codigo = p_idCatalogocodigo
  ) THEN
    RETURN 'Catálogo de floristería no encontrado.';
  END IF;
  -- Insertar el nuevo registro histórico de precio de flor
  INSERT INTO HISTORICO_PRECIO_FLOR (
    idCatalogoFloristeria, idCatalogocodigo, fechaInicio, fechaFin, precio, tamanoTallo
  ) VALUES (
    p_idCatalogoFloristeria, p_idCatalogocodigo, p_fechaInicio, p_fechaFin, p_precio, p_tamanoTallo
  );
  RETURN 'Histórico de precio de flor insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para actualizar HISTORICO_PRECIO_FLOR
CREATE OR REPLACE FUNCTION actualizar_historico_precio_flor(
  p_idCatalogoFloristeria NUMERIC,
  p_idCatalogocodigo NUMERIC,
  p_fechaInicio DATE,
  p_precio NUMERIC,
  p_fechaFin DATE DEFAULT NULL,
  p_tamanoTallo NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM HISTORICO_PRECIO_FLOR
    WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
      AND idCatalogocodigo = p_idCatalogocodigo
      AND fechaInicio = p_fechaInicio
  ) THEN
    RETURN 'Histórico de precio de flor no encontrado.';
  END IF;

  UPDATE HISTORICO_PRECIO_FLOR
  SET fechaFin = p_fechaFin,
      precio = p_precio,
      tamanoTallo = p_tamanoTallo
  WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
    AND idCatalogocodigo = p_idCatalogocodigo
    AND fechaInicio = p_fechaInicio;

  RETURN 'Histórico de precio de flor actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para eliminar HISTORICO_PRECIO_FLOR
CREATE OR REPLACE FUNCTION eliminar_historico_precio_flor(
  p_idCatalogoFloristeria NUMERIC,
  p_idCatalogocodigo NUMERIC,
  p_fechaInicio DATE
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM HISTORICO_PRECIO_FLOR
    WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
      AND idCatalogocodigo = p_idCatalogocodigo
      AND fechaInicio = p_fechaInicio
  ) THEN
    RETURN 'Histórico de precio de flor no encontrado.';
  END IF;

  DELETE FROM HISTORICO_PRECIO_FLOR
  WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
    AND idCatalogocodigo = p_idCatalogocodigo
    AND fechaInicio = p_fechaInicio;

  RETURN 'Histórico de precio de flor eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: DETALLE_BOUQUET Vista principal
CREATE OR REPLACE VIEW vista_detalle_bouquet AS
SELECT
  idCatalogoFloristeria,
  idCatalogocodigo,
  bouquetId,
  cantidad,
  talloTamano,
  descripcion
FROM DETALLE_BOUQUET;

-- Issue: DETALLE_BOUQUET Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_detalle_bouquet AS
SELECT
  db.idCatalogoFloristeria,
  f.nombre AS nombreFloristeria,
  db.idCatalogocodigo,
  cf.nombrePropio AS nombreFlor,
  db.bouquetId,
  db.cantidad,
  db.talloTamano,
  db.descripcion
FROM DETALLE_BOUQUET db
JOIN CATALOGO_FLORISTERIA cf ON db.idCatalogoFloristeria = cf.idFloristeria
  AND db.idCatalogocodigo = cf.codigo
JOIN FLORISTERIAS f ON cf.idFloristeria = f.floristeriaId;

-- Issue: Función para insertar DETALLE_BOUQUET
CREATE OR REPLACE FUNCTION insertar_detalle_bouquet(
  p_idCatalogoFloristeria NUMERIC,
  p_idCatalogocodigo NUMERIC,
  p_bouquetId NUMERIC,
  p_cantidad NUMERIC,
  p_talloTamano NUMERIC DEFAULT NULL,
  p_descripcion VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que el catálogo de floristería exista
  IF NOT EXISTS (
    SELECT 1 FROM CATALOGO_FLORISTERIA
    WHERE idFloristeria = p_idCatalogoFloristeria
      AND codigo = p_idCatalogocodigo
  ) THEN
    RETURN 'Catálogo de floristería no encontrado.';
  END IF;

  -- Insertar el nuevo detalle de bouquet
  INSERT INTO DETALLE_BOUQUET (
    idCatalogoFloristeria, idCatalogocodigo, bouquetId, cantidad, talloTamano, descripcion
  ) VALUES (
    p_idCatalogoFloristeria, p_idCatalogocodigo, p_bouquetId, p_cantidad, p_talloTamano, p_descripcion
  );

  RETURN 'Detalle de bouquet insertado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para actualizar DETALLE_BOUQUET
CREATE OR REPLACE FUNCTION actualizar_detalle_bouquet(
  p_idCatalogoFloristeria NUMERIC,
  p_idCatalogocodigo NUMERIC,
  p_bouquetId NUMERIC,
  p_cantidad NUMERIC,
  p_talloTamano NUMERIC DEFAULT NULL,
  p_descripcion VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM DETALLE_BOUQUET
    WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
      AND idCatalogocodigo = p_idCatalogocodigo
      AND bouquetId = p_bouquetId
  ) THEN
    RETURN 'Detalle de bouquet no encontrado.';
  END IF;

  UPDATE DETALLE_BOUQUET
  SET cantidad = p_cantidad,
      talloTamano = p_talloTamano,
      descripcion = p_descripcion
  WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
    AND idCatalogocodigo = p_idCatalogocodigo
    AND bouquetId = p_bouquetId;

  RETURN 'Detalle de bouquet actualizado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para eliminar DETALLE_BOUQUET
CREATE OR REPLACE FUNCTION eliminar_detalle_bouquet(
  p_idCatalogoFloristeria NUMERIC,
  p_idCatalogocodigo NUMERIC,
  p_bouquetId NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM DETALLE_BOUQUET
    WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
      AND idCatalogocodigo = p_idCatalogocodigo
      AND bouquetId = p_bouquetId
  ) THEN
    RETURN 'Detalle de bouquet no encontrado.';
  END IF;

  DELETE FROM DETALLE_BOUQUET
  WHERE idCatalogoFloristeria = p_idCatalogoFloristeria
    AND idCatalogocodigo = p_idCatalogocodigo
    AND bouquetId = p_bouquetId;

  RETURN 'Detalle de bouquet eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: FACTURA_FINAL Vista principal
CREATE OR REPLACE VIEW vista_factura_final AS
SELECT
  idFloristeria,
  numFactura,
  fechaEmision,
  montoTotal,
  idClienteNatural,
  idClienteJuridico
FROM FACTURA_FINAL;

-- Issue: FACTURA_FINAL Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_factura_final AS
SELECT
    ff.idFloristeria,
    f.nombre AS nombreFloristeria,
    ff.numFactura,
    ff.fechaEmision,
    ff.montoTotal,
    cn.documentoIdentidad AS documentoClienteNatural,
    cn.primernombre AS primerNombreClienteNatural,
    cn.primerApellido AS primerApellidoClienteNatural,
    cj.RIF AS documentoClienteJuridico,
    cj.nombre AS nombreClienteJuridico
FROM FACTURA_FINAL ff
JOIN FLORISTERIAS f ON ff.idFloristeria = f.floristeriaId
LEFT JOIN CLIENTE_NATURAL cn ON ff.idClienteNatural = cn.cliNaturalId
LEFT JOIN CLIENTE_JURIDICO cj ON ff.idClienteJuridico = cj.cliJuridicoId;

-- Issue: Función para insertar FACTURA_FINAL
CREATE OR REPLACE FUNCTION insertar_factura_final(
  p_idFloristeria NUMERIC,
  p_numFactura NUMERIC,
  p_fechaEmision DATE,
  p_montoTotal NUMERIC,
  p_idClienteNatural NUMERIC DEFAULT NULL,
  p_idClienteJuridico NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que la floristería exista
  IF NOT EXISTS (SELECT 1 FROM FLORISTERIAS WHERE floristeriaId = p_idFloristeria) THEN
    RETURN 'Floristería no encontrada.';
  END IF;

  -- Validar que solo uno de los campos idClienteNatural o idClienteJuridico tenga un valor
  IF p_idClienteNatural IS NOT NULL AND p_idClienteJuridico IS NOT NULL THEN
    RETURN 'Solo uno de los campos idClienteNatural o idClienteJuridico debe tener un valor.';
  END IF;

  -- Insertar la nueva factura final
  INSERT INTO FACTURA_FINAL (
    idFloristeria, numFactura, fechaEmision, montoTotal, idClienteNatural, idClienteJuridico
  ) VALUES (
    p_idFloristeria, p_numFactura, p_fechaEmision, p_montoTotal, p_idClienteNatural, p_idClienteJuridico
  );

  RETURN 'Factura final insertada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para actualizar FACTURA_FINAL
CREATE OR REPLACE FUNCTION actualizar_factura_final(
  p_idFloristeria NUMERIC,
  p_numFactura NUMERIC,
  p_fechaEmision DATE,
  p_montoTotal NUMERIC,
  p_idClienteNatural NUMERIC DEFAULT NULL,
  p_idClienteJuridico NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM FACTURA_FINAL
    WHERE idFloristeria = p_idFloristeria
      AND numFactura = p_numFactura
  ) THEN
    RETURN 'Factura final no encontrada.';
  END IF;

  -- Validar que solo uno de los campos idClienteNatural o idClienteJuridico tenga un valor
  IF p_idClienteNatural IS NOT NULL AND p_idClienteJuridico IS NOT NULL THEN
    RETURN 'Solo uno de los campos idClienteNatural o idClienteJuridico debe tener un valor.';
  END IF;

  UPDATE FACTURA_FINAL
  SET fechaEmision = p_fechaEmision,
      montoTotal = p_montoTotal,
      idClienteNatural = p_idClienteNatural,
      idClienteJuridico = p_idClienteJuridico
  WHERE idFloristeria = p_idFloristeria
    AND numFactura = p_numFactura;

  RETURN 'Factura final actualizada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para eliminar FACTURA_FINAL
CREATE OR REPLACE FUNCTION eliminar_factura_final(
  p_idFloristeria NUMERIC,
  p_numFactura NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM FACTURA_FINAL
    WHERE idFloristeria = p_idFloristeria
      AND numFactura = p_numFactura
  ) THEN
    RETURN 'Factura final no encontrada.';
  END IF;

  -- Verificar referencias en DETALLE_FACTURA (si aplica)
  IF EXISTS (
    SELECT 1 FROM DETALLE_FACTURA
    WHERE idFActuraFloristeria = p_idFloristeria
      AND idNumFactura = p_numFactura
  ) THEN
    RETURN 'No se puede eliminar la factura final porque está referenciada en DETALLE_FACTURA.';
  END IF;

  DELETE FROM FACTURA_FINAL
  WHERE idFloristeria = p_idFloristeria
    AND numFactura = p_numFactura;

  RETURN 'Factura final eliminada exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: DETALLE_FACTURA Vista principal
CREATE OR REPLACE VIEW vista_detalle_factura AS
SELECT
  idFActuraFloristeria,
  idNumFactura,
  detalleId,
  catalogoFloristeria,
  catalogoCodigo,
  bouquetFloristeria,
  bouquetcodigo,
  bouquetId,
  cantidad,
  valoracionPrecio,
  valorancionCalidad,
  valoracionPromedio,
  detalles
FROM DETALLE_FACTURA;

-- Issue: DETALLE_FACTURA Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_detalle_factura AS
SELECT
  df.idFActuraFloristeria,
  f.nombre AS nombreFloristeria,
  df.idNumFactura,
  df.detalleId,
  cf.nombrePropio AS nombreFlor,
  db.descripcion AS descripcionBouquet,
  df.cantidad,
  df.valoracionPrecio,
  df.valorancionCalidad,
  df.valoracionPromedio,
  df.detalles
FROM DETALLE_FACTURA df
JOIN FACTURA_FINAL ff ON df.idFActuraFloristeria = ff.idFloristeria
  AND df.idNumFactura = ff.numFactura
LEFT JOIN CATALOGO_FLORISTERIA cf ON df.catalogoFloristeria = cf.idFloristeria
  AND df.catalogoCodigo = cf.codigo
LEFT JOIN DETALLE_BOUQUET db ON df.bouquetFloristeria = db.idCatalogoFloristeria
  AND df.bouquetcodigo = db.idCatalogocodigo
  AND df.bouquetId = db.bouquetId
JOIN FLORISTERIAS f ON ff.idFloristeria = f.floristeriaId;

-- Issue: Función para insertar DETALLE_FACTURA
CREATE OR REPLACE FUNCTION insertar_detalle_factura(
  p_idFActuraFloristeria NUMERIC,
  p_idNumFactura NUMERIC,
  p_detalleId NUMERIC,
  p_catalogoFloristeria NUMERIC DEFAULT NULL,
  p_catalogoCodigo NUMERIC DEFAULT NULL,
  p_bouquetFloristeria NUMERIC DEFAULT NULL,
  p_bouquetcodigo NUMERIC DEFAULT NULL,
  p_bouquetId NUMERIC DEFAULT NULL,
  p_cantidad NUMERIC DEFAULT NULL,
  p_valoracionPrecio NUMERIC DEFAULT NULL,
  p_valorancionCalidad NUMERIC DEFAULT NULL,
  p_valoracionPromedio NUMERIC DEFAULT NULL,
  p_detalles VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que solo uno de los campos catalogoFloristeria/catalogoCodigo o bouquetFloristeria/bouquetcodigo/bouquetId tenga un valor
  IF (p_catalogoFloristeria IS NOT NULL AND p_catalogoCodigo IS NOT NULL AND p_bouquetFloristeria IS NULL AND p_bouquetcodigo IS NULL AND p_bouquetId IS NULL) OR 
     (p_catalogoFloristeria IS NULL AND p_catalogoCodigo IS NULL AND p_bouquetFloristeria IS NOT NULL AND p_bouquetcodigo IS NOT NULL AND p_bouquetId IS NOT NULL) THEN
    -- Insertar el nuevo detalle de factura
    INSERT INTO DETALLE_FACTURA (
      idFActuraFloristeria, idNumFactura, detalleId, catalogoFloristeria, catalogoCodigo, 
      bouquetFloristeria, bouquetcodigo, bouquetId, cantidad, valoracionPrecio, 
      valorancionCalidad, valoracionPromedio, detalles
    ) VALUES (
      p_idFActuraFloristeria, p_idNumFactura, p_detalleId, p_catalogoFloristeria, p_catalogoCodigo, 
      p_bouquetFloristeria, p_bouquetcodigo, p_bouquetId, p_cantidad, p_valoracionPrecio, 
      p_valorancionCalidad, p_valoracionPromedio, p_detalles
    );

    RETURN 'Detalle de factura insertado exitosamente.';
  ELSE
    RETURN 'Debe proporcionar valores válidos para catalogoFloristeria/catalogoCodigo o bouquetFloristeria/bouquetcodigo/bouquetId.';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para actualizar DETALLE_FACTURA
CREATE OR REPLACE FUNCTION actualizar_detalle_factura(
  p_idFActuraFloristeria NUMERIC,
  p_idNumFactura NUMERIC,
  p_detalleId NUMERIC,
  p_catalogoFloristeria NUMERIC DEFAULT NULL,
  p_catalogoCodigo NUMERIC DEFAULT NULL,
  p_bouquetFloristeria NUMERIC DEFAULT NULL,
  p_bouquetcodigo NUMERIC DEFAULT NULL,
  p_bouquetId NUMERIC DEFAULT NULL,
  p_cantidad NUMERIC DEFAULT NULL,
  p_valoracionPrecio NUMERIC DEFAULT NULL,
  p_valorancionCalidad NUMERIC DEFAULT NULL,
  p_valoracionPromedio NUMERIC DEFAULT NULL,
  p_detalles VARCHAR DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM DETALLE_FACTURA
    WHERE idFActuraFloristeria = p_idFActuraFloristeria
      AND idNumFactura = p_idNumFactura
      AND detalleId = p_detalleId
  ) THEN
    RETURN 'Detalle de factura no encontrado.';
  END IF;

  -- Validar que solo uno de los campos catalogoFloristeria/catalogoCodigo o bouquetFloristeria/bouquetcodigo/bouquetId tenga un valor
  IF (p_catalogoFloristeria IS NOT NULL AND p_catalogoCodigo IS NOT NULL AND p_bouquetFloristeria IS NULL AND p_bouquetcodigo IS NULL AND p_bouquetId IS NULL) OR 
     (p_catalogoFloristeria IS NULL AND p_catalogoCodigo IS NULL AND p_bouquetFloristeria IS NOT NULL AND p_bouquetcodigo IS NOT NULL AND p_bouquetId IS NOT NULL) THEN
    -- Actualizar el detalle de factura
    UPDATE DETALLE_FACTURA
    SET catalogoFloristeria = p_catalogoFloristeria,
        catalogoCodigo = p_catalogoCodigo,
        bouquetFloristeria = p_bouquetFloristeria,
        bouquetcodigo = p_bouquetcodigo,
        bouquetId = p_bouquetId,
        cantidad = p_cantidad,
        valoracionPrecio = p_valoracionPrecio,
        valorancionCalidad = p_valorancionCalidad,
        valoracionPromedio = p_valoracionPromedio,
        detalles = p_detalles
    WHERE idFActuraFloristeria = p_idFActuraFloristeria
      AND idNumFactura = p_idNumFactura
      AND detalleId = p_detalleId;

    RETURN 'Detalle de factura actualizado exitosamente.';
  ELSE
    RETURN 'Debe proporcionar valores válidos para catalogoFloristeria/catalogoCodigo o bouquetFloristeria/bouquetcodigo/bouquetId.';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para eliminar DETALLE_FACTURA
CREATE OR REPLACE FUNCTION eliminar_detalle_factura(
  p_idFActuraFloristeria NUMERIC,
  p_idNumFactura NUMERIC,
  p_detalleId NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM DETALLE_FACTURA
    WHERE idFActuraFloristeria = p_idFActuraFloristeria
      AND idNumFactura = p_idNumFactura
      AND detalleId = p_detalleId
  ) THEN
    RETURN 'Detalle de factura no encontrado.';
  END IF;

  DELETE FROM DETALLE_FACTURA
  WHERE idFActuraFloristeria = p_idFActuraFloristeria
    AND idNumFactura = p_idNumFactura
    AND detalleId = p_detalleId;

  RETURN 'Detalle de factura eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;

-- Issue: TELEFONOS Vista principal
CREATE OR REPLACE VIEW vista_telefonos AS
SELECT
  codPais,
  codArea,
  numero,
  idSubastadora,
  idProductora,
  idFloristeria
FROM TELEFONOS;

-- Issue: TELEFONOS Vista de detalles
CREATE OR REPLACE VIEW vista_detalles_telefonos AS
SELECT
  t.codPais,
  t.codArea,
  t.numero,
  s.nombreSubastadora,
  p.nombreProductora,
  f.nombre AS nombreFloristeria
FROM TELEFONOS t
LEFT JOIN SUBASTADORA s ON t.idSubastadora = s.subastadoraId
LEFT JOIN PRODUCTORAS p ON t.idProductora = p.productoraId
LEFT JOIN FLORISTERIAS f ON t.idFloristeria = f.floristeriaId;

-- Issue: Función para insertar TELEFONOS
CREATE OR REPLACE FUNCTION insertar_telefono(
  p_codPais NUMERIC,
  p_codArea NUMERIC,
  p_numero NUMERIC,
  p_idSubastadora NUMERIC DEFAULT NULL,
  p_idProductora NUMERIC DEFAULT NULL,
  p_idFloristeria NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  -- Validar que solo uno de los campos idSubastadora, idProductora o idFloristeria tenga un valor
  IF (p_idSubastadora IS NOT NULL AND p_idProductora IS NULL AND p_idFloristeria IS NULL) OR
     (p_idSubastadora IS NULL AND p_idProductora IS NOT NULL AND p_idFloristeria IS NULL) OR
     (p_idSubastadora IS NULL AND p_idProductora IS NULL AND p_idFloristeria IS NOT NULL) THEN
    -- Insertar el nuevo teléfono
    INSERT INTO TELEFONOS (
      codPais, codArea, numero, idSubastadora, idProductora, idFloristeria
    ) VALUES (
      p_codPais, p_codArea, p_numero, p_idSubastadora, p_idProductora, p_idFloristeria
    );

    RETURN 'Teléfono insertado exitosamente.';
  ELSE
    RETURN 'Debe proporcionar un valor válido para idSubastadora, idProductora o idFloristeria.';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para actualizar TELEFONOS
CREATE OR REPLACE FUNCTION actualizar_telefono(
  p_codPais NUMERIC,
  p_codArea NUMERIC,
  p_numero NUMERIC,
  p_idSubastadora NUMERIC DEFAULT NULL,
  p_idProductora NUMERIC DEFAULT NULL,
  p_idFloristeria NUMERIC DEFAULT NULL
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM TELEFONOS
    WHERE codPais = p_codPais
      AND codArea = p_codArea
      AND numero = p_numero
  ) THEN
    RETURN 'Teléfono no encontrado.';
  END IF;

  -- Validar que solo uno de los campos idSubastadora, idProductora o idFloristeria tenga un valor
  IF (p_idSubastadora IS NOT NULL AND p_idProductora IS NULL AND p_idFloristeria IS NULL) OR
     (p_idSubastadora IS NULL AND p_idProductora IS NOT NULL AND p_idFloristeria IS NULL) OR
     (p_idSubastadora IS NULL AND p_idProductora IS NULL AND p_idFloristeria IS NOT NULL) THEN
    -- Actualizar el teléfono
    UPDATE TELEFONOS
    SET idSubastadora = p_idSubastadora,
        idProductora = p_idProductora,
        idFloristeria = p_idFloristeria
    WHERE codPais = p_codPais
      AND codArea = p_codArea
      AND numero = p_numero;

    RETURN 'Teléfono actualizado exitosamente.';
  ELSE
    RETURN 'Debe proporcionar un valor válido para idSubastadora, idProductora o idFloristeria.';
  END IF;
END;
$$ LANGUAGE plpgsql;

-- Issue: Función para eliminar TELEFONOS
CREATE OR REPLACE FUNCTION eliminar_telefono(
  p_codPais NUMERIC,
  p_codArea NUMERIC,
  p_numero NUMERIC
)
RETURNS TEXT AS $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM TELEFONOS
    WHERE codPais = p_codPais
      AND codArea = p_codArea
      AND numero = p_numero
  ) THEN
    RETURN 'Teléfono no encontrado.';
  END IF;

  DELETE FROM TELEFONOS
  WHERE codPais = p_codPais
    AND codArea = p_codArea
    AND numero = p_numero;

  RETURN 'Teléfono eliminado exitosamente.';
END;
$$ LANGUAGE plpgsql;


--------------------------------------------------------- fin vistas --------------------------

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


-----------------------------------------------------------------------
-- REQUERIMIENTO 2 - GANANCIAS NETAS UNA FLORISTERIA --
-----------------------------------------------------------------------


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

SELECT * FROM ganancias_floristeria(2, '2023-09-01');

/* Funcion adicional que llama la anterioir para los 12 meses del anio*/

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

SELECT * FROM fn_ganancias_por_anio(2,2023)

/* FIN DEL REQUERIMIENTO 2 */