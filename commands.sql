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
(3, 3, 1003, 3, 3, 3 ,300);

-- Verificar los datos insertados
SELECT * FROM CANTIDAD_OFRECIDA;



-- Insertar datos de prueba en la tabla CONTACTOS

INSERT INTO CONTACTOS (idFloristeria, contactoId, documentoIdentidad, primerNombre, primerApellido, segundoApellido, segundoNombre) VALUES 
(1, 5, 667788990, 'Charlie', 'Black', 'Taylor', 'James'),
(2, 4, 554433221, 'Bob', 'White', 'Jones', 'David'),
(3, 1, 123456789, 'John', 'Doe', 'Smith', 'Michael'),
(4, 2, 987654321, 'Jane', 'Doe', 'Johnson', 'Emily');

-- Verificar los datos insertados
SELECT * FROM CONTACTOS;

-- Insertar datos de prueba en la tabla AFILIACION
INSERT INTO AFILIACION (idFloristeria, idSubastadora) VALUES 
(1, 1),
(2, 2),
(3, 3);

-- Verificar los datos insertados
SELECT * FROM AFILIACION;


-- Insertar datos de prueba en la tabla FACTURA
INSERT INTO FACTURA (facturaId, idAfiliacionFloristeria, idAfiliacionSubastadora, fechaEmision, montoTotal, numeroEnvio) VALUES
(1, 1, 1, '2021-01-18 16:00:00', 10000.00, NULL),
(2, 1, 1, '2021-02-15 16:00:00', 1100.00, 3232),
(3, 2, 2, '2023-05-01 16:00:00', 750.00, 12346),
(4, 3, 3, '2023-06-01 16:00:00', 1000.00, 12347);

-- Verificar los datos insertados
SELECT * FROM FACTURA;


SELECT MontoComision( 1001, '2021-01-10');

-- Insertar datos de prueba en la tabla PAGOS
SELECT insertar_Pago(1, 1, 1001, '2021-02-10', 50.00, 'Pago');
SELECT insertar_Pago(1, 1, 1001, '2021-03-03', 220.00, 'multa');
SELECT insertar_Pago(1, 1, 1001, '2021-03-15', 5.5, 'Pago');


-- Verificar los datos insertados
SELECT * FROM PAGOS;

-- Insertar datos de prueba en la tabla LOTE
INSERT INTO LOTE (idCantidadContratoSubastadora, idCantidadContratoProductora, idCantidad_NContrato, idCantidadCatalogoProductora, idCantidadCorte, idCantidadvnb, NumLote, bi, cantidad, precioInicial, precioFinal, idFactura) VALUES
(1, 1, 1001, 1, 1, 1, 1, 1, 50, 10.00, 15.00, 1),
(2, 2, 1002, 2, 2, 2, 2, 2, 100, 20.00, 25.00, 2),
(3, 3, 1003, 3, 3, 3, 3, 3, 150, 30.00, 35.00, 3);

-- Verificar los datos insertados
SELECT * FROM LOTE;


-- Insertar datos de prueba en la tabla CATALOGO_FLORISTERIA
INSERT INTO CATALOGO_FLORISTERIA (idFloristeria, codigo, idCorteFlor, idColor, nombrePropio, descripcion) VALUES
(1, 1, 1, 2, 'Rosa Roja', 'Rosa roja clásica para ocasiones románticas'),
(2, 2, 2, 3, 'Tulipán Amarillo', 'Tulipán amarillo brillante para alegrar el día'),
(3, 3, 3, 4, 'Orquídea Púrpura', 'Orquídea exótica y elegante en color púrpura'),
(4, 4, 4, 5, 'Girasol', 'Girasol alto y brillante que sigue al sol'),
(5, 5, 5, 6, 'Lirio Blanco', 'Lirio blanco elegante y fragante para cualquier ocasión');

-- Verificar los datos insertados
SELECT * FROM CATALOGO_FLORISTERIA;


-- Insertar datos de prueba en la tabla HISTORICO_PRECIO_FLOR
INSERT INTO HISTORICO_PRECIO_FLOR (idCatalogoFloristeria, idCatalogocodigo, fechaInicio, fechaFin, precio, tamanoTallo) VALUES
(1, 1, '2023-01-01', NULL, 10.00, 50),
(2, 2, '2023-01-01', NULL, 15.00, 60),
(3, 3, '2023-01-01', NULL, 20.00, 70),
(4, 4, '2023-01-01', NULL, 25.00, 80),
(5, 5, '2023-01-01', NULL, 30.00, 90);

-- Verificar los datos insertados
SELECT * FROM HISTORICO_PRECIO_FLOR;


-- Insertar datos de prueba en la tabla DETALLE_BOUQUET
INSERT INTO DETALLE_BOUQUET (idCatalogoFloristeria, idCatalogocodigo, bouquetId, cantidad, talloTamano, descripcion) VALUES
(1, 1, 1, 10, 50, 'Bouquet de rosas rojas'),
(2, 2, 2, 15, 60, 'Bouquet de tulipanes amarillos'),
(3, 3, 3, 20, 70, 'Bouquet de orquídeas púrpuras'),
(4, 4, 4, 25, 80, 'Bouquet de girasoles'),
(5, 5, 5, 30, 90, 'Bouquet de lirios blancos');

-- Verificar los datos insertados
SELECT * FROM DETALLE_BOUQUET;


-- Insertar datos de prueba en la tabla FACTURA_FINAL
INSERT INTO FACTURA_FINAL (idFloristeria, numFactura, fechaEmision, montoTotal, idClienteNatural, idClienteJuridico) VALUES
(1, 1, '2023-07-01', 500.00, 1, NULL),
(2, 2, '2023-08-01', 750.00, NULL, 1),
(3, 3, '2023-09-01', 1000.00, 2, NULL),
(4, 4, '2023-10-01', 1250.00, NULL, 2),
(5, 5, '2023-11-01', 1500.00, 3, NULL);

-- Verificar los datos insertados
SELECT * FROM FACTURA_FINAL;


-- Insertar datos de prueba en la tabla DETALLE_FACTURA
INSERT INTO DETALLE_FACTURA (idFActuraFloristeria, idNumFactura, detalleId, catalogoFloristeria, catalogoCodigo, bouquetFloristeria, bouquetcodigo, bouquetId, cantidad, valoracionPrecio, valorancionCalidad, valoracionPromedio, detalles) VALUES
(1, 1, 1, 1, 1, NULL, NULL, NULL, 10, 9.5, 9.0, 9.25, 'Rosa Roja de alta calidad'),
(2, 2, 2, NULL, NULL, 2, 2, 2, 15, 8.5, 8.0, 8.25, 'Bouquet de tulipanes amarillos'),
(3, 3, 3, 3, 3, NULL, NULL, NULL, 20, 9.0, 9.5, 9.25, 'Orquídea Púrpura exótica'),
(4, 4, 4, NULL, NULL, 4, 4, 4, 25, 8.0, 8.5, 8.25, 'Bouquet de girasoles'),
(5, 5, 5, 5, 5, NULL, NULL, NULL, 30, 9.5, 9.0, 9.25, 'Lirio Blanco elegante');

-- Verificar los datos insertados
SELECT * FROM DETALLE_FACTURA;


-- Insertar datos de prueba en la tabla TELEFONOS


-- Verificar los datos insertados



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

