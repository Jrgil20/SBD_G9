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

-- insert into pais
INSERT INTO PAIS (nombrePais, continente) VALUES ('Venezuela', 'Am');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Holanda', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Alemania', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Brasil', 'Am');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Dinamarca', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('Polonia', 'Eu');
INSERT INTO PAIS (nombrePais, continente) VALUES ('España', 'Eu');

SELECT * FROM PAIS;

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

-- Obtener el paisId de Holanda
SELECT paisId FROM PAIS WHERE nombrePais = 'Holanda';
-- Supongamos que el paisId de Holanda es 2

-- Insertar las subastadoras
INSERT INTO SUBASTADORA (nombreSubastadora, idPais) VALUES 
('Royal Flora Holland', 2),
('Plantion', 2),
('Dutch Flower Group', 2);

SELECT * FROM SUBASTADORA;

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

-- Obtener el paisId de Holanda (se repite porque es para las productoras)
SELECT paisId FROM PAIS WHERE nombrePais = 'Holanda';
-- Supongamos que el paisId de Holanda es 2

-- insertar las productoras 
INSERT INTO PRODUCTORAS (nombreProductora, paginaWeb, idPais) VALUES 
('Anthura', 'anthura.nl', 2),
('Van den bos', 'www.vandenbos.com', 2),
('Hilverda florist', 'www.hilverdaflorist.com', 2);

SELECT * FROM PRODUCTORAS;

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

-- Obtener el paisId de cada país
SELECT paisId FROM PAIS WHERE nombrePais = 'Alemania';
SELECT paisId FROM PAIS WHERE nombrePais = 'Brasil';
SELECT paisId FROM PAIS WHERE nombrePais = 'Polonia';
SELECT paisId FROM PAIS WHERE nombrePais = 'España'; -- Asumiendo que Herbs Barcelona es de España
SELECT paisId FROM PAIS WHERE nombrePais = 'Venezuela';

-- Supongamos que los paisId son los siguientes:
-- Alemania: 3
-- Brasil: 4
-- Polonia: 6
-- España: 7
-- Venezuela: 1

-- Insertar las floristerías
INSERT INTO FLORISTERIAS (nombre, email, paginaWeb, idPais) VALUES 
('FloraPrima', 'einkauf-nf@floraprima.de', 'www.floraprima.de', 3),
('Flowers for Brazil', 'example@gmail.com', 'www.flower4brazil.com', 4),
('Poczta kwiatowa', 'biuro@kwiatowaprzesylka.pl', 'www.kwiatowaprzesylka.pl', 6),
('Herbs Barcelona', 'info@herbs.es', 'www.herbs.es', 7),
('Toscana Flores', 'contacto@toscanaflores.com', 'toscanaflores.com', 1);


select * from FLORISTERIAS;

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

-- Insertar datos de prueba en CLIENTE_NATURAL
INSERT INTO CLIENTE_NATURAL (documentoIdentidad, primernombre, primerApellido, segundoApellido, segundonombre) VALUES 
(12345678, 'Juan', 'Pérez', 'García', 'Carlos'),
(87654321, 'María', 'López', 'Martínez', 'Isabel'),
(11223344, 'Carlos', 'Hernández', 'Sánchez', 'Ricardo'),
(44332211, 'Ana', 'Gómez', 'Fernández', NULL),
(55667788, 'Luis', 'Díaz', 'Torres', 'Eduardo');

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM CLIENTE_NATURAL;

-- create sequence for CLIENTE_JURIDICO
CREATE SEQUENCE cliente_juridico_seq START WITH 1 INCREMENT BY 1;

-- create CLIENTE_JURIDICO
CREATE TABLE CLIENTE_JURIDICO (
  cliJuridicoId NUMERIC PRIMARY KEY DEFAULT nextval('cliente_juridico_seq'),
  RIF NUMERIC NOT NULL UNIQUE,
  nombre VARCHAR NOT NULL
);

-- Insertar datos de prueba en CLIENTE_JURIDICO
INSERT INTO CLIENTE_JURIDICO (RIF, nombre) VALUES 
(123456789, 'Empresa A'),
(987654321, 'Empresa B'),
(112233445, 'Empresa C'),
(554433221, 'Empresa D'),
(667788990, 'Empresa E');

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM CLIENTE_JURIDICO;

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

-- Insertar datos de prueba en FLOR_CORTES
INSERT INTO FLOR_CORTES (nombreComun, Descripcion, genero_especie, etimologia, colores, temperatura) VALUES 
('Rosa', 'Flor ornamental popular', 'Rosa gallica', 'De la palabra latina "rosa"', 'Rojo, Blanco, Amarillo, Rosa', 18),
('Tulipán', 'Flor bulbosa de primavera', 'Tulipa gesneriana', 'Del turco "tülbend" que significa turbante', 'Rojo, Amarillo, Púrpura, Blanco', 15),
('Orquídea', 'Flor exótica y diversa', 'Orchidaceae', 'Del griego "orchis" que significa testículo', 'Púrpura, Blanco, Rosa, Amarillo', 20),
('Girasol', 'Flor alta que sigue al sol', 'Helianthus annuus', 'Del griego "helios" que significa sol y "anthos" que significa flor', 'Amarillo', 25),
('Lirio', 'Flor elegante y fragante', 'Lilium', 'Del griego "leirion"', 'Blanco, Rosa, Amarillo, Naranja', 22);

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM FLOR_CORTES;

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
('Oc', 'Funeral');


-- Verificar que los datos han sido insertados correctamente
SELECT * FROM SIGNIFICADO;

-- create sequence for COLOR
CREATE SEQUENCE color_seq START WITH 1 INCREMENT BY 1;

-- create COLOR
CREATE TABLE COLOR (
  colorId NUMERIC PRIMARY KEY DEFAULT nextval('color_seq'),
  Nombre VARCHAR NOT NULL,
  Descripcion VARCHAR NOT NULL
);

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

-- create sequence for ENLACES
CREATE SEQUENCE enlaces_seq START WITH 1 INCREMENT BY 1;

-- create ENLACES
CREATE TABLE ENLACES (
  Idenlace NUMERIC PRIMARY KEY DEFAULT nextval('enlaces_seq'),
  Descripcion VARCHAR NOT NULL,
  idColor NUMERIC,
  idCorte NUMERIC
);

-- Agregar claves foráneas
ALTER TABLE ENLACES
ADD CONSTRAINT FK1 FOREIGN KEY (idColor) REFERENCES COLOR(colorId),
ADD CONSTRAINT FK2 FOREIGN KEY (idCorte) REFERENCES FLOR_CORTES(corteId);

-- Insertar datos de prueba en ENLACES
INSERT INTO ENLACES (Descripcion, IdColor, idCorte) VALUES 
('rosas rojas es el clásico regalo romántico', 2, 2),
('La rosa blanca es un símbolo de pureza, inocencia y amor puro', 2, 1);

-- Verificar que los datos han sido insertados correctamente
SELECT * FROM ENLACES;

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

-- Insertar datos de prueba en CATALOGOPRODUCTOR
INSERT INTO CATALOGOPRODUCTOR (idProductora, idCorte, vbn, nombrepropio, descripcion) VALUES 
(1, 1, 1, 'Rosas', NULL);

-- Verificar los datos insertados
SELECT * FROM CATALOGOPRODUCTOR;

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
ADD CONSTRAINT check_tipoProductor CHECK (tipoProductor IN ('Ca', 'Cb', 'Cc', 'Cg', 'Ka'));

-- Insertar datos de prueba en la tabla CONTRATO
INSERT INTO CONTRATO (idSubastadora, idProductora, nContrato, fechaemision, porcentajeProduccion, tipoProductor, idrenovS, idrenovP, ren_nContrato, cancelado) VALUES
(1, 1, 1001, '2023-01-01', 0.15, 'Ca', NULL, NULL, NULL, NULL),
(2, 2, 1002, '2023-02-01', 0.20, 'Cb', NULL, NULL, NULL, NULL),
(3, 3, 1003, '2023-03-01', 0.25, 'Cc', NULL, NULL, NULL, NULL);

-- Verificar los datos insertados
SELECT * FROM CONTRATO;

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


-- Insertar datos de prueba en la tabla CANTIDAD_OFRECIDA
INSERT INTO CANTIDAD_OFRECIDA (idContratoSubastadora, idContratoProductora, idNContrato, idCatalogoProductora,idCatalogoCorte, idVnb, cantidad) VALUES
(1, 1, 1001, 1, 1, 1, 100),
(2, 2, 1002, 1, 1, 1,200),
(3, 3, 1003, 1, 1, 1,300);

-- Verificar los datos insertados
SELECT * FROM CANTIDAD_OFRECIDA;

-- Crear la tabla
CREATE TABLE PAGOS(
  idContratoSubastadora NUMERIC NOT NULL,
  idContratoProductora NUMERIC NOT NULL,
  idNContrato NUMERIC NOT NULL,
  pagoId NUMERIC NOT NULL,
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

-- Insertar datos de prueba en la tabla PAGOS
INSERT INTO PAGOS (idContratoSubastadora, idContratoProductora, idNContrato, pagoId, fechaPago, montoComision, tipo) VALUES
(1, 1, 1001, 1, '2023-01-15', 150.00, 'membresia'),
(2, 2, 1002, 2, '2023-02-15', 200.00, 'pago'),
(3, 3, 1003, 3, '2023-03-15', 250.00, 'multa');

-- Verificar los datos insertados
SELECT * FROM PAGOS;


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

-- Insertar datos de prueba en la tabla CONTACTOS

INSERT INTO CONTACTOS (idFloristeria, contactoId, documentoIdentidad, primerNombre, primerApellido, segundoApellido, segundoNombre) VALUES 
(1, 5, 667788990, 'Charlie', 'Black', 'Taylor', 'James'),
(2, 4, 554433221, 'Bob', 'White', 'Jones', 'David'),
(3, 1, 123456789, 'John', 'Doe', 'Smith', 'Michael'),
(4, 2, 987654321, 'Jane', 'Doe', 'Johnson', 'Emily');

-- Verificar los datos insertados
SELECT * FROM CONTACTOS;

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

-- Insertar datos de prueba en la tabla AFILIACION
INSERT INTO AFILIACION (idFloristeria, idSubastadora) VALUES 
(1, 1),
(2, 2),
(3, 3);

-- Verificar los datos insertados
SELECT * FROM AFILIACION;


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

-- Insertar datos de prueba en la tabla FACTURA


-- Verificar los datos insertados
-- Insertar datos de prueba en la tabla FACTURA
INSERT INTO FACTURA (facturaId, idAfiliacionFloristeria, idAfiliacionSubastadora, fechaEmision, montoTotal, numeroEnvio) VALUES
(1, 1, 1, '2023-04-01', 500.00, 12345),
(2, 2, 2, '2023-05-01', 750.00, 12346),
(3, 3, 3, '2023-06-01', 1000.00, 12347);

-- Verificar los datos insertados
SELECT * FROM FACTURA;


-- Crear la tabla
CREATE TABLE LOTE(
  idSubastadora NUMERIC NOT NULL,
  idProductora NUMERIC NOT NULL,
  nContrato NUMERIC NOT NULL,
  idProductora2 NUMERIC NOT NULL,
  idCorteFlor NUMERIC NOT NULL,
  vnbFlor NUMERIC NOT NULL,
  idCorteFlor NUMERIC NOT NULL,
  idFactura NUMERIC NOT NULL,
  bi NUMERIC NOT NULL,
  cantidad NUMERIC NOT NULL,
  precioInicial NUMERIC NOT NULL,
  precioFinal NUMERIC NOT NULL,
  PRIMARY KEY (idSubastadora, idProductora, nContrato, idProductora2, idCorteFlor, vnbFlor, idCorteFlor, idFactura)
)

-- Agregar claves foráneas
ALTER TABLE LOTE
ADD CONSTRAINT fk_idSubastadora_lote FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId),
ADD CONSTRAINT fk_idProductora_lote FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS (productoraId),
ADD CONSTRAINT fk_nContrato_lote FOREIGN KEY (nContrato) REFERENCES CONTRATO (nContrato),
ADD CONSTRAINT fk_idProductora2_lote FOREIGN KEY (idProductora2) REFERENCES PRODUCTORAS (productoraId),
ADD CONSTRAINT fk_idCorteFlor_lote FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId),
ADD CONSTRAINT fk_vnbFlor_lote FOREIGN KEY (vnbFlor) REFERENCES CATALOGOPRODUCTOR (vbn),
ADD CONSTRAINT fk_idCorteFlor_lote FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId),
ADD CONSTRAINT fk_idFactura_lote FOREIGN KEY (idFactura) REFERENCES FACTURA (idFactura);


-- Insertar datos de prueba en la tabla LOTE


-- Verificar los datos insertados


-- Crear la tabla
CREATE TABLE CATALOGO_FLORISTERIA(
  idFloristeria NUMERIC NOT NULL,
  idCorteFlor NUMERIC NOT NULL,
  idColor NUMERIC NOT NULL,
  codigo NUMERIC NOT NULL,
  nombrePropio VARCHAR NOT NULL,
  descripcion VARCHAR,
  PRIMARY KEY (idFloristeria, idCorteFlor, idCodigo,codigo)
  
);

-- Agregar claves foráneas
ALTER TABLE CATALOGO_FLORISTERIA
ADD CONSTRAINT fk_idFloristeria_catalogofloristeria FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idCorteFlor_catalogofloristeria FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId);
ADD CONSTRAINT fk_idCodigo_catalogofloristeria FOREIGN KEY (idCodigo) REFERENCES COLOR (colorId);

-- Insertar datos de prueba en la tabla CATALOGO_FLORISTERIA


-- Verificar los datos insertados


-- Crear la tabla
CREATE HISTORICO_PRECIO_FLOR(
  idFloristeria NUMERIC NOT NULL,
  idCorteFlor NUMERIC NOT NULL,
  idColor NUMERIC NOT NULL,
  codigoCatalogo NUMERIC NOT NULL, 
  fechaInicio DATE NOT NULL,
  fechaFin DATE,
  precio NUMERIC NOT NULL,
  tamanoTallo NUMERIC NOT NULL,
  PRIMARY KEY (idFloristeria, idCorteFlor, idColor, fecha)
);

-- Agregar claves foráneas
ALTER TABLE HISTORICO_PRECIO_FLOR
ADD CONSTRAINT fk_idFloristeria_historicoPrecioFlor FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idCorteFlor_historicoPrecioFlor FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId),
ADD CONSTRAINT fk_idColor_historicoPrecioFlor FOREIGN KEY (idColor) REFERENCES COLOR (colorId);
ADD Constraint fk_codigoCatalogo_historicoPrecioFlor FOREIGN KEY (codigoCatalogo) REFERENCES CATALOGO_FLORISTERIA (codigo);

-- Insertar datos de prueba en la tabla HISTORICO_PRECIO_FLOR


-- Verificar los datos insertados


-- Crear la tabla
CREATE TABLE DETALLE_BOUQUET(
  idFloristeria NUMERIC NOT NULL,
  idCorteFlor NUMERIC NOT NULL,
  idColor NUMERIC NOT NULL,
  codigo NUMERIC NOT NULL,
  idBouquet NUMERIC NOT NULL,
  cantidad NUMERIC NOT NULL,
  talloTamano NUMERIC,
  descripcion VARCHAR,
  PRIMARY KEY (idFloristeria, idCorteFlor, idColor, codigo, idBouquet)
);

-- Agregar claves foráneas
ALTER TABLE DETALLE_BOUQUET
ADD CONSTRAINT fk_idFloristeria_detalleBouquet FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idCorteFlor_detalleBouquet FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId),
ADD CONSTRAINT fk_idColor_detalleBouquet FOREIGN KEY (idColor) REFERENCES COLOR (colorId);
ADD CONSTRAINT fk_codigo_detalleBouquet FOREIGN KEY (codigo) REFERENCES CATALOGO_FLORISTERIA (codigo);


-- Insertar datos de prueba en la tabla DETALLE_BOUQUET



-- Verificar los datos insertados


-- Crear la tabla 
CREATE FACTURA_FINAL(
  idFloristeria NUMERIC NOT NULL,
  idFactura NUMERIC NOT NULL,
  fechaEmision DATE NOT NULL,
  montoTotal NUMERIC NOT NULL,
  idClienteNatural NUMERIC,
  idClienteJuridico NUMERIC,
  PRIMARY KEY (idFloristeria, idSubastadora, idFactura)
);


-- Agregar claves foráneas
ALTER TABLE FACTURA_FINAL
ADD CONSTRAINT fk_idFloristeria_facturaFinal FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idCLienteNAatural_facturaFinal FOREIGN KEY (idClienteNatural) REFERENCES CLIENTE_NATURAL (cliNaturalId),
ADD CONSTRAINT fk_idClienteJuridico_facturaFinal FOREIGN KEY (idClienteJuridico) REFERENCES CLIENTE_JURIDICO (cliJuridicoId);



-- Insertar datos de prueba en la tabla FACTURA_FINAL


-- Verificar los datos insertados


-- Crear la tabla
CREATE TABLE DETALLE_FACTURA(
  idFloristeria NUMERIC NOT NULL,
  idFactura NUMERIC NOT NULL,
  idDetalle NUMERIC NOT NULL,
  idCorteFlor NUMERIC NOT NULL,
  idColor NUMERIC NOT NULL,
  codigoCatalogo NUMERIC NOT NULL,
  idBouquet NUMERIC,
  cantidad NUMERIC NOT NULL,
  valoracionPrecio NUMERIC,
  valorancionCalidad NUMERIC,
  valoracionPromedio NUMERIC,
  detalles VARCHAR,
  PRIMARY KEY (idFloristeria, idFactura,idDetalle)
);

-- Agregar claves foráneas
ALTER TABLE DETALLE_FACTURA
ADD CONSTRAINT fk_idFloristeria_detalleFactura FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId),
ADD CONSTRAINT fk_idFactura_detalleFactura FOREIGN KEY (idFactura) REFERENCES FACTURA_FINAL (idFactura),
ADD CONSTRAINT fk_idCorteFlor_detalleFactura FOREIGN KEY (idCorteFlor) REFERENCES FLOR_CORTES (corteId),
ADD CONSTRAINT fk_idColor_detalleFactura FOREIGN KEY (idColor) REFERENCES COLOR (colorId);
ADD CONSTRAINT fk_codigoCatalogo_detalleFactura FOREIGN KEY (codigoCatalogo) REFERENCES CATALOGO_FLORISTERIA (codigo);
ADD CONSTRAINT fk_idBouquet_detalleFactura FOREIGN KEY (idBouquet) REFERENCES DETALLE_BOUQUET (idBouquet);

-- Insertar datos de prueba en la tabla DETALLE_FACTURA


-- Verificar los datos insertados



-- Crear la tabla
CREATE TABLE TELEFONOS(
  codPais NUMERIC NOT NULL,
  codArea NUMERIC NOT NULL,
  numero NUMERIC NOT NULL,
  idSubastadora NUMERIC,
  idProdcutora NUMERIC,
  idFloristeria NUMERIC,
  PRIMARY KEY (codPais, codArea, numero)
);

-- Agregar claves foráneas
ALTER TABLE TELEFONOS
ADD CONSTRAINT fk_idSubastadora_telefonos FOREIGN KEY (idSubastadora) REFERENCES SUBASTADORA (subastadoraId),
ADD CONSTRAINT fk_idProductora_telefonos FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS (productoraId),
ADD CONSTRAINT fk_idFloristeria_telefonos FOREIGN KEY (idFloristeria) REFERENCES FLORISTERIAS (floristeriaId);

-- Insertar datos de prueba en la tabla TELEFONOS


-- Verificar los datos insertados

