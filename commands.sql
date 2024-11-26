-- create sequence for PAIS
CREATE SEQUENCE pais_seq START 1;

-- create pais
CREATE TABLE PAIS (
  paisId NUMERIC(2) PRIMARY KEY DEFAULT nextval('pais_seq'),
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
CREATE SEQUENCE subastadora_seq START 1;

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
CREATE SEQUENCE productoras_seq START 1;

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
CREATE SEQUENCE floristerias_seq START 1;

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
CREATE SEQUENCE cliente_natural_seq START 1;

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
CREATE SEQUENCE cliente_juridico_seq START 1;

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
CREATE SEQUENCE flor_cortes_seq START 1;

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
CREATE SEQUENCE significado_seq START 1;

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
CREATE SEQUENCE color_seq START 1;

-- create COLOR
CREATE TABLE COLOR (
  ColorId NUMERIC PRIMARY KEY DEFAULT nextval('color_seq'),
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
CREATE SEQUENCE enlaces_seq START 1;

-- create ENLACES
CREATE TABLE ENLACES (
  Idenlace NUMERIC PRIMARY KEY DEFAULT nextval('enlaces_seq'),
  Descripcion VARCHAR NOT NULL,
  IdColor NUMERIC,
  idCorte NUMERIC
);

-- Agregar claves foráneas
ALTER TABLE ENLACES
ADD CONSTRAINT FK1 FOREIGN KEY (IdColor) REFERENCES COLOR(colorId),
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
  descripcion VARCHAR NOT NULL,
  PRIMARY KEY (idProductora, idCorte, vbn)
);

-- Agregar claves foráneas y restricción UNIQUE
ALTER TABLE CATALOGOPRODUCTOR
ADD CONSTRAINT FK1 FOREIGN KEY (idCorte) REFERENCES FLOR_CORTES(corteId),
ADD CONSTRAINT FK2 FOREIGN KEY (idProductora) REFERENCES PRODUCTORAS(productoraId),
ADD CONSTRAINT unique_vbn UNIQUE (vbn);