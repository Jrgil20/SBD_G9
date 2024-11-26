-- create sequence for PAIS
CREATE SEQUENCE pais_seq START 1;

-- create pais
CREATE TABLE PAIS (
  paisId NUMERIC PRIMARY KEY DEFAULT nextval('pais_seq'),
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
  idFloristeria NUMERIC PRIMARY KEY DEFAULT nextval('floristerias_seq'),
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