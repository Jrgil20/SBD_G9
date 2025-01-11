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
INSERT INTO FACTURA (facturaId, idAfiliacionFloristeria, idAfiliacionSubastadora, fechaEmision, montoTotal, numeroEnvio) VALUES
(1, 1, 1, '2021-01-18 16:00:00', 10000.00, NULL),
(2, 1, 1, '2021-02-15 16:00:00', 1100.00, 3232),
(3, 2, 2, '2023-05-01 16:00:00', 750.00, 12346),
(4, 3, 3, '2023-06-01 16:00:00', 1000.00, 12347),
(5, 4, 1, '2023-07-01 16:00:00', 1250.00, 12348),
(6, 5, 2, '2023-08-01 16:00:00', 1500.00, 12349),
(7, 6, 3, '2023-09-01 16:00:00', 1750.00, 12350),
(8, 1, 2, '2023-10-01 16:00:00', 2000.00, 12351),
(9, 2, 3, '2023-11-01 16:00:00', 2250.00, 12352);

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
(2, 2, 2, 3, 'Tulipán Amarillo', 'Tulipán amarillo brillante para alegrar el día'),
(3, 3, 3, 11, 'Orquídea Púrpura', 'Orquídea exótica y elegante en color púrpura'),
(4, 4, 4, 5, 'Girasol', 'Girasol alto y brillante que sigue al sol'),
(5, 5, 5, 1, 'Lirio Blanco', 'Lirio blanco elegante y fragante para cualquier ocasión'),
(6, 6, 6, 2, 'Clavel Rojo', 'Clavel rojo popular en ramos y arreglos'),
(1, 7, 7, 1, 'Margarita Blanca', 'Margarita sencilla y alegre en color blanco'),
(2, 8, 8, 10, 'Hortensia Azul', 'Hortensia ornamental en racimos de color azul'),
(3, 9, 9, 4, 'Peonía Rosa', 'Peonía grande y fragante en color rosa');

-- Verificar los datos insertados
SELECT * FROM CATALOGO_FLORISTERIA;


-- Insertar datos de prueba en la tabla HISTORICO_PRECIO_FLOR
INSERT INTO HISTORICO_PRECIO_FLOR (idCatalogoFloristeria, idCatalogocodigo, fechaInicio, fechaFin, precio, tamanoTallo) VALUES
(1, 1, '2023-01-01', NULL, 10.00, 50),
(2, 2, '2023-01-01', NULL, 15.00, 60),
(3, 3, '2023-01-01', NULL, 20.00, 70),
(4, 4, '2023-01-01', NULL, 25.00, 80),
(5, 5, '2023-01-01', NULL, 30.00, 90),
(1, 7, '2023-02-01', NULL, 12.00, 55),
(2, 8, '2023-02-01', NULL, 18.00, 65),
(3, 9, '2023-02-01', NULL, 22.00, 75),
(4, 4, '2023-02-01', NULL, 28.00, 85);

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


-- Insertar datos de prueba en la tabla FACTURA_FINAL
INSERT INTO FACTURA_FINAL (idFloristeria, numFactura, fechaEmision, montoTotal, idClienteNatural, idClienteJuridico) VALUES
(1, 1, '2023-07-01', 500.00, 1, NULL),
(2, 2, '2023-08-01', 750.00, NULL, 1),
(3, 3, '2023-09-01', 1000.00, 2, NULL),
(4, 4, '2023-10-01', 1250.00, NULL, 2),
(5, 5, '2023-11-01', 1500.00, 3, NULL),
(2, 6, '2023-12-01', 1750.00, NULL, 3),
(3, 7, '2024-01-01', 2000.00, 4, NULL),
(4, 8, '2024-02-01', 2250.00, NULL, 4),
(5, 9, '2024-03-01', 2500.00, 5, NULL);

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