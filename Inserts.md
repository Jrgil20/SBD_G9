| paisId | nombrePais | continente |
|--------|-------------|------------|
| 1      | Venezuela   | Am         |
| 2      | Holanda     | Eu         |
| 3      | Alemania    | Eu         |
| 4      | Brasil      | Am         |
| 5      | Dinamarca   | Eu         |
| 6      | Polonia     | Eu         |
| 7      | España      | Eu         |
| 8      | Colombia    | Am         |
| 9      | Ecuador     | Am         |

(9 rows)

| subastadoraId | nombreSubastadora    | idPais |
|---------------|----------------------|--------|
| 1             | Royal Flora Holland  | 2      |
| 2             | Plantion             | 2      |
| 3             | Dutch Flower Group   | 2      |

(3 rows)

| productoraId | nombreProductora | paginaWeb               | idPais |
|--------------|------------------|-------------------------|--------|
| 1            | Anthura          | anthura.nl              | 2      |
| 2            | Van den bos      | www.vandenbos.com       | 2      |
| 3            | Hilverda florist | www.hilverdaflorist.com | 2      |

(3 rows)

| floristeriaId | nombre           | email                          | paginaWeb                | idPais |
|---------------|------------------|--------------------------------|--------------------------|--------|
| 1             | FloraPrima       | einkauf-nf@floraprima.de       | www.floraprima.de        | 3      |
| 2             | Flowers for Brazil | example@gmail.com            | www.flower4brazil.com    | 4      |
| 3             | Poczta kwiatowa  | biuro@kwiatowaprzesylka.pl     | www.kwiatowaprzesylka.pl | 6      |
| 4             | Herbs Barcelona  | info@herbs.es                  | www.herbs.es             | 7      |
| 5             | Toscana Flores   | contacto@toscanaflores.com     | toscanaflores.com        | 1      |

(5 rows)

| cliNaturalId | documentoIdentidad | primernombre | primerApellido | segundoApellido | segundonombre |
|--------------|---------------------|--------------|----------------|-----------------|---------------|
| 1            | 12345678            | Juan         | Pérez          | García          | Carlos        |
| 2            | 87654321            | María        | López          | Martínez        | Isabel        |
| 3            | 11223344            | Carlos       | Hernández      | Sánchez         | Ricardo       |
| 4            | 44332211            | Ana          | Gómez          | Fernández       | NULL          |
| 5            | 55667788            | Luis         | Díaz           | Torres          | Eduardo       |

(5 rows)

| cliJuridicoId | RIF        | nombre    |
|---------------|------------|-----------|
| 1             | 123456789  | Empresa A |
| 2             | 987654321  | Empresa B |
| 3             | 112233445  | Empresa C |
| 4             | 554433221  | Empresa D |
| 5             | 667788990  | Empresa E |

(5 rows)

| corteId | nombreComun | Descripcion             | genero_especie    | etimologia                                | colores                        | temperatura |
|---------|-------------|-------------------------|-------------------|-------------------------------------------|--------------------------------|-------------|
| 1       | Rosa        | Flor ornamental popular | Rosa gallica      | De la palabra latina "rosa"               | Rojo, Blanco, Amarillo, Rosa   | 18          |
| 2       | Tulipán     | Flor bulbosa de primavera | Tulipa gesneriana | Del turco "tülbend" que significa turbante | Rojo, Amarillo, Púrpura, Blanco | 15          |
| 3       | Orquídea    | Flor exótica y diversa  | Orchidaceae       | Del griego "orchis" que significa testículo | Púrpura, Blanco, Rosa, Amarillo | 20          |
| 4       | Girasol     | Flor alta que sigue al sol | Helianthus annuus | Del griego "helios" que significa sol y "anthos" que significa flor | Amarillo | 25 |
| 5       | Lirio       | Flor elegante y fragante | Lilium            | Del griego "leirion"                      | Blanco, Rosa, Amarillo, Naranja | 22          |

(5 rows)

| SignificadoId | Tipo | Descripcion   |
|---------------|------|---------------|
| 1             | Oc   | Boda          |
| 2             | Se   | Amor          |
| 3             | Oc   | Cumpleaños    |
| 4             | Se   | Felicidad     |
| 5             | Oc   | Aniversario   |
| 6             | Se   | Tristeza      |
| 7             | Oc   | Graduación    |
| 8             | Se   | Amistad       |
| 9             | Oc   | Nacimiento    |
| 10            | Se   | Perdón        |
| 11            | Oc   | Despedida     |
| 12            | Se   | Agradecimiento |
| 13            | Oc   | San Valentín  |
| 14            | Se   | Alegría       |
| 15            | Oc   | Funeral       |
| 16            | Se   | Paz           |

(16 rows)

| colorId | Nombre         | Descripcion                                                                 |
|---------|----------------|-----------------------------------------------------------------------------|
| 1       | Blanco         | Las flores blancas son magníficas, únicas, y no tradicionales. Son perfectas para una nueva relación o para decir a tu pareja lo perfecta que es para ti. También son las flores para expresar la pureza de tu amor. Buenas ideas son rosas u orquídeas blancas. |
| 2       | Rojo           | El rojo es el color tradicional del amor y del romance. Una docena de rosas rojas es el clásico regalo romántico. |
| 3       | Blanco y Rojo  | Las flores rojas y blancas son una combinación llamativa y que encarnan todos los sentimientos y emociones de un verdadero vínculo. |
| 4       | Rosado         | Es el color femenino por excelencia. Las rosas rosadas son perfectas como regalo romántico, y representan la ingenuidad, bondad, ternura, buen sentimiento y ausencia de todo mal. |
| 5       | Amarillo       | Si quieres hacer las cosas más lentas es el color a enviar, el amarillo es el color de la amistad. Irradia siempre en todas partes y sobre toda las cosas, es el color de la luz. |
| 6       | Amarillo y Rojo | El amarillo simboliza su amistad actual y el rojo indica que deseas avanzar hacia una nueva relación. |
| 7       | Naranja        | El naranja es un color fuerte, cálido que muestra la fascinación o intriga. |
| 8       | Melocotón      | El Melocotón es un tono de naranja y rosa que representan a la vez el romanticismo de las rosas y el calor y la gratitud del anaranjado. Se trata de un color perfecto para mostrar amor y reconocimiento. |
| 9       | Verde          | El verde es un color rico y fresco, perfecto para la pareja armoniosa. Es el color de la esperanza. Y puede expresar: naturaleza, juventud, deseo, descanso, equilibrio. |
| 10      | Azul           | El Azul es el color de la paz y la estabilidad. Es fresco y relajante. Es el color del cielo y del mar. Es un color reservado y que parece que se aleja. Puede expresar confianza, reserva, armonía, afecto, amistad, fidelidad y amor. |
| 11      | Violeta        | Es el color que indica ausencia de tensión. A menudo se le asocia con la nobleza, es un color perfecto para un amor de mucho tiempo. |

(11 rows)

| IdSignificado | Descripcion                                      | IdColor | idCorte |
|---------------|--------------------------------------------------|---------|---------|
| 1             | rosas rojas es el clásico regalo romántico       | 2       | 2       |
| 2             | La rosa blanca es un símbolo de pureza, inocencia y amor puro | 2       | 1       |

(2 rows)

| idProductora | idCorte | vbn | nombrepropio | descripcion |
|--------------|---------|-----|--------------|-------------|
| 1            | 1       | 1   | Rosas        | NULL        |

(1 row)

| idSubastadora | idProductora | nContrato | fechaemision | porcentajeProduccion | tipoProductor | idrenovS | idrenovP | ren_nContrato | cancelado |
|---------------|--------------|-----------|--------------|----------------------|---------------|----------|----------|---------------|-----------|
| 1             | 1            | 1001      | 2023-01-01   | 0.60                 | Ca            | NULL     | NULL     | NULL          | NULL      |
| 2             | 2            | 1002      | 2023-02-01   | 0.25                 | Cb            | NULL     | NULL     | NULL          | NULL      |
| 3             | 3            | 1003      | 2023-03-01   | 0.15                 | Cc            | NULL     | NULL     | NULL          | NULL      |

(3 rows)

| idContratoSubastadora | idContratoProductora | idNContrato | idCatalogoProductora | idCatalogoCorte | idVnb | cantidad |
|-----------------------|----------------------|-------------|----------------------|-----------------|-------|----------|
| 1                     | 1                    | 1001        | 1                    | 1               | 1     | 100      |
| 2                     | 2                    | 1002        | 1                    | 1               | 1     | 200      |
| 3                     | 3                    | 1003        | 1                    | 1               | 1     | 300      |

(3 rows)

| idContratoSubastadora | idContratoProductora | idNContrato | pagoId | fechaPago  | montoComision | tipo      |
|-----------------------|----------------------|-------------|--------|------------|---------------|-----------|
| 1                     | 1                    | 1001        | 1      | 2023-01-15 | 150.00        | membresia |
| 2                     | 2                    | 1002        | 2      | 2023-02-15 | 200.00        | pago      |
| 3                     | 3                    | 1003        | 3      | 2023-03-15 | 250.00        | multa     |

(3 rows)

| idFloristeria | contactoId | documentoIdentidad | primerNombre | primerApellido | segundoApellido | segundoNombre |
|---------------|------------|--------------------|--------------|----------------|-----------------|---------------|
| 1             | 5          | 667788990          | Charlie      | Black          | Taylor          | James         |
| 2             | 4          | 554433221          | Bob          | White          | Jones           | David         |
| 3             | 1          | 123456789          | John         | Doe            | Smith           | Michael       |
| 4             | 2          | 987654321          | Jane         | Doe            | Johnson         | Emily         |

(4 rows)

| idFloristeria | idSubastadora |
|---------------|---------------|
| 1             | 1             |
| 2             | 2             |
| 3             | 3             |

(3 rows)

| facturaId | idAfiliacionFloristeria | idAfiliacionSubastadora | fechaEmision | montoTotal | numeroEnvio |
|-----------|-------------------------|-------------------------|--------------|------------|-------------|
| 1         | 1                       | 1                       | 2023-04-01   | 500.00     | 12345       |
| 2         | 2                       | 2                       | 2023-05-01   | 750.00     | 12346       |
| 3         | 3                       | 3                       | 2023-06-01   | 1000.00    | 12347       |

(3 rows)

| idCantidadContratoSubastadora | idCantidadContratoProductora | idCantidad_NContrato | idCantidadCatalogoProductora | idCantidadCorte | idCantidadvnb | NumLote | bi | cantidad | precioInicial | precioFinal | idFactura |
|-------------------------------|------------------------------|----------------------|------------------------------|-----------------|---------------|---------|----|----------|---------------|-------------|-----------|
| 1                             | 1                            | 1001                 | 1                            | 1               | 1             | 1       | 1  | 50       | 10.00         | 15.00       | 1         |
| 2                             | 2                            | 1002                 | 1                            | 1               | 1             | 2       | 2  | 100      | 20.00         | 25.00       | 2         |
| 3                             | 3                            | 1003                 | 1                            | 1               | 1             | 3       | 3  | 150      | 30.00         | 35.00       | 3         |

(3 rows)

| idFloristeria | codigo | idCorteFlor | idColor | nombrePropio       | descripcion                                      |
|---------------|--------|-------------|---------|--------------------|--------------------------------------------------|
| 1             | 1      | 1           | 2       | Rosa Roja          | Rosa roja clásica para ocasiones románticas      |
| 2             | 2      | 2           | 3       | Tulipán Amarillo   | Tulipán amarillo brillante para alegrar el día   |
| 3             | 3      | 3           | 4       | Orquídea Púrpura   | Orquídea exótica y elegante en color púrpura     |
| 4             | 4      | 4           | 5       | Girasol            | Girasol alto y brillante que sigue al sol        |
| 5             | 5      | 5           | 6       | Lirio Blanco       | Lirio blanco elegante y fragante para cualquier ocasión |

(5 rows)

| idCatalogoFloristeria | idCatalogocodigo | fechaInicio | fechaFin | precio | tamanoTallo |
|-----------------------|------------------|-------------|----------|--------|-------------|
| 1                     | 1                | 2023-01-01  | NULL     | 10.00  | 50          |
| 2                     | 2                | 2023-01-01  | NULL     | 15.00  | 60          |
| 3                     | 3                | 2023-01-01  | NULL     | 20.00  | 70          |
| 4                     | 4                | 2023-01-01  | NULL     | 25.00  | 80          |
| 5                     | 5                | 2023-01-01  | NULL     | 30.00  | 90          |

(5 rows)

| idCatalogoFloristeria | idCatalogocodigo | bouquetId | cantidad | talloTamano | descripcion                |
|-----------------------|------------------|-----------|----------|-------------|----------------------------|
| 1                     | 1                | 1         | 10       | 50          | Bouquet de rosas rojas     |
| 2                     | 2                | 2         | 15       | 60          | Bouquet de tulipanes amarillos |
| 3                     | 3                | 3         | 20       | 70          | Bouquet de orquídeas púrpuras |
| 4                     | 4                | 4         | 25       | 80          | Bouquet de girasoles       |
| 5                     | 5                | 5         | 30       | 90          | Bouquet de lirios blancos  |

(5 rows)

| idFloristeria | numFactura | fechaEmision | montoTotal | idClienteNatural | idClienteJuridico |
|---------------|------------|--------------|------------|------------------|-------------------|
| 1             | 1          | 2023-07-01   | 500.00     | 1                | NULL              |
| 2             | 2          | 2023-08-01   | 750.00     | NULL             | 1                 |
| 3             | 3          | 2023-09-01   | 1000.00    | 2                | NULL              |
| 4             | 4          | 2023-10-01   | 1250.00    | NULL             | 2                 |
| 5             | 5          | 2023-11-01   | 1500.00    | 3                | NULL              |

(5 rows)

| idFActuraFloristeria | idNumFactura | detalleId | catalogoFloristeria | catalogoCodigo | bouquetFloristeria | bouquetcodigo | bouquetId | cantidad | valoracionPrecio | valorancionCalidad | valoracionPromedio | detalles                  |
|----------------------|--------------|-----------|---------------------|----------------|--------------------|---------------|-----------|----------|------------------|--------------------|--------------------|---------------------------|
| 1                    | 1            | 1         | 1                   | 1              | NULL               | NULL          | NULL      | 10       | 9.5              | 9.0                | 9.25               | Rosa Roja de alta calidad |
| 2                    | 2            | 2         | NULL                | NULL           | 2                  | 2             | 2         | 15       | 8.5              | 8.0                | 8.25               | Bouquet de tulipanes amarillos |
| 3                    | 3            | 3         | 3                   | 3              | NULL               | NULL          | NULL      | 20       | 9.0              | 9.5                | 9.25               | Orquídea Púrpura exótica |
| 4                    | 4            | 4         | NULL                | NULL           | 4                  | 4             | 4         | 25       | 8.0              | 8.5                | 8.25               | Bouquet de girasoles       |
| 5                    | 5            | 5         | 5                   | 5              | NULL               | NULL          | NULL      | 30       | 9.5              | 9.0                | 9.25               | Lirio Blanco elegante |
