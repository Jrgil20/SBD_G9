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


