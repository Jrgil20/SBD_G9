// db.js
const { Pool } = require('pg');
require('dotenv').config();

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
});

pool.connect((err) => {
  if (err) {
    console.error('Error connecting to the database', err);
  } else {
    console.log('Connected to the PostgreSQL database');
  }
});

const getProductoras = async () => {
  try {
    const result = await pool.query('SELECT * FROM informacion_de_productores()');
    
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getCatalogoProductoraById = async (productorId) => {
  try {
    const result = await pool.query(`SELECT * FROM CatalogoProductoraById(${productorId});`);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getDetalleFlores = async (florId,productorId) => {
  try {
    const result = await pool.query(`SELECT * FROM Obtener_DetalleFlores(${productorId}, ${florId});`);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getFloristerias = async () => {
  try {
    const result = await pool.query('SELECT * FROM obtener_floristeria()');
    return result.rows;
  } catch (err) {
    console.error('Error querying the database:', err);
    throw err;
  }
};

const getFloresValoraciones = async (floristeriaId) => {
  try {
    console.log(`Executing query for floristeria ID: ${floristeriaId}`);
    const result = await pool.query(`
      SELECT * from obtener_valoraciones_por_floristeria($1)
    `, [floristeriaId]);
    console.log('Query result:', result.rows);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

async function getInformacionFlor(idFloristeria, idFlor) {
  try {
    const result = await pool.query(`
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
        WHERE cf.idFloristeria = $1 AND cf.idcorteflor = $2
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
    `, [idFloristeria, idFlor]);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
}

//Facturas
async function getFacturas(){
  try{
    const result=await pool.query(`SELECT * FROM obtener_facturas();`)
    return result.rows;
  }catch(err){
    console.error('Error querying the database', err);
    throw err;
  }
}

async function getInformacionFactura(idFactura){
  try{
    const result=await pool.query(`SELECT * FROM Traer_lotes(${idFactura});`,[idFactura] )
    return result.rows;
  }catch(err){
    console.error('Error querying the database', err);
    throw err;
  }
}	

const getFlorCortes = async () => {
  try {
    console.log('Executing query to get flor cortes');
    const result = await pool.query('SELECT * FROM obtener_flor_cortes()');
    console.log('Query result:', result.rows);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getContratosProductora = async (productoraId) => {
  try {
    const result = await pool.query('SELECT * FROM obtener_contratos_productora($1)', [productoraId]);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

module.exports = { 
  pool, 
  getProductoras, 
  getFloristerias, 
  getCatalogoProductoraById, 
  getDetalleFlores, 
  getFloresValoraciones, 
  getInformacionFlor, 
  getFacturas, 
  getInformacionFactura,
  getFlorCortes,
  getContratosProductora
};

