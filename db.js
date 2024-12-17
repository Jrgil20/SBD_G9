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
    const result = await pool.query(`SELECT * FROM obtener_informacion_de_flor(${idFloristeria}, ${idFlor});`, [idFloristeria, idFlor]);
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


module.exports = { pool, getProductoras, getFloristerias,getCatalogoProductoraById,getDetalleFlores,getFloresValoraciones,getInformacionFlor,getFacturas,getInformacionFactura};

