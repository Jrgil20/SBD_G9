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
    const result = await pool.query('SELECT p.productoraid, p.nombreproductora, p.paginaweb, pa.nombrepais AS pais FROM productoras p JOIN pais pa ON p.idpais = pa.paisid');
    
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getCatalogoProductoraById = async (productorId) => {
  try {
    const result = await pool.query(`
      SELECT
      fc.corteid,
      fc.nombrecomun, 
      cp.nombrepropio, 
      cp.vbn
      FROM flor_cortes fc
      INNER JOIN catalogoproductor cp ON fc.corteid = cp.idcorte
      INNER JOIN productoras p ON cp.idproductora = p.productoraid
      WHERE p.productoraid = ${productorId}
      ORDER BY fc.nombrecomun;
    `);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getDetalleFlores = async (florId,productorId) => {
  try {
    const result = await pool.query(`SELECT 
    cp.nombrepropio, 
    cp.descripcion, 
    fc.etimologia, 
    fc.genero_especie ,
    fc.temperatura 
    FROM catalogoproductor cp INNER JOIN flor_cortes fc ON cp.idcorte = fc.corteid 
    WHERE cp.idproductora = ${productorId} AND fc.corteid = ${florId}; `);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getFloristerias = async () => {
  try {
    const result = await pool.query(`
      SELECT f.floristeriaid, f.nombre, f.email, f.paginaweb, p.nombrepais AS pais FROM floristerias f JOIN pais p ON f.idpais = p.paisid
    `);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database:', err);
    throw err;
  }
};

module.exports = { pool, getProductoras, getFloristerias,getCatalogoProductoraById,getDetalleFlores};

