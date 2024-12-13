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
    const result = await pool.query('SELECT productoraid, nombreproductora, paginaWeb, idPais FROM productoras');
    return result.rows;
  } catch (err) {
    console.error('Error querying the database', err);
    throw err;
  }
};

const getFloristerias = async () => {
  try {
    const result = await pool.query(`
      SELECT f.floristeriaid, f.nombre, f.email, f.paginaweb, p.nombrepais AS pais
      FROM floristerias f
      JOIN pais p ON f.idpais = p.paisid
    `);
    return result.rows;
  } catch (err) {
    console.error('Error querying the database:', err);
    throw err;
  }
};

module.exports = { pool, getProductoras, getFloristerias };

