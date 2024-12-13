const express = require('express');
const { pool, getProductoras, getFloristerias } = require('./db');
const path = require('path');

const app = express();

// Configurar el motor de plantillas EJS (si es necesario)
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'view'));

// Servir archivos estáticos desde la carpeta 'view'
app.use(express.static(path.join(__dirname, 'view')));

app.get('/test', async (req, res) => {
  try {
    const result = await pool.query('SELECT NOW()');
    res.json(result.rows);
  } catch (err) {
    console.error('Error querying the database:', err);
    res.status(500).send('Error querying the database');
  }
});

// Ruta para servir el archivo HTML principal
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, 'view', 'index.html'));
});

// Nueva ruta para obtener datos de las productoras
app.get('/api/productoras', async (req, res) => {
  try {
    const productoras = await getProductoras();
    res.json(productoras);
  } catch (err) {
    console.error('Error querying the database:', err);
    res.status(500).json({ error: 'Error querying the database' });
  }
});

// Nueva ruta para obtener datos de las floristerias
app.get('/api/floristerias', async (req, res) => {
  try {
    const floristerias = await getFloristerias();
    res.json(floristerias);
  } catch (err) {
    console.error('Error querying the database:', err);
    res.status(500).json({ error: 'Error querying the database' });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
  console.log(`Click here to open: http://localhost:${PORT}`);
});