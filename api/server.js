const express = require('express');
const cors = require('cors');
const mysql = require('mysql2/promise');
require('dotenv').config();

const app = express();
app.use(cors());

const connection = mysql.createPool({
  uri: process.env.DATABASE_URL,
  ssl: { rejectUnauthorized: false }
});

app.get('/stations', async (req, res) => {
  try {
    const [rows] = await connection.query('SELECT * FROM Stations');
    res.json({
      "Sukhumvit Line": {
        stations: rows.map(r => r.name),
        map_url: rows[0]?.map_url || null
      }
    });
  } catch (err) {
    console.error(err);
    res.status(500).send('Error retrieving stations');
  }
});

app.listen(3000, () => console.log('Server on 3000'));

module.exports = app;
