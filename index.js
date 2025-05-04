const express = require('express');
const cors = require('cors');
const mysql = require('mysql2');
require('dotenv').config();

const app = express();

app.use(cors());
app.use(express.json());

const connection = mysql.createConnection(process.env.DATABASE_URL);

// ทดสอบว่า server ตอบได้
app.get('/', (req, res) => {
  res.send('📡 Train API is running...');
});

// ✅ อ่านข้อมูลจากตาราง Stations ทั้งหมด
app.get('/stations', (req, res) => {
  connection.query('SELECT * FROM Stations', (err, results) => {
    if (err) return res.status(500).send('Database error');
    res.send(results);
  });
});

// ✅ อ่านเฉพาะ station ตาม id
app.get('/stations/:id', (req, res) => {
  const id = req.params.id;
  connection.query('SELECT * FROM Stations WHERE id = ?', [id], (err, results) => {
    if (err) return res.status(500).send('Database error');
    res.send(results);
  });
});


app.listen(process.env.PORT || 3000, () => {
  console.log('✅ Train API (Read-only) is running on port 3000');
});

module.exports = app;
