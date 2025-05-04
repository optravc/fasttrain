import mysql from 'mysql2/promise';

export default async function handler(req, res) {
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method Not Allowed' });
  }

  try {
    const connection = await mysql.createConnection(process.env.DATABASE_URL);

    const [rows] = await connection.execute('SELECT * FROM Stations');

    await connection.end();

    res.status(200).json({
      "Sukhumvit Line": {
        stations: rows.map(row => row.name),
        map_url: rows[0]?.map_url || null
      }
    });
  } catch (error) {
    console.error('❌ DB Error:', error);
    res.status(500).json({ error: 'Internal Server Error', detail: error.message });
  }
}
