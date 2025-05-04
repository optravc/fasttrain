import { getPool } from '../../db.js';

export async function handleRoutes(req, res) {
  try {
    const pool = getPool();
    const [rows] = await pool.query('SELECT line, name, map_url FROM Stations');

    const result = {};
    rows.forEach(row => {
      if (!result[row.line]) {
        result[row.line] = {
          stations: [],
          submap: row.map_url
        };
      }
      result[row.line].stations.push(row.name);
    });

    res.status(200).json(result);
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
}
