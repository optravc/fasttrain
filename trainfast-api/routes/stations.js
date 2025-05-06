import express from 'express';
import { getPool } from '../lib/db.js';

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const pool = getPool();

    // ดึงข้อมูลจากทั้ง 2 ตาราง
    const [sukhumvitRows] = await pool.execute('SELECT * FROM SukhumvitLine');
    const [silomRows] = await pool.execute('SELECT * FROM SilomLine');
    const [goldline] = await pool.execute('SELECT * FROM GoldLine');

    res.json({
      "Sukhumvit Line": {
        stations: sukhumvitRows.map(row => ({
          name: row.name,
          map_url: row.map_url
        }))
      },
      "Silom Line": {
        stations: silomRows.map(row => ({
          name: row.name,
          map_url: row.map_url
        }))
      },
      "Gold Line": {
        stations: goldline.map(row => ({
          name: row.name,
          map_url: row.map_url
        }))
      }
    });

  } catch (err) {
    console.error('❌ DB Error:', err);
    res.status(500).json({ error: 'Internal Server Error', detail: err.message });
  }
});

export default router;
