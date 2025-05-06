import express from 'express';
import { getPool } from '../lib/db.js';

const router = express.Router();

// ✅ POST /api/addLine
router.post('/', async (req, res) => {
  const { line, name, map_url } = req.body;

  // ตรวจสอบ input
  if (!line || !name || !map_url) {
    return res.status(400).json({ error: 'Missing line, name, or map_url' });
  }

  let table;
  switch (line) {
    case 'Sukhumvit Line':
      table = 'SukhumvitLine';
      break;
    case 'Silom Line':
      table = 'SilomLine';
      break;
    case 'Gold Line':
      table = 'GoldLine';
      break;
    default:
      return res.status(400).json({ error: 'Invalid line name' });
  }

  try {
    const pool = getPool();
    const sql = `INSERT INTO ${table} (line, name, map_url) VALUES (?, ?, ?)`;
    const [result] = await pool.execute(sql, [line, name, map_url]);

    res.json({
      message: `✅ เพิ่มสถานี ${name} ลงใน ${table} สำเร็จ`,
      id: result.insertId,
    });
  } catch (err) {
    console.error('❌ Insert error:', err);
    res.status(500).json({ error: 'Database error', detail: err.message });
  }
});

export default router;
