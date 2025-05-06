import express from 'express';
import { getPool } from '../lib/db.js';

const router = express.Router();


router.post('/', async (req, res) => {
  const { line, name } = req.body;

  // ตรวจสอบ input
  if (!line || !name) {
    return res.status(400).json({ error: 'Missing line or name' });
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
    const sql = `DELETE FROM ${table} WHERE name = ? LIMIT 1`;
    const [result] = await pool.execute(sql, [name]);

    if (result.affectedRows === 0) {
      return res.status(404).json({ error: 'ไม่พบสถานีที่ต้องการลบ' });
    }

    res.json({
      message: `🗑 ลบสถานี ${name} จาก ${table} สำเร็จ`,
      affectedRows: result.affectedRows,
    });
  } catch (err) {
    console.error('❌ Delete error:', err);
    res.status(500).json({ error: 'Database error', detail: err.message });
  }
});

export default router;
