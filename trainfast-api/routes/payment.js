import express from 'express'; 
import { getPool } from '../lib/db.js'; 

const router = express.Router();


router.post('/', async (req, res) => {
  try {
    // รับข้อมูลที่ถูกส่งมาจาก frontend
    const { line, startStation, endStation, price } = req.body;

    if (!line || !startStation || !endStation || !price) {
      return res.status(400).json({ error: 'Missing required fields' }); 
    }

    // สร้าง ref (รหัสอ้างอิง) สำหรับ QR โดยใช้ชื่อสาย + timestamp
    const ref1 = `${line}-${Date.now()}`;

   
    const qrText = `https://mock-qr.fasttrain.com/checkout/${ref1}`;

    const pool = getPool(); 
    const conn = await pool.getConnection();

    try {
      await conn.beginTransaction(); 

      await conn.execute(
        `INSERT INTO tickets (line, startStation, endStation, price, qr_url, createdAt)
         VALUES (?, ?, ?, ?, ?, NOW())`,
        [line, startStation, endStation, price, qrText] 
      );

      await conn.commit(); 
    } catch (dbError) {
      await conn.rollback(); 
      throw dbError; 
    } finally {
      conn.release();
    }

   
    return res.json({ qrText });

  } catch (error) {
    // กรณีที่เกิดปัญหาทั่วไป เช่น DB ล่ม
    console.error(':fire: Payment Error:', error.message); 
    return res.status(500).json({
      error: 'เกิดข้อผิดพลาดขณะสร้าง QR หรือบันทึกข้อมูลตั๋ว', 
      detail: error.message 
    });
  }
});

export default router; 