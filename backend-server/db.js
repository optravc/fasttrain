import mysql from 'mysql2/promise';
let pool;
export function getPool() {
    if (!pool) {
        console.log('✅ Connecting to DB:', process.env.DATABASE_URL);
        pool = mysql.createPool({
            uri: process.env.DATABASE_URL,
            ssl: {
                rejectUnauthorized: false // ปิดการตรวจสอบใบรับรอง SSL
            }
        });
    }
    return pool;
}
