import express from 'express';
import cors from 'cors'; // ✅ เพิ่ม CORS
import { handleRoutes } from './api/sukumvit/route.js';
import dotenv from 'dotenv';
dotenv.config();


const app = express();
const PORT = 5000;

app.use(cors()); // ✅ เปิด CORS ให้ทุกโดเมนสามารถเรียก API ได้

app.get('/', handleRoutes); // ✅ Route ที่ Flutter ใช้

app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
