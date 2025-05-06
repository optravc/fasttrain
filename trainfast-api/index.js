import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import stationsRoute from './routes/stations.js';
import paymentRoute from './routes/payment.js'; 
import addLine from './routes/addLine.js'; 
import addLineRouter from './routes/delete.js';
dotenv.config();

const app = express();
const port = process.env.PORT || 5000;

app.use(cors());
app.use(express.json());

app.use('/api/stations', stationsRoute);
app.use('/api/payment', paymentRoute);
app.use('/api/addLine', addLine);
app.use('/api/delete', addLineRouter);

app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
});
