// index.js
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');

const detailRoutes = require('./route/detaileroute');
const requestRoutes = require('./route/requestroute');
const cartRoutes = require('./route/cartroute');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 5000;

mongoose.connect(process.env.DB_URI)
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.error('Error connecting to MongoDB:', err));

app.use(express.json());

app.use('/api', detailRoutes);
app.use('/api', requestRoutes);
app.use('/api', cartRoutes);

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
