// index.js
const express = require('express');
const mongoose = require('mongoose');
const dotenv = require('dotenv');
const productRoutes = require('./route/prodectroute');
const detailRoutes = require('./route/detaileroute');

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

mongoose.connect(process.env.DB_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log('Connected to MongoDB'))
  .catch((err) => console.error('Error connecting to MongoDB:', err));

app.use(express.json());
app.use('/api', productRoutes);
app.use('/api', detailRoutes);

app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
