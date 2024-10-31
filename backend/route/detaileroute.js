// routes/detailRoutes.js
const express = require('express');
const router = express.Router();
const { getProductById } = require('../controller/detailcontroller');

// Route to get product by ID
router.get('/product/:id', getProductById);

module.exports = router;
