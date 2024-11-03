// routes/detailRoutes.js
const express = require('express');
const router = express.Router();
const { getProductsByCategory, getProductById } = require('../controller/controller');

// Route to get product by ID
router.get('/tools/:id', getProductById);

// Route to get products by category
router.get('/tools/category/:category', getProductsByCategory);

module.exports = router;
