const express = require('express');
const router = express.Router();
const { getProductsByCategory } = require('../controller/controller');



router.get('/products/:category', getProductsByCategory);

module.exports = router;
