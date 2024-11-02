// routes/cartroute.js
const express = require('express');
const router = express.Router();
const { addToCart, getCartItems } = require('../controller/cartcontroller');

router.post('/cart', addToCart);
router.get('/cart', getCartItems);

module.exports = router;