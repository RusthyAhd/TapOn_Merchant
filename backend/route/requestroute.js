// routes/requestroute.js
const express = require('express');
const router = express.Router();
const { createRequest } = require('../controller/requestcontroller');

router.post('/request', createRequest);

module.exports = router;