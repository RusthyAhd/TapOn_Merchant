// models/requestmodel.js
const mongoose = require('mongoose');

const requestSchema = new mongoose.Schema({
  fullName: { type: String, required: true },
  phoneNumber: { type: String, required: true },
  address: { type: String, required: true },
  currentLocation: { type: String },
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('tool_orders', requestSchema);