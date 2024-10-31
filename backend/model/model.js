const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  title: String,
  price: String,
  image: String, // base64 or URL
  description: String,
  category: String,
});

module.exports = mongoose.model('Product', productSchema);
