const mongoose = require('mongoose');

const productSchema = new mongoose.Schema({
  name: { type: String, required: true },
  description: { type: String, required: true },
  category: { type: String, required: true },
  quantity: { type: Number, required: true },
  price: { type: Number, required: true },
  discount: { type: Number },
  totalAmount: { type: Number, required: true },
  address: { type: String },
  brand: { type: String },
  image: { type: String },
});

// Check if the model already exists before defining it
const Product = mongoose.models.Product || mongoose.model('item', productSchema);

module.exports = Product;
