// controllers/productController.js
const Product = require('../model/detailmodel');
const fs = require('fs');
const path = require('path');

exports.getProductById = async (req, res) => {
  try {
    const { id } = req.params;
    const product = await Product.findById(id);
    if (!product) return res.status(404).json({ message: 'Product not found' });

    // Convert image path to base64 if stored as a file path
    if (product.image) {
      const imagePath = path.join(__dirname, '..', product.image);
      const imageData = fs.readFileSync(imagePath, { encoding: 'base64' });
      product.image = imageData;
    }
    
    res.status(200).json({ product });
  } catch (error) {
    res.status(500).json({ message: 'Failed to retrieve product', error });
  }
};
