// controllers/detailcontroller.js
const Product = require('../model/detailmodel');
const fs = require('fs');
const path = require('path');
const mongoose = require('mongoose');

exports.getProductById = async (req, res) => {
  try {
    const { id } = req.params;

    // Validate ObjectId
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(400).json({ message: 'Invalid product ID' });
    }

    const product = await Product.findById(id);
    if (!product) {
      return res.status(404).json({ message: 'Product not found' });
    }

    // Convert image path to base64 if stored as a file path
    if (product.image) {
      const imagePath = path.join(__dirname, '..', product.image);
      if (fs.existsSync(imagePath)) {
        const imageData = fs.readFileSync(imagePath, { encoding: 'base64' });
        product.image = imageData;
      } else {
        product.image = null; // or handle the missing image case as needed
      }
    }

    res.status(200).json({ product });
  } catch (error) {
    console.error('Error retrieving product:', error);
    res.status(500).json({ message: 'Failed to retrieve product', error });
  }
};