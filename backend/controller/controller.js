const Product = require('../model/model');

exports.getProductsByCategory = async (req, res) => {
  try {
    const { category } = req.params;
    const products = await Product.find({ category });
    res.json({ products });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching products', error });
  }
};
