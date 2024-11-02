// controllers/cartcontroller.js
const Cart = require('../model/cartmode');

exports.addToCart = async (req, res) => {
  try {
    const { productId, name, price, image } = req.body;

    const newCartItem = new Cart({
      productId,
      name,
      price,
      image,
    });

    await newCartItem.save();
    res.status(201).json({ message: 'Product added to cart successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to add product to cart', error });
  }
};

exports.getCartItems = async (req, res) => {
  try {
    const cartItems = await Cart.find();
    res.status(200).json(cartItems);
  } catch (error) {
    res.status(500).json({ message: 'Failed to fetch cart items', error });
  }
};