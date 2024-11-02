// controllers/requestcontroller.js
const Request = require('../model/requestmodel');

exports.createRequest = async (req, res) => {
  try {
    const { fullName, phoneNumber, address, currentLocation } = req.body;

    const newRequest = new Request({
      fullName,
      phoneNumber,
      address,
      currentLocation,
    });

    await newRequest.save();
    res.status(201).json({ message: 'Request created successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Failed to create request', error });
  }
};