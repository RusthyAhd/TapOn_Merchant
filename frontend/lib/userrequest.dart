import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RequestToolsPage extends StatefulWidget {
  @override
  _RequestToolsPageState createState() => _RequestToolsPageState();
}

class _RequestToolsPageState extends State<RequestToolsPage> {
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  String _currentLocation = 'No location selected';

  // Function to get the current location
  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, request the user to enable them
      return Future.error('Location services are disabled.');
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentLocation =
          'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
    });
  }

  // Function to handle the "Request Now" action
  Future<void> _submitRequest() async {
    final String fullName = _fullNameController.text;
    final String phoneNumber = _phoneNumberController.text;
    final String address = _addressController.text;

    final response = await http.post(
      Uri.parse('http://10.11.12.149:5000/api/request'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'fullName': fullName,
        'phoneNumber': phoneNumber,
        'address': address,
        'currentLocation': _currentLocation,
      }),
    );

    if (response.statusCode == 201) {
      // Request created successfully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Request created successfully')),
      );
    } else {
      // Failed to create request
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create request')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Tools'),
        backgroundColor: Colors.orange,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8.0,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Full Name TextField
                  TextField(
                    controller: _fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Phone Number TextField
                  TextField(
                    controller: _phoneNumberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Address TextField
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      prefixIcon: Icon(Icons.home),
                    ),
                  ),
                  SizedBox(height: 16.0),

                  // Use My Current Location Button
                  ElevatedButton.icon(
                    onPressed: _getCurrentLocation,
                    icon: Icon(Icons.location_on),
                    label: Text('Use My Current Location'),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 8.0),

                  // Display Current Location
                  Text(
                    _currentLocation,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),

            // Request Now Button
            ElevatedButton(
              onPressed: _submitRequest,
              child: Text('Request Now'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
