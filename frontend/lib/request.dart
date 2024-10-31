/*import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google_maps;
import 'package:location/location.dart' as loc;
import 'package:geocoding/geocoding.dart';

class UT_ToolRequest extends StatefulWidget {
  final Map<String, dynamic>? product; // Optional product field
  final String? shopEmail; // Optional shop email field
  
  const UT_ToolRequest({
    this.product,
    this.shopEmail,
  });

  @override
  State<UT_ToolRequest> createState() => _UT_ToolRequestState();
}

class _UT_ToolRequestState extends State<UT_ToolRequest> {
  final List<String> weekdays = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
  List<String> selectedWeekdays = [];
  TextEditingController _qytController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  
  bool _isLoadingLocation = false;
  String _currentAddress = "";
  double? _latitude;
  double? _longitude;
  late google_maps.GoogleMapController mapController;
  final Set<google_maps.Marker> _markers = {};

  String? fullName;
  String? phoneNumber;
  String? address;

  @override
  void initState() {
    super.initState();
    selectedWeekdays = widget.product?['available_days'] != null
        ? List<String>.from(widget.product!['available_days'])
        : [];
    _qytController.text = '1';
  }

  bool isBase64(String str) {
    try {
      base64Decode(str);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _isLoadingLocation = true;
    });

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _showError('Location permissions are denied.');
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        _showError('Location permissions are permanently denied.');
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _latitude = position.latitude;
          _longitude = position.longitude;
          _currentAddress =
              "${place.locality}, ${place.postalCode}, ${place.country}";
          _locationController.text = place.locality ?? '';
          _markers.add(google_maps.Marker(
            markerId: google_maps.MarkerId('My Location'),
            position: google_maps.LatLng(_latitude ?? 6.9388614,
                _longitude ?? 79.8542005), // Default Location
            infoWindow: google_maps.InfoWindow(title: 'My Location'),
          ));
        });
      }
    } catch (e) {
      _showError('Error fetching location: $e');
    } finally {
      setState(() {
        _isLoadingLocation = false;
      });
    }
  }

  void _goToCurrentLocation() async {
    final loc.Location location = loc.Location();
    final currentLocation = await location.getLocation();
    if (currentLocation.latitude != null && currentLocation.longitude != null) {
      setState(() {
        _latitude = currentLocation.latitude;
        _longitude = currentLocation.longitude;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.yellow[700],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Request Tools',
          style: TextStyle(color: Colors.black, fontSize: screenWidth * 0.05),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight * 0.02),

              // Card containing form fields
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Full Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your full name'
                            : null,
                        onSaved: (value) => fullName = value!,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          prefixIcon: Icon(Icons.phone),
                        ),
                        validator: (value) => value!.isEmpty
                            ? 'Please enter your phone number'
                            : null,
                        onSaved: (value) => phoneNumber = value!,
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          prefixIcon: Icon(Icons.home),
                        ),
                        validator: (value) =>
                            value!.isEmpty ? 'Please enter your address' : null,
                        onSaved: (value) => address = value!,
                      ),
                       SizedBox(height: 16.0),
                      // Button to get current location
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: _getCurrentLocation,
                          icon: Icon(Icons.my_location),
                          label: Text('Use My Current Location'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            backgroundColor: Colors.amber,
                          ),
                        ),
                      ),
                      SizedBox(height: 16.0),

                      // Location details
                      _isLoadingLocation
                          ? Center(child: CircularProgressIndicator())
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (_currentAddress.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Current Address: $_currentAddress',
                                      style: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                                if (_latitude != null && _longitude != null)
                                  Text(
                                    'Latitude: $_latitude, Longitude: $_longitude',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                if (_latitude == null && _longitude == null)
                                  Text(
                                    'No location selected',
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.05),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showConfirmAlert(widget.product?['price'], _qytController.text.isEmpty ? '1' : _qytController.text);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.yellow,
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1, vertical: 15),
                    textStyle: TextStyle(fontSize: screenWidth * 0.045, color: Colors.white),
                  ),
                  child: Text('Request Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmAlert(String? price, String qyt) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Request'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Tool: ${widget.product?['title'] ?? 'title'}'),
              Text('Amount: LKR $price for $qyt quantity'),
              Text('Total: LKR ${double.tryParse(price ?? '0')! * int.parse(qyt)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}*/
