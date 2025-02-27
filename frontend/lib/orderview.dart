
import 'package:flutter/material.dart';
/*import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tap_on/Service_Provider/SP_Dashboard.dart';
import 'package:tap_on/widgets/Loading.dart';
import 'package:http/http.dart' as http;*/

class UH_OrderView extends StatefulWidget {
  final Map<String, dynamic> order;
  const UH_OrderView({super.key, 
    required this.order,
  });

  @override
  State<UH_OrderView> createState() => _UH_OrderViewState();
}

class _UH_OrderViewState extends State<UH_OrderView> {
  /*TextEditingController _reasonController = TextEditingController();

  void handleAcceptOrder() async {
    LoadingDialog.show(context);
    try {
      final baseURL = dotenv.env['BASE_URL']; // Get the base URL
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final bodyData = {
        "order_id": widget.order['orderId'],
        "status": "accept",
        "reason": ""
      };
      final response = await http.put(
        Uri.parse('$baseURL/so/change/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(bodyData),
      ); // Send a GET request to the API
      final data = jsonDecode(response.body); // Decode the response
      final status = data['status']; // Get the status from the response
      // Check if the status is 200
      if (status == 200) {
        LoadingDialog.hide(context); // Hide the loading dialog
        // Navigate to the Verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SP_Dashboard(),
          ),
        );
      } else {
        // Show an error alert if the status is not 200
        LoadingDialog.hide(context); // Hide the loading dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        ); // Show an error alert
      }
    } catch (e) {
      // Show an error alert if an error occurs
      LoadingDialog.hide(context); // Hide the loading dialog
      debugPrint('Something went wrong $e'); // Print the error
    }
  }

  void handleRejectOrder() async {
    LoadingDialog.show(context);
    if (_reasonController.text.isEmpty || _reasonController.text == '') {
      LoadingDialog.hide(context);
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Oops...',
        text: 'Please enter a reason for rejection',
        backgroundColor: Colors.black,
        titleColor: Colors.white,
        textColor: Colors.white,
      );
      return;
    }
    try {
      final baseURL = dotenv.env['BASE_URL']; // Get the base URL
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final bodyData = {
        "order_id": widget.order['orderId'],
        "status": "accept",
        "reason": _reasonController.text
      };
      final response = await http.put(
        Uri.parse('$baseURL/so/change/status'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': '$token',
        },
        body: jsonEncode(bodyData),
      ); // Send a GET request to the API
      final data = jsonDecode(response.body); // Decode the response
      final status = data['status']; // Get the status from the response
      // Check if the status is 200
      if (status == 200) {
        LoadingDialog.hide(context); // Hide the loading dialog
        // Navigate to the Verification screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SP_Dashboard(),
          ),
        );
      } else {
        // Show an error alert if the status is not 200
        LoadingDialog.hide(context); // Hide the loading dialog
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          title: 'Oops...',
          text: 'Sorry, something went wrong',
          backgroundColor: Colors.black,
          titleColor: Colors.white,
          textColor: Colors.white,
        ); // Show an error alert
      }
    } catch (e) {
      // Show an error alert if an error occurs
      LoadingDialog.hide(context); // Hide the loading dialog
      debugPrint('Something went wrong $e'); // Print the error
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Order Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Information
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Booking ID', style: TextStyle(color: Colors.grey)),
                  Text(widget.order['orderId'],
                      style: const TextStyle(color: Colors.blue)),
                ],
              ),
              const SizedBox(height: 16),
              Text(widget.order['ordername'],
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Text('Date:', style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 8),
                  Text(widget.order['date']),
                ],
              ),
              const SizedBox(height: 8),
              const Row(
                children: [
                  Text('Time:', style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 8),
                  Text('12:00 PM'),
                ],
              ),
              const SizedBox(height: 25),

              const SizedBox(height: 16),

              // Price Details
              const Text('Price Detail', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildPriceRow('Price',
                        '${widget.order['price'] / widget.order['days']} x ${widget.order['days']} = ${widget.order['price']}'),
                    const Divider(),
                    _buildPriceRow('Sub Total', '${widget.order['price']}'),
                    const Divider(),
                    _buildPriceRow('Total Amount', '${widget.order['price']}',
                        isBold: true),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String price, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          price,
          style: TextStyle(
            fontSize: 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
