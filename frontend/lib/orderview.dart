import 'package:flutter/material.dart';

class UH_OrderView extends StatefulWidget {
  final Map<String, dynamic> order;
  const UH_OrderView({
    super.key,
    required this.order,
  });

  @override
  State<UH_OrderView> createState() => _UH_OrderViewState();
}

class _UH_OrderViewState extends State<UH_OrderView> {
  @override
  Widget build(BuildContext context) {
    // Extract data from the order map and provide default values if null
    final String orderId = widget.order['orderId'] ?? 'Unknown Order ID';
    final String productName = widget.order['productName'] ?? 'Unknown Product';
    final String customerName =
        widget.order['customerName'] ?? 'Unknown Customer';
    final String orderStatus = widget.order['orderStatus'] ?? 'Unknown Status';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: $orderId', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Product Name: $productName',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Customer Name: $customerName',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Order Status: $orderStatus',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Add your order handling logic here
              },
              child: const Text('Process Order'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.green, // Background color
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
