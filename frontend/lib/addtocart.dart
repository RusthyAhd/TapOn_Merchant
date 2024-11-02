import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddToCartPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;


  const AddToCartPage({Key? key, required this.cartItems}) : super(key: key);

  @override
  _AddToCartPageState createState() => _AddToCartPageState();
}

class _AddToCartPageState extends State<AddToCartPage> {
  List<Map<String, dynamic>> cartItems = [];
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  Future<void> fetchCartItems() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.11.12.149:5000/api/cart'),
      );

      if (response.statusCode == 200) {
        setState(() {
          cartItems =
              List<Map<String, dynamic>>.from(json.decode(response.body));
          calculateTotal();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch cart items')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching cart items: $e')),
      );
    }
  }

  void calculateTotal() {
    totalAmount = cartItems.fold(
      0,
      (sum, item) => sum + ((item['price'] ?? 0) * (item['quantity'] ?? 1)),
    );
    setState(() {});
  }

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]['quantity'] = (cartItems[index]['quantity'] ?? 1) + 1;
    });
    calculateTotal();
  }

  void decreaseQuantity(int index) {
    setState(() {
      if ((cartItems[index]['quantity'] ?? 1) > 1) {
        cartItems[index]['quantity']--;
      }
    });
    calculateTotal();
  }

  bool isValidBase64(String? base64String) {
    if (base64String == null) return false;
    final base64RegExp = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');
    return base64RegExp.hasMatch(base64String);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review Cart'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                cartItems.clear();
                totalAmount = 0;
              });
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${cartItems.length} Items',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 4.0, horizontal: 8.0),
                  child: Card(
                    child: ListTile(
                      leading: isValidBase64(item['image'])
                          ? Image.memory(
                              base64Decode(item['image'] ?? ''),
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) =>
                                  Icon(Icons.error),
                            )
                          : (item['image'] != null
                              ? Image.network(item['image'],
                                  width: 50,
                                  height: 50,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Icon(Icons.error))
                              : Icon(Icons.image)),
                      title: Text(item['name'] ?? 'Unknown Item'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['category'] ?? 'Unknown Category'),
                          Text(
                              'Rs.${(item['price'] ?? 0).toStringAsFixed(2)} (inclusive of all taxes)'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () => decreaseQuantity(index),
                          ),
                          Text((item['quantity'] ?? 1).toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () => increaseQuantity(index),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Rs.${totalAmount.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Implement checkout action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'Checkout',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
