import 'package:TapOn_merchant/Notification.dart';
import 'package:TapOn_merchant/addtocart.dart' as addtocart;
import 'package:TapOn_merchant/prodectmenu.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:TapOn_merchant/addtocart.dart';

class TapOnHomePage extends StatefulWidget {
  const TapOnHomePage({super.key});

  @override
  _TapOnHomePageState createState() => _TapOnHomePageState();
}

class _TapOnHomePageState extends State<TapOnHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title:
            const Text("TapOn Merchant", style: TextStyle(color: Colors.black)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UH_Notification(),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile and Balance Section
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Action when profile avatar is tapped
                    },
                    child: const CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'Rishaf',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_shopping_cart,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              addtocart.AddToCartPage(cartItems: []),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Service Selection
              const Text(
                "Choose your service",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // GridView for Services
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildServiceButton("Grocery", 'assets/grocery.png', context),
                  _buildServiceButton(
                      "Beverages", 'assets/beverages.png', context),
                  _buildServiceButton("Snacks", 'assets/snacks.png', context),
                  _buildServiceButton("CBL", 'assets/cbl.png', context),
                  _buildServiceButton("Anchor", 'assets/anchor.png', context),
                  _buildServiceButton(
                      "Household", 'assets/household.png', context),
                  _buildServiceButton("Bakery", 'assets/bakery.png', context),
                  _buildServiceButton("Dairy", 'assets/dairy.png', context),
                  _buildServiceButton("MY Cool", 'assets/my_cool.png', context),
                ],
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceButton(
      String label, String imagePath, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        try {
          final response = await http.get(
              Uri.parse('http://localhost:5000/api/tools/category/$label'));

          if (response.statusCode == 200) {
            var jsonResponse = json.decode(response.body);

            // Check if 'products' key exists
            if (jsonResponse['products'] != null) {
              List<dynamic> productsData = jsonResponse['products'];

              List<Map<String, dynamic>> products = productsData.map((product) {
                return {
                  '_id': product['_id'] as String? ?? '',
                  'name': product['name'] as String? ?? '',
                  'price': product['price']?.toString() ?? '0',
                  'image': product['image'] as String? ?? '',
                  'description': product['description'] as String? ?? '',
                };
              }).toList();

              // Navigate to ProductMenu with fetched products
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductMenu(
                    service: label,
                    shopName: 'TapOn',
                    shopEmail: 'shop@example.com',
                    shopPhone: '123456789',
                    products: products,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No products found')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to fetch products')),
            );
          }
        } catch (error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $error')),
          );
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Image.asset(imagePath, height: 50, width: 50),
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }
}
