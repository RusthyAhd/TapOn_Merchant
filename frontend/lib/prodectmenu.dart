import 'package:TapOn_merchant/prodectdetails.dart';
import 'package:TapOn_merchant/addtocart.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductMenu extends StatefulWidget {
  final String service;
  final String shopName;
  final String shopEmail;
  final String shopPhone;
  final List<Map<String, dynamic>> products;

  const ProductMenu({
    super.key,
    required this.service,
    required this.shopName,
    required this.shopEmail,
    required this.shopPhone,
    required this.products,
  });

  @override
  _ProductMenuState createState() => _ProductMenuState();
}

class _ProductMenuState extends State<ProductMenu> {
  List<Map<String, dynamic>> cartItems = [];

  Future<void> addToCart(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse('http://10.11.12.149:5000/api/cart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'productId': product['_id'],
        'name': product['name'],
        'price': product['price'],
        'image': product['image'],
      }),
    );

    if (response.statusCode == 201) {
      setState(() {
        cartItems.add(product);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${product['name']} added to cart')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product to cart')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.shopName} Products',
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddToCartPage(cartItems: cartItems),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to ${widget.service} service page!',
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  return productTile(context, product, widget.shopEmail);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget productTile(
      BuildContext context, Map<String, dynamic> product, String shopEmail) {
    String formattedImage = product['image'] ?? '';
    if (formattedImage.isNotEmpty && formattedImage.length % 4 != 0) {
      formattedImage += '=' * (4 - (formattedImage.length % 4));
    }

    Widget imageWidget;
    try {
      imageWidget = Image.memory(
        base64Decode(formattedImage),
        fit: BoxFit.cover,
        width: 100,
        height: 100,
      );
    } catch (e) {
      imageWidget =
          const Icon(Icons.broken_image, color: Colors.grey, size: 100);
    }

    return Card(
      color: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: SizedBox(
          width: 100,
          height: 100,
          child: ClipRRect(
              borderRadius: BorderRadius.circular(10), child: imageWidget),
        ),
        title: Text(product['name'] ?? 'Untitled',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text('Price: ${product['price'] ?? 'N/A'}',
            style: const TextStyle(fontSize: 14)),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            addToCart(product);
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                productId: product['_id'] ?? '',
                shopEmail: shopEmail,
              ),
            ),
          );
        },
      ),
    );
  }
}
