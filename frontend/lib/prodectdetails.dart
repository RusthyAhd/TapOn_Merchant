import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductDetailPage extends StatefulWidget {
  final String productId;
  final String shopEmail;

  const ProductDetailPage({
    super.key,
    required this.productId,
    required this.shopEmail,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  Map<String, dynamic>? product;
  bool isLoading = true;
  bool productNotFound = false;

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  Future<void> fetchProductDetails() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.11.21.83:3000/api/product/${widget.productId}'),
      );

      if (response.statusCode == 200) {
        setState(() {
          product = json.decode(response.body)['product'];
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        setState(() {
          productNotFound = true;
          isLoading = false;
        });
      } else {
        print(
            'Failed to load product details. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Loading..."),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (productNotFound) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: const Text("Product Not Found"),
        ),
        body: const Center(child: Text("The requested product was not found.")),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(product?['name'] ?? 'Product Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 200,
              child: product?['image'] != null
                  ? Image.memory(
                      base64Decode(product!['image']),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(
                          child: Icon(Icons.broken_image,
                              size: 100, color: Colors.grey),
                        );
                      },
                    )
                  : const Center(
                      child: Icon(Icons.image, size: 100, color: Colors.grey)),
            ),
            const SizedBox(height: 16.0),
            Text(
              product?['name'] ?? 'Untitled',
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            Text(
              product?['address'] ?? 'No location',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const Divider(height: 24, thickness: 1),
            Text(
              'Price: ${product?['price'] ?? 'N/A'}',
              style: const TextStyle(
                  fontSize: 24,
                  color: Colors.blue,
                  fontWeight: FontWeight.bold),
            ),
            Text('Discount: ${product?['discount'] ?? 'No discount'}',
                style: const TextStyle(fontSize: 16)),
            Text('Brand: ${product?['brand'] ?? 'No brand'}',
                style: const TextStyle(fontSize: 14)),
            const Divider(height: 24, thickness: 1),
            const Text(
              'Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              product?['description'] ?? 'No description',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
