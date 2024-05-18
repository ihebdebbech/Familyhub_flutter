import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  static const String baseUrl =
      'https://backend-secure-payment-for-kids.onrender.com'; // Update with your backend URL

  static Future<List<Product>> getProducts(
      BuildContext context, String sellerId) async {
    final response = await http.get(Uri.parse('$baseUrl/product/$sellerId'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      // Show a dialog if no products are found
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Products Found'),
            content: const Text(
                'No products found. Please add a product for sale before using this feature.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
      return []; // Return an empty list of products
    } else {
      // Handle other error cases
      throw Exception('Failed to load products');
    }
  }

  static Future<Product?> getProductById(String productId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/product/detail/$productId'));
    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      return Product.fromJson(responseData);
    } else if (response.statusCode == 404) {
      return null; // Product not found
    } else {
      throw Exception('Failed to fetch product');
    }
  }
}
