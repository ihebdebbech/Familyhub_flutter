import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import '../models/WishList.dart';

class WishListService {
  static const String baseUrl = 'https://backend-secure-payment-for-kids.onrender.com';

  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse('$baseUrl/WishList/products'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<List<WishList>> getAllProductsWhished(String childId) async {
    final response = await http.get(Uri.parse('$baseUrl/WishList/$childId'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => WishList.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load wished products');
    }
  }

  static Future<WishList> addWishedProduct(Product product) async {
    final WishList wishedProduct = WishList(
      id: "", // The ID will be generated by the backend
      childId: "2", // Assuming a static child ID for this example
      productId: product
          .id, // Assuming the product ID is accessible from the 'Product' object
      statut:
          false, // Assuming the default status is "false" for new wished products
    );

    final Uri uri = Uri.parse('$baseUrl/wishlist/add');

    try {
      final http.Response response = await http.post(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(wishedProduct.toJson()),
      );

      if (response.statusCode == 201) {
        final dynamic responseData = json.decode(response.body);
        return WishList.fromJson(responseData);
      } else {
        // Print error response for debugging
        print(
            'Failed to add wished product - Status Code: ${response.statusCode}, Response Body: ${response.body}');
        throw Exception('Failed to add wished product');
      }
    } catch (error) {
      // Print error for debugging
      print('Failed to add wished product - Error: $error');
      throw Exception('Failed to add wished product');
    }
  }

  static Future<void> deleteWishedProduct(
      String childId, String productId) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl/wishlist/delete/$childId/$productId'));
      if (response.statusCode == 200) {
        // Product deleted successfully
        return;
      } else if (response.statusCode == 404) {
        // Product not found
        throw Exception('Wished product not found');
      } else {
        // Handle other error cases
        throw Exception('Failed to delete wished product');
      }
    } catch (error) {
      // Handle network errors
      throw Exception('Failed to delete wished product: $error');
    }
  }

  static Future<WishList> updateWishedProduct(
      String childId, String productId) async {
    final response =
        await http.put(Uri.parse('$baseUrl/wishlist/edit/$childId/$productId'));
    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      return WishList.fromJson(responseData);
    } else {
      throw Exception('Failed to update wished product');
    }
  }

  static Future<WishList?> getWishedProductById(
      String childId, String productId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/wishlist/$childId/$productId'));
    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      return WishList.fromJson(responseData);
    } else if (response.statusCode == 404) {
      // Handle product not found
      return null;
    } else {
      throw Exception('Failed to fetch wished product');
    }
  }

  static Future<List<Product>> getAllProductDetails(String childId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/wishlist/allProducts/$childId'));
    if (response.statusCode == 200) {
      final List<dynamic> responseData = json.decode(response.body);
      return responseData.map((data) => Product.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load wished products');
    }
  }
}
