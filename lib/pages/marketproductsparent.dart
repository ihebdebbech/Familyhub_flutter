// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../services/product.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'addProductForm.dart';
import '../models/product.dart';
import 'editproduct.dart';

class MarketPage extends StatefulWidget {
  @override
  _MarketPageState createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  bool _buttonsVisible = true;
  List<Product> _products = [];

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: Center(
                child: Visibility(
                  visible: _buttonsVisible,
                  child: Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          String userId = prefs.getString('userId') ?? '';
                          String sellerId = userId;
                          ProductService.getProducts(context, sellerId)
                              .then((products) {
                            setState(() {
                              _products = products;
                              _buttonsVisible = false;
                            });
                          }).catchError((error) {
                            print('Error fetching products: $error');
                          });
                        },
                        icon: Icon(Icons.shopping_basket),
                        label: Text('My Products'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.blue,
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 30.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: Icon(Icons.shopping_cart),
                        label: Text('Buy a Product'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.green,
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 30.0,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddProductScreen(),
                            ),
                          );
                        },
                        icon: Icon(Icons.add_shopping_cart),
                        label: Text('Add a Product to Sell'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFFFE27D),
                          textStyle: TextStyle(color: Color(0xFF17233D)),
                          padding: EdgeInsets.symmetric(
                            vertical: 15.0,
                            horizontal: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                ),
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 4,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Image of the product from Firebase Storage
                                product.image != null
                                    ? Image.network(
                                        product.image!,
                                        height: 120,
                                        fit: BoxFit.cover,
                                      )
                                    : Placeholder(), // Placeholder or alternative if image is not available
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          Text(
                                            'Product Name: ${product.productName}',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Description: ${product.description}',
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 2,
                                            style: TextStyle(fontSize: 14),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Price: \$${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Type: ${product.type}',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.edit),
                              color: Color.fromARGB(255, 56, 169, 194),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditProductScreen(product: product),
                                  ),
                                ).then((updatedProduct) {
                                  if (updatedProduct != null) {
                                    setState(() {
                                      _products[index] = updatedProduct;
                                    });
                                  }
                                });
                              },
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Colors.red,
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content: Text(
                                        'Are you sure you want to delete this product?',
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            try {
                                              await ProductService
                                                  .deleteProduct(
                                                      context, product.id);
                                              setState(() {
                                                _products.removeAt(index);
                                              });
                                              Navigator.of(context).pop();
                                            } catch (error) {
                                              print(
                                                  'Failed to delete product: $error');
                                            }
                                          },
                                          child: Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Visibility(
        visible: !_buttonsVisible,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 100.0, right: 25),
          child: FloatingActionButton(
            onPressed: () {
              setState(() {
                _buttonsVisible = true;
                _products.clear();
              });
            },
            child: Icon(Icons.arrow_back),
            backgroundColor: Color(0xFFFFE27D),
          ),
        ),
      ),
    );
  }
}
