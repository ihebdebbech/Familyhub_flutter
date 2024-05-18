import 'package:flutter/material.dart';

class Purchase {
  final String productName;
  final double price;
  final String imageUrl;

  Purchase(
      {required this.productName, required this.price, required this.imageUrl});
}

class PurchaseHistoryPage extends StatelessWidget {
  final List<Purchase> purchases = [
    Purchase(
        productName: "red car", price: 10.99, imageUrl: "assets/redcar.jpg"),
    Purchase(
        productName: "red car", price: 19.99, imageUrl: "assets/redcar.jpg"),
    // Add more purchases here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Purchase History'),
      ),
      body: ListView.builder(
        itemCount: purchases.length,
        itemBuilder: (context, index) {
          final purchase = purchases[index];
          return ListTile(
            leading: Image.asset(
              purchase.imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
            ),
            title: Text(purchase.productName),
            subtitle: Text('\$${purchase.price.toStringAsFixed(2)}'),
            // Add more details like date, quantity, etc. if needed
          );
        },
      ),
    );
  }
}
