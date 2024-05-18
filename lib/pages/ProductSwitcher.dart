import 'package:flutter/material.dart';
import 'package:flutter_application_1/pages/addProductForm.dart';
import 'package:flutter_application_1/pages/chat/chatDirectory.dart';
import 'package:flutter_application_1/pages/chat/chatPage.dart';
import 'package:flutter_application_1/pages/chat/chatRoomsPage.dart';
import 'package:flutter_application_1/services/chatServices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/product.dart';
import '../services/WishListService.dart';
import '../services/ProductService.dart';


class ProductSwitcher extends StatefulWidget {
  @override
  _ProductSwitcherState createState() => _ProductSwitcherState();
}

class _ProductSwitcherState extends State<ProductSwitcher> {
  bool _showProducts = true;

  void _toggleView() {
    setState(() {
      _showProducts = !_showProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                setState(() {
                  _showProducts = true;
                });
              },
              child: Text(
                'My Products',
                style: TextStyle(
                  color: _showProducts ? Colors.blue : Colors.grey,
                ),
              ),
            ),
            Switch(
              value: _showProducts,
              onChanged: (value) {
                _toggleView();
              },
              activeColor: Color.fromARGB(255, 11, 45, 84),
              inactiveTrackColor: Color.fromARGB(255, 254, 210, 143),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _showProducts = false;
                });
              },
              child: Text(
                'Marketplace',
                style: TextStyle(
                  color: _showProducts ? Colors.grey : Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
     floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to the add page
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddProductScreen()),
            );
          },
          child: Icon(Icons.add),
          splashColor: Color.fromARGB(255, 11, 45, 84),
          backgroundColor: Color.fromARGB(255, 254, 210, 143),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      // Wrap the body with SafeArea and add padding to accommodate the bottom navigation bar
    body: Padding(
  padding: EdgeInsets.only(bottom: _showProducts ? 50 : 65),
  child: SafeArea(
    bottom: true,
    child: _showProducts ? ProductsWidget() : ProductsToBuyWidget(),
  ),
),

    );
  }
}

class ProductsWidget extends StatefulWidget {
  @override
  _ProductsWidgetState createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  late Future<List<Product>> _productsFuture;
 void initState() {
  super.initState();
  _loadProducts();
}

void _loadProducts() async {
    // Fetch products asynchronously
    try {
      setState(() {
        // Show spinner while loading
        _productsFuture = ProductService.getProducts(context, "660c6d7dff61d4d9295dd34d");
      });
    } catch (e) {
      // Handle error
      print("Error loading products: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: Container(
      color: Color.fromARGB(255, 222, 228, 245),
      
     child: FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show spinner while loading
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Show error message if there's an error
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final List<Product> products = snapshot.data!;
          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Card(
                color: Color.fromRGBO(255, 255, 255, 1), 
                    elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Image.network(
                          products[index].image??"",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            products[index].productName,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            products[index].description,
                            style: TextStyle(fontSize: 12),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '\$${products[index].price.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                color: Color.fromARGB(255, 11, 45, 84),
                                onPressed: () {
                                  _showEditPopup(context, products[index]);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),                
                              color: Colors.red,
                                onPressed: () {
                                  // Show delete confirm popup
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
    ),
  ),
);
  }
}

class ProductsToBuyWidget extends StatefulWidget {
  @override
  _ProductsToBuyWidgetState createState() => _ProductsToBuyWidgetState();
}

class _ProductsToBuyWidgetState extends State<ProductsToBuyWidget> {
  late Future<List<Product>> _productsFuture;
  late String username; 

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    // Fetch products asynchronously
    try {
      setState(() {
        // Show spinner while loading
        _productsFuture = WishListService.getProducts();
      });
    } catch (e) {
      // Handle error
      print("Error loading products: $e");
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
     appBar: AppBar(
          title: Text('Marketplace'),
          actions: [
            IconButton(
              icon: Icon(Icons.wechat_outlined,
                color: Colors.blue,
                size: 36.0,
                 semanticLabel: 'Old Chat'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatDirectoryPage()),
                );
              },
            ),
          ],
        ),
    body: Container(
      color: Color.fromARGB(255, 214, 214, 214),
      child: Center(
        child: FutureBuilder<List<Product>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show spinner while loading
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // Show error message if there's an error
              return Text('Error: ${snapshot.error}');
            } else {
              final List<Product> allProducts = snapshot.data!;
              final currentUserID = '660c6d7dff61d4d9295dd34d'; // Replace with actual user ID

              // Filter products based on sellerId
              final List<Product> filteredProducts = allProducts.where((product) => product.sellerId != currentUserID).toList();

              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 0.7,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    color: Color.fromRGBO(255, 255, 255, 1), // Use `Color.fromRGBO()` instead of `Color.fromARGB()`
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(
                                filteredProducts[index].image??"",
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                filteredProducts[index].productName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 4),
                              Text(
                                filteredProducts[index].description,
                                style: TextStyle(fontSize: 12),
                              ),
                              SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${filteredProducts[index].price.toStringAsFixed(2)}',
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromRGBO(34, 145, 71, 0.99)), // Use `Color.fromRGBO()` for the color
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.message),
                                    color: Color.fromARGB(255, 11, 45, 84),
                                    onPressed: () async {
                                      // Get the username
                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      String username = prefs.getString('username') ?? '';
                                      
                                      // Call the service function createRoom
                                      int roomId = await ChatService.createRoom(username, filteredProducts[index].sellerId);
                                      
                                      // Navigate to the chat room with the returned room ID
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => MessengerScreen(roomId: roomId)),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    ),
  );
}

}



class AddProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Center(
        child: Text('Add Product Page'),
      ),
    );
  }
}

void _showEditPopup(BuildContext context, Product product) {
  TextEditingController productNameController = TextEditingController(text: product.productName);
  TextEditingController descriptionController = TextEditingController(text: product.description);
  TextEditingController priceController = TextEditingController(text: product.price.toString());

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Edit Product',style: TextStyle(color: Color.fromARGB(255, 243, 182, 89))),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Product Name',enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 254, 182, 89)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 11, 45, 84)),
    ),
                          
                  ),
              ),
              TextFormField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description',enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 254, 182, 89)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 11, 45, 84)),
    ),
    ),
              ),
              TextFormField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Price',enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 254, 182, 89)),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color.fromARGB(255, 11, 45, 84)),
    ),
    ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0), // Adjust border radius as needed
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
          Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 11, 45, 84),
                borderRadius: BorderRadius.circular(8.0), // Adjust border radius as needed
              ),
              child: TextButton(
                onPressed: () {
                  // Perform edit action here
                  String editedProductName = productNameController.text;
                  String editedDescription = descriptionController.text;
                  double editedPrice = double.parse(priceController.text);

                  // Update the product with edited values
                  // Perform edit action here
                  // For example:
                  // productService.editProduct(product.id, editedProductName, editedDescription, editedPrice);

                  Navigator.of(context).pop();
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
,
        ],
      );
    },
  );
}