import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/WishListService.dart';

class ParentProduct extends StatelessWidget {
  final List<String> children = ['Child 1', 'Child 2', 'Child 3'];
  final String childid; // Sample list of children
  ParentProduct(this.childid);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Page'),
      ),
      body: ChildCard(
              childName: childid, childID: 2.toString())
        
    );
  }
}

class ChildCard extends StatelessWidget {
  final String childName;
  final String childID;
  const ChildCard({required this.childName, required this.childID});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the child's wishlist page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChildWishlistPage(childName: childName, childID: childID),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/child_avatar.jpg'),
                radius: 30,
              ),
              SizedBox(height: 8),
              Text(
                childName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChildWishlistPage extends StatefulWidget {
  final String childName;
  final String childID;

  ChildWishlistPage({required this.childName, required this.childID});

  @override
  _ChildWishlistPageState createState() => _ChildWishlistPageState();
}

class _ChildWishlistPageState extends State<ChildWishlistPage> {
  List<Product> wishlistProducts = [];

  @override
  void initState() {
    super.initState();
    fetchWishlistProducts(widget.childID);
  }


  Future<void> fetchWishlistProducts(String childID) async {
    try {
      // Fetch wished products from the wishlist
      List<Product> products = await WishListService.getAllProductDetails(childID);
      setState(() {
        wishlistProducts = products;
      });
    } catch (error) {
      // Handle errors if any
      print('Error fetching wishlist products: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.childName}\'s Wishlist'),
      ),
      body: Container(
decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 254, 210, 143),
              Color.fromARGB(255, 11, 45, 84),
            ],
            begin: Alignment.topCenter, // Adjusted to start from the top
            end: Alignment.bottomCenter, // Adjusted to end at the bottom
            stops: [0, 0.9],
            tileMode: TileMode.clamp,
          ),
        ),  child: ListView.builder(
        itemCount: wishlistProducts.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) {
              _removeProduct(index,widget.childID);
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.only(right: 16.0),
              child: Icon(Icons.delete, color: Colors.white),
            ),
            child: ProductCard(product: wishlistProducts[index],
            childId:widget.childID,
              onDelete: () => _removeProduct(index,widget.childID),),
          );
        },
      ),
      ),
    );
  }

 void _removeProduct(int index , String childId) async {
  // Get the product to be deleted
  Product productToRemove = wishlistProducts[index];

  // Remove the product from the list
  setState(() {
    wishlistProducts.removeAt(index);
  });

  // Call the service function to remove the product from the database
  await WishListService.deleteWishedProduct(childId, productToRemove.id);

  // Fetch the updated wishlist after deletion
  await fetchWishlistProducts(childId);
}

}



class ProductCard extends StatelessWidget {
  final Product product;
  final String childId;
  final VoidCallback onDelete;

  const ProductCard({required this.product, required this.childId ,required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromRGBO(255, 255, 255, 1),
      elevation: 4,
      margin: EdgeInsets.all(8), 
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.productName,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                      
                      SizedBox(height: 4),
                      Text(
                        'Type: ${product.type}',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                      SizedBox(height: 10),
                      Text(
                        product.description,
                        style: TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        _removeProductFromWishlist(context);
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.messenger_outline, color: Colors.blue),
                      onPressed: () {
                        WishListService.updateWishedProduct(childId,product.id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 8),
            Image.network(
                product.image ?? '', // Use the null-aware operator to handle nullable case
              width: 320,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 4),
                      Text(
                        'Price: ${product.price}\$',
                        style: TextStyle(fontSize: 18, color: Colors.green,fontWeight: FontWeight.bold,),
                      ),
          ],
        ),
      ),
    );
  }

   void _removeProductFromWishlist(BuildContext context) {
    // Show a snackbar to indicate successful deletion
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.productName} removed from wishlist'),
      ),
    );

    // Call the onDelete callback to remove the product from the wishlist
    onDelete();
  }
}
