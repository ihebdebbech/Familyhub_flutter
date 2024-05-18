import 'package:flutter/material.dart';
import '../services/WishListService.dart';
import '../models/product.dart';
import '../models/WishList.dart';


class WishProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safe Payment',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ProductListPage(),
        '/wishlist': (context) => WishlistPage(),
      },
            debugShowCheckedModeBanner: false,
    );
  }
}

class ProductListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () async{
             await Navigator.pushNamed(context, '/wishlist');
              // Refresh the ProductListPage
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: WishListService.getProducts(), // Fetch products asynchronously
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<Product> products = snapshot.data ?? [];
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 0.7,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                // Check if the product is in the wishlist
                return FutureBuilder<WishList?>(
                  future: WishListService.getWishedProductById(
                    "2",
                    products[index].id, // Assuming productId is stored in Product model as 'id'
                  ),
                  builder: (context, wishSnapshot) {
                    if (wishSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (wishSnapshot.hasError) {
                      return Center(
                          child: Text('Error: ${wishSnapshot.error}'));
                    } else {
                      //final WishList? wishedProduct = wishSnapshot.data;
                      //if (wishedProduct == null) {
                        // Product is not in the wishlist, display it
                        return ProductCard(product: products[index]);
                      /*} else {
                        return Visibility(
  visible: false,
  child: ProductCard(product: products[index]),
);
                      }*/
                    }
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    // Check if the product is in the wishlist and update isFavorite accordingly
    WishListService.getWishedProductById("2", widget.product.id)
        .then((wishedProduct) {
      setState(() {
        isFavorite = wishedProduct != null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isFavorite = !isFavorite;
          // Handle adding/removing product to/from wishlist
          if (isFavorite) {
            WishlistPage.selectedProducts.add(widget.product);
            WishListService.addWishedProduct(widget.product);
          } else {
            WishlistPage.selectedProducts.remove(widget.product);
            WishListService.deleteWishedProduct("2", widget.product.id);
          }
        });
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/product.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.productName,
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Price: \$${widget.product.price}',
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                  // Handle adding/removing product to/from wishlist
                  if (isFavorite) {
                    WishlistPage.selectedProducts.add(widget.product);
                    WishListService.addWishedProduct(widget.product);
                  } else {
                    WishlistPage.selectedProducts.remove(widget.product);
                    WishListService.deleteWishedProduct("2", widget.product.id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class WishlistPage extends StatefulWidget {
  static List<Product> selectedProducts = [];

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    // Fetch old products from the wishlist when the page is initialized
    fetchOldProducts();
  }

  Future<void> fetchOldProducts() async {
    try {
      // Fetch wished products from the wishlist
      final List<Product> oldProducts = await WishListService.getAllProductDetails('2');

      // Clear the existing selectedProducts list before updating
      setState(() {
        WishlistPage.selectedProducts = oldProducts;
      });
    } catch (error) {
      // Handle errors if any
      print('Error fetching old products from wishlist: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),
      body: ListView.builder(
        itemCount: WishlistPage.selectedProducts.length,
        itemBuilder: (context, index) {
          final Product product = WishlistPage.selectedProducts[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                border: Border.all(color: Colors.grey),
              ),
              child: ListTile(
                title: Text(
                  product.productName,
                  style: const TextStyle(fontSize: 18.0),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      WishlistPage.selectedProducts.removeAt(index);
                    });

                    // Delete the wished product from the wishlist
                    WishListService.deleteWishedProduct("2", product.id);
                    //Navigator.pop(context);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

