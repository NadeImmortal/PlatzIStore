import 'package:flutter/material.dart';
import '../models/product_model.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context);
    final isFav = favorites.isFavorite(product.id);
    return Scaffold(
      extendBodyBehindAppBar: true, // Allows image to go behind the back button
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.black,
                ),
                onPressed: () {
                  favorites.toggleFavorite(product);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Added to Favorites!")),
                  );
                },
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          //Large Product Image
          Expanded(
            flex: 5, // Takes up top 50% of screen
            child: Container(
              width: double.infinity,
              color: Colors.grey[200],
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => const Center(
                  child: Icon(Icons.broken_image, size: 100, color: Colors.grey),
                ),
              ),
            ),
          ),

          //Product Info
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Men's Style",
                              style: TextStyle(color: Colors.grey[500]),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              product.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D1F22),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "Price",
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                          Text(
                            "\$${product.price}",
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D1F22),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),

                  // Description
                  const Text(
                    "Description",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        product.description,
                        style: TextStyle(color: Colors.grey[600], height: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // "Add to Cart" Button
                  ElevatedButton(
                    
                    onPressed: () {
                      Provider.of<CartProvider>(context, listen: false).addItem(product);
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                             content: Text("Added ${product.title} to Cart!"),
                            duration: const Duration(seconds: 1),
                            backgroundColor: Theme.of(context).primaryColor,
                            
                    ),
         );
         
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9775FA),
                      foregroundColor: Colors.white, // White Text
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15), // Rounded corners
                      ),
                    ),
                    child: const Text("Add to Cart", semanticsLabel: "Add to Cart"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}