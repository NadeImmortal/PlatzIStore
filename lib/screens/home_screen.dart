import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product_model.dart';
import 'product_detail_screen.dart';
import '../services/auth_service.dart';
import 'cart_screen.dart';
import 'favorites_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../providers/favorites_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();
  User? _currentUser;

  @override
  void initState() {
    super.initState();

    // Initialize user immediately
    _currentUser = FirebaseAuth.instance.currentUser;

    // Load products and Providers
    _fetchProducts();
    Future.microtask(() {
      Provider.of<CartProvider>(context, listen: false).loadFromFirestore();
      Provider.of<FavoritesProvider>(context, listen: false).loadFromFirestore();
    });

    // This catches the name update if it happened while the screen was loading.
    Timer(const Duration(seconds: 1), () async {
      if (mounted) {
        await FirebaseAuth.instance.currentUser?.reload();
        setState(() {
          _currentUser = FirebaseAuth.instance.currentUser;
        });
      }
    });
  }

  Future<void> _fetchProducts() async {
    try {
      final products = await ApiService.getProducts();
      if (mounted) {
        setState(() {
          _allProducts = products;
          _filteredProducts = products;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error loading products: $e")),
        );
      }
    }
  }

  void _runFilter(String enteredKeyword) {
    List<Product> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allProducts;
    } else {
      results = _allProducts
          .where((product) =>
              product.title.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }

    setState(() {
      _filteredProducts = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get current user info
    final user = _currentUser ?? FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? "Guest";
    // Define colors based on theme for consistency
    final primaryColor = Theme.of(context).primaryColor;
    const backgroundColor = Color(0xFFF8F9FA); // Slightly off-white background

    return Scaffold(
      backgroundColor: backgroundColor,
      // Keep existing AppBar functionality but styled cleanly
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade200)
              ),
              child: const Icon(Icons.menu, color: Colors.black)
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
           IconButton(
            icon: Container(
               padding: const EdgeInsets.all(8),
               decoration: BoxDecoration(
                   color: Colors.white,
                   shape: BoxShape.circle,
                   border: Border.all(color: Colors.grey.shade200)
               ),
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.black)
            ),
            tooltip: 'CartIcon',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          ),
           IconButton(
             icon: Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                     color: Colors.red.shade50,
                     shape: BoxShape.circle,
                 ),
                 child: const Icon(Icons.logout, color: Colors.redAccent, size: 20)
             ),
            onPressed: () async {
              Provider.of<CartProvider>(context, listen: false).clearLocal();
              Provider.of<FavoritesProvider>(context, listen: false).clearLocal();
              await AuthService().signOut();
            },
          ),
          const SizedBox(width: 10),
        ],
      ),

      // Keep existing Drawer
      drawer: _buildDrawer(context, user, displayName),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            // Redesigned Greeting Section
            Text("Hello, $displayName!", style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
            Text("Let's find your clothes.", style: TextStyle(fontSize: 16, color: Colors.grey[600])),

            const SizedBox(height: 25),

            // Redesigned Search Bar Section
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
                      ]
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _runFilter,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        hintText: "Search products...",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // Visual Filter Button icon
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.tune, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("New Arrivals", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20)),
                TextButton(onPressed: () {}, child: const Text("View All"))
              ],
            ),
            const SizedBox(height: 10),

            // Product Grid
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  return _buildProductCard(_filteredProducts[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  //product card
  Widget _buildProductCard(Product product) {
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20), // More rounded
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 15, offset: const Offset(0, 5)) // Softer shadow
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (ctx, err, stack) => Container(color: Colors.grey[100], child: const Icon(Icons.broken_image, color: Colors.grey)),
                        )
                    ),
                    
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: Icon(Icons.favorite_border, size: 18, color: Colors.grey[400]),
                      )
                    )
                  ],
                ),
              ),
            ),
            // Details Section
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, height: 1.2),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${product.price}",
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: primaryColor),
                        ),
                        // Small add icon 
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), shape: BoxShape.circle),
                           child: Icon(Icons.add, size: 16, color: primaryColor)
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //widget for the Drawer to keep build method clean
  Widget _buildDrawer(BuildContext context, User? user, String displayName) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            accountName: Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            accountEmail: Text(user?.email ?? ""),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 40, color: Colors.grey),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesScreen()));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: () async {
              Provider.of<CartProvider>(context, listen: false).clearLocal();
              Provider.of<FavoritesProvider>(context, listen: false).clearLocal();
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}