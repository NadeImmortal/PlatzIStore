import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favorites = Provider.of<FavoritesProvider>(context);
    final items = favorites.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("My Favorites")),
      body: items.isEmpty
          ? const Center(child: Text("No favorites yet"))
          : ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final product = items[index];
                return ListTile(
                  leading: Image.network(product.imageUrl, width: 50, fit: BoxFit.cover),
                  title: Text(product.title),
                  subtitle: Text("\$${product.price}"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
                    );
                  },
                );
              },
            ),
    );
  }
}