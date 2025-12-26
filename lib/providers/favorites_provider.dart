import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';

class FavoritesProvider with ChangeNotifier {
  final Map<int, Product> _items = {};

  Map<int, Product> get items => _items;

  bool isFavorite(int id) {
    return _items.containsKey(id);
  }

  Future<void> toggleFavorite(Product product) async {
    final user = FirebaseAuth.instance.currentUser;

    if (_items.containsKey(product.id)) {
      // 1. REMOVE
      _items.remove(product.id);
      notifyListeners();

      // Delete from Firestore
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(user.uid)
            .collection('items')
            .doc(product.id.toString())
            .delete();
      }
    } else {
      // 2. ADD
      _items.putIfAbsent(product.id, () => product);
      notifyListeners();

      // Add to Firestore
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('favorites')
            .doc(user.uid)
            .collection('items')
            .doc(product.id.toString())
            .set({
              'id': product.id,
              'title': product.title,
              'price': product.price,
              'imageUrl': product.imageUrl,
            });
      }
    }
  }

  // Clear Local State (For Logout)
  void clearLocal() {
    _items.clear();
    notifyListeners();
  }

  Future<void> loadFromFirestore() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      _items.clear(); 
      notifyListeners();
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('favorites')
          .doc(user.uid)
          .collection('items')
          .get();

      _items.clear(); 

      for (var doc in snapshot.docs) {
        _items.putIfAbsent(
          doc['id'],
          () => Product(
            id: doc['id'],
            title: doc['title'],
            price: doc['price'],
            description: "", 
            imageUrl: doc['imageUrl'],
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      print("Error loading favorites: $e");
    }
  }
}