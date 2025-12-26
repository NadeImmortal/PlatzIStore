import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';

class CartProvider with ChangeNotifier {
  final Map<int, CartItem> _items = {};

  Map<int, CartItem> get items => _items;

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, item) {
      total += item.price * item.quantity;
    });
    return total;
  }

  // ADD ITEM (Upsert to Firestore)
  Future<void> addItem(Product product) async {
    final user = FirebaseAuth.instance.currentUser;
    
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => CartItem(
          productId: existing.productId,
          title: existing.title,
          imageUrl: existing.imageUrl,
          price: existing.price,
          quantity: existing.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
          productId: product.id,
          title: product.title,
          imageUrl: product.imageUrl,
          price: product.price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();

    // UPDATE FIRESTORE (Specific Document)
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .doc(product.id.toString())
          .set(_items[product.id]!.toJson());
    }
  }

  // REMOVE ITEM (Delete from Firestore if needed)
  Future<void> removeSingleItem(int productId) async {
    if (!_items.containsKey(productId)) return;
    final user = FirebaseAuth.instance.currentUser;

    if (_items[productId]!.quantity > 1) {
      // Decrease Quantity
      _items.update(
        productId,
        (existing) => CartItem(
          productId: existing.productId,
          title: existing.title,
          imageUrl: existing.imageUrl,
          price: existing.price,
          quantity: existing.quantity - 1,
        ),
      );
      notifyListeners();
      
      // Update Firestore
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .doc(productId.toString())
            .set(_items[productId]!.toJson());
      }
    } else {
      // Remove completely
      _items.remove(productId);
      notifyListeners();

      // DELETE FROM FIRESTORE
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('carts')
            .doc(user.uid)
            .collection('items')
            .doc(productId.toString())
            .delete();
      }
    }
  }

  // CLEAR CART (For Checkout - Wipes DB)
  Future<void> clearCart() async {
    // 1. Clear Local
    _items.clear();
    notifyListeners();

    // 2. Clear Firestore
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final collection = FirebaseFirestore.instance
          .collection('carts')
          .doc(user.uid)
          .collection('items');
      
      // Get all documents and delete them one by one
      final snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    }
  }

  // CLEAR LOCAL (For Logout - Keeps DB)
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
          .collection('carts')
          .doc(user.uid)
          .collection('items')
          .get();

      _items.clear();

      for (var doc in snapshot.docs) {
        _items.putIfAbsent(
          int.parse(doc.id),
          () => CartItem(
            productId: doc['productId'],
            title: doc['title'],
            imageUrl: doc['imageUrl'],
            price: doc['price'],
            quantity: doc['quantity'],
          ),
        );
      }
      notifyListeners();
    } catch (e) {
      print("Error loading cart: $e");
    }
  }
}