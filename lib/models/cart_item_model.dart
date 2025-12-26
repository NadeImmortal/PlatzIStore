class CartItem {
  final int productId;
  final String title;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  // To convert to JSON for Firestore
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'title': title,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }
}