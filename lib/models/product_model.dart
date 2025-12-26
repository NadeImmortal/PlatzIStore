class Product {
  final int id;
  final String title;
  final double price;
  final String description;
  final String imageUrl;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Safe image handling for Platzi API
    String img = 'https://placehold.co/600x400/png';
    if (json['images'] != null && (json['images'] as List).isNotEmpty) {
      String rawImg = json['images'][0];
      // Clean up brackets if API sends ["url"] stringified
      if (rawImg.startsWith('["') && rawImg.endsWith('"]')) {
         rawImg = rawImg.substring(2, rawImg.length - 2);
      }
      if (rawImg.isNotEmpty) img = rawImg;
    }

    return Product(
      id: json['id'],
      title: json['title'] ?? 'No Name',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? 'No description available',
      imageUrl: img,
    );
  }
}