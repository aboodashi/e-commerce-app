class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final double rating;
  final int reviewsCount;
  final String categoryId;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.rating,
    required this.reviewsCount,
    required this.categoryId,
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      images: List<String>.from(data['images'] ?? []),
      rating: (data['rating'] ?? 0).toDouble(),
      reviewsCount: data['reviewsCount'] ?? 0,
      categoryId: data['categoryId'] ?? '',
    );
  }
}
