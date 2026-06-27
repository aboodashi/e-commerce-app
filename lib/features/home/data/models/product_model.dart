import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<dynamic> images;
  final String categoryId;
  final int stock;
  final bool isActive;
  final Timestamp createdAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.images,
    required this.categoryId,
    required this.stock,
    required this.isActive,
    required this.createdAt,
  });

  factory ProductModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ProductModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      images: data['images'] ?? [],
      categoryId: data['categoryId'] ?? '',
      stock: data['stock'] ?? 0,
      isActive: data['isActive'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }
}
