import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String name;
  final String description;
  final double price;
  final List<String> images;
  final String categoryId;
  final int stock;
  final bool isActive;
  final int createdAt;

  ProductModel({
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
      name: data['name'],
      description: data['description'],
      price: data['price'],
      images: data['images'],
      categoryId: data['categoryId'],
      stock: data['stock'],
      isActive: data['isActive'],
      createdAt: data['createdAt'],
    );
  }
}
