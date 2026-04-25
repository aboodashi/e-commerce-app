import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String name;
  final String imageUrl;
  final int order;

  CategoryModel({
    required this.name,
    required this.imageUrl,
    required this.order,
  });

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      name: data['name'],
      imageUrl: data['imageUrl'],
      order: data['order'],
    );
  }
}
