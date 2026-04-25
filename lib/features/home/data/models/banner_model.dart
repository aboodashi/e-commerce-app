import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String imageUrl;
  final int order;
  final bool isActive;

  BannerModel({
    required this.imageUrl,
    required this.order,
    required this.isActive,
  });

  factory BannerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BannerModel(
      imageUrl: data['imageUrl'],
      order: data['order'],
      isActive: data['isActive'],
    );
  }
}
