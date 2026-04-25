import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flstn_store/features/home/data/models/banner_model.dart';
import 'package:flstn_store/features/home/data/models/category_model.dart';
import 'package:flstn_store/features/home/data/models/product_model.dart';

class HomeRepository {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Banners
  Future<List<BannerModel>> getBanners() async {
    final snapshot = await _db
        .collection('banners')
        .where('isActive', isEqualTo: true)
        .orderBy('order')
        .get();
    print(
      "222222222222222222222222222222222222222222222222${snapshot.docs.map((doc) => BannerModel.fromFirestore(doc)).toList()}",
    );
    return snapshot.docs.map((doc) => BannerModel.fromFirestore(doc)).toList();
  }

  // Categories
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(seconds: 2));
    final snapshot = await _db.collection('categories').orderBy('order').get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromFirestore(doc))
        .toList();
  }

  // Products
  Future<List<ProductModel>> getProducts({
    bool? isNew,
    bool? isSale,
    bool? isPopular,
    int limit = 10,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    Query query = _db
        .collection('products')
        .where('isActive', isEqualTo: true)
        .limit(limit);

    if (isNew != null) {
      query = query.where('isNew', isEqualTo: isNew);
    }
    if (isSale != null) {
      query = query.where('isSale', isEqualTo: isSale);
    }
    if (isPopular != null) {
      query = query.where('isPopular', isEqualTo: isPopular);
    }

    final snapshot = await query.get();
    return snapshot.docs.map((doc) => ProductModel.fromFirestore(doc)).toList();
  }
}
