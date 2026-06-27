import 'package:cloud_firestore/cloud_firestore.dart';

import 'models/product_model.dart';

class ProductRepository {
  final FirebaseFirestore firestore;

  ProductRepository(this.firestore);

  Future<ProductModel> getProductById(String id) async {
    final doc = await firestore.collection('products').doc(id).get();

    if (!doc.exists || doc.data() == null) {
      throw Exception('Product not found');
    }

    return ProductModel.fromFirestore(doc.id, doc.data()!);
  }
}
