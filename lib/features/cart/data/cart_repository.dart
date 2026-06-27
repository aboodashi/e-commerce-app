import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'models/cart_item_model.dart';

class CartRepository {
  static const String _cartKey = 'cart_items';

  Future<List<CartItemModel>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_cartKey);
    if (raw == null) return [];
    final List<dynamic> decoded = jsonDecode(raw);
    return decoded
        .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveCart(List<CartItemModel> items) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(items.map((e) => e.toJson()).toList());
    await prefs.setString(_cartKey, encoded);
  }

  Future<List<CartItemModel>> addToCart(
    List<CartItemModel> currentItems,
    CartItemModel newItem,
  ) async {
    final items = List<CartItemModel>.from(currentItems);
    final index = items.indexWhere((i) => i.productId == newItem.productId);
    if (index >= 0) {
      items[index] = items[index].copyWith(
        quantity: items[index].quantity + newItem.quantity,
      );
    } else {
      items.add(newItem);
    }
    await saveCart(items);
    return items;
  }

  Future<List<CartItemModel>> removeFromCart(
    List<CartItemModel> currentItems,
    String productId,
  ) async {
    final items = currentItems.where((i) => i.productId != productId).toList();
    await saveCart(items);
    return items;
  }

  Future<List<CartItemModel>> updateQuantity(
    List<CartItemModel> currentItems,
    String productId,
    int quantity,
  ) async {
    final items = List<CartItemModel>.from(currentItems);
    final index = items.indexWhere((i) => i.productId == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = items[index].copyWith(quantity: quantity);
      }
    }
    await saveCart(items);
    return items;
  }
}
