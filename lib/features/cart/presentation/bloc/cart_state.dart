import '../../data/models/cart_item_model.dart';

abstract class CartState {}

class CartLoadingState extends CartState {}

class CartLoadedState extends CartState {
  final List<CartItemModel> items;
  final double total;

  CartLoadedState(this.items)
      : total = items.fold(
          0,
          (sum, item) => sum + item.price * item.quantity,
        );

  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);
}

class CartErrorState extends CartState {
  final String message;
  CartErrorState(this.message);
}
