import '../../data/models/cart_item_model.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final CartItemModel item;
  AddToCartEvent(this.item);
}

class RemoveFromCartEvent extends CartEvent {
  final String productId;
  RemoveFromCartEvent(this.productId);
}

class UpdateQuantityEvent extends CartEvent {
  final String productId;
  final int quantity;
  UpdateQuantityEvent(this.productId, this.quantity);
}
