abstract class ProductEvent {}

class ProductLoadEvent extends ProductEvent {
  final String productId;
  ProductLoadEvent(this.productId);
}

class ProductToggleFavoriteEvent extends ProductEvent {}

class ProductQuantityChangedEvent extends ProductEvent {
  final int quantity;
  ProductQuantityChangedEvent(this.quantity);
}

class ProductAddToCartEvent extends ProductEvent {}
