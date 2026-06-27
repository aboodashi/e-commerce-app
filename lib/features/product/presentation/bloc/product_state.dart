import '../../data/models/product_model.dart';

abstract class ProductState {}

class ProductInitialState extends ProductState {}

class ProductLoadingState extends ProductState {}

class ProductLoadedState extends ProductState {
  final ProductModel product;
  final bool isFavorite;
  final int quantity;

  ProductLoadedState({
    required this.product,
    required this.isFavorite,
    this.quantity = 1,
  });

  ProductLoadedState copyWith({bool? isFavorite, int? quantity}) {
    return ProductLoadedState(
      product: product,
      isFavorite: isFavorite ?? this.isFavorite,
      quantity: quantity ?? this.quantity,
    );
  }
}

class ProductErrorState extends ProductState {
  final String message;

  ProductErrorState(this.message);
}

class ProductAddedToCartState extends ProductState {}
