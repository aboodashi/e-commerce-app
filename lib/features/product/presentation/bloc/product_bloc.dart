import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository repository;

  ProductBloc({required this.repository}) : super(ProductInitialState()) {
    on<ProductLoadEvent>(_onProductLoad);
    on<ProductToggleFavoriteEvent>(_onProductToggleFavorite);
    on<ProductQuantityChangedEvent>(_onProductQuantityChanged);
    on<ProductAddToCartEvent>(_onProductAddToCart);
  }

  Future<void> _onProductLoad(
    ProductLoadEvent event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoadingState());
    try {
      final product = await repository.getProductById(event.productId);
      emit(
        ProductLoadedState(product: product, isFavorite: false, quantity: 1),
      );
    } catch (e) {
      emit(ProductErrorState(e.toString()));
    }
  }

  void _onProductToggleFavorite(
    ProductToggleFavoriteEvent event,
    Emitter<ProductState> emit,
  ) {
    final currentState = state;
    if (currentState is ProductLoadedState) {
      emit(currentState.copyWith(isFavorite: !currentState.isFavorite));
    }
  }

  void _onProductQuantityChanged(
    ProductQuantityChangedEvent event,
    Emitter<ProductState> emit,
  ) {
    final currentState = state;
    if (currentState is ProductLoadedState) {
      emit(currentState.copyWith(quantity: event.quantity));
    }
  }

  void _onProductAddToCart(
    ProductAddToCartEvent event,
    Emitter<ProductState> emit,
  ) {
    if (state is ProductLoadedState) {
      final current = state as ProductLoadedState;
      emit(ProductAddedToCartState());
      emit(current);
    }
  }
}
