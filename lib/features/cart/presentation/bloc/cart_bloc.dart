import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/cart_repository.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final CartRepository repository;

  CartBloc({required this.repository}) : super(CartLoadingState()) {
    on<LoadCartEvent>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateQuantityEvent>(_onUpdateQuantity);
  }

  Future<void> _onLoadCart(
    LoadCartEvent event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoadingState());
    try {
      final items = await repository.loadCart();
      emit(CartLoadedState(items));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  Future<void> _onAddToCart(
    AddToCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    final currentItems =
        current is CartLoadedState ? current.items : [];
    try {
      final items = await repository.addToCart(
        List.from(currentItems),
        event.item,
      );
      emit(CartLoadedState(items));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCartEvent event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is! CartLoadedState) return;
    try {
      final items = await repository.removeFromCart(
        List.from(current.items),
        event.productId,
      );
      emit(CartLoadedState(items));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantityEvent event,
    Emitter<CartState> emit,
  ) async {
    final current = state;
    if (current is! CartLoadedState) return;
    try {
      final items = await repository.updateQuantity(
        List.from(current.items),
        event.productId,
        event.quantity,
      );
      emit(CartLoadedState(items));
    } catch (e) {
      emit(CartErrorState(e.toString()));
    }
  }
}
