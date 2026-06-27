import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';
import '../bloc/cart_state.dart';
import '../widgets/cart_item_card.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CartBloc>().add(LoadCartEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoadingState) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartErrorState) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<CartBloc>().add(LoadCartEvent()),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is CartLoadedState) {
            if (state.items.isEmpty) {
              return _EmptyCart();
            }

            return SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        return CartItemCard(item: state.items[index]);
                      },
                    ),
                  ),
                  _CartSummary(state: state),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 56,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add items to get started',
            style: TextStyle(
              fontSize: 15,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            child: CustomButton(
              text: 'Shop Now',
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.main,
                (route) => false,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartSummary extends StatelessWidget {
  final CartLoadedState state;

  const _CartSummary({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            offset: const Offset(0, -4),
            blurRadius: 20,
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${state.itemCount} ${state.itemCount == 1 ? 'item' : 'items'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const Text(
                  'Total',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox.shrink(),
                Text(
                  '\$${state.total.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Proceed to Checkout',
              icon: const Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
              ),
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.checkout),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
