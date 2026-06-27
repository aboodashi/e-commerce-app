import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../bloc/product_bloc.dart';
import '../bloc/product_event.dart';
import '../bloc/product_state.dart';

class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProductBloc>().add(ProductLoadEvent(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listenWhen: (previous, current) => current is ProductAddedToCartState,
      listener: (context, state) {
        if (state is ProductAddedToCartState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to cart successfully')),
          );
        }
      },
      child: BlocBuilder<ProductBloc, ProductState>(
        buildWhen: (previous, current) => current is! ProductAddedToCartState,
        builder: (context, state) {
          if (state is ProductLoadingState || state is ProductInitialState) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProductErrorState) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ProductBloc>().add(
                          ProductLoadEvent(widget.productId),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is ProductLoadedState) {
            final product = state.product;
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      state.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: state.isFavorite ? Colors.red : null,
                    ),
                    onPressed: () {
                      context.read<ProductBloc>().add(
                        ProductToggleFavoriteEvent(),
                      );
                    },
                  ),
                ],
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'product_${product.id}',
                              child: product.images.isNotEmpty
                                  ? Image.network(
                                      product.images.first,
                                      height: 300,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    )
                                  : Container(
                                      height: 300,
                                      width: double.infinity,
                                      color: Colors.grey[200],
                                      child: const Icon(
                                        Icons.broken_image,
                                        size: 80,
                                      ),
                                    ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          product.name,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.displayMedium,
                                        ),
                                      ),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${product.rating} (${product.reviewsCount} reviews)',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Text(
                                    'Description',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.displaySmall,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    product.description,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          height: 1.5,
                                          color: AppColors.textSecondary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            offset: const Offset(0, -5),
                            blurRadius: 20,
                          ),
                        ],
                      ),
                      child: SafeArea(
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.border),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove),
                                    onPressed: () {
                                      if (state.quantity > 1) {
                                        context.read<ProductBloc>().add(
                                          ProductQuantityChangedEvent(
                                            state.quantity - 1,
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                  Text(
                                    state.quantity.toString(),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      context.read<ProductBloc>().add(
                                        ProductQuantityChangedEvent(
                                          state.quantity + 1,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              child: CustomButton(
                                text: 'Add to Cart',
                                icon: const Icon(
                                  Icons.shopping_bag_outlined,
                                  color: Colors.white,
                                ),
                                onPressed: () {
                                  context.read<ProductBloc>().add(
                                    ProductAddToCartEvent(),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
