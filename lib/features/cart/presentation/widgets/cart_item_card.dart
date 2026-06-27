import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../data/models/cart_item_model.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_event.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;

  const CartItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: item.image.isEmpty
                ? Container(
                    width: 80,
                    height: 80,
                    color: AppColors.background,
                    child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                  )
                : Image.network(
                    item.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, e, s) => Container(
                      width: 80,
                      height: 80,
                      color: AppColors.background,
                      child: const Icon(Icons.broken_image, color: AppColors.textSecondary),
                    ),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _QuantityButton(
                      icon: Icons.remove,
                      onTap: () {
                        context.read<CartBloc>().add(
                              UpdateQuantityEvent(
                                item.productId,
                                item.quantity - 1,
                              ),
                            );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    _QuantityButton(
                      icon: Icons.add,
                      onTap: () {
                        context.read<CartBloc>().add(
                              UpdateQuantityEvent(
                                item.productId,
                                item.quantity + 1,
                              ),
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error),
            onPressed: () {
              context.read<CartBloc>().add(RemoveFromCartEvent(item.productId));
            },
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Icon(icon, size: 16, color: AppColors.textPrimary),
      ),
    );
  }
}
