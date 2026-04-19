import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/app_routes.dart';

final List<Map<String, dynamic>> _placeholderCartItems = [
  {
    'id': '1',
    'title': 'Premium Headphones',
    'price': 199.99,
    'imageUrl':
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1000&auto=format&fit=crop',
    'quantity': 1,
  },
  {
    'id': '2',
    'title': 'Smart Watch Series 7',
    'price': 299.99,
    'imageUrl':
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?q=80&w=1000&auto=format&fit=crop',
    'quantity': 1,
  },
];

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final total = _placeholderCartItems.fold<double>(
      0,
      (previous, item) => previous + (item['price'] as double),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('My Cart')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(24.0),
                itemCount: _placeholderCartItems.length,
                itemBuilder: (context, index) {
                  final product = _placeholderCartItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          // ignore: deprecated_member_use
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product['imageUrl'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '\$${(product['price'] as double).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  _buildQuantityButton(Icons.remove),
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                    child: Text(
                                      '1',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  _buildQuantityButton(Icons.add),
                                ],
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                          ),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  );
                },
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
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Total',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: 'Checkout',
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRoutes.checkout),
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

  Widget _buildQuantityButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16),
    );
  }
}
