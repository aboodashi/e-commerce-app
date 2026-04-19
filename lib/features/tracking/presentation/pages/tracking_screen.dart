import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../core/app_routes.dart';

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Track Order')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Order ID: #4582910',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Estimated Delivery: 24 Oct 2026',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 48),

              _buildTrackingStep(
                title: 'Order Placed',
                subtitle: 'We have received your order',
                icon: Icons.assignment,
                isCompleted: true,
                isLast: false,
              ),
              _buildTrackingStep(
                title: 'Processing',
                subtitle: 'Your order is being prepared',
                icon: Icons.inventory_2,
                isCompleted: true,
                isLast: false,
              ),
              _buildTrackingStep(
                title: 'On The Way',
                subtitle: 'Your order is out for delivery',
                icon: Icons.local_shipping,
                isCompleted: false,
                isLast: false,
                isActive: true,
              ),
              _buildTrackingStep(
                title: 'Delivered',
                subtitle: 'Your order has been delivered',
                icon: Icons.check_circle,
                isCompleted: false,
                isLast: true,
              ),

              const Spacer(),
              CustomButton(
                text: 'Receive Order (Simulation)',
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.completeOrder,
                ),
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Cancel Order',
                isOutlined: true,
                onPressed: () => _showCancelDialog(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackingStep({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isCompleted,
    required bool isLast,
    bool isActive = false,
  }) {
    Color color = isCompleted
        ? AppColors.success
        : (isActive ? AppColors.primary : AppColors.border);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: isCompleted ? AppColors.success : AppColors.border,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isActive || isCompleted
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: isActive || isCompleted
                      ? AppColors.textPrimary
                      : AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Order'),
          content: const Text(
            'Are you sure you want to cancel this order? This action cannot be undone.',
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No, Keep It'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.main,
                  (route) => false,
                );
              },
              child: const Text(
                'Yes, Cancel',
                style: TextStyle(color: AppColors.error),
              ),
            ),
          ],
        );
      },
    );
  }
}
