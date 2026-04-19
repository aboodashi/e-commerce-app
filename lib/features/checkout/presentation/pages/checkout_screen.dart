import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../core/app_routes.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Contact Information',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Email or phone number'),
              const SizedBox(height: 32),

              Text(
                'Delivery Address',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Full Name'),
              const SizedBox(height: 16),
              const CustomTextField(hintText: 'Street Address'),
              const SizedBox(height: 16),
              Row(
                children: const [
                  Expanded(child: CustomTextField(hintText: 'City')),
                  SizedBox(width: 16),
                  Expanded(child: CustomTextField(hintText: 'Postal Code')),
                ],
              ),
              const SizedBox(height: 32),

              Text(
                'Payment Method',
                style: Theme.of(context).textTheme.displaySmall,
              ),
              const SizedBox(height: 16),
              _buildPaymentOption('Credit Card', Icons.credit_card, true),
              const SizedBox(height: 12),
              _buildPaymentOption('PayPal', Icons.paypal, false),
              const SizedBox(height: 12),
              _buildPaymentOption('Cash on Delivery', Icons.money, false),
              const SizedBox(height: 48),

              CustomButton(
                text: 'Confirm Order',
                onPressed: () =>
                    Navigator.pushNamed(context, AppRoutes.tracking),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.05)
            : AppColors.surface,
        border: Border.all(
          color: isSelected ? AppColors.primary : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isSelected ? AppColors.primary : AppColors.textSecondary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? AppColors.primary : AppColors.textPrimary,
              ),
            ),
          ),
          if (isSelected)
            const Icon(Icons.check_circle, color: AppColors.primary),
        ],
      ),
    );
  }
}
