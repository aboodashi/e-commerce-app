import 'package:flstn_store/features/auth/presentation/widgets/custom_app_bar.dart';
import 'package:flstn_store/shared/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/auth_bloc.dart';

class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 24),
                    const Icon(
                      Icons.mark_email_unread_outlined,
                      size: 100,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Verify your email',
                      style: Theme.of(context).textTheme.displayLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'We have sent an email verification link to your email address. Please verify to continue.',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 48),
                    CustomButton(
                      text: 'I\'ve Verified, Continue',
                      onPressed: () {
                        context.read<AuthBloc>().add(AuthCheckRequested());
                      },
                    ),
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(SendEmailVerificationEvent());
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Verification email resent!')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Resend Email',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(LogoutEvent());
                      },
                      child: const Text(
                        'Back to Login',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
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
}
