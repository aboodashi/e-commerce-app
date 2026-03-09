import 'package:flstn_store/features/auth/presentation/widgets/custom_app_bar.dart';
import 'package:flstn_store/features/auth/presentation/widgets/custom_button.dart';
import 'package:flstn_store/features/auth/presentation/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import 'forget_password_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 48),
                    Text(
                      'Welcome Back!',
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to explore amazing products',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 25),
                    const CustomTextField(
                      hintText: 'Email Address',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    const CustomTextField(
                      hintText: 'Password',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                    ),
                    const SizedBox(height: 2),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgetPasswordScreen(),
                          ),
                        ),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    CustomButton(text: 'Sign In', onPressed: () {}),
                    const SizedBox(height: 24),

                    /// OR with lines
                    Row(
                      children: [
                        Expanded(
                          child: Divider(thickness: 1, color: Colors.black54),
                        ),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "OR",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        Expanded(
                          child: Divider(thickness: 1, color: Colors.black54),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    /// Social icons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        /// Apple
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.apple,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),

                        SizedBox(width: 20),

                        /// Google (placeholder)
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.g_mobiledata,
                            size: 30,
                            color: Colors.red,
                          ),
                        ),

                        SizedBox(width: 20),

                        /// Facebook
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.facebook,
                            size: 30,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 60),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                        TextButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SignupScreen(),
                            ),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
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
