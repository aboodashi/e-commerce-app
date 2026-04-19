import 'package:flstn_store/features/auth/presentation/widgets/custom_app_bar.dart';
import 'package:flstn_store/shared/widgets/custom_button.dart';
import 'package:flstn_store/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../bloc/auth_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  bool _showPassword = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedButNotVerified || state is Authenticated) {
          Navigator.pushNamedAndRemoveUntil(context, AppRoutes.authWrapper, (route) => false);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              const CustomAppBar(),
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Sign up to get started!',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 48),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                controller: _firstNameController,
                                hintText: 'First Name',
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Required';
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: CustomTextField(
                                controller: _lastNameController,
                                hintText: 'Last Name',
                                validator: (val) {
                                  if (val == null || val.isEmpty) return 'Required';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email is required';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                              return 'Enter a valid email format';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _phoneController,
                          hintText: 'Phone number',
                          prefixIcon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: !_showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextField(
                          controller: _confirmPasswordController,
                          hintText: 'Confirm Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: !_showPassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _showPassword, 
                              onChanged: (value) {
                                setState(() {
                                  _showPassword = value ?? false;
                                });
                              }
                            ),
                            const Text("Show Password", style: TextStyle(fontSize: 16)),
                          ],
                        ),
                        const SizedBox(height: 48),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            return CustomButton(
                              text: state is AuthLoading ? 'Loading...' : 'Sign Up',
                              onPressed: () {
                                if (state is! AuthLoading) {
                                  if (_formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      RegisterEvent(email: _emailController.text, password: _passwordController.text)
                                    );
                                  }
                                }
                              }
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        OutlinedButton(
                          onPressed: () {
                             context.read<AuthBloc>().add(GuestLoginEvent());
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 56),
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text(
                            'Continue without account',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Already have an account?',
                              style: TextStyle(color: AppColors.textSecondary),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                              child: const Text(
                                'Sign In',
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
