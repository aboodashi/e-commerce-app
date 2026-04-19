import 'package:flstn_store/features/auth/presentation/widgets/custom_app_bar.dart';
import 'package:flstn_store/shared/widgets/custom_button.dart';
import 'package:flstn_store/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/app_routes.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool('onboardingSeen', false);
      prefs.setBool('isLoggedIn', false);
    });

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const CustomAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
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
                        controller: _passwordController,
                        hintText: 'Password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 2),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(
                            context,
                            AppRoutes.forgetPassword,
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
                      BlocConsumer<AuthBloc, AuthState>(
                        listener: (context, state) {
                          if (state is Authenticated || state is AuthenticatedButNotVerified) {
                            // Let AuthWrapper handle root navigation context
                            // Or jump safely to root if this screen is pushed explicitly via Navigator
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
                        builder: (context, state) {
                          return CustomButton(
                            text: state is AuthLoading ? 'Loading...' : 'Sign In',
                            onPressed: () {
                              if (state is! AuthLoading) {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    LoginEvent(
                                      email: _emailController.text, 
                                      password: _passwordController.text
                                    )
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      Row(
                        children: const [
                          Expanded(child: Divider(thickness: 1, color: Colors.black54)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "OR",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ),
                          Expanded(child: Divider(thickness: 1, color: Colors.black54)),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.apple,
                              size: 30,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(width: 20),
                          
                          GestureDetector(
                            onTap: () {
                              context.read<AuthBloc>().add(GoogleLoginEvent());
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.g_mobiledata, // Google Sign In
                                size: 40,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          const SizedBox(width: 20),
                          
                          GestureDetector(
                            onTap: () {
                               context.read<AuthBloc>().add(GuestLoginEvent());
                            },
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                size: 30,
                                color: Colors.orange,
                              ),
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
                            onPressed: () => Navigator.pushNamed(context, AppRoutes.signup),
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
            ),
          ],
        ),
      ),
    );
  }
}
