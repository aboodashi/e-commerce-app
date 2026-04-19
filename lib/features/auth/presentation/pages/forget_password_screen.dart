import 'package:flstn_store/features/auth/presentation/widgets/custom_app_bar.dart';
import 'package:flstn_store/shared/widgets/custom_button.dart';
import 'package:flstn_store/shared/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        'Forgot Password',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your email address to get a link to reset your password.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 48),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email Address',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email is required';
                          }
                          if (!RegExp(
                            r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                          ).hasMatch(value)) {
                            return 'Enter a valid email format';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 48),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          return CustomButton(
                            text: state is AuthLoading
                                ? 'Sending...'
                                : 'Send Code',
                            onPressed: () {
                              if (state is! AuthLoading) {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthBloc>().add(
                                    ResetPasswordEvent(
                                      email: _emailController.text,
                                    ),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Password reset link sent to email!',
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                }
                              }
                            },
                          );
                        },
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
