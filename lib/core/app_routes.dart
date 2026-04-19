import 'package:flutter/material.dart';

import '../features/onboarding/onboarding_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/signup_screen.dart';
import '../features/auth/presentation/pages/forget_password_screen.dart';
import '../features/home/presentation/pages/main_screen.dart';
import '../features/product/presentation/pages/product_details_screen.dart';
import '../features/cart/presentation/pages/cart_screen.dart';
import '../features/checkout/presentation/pages/checkout_screen.dart';
import '../features/tracking/presentation/pages/tracking_screen.dart';
import '../features/tracking/presentation/pages/complete_order_screen.dart';
import '../features/auth/presentation/pages/auth_wrapper.dart';
import '../features/auth/presentation/pages/email_verification_screen.dart';

class AppRoutes {
  // static const String splash = '/';
  static const String authWrapper = '/auth-wrapper';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String forgetPassword = '/forget-password';
  static const String emailVerification = '/email-verification';
  static const String main = '/main';
  static const String productDetails = '/product-details';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String tracking = '/tracking';
  static const String completeOrder = '/complete-order';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case splash:
      //   return _fadeRoute(const SplashScreen(), settings);
      case authWrapper:
        return _fadeRoute(const AuthWrapper(), settings);
      case onboarding:
        return _fadeRoute(const OnboardingScreen(), settings);
      case login:
        return _fadeRoute(const LoginScreen(), settings);
      case signup:
        return _slideRoute(const SignupScreen(), settings);
      case forgetPassword:
        return _slideRoute(const ForgetPasswordScreen(), settings);
      case emailVerification:
        return _fadeRoute(const EmailVerificationScreen(), settings);
      case main:
        return _fadeRoute(const MainScreen(), settings);
      case productDetails:
        final args = settings.arguments as Map<String, dynamic>;
        return _slideRoute(
          ProductDetailsScreen(
            id: args['id'],
            title: args['title'],
            imageUrl: args['imageUrl'],
            price: args['price'],
            rating: args['rating'],
            reviewsCount: args['reviewsCount'],
            description: args['description'],
          ),
          settings,
        );
      case cart:
        return _slideRoute(const CartScreen(), settings);
      case checkout:
        return _slideRoute(const CheckoutScreen(), settings);
      case tracking:
        return _slideRoute(const TrackingScreen(), settings);
      case completeOrder:
        return _fadeRoute(const CompleteOrderScreen(), settings);
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }

  // Fade Transition
  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  // Slide Transition
  static PageRouteBuilder _slideRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOutCubic;
        var tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
