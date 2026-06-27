import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flstn_store/features/home/presentation/pages/home_screen.dart';
import 'package:flstn_store/features/home/presentation/pages/notifications_screen.dart';
import 'package:flstn_store/features/home/presentation/pages/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../features/auth/presentation/pages/auth_wrapper.dart';
import '../features/auth/presentation/pages/email_verification_screen.dart';
import '../features/auth/presentation/pages/forget_password_screen.dart';
import '../features/auth/presentation/pages/login_screen.dart';
import '../features/auth/presentation/pages/signup_screen.dart';
import '../features/cart/presentation/pages/cart_screen.dart';
import '../features/checkout/presentation/pages/checkout_screen.dart';
import '../features/home/presentation/pages/account_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/product/data/product_repository.dart';
import '../features/product/presentation/bloc/product_bloc.dart';
import '../features/product/presentation/pages/product_details_screen.dart';
import '../features/tracking/presentation/pages/complete_order_screen.dart';
import '../features/tracking/presentation/pages/tracking_screen.dart';

class AppRoutes {
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
  static const String accountScreen = '/account-screen';
  static const String notificationsScreen = '/notifications-screen';
  static const String search = '/search';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
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
        return _fadeRoute(const HomeScreen(), settings);
      case accountScreen:
        return _slideRoute(const AccountScreen(), settings);
      case notificationsScreen:
        return _slideRoute(const NotificationsScreen(), settings);
      case search:
        return _slideRoute(const SearchScreen(), settings);
      case productDetails:
        final productId = settings.arguments as String;
        return _slideRoute(
          BlocProvider(
            create: (context) => ProductBloc(
              repository: ProductRepository(FirebaseFirestore.instance),
            ),
            child: ProductDetailsScreen(productId: productId),
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

  static PageRouteBuilder _fadeRoute(Widget page, RouteSettings settings) {
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

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
