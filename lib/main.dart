import 'package:firebase_core/firebase_core.dart';
import 'package:flstn_store/features/auth/data/auth_repository.dart';
import 'package:flstn_store/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flstn_store/features/cart/data/cart_repository.dart';
import 'package:flstn_store/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:flstn_store/features/cart/presentation/bloc/cart_event.dart';
import 'package:flstn_store/features/home/data/home_repository.dart';
import 'package:flstn_store/features/home/presentation/bloc/home_bloc.dart';
import 'package:flstn_store/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'core/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final bool onboardingSeen = prefs.getBool('onboardingSeen') ?? false;

  await Firebase.initializeApp(
    ////////////////////////////////////////////////////
    options: DefaultFirebaseOptions.currentPlatform,
  );

  String initialRoute = AppRoutes.login;
  if (isLoggedIn) {
    initialRoute = AppRoutes.main;
  } else if (!onboardingSeen) {
    initialRoute = AppRoutes.onboarding;
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(authRepository: AuthRepository()),
        ),
        BlocProvider(
          create: (context) => HomeBloc(homeRepository: HomeRepository()),
        ),
        BlocProvider(
          create: (context) => CartBloc(repository: CartRepository())
            ..add(LoadCartEvent()),
        ),
      ],
      child: MyApp(initialRoute: initialRoute),
    ),
  );
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flstn Store',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: initialRoute,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}
