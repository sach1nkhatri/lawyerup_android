import 'package:flutter/material.dart';
import '../features/splash/pages/splash_page.dart';
import '../features/welcome/pages/welcome_page.dart';
import '../features/tutorials/pages/tutorial_1_page.dart';
import '../features/tutorials/pages/tutorial_2_page.dart';
import '../features/tutorials/pages/tutorial_3_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String tutorial1 = '/tutorial-1'; // new route
  static const String tutorial2 = '/tutorial-2'; // new route
  static const String tutorial3 = '/tutorial-3'; // new route
  static const String login = '/login'; // new route
  static const String signup = '/signup';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    welcome: (context) => const WelcomePage(),
    tutorial1: (context) => const Tutorial1Page(), // new screen
    tutorial2: (context) => const Tutorial2Page(), // new screen
    tutorial3: (context) => const Tutorial3Page(), // new screen
    login: (context) => const LoginPage(), // new screen
    signup: (context) => const SignUpPage(),
  };
}
