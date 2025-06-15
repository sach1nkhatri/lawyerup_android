import 'package:flutter/material.dart';

import '../../features/ai_chat/presentation/pages/chat_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/lawyer_up/presentation/pages/lawyer_up_page.dart';
import '../../features/news/presentation/pages/news_page.dart';
import '../../features/onboarding/presentation/pages/tutorial_1_page.dart';
import '../../features/onboarding/presentation/pages/tutorial_2_page.dart';
import '../../features/onboarding/presentation/pages/tutorial_3_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/pdf_library/presentation/pages/pdf_library_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';




class AppRouter {
  static const String splash = '/';
  static const String welcome = '/welcome';
  static const String tutorial1 = '/tutorial-1';
  static const String tutorial2 = '/tutorial-2';
  static const String tutorial3 = '/tutorial-3';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String chat = '/chat';
  static const String news = '/news';
  static const String pdf = '/pdfpage';
  static const String lawyer = '/lawyerup';

  //  New routes for bottom navigation pages
  static const String profile = '/profile';
  static const String settings = '/settings';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    welcome: (context) => const WelcomePage(),
    tutorial1: (context) => const Tutorial1Page(),
    tutorial2: (context) => const Tutorial2Page(),
    tutorial3: (context) => const Tutorial3Page(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignUpPage(),
    dashboard: (context) => const DashboardPage(),
    chat: (context) => const ChatPage(),
    news: (context) => const NewsPage(),
    pdf: (context) => const PdfLibraryPage(),
    lawyer: (context) => const LawyerUpPage(),
    settings: (context) => const SettingsPage(),
  };
}
