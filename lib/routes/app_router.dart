import 'package:flutter/material.dart';
import '../features/splash/pages/splash_page.dart';
import '../features/welcome/pages/welcome_page.dart';
import '../features/tutorials/pages/tutorial_1_page.dart';
import '../features/tutorials/pages/tutorial_2_page.dart';
import '../features/tutorials/pages/tutorial_3_page.dart';
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/signup_page.dart';
import '../features/dashboard/pages/dashboard_page.dart';
import '../features/ai_chat/pages/chat_page.dart';
import '../features/news/pages/news_page.dart';
import '../features/pdf_library/pages/pdf_library_page.dart';
import '../features/lawyer_up/pages/lawyer_up_page.dart';


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
  };
}
