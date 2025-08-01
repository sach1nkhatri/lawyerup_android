import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lawyerup_android/features/bookings/presentation/pages/booking_tab_page.dart';

import '../../features/law_ai_chat/presentation/pages/chat_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/signup_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/lawyer_up/domain/entities/lawyer.dart';
import '../../features/lawyer_up/presentation/bloc/lawyer_list_bloc.dart';
import '../../features/lawyer_up/presentation/pages/lawyer_preview_page.dart';
import '../../features/lawyer_up/presentation/pages/lawyer_up_page.dart';
import '../../features/news/presentation/pages/news_page.dart';
import '../../features/onboarding/presentation/pages/tutorial_1_page.dart';
import '../../features/onboarding/presentation/pages/tutorial_2_page.dart';
import '../../features/onboarding/presentation/pages/tutorial_3_page.dart';
import '../../features/onboarding/presentation/pages/welcome_page.dart';
import '../../features/pdf_library/presentation/pages/pdf_library_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../service_locater/service_locator.dart';
import '../../features/lawyer_up/presentation/bloc/lawyer_list_event.dart';




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
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String lawyerPreview = '/preview';
  static const String bookingTabPage = '/bookings';

  static final Map<String, WidgetBuilder> routes = {
    splash: (context) => const SplashPage(),
    welcome: (context) => const WelcomePage(),
    tutorial1: (context) => const Tutorial1Page(),
    tutorial2: (context) => const Tutorial2Page(),
    tutorial3: (context) => const Tutorial3Page(),
    login: (context) => const LoginPage(),
    signup: (context) => const SignupPage(),
    dashboard: (context) => const DashboardPage(),
    chat: (context) => const ChatPage(),
    news: (context) => const NewsPage(),
    pdf: (context) => const PdfLibraryPage(),
    settings: (context) => const SettingsPage(),

    // Booking Page
    bookingTabPage: (context) {
      return const BookingTabPage(); // no role passed, handled via Hive inside
    },



    // ✅ Lawyer List Page
    lawyer: (context) => BlocProvider(
      create: (_) => sl<LawyerListBloc>()..add(FetchAllLawyersEvent()),
      child: const LawyerUpPage(),
    ),

    // ✅ Lawyer Preview Page
    lawyerPreview: (context) {
      final lawyer = ModalRoute.of(context)!.settings.arguments as Lawyer;
      return LawyerUpPreviewPage(lawyer: lawyer); // Create this page!
    },
  };
}

