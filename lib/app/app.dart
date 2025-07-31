import 'package:flutter/material.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';
import '../main.dart'; // for navigatorKey

class LawyerUpApp extends StatelessWidget {
  const LawyerUpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LawyerUp AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRouter.splash,
      routes: AppRouter.routes,
      navigatorKey: navigatorKey,
    );
  }
}
