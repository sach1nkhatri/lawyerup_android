import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../app/routes/app_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )
      ..forward();

    Future.delayed(const Duration(seconds: 3), () async {
      final box = await Hive.openBox('settingsBox');
      final onboardingDone = box.get('onboardingComplete', defaultValue: false);
      final isLoggedIn = box.get('isLoggedIn', defaultValue: false);

      String route;
      if (!onboardingDone) {
        route = AppRouter.welcome;
      } else if (isLoggedIn) {
        route = AppRouter.dashboard;
      } else {
        route = AppRouter.login;
      }

      Navigator.pushReplacementNamed(context, route);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildSquareProgressBar() {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: 100,
          height: 8,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400, width: 1),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _controller.value,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                      'assets/images/logo2.png', width: 160, height: 160),
                  const SizedBox(height: 16),
                  const Text(
                    'LαɯყҽɾUρ',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  buildSquareProgressBar(),
                ],
              ),
            ),

            // ✅ Footer Text
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Developed by Sachin Khatri • v1.0.3',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
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