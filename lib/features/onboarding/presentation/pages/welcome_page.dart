import 'package:flutter/material.dart';
import 'package:lawyerup_android/features/onboarding/presentation/pages/tutorial_1_page.dart';




class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
// Inside Stack children:
          MediaQuery.of(context).size.shortestSide >= 500
              ? Positioned(
            top: 10,
            left: -7,
            right: -7,
            bottom: -8,
            child: Image.asset(
              'assets/images/tabwelcome.png',
              fit: BoxFit.contain, // Or adjust as needed
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.high,
            ),
          )
              : Positioned(
            top: 10,
            left: -7,
            right: -7,
            bottom: -8,
            child: Image.asset(
              'assets/images/welcomescreen.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),


          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(_createSwipeRoute(const Tutorial1Page()));
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                label: const Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  backgroundColor: const Color(0xFF18EFCB),
                  foregroundColor: Colors.black,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Left swipe transition
  Route _createSwipeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Right to left
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
