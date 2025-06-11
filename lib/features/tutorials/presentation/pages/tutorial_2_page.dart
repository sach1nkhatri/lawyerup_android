import 'package:flutter/material.dart';
import 'package:lawyerup_android/features/tutorials/presentation/pages/tutorial_3_page.dart';

class Tutorial2Page extends StatelessWidget {
  const Tutorial2Page({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Full background tutorial image
          Positioned(
            top: 10,
            left: -7,
            right: -7,
            bottom: -8,
            child: MediaQuery.of(context).size.shortestSide >= 600 // Tablet or iPad check
                ? Image.asset(
              'assets/images/tab_2.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            )
                : Image.asset(
              'assets/images/Tutorial 2.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),

          // Page indicator (3 circles)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                TutorialDot(isActive: false, color: Color(0xFFAAAAAA)), // dot 1
                SizedBox(width: 8),
                TutorialDot(isActive: true, color: Color(0xFF18EFCB)),  // dot 2 ✅
                SizedBox(width: 8),
                TutorialDot(isActive: false, color: Color(0xFFAAAAAA)), // dot 3
              ],

            ),
          ),

          // Next button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).push(_createSwipeRoute(const Tutorial3Page()));
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                label: const Text('Next'),
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
}

class TutorialDot extends StatelessWidget {
  final bool isActive;
  final Color color;

  const TutorialDot({
    super.key,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
Route _createSwipeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
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
