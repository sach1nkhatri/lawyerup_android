import 'package:flutter/material.dart';

import '../../../../routes/app_router.dart';


class Tutorial3Page extends StatelessWidget {
  const Tutorial3Page({Key? key}) : super(key: key);

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
              'assets/images/tab_3.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            )
                : Image.asset(
              'assets/images/Tutorial 3.png',
              fit: BoxFit.fill,
              filterQuality: FilterQuality.high,
            ),
          ),

          // Page indicator (dot 3 active)
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                TutorialDot(isActive: false, color: Color(0xFFAAAAAA)), // dot 1
                SizedBox(width: 8),
                TutorialDot(isActive: false, color: Color(0xFFAAAAAA)), // dot 2
                SizedBox(width: 8),
                TutorialDot(isActive: true, color: Color(0xFF18EFCB)),  // dot 3
              ],
            ),
          ),

          // Finish button
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to next page: change to your actual next screen
                  Navigator.pushNamed(context, AppRouter.login);
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                label: const Text('Finish'),
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
