import 'package:flutter/material.dart';
import '../../../routes/app_router.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 10,
            left:-7,
            right: -7,
            bottom: -8,
            child: Image.asset(
              'assets/images/welcomescreendesign.png',
              fit: BoxFit.fill, // Forces image to fill entire screen (including 1–2px edges)
              filterQuality: FilterQuality.high, // optional: anti-aliases scaling
            ),
          ),

          const Positioned(
            top: 530,
            left: 20,
            right: 20,
            child: Text(
              'Get started with'
                  ' LawyerUp Ai',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    blurRadius: 8,
                    color: Colors.black45,
                    offset: Offset(1, 2),
                  )
                ],
              ),
            ),
          ),

          // EXISTING BUTTON
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.tutorial1);
                },
                icon: const Icon(Icons.arrow_forward_ios, size: 18),
                label: const Text('Get Started'),
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
