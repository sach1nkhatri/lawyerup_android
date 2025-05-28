import 'package:flutter/material.dart';
class BottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int)? onTap;

  const BottomNav({
    super.key,
    required this.currentIndex,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Color(0xFF1E2B3A);

    const iconPaths = [
      'assets/icons/chaticon.png',       // Index 0 → AI Chat
      'assets/icons/dashboardicon.png',  // Index 1 → Dashboard
      'assets/icons/settingsicon.png',   // Index 2 → Settings
    ];

    return Container(
      height: 70,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(iconPaths.length, (index) {
          return Expanded(
            child: GestureDetector(
              onTap: () => onTap?.call(index),
              child: Center(
                child: Image.asset(
                  iconPaths[index],
                  width: 28,
                  height: 28,
                  color: currentIndex == index ? Colors.white : Colors.white70,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
