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

    const icons = [
      Icons.person_outline,
      Icons.chat_bubble_outline,
      Icons.settings_outlined,
    ];

    return Container(
      height: 70,
      color: backgroundColor,
      child: Row(
        children: [
          // Profile - center left
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => onTap?.call(0),
                child: Icon(
                  icons[0],
                  size: 28,
                  color: currentIndex == 0 ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ),

          // Chat - center middle
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => onTap?.call(1),
                child: Icon(
                  icons[1],
                  size: 28,
                  color: currentIndex == 1 ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ),

          // Settings - center right
          Expanded(
            child: Center(
              child: GestureDetector(
                onTap: () => onTap?.call(2),
                child: Icon(
                  icons[2],
                  size: 28,
                  color: currentIndex == 2 ? Colors.white : Colors.white70,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
