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
    const backgroundColor = Color(0xFFFFFFFF);

    const iconPaths = [
      'assets/icons/chaticon.png',       // Index 0 → AI Chat
      'assets/icons/dashboardicon.png',  // Index 1 → Dashboard
      'assets/icons/settingsicon.png',   // Index 2 → Settings
    ];

    return Padding(
      padding: const EdgeInsets.only(bottom: 8), // for floating effect
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 70,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(iconPaths.length, (index) {
            final isSelected = currentIndex == index;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTap?.call(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.black.withOpacity(0.15) : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Image.asset(
                      iconPaths[index],
                      width: isSelected ? 30 : 26,
                      height: isSelected ? 30 : 26,
                      // Removed color tint to show icons as-is (black)
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
