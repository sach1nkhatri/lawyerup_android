import 'package:flutter/material.dart';

class PlanToggleTabs extends StatelessWidget {
  final String activeTab;
  final void Function(String) onTabChange;

  const PlanToggleTabs({
    super.key,
    required this.activeTab,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['Daily', 'Weekly', 'Monthly'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: tabs.map((tab) {
        final isActive = tab.toLowerCase() == activeTab.toLowerCase();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: GestureDetector(
            onTap: () => onTabChange(tab.toLowerCase()),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: isActive ? Colors.deepPurple : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(30),
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: Colors.deepPurple.withOpacity(0.4),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  )
                ]
                    : [],
              ),
              child: Text(
                tab,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black87,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PlayfairDisplay',
                  fontSize: 14,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
