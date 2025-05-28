import 'package:flutter/material.dart';
import 'package:lawyerup_android/features/ai_chat/pages/chat_page.dart';
import 'package:lawyerup_android/features/dashboard/pages/dashboard_view.dart';
import 'package:lawyerup_android/features/settings/pages/settings_page.dart';
import 'package:lawyerup_android/shared/widgets/bottom_nav.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    ChatPage(),        // Index 0
    DashboardView(),   //index 1
    SettingsPage(),    // Index 2
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped, // ✅ Properly passed callback
      ),
    );
  }
}
