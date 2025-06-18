import 'package:flutter/material.dart';



import '../widgets/bottom_nav.dart';
import '../../../ai_chat/presentation/pages/chat_page.dart';
import '../../../settings/presentation/pages/settings_page.dart';
import 'dashboard_view.dart';

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
