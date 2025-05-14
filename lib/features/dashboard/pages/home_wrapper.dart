import 'package:flutter/material.dart';
import '../../ai_chat/pages/chat_page.dart';
import '../../settings/pages/settings_page.dart';
import '../../../shared/widgets/bottom_nav.dart';



class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int currentIndex = 0;

  final List<Widget> pages = const [
    // ProfilePage(),
    ChatPage(),
    SettingsPage(), // ✅ make sure this is here
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex], // shows correct page
      bottomNavigationBar: BottomNav(
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}

