import 'package:flutter/material.dart';
import '../../../shared/widgets/logo_header.dart';
import '../widgets/quick_links.dart';
import '../widgets/news_card.dart';
import '../widgets/bookings_card.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: false, //for removing return button
        title: const Text(
          "Home",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Center(child: LogoHeader()),
            SizedBox(height: 24),
            QuickLinks(),
            SizedBox(height: 32),
            NewsCard(),
            SizedBox(height: 32),
            BookingsCard(),
            SizedBox(height: 20),
          ],
        ),
      ),
      // bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
