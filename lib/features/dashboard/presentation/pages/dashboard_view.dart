import 'package:flutter/material.dart';

import '../widgets/logo_header.dart';
import '../widgets/quick_links.dart';
import '../widgets/bookings_card.dart';
import '../widgets/featured_lawyers_widget.dart';
import '../widgets/featured_news_widget.dart';

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
        automaticallyImplyLeading: false,
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
          children: [
            const Center(child: LogoHeader()),
            const SizedBox(height: 24),
            const QuickLinks(),
            const SizedBox(height: 32),
            const SizedBox(height: 32),
            const BookingsCard(),
            const SizedBox(height: 32),

            // 🧑‍⚖️ Featured Lawyers Section
            Text(
              "Featured Lawyers",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            const FeaturedLawyersWidget(),
            const SizedBox(height: 24),
            const SizedBox(height: 24),
            Text(
              "Featured News",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            const FeaturedNewsWidget(),
          ],
        ),
      ),
      // bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
