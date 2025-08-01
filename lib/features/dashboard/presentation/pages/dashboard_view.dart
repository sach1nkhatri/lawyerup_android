import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // 🔁 Needed for SystemUiOverlayStyle
import '../../../../app/shared/services/hive_service.dart';
import '../../../join_as_a_lawyer/presentation/pages/join_as_lawyer_page.dart';
import '../widgets/logo_header.dart';
import '../widgets/quick_links.dart';
import '../widgets/featured_news_widget.dart'; // ✅ use this only!

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  late String role;

  @override
  void initState() {
    super.initState();
    role = HiveService.getRole();
    print('Logged-in role: $role');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark, // ✅ Makes status bar icons dark
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Container(
            padding: const EdgeInsets.only(top: 60, bottom: 10, left: 10),
            color: Colors.white,
            child: const Center(
              child: LogoHeader(),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const QuickLinks(),
              const SizedBox(height: 32),
              if (role == 'admin')
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JoinAsLawyerPage()),
                    );
                  },
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text("Join as a Lawyer"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF18EFCB),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                ),
              const SizedBox(height: 32),
              Text(
                "Featured News",
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontFamily: 'Lora',
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              const FeaturedNewsWidget(),
              const SizedBox(height: 24),
              // Uncomment if needed later
              // Text(
              //   "Featured Lawyers",
              //   style: Theme.of(context).textTheme.titleMedium?.copyWith(
              //     fontWeight: FontWeight.bold,
              //     fontSize: 18,
              //   ),
              // ),
              // const SizedBox(height: 16),
              // const FeaturedLawyersWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
