import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../app/routes/app_router.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../widgets/settings_section.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Profile Header
          Row(
            children: [
              CircleAvatar(
                radius: 44,
                backgroundColor: Colors.redAccent,
                child: CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sachin Khatri", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("Tokha"),
                  Text("Since 2022"),
                  Text("Standard Plan"),
                ],
              )
            ],
          ),
          const SizedBox(height: 32),

          const SettingsSection(
            title: "Account",
            items: ["Edit Profile", "Change Password", "Privacy"],
          ),
          const SizedBox(height: 24),
          const SettingsSection(
            title: "Notification",
            items: ["Notification", "Updates"],
            switches: [true, false],
          ),
          const SizedBox(height: 24),
          const SettingsSection(
            title: "Other",
            items: ["Dark Mode", "Language", "Premium"],
            switches: [false],
            buttons: ["English", "GetPlus+"],
          ),
          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  // ✅ Call proper repository logout
                  await sl<AuthRepository>().logout();

                  // ✅ Optional: also clear any extra local boxes
                  final settingsBox = await Hive.openBox('settingsBox');
                  await settingsBox.clear();

                  // ✅ Navigate to login
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    AppRouter.login,
                        (route) => false,
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
