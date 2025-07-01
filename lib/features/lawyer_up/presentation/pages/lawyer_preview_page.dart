import 'package:flutter/material.dart';
import '../../domain/entities/lawyer.dart';
import '../widgets/review_section.dart';

class LawyerUpPreviewPage extends StatelessWidget {
  final Lawyer lawyer;

  const LawyerUpPreviewPage({super.key, required this.lawyer});

  String _stars(double rating) {
    int rounded = rating.round();
    return '⭐' * rounded + '☆' * (5 - rounded);
  }

  @override
  Widget build(BuildContext context) {
    final rating = lawyer.reviews.isNotEmpty
        ? lawyer.reviews.map((r) => r.rating).reduce((a, b) => a + b) / lawyer.reviews.length
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF1C2D3D),
        title: const Text("Lawyer Details", style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 🖼 Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              child: Image.network(
                lawyer.profilePhoto,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 100),
              ),
            ),

            // 🧾 Tabs + Detail Cards
            DefaultTabController(
              length: 3,
              child: Container(
                color: const Color(0xE6D9FFFF),
                child: Column(
                  children: [
                    const TabBar(
                      tabs: [
                        Tab(text: 'Profile'),
                        Tab(text: 'Info'),
                        Tab(text: 'Work'),
                      ],
                      labelColor: Colors.black,
                      labelStyle: TextStyle(fontWeight: FontWeight.bold),
                      indicatorColor: Colors.blue,
                      indicatorWeight: 3,
                    ),
                    Container(
                      height: 300,
                      padding: const EdgeInsets.all(12),
                      child: TabBarView(
                        children: [
                          // 🔹 Profile Tab
                          _tabCard([
                            _infoBox("Description", lawyer.description),
                            _infoBox("Special Case", lawyer.specialCase),
                            _infoBox("Social Link", lawyer.socialLink, link: true),
                          ]),

                          // 🔹 Info Tab
                          _tabCard([
                            _infoRow("Name", lawyer.fullName),
                            _infoRow("Speciality", lawyer.specialization),
                            _infoRow("Bar Reg Number", lawyer.barRegNumber),
                            _infoRow("Address", lawyer.address),
                            _infoRow("Contact", lawyer.phone),
                          ]),

                          // 🔹 Work Tab
                          _tabCard([
                            const Text("Education", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            ...lawyer.education.map((e) => Text("🎓 $e")),
                            const SizedBox(height: 16),
                            const Text("Work Experience", style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            ...lawyer.workExperience.map((w) => Text("📁 $w")),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 📅 Get Appointment
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: ElevatedButton(
                onPressed: () {
                  // TODO: implement appointment logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade100,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                ),
                child: const Text("Get Appointment"),
              ),
            ),

            // ⭐ Review Section
            ReviewSection(rating: rating, reviews: lawyer.reviews),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _tabCard(List<Widget> children) {
    return SingleChildScrollView(
      child: Column(
        children: children.map((child) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: child,
          );
        }).toList(),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return RichText(
      text: TextSpan(
        text: "$title: ",
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: [
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _infoBox(String title, String value, {bool link = false}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: "$title\n",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: 14,
                decoration: link ? TextDecoration.underline : null,
                color: link ? Colors.purple : Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
