import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../../features/auth/data/models/user_hive_model.dart';
import '../../domain/entities/lawyer.dart';
import '../widgets/review_section.dart';
import 'appointment_modal.dart';

class LawyerDetailTabView extends StatelessWidget {
  final Lawyer lawyer;

  const LawyerDetailTabView({super.key, required this.lawyer});

  String _stars(double rating) {
    int rounded = rating.round();
    return '⭐' * rounded + '☆' * (5 - rounded);
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

  @override
  Widget build(BuildContext context) {
    final rating = lawyer.reviews.isNotEmpty
        ? lawyer.reviews.map((r) => r.rating).reduce((a, b) => a + b) / lawyer.reviews.length
        : 0.0;

    final imageUrl = "${ApiEndpoints.baseHost}${lawyer.profilePhoto}";

    // ✅ Fetch current user from Hive
    final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final currentUser = userBox.get(HiveConstants.userKey);

    // ✅ Logic to prevent lawyers from booking other lawyers or themselves
    final isLawyer = currentUser?.role == 'lawyer';
    final currentUserId = currentUser?.uid;
    final viewedLawyerCreatorId = lawyer.id;

    final isSelf = currentUserId == viewedLawyerCreatorId;
    final disableBooking = isLawyer || isSelf;

    return SingleChildScrollView(
      child: Column(
        children: [
          // 🖼 Image
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[200],
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
                    height: 350,
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
                          ...lawyer.education.map((e) => Text("🎓 ${e.degree}, ${e.institute} (${e.year}) - ${e.specialization}")),
                          const SizedBox(height: 16),
                          const Text("Work Experience", style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          ...lawyer.workExperience.map((w) => Text("📁 ${w.court} (${w.from} to ${w.to})")),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 📅 Appointment Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ElevatedButton(
              onPressed: disableBooking
                  ? null
                  : () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  builder: (ctx) => AppointmentModal(
                    lawyerId: lawyer.id,
                    onClose: () => print("Closed"),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                disableBooking ? Colors.grey.shade300 : Colors.pink.shade100,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: Text(
                disableBooking
                    ? "Not Available for Lawyers"
                    : "Get Appointment",
              ),
            ),
          ),

          // ⭐ Review Section
          ReviewSection(rating: rating, reviews: lawyer.reviews),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
