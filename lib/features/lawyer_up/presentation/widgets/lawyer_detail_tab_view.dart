import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../domain/entities/lawyer.dart';

class LawyerDetailTabView extends StatefulWidget {
  final Lawyer lawyer;

  const LawyerDetailTabView({super.key, required this.lawyer});

  @override
  State<LawyerDetailTabView> createState() => _LawyerDetailTabViewState();
}

class _LawyerDetailTabViewState extends State<LawyerDetailTabView>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final String imageUrl;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);

    imageUrl = "${ApiEndpoints.baseHost}${widget.lawyer.profilePhoto?.startsWith('/') ?? false
        ? widget.lawyer.profilePhoto
        : '/${widget.lawyer.profilePhoto}'}";
  }

  void _showAppointmentModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text("🗓 Book Appointment", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text("Appointment UI coming soon..."),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lawyer = widget.lawyer;

    return Column(
      children: [
        // 🖼 Profile + Tabs
        Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: double.infinity,
                height: 220,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  'assets/images/avatar_placeholder.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 220,
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.person, size: 100),
              ),
            ),
            Container(
              color: const Color(0xFFE0F7FA),
              child: TabBar(
                controller: _tabController,
                labelColor: Colors.black,
                indicatorColor: Colors.lightBlue,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(text: 'Profile'),
                  Tab(text: 'Info'),
                  Tab(text: 'Work'),
                ],
              ),
            ),
          ],
        ),

        // 📑 Tab Content
        Expanded(
          child: Container(
            color: const Color(0xFFE0F7FA),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProfileTab(lawyer),
                _buildInfoTab(lawyer),
                _buildWorkTab(lawyer),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileTab(Lawyer lawyer) {
    return _detailCard([
      _infoText("Name", lawyer.fullName),
      _infoText("Speciality", lawyer.specialization),
      _infoText("Bar Reg Number", lawyer.barRegNumber),
      _infoText("Address", "${lawyer.address}, ${lawyer.city}, ${lawyer.state}"),
      _infoText("Contact", lawyer.phone),
      const SizedBox(height: 12),
      _appointmentButton(),
    ]);
  }

  Widget _buildInfoTab(Lawyer lawyer) {
    return _detailCard([
      _sectionCard("Description", lawyer.description),
      _sectionCard("Special Case", lawyer.specialCase),
      _sectionCard("Social Link", lawyer.socialLink),
      const SizedBox(height: 12),
      _appointmentButton(),
    ]);
  }

  Widget _buildWorkTab(Lawyer lawyer) {
    return _detailCard([
      const Text("🎓 Education", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 6),
      ...lawyer.education.map((e) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          "🎓 ${e.degree ?? 'N/A'} - ${e.institute ?? 'N/A'}, ${e.year ?? 'N/A'} (${e.specialization ?? 'N/A'})",
          style: const TextStyle(fontSize: 14),
        ),
      )),

      const SizedBox(height: 12),
      const Text("📁 Work Experience", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      const SizedBox(height: 6),
      ...lawyer.workExperience.map((w) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          "📁 ${w.court ?? 'N/A'} (${w.from ?? 'N/A'} to ${w.to ?? 'N/A'})",
          style: const TextStyle(fontSize: 14),
        ),
      )),

      const SizedBox(height: 12),
      _appointmentButton(),
    ]);
  }

  Widget _infoText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  Widget _sectionCard(String title, String? content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 6),
          Text(content ?? 'Not Provided'),
        ],
      ),
    );
  }

  Widget _detailCard(List<Widget> children) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _appointmentButton() {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFAD4D4),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        onPressed: _showAppointmentModal,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Text("Get Appointment"),
        ),
      ),
    );
  }
}
