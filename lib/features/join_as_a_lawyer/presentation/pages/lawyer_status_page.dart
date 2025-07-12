import 'package:flutter/material.dart';

class LawyerStatusPage extends StatelessWidget {
  final Map<String, dynamic> lawyer;

  const LawyerStatusPage({super.key, required this.lawyer});

  String getStatusLabel(String status) {
    switch (status) {
      case 'hold':
        return 'Application Sent';
      case 'verified':
        return 'Application Approved';
      case 'listed':
        return 'Listed';
      case 'rejected':
        return 'Rejected';
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = lawyer['status'] ?? 'hold';

    return Scaffold(
      appBar: AppBar(title: const Text('Lawyer Status')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: lawyer['profilePhoto'] != null
                    ? NetworkImage(lawyer['profilePhoto'])
                    : const AssetImage('assets/avatar.png') as ImageProvider,
              ),
            ),
            const SizedBox(height: 16),

            // Personal Details
            _info('Name', lawyer['fullName']),
            _info('Specialization', lawyer['specialization']),
            _info('Qualification', lawyer['qualification']),
            _info('Address', lawyer['address']),
            _info('Phone', lawyer['phone']),
            _info('Status', getStatusLabel(status)),

            const Divider(),

            // Schedule
            if ((lawyer['schedule'] as Map).isNotEmpty) ...[
              const Text('Availability', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              ...((lawyer['schedule'] as Map<String, dynamic>).entries.map((entry) {
                final slots = (entry.value as List).map((s) => '${s['start']} to ${s['end']}').join(', ');
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text('${entry.key}: $slots'),
                );
              }))
            ],

            const Divider(),

            // Optional Sections
            if (lawyer['description'] != null && lawyer['description'].toString().isNotEmpty)
              _section('Description', lawyer['description']),
            if (lawyer['specialCase'] != null && lawyer['specialCase'].toString().isNotEmpty)
              _section('Special Case', lawyer['specialCase']),
            if (lawyer['socialLink'] != null && lawyer['socialLink'].toString().isNotEmpty)
              _section('Social Link', lawyer['socialLink']),

            if (lawyer['education'] != null && lawyer['education'] is List && (lawyer['education'] as List).isNotEmpty)
              _sectionList('Education', lawyer['education'], (e) =>
              '🎓 ${e['degree']} - ${e['institute']}, ${e['year']} (${e['specialization']})'),

            if (lawyer['workExperience'] != null && lawyer['workExperience'] is List && (lawyer['workExperience'] as List).isNotEmpty)
              _sectionList('Work Experience', lawyer['workExperience'], (w) =>
              '📁 ${w['court']} (${w['from']} to ${w['to']})'),

            const Divider(),

            // Status Progress
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _statusStep('Application Sent', status != 'rejected', status != 'hold'),
                _statusStep('Approved', status == 'verified' || status == 'listed', status == 'listed'),
                _statusStep('Listed', status == 'listed', false),
              ],
            ),

            if (status == 'rejected' && lawyer['rejectionReason'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    border: Border.all(color: Colors.red),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("❌ Application Rejected", style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text("Reason: ${lawyer['rejectionReason']}"),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _info(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text('$label: ${value ?? 'N/A'}'),
    );
  }

  Widget _section(String title, dynamic content) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          Text(content),
        ],
      ),
    );
  }

  Widget _sectionList(String title, List list, String Function(dynamic) formatter) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 4),
          ...list.map((item) => Text(formatter(item))).toList(),
        ],
      ),
    );
  }

  Widget _statusStep(String label, bool isActive, bool isFinal) {
    return Column(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: isActive
              ? (isFinal ? Colors.blue : Colors.green)
              : Colors.grey.shade300,
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 12, color: isActive ? Colors.black : Colors.grey)),
      ],
    );
  }
}
