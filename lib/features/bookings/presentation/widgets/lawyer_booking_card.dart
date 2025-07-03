import 'package:flutter/material.dart';

class LawyerBookingCard extends StatelessWidget {
  final String name;
  final String email;
  final String contact;
  final String date;
  final String time;
  final String mode;
  final String description;
  final String status;

  const LawyerBookingCard({
    super.key,
    required this.name,
    required this.email,
    required this.contact,
    required this.date,
    required this.time,
    required this.mode,
    required this.description,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text('📧 $email'),
            Text('📞 $contact'),
            const Divider(height: 20, thickness: 1.2),
            Text('🗓 Date: $date'),
            Text('⏰ Time: $time'),
            Text('🧾 Mode: $mode'),
            Text('📄 Description: $description'),
            Text('📌 Status: $status', style: TextStyle(fontWeight: FontWeight.bold, color: _statusColor())),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (status == 'pending')
                  ElevatedButton(onPressed: () {}, child: const Text('Approve')),
                if (status == 'approved')
                  ElevatedButton(onPressed: () {}, child: const Text('Complete')),
                if (status == 'approved')
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Color _statusColor() {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}
