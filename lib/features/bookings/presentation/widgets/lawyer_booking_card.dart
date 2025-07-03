import 'package:flutter/material.dart';

import '../../domain/entities/booking.dart';


class LawyerBookingCard extends StatelessWidget {
  final Booking booking;

  const LawyerBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final client = booking.user;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(client.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text('📧 ${client.email}'),
            Text('📞 ${client.contactNumber ?? client.phone ?? "-"}'),
            const Divider(height: 20),
            Text('🗓 Date: ${booking.date}'),
            Text('⏰ Time: ${booking.time}'),
            Text('🧾 Mode: ${booking.mode}'),
            Text('📄 Description: ${booking.description}'),
            Text('📌 Status: ${booking.status}', style: TextStyle(fontWeight: FontWeight.bold, color: _statusColor())),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                if (booking.status == 'pending')
                  ElevatedButton(onPressed: () {}, child: const Text('Approve')),
                if (booking.status == 'approved')
                  ElevatedButton(onPressed: () {}, child: const Text('Mark Complete')),
                if (booking.status == 'approved')
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat),
                    label: const Text('Chat'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor() {
    switch (booking.status.toLowerCase()) {
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
