import 'package:flutter/material.dart';

import '../../domain/entities/booking.dart';


class UserBookingCard extends StatelessWidget {
  final Booking booking;

  const UserBookingCard({super.key, required this.booking});

  @override
  Widget build(BuildContext context) {
    final lawyer = booking.lawyer;
    final profile = booking.lawyerList;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(lawyer.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text('📧 ${lawyer.email}'),
            Text('📞 ${lawyer.contactNumber ?? lawyer.phone ?? "-"}'),
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
                  ElevatedButton(onPressed: () {}, child: const Text('Cancel')),
                if (booking.status == 'completed' && !booking.reviewed)
                  OutlinedButton(onPressed: () {}, child: const Text('Rate')),
                if (booking.status == 'approved')
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.chat_bubble_outline),
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
