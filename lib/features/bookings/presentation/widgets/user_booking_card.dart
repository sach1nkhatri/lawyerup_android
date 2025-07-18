import 'package:flutter/material.dart';
import 'package:lawyerup_android/features/bookings/presentation/widgets/user_review_modal.dart';
import '../../domain/entities/booking.dart';
import '../pages/chat_bottom_sheet.dart';

class UserBookingCard extends StatelessWidget {
  final Booking booking;
  final String currentUserId;

  const UserBookingCard({
    super.key,
    required this.booking,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context) {
    final lawyer = booking.lawyer;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Color(0xFFFFFFFF),shadowColor: Colors.tealAccent,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '👨‍⚖️ Lawyer Info',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text(
              lawyer.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 4),
            Text('📧 ${lawyer.email}'),
            Text('📞 ${lawyer.contactNumber ?? lawyer.phone ?? "-"}'),

            const Divider(height: 24),

            const Text(
              '📅 Booking Details',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Text('🗓 Date: ${booking.date}'),
            Text('⏰ Time: ${booking.time}'),
            Text('🧾 Mode: ${booking.mode}'),
            if (booking.description.isNotEmpty) Text('📝 ${booking.description}'),

            const SizedBox(height: 12),
            Text(
              '📌 Status: ${booking.status.toUpperCase()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _statusColor(booking.status),
              ),
            ),
            const SizedBox(height: 16),

            // 👇 Buttons
            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                if (booking.status == 'pending')
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Handle cancel
                    },
                    child: const Text('Cancel'),
                  ),
                if (booking.status == 'completed' && !booking.reviewed)
                  OutlinedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        builder: (_) => UserReviewModal(
                          bookingId: booking.id, // ✅ Replace with actual booking ID
                          onSuccess: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("✅ Review submitted!")),
                            );
                            Navigator.of(context).pop(); // Close modal if needed
                          },
                        ),
                      );
                    },
                    child: const Text('Rate'),
                  ),


                if (booking.status == 'approved')
                  ElevatedButton.icon(
                    icon: const Icon(Icons.chat_bubble_outline),
                    label: const Text('Chat'),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => ChatBottomSheet(
                          bookingId: booking.id,
                          currentUserId: currentUserId,
                        ),
                      );
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _statusColor(String status) {
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

