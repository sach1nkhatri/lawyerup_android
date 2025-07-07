import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../../auth/data/models/user_hive_model.dart';
import '../../data/datasources/remote_datasource/booking_remote_data_source.dart';
import '../../domain/entities/booking.dart';
import '../pages/chat_bottom_sheet.dart';

class LawyerBookingCard extends StatefulWidget {
  final Booking booking;

  const LawyerBookingCard({super.key, required this.booking});

  @override
  State<LawyerBookingCard> createState() => _LawyerBookingCardState();
}

class _LawyerBookingCardState extends State<LawyerBookingCard> {
  late String status;
  late String meetingLink;

  final bookingRemote = sl<BookingRemoteDataSource>();

  @override
  void initState() {
    super.initState();
    status = widget.booking.status;
    meetingLink = widget.booking.meetingLink;
  }

  @override
  Widget build(BuildContext context) {
    final client = widget.booking.user;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("👤 Client Info", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _infoText(client.fullName, isBold: true),
            _infoText('📧 ${client.email}'),
            _infoText('📞 ${client.contactNumber ?? client.phone ?? "-"}'),

            const Divider(height: 28, thickness: 1.2),

            _infoText('🗓 Date: ${widget.booking.date}'),
            _infoText('⏰ Time: ${widget.booking.time}'),
            _infoText('🧾 Mode: ${widget.booking.mode}'),
            _infoText('🔗 Meeting Link: ${meetingLink.isNotEmpty ? meetingLink : 'Not set'}'),

            const SizedBox(height: 12),
            Text(
              '📌 Status: ${status.toUpperCase()}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: status == 'completed'
                    ? Colors.green
                    : status == 'approved'
                    ? Colors.orange
                    : Colors.red,
              ),
            ),

            const SizedBox(height: 16),

            Wrap(
              spacing: 12,
              runSpacing: 10,
              children: [
                if (status == 'pending')
                  _actionButton(' Approve', () => _confirmStatusUpdate(context, 'approved'), Colors.orange),

                if (status == 'approved') ...[
                  _actionButton('Complete', () => _confirmStatusUpdate(context, 'completed'), Colors.green),
                  _actionButton('💬 Chat', () => _openChat(context), Colors.blue),
                ],

                _actionButton('🔗 Set Link', () => _promptMeetingLink(context), Colors.indigo),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoText(String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Text(
        text,
        style: TextStyle(fontSize: 15, fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
      ),
    );
  }

  Widget _actionButton(String label, VoidCallback onPressed, Color color) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.arrow_forward_ios, size: 16),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  void _promptMeetingLink(BuildContext context) {
    final controller = TextEditingController(text: meetingLink);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Meeting Link'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Paste Google Meet / Zoom link...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              final newLink = controller.text.trim();
              Navigator.pop(context);
              try {
                await bookingRemote.updateMeetingLink(widget.booking.id, newLink);
                setState(() => meetingLink = newLink);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Meeting link updated')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmStatusUpdate(BuildContext context, String newStatus) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Update Booking Status'),
        content: Text('Mark this booking as "$newStatus"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await bookingRemote.updateBookingStatus(widget.booking.id, newStatus);
                setState(() => status = newStatus);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Marked as $newStatus')));
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  void _openChat(BuildContext context) {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    final user = box.get('user');
    final currentUserId = user?.uid ?? '';

    if (currentUserId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User ID not found")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChatBottomSheet(
        bookingId: widget.booking.id,
        currentUserId: currentUserId,
      ),
    );
  }
}
