import 'package:flutter/material.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../data/datasources/remote_datasource/booking_remote_data_source.dart';
import '../../domain/entities/booking.dart';

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
            Text('🗓 Date: ${widget.booking.date}'),
            Text('⏰ Time: ${widget.booking.time}'),
            Text('🧾 Mode: ${widget.booking.mode}'),
            const SizedBox(height: 8),
            Text('🔗 Meeting Link: ${meetingLink.isNotEmpty ? meetingLink : 'Not set'}'),
            const SizedBox(height: 12),
            Text(
              '📌 Status: ${status.toUpperCase()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: status == 'completed'
                    ? Colors.green
                    : status == 'approved'
                    ? Colors.orange
                    : Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            if (status != 'completed') ...[
              if (status == 'pending')
                ElevatedButton(
                  onPressed: () => _confirmStatusUpdate(context, 'approved'),
                  child: const Text('Approve Booking'),
                ),
              if (status == 'approved')
                ElevatedButton(
                  onPressed: () => _confirmStatusUpdate(context, 'completed'),
                  child: const Text('Mark as Completed'),
                ),
              ElevatedButton(
                onPressed: () => _promptMeetingLink(context),
                child: const Text('Set Meeting Link'),
              ),
            ]
          ],
        ),
      ),
    );
  }

  void _promptMeetingLink(BuildContext context) {
    final controller = TextEditingController(text: meetingLink);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Meeting Link'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'Enter meeting link'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newLink = controller.text.trim();
              Navigator.pop(context);

              try {
                await bookingRemote.updateMeetingLink(widget.booking.id, newLink);
                setState(() {
                  meetingLink = newLink;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Meeting link updated')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update meeting link: $e')),
                );
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
        title: const Text('Confirm Status Update'),
        content: Text('Do you want to mark this booking as "$newStatus"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await bookingRemote.updateBookingStatus(widget.booking.id, newStatus);
                setState(() {
                  status = newStatus;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Booking marked as $newStatus')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to update status: $e')),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
