import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:http/http.dart' as http;
import 'package:lawyerup_android/features/bookings/presentation/widgets/user_review_modal.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../../app/shared/widgets/global_snackbar.dart';
import '../../../auth/data/models/user_hive_model.dart';
import '../../domain/entities/booking.dart';
import '../pages/chat_bottom_sheet.dart';

class UserBookingCard extends StatelessWidget {
  final Booking booking;
  final String currentUserId;
  final VoidCallback onCancelSuccess;

  const UserBookingCard({
    super.key,
    required this.booking,
    required this.currentUserId,
    required this.onCancelSuccess,
  });

  @override
  Widget build(BuildContext context) {
    final lawyer = booking.lawyer;

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFFFFFFFF),
      shadowColor: Colors.tealAccent,
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
            if (booking.description.isNotEmpty)
              Text('📝 ${booking.description}'),

            const SizedBox(height: 12),
            Text(
              '📌 Status: ${booking.status.toUpperCase()}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _statusColor(booking.status),
              ),
            ),
            const SizedBox(height: 16),

            Wrap(
              spacing: 10,
              runSpacing: 8,
              children: [
                if (booking.status == 'pending')
                  ElevatedButton(
                    onPressed: () async {
                      final userBox = Hive.box<UserHiveModel>(HiveConstants.userBox);
                      final user = userBox.get(HiveConstants.userKey);

                      if (user == null) {
                        GlobalSnackBar.show(
                          context,
                          "⚠️ Login required.",
                          type: SnackType.warning,
                        );
                        return;
                      }

                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          backgroundColor: Colors.white,
                          title: Row(
                            children: const [
                              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
                              SizedBox(width: 10),
                              Text(
                                "Cancel Booking",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          content: const Text(
                            "Are you sure you want to cancel this booking?\nThis action cannot be undone.",
                            style: TextStyle(fontSize: 15, height: 1.4),
                          ),
                          actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          actionsAlignment: MainAxisAlignment.spaceBetween,
                          actions: [
                            TextButton.icon(
                              onPressed: () => Navigator.pop(ctx, false),
                              icon: const Icon(Icons.close, color: Colors.grey),
                              label: const Text("No", style: TextStyle(color: Colors.grey)),
                            ),
                            ElevatedButton.icon(
                              onPressed: () => Navigator.pop(ctx, true),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text("Yes, Cancel"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm != true) return;

                      try {
                        final res = await http.delete(
                          Uri.parse(ApiEndpoints.deleteBooking(booking.id)),
                          headers: {
                            'Authorization': 'Bearer ${user.token}',
                          },
                        );

                        if (res.statusCode == 200) {
                          GlobalSnackBar.show(context, "Booking cancelled.", type: SnackType.success);
                          onCancelSuccess(); // Refresh booking list
                        } else {
                          GlobalSnackBar.show(context, "Failed to cancel: ${res.body}", type: SnackType.error);
                        }
                      } catch (e) {
                        GlobalSnackBar.show(context, "Error cancelling booking.", type: SnackType.error);
                      }
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
                          bookingId: booking.id,
                          onSuccess: () {
                            GlobalSnackBar.show(
                              context,
                              "✅ Review submitted!",
                              type: SnackType.success,
                            );
                            Navigator.of(context).pop(); // Close the modal
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
