import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import '../../../../app/constant/api_endpoints.dart';
import '../../../../app/constant/hive_constants.dart';
import '../../../../app/shared/widgets/global_snackbar.dart';
import '../../../../features/auth/data/models/user_hive_model.dart';

class UserReviewModal extends StatefulWidget {
  final String bookingId;
  final VoidCallback onSuccess;

  const UserReviewModal({
    super.key,
    required this.bookingId,
    required this.onSuccess,
  });

  @override
  State<UserReviewModal> createState() => _UserReviewModalState();
}

class _UserReviewModalState extends State<UserReviewModal> {
  int rating = 5;
  String comment = '';
  bool isSubmitting = false;

  Future<void> _submitReview() async {
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

    setState(() => isSubmitting = true);

    try {
      final res = await http.post(
        Uri.parse(ApiEndpoints.submitReview(widget.bookingId)),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${user.token}',
        },
        body: jsonEncode({
          "user": user.fullName,
          "rating": rating,
          "comment": comment,
        }),
      );

      setState(() => isSubmitting = false);

      if (res.statusCode == 200) {
        Navigator.pop(context);
        widget.onSuccess();
        GlobalSnackBar.show(
          context,
          "Review submitted successfully!",
          type: SnackType.success,
        );
      } else {
        GlobalSnackBar.show(
          context,
          "Failed to submit review: ${res.body}",
          type: SnackType.error,
        );
      }
    } catch (e) {
      setState(() => isSubmitting = false);
      GlobalSnackBar.show(
        context,
        "Error submitting review.",
        type: SnackType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Leave a Review",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),

            // Rating Stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final filled = i < rating;
                return IconButton(
                  icon: Icon(
                    filled ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => setState(() => rating = i + 1),
                );
              }),
            ),

            // Comment Input
            TextField(
              decoration: InputDecoration(
                hintText: "Share your experience...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              maxLines: 4,
              onChanged: (val) => comment = val,
            ),

            const SizedBox(height: 20),

            // Submit Button
            ElevatedButton.icon(
              onPressed: isSubmitting ? null : _submitReview,
              icon: isSubmitting
                  ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white),
              )
                  : const Icon(Icons.send),
              label: Text(isSubmitting ? "Submitting..." : "Submit Review"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink.shade400,
                foregroundColor: Colors.white,
                padding:
                const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
