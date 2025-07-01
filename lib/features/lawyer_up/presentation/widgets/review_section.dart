import 'package:flutter/material.dart';
import '../../data/models/lawyer_model.dart';

class ReviewSection extends StatelessWidget {
  final double rating;
  final List<ReviewModel> reviews;

  const ReviewSection({
    super.key,
    required this.rating,
    required this.reviews,
  });

  String _stars(double value) {
    final rounded = value.round();
    return '⭐' * rounded + '☆' * (5 - rounded);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Overall Rating
          Row(
            children: [
              const Text(
                "Review",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 8),
              Text(
                _stars(rating),
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 🔹 No Reviews State
          if (reviews.isEmpty)
            const Center(
              child: Text(
                "No reviews available.",
                style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
              ),
            )
          else
          // 🔹 Individual Reviews
            ...reviews.map((review) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.comment,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    review.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  Text(
                    _stars(review.rating),
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            )),
        ],
      ),
    );
  }
}
