import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../domain/entities/lawyer.dart';

class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;

  const LawyerCard({Key? key, required this.lawyer}) : super(key: key);

  String _generateStars(double rating) {
    int rounded = rating.round();
    return '⭐' * rounded + '☆' * (5 - rounded);
  }

  @override
  Widget build(BuildContext context) {
    final rating = lawyer.reviews.isNotEmpty
        ? lawyer.reviews.map((r) => r.rating).reduce((a, b) => a + b) / lawyer.reviews.length
        : 0.0;

    final stars = _generateStars(rating);
    final imageUrl = "${ApiEndpoints.baseHost}${lawyer.profilePhoto ?? ''}";

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      elevation: 4,
      color: Colors.cyan[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // 🖼 Profile Photo
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 130,
                height: 130,
                fit: BoxFit.cover,
                fadeInDuration: Duration.zero,
                fadeOutDuration: Duration.zero,
                placeholderFadeInDuration: Duration.zero,
                placeholder: (context, url) => Image.asset(
                  'assets/images/avatar_placeholder.png',
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) =>
                const Icon(Icons.person, size: 70),
              ),
            ),
            const SizedBox(width: 12),

            // 🧑 Lawyer Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lawyer.fullName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    lawyer.specialization,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(stars, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 24)
          ],
        ),
      ),
    );
  }
}
