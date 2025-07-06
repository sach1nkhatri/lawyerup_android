import 'package:flutter/material.dart';
import '../../../../app/constant/api_endpoints.dart';

class NewsArticleCard extends StatelessWidget {
  final String title;
  final String summary;
  final String image;
  final int likes;
  final int dislikes;
  final String author;
  final DateTime date;
  final VoidCallback onTap;

  const NewsArticleCard({
    required this.title,
    required this.summary,
    required this.image,
    required this.likes,
    required this.dislikes,
    required this.author,
    required this.date,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final fullImageUrl = "${ApiEndpoints.baseHost}$image";

    return GestureDetector(
      onTap: onTap,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4, color: Colors.white,
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Image.network(
                fullImageUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
              child: Text(
                'by $author • ${_formatDate(date)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Playfair',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'Lora',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontFamily: 'Playfair'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined,
                          size: 16, color: Colors.green[700]),
                      const SizedBox(width: 4),
                      Text('$likes'),
                      const SizedBox(width: 16),
                      Icon(Icons.thumb_down_alt_outlined,
                          size: 16, color: Colors.red[700]),
                      const SizedBox(width: 4),
                      Text('$dislikes'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
