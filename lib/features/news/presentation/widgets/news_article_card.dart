import 'package:flutter/material.dart';

class NewsArticleCard extends StatelessWidget {
  final String title;
  final String summary;
  final String image;
  final int likes;
  final int dislikes;
  final VoidCallback onTap;

  const NewsArticleCard({
    required this.title,
    required this.summary,
    required this.image,
    required this.likes,
    required this.dislikes,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(summary, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined, size: 16, color: Colors.grey[700]),
                      const SizedBox(width: 4),
                      Text('$likes'),
                      const SizedBox(width: 16),
                      Icon(Icons.thumb_down_alt_outlined, size: 16, color: Colors.grey[700]),
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
}
