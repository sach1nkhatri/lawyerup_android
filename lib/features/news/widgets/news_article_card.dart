import 'package:flutter/material.dart';

class NewsCard extends StatelessWidget {
  final String date;
  final String title;
  final String description;
  final String? imagePath;

  const NewsCard({
    super.key,
    required this.date,
    required this.title,
    required this.description,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        const Text("By Post Report", style: TextStyle(fontSize: 12)),
        const SizedBox(height: 4),
        Text(description, style: const TextStyle(fontSize: 13)),
        if (imagePath != null) ...[
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset(
              imagePath!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: 180,
            ),
          ),
        ],
        const SizedBox(height: 12),
        const Divider(thickness: 1),
      ],
    );
  }
}
