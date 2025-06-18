import 'package:flutter/material.dart';

class FeaturedNewsWidget extends StatelessWidget {
  const FeaturedNewsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> newsList = [
      {
        'title': 'सर्वोच्च अदालतको आदेश',
        'summary': 'सर्वोच्च अदालतले दिएको एउटा आदेशमा अनलाइन कानुनी परामर्शलाई कानुनी मान्यता दिइएको छ। अदालतले भनेको छ कि...',
        'author': 'सुनिता भण्डारी',
        'date': '2025-06-14',
        'likes': 1,
        'dislikes': 0,
      },
      // Add more static news if needed
    ];

    return SizedBox(
      height:300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: newsList.length,
        separatorBuilder: (_, __) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final news = newsList[index];

          return Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Placeholder image
                Container(
                  height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image, size: 40),
                ),
                const SizedBox(height: 12),
                Text(
                  news['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  news['summary'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  news['author'],
                  style: const TextStyle(fontSize: 11, color: Colors.grey),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(news['date'], style: const TextStyle(fontSize: 10)),
                    Row(
                      children: [
                        const Icon(Icons.thumb_up_alt_outlined, size: 14),
                        Text(" ${news['likes']}  "),
                        const Icon(Icons.thumb_down_alt_outlined, size: 14),
                        Text(" ${news['dislikes']}"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
