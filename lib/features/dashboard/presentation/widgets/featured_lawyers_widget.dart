import 'package:flutter/material.dart';

class FeaturedLawyersWidget extends StatelessWidget {
  const FeaturedLawyersWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> lawyers = [
      {
        'name': 'Advocate Mr Bean',
        'specialization': 'Criminal Lawyer',
        'rating': 5,
        'imageUrl': null,
      },
      {
        'name': 'Shyam Pathak',
        'specialization': 'Family Law',
        'rating': 4,
        'imageUrl': null,
      },
      {
        'name': 'Anita Rana',
        'specialization': 'Corporate Law',
        'rating': 5,
        'imageUrl': null,
      },
    ];

    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: lawyers.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final lawyer = lawyers[index];
          return Container(
            width: 160,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(0, 2),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.grey,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(height: 12),
                Text(
                  lawyer['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  lawyer['specialization'],
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 8),
                Row(
                  children: List.generate(
                    lawyer['rating'],
                        (i) => const Icon(Icons.star, color: Colors.amber, size: 16),
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {},
                  child: const Text("View Profile"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
