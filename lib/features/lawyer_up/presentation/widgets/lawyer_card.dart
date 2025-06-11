import 'package:flutter/material.dart';

class LawyerCard extends StatelessWidget {
  const LawyerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFA5F6EF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // ✅ center the children vertically
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              'assets/images/photopro.png',
              height: 80,
              width: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // optional
              children: const [
                Text("Name", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text("Specializations"),
                Text("Contact"),
                Text("Education"),
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star, size: 18, color: Colors.amber),
                    Icon(Icons.star_border, size: 18, color: Colors.black87),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
