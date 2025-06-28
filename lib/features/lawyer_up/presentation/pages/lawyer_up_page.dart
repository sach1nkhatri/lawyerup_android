import 'package:flutter/material.dart';
import '../widgets/lawyer_card.dart';

class LawyerUpPage extends StatelessWidget {
  const LawyerUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "LawyerUP",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.toggle_on, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Search for lawyers",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 20,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              physics: const BouncingScrollPhysics(),
              childAspectRatio: 0.7,
              children: List.generate(4, (index) {
                return LawyerCard(
                  name: "Advocate Mr Bean",
                  specialty: "Criminal Lawyer",
                  rating: 5,
                  imagePath: "assets/images/lawyer.png",
                  onViewProfile: () {
                    // Navigate to profile
                  },
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
