import 'package:flutter/material.dart';
import '../widgets/news_article_card.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> newsData = [
      {
        "date": "Wed, Apr 20, 2025",
        "title": "Cyber Law bill is passes by the executive bodies of the Nepal.",
        "description": "The new bill is passed and will be implemented from today",
      },
      {
        "date": "Wed, Apr 20, 2025",
        "title": "New Property Rights Act Proposed in Parliament",
        "description": "The draft law seeks to streamline property registration and ownership disputes.",
      },
      {
        "date": "Wed, Apr 20, 2025",
        "title": "Amendment to Labor Law Enhances Worker Protection",
        "description": "Key changes include increased minimum wage and stricter safety standards.",
      },
      {
        "date": "Wed, Apr 20, 2025",
        "title": "Amendment to Labor Law Enhances Worker Protection",
        "description": "Key changes include increased minimum wage and stricter safety standards.",
      },
      {
        "date": "Wed, Apr 20, 2025",
        "title": "Amendment to Labor Law Enhances Worker Protection",
        "description": "Key changes include increased minimum wage and stricter safety standards.",
      },
    ];

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
          "News & Article",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...newsData.map((news) => NewsCard(
            date: news['date']!,
            title: news['title']!,
            description: news['description']!,
          )),
          const NewsCard(
            date: "Wed, Apr 20, 2025",
            title: "Justice in Action",
            description: "Symbolic representation of the legal system in modern times.",
            imagePath: 'assets/images/judiciary.png',
          ),
        ],
      ),
    );
  }
}
