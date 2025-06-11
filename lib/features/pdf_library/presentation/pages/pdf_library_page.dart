import 'package:flutter/material.dart';
import '../widgets/pdf_tile.dart';

class PdfLibraryPage extends StatelessWidget {
  const PdfLibraryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pdfList = [
      "Constitution of Nepal 2072",
      "Civil code",
      "Criminal Code",
      "Land & property",
      "Tax",
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "PDF Library",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Icon(Icons.toggle_on, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar under AppBar
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
                      "Search for law article",
                      style: TextStyle(color: Colors.black54, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Expanded list
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: pdfList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return PdfTile(title: pdfList[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
