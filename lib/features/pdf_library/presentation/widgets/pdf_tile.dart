import 'package:flutter/material.dart';

class PdfTile extends StatelessWidget {
  final String title;

  const PdfTile({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFA5F6EF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        children: [
          Image.asset('assets/images/pdf.png', height: 40), // 👈 your PDF icon
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          GestureDetector(
            onTap: () {
              // TODO: implement PDF download or open logic
            },
            child: Image.asset('assets/images/download.png', height: 28),
          )
        ],
      ),
    );
  }
}
