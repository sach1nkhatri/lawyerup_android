import 'package:flutter/material.dart';

class QuickLinks extends StatelessWidget {
  const QuickLinks({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive tile width
        double maxWidth = constraints.maxWidth;
        double tileWidth = (maxWidth - 48) / 2; // 2 per row with 16 spacing

        return Center(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: [
              _tile(
                  context, "LawyerUP", "assets/images/qwhammer.png", tileWidth),

              _tile(context, "News & Articles", "assets/images/newspaper.png",
                  tileWidth),

              _tile(context, "Law Pdf", "assets/images/law.png", tileWidth),

              _tile(context, "Bookings", "assets/images/bookings.png", tileWidth),
            ],
          ),
        );
      },
    );
  }

  Widget _tile(BuildContext context, String title, String assetPath,
      double width) {
    return Container(
      width: width,
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: InkWell(
        onTap: () {
          if (title == "Bookings") {
            Navigator.pushNamed(context, '/bookings'); // or 'lawyer'

          } else if (title == "News & Articles") {
            Navigator.pushNamed(context, '/news');
          } else if (title == "Law Pdf") {
            Navigator.pushNamed(context, '/pdfpage'); // Assuming route exists
          } else if (title == "LawyerUP") {
            Navigator.pushNamed(context, '/lawyerup'); // Assuming route exists
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(assetPath, height: 48),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}