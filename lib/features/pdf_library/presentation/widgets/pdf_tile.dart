import 'package:flutter/material.dart';
import '../../../../core/network/dio_client.dart';

class PdfTile extends StatelessWidget {
  final String title;
  final String url;

  const PdfTile({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final filename = url.split('/').last;
        String? path;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            double progress = 0;
            return StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text("Downloading..."),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 12),
                    Text("${(progress * 100).toStringAsFixed(0)}%"),
                  ],
                ),
              ),
            );
          },
        );

        path = await DioClient().downloadPdfFile(
          filename: filename,
          saveAs: title,
          onProgress: (p) {
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Downloaded to $path")),
              );
            }
          },
        );

        if (path == null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Download failed")),
          );
        }
      },
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFA5F6EF),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
        ),
        child: Row(
          children: [
            Image.asset('assets/images/pdf.png', height: 40),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Image.asset('assets/images/download.png', height: 28),
          ],
        ),
      ),
    );
  }
}
