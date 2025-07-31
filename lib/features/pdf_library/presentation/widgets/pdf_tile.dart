import 'package:flutter/material.dart';
import '../../../../core/network/dio_client.dart';
import '../pages/pdf_viewer_page.dart';

class PdfTile extends StatelessWidget {
  final String title;
  final String fullUrl; // full absolute URL
  final String rawUrl;  // only needed to extract filename

  const PdfTile({
    super.key,
    required this.title,
    required this.fullUrl,
    required this.rawUrl,
  });

  @override
  Widget build(BuildContext context) {
    final filename = rawUrl.split('/').last;

    return GestureDetector(
      onTap: () async {
        final action = await showDialog<String>(
          context: context,
          barrierDismissible: true,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.picture_as_pdf, size: 48, color: Colors.redAccent),
                    const SizedBox(height: 16),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "What would you like to do with this file?",
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context, 'preview'),
                            icon: const Icon(Icons.visibility, color: Colors.white),
                            label: const Text("Preview", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context, 'download'),
                            icon: const Icon(Icons.download),
                            label: const Text("Download", style: TextStyle(color: Colors.white)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              ),
            );
          },
        );

        if (action == 'preview') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => PdfViewerPage(url: fullUrl)),
          );
        }

        if (action == 'download') {
          double progress = 0;

          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                titlePadding: const EdgeInsets.only(top: 16, left: 20, right: 8),
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Downloading...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Icon(Icons.close, color: Colors.grey),
                    ),
                  ],
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 12),
                    Text("${(progress * 100).toStringAsFixed(0)}%"),
                  ],
                ),
              ),
            ),
          );

          final path = await DioClient().downloadPdfFile(
            filename: filename,
            saveAs: title,
            onProgress: (p) {
              progress = p;
              (context as Element).markNeedsBuild(); // force dialog to refresh
            },
          );

          Navigator.of(context, rootNavigator: true).pop(); // close progress dialog

          if (path != null && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Downloaded to $path")),
            );
          } else if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Download failed")),
            );
          }
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
              child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            ),
            Image.asset('assets/images/download.png', height: 28),
          ],
        ),
      ),
    );
  }
}
