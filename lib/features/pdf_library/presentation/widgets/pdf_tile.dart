import 'package:flutter/material.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../app/constant/api_endpoints.dart'; // for baseHost/uploads
import '../pages/pdf_viewer_page.dart';

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
    final fullUrl = '${ApiEndpoints.uploads}$url';

    return GestureDetector(
      onTap: () async {
        final filename = url.split('/').last;

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
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
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
                            icon: const Icon(Icons.visibility, color: Colors.white), // Optional: white icon
                            label: const Text(
                              "Preview",
                              style: TextStyle(color: Colors.white), // 👈 custom text color here
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child:ElevatedButton.icon(
                              onPressed: () => Navigator.pop(context, 'download'),
                              icon: const Icon(Icons.download),
                              label: const Text(
                                "Download",
                                style: TextStyle(color: Colors.white), // 🔥 Set your desired color here
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
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
            MaterialPageRoute(
              builder: (_) => PdfViewerPage(url: fullUrl),
            ),
          );
        }

        if (action == 'download') {
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

          final path = await DioClient().downloadPdfFile(
            filename: filename,
            saveAs: title,
            onProgress: (p) {
              Navigator.of(context, rootNavigator: true).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Downloaded to $p")),
              );
            },
          );

          if (path == null && context.mounted) {
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
