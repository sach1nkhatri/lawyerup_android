import '../../../../app/constant/api_endpoints.dart';

class PdfEntity {
  final String id;
  final String title;
  final String url; // This is the raw path from the DB: /uploads/pdf/xyz.pdf

  const PdfEntity({
    required this.id,
    required this.title,
    required this.url,
  });

  /// Full URL for preview/download
  String get fullUrl => '${ApiEndpoints.baseHost}$url';
}
