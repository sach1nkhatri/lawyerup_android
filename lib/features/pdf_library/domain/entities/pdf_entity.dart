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

  /// Safely returns full URL for preview/download
  String get fullUrl {
    final base = ApiEndpoints.staticHost.endsWith('/')
        ? ApiEndpoints.staticHost.substring(0, ApiEndpoints.staticHost.length - 1)
        : ApiEndpoints.staticHost;

    final path = url.startsWith('/') ? url : '/$url';
    return '$base$path';
  }
}
