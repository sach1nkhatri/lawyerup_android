import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/constant/api_endpoints.dart';

class DioClient {
  final Dio dio;

  DioClient()
      : dio = Dio(BaseOptions(
    baseUrl: ApiEndpoints.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {'Content-Type': 'application/json'},
  )) {
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  //  Download PDF with optional progress callback
  Future<String?> downloadPdfFile({
    required String filename,
    required String saveAs,
    Function(double progress)? onProgress,
  }) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) return null;

      final directory = await getExternalStorageDirectory();
      if (directory == null) return null;

      final savePath = '${directory.path}/$saveAs.pdf';
      final fullUrl = '${ApiEndpoints.baseHost}/uploads/pdf/$filename';

      await dio.download(
        fullUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );

      return savePath;
    } catch (e) {
      print(' PDF download error: $e');
      return null;
    }
  }
}
