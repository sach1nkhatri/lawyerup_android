import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../app/constant/api_endpoints.dart';
import '../../app/shared/widgets/global_snackbar.dart';

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

  Future<String?> downloadPdfFile({
    required String filename,
    required String saveAs,
    required BuildContext context,
    Function(double progress)? onProgress,
  }) async {
    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        GlobalSnackBar.show(context, "Storage permission denied", type: SnackType.error);
        return null;
      }

      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        GlobalSnackBar.show(context, "Unable to access storage", type: SnackType.error);
        return null;
      }

      final savePath = '${directory.path}/$saveAs.pdf';
      final fullUrl = '${ApiEndpoints.staticHost}/uploads/pdf/$filename';

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
      print('PDF download error: $e');
      GlobalSnackBar.show(context, "Download failed: ${_friendlyError(e)}", type: SnackType.error);
      return null;
    }
  }

  String _friendlyError(dynamic e) {
    if (e is DioException) {
      if (e.type == DioExceptionType.connectionTimeout) return "Connection timeout";
      if (e.type == DioExceptionType.receiveTimeout) return "Server response timed out";
      if (e.type == DioExceptionType.badResponse) return "Invalid server response";
      if (e.message?.contains("404") ?? false) return "File not found";
    }
    return "Unexpected error";
  }
}
