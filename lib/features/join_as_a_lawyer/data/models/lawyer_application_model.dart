import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../domain/entity/lawyer_application.dart';

class LawyerApplicationModel {
  /// Converts a LawyerApplication into a multipart/form-data HTTP request
  static Future<http.MultipartRequest> toMultipartRequest(
      Uri uri,
      LawyerApplication app,
      String token,
      ) async {
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    // Add regular fields
    request.fields.addAll(toJson(app));

    // Attach files
    if (app.profilePhotoPath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'profilePhoto',
        app.profilePhotoPath!,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    if (app.licenseFilePath != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'licenseFile',
        app.licenseFilePath!,
        contentType: MediaType('application', 'pdf'),
      ));
    }

    return request;
  }

  /// Converts the domain entity into JSON-ready map for form fields
  static Map<String, String> toJson(LawyerApplication app) {
    return {
      'fullName': app.fullName,
      'specialization': app.specialization,
      'email': app.email,
      'phone': app.phone,
      'state': app.state,
      'city': app.city,
      'address': app.address,
      'description': app.description ?? '',
      'specialCase': app.specialCase ?? '',
      'socialLink': app.socialLink ?? '',
      'expectedGraduation': app.expectedGraduation ?? '',
      'role': app.isJunior ? 'junior' : 'senior',

      // Complex fields as JSON strings
      'education': jsonEncode(app.education.map((e) => e.toJson()).toList()),
      'workExperience': jsonEncode(
        app.isJunior ? [] : app.workExperience.map((w) => w.toJson()).toList(),
      ),
      'schedule': jsonEncode(
        app.schedule.map((day, slots) =>
            MapEntry(day, slots.map((s) => s.toJson()).toList())),
      ),
    };
  }
}
