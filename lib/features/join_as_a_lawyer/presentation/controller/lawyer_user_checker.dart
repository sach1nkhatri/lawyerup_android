import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constant/hive_constants.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../auth/data/models/user_hive_model.dart';

class LawyerUserChecker {
  /// Fetches the current user's lawyer profile via /lawyers/me
  static Future<Map<String, dynamic>?> getLawyerByMe() async {
    try {
      final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
      final user = box.get(HiveConstants.userKey);
      final token = user?.token;

      if (token == null) return null;

      final response = await http.get(
        Uri.parse(ApiEndpoints.getLawyerByMe), // ✅ fixed to /me
        headers: { 'Authorization': 'Bearer $token' },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("⚠️ LawyerUserChecker: ${response.statusCode} - ${response.body}");
      }

      return null;
    } catch (e) {
      print("❌ LawyerUserChecker.getLawyerByMe Error: $e");
      return null;
    }
  }
}
