import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constant/hive_constants.dart';
import '../../../../app/constant/api_endpoints.dart';
import '../../../auth/data/models/user_hive_model.dart';

class LawyerHelper {
  /// Same as LawyerUserChecker: fetch current user's listing
  static Future<Map<String, dynamic>?> getCurrentUserLawyer() async {
    try {
      final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
      final user = box.get(HiveConstants.userKey);
      final token = user?.token;

      if (token == null) return null;

      final res = await http.get(
        Uri.parse(ApiEndpoints.getLawyerByMe), // ✅ fixed to /me
        headers: { 'Authorization': 'Bearer $token' },
      );

      if (res.statusCode == 200) {
        return jsonDecode(res.body);
      } else {
        print("⚠️ LawyerHelper: ${res.statusCode} - ${res.body}");
      }

      return null;
    } catch (e) {
      print("❌ LawyerHelper.getCurrentUserLawyer Error: $e");
      return null;
    }
  }
}
