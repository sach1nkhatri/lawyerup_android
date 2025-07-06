import 'package:hive/hive.dart';
import '../../../features/auth/data/models/user_hive_model.dart';
import '../../constant/hive_constants.dart';

class HiveService {
  /// Get the full user object (UserHiveModel)
  static UserHiveModel? getUser() {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    return box.get(HiveConstants.userKey);
  }

  /// Get the user's role as a string (e.g., 'user', 'lawyer', 'admin')
  static String getRole() {
    final user = getUser();
    return user?.role ?? '';
  }

  /// Check if the user is a lawyer
  static bool isLawyer() => getRole() == 'lawyer';

  /// Check if the user is an admin
  static bool isAdmin() => getRole() == 'admin';

  /// Save user (optional helper)
  static Future<void> saveUser(UserHiveModel user) async {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    await box.put(HiveConstants.userKey, user);
  }

  /// Clear user (e.g., on logout)
  static Future<void> clearUser() async {
    final box = Hive.box<UserHiveModel>(HiveConstants.userBox);
    await box.delete(HiveConstants.userKey);
  }
}
