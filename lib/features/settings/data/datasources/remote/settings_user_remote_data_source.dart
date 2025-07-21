import '../../models/settings_user_model.dart';

abstract class SettingsUserRemoteDataSource {
  Future<SettingsUserModel> getCurrentUser();

  Future<void> updateUserProfile({
    required String contactNumber,
    required String state,
    required String city,
    required String address,
  });
}
