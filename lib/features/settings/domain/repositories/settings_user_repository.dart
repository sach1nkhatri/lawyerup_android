import '../entities/settings_user_entity.dart';

abstract class SettingsUserRepository {
  Future<SettingsUserEntity> getCurrentUser();

  Future<void> updateUserProfile({
    required String contactNumber,
    required String state,
    required String city,
    required String address,
  });
}
