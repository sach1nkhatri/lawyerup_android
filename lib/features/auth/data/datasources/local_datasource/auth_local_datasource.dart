import '../../../domain/entities/user_entity.dart';

abstract class AuthLocalDatasource {
  /// Cache a user object to Hive
  Future<void> cacheUser(UserEntity user);

  /// Retrieve the saved user from Hive (if any)
  Future<UserEntity?> getSavedUser();

  /// Clear the cached user from Hive
  Future<void> clearUser();
}
