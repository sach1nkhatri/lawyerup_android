import '../../../domain/entities/user_entity.dart';

abstract class AuthLocalDatasource {
  Future<UserEntity> login(String email, String password);
  Future<UserEntity> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  });
}
