import '../../models/user_hive_model.dart';

abstract class AuthLocalDatasource {
  Future<UserHiveModel> login(String email, String password);
  Future<UserHiveModel> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  });
}
