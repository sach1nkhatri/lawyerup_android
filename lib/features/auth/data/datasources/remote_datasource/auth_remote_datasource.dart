
import '../../models/user_model.dart';

abstract class AuthRemoteDatasource {
  Future<UserModel> login(String email, String password);

  Future<UserModel> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  });
}
