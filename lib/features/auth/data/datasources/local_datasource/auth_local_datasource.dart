import 'package:hive/hive.dart';
import '../../models/user_hive_model.dart';
import 'auth_local_datasource_impl.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final Box<UserHiveModel> box = Hive.box<UserHiveModel>('users');

  @override
  Future<UserHiveModel> login(String email, String password) async {
    try {
      final user = box.values.firstWhere(
            (u) => u.email == email && u.token == password, // assuming token as password for local mock
      );
      return user;
    } catch (_) {
      throw Exception("Invalid credentials");
    }
  }

  @override
  Future<UserHiveModel> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  }) async {
    final exists = box.values.any((u) => u.email == email);
    if (exists) throw Exception("User already exists");

    final newUser = UserHiveModel(
      uid: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      token: password,
    );

    await box.add(newUser);
    return newUser;
  }
}
