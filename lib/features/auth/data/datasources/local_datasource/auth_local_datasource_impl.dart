import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../app/constant/hive_constants.dart';
import '../../../domain/entities/user_entity.dart';
import '../../models/user_hive_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final Box<UserHiveModel> box = Hive.box<UserHiveModel>(HiveConstants.userBox);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final user = box.values.firstWhere(
            (u) => u.email == email && u.token == password,
      );
      return user.toEntity(); // ✅ FIXED: Convert HiveModel → Entity
    } catch (_) {
      throw Exception("Invalid credentials");
    }
  }

  @override
  Future<UserEntity> signup({
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
    return newUser.toEntity(); // ✅ FIXED
  }
}
