import 'package:hive_flutter/adapters.dart';

import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_datasource/auth_local_datasource.dart';
import '../datasources/remote_datasource/auth_remote_datasource.dart';
import '../models/user_hive_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;
  final bool useLocal;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    required this.useLocal,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    if (useLocal) {
      return await localDatasource.login(email, password);
    }

    try {
      final remoteUser = await remoteDatasource.login(email, password);

      final box = Hive.box<UserHiveModel>('users');
      final userHive = UserHiveModel(
        uid: remoteUser.uid,
        email: remoteUser.email,
        token: remoteUser.token, // ✅ Store JWT token
      );
      await box.clear();
      await box.add(userHive);

      return remoteUser;
    } catch (_) {
      return await localDatasource.login(email, password);
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
    return await remoteDatasource.signup(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      contactNumber: contactNumber,
    );
  }

  Future<void> logout() async {
    final box = Hive.box<UserHiveModel>('users');
    await box.clear();
  }
}
