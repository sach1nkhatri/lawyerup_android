import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_datasource/auth_local_datasource.dart';
import '../datasources/remote_datasource/auth_remote_datasource.dart';

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
    final userModel = await remoteDatasource.login(email, password);
    await localDatasource.cacheUser(userModel);
    return userModel;
  }

  @override
  Future<UserEntity> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  }) async {
    final userModel = await remoteDatasource.signup(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      contactNumber: contactNumber,
    );
    await localDatasource.cacheUser(userModel);
    return userModel;
  }

  Future<UserEntity?> getSavedUser() async {
    return await localDatasource.getSavedUser();
  }

  @override
  Future<void> logout() async {
    await localDatasource.clearUser();
  }
}
