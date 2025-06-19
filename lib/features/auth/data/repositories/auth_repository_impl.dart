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
    this.useLocal = false,
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    if (useLocal) {
      return await localDatasource.login(email, password); // ✅ Already returns Entity
    }

    try {
      return await remoteDatasource.login(email, password);
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
    if (useLocal) {
      return await localDatasource.signup(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        contactNumber: contactNumber,
      );
    }

    try {
      return await remoteDatasource.signup(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        contactNumber: contactNumber,
      );
    } catch (_) {
      return await localDatasource.signup(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        contactNumber: contactNumber,
      );
    }
  }
}
