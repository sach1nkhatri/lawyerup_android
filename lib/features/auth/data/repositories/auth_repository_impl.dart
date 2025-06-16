import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;

  AuthRepositoryImpl(this.remoteDatasource);

  @override
  Future<UserEntity> login(String email, String password) {
    return remoteDatasource.login(email, password);
  }

  @override
  Future<UserEntity> signup({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  }) {
    return remoteDatasource.signup(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      contactNumber: contactNumber,
    );
  }
}
