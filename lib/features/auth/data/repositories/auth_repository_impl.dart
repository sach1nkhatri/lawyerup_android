import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local_datasource/auth_local_datasource_impl.dart';
import '../datasources/remote_datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final AuthLocalDatasource localDatasource;

  /// Optional: switch between local and remote manually
  final bool useLocal;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
    this.useLocal = false, // Set true to force Hive usage
  });

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      if (useLocal) {
        final user = await localDatasource.login(email, password);
        return user.toEntity();
      }

      final user = await remoteDatasource.login(email, password);
      return user;
    } catch (e) {
      // Fallback if remote fails
      try {
        final user = await localDatasource.login(email, password);
        return user.toEntity();
      } catch (localError) {
        rethrow;
      }
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
    try {
      if (useLocal) {
        final user = await localDatasource.signup(
          fullName: fullName,
          email: email,
          password: password,
          role: role,
          contactNumber: contactNumber,
        );
        return user.toEntity();
      }

      final user = await remoteDatasource.signup(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
        contactNumber: contactNumber,
      );
      return user;
    } catch (e) {
      // Fallback if remote fails
      try {
        final user = await localDatasource.signup(
          fullName: fullName,
          email: email,
          password: password,
          role: role,
          contactNumber: contactNumber,
        );
        return user.toEntity();
      } catch (localError) {
        rethrow;
      }
    }
  }
}
