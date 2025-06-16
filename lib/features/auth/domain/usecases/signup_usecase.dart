import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase(this.repository);

  Future<UserEntity> call({
    required String fullName,
    required String email,
    required String password,
    required String role,
    required String contactNumber,
  }) {
    return repository.signup(
      fullName: fullName,
      email: email,
      password: password,
      role: role,
      contactNumber: contactNumber,
    );
  }
}
