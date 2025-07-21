import '../entities/settings_user_entity.dart';
import '../repositories/settings_user_repository.dart';

class GetCurrentUserUseCase {
  final SettingsUserRepository repository;
  GetCurrentUserUseCase(this.repository);

  Future<SettingsUserEntity> call() async {
    return await repository.getCurrentUser();
  }
}