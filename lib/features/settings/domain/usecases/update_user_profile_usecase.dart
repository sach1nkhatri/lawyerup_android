import '../repositories/settings_user_repository.dart';

class UpdateUserProfileUseCase {
  final SettingsUserRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<void> call({
    required String contactNumber,
    required String state,
    required String city,
    required String address,
  }) async {
    await repository.updateUserProfile(
      contactNumber: contactNumber,
      state: state,
      city: city,
      address: address,
    );
  }
}
