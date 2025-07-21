import '../../domain/entities/settings_user_entity.dart';
import '../../domain/repositories/settings_user_repository.dart';
import '../datasources/remote/settings_user_remote_data_source.dart';

class SettingsUserRepositoryImpl implements SettingsUserRepository {
  final SettingsUserRemoteDataSource remote;

  SettingsUserRepositoryImpl(this.remote);

  @override
  Future<SettingsUserEntity> getCurrentUser() async {
    final model = await remote.getCurrentUser();
    return SettingsUserEntity(
      uid: model.uid,
      fullName: model.fullName,
      email: model.email,
      contactNumber: model.contactNumber,
      state: model.state,
      city: model.city,
      address: model.address,
      plan: model.plan,
      createdAt: model.createdAt,
    );
  }

  @override
  Future<void> updateUserProfile({
    required String contactNumber,
    required String state,
    required String city,
    required String address,
  }) {
    return remote.updateUserProfile(
      contactNumber: contactNumber,
      state: state,
      city: city,
      address: address,
    );
  }
}
