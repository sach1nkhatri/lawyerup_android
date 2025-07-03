import 'package:hive_flutter/hive_flutter.dart';
import '../../../../../app/constant/hive_constants.dart';
import '../../../domain/entities/user_entity.dart';
import '../../models/user_hive_model.dart';
import 'auth_local_datasource.dart';

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final box = Hive.box<UserHiveModel>(HiveConstants.userBox);

  @override
  Future<void> cacheUser(UserEntity user) async {
    final userHive = UserHiveModel(
      uid: user.uid,
      fullName: user.fullName,
      email: user.email,
      role: user.role,
      token: user.token,
    );
    await box.put('user', userHive);
  }

  @override
  Future<UserEntity?> getSavedUser() async {
    final userHive = box.get('user');
    return userHive?.toEntity();
  }

  @override
  Future<void> clearUser() async {
    await box.delete('user');
  }
}
