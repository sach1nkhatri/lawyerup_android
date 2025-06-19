import 'package:hive/hive.dart';

import '../../domain/entities/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String token;

  UserHiveModel({
    required this.uid,
    required this.email,
    required this.token,
  });

  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      uid: entity.uid,
      email: entity.email,
      token: entity.token,
    );
  }

  UserEntity toEntity() {
    return UserEntity(uid: uid, email: email, token: token);
  }
}
