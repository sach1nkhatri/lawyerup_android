import 'package:hive/hive.dart';
import '../../domain/entities/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 0)
class UserHiveModel extends HiveObject {
  @HiveField(0)
  final String uid;

  @HiveField(1)
  final String fullName;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String role;

  @HiveField(4)
  final String token;

  @HiveField(5)
  final String contactNumber;

  UserHiveModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.role,
    required this.token,
    required this.contactNumber,
  });

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      fullName: fullName,
      email: email,
      role: role,
      token: token,
      contactNumber: contactNumber,
    );
  }
}
