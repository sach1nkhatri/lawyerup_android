import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required String uid,
    required String fullName,
    required String email,
    required String role,
    required String contactNumber,
  }) : super(
    uid: uid,
    fullName: fullName,
    email: email,
    role: role,
    contactNumber: contactNumber,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
    );
  }
}
