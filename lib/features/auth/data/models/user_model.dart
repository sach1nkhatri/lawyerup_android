import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.role,
    required super.token,
    required super.contactNumber,
  });


  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      fullName: entity.fullName,
      email: entity.email,
      role: entity.role,
      token: entity.token,
      contactNumber: entity.contactNumber,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json, String token) {
    return UserModel(
      uid: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
      token: token,
      contactNumber: json['contactNumber']??'',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': uid,
      'fullName': fullName,
      'email': email,
      'role': role,
      'token': token,
    };
  }
}
