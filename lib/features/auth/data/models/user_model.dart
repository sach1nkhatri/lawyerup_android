import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required String uid,
    required String email,
    required String token,
  }) : super(
    uid: uid,
    email: email,
    token: token,
  );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['_id'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': uid,
      'email': email,
      'token': token,
    };
  }
}
