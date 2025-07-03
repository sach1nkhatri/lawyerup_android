import '../../domain/entities/user.dart' as domain;

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? contactNumber;
  final String? phone;
  final String? role;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.contactNumber,
    this.phone,
    this.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'],
      phone: json['phone'],
      role: json['role'],
    );
  }

  domain.User toEntity() {
    return domain.User(
      id: id,
      fullName: fullName,
      email: email,
      contactNumber: contactNumber,
      phone: phone,
      role: role,
    );
  }
}
