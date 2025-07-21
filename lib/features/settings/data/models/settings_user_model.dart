import '../../domain/entities/settings_user_entity.dart';

class SettingsUserModel extends SettingsUserEntity {
  const SettingsUserModel({
    required super.uid,
    required super.fullName,
    required super.email,
    required super.contactNumber,
    required super.state,
    required super.city,
    required super.address,
    required super.plan,
    required super.createdAt,
  });

  factory SettingsUserModel.fromJson(Map<String, dynamic> json) {
    return SettingsUserModel(
      uid: json['_id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'] ?? '',
      state: json['state'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      plan: json['plan'] ?? 'Free Trial',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': uid,
      'fullName': fullName,
      'email': email,
      'contactNumber': contactNumber,
      'state': state,
      'city': city,
      'address': address,
      'plan': plan,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
