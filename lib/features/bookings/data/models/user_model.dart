import '../../domain/entities/user.dart' as domain;

class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String? contactNumber;
  final String? phone;
  final String? role;
  final String? address;
  final String? city;
  final String? state;
  final String? plan;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    this.contactNumber,
    this.phone,
    this.role,
    this.address,
    this.city,
    this.state,
    this.plan,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      contactNumber: json['contactNumber'],
      phone: json['phone'],
      role: json['role'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      plan: json['plan'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'email': email,
      'contactNumber': contactNumber,
      'phone': phone,
      'role': role,
      'address': address,
      'city': city,
      'state': state,
      'plan': plan,
    };
  }

  domain.User toEntity() {
    return domain.User(
      id: id,
      fullName: fullName,
      email: email,
      contactNumber: contactNumber,
      phone: phone,
      role: role,
      address: address,
      city: city,
      state: state,
      plan: plan,
    );
  }
}
