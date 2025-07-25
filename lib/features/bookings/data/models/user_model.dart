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

  const UserModel({
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

  /// ✅ Fallback user for cases like missing sender info
  static const fallback = UserModel(
    id: '',
    fullName: 'Unknown',
    email: '',
    contactNumber: '',
    phone: '',
    role: 'user',
    address: '',
    city: '',
    state: '',
    plan: '',
  );

  /// ✅ From backend JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'] ?? '',
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

  /// ✅ To backend JSON
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

  /// ✅ Convert to domain entity
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

  /// ✅ Create from domain entity
  factory UserModel.fromEntity(domain.User user) {
    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      contactNumber: user.contactNumber,
      phone: user.phone,
      role: user.role,
      address: user.address,
      city: user.city,
      state: user.state,
      plan: user.plan,
    );
  }

  /// ✅ (Optional) Create from ID-only map
  factory UserModel.fromIdOnly(Map<String, dynamic> json) {
    return UserModel(
      id: json[r'$oid'] ?? '',
      fullName: 'Unknown',
      email: '',
    );
  }
}
