class User {
  final String id;
  final String fullName;
  final String email;
  final String? contactNumber;
  final String? phone;
  final String? role;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.contactNumber,
    this.phone,
    this.role,
  });
}
