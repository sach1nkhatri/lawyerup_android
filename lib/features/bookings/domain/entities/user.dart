class User {
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

  User({
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
}
