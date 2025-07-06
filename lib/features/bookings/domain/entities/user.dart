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

  const User({
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

  static const fallback = User(
    id: '',
    fullName: 'Unknown User',
    email: '',
    contactNumber: '',
    phone: '',
    role: 'user',
    address: '',
    city: '',
    state: '',
    plan: '',
  );
}
