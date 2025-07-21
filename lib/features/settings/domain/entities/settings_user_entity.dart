class SettingsUserEntity {
  final String uid;
  final String fullName;
  final String email;
  final String contactNumber;
  final String state;
  final String city;
  final String address;
  final String plan;
  final DateTime createdAt;

  const SettingsUserEntity({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.contactNumber,
    required this.state,
    required this.city,
    required this.address,
    required this.plan,
    required this.createdAt,
  });
}
