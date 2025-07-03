class LawyerProfile {
  final String id;
  final String specialization;
  final String qualification;
  final String? profilePhoto;
  final String? contact;
  final String? phone;
  final dynamic schedule;

  LawyerProfile({
    required this.id,
    required this.specialization,
    required this.qualification,
    this.profilePhoto,
    this.contact,
    this.phone,
    this.schedule,
  });
}
