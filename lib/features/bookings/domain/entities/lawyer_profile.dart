class LawyerProfile {
  final String id;
  final String specialization;
  final String qualification;
  final String? contact;
  final String? phone;
  final String? rate;
  final String? profilePhoto;
  final Map<String, dynamic>? schedule;

  const LawyerProfile({
    required this.id,
    required this.specialization,
    required this.qualification,
    this.contact,
    this.phone,
    this.rate,
    this.profilePhoto,
    this.schedule,
  });

  static const fallback = LawyerProfile(
    id: '',
    specialization: 'N/A',
    qualification: 'N/A',
    contact: '',
    phone: '',
    rate: '',
    profilePhoto: '',
    schedule: {},
  );
}
