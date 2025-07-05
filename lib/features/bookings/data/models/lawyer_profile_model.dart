import '../../domain/entities/lawyer_profile.dart' as domain;

class LawyerProfileModel {
  final String id;
  final String specialization;
  final String qualification;
  final String? contact;
  final String? phone;
  final String? rate;
  final String? profilePhoto;
  final Map<String, dynamic>? schedule;

  LawyerProfileModel({
    required this.id,
    required this.specialization,
    required this.qualification,
    this.contact,
    this.phone,
    this.rate,
    this.profilePhoto,
    this.schedule,
  });

  factory LawyerProfileModel.fromJson(Map<String, dynamic> json) {
    return LawyerProfileModel(
      id: json['_id'] ?? '',
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      contact: json['contact'],
      phone: json['phone'],
      rate: json['rate'],
      profilePhoto: json['profilePhoto'],
      schedule: Map<String, dynamic>.from(json['schedule'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'specialization': specialization,
      'qualification': qualification,
      'contact': contact,
      'phone': phone,
      'rate': rate,
      'profilePhoto': profilePhoto,
      'schedule': schedule,
    };
  }

  domain.LawyerProfile toEntity() {
    return domain.LawyerProfile(
      id: id,
      specialization: specialization,
      qualification: qualification,
      contact: contact,
      phone: phone,
      rate: rate,
      profilePhoto: profilePhoto,
      schedule: schedule,
    );
  }

  static domain.LawyerProfile fallback = domain.LawyerProfile.fallback;
}
