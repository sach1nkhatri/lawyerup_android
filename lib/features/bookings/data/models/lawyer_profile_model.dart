import '../../domain/entities/lawyer_profile.dart' as domain;

class LawyerProfileModel {
  final String id;
  final String specialization;
  final String qualification;
  final String? profilePhoto;
  final String? contact;
  final String? phone;
  final dynamic schedule;

  LawyerProfileModel({
    required this.id,
    required this.specialization,
    required this.qualification,
    this.profilePhoto,
    this.contact,
    this.phone,
    this.schedule,
  });

  factory LawyerProfileModel.fromJson(Map<String, dynamic> json) {
    return LawyerProfileModel(
      id: json['_id'],
      specialization: json['specialization'] ?? '',
      qualification: json['qualification'] ?? '',
      profilePhoto: json['profilePhoto'],
      contact: json['contact'],
      phone: json['phone'],
      schedule: json['schedule'],
    );
  }

  factory LawyerProfileModel.empty() {
    return LawyerProfileModel(
      id: '',
      specialization: '',
      qualification: '',
      profilePhoto: null,
      contact: null,
      phone: null,
      schedule: {},
    );
  }


  domain.LawyerProfile toEntity() {
    return domain.LawyerProfile(
      id: id,
      specialization: specialization,
      qualification: qualification,
      profilePhoto: profilePhoto,
      contact: contact,
      phone: phone,
      schedule: schedule,
    );
  }
}
