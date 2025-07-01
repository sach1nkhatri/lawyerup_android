import '../../data/models/lawyer_model.dart';

class Lawyer {
  final String id;
  final String fullName;
  final String specialization; // From latest education
  final String barRegNumber; // From root-level specialization
  final String email;
  final String phone;
  final String address;
  final String city;
  final String state;
  final String profilePhoto;
  final String licenseFile;
  final String description;
  final String specialCase;
  final String socialLink;
  final List<WorkExperienceModel> workExperience;
  final List<EducationModel> education;
  final Map<String, List<ScheduleSlotModel>> schedule;
  final List<ReviewModel> reviews;

  Lawyer({
    required this.id,
    required this.fullName,
    required this.specialization,
    required this.barRegNumber,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.state,
    required this.profilePhoto,
    required this.licenseFile,
    required this.description,
    required this.specialCase,
    required this.socialLink,
    required this.workExperience,
    required this.education,
    required this.schedule,
    required this.reviews,
  });

}