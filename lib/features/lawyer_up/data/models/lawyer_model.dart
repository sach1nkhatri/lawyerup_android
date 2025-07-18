class LawyerModel {
  final String id;
  final String user; // ✅ NEW: Lawyer's user ID
  final String fullName;
  final String specialization; // Used as bar reg number
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
  final List<ReviewModel> reviews;
  final Map<String, List<ScheduleSlotModel>> schedule;

  LawyerModel({
    required this.id,
    required this.user, // ✅ in constructor
    required this.fullName,
    required this.specialization,
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

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    return LawyerModel(
      id: json['_id'],
      user: json['user'] is Map && json['user']['\$oid'] != null
          ? json['user']['\$oid']
          : json['user'].toString(), // ✅ handles both formats
      fullName: json['fullName'],
      specialization: json['specialization'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      profilePhoto: json['profilePhoto'],
      licenseFile: json['licenseFile'],
      description: json['description'],
      specialCase: json['specialCase'],
      socialLink: json['socialLink'],
      workExperience: (json['workExperience'] as List)
          .map((e) => WorkExperienceModel.fromJson(e))
          .toList(),
      education: (json['education'] as List)
          .map((e) => EducationModel.fromJson(e))
          .toList(),
      schedule: (json['schedule'] as Map<String, dynamic>).map(
            (day, slots) => MapEntry(
          day,
          (slots as List)
              .map((e) => ScheduleSlotModel.fromJson(e))
              .toList(),
        ),
      ),
      reviews: (json['reviews'] as List)
          .map((e) => ReviewModel.fromJson(e))
          .toList(),
    );
  }
}
class WorkExperienceModel {
  final String court;
  final String from;
  final String to;

  WorkExperienceModel({
    required this.court,
    required this.from,
    required this.to,
  });

  factory WorkExperienceModel.fromJson(Map<String, dynamic> json) {
    return WorkExperienceModel(
      court: json['court'],
      from: json['from'],
      to: json['to'],
    );
  }
}
class EducationModel {
  final String degree;
  final String institute;
  final String year;
  final String specialization;

  EducationModel({
    required this.degree,
    required this.institute,
    required this.year,
    required this.specialization,
  });

  factory EducationModel.fromJson(Map<String, dynamic> json) {
    return EducationModel(
      degree: json['degree'],
      institute: json['institute'],
      year: json['year'],
      specialization: json['specialization'],
    );
  }
}
class ScheduleSlotModel {
  final String start;
  final String end;

  ScheduleSlotModel({
    required this.start,
    required this.end,
  });

  factory ScheduleSlotModel.fromJson(Map<String, dynamic> json) {
    return ScheduleSlotModel(
      start: json['start'],
      end: json['end'],
    );
  }
}
class ReviewModel {
  final String name;
  final String comment;
  final double rating;

  ReviewModel({
    required this.name,
    required this.comment,
    required this.rating,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      name: json['user'] ?? '', // ✅ FIXED: using 'user' field
      comment: json['comment'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }
}
