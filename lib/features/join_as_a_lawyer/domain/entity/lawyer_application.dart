class LawyerApplication {
  final String fullName;
  final String specialization;
  final String email;
  final String phone;
  final String state;
  final String city;
  final String address;
  final String? description;
  final String? specialCase;
  final String? socialLink;
  final List<Education> education;
  final List<WorkExperience> workExperience;
  final Map<String, List<TimeSlot>> schedule;
  final bool isJunior;
  final String? expectedGraduation;

  final String? profilePhotoPath; // local path
  final String? licenseFilePath;

  LawyerApplication({
    required this.fullName,
    required this.specialization,
    required this.email,
    required this.phone,
    required this.state,
    required this.city,
    required this.address,
    required this.description,
    required this.specialCase,
    required this.socialLink,
    required this.education,
    required this.workExperience,
    required this.schedule,
    required this.isJunior,
    this.expectedGraduation,
    required this.profilePhotoPath,
    required this.licenseFilePath,
  });
}

class Education {
  final String degree;
  final String institute;
  final String year;
  final String specialization;

  Education({
    required this.degree,
    required this.institute,
    required this.year,
    required this.specialization,
  });

  Map<String, dynamic> toJson() => {
    'degree': degree,
    'institute': institute,
    'year': year,
    'specialization': specialization,
  };
}

class WorkExperience {
  final String court;
  final String from;
  final String to;

  WorkExperience({
    required this.court,
    required this.from,
    required this.to,
  });

  Map<String, dynamic> toJson() => {
    'court': court,
    'from': from,
    'to': to,
  };
}

class TimeSlot {
  final String start;
  final String end;

  TimeSlot({
    required this.start,
    required this.end,
  });

  Map<String, dynamic> toJson() => {
    'start': start,
    'end': end,
  };
}
