import '../../domain/entities/booking.dart';
import '../../domain/entities/lawyer_profile.dart';
import '../../domain/entities/user.dart'; // Make sure this is imported
import 'user_model.dart';
import 'lawyer_profile_model.dart';

class BookingModel extends Booking {
  const BookingModel({
    required super.id,
    required super.user,
    required super.lawyer,
    required super.lawyerList,
    required super.date,
    required super.time,
    required super.duration,
    required super.mode,
    required super.description,
    required super.meetingLink,
    required super.status,
    required super.reviewed,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'] ?? '',

      user: (json['user'] != null && json['user'] is Map<String, dynamic>)
          ? UserModel.fromJson(json['user']).toEntity()
          : User.fallback,

      lawyer: (json['lawyer'] != null && json['lawyer'] is Map<String, dynamic>)
          ? UserModel.fromJson(json['lawyer']).toEntity()
          : User.fallback,

      lawyerList: (json['lawyerList'] != null && json['lawyerList'] is Map<String, dynamic>)
          ? LawyerProfileModel.fromJson(json['lawyerList']).toEntity()
          : LawyerProfile.fallback,

      date: json['date'] ?? '',
      time: json['time'] ?? '',
      duration: json['duration'] ?? 1,
      mode: json['mode'] ?? 'online',
      description: json['description'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      status: json['status'] ?? 'pending',
      reviewed: json['reviewed'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': (user as UserModel).toJson(),
      'lawyer': (lawyer as UserModel).toJson(),
      'lawyerList': (lawyerList as LawyerProfileModel).toJson(),
      'date': date,
      'time': time,
      'duration': duration,
      'mode': mode,
      'description': description,
      'meetingLink': meetingLink,
      'status': status,
      'reviewed': reviewed,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
