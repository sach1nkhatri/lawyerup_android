import 'user_model.dart';
import 'lawyer_profile_model.dart';
import 'message_model.dart';
import '../../domain/entities/booking.dart';
import '../../domain/entities/user.dart' as domain_user;
import '../../domain/entities/lawyer_profile.dart' as domain_lawyer;
import '../../domain/entities/message.dart' as domain_message;

class BookingModel {
  final String id;
  final UserModel user;
  final UserModel lawyer;
  final LawyerProfileModel lawyerList;
  final String date;
  final String time;
  final int duration;
  final String mode;
  final String description;
  final String meetingLink;
  final String status;
  final bool reviewed;
  final List<MessageModel> messages;
  final DateTime createdAt;
  final DateTime updatedAt;

  BookingModel({
    required this.id,
    required this.user,
    required this.lawyer,
    required this.lawyerList,
    required this.date,
    required this.time,
    required this.duration,
    required this.mode,
    required this.description,
    required this.meetingLink,
    required this.status,
    required this.reviewed,
    required this.messages,
    required this.createdAt,
    required this.updatedAt,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['_id'],
      user: UserModel.fromJson(json['user']),
      lawyer: UserModel.fromJson(json['lawyer']),
      lawyerList: LawyerProfileModel.fromJson(json['lawyerList']),
      date: json['date'],
      time: json['time'],
      duration: json['duration'],
      mode: json['mode'],
      description: json['description'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      status: json['status'],
      reviewed: json['reviewed'] ?? false,
      messages: (json['messages'] as List<dynamic>?)
          ?.map((e) => MessageModel.fromJson(e))
          .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Booking toEntity() {
    return Booking(
      id: id,
      user: user.toEntity(),
      lawyer: lawyer.toEntity(),
      lawyerList: lawyerList.toEntity(),
      date: date,
      time: time,
      duration: duration,
      mode: mode,
      description: description,
      meetingLink: meetingLink,
      status: status,
      reviewed: reviewed,
      messages: messages.map((m) => m.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
