import 'user.dart';
import 'lawyer_profile.dart';

class Booking {
  final String id;
  final User user;
  final User lawyer;
  final LawyerProfile lawyerList;
  final String date;
  final String time;
  final int duration;
  final String mode;
  final String description;
  final String meetingLink;
  final String status;
  final bool reviewed;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
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
    required this.createdAt,
    required this.updatedAt,
  });
}
