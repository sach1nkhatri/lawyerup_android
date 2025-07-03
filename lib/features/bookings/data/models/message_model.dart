import 'user_model.dart';
import '../../domain/entities/message.dart' as domain;

class MessageModel {
  final String text;
  final UserModel sender;
  final DateTime timestamp;
  final String status;

  MessageModel({
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      text: json['text'],
      sender: UserModel.fromJson(json['sender']),
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'] ?? 'sent',
    );
  }

  domain.Message toEntity() {
    return domain.Message(
      text: text,
      sender: sender.toEntity(),
      timestamp: timestamp,
      status: status,
    );
  }
}
