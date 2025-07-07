import 'user_model.dart';
import '../../domain/entities/message.dart' as domain;

class MessageModel {
  final String text;
  final String senderId;
  final UserModel sender; // full user
  final DateTime timestamp;
  final String status;

  MessageModel({
    required this.text,
    required this.senderId,
    required this.sender,
    required this.timestamp,
    required this.status,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'];
    final senderId = senderJson['_id'] ?? '';

    return MessageModel(
      text: json['text'],
      senderId: senderId,
      sender: UserModel.fromJson(senderJson), // only 1 param here
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'] ?? 'sent',
    );
  }

  domain.Message toEntity() {
    return domain.Message(
      text: text,
      senderId: senderId,
      timestamp: timestamp,
      status: status,
    );
  }

  factory MessageModel.fromEntity(domain.Message message) {
    return MessageModel(
      text: message.text,
      senderId: message.senderId,
      sender: UserModel.fallback, // 👈 dummy user object
      timestamp: message.timestamp,
      status: message.status,
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'sender': senderId, // only send senderId back to backend
      'timestamp': timestamp.toIso8601String(),
      'status': status,
    };
  }
}
