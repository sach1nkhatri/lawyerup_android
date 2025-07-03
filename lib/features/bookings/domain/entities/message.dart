import 'user.dart';

class Message {
  final String text;
  final User sender;
  final DateTime timestamp;
  final String status;

  Message({
    required this.text,
    required this.sender,
    required this.timestamp,
    required this.status,
  });
}
