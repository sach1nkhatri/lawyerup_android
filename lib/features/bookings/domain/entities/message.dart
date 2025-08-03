class Message {
  final String text;
  final String senderId;
  final DateTime timestamp;
  final String status;
  final String? senderName;

  Message({
    required this.text,
    required this.senderId,
    required this.timestamp,
    required this.status,
    this.senderName,
  });
}
