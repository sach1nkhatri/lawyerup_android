class Message {
  final String text;
  final String senderId;
  final DateTime timestamp;
  final String status;

  Message({
    required this.text,
    required this.senderId,
    required this.timestamp,
    required this.status,
  });
}
