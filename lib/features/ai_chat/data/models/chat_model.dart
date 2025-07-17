class ChatModel {
  final String id;
  final String title;
  final List<Map<String, dynamic>> messages;

  ChatModel({
    required this.id,
    required this.title,
    required this.messages,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] as List<dynamic>? ?? [];

    final parsedMessages = messagesJson.map<Map<String, dynamic>>((m) {
      final role = m['role'] ?? '';
      final content = m['content'] ?? '';

      return {
        'text': content,
        'isUser': role == 'user',
      };
    }).toList();

    return ChatModel(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Untitled',
      messages: parsedMessages,
    );
  }
}
