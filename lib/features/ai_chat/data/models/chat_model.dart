class ChatModel {
  final String id;
  final String title;

  ChatModel({required this.id, required this.title});

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['_id'],
      title: json['title'] ?? 'Untitled',
    );
  }
}
