import '../entities/message.dart';

// chat_repository.dart
abstract class ChatRepository {
  Future<Message> sendMessage(String bookingId, Message message); // <- updated
  Future<List<Message>> getMessages(String bookingId);
  Future<void> markMessagesAsRead(String bookingId);
}
