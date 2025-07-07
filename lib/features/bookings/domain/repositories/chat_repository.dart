import '../entities/message.dart';

abstract class ChatRepository {
  Future<void> sendMessage(String bookingId, Message message);
  Future<List<Message>> getMessages(String bookingId);
  Future<void> markMessagesAsRead(String bookingId);
}
