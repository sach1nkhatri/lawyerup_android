import '../entities/message.dart';
import '../repositories/chat_repository.dart';

class SendMessage {
  final ChatRepository repository;

  SendMessage(this.repository);

  Future<void> call(String bookingId, Message message) async {
    return await repository.sendMessage(bookingId, message);
  }
}

