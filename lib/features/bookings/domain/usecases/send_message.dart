import '../entities/message.dart';
import '../repositories/chat_repository.dart';


class SendMessage {
  final ChatRepository repository;
  SendMessage(this.repository);

  Future<Message> call(String bookingId, Message message) {
    return repository.sendMessage(bookingId, message); // <- now returns Message
  }
}


