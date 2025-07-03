import '../entities/message.dart';
import '../repositories/booking_repository.dart';

class SendMessage {
  final BookingRepository repository;

  SendMessage(this.repository);

  Future<Message> call(String bookingId, String senderId, String text) {
    return repository.sendMessage(bookingId, senderId, text);
  }
}
