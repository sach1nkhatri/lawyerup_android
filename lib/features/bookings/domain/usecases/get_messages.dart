import '../entities/message.dart';
import '../repositories/booking_repository.dart';

class GetMessages {
  final BookingRepository repository;

  GetMessages(this.repository);

  Future<List<Message>> call(String bookingId) {
    return repository.getMessages(bookingId);
  }
}
