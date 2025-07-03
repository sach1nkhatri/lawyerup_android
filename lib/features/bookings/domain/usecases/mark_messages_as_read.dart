import '../repositories/booking_repository.dart';

class MarkMessagesAsRead {
  final BookingRepository repository;

  MarkMessagesAsRead(this.repository);

  Future<void> call(String bookingId) {
    return repository.markMessagesAsRead(bookingId);
  }
}
