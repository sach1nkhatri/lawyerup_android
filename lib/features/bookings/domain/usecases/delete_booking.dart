import '../repositories/booking_repository.dart';

class DeleteBooking {
  final BookingRepository repository;

  DeleteBooking(this.repository);

  Future<void> call(String bookingId) {
    return repository.deleteBooking(bookingId);
  }
}
