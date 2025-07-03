import '../repositories/booking_repository.dart';

class UpdateBookingStatus {
  final BookingRepository repository;

  UpdateBookingStatus(this.repository);

  Future<void> call(String bookingId, String newStatus) {
    return repository.updateBookingStatus(bookingId, newStatus);
  }
}
