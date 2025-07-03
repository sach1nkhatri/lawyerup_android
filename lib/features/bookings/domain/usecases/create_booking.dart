import '../repositories/booking_repository.dart';

class CreateBooking {
  final BookingRepository repository;

  CreateBooking(this.repository);

  Future<void> call(Map<String, dynamic> data) {
    return repository.createBooking(data);
  }
}
