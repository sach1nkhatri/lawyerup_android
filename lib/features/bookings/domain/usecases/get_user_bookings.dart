import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetUserBookings {
  final BookingRepository repository;

  GetUserBookings(this.repository);

  Future<List<Booking>> call(String userId) {
    return repository.getUserBookings(userId);
  }
}
