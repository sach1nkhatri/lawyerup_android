import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetLawyerBookings {
  final BookingRepository repository;

  GetLawyerBookings(this.repository);

  Future<List<Booking>> call(String lawyerId) {
    return repository.getLawyerBookings(lawyerId);
  }
}
