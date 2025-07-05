import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookings {
  final BookingRepository repository;

  GetBookings(this.repository);

  Future<List<Booking>> call({
    required String userId,
    required String role, // 'user' or 'lawyer'
  }) async {
    return await repository.getBookings(userId: userId, role: role);
  }
}
