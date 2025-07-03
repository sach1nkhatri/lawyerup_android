import '../repositories/booking_repository.dart';

class GetAvailableSlots {
  final BookingRepository repository;

  GetAvailableSlots(this.repository);

  Future<List<String>> call({
    required String lawyerId,
    required String date,
    required int duration,
  }) {
    return repository.getAvailableSlots(
      lawyerId: lawyerId,
      date: date,
      duration: duration,
    );
  }
}
