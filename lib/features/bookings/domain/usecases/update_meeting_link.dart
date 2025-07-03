import '../repositories/booking_repository.dart';

class UpdateMeetingLink {
  final BookingRepository repository;

  UpdateMeetingLink(this.repository);

  Future<void> call(String bookingId, String link) {
    return repository.updateMeetingLink(bookingId, link);
  }
}
