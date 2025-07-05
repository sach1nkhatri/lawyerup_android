import '../entities/booking.dart';
import '../entities/message.dart';

abstract class BookingRepository {
  Future<List<Booking>> getBookings({
    required String userId,
    required String role, // 'user' or 'lawyer'
  });

  Future<void> createBooking(Map<String, dynamic> data);
  Future<void> updateBookingStatus(String bookingId, String newStatus);
  Future<void> updateMeetingLink(String bookingId, String link);
  Future<void> deleteBooking(String bookingId);

  Future<List<String>> getAvailableSlots({
    required String lawyerId,
    required String date,
    required int duration,
  });

  Future<List<Message>> getMessages(String bookingId);
  Future<Message> sendMessage(String bookingId, String senderId, String text);
  Future<void> markMessagesAsRead(String bookingId);
}
