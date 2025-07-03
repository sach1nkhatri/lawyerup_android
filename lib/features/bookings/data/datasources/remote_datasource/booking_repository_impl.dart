import 'package:lawyerup_android/features/bookings/domain/entities/booking.dart';
import 'package:lawyerup_android/features/bookings/domain/entities/message.dart';
import 'package:lawyerup_android/features/bookings/domain/repositories/booking_repository.dart';

import 'booking_remote_data_source.dart';




class BookingRepositoryImpl implements BookingRepository {
  final BookingRemoteDataSource remote;

  BookingRepositoryImpl({required this.remote});

  @override
  Future<List<Booking>> getUserBookings(String userId) async {
    final result = await remote.getUserBookings(userId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Booking>> getLawyerBookings(String lawyerId) async {
    final result = await remote.getLawyerBookings(lawyerId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> createBooking(Map<String, dynamic> data) {
    return remote.createBooking(data);
  }

  @override
  Future<void> updateBookingStatus(String bookingId, String newStatus) {
    return remote.updateBookingStatus(bookingId, newStatus);
  }

  @override
  Future<void> updateMeetingLink(String bookingId, String link) {
    return remote.updateMeetingLink(bookingId, link);
  }

  @override
  Future<void> deleteBooking(String bookingId) {
    return remote.deleteBooking(bookingId);
  }

  @override
  Future<List<String>> getAvailableSlots({
    required String lawyerId,
    required String date,
    required int duration,
  }) {
    return remote.getAvailableSlots(
      lawyerId: lawyerId,
      date: date,
      duration: duration,
    );
  }

  @override
  Future<List<Message>> getMessages(String bookingId) async {
    final result = await remote.getMessages(bookingId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Message> sendMessage(String bookingId, String senderId, String text) async {
    final model = await remote.sendMessage(bookingId, senderId, text);
    return model.toEntity();
  }

  @override
  Future<void> markMessagesAsRead(String bookingId) {
    return remote.markMessagesAsRead(bookingId);
  }
}
