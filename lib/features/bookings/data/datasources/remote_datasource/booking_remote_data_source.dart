import 'package:dio/dio.dart';
import '../../models/booking_model.dart';
import '../../models/message_model.dart';

class BookingRemoteDataSource {
  final Dio dio;

  BookingRemoteDataSource({required this.dio});
  Future<List<BookingModel>> getBookings({
    required String userId,
    required String role, // 'user' or 'lawyer'
  }) async {
    try {
      //  Dynamically choose endpoint
      final endpoint = role == 'lawyer'
          ? '/bookings/lawyer/$userId'
          : '/bookings/user/$userId';

      final res = await dio.get(endpoint);

      return (res.data as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();
    } catch (e) {
      print("Booking fetch failed: $e");
      rethrow;
    }
  }

  Future<void> createBooking(Map<String, dynamic> data) async {
    await dio.post('/bookings', data: data);
  }

  Future<void> updateBookingStatus(String id, String newStatus) async {
    await dio.patch('/bookings/$id/status', data: {'status': newStatus});
  }

  Future<void> updateMeetingLink(String id, String link) async {
    await dio.patch('/bookings/$id/meeting-link', data: {'meetingLink': link});
  }

  Future<void> deleteBooking(String id) async {
    await dio.delete('/bookings/$id');
  }

  Future<List<String>> getAvailableSlots({
    required String lawyerId,
    required String date,
    required int duration,
  }) async {
    final res = await dio.get('/bookings/slots', queryParameters: {
      'lawyerId': lawyerId,
      'date': date,
      'duration': duration,
    });

    return (res.data as List).map((e) => e.toString()).toList();
  }

  Future<List<MessageModel>> getMessages(String bookingId) async {
    final res = await dio.get('/bookings/$bookingId/chat');
    return (res.data as List).map((e) => MessageModel.fromJson(e)).toList();
  }

  Future<MessageModel> sendMessage(
      String bookingId,
      String senderId,
      String text,
      ) async {
    final res = await dio.post('/bookings/$bookingId/chat', data: {
      'sender': senderId,
      'text': text,
    });
    return MessageModel.fromJson(res.data);
  }

  Future<void> markMessagesAsRead(String bookingId) async {
    await dio.patch('/bookings/$bookingId/chat/read');
  }
}
