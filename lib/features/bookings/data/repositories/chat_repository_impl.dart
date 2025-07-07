import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/remote_datasource/booking_remote_data_source.dart';


class ChatRepositoryImpl implements ChatRepository {
  final BookingRemoteDataSource bookingRemoteDataSource;

  ChatRepositoryImpl({required this.bookingRemoteDataSource});

  @override
  Future<void> sendMessage(String bookingId, Message message) {
    // Extract senderId and text from the domain entity (after adjusting entity structure)
    return bookingRemoteDataSource.sendMessage(
      bookingId,
      message.senderId,
      message.text,
    );
  }

  @override
  Future<List<Message>> getMessages(String bookingId) async {
    final result = await bookingRemoteDataSource.getMessages(bookingId);
    return result.map((e) => e.toEntity()).toList();
  }

  @override
  Future<void> markMessagesAsRead(String bookingId) {
    return bookingRemoteDataSource.markMessagesAsRead(bookingId);
  }
}
