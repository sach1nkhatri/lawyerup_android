import '../../domain/entities/message.dart';

abstract class ChatEvent {}

class LoadMessages extends ChatEvent {
  final String bookingId;

  LoadMessages(this.bookingId);
}

class SendMessageEvent extends ChatEvent {
  final String bookingId;
  final Message message;

  SendMessageEvent({required this.bookingId, required this.message});
}
