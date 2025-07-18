import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_messages.dart';
import '../../domain/usecases/send_message.dart';
import '../../domain/usecases/mark_messages_as_read.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final GetMessages getMessages;
  final SendMessage sendMessage;
  final MarkMessagesAsRead markMessagesAsRead;

  ChatBloc({
    required this.getMessages,
    required this.sendMessage,
    required this.markMessagesAsRead,
  }) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessageEvent>(_onSendMessage);
  }

  Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
    emit(ChatLoading());
    try {
      final messages = await getMessages(event.bookingId);
      emit(ChatLoaded(messages));
      await markMessagesAsRead(event.bookingId);
    } catch (e) {
      emit(ChatError("Failed to load messages: ${e.toString()}"));
    }
  }

  Future<void> _onSendMessage(SendMessageEvent event, Emitter<ChatState> emit) async {
    if (state is ChatLoaded) {
      try {
        final sentMessage = await sendMessage(event.bookingId, event.message);

        final currentMessages = (state as ChatLoaded).messages;
        final updatedMessages = [...currentMessages, sentMessage];

        emit(ChatLoaded(updatedMessages));
      } catch (e) {
        emit(ChatError("Failed to send message: ${e.toString()}"));
      }
    }
  }
}
