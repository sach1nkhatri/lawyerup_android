import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'law_ai_chat_event.dart';
import 'law_ai_chat_state.dart';

class LawAiChatBloc extends Bloc<LawAiChatEvent, LawAiChatState> {
  LawAiChatBloc()
      : super(LawAiChatState(
    chatSessions: {'chat_1': []},
    currentChatId: 'chat_1',
  )) {
    on<SendMessage>(_onSendMessage);
    on<StartNewChatEvent>(_onStartNewChat);
    on<LoadChatByIdEvent>(_onLoadChat);
    on<SetAllChatsFromDrawerEvent>(_onSetAllChatsFromDrawer);
  }

  Future<void> _onSendMessage(
      SendMessage event,
      Emitter<LawAiChatState> emit,
      ) async {
    final session = [...state.messages];
    session.add({'text': event.message, 'isUser': true});
    emit(state.copyWith(
      chatSessions: {
        ...state.chatSessions,
        state.currentChatId: session,
      },
      isStreaming: true,
    ));

    try {
      const url = 'http://10.0.2.2:1234/v1/chat/completions';
      final request = http.Request('POST', Uri.parse(url))
        ..headers['Content-Type'] = 'application/json'
        ..body = jsonEncode({
          "messages": [
            {"role": "user", "content": event.message}
          ],
          "max_tokens": 200,
          "temperature": 0.7,
          "stream": true,
        });

      final response = await request.send();

      StringBuffer buffer = StringBuffer();
      session.add({'text': '', 'isUser': false});
      emit(state.copyWith(
        chatSessions: {
          ...state.chatSessions,
          state.currentChatId: session,
        },
      ));

      await for (var chunk in response.stream.transform(utf8.decoder)) {
        for (var line in chunk.split('\n')) {
          if (line.startsWith('data: ')) {
            final jsonLine = line.replaceFirst('data: ', '').trim();
            if (jsonLine == '[DONE]') {
              emit(state.copyWith(isStreaming: false));
              break;
            }

            final data = jsonDecode(jsonLine);
            final delta = data['choices'][0]['delta'];
            final newText = delta['content'];
            if (newText != null) {
              buffer.write(newText);
              final updatedSession = [...session];
              updatedSession[updatedSession.length - 1] = {
                'text': buffer.toString(),
                'isUser': false,
              };
              emit(state.copyWith(
                chatSessions: {
                  ...state.chatSessions,
                  state.currentChatId: updatedSession,
                },
              ));
            }
          }
        }
      }
    } catch (e) {
      final errorSession = [...session];
      errorSession.add({'text': 'Error: $e', 'isUser': false});
      emit(state.copyWith(
        chatSessions: {
          ...state.chatSessions,
          state.currentChatId: errorSession,
        },
        isStreaming: false,
      ));
    }
  }

  void _onStartNewChat(
      StartNewChatEvent event,
      Emitter<LawAiChatState> emit,
      ) {
    final newId = 'chat_${DateTime.now().millisecondsSinceEpoch}';
    final updatedSessions =
    Map<String, List<Map<String, dynamic>>>.from(state.chatSessions);
    updatedSessions[newId] = [];
    emit(state.copyWith(chatSessions: updatedSessions, currentChatId: newId));
  }

  void _onLoadChat(
      LoadChatByIdEvent event,
      Emitter<LawAiChatState> emit,
      ) {
    emit(state.copyWith(currentChatId: event.chatId));
  }

  void _onSetAllChatsFromDrawer(
      SetAllChatsFromDrawerEvent event,
      Emitter<LawAiChatState> emit,
      ) {
    final merged = {
      ...state.chatSessions,
      ...event.chatSessions,
    };
    emit(state.copyWith(chatSessions: merged));
  }
}
