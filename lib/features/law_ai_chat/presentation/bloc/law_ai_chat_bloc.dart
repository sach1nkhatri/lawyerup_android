import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

import '../../../../app/constant/api_endpoints.dart';
import '../../../auth/data/models/user_hive_model.dart';
import 'law_ai_chat_event.dart';
import 'law_ai_chat_state.dart';

class LawAiChatBloc extends Bloc<LawAiChatEvent, LawAiChatState> {
  LawAiChatBloc()
      : super(
    LawAiChatState(
      chatSessions: {'chat_1': []},
      currentChatId: 'chat_1',
    ),
  ) {
    on<SendMessage>(_onSendMessage);
    on<StartNewChatEvent>(_onStartNewChat);
    on<LoadChatByIdEvent>(_onLoadChat);
    on<SetAllChatsFromDrawerEvent>(_onSetAllChatsFromDrawer);
  }

  Future<void> _onSendMessage(
      SendMessage event,
      Emitter<LawAiChatState> emit,
      ) async {
    final userBox = Hive.box<UserHiveModel>('users');
    final token = userBox.getAt(0)?.token;

    if (token == null) {
      emit(state.copyWith(isStreaming: false));
      return;
    }

    final dio = Dio();
    String chatId = state.currentChatId;
    final allSessions = {...state.chatSessions};

    // Create chat if placeholder
    if (!allSessions.containsKey(chatId) || chatId == 'chat_1') {
      final res = await dio.post(
        ApiEndpoints.getChats,
        options: Options(headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        }),
      );
      chatId = res.data['_id'];

      allSessions[chatId] = [];
      emit(state.copyWith(
        currentChatId: chatId,
        chatSessions: allSessions,
      ));
    }

    // Add user message
    final updated = [...allSessions[chatId] ?? []]
      ..add({'text': event.message, 'isUser': true});
    allSessions[chatId] = updated.cast<Map<String, dynamic>>();
    emit(state.copyWith(
      chatSessions: allSessions,
      isStreaming: true,
    ));

    // Save to DB
    await dio.post(
      ApiEndpoints.sendAiMessage(chatId),
      data: {'chatId': chatId, 'message': event.message},
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );

    // Start bot response
    final botSession = [...allSessions[chatId] ?? []]
      ..add({'text': '', 'isUser': false});
    allSessions[chatId] = botSession.cast<Map<String, dynamic>>();
    emit(state.copyWith(chatSessions: allSessions));

    // Build full message history
    final sessionHistory = allSessions[chatId] ?? [];

    final List<Map<String, String>> messages = [
      {
        'role': 'system',
        'content': '''
You are LawyerUp AI – a professional, reliable Nepali legal assistant.

You must only answer questions strictly related to:
- Nepali law and legal procedures
- Social, political, and geopolitical matters (if they relate to law)
- Government regulations, legal rights, or constitutional topics

Do NOT answer anything unrelated to legal, civic, or governmental matters.

You may respond in simple English or Nepali based on the user’s tone. Be concise, helpful, and accurate. If a user asks something outside your domain, politely say that LawyerUp AI is focused only on legal topics.
'''
      },
      for (final msg in sessionHistory)
        {
          'role': msg['isUser'] == true ? 'user' : 'assistant',
          'content': msg['text'] ?? ''
        },
      {
        'role': 'user',
        'content': event.message,
      },
    ];

    final request = http.Request(
      'POST',
      Uri.parse('http://192.168.1.85:1234/v1/chat/completions'),
    )
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({
        'model': 'llama3:8b-instruct',
        'stream': true,
        'messages': messages,
      });

    final response = await request.send();
    final buffer = StringBuffer();

    await for (final chunk in response.stream.transform(utf8.decoder)) {
      for (final line in chunk.split('\n')) {
        if (line.trim() == 'data: [DONE]') {
          emit(state.copyWith(isStreaming: false));
          break;
        }

        if (line.startsWith('data:')) {
          final jsonLine = line.substring(5).trim();
          if (jsonLine.isEmpty) continue;

          try {
            final data = jsonDecode(jsonLine);
            final tokenPart = data['choices'][0]['delta']['content'];
            if (tokenPart != null) {
              buffer.write(tokenPart);

              final updatedBot = [...state.chatSessions[chatId] ?? []];
              if (updatedBot.isNotEmpty &&
                  updatedBot.last['isUser'] == false) {
                updatedBot[updatedBot.length - 1] = {
                  'text': buffer.toString(),
                  'isUser': false,
                };

                emit(state.copyWith(chatSessions: {
                  ...state.chatSessions,
                  chatId: updatedBot.cast<Map<String, dynamic>>(),
                }));
              }
            }
          } catch (_) {}
        }
      }
    }

    // Save final reply
    await dio.post(
      ApiEndpoints.saveReply,
      data: {'chatId': chatId, 'reply': buffer.toString()},
      options: Options(headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      }),
    );
  }

  void _onStartNewChat(
      StartNewChatEvent event,
      Emitter<LawAiChatState> emit,
      ) {
    final newId = 'chat_\${DateTime.now().millisecondsSinceEpoch}';
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
