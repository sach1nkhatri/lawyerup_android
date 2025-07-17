import 'package:equatable/equatable.dart';

class LawAiChatState extends Equatable {
  final Map<String, List<Map<String, dynamic>>> chatSessions;
  final String currentChatId;
  final bool isStreaming;

  const LawAiChatState({
    required this.chatSessions,
    required this.currentChatId,
    this.isStreaming = false,
  });

  List<Map<String, dynamic>> get messages => chatSessions[currentChatId] ?? [];

  LawAiChatState copyWith({
    Map<String, List<Map<String, dynamic>>>? chatSessions,
    String? currentChatId,
    bool? isStreaming,
  }) {
    return LawAiChatState(
      chatSessions: chatSessions ?? this.chatSessions,
      currentChatId: currentChatId ?? this.currentChatId,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  @override
  List<Object?> get props => [chatSessions, currentChatId, isStreaming];
}
