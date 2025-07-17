import 'package:equatable/equatable.dart';

import '../../data/models/chat_model.dart';

abstract class LawAiChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

/// 🚀 User sends a message
class SendMessage extends LawAiChatEvent {
  final String message;
  SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

/// 🆕 Start a new empty chat
class StartNewChatEvent extends LawAiChatEvent {}

/// 📥 Load a saved chat by ID
class LoadChatByIdEvent extends LawAiChatEvent {
  final String chatId;
  LoadChatByIdEvent(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

/// 💡 Load default prompt recommendations (optional)
class LoadInitialRecommendationsEvent extends LawAiChatEvent {}


class SetActiveChatEvent extends LawAiChatEvent {
  final ChatModel chat;

  SetActiveChatEvent(this.chat);

  @override
  List<Object?> get props => [chat];
}

class SetAllChatsFromDrawerEvent extends LawAiChatEvent {
  final Map<String, List<Map<String, dynamic>>> chatSessions;

  SetAllChatsFromDrawerEvent(this.chatSessions);

  @override
  List<Object?> get props => [chatSessions];
}
