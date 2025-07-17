import 'package:equatable/equatable.dart';

abstract class LawAiChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SendMessage extends LawAiChatEvent {
  final String message;
  SendMessage(this.message);

  @override
  List<Object?> get props => [message];
}

class StartNewChat extends LawAiChatEvent {}

class LoadChat extends LawAiChatEvent {
  final String chatId;
  LoadChat(this.chatId);

  @override
  List<Object?> get props => [chatId];
}
