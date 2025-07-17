import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/law_ai_chat_bloc.dart';
import '../bloc/law_ai_chat_event.dart';
import '../bloc/law_ai_chat_state.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';
import '../widgets/chat_drawer.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LawAiChatBloc(),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatelessWidget {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        automaticallyImplyLeading: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: BlocBuilder<LawAiChatBloc, LawAiChatState>(
          builder: (context, state) {
            final messages = state.messages;
            final title = messages.isNotEmpty
                ? messages.firstWhere((m) => m['isUser'], orElse: () => {'text': 'Get Plus+'})['text']
                : 'New Chat';

            return Text(
              title.length > 25 ? '${title.substring(0, 25)}...' : title,
              style: const TextStyle(color: Colors.white),
            );
          },
        ),
        centerTitle: true,
      ),
      drawer: ChatDrawer(
        onChatSelected: (chatId) {
          final bloc = context.read<LawAiChatBloc>();

          if (chatId.isEmpty) {
            bloc.add(StartNewChatEvent());
          } else {
            bloc.add(LoadChatByIdEvent(chatId));
          }
        },
      ),
      body: const SafeArea(
        child: Column(
          children: [
            Expanded(child: ChatBubbleArea()),
            MessageInput(),
          ],
        ),
      ),
    );
  }
}
