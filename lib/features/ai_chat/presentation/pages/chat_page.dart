import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/law_ai_chat_bloc.dart';
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
      child: Scaffold(
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
              final title = state.messages.isNotEmpty
                  ? state.messages.firstWhere((m) => m['isUser'], orElse: () => {'text': 'Get Plus+'})['text']
                  : 'Get Plus+';
              return Text(
                title.length > 25 ? '${title.substring(0, 25)}...' : title,
                style: const TextStyle(color: Colors.white),
              );
            },
          ),
          centerTitle: true,
        ),
        drawer: const ChatDrawer(),
        body: const SafeArea(
          child: Column(
            children: [
              Expanded(child: ChatBubbleArea()),
              MessageInput(),
            ],
          ),
        ),
      ),
    );
  }
}
