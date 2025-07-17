import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/law_ai_chat_bloc.dart';
import '../bloc/law_ai_chat_event.dart';
import '../bloc/law_ai_chat_state.dart';

class ChatBubbleArea extends StatefulWidget {
  const ChatBubbleArea({super.key});

  @override
  State<ChatBubbleArea> createState() => _ChatBubbleAreaState();
}

class _ChatBubbleAreaState extends State<ChatBubbleArea> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LawAiChatBloc, LawAiChatState>(
      builder: (context, state) {
        final messages = state.messages; // ✅ clean getter from state

        // Auto-scroll to bottom
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });

        if (messages.isEmpty) {
          return const RecommendedPrompts();
        }

        return ListView.builder(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final msg = messages[index];
            final isUser = msg['isUser'] == true;
            final text = msg['text'] ?? '';

            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: ChatBubble(
                text: text,
                isUser: isUser,
              ),
            );
          },
        );
      },
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatBubble({super.key, required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      constraints: const BoxConstraints(maxWidth: 300),
      decoration: BoxDecoration(
        color: isUser ? const Color(0xFFA5F6EF) : const Color(0xFFD3E6F9),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}

class RecommendedPrompts extends StatelessWidget {
  const RecommendedPrompts({super.key});

  @override
  Widget build(BuildContext context) {
    final prompts = [
      "What is law?",
      "How to file a complaint?",
      "Can I represent myself in court?",
      "What rights do I have during an arrest?",
      "Explain the types of contracts.",
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Try asking",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E2B3A),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 12,
            children: prompts.map((text) {
              return InkWell(
                onTap: () {
                  context.read<LawAiChatBloc>().add(SendMessage(text));
                },
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F6FA),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Text(
                    text,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
