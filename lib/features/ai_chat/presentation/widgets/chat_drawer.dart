import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/law_ai_chat_bloc.dart';
import '../bloc/law_ai_chat_event.dart';
import '../bloc/law_ai_chat_state.dart';

class ChatDrawer extends StatelessWidget {
  const ChatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
      ),
      child: BlocBuilder<LawAiChatBloc, LawAiChatState>(
        builder: (context, state) {
          final chats = state.chatSessions.keys.toList().reversed.toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Color(0xFF1E2B3A),
                  borderRadius: BorderRadius.only(topRight: Radius.circular(20)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.chat_bubble_outline, color: Colors.white, size: 32),
                    SizedBox(height: 12),
                    Text(
                      "Your Chats",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("Select or start a new conversation",
                        style: TextStyle(color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: chats.length,
                  itemBuilder: (context, index) {
                    final chatId = chats[index];
                    final isActive = chatId == state.currentChatId;

                    return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        context.read<LawAiChatBloc>().add(LoadChat(chatId));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: isActive ? const Color(0xFFE0F7FA) : const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(12),
                          border: isActive ? Border.all(color: Colors.teal, width: 1.2) : null,
                        ),
                        child: Text(
                          chatId,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: isActive ? Colors.teal[800] : Colors.black87,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E2B3A),
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    "Start New Chat",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    context.read<LawAiChatBloc>().add(StartNewChat());
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
