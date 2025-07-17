import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../data/datasources/remote/chat_remote_data_source.dart';
import '../../data/models/chat_model.dart';
import '../bloc/law_ai_chat_bloc.dart';

class ChatDrawer extends StatefulWidget {
  final Function(String chatId) onChatSelected; // callback to parent

  const ChatDrawer({super.key, required this.onChatSelected});

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  List<ChatModel> chats = [];
  bool loading = true;
  String? selectedId;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    try {
      final chatSource = ChatRemoteDataSourceImpl(dio: sl<Dio>());
      final fetchedChats = await chatSource.getChats();
      setState(() {
        chats = fetchedChats;
        loading = false;
      });
    } catch (e) {
      debugPrint("❌ Failed to load chats: $e");
      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentChatId = context.read<LawAiChatBloc>().state.currentChatId;

    return Drawer(
      backgroundColor: const Color(0xFF0F1C2C),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: Text(
                "💬 Chat Sessions",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Loading spinner
            if (loading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Center(child: CircularProgressIndicator(color: Colors.white)),
              )
            else if (chats.isEmpty)
              const Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "No chat history yet.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
            else
            // Chat list
              Expanded(
                child: ListView.separated(
                  itemCount: chats.length,
                  separatorBuilder: (_, __) => const Divider(color: Colors.white12),
                  itemBuilder: (context, index) {
                    final chat = chats[index];
                    final isSelected = chat.id == currentChatId;

                    return ListTile(
                      title: Text(
                        chat.title,
                        style: TextStyle(
                          color: isSelected ? Colors.lightBlueAccent : Colors.white,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      tileColor: isSelected ? Colors.white10 : Colors.transparent,
                      onTap: () {
                        widget.onChatSelected(chat.id); // 🔁 trigger chat load
                        Navigator.pop(context); // close drawer
                      },
                    );
                  },
                ),
              ),

            // Divider
            const Divider(color: Colors.white24),

            // New Chat button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  minimumSize: const Size.fromHeight(45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text("Start New Chat", style: TextStyle(color: Colors.white)),
                onPressed: () {
                  setState(() => selectedId = null);
                  widget.onChatSelected(''); // empty string means new chat
                  Navigator.pop(context);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
