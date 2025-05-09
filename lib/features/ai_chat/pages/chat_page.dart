import 'package:flutter/material.dart';
import '../widgets/chat_bubble.dart';
import '../widgets/message_input.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E2B3A),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Get Plus+", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.toggle_on, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatBubbleArea(),
          ),
          MessageInput(),
        ],
      ),
    );
  }
}
