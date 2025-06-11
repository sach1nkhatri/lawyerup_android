import 'package:flutter/material.dart';

class ChatBubbleArea extends StatelessWidget {
  const ChatBubbleArea({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: const [
        Align(
          alignment: Alignment.centerRight,
          child: ChatBubble(
            text: "What is law",
            isUser: true,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: ChatBubble(
            text: "Law, broadly defined, is a system of rules established by a government or society to regulate behavior and maintain order.",
            isUser: false,
          ),
        ),
      ],
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
