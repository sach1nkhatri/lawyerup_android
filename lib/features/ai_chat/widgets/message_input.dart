import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  const MessageInput({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFD3E6F9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          decoration: const InputDecoration(
            hintText: "Ask anything",
            border: InputBorder.none,
          ),
          onSubmitted: (text) {
            // TODO: handle AI query
          },
        ),
      ),
    );
  }
}
