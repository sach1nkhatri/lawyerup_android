import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/law_ai_chat_bloc.dart';
import '../bloc/law_ai_chat_event.dart';

class MessageInput extends StatefulWidget {
  const MessageInput({super.key});

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFD3E6F9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 120),
                child: Scrollbar(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: "Ask anything",
                      border: InputBorder.none,
                    ),
                    onSubmitted: _handleSubmit,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send_rounded),
              color: Colors.black87,
              onPressed: () => _handleSubmit(_controller.text),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSubmit(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    context.read<LawAiChatBloc>().add(SendMessage(trimmed));
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
