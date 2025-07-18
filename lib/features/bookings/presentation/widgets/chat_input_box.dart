import 'package:flutter/material.dart';

class ChatInputBox extends StatefulWidget {
  final Function(String) onSend;
  final VoidCallback? onTyping; // ✅ optional typing callback

  const ChatInputBox({
    super.key,
    required this.onSend,
    this.onTyping,
  });

  @override
  State<ChatInputBox> createState() => _ChatInputBoxState();
}


class _ChatInputBoxState extends State<ChatInputBox> {
  final TextEditingController _controller = TextEditingController();

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSend(text);
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 8,
        left: 12,
        right: 12,
        top: 8,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                decoration: const InputDecoration(
                  hintText: "Type a message...",
                  border: InputBorder.none,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: Colors.lightBlueAccent),
              onPressed: _handleSend,
            )
          ],
        ),
      ),
    );
  }
}
