import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/service_locater/service_locator.dart';
import '../../../bookings/presentation/widgets/chat_bubble.dart';
import '../../domain/entities/message.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_input_box.dart';


class ChatBottomSheet extends StatefulWidget {
  final String bookingId;
  final String currentUserId;


  const ChatBottomSheet({
    super.key,
    required this.bookingId,
    required this.currentUserId,
  });

  @override
  State<ChatBottomSheet> createState() => _ChatBottomSheetState();
}

class _ChatBottomSheetState extends State<ChatBottomSheet> {
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ChatBloc>()..add(LoadMessages(widget.bookingId)),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.6,
        maxChildSize: 1.0,
        builder: (_, controller) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const Text("Chat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const Divider(),

                Expanded(
                  child: BlocConsumer<ChatBloc, ChatState>(
                    listener: (context, state) {
                      if (state is ChatLoaded) {
                        _scrollToBottom();
                      }
                    },
                    builder: (context, state) {
                      if (state is ChatLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ChatError) {
                        return Center(child: Text(state.error));
                      } else if (state is ChatLoaded) {
                        final messages = state.messages;
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            final isMe = message.senderId == widget.currentUserId;
                            return ChatBubble(
                              text: message.text,
                              isMe: isMe,
                            );
                          },
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),

                ChatInputBox(
                  onSend: (text) {
                    final message = Message(
                      text: text,
                      senderId: widget.currentUserId,
                      timestamp: DateTime.now(),
                      status: 'sent',
                    );
                    context.read<ChatBloc>().add(
                      SendMessageEvent(
                        bookingId: widget.bookingId,
                        message: message,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
