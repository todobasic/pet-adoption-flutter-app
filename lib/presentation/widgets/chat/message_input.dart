import 'package:flutter/material.dart';

class MessageInput extends StatelessWidget {
  final TextEditingController messageController;
  final VoidCallback onSend;

  const MessageInput({
    required this.messageController,
    required this.onSend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: messageController,
              decoration: const InputDecoration(hintText: 'Enter your message...'),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: onSend,
          ),
        ],
      ),
    );
  }
}
