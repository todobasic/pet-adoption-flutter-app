import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final bool isMe;
  final String text;

  const MessageBubble({
    required this.isMe,
    required this.text,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Text(
          text,
          style: TextStyle(color: isMe ? Colors.white : Colors.black),
        ),
      ),
    );
  }
}
