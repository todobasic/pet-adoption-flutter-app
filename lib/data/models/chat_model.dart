import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final Timestamp timestamp;

  ChatMessage({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });

  factory ChatMessage.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChatMessage(
      id: doc.id,
      chatId: data['chatId'],
      senderId: data['senderId'],
      content: data['content'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'senderId': senderId,
      'content': content,
      'timestamp': timestamp,
    };
  }
}
