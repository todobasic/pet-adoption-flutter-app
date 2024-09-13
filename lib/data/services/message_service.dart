import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> markMessagesAsRead(String chatRoomId, String currentUserId) async {
    final unreadMessages = await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isRead', isEqualTo: false)
        .get();

    for (var doc in unreadMessages.docs) {
      doc.reference.update({'isRead': true});
    }
  }
}

final messageServiceProvider = Provider((ref) => MessageService());