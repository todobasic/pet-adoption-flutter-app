import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  final FirebaseFirestore _firestore;

  ChatRepository(this._firestore);

  String getChatRoomId(String currentUserId, String otherUserId) {
    return currentUserId.compareTo(otherUserId) > 0
        ? '${currentUserId}_$otherUserId'
        : '${otherUserId}_$currentUserId';
  }

  Stream<QuerySnapshot> getMessagesStream(String chatRoomId) {
    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }

  Future<void> sendMessage({
    required String chatRoomId,
    required String currentUserId,
    required String otherUserId,
    required String text,
  }) async {
    final message = {
      'senderId': currentUserId,
      'receiverId': otherUserId,
      'text': text.trim(),
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    };

    final chatRoomRef = _firestore.collection('chat_rooms').doc(chatRoomId);
    
    await chatRoomRef.set({
      'participants': FieldValue.arrayUnion([currentUserId, otherUserId])
    }, SetOptions(merge: true));
   
    await chatRoomRef.collection('messages').add(message);
  }  
  
  Stream<QuerySnapshot> getChatRoomsStream(String currentUserId) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: currentUserId)
        .snapshots();
  }
}
