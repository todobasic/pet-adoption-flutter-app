import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

final unreadMessagesUsersProvider = StreamProvider.autoDispose<List<String>>((ref) {
  final currentUserId = ref.watch(authStateProvider).value?.uid;

  if (currentUserId == null) {
    return Stream.value([]);
  }

  return FirebaseFirestore.instance
      .collection('chat_rooms')
      .where('participants', arrayContains: currentUserId)
      .snapshots()
      .map((snapshot) {
    final unreadUsers = <String>{};

    for (final doc in snapshot.docs) {
      final chatRoomId = doc.id;
      final otherUserId = chatRoomId.split('_').firstWhere((id) => id != currentUserId);

      final unreadMessages = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false)
          .snapshots();

      unreadMessages.forEach((messageSnapshot) {
        if (messageSnapshot.docs.isNotEmpty) {
          unreadUsers.add(otherUserId);
        }
      });
    }

    return unreadUsers.toList();
  });
});
