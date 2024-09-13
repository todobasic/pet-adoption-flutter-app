import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

final unreadMessagesCountProvider = StreamProvider<int>((ref) {
  final currentUserId = ref.watch(authStateProvider).value?.uid;

  if (currentUserId == null) {
    return const Stream.empty();
  }

  return FirebaseFirestore.instance
      .collection('chat_rooms')
      .where('participants', arrayContains: currentUserId)
      .snapshots()
      .asyncMap((snapshot) async {
    final futures = snapshot.docs.map((doc) async {
      final chatRoomId = doc.id;

      final unreadMessagesQuery = FirebaseFirestore.instance
          .collection('chat_rooms')
          .doc(chatRoomId)
          .collection('messages')
          .where('receiverId', isEqualTo: currentUserId)
          .where('isRead', isEqualTo: false);

      final unreadMessages = await unreadMessagesQuery.get();

      return unreadMessages.docs.length;
    });

    final countsList = await Future.wait(futures);
    return countsList.fold<int>(0, (a, b) => a + b);
  });
});
