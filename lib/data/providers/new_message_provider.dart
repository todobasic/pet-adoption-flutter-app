import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

final newMessagesProvider = StreamProvider.family<bool, String>((ref, otherUserId) {
  final currentUserId = ref.watch(authStateProvider).value?.uid;

  if (currentUserId == null) {
    return const Stream.empty();
  }

  final chatRoomId = currentUserId.compareTo(otherUserId) > 0
      ? '${currentUserId}_$otherUserId'
      : '${otherUserId}_$currentUserId';

  final unreadMessagesStream = FirebaseFirestore.instance
      .collection('chat_rooms')
      .doc(chatRoomId)
      .collection('messages')
      .where('receiverId', isEqualTo: currentUserId)
      .where('isRead', isEqualTo: false)
      .snapshots();

  return unreadMessagesStream.map((snapshot) => snapshot.docs.isNotEmpty);
});
