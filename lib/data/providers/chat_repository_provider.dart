import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption/data/repositories/chat_repository.dart';

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepository(FirebaseFirestore.instance);
});
