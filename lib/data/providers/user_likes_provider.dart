import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userLikesProvider = FutureProvider.family<List<String>, String>((ref, userId) async {
  final firestore = FirebaseFirestore.instance;
  final querySnapshot = await firestore
      .collection('user_likes')
      .doc(userId)
      .collection('liked_posts')
      .get();
  
  return querySnapshot.docs.map((doc) => doc.id).toList();
});
