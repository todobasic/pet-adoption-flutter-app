import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userInfoProvider = FutureProvider.family<Map<String, dynamic>?, String>((ref, userId) async {
  final firestore = FirebaseFirestore.instance;
  final userDoc = await firestore.collection('users').doc(userId).get();
  return userDoc.data();
});
