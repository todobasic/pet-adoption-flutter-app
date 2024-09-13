import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final userStreamProvider = StreamProvider.autoDispose<QuerySnapshot>((ref) {
  return FirebaseFirestore.instance.collection('users').snapshots();
});
