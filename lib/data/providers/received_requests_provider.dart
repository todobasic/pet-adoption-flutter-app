import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

final receivedRequestsProvider = StreamProvider.autoDispose<List<AdoptionRequestModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
    .collection('adoption_requests')
    .where('postOwnerId', isEqualTo: user.uid)
    .where('status', isEqualTo: 'pending')
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => AdoptionRequestModel.fromMap(doc.data()))
    .toList());
});


final pendingRequestsCounterProvider = StreamProvider.autoDispose<int>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return const Stream.empty();
  }

  final query = FirebaseFirestore.instance
    .collection('adoption_requests')
    .where('postOwnerId', isEqualTo: user.uid)
    .where('status', isEqualTo: 'pending');

  return query.snapshots().map((snapshot) => snapshot.docs.length);
});
