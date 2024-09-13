import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

final userRequestsForPetProvider = StreamProvider.family<List<AdoptionRequestModel>, String>((ref, petPostId) {
  final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid;
  if (currentUserId == null) {
    return Stream.value([]);
  }

  final firestore = FirebaseFirestore.instance;

  return firestore
    .collection('adoption_requests')
    .where('postId', isEqualTo: petPostId)
    .where('requesterId', isEqualTo: currentUserId)
    .snapshots()
    .map((snapshot) => snapshot.docs.map((doc) => AdoptionRequestModel.fromFirestore(doc)).toList());
});