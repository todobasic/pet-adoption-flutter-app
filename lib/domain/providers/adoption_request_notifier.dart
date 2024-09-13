import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';
import 'package:pet_adoption/data/repositories/adoption_request_repository.dart';
import 'package:pet_adoption/domain/providers/firebase_provider.dart';

final adoptionRequestRepositoryProvider = Provider<AdoptionRequestRepository>((ref){
  final firestore = ref.watch(firebaseFirestoreProvider);
  return AdoptionRequestRepository(firestore);
});

class AdoptionRequestNotifier extends StateNotifier<List<AdoptionRequestModel>> {
  final FirebaseFirestore _firestore;

  AdoptionRequestNotifier(this._firestore) : super([]);

  

  Future<void> updateRequestStatus(String requestId, String status) async {
    await _firestore.collection('adoption_requests').doc(requestId).update({'status': status});
    state = state.where((request) => request.requestId != requestId).toList();
  }

}

final adoptionRequestNotifierProvider = StateNotifierProvider<AdoptionRequestNotifier, List<AdoptionRequestModel>>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return AdoptionRequestNotifier(firestore);
});