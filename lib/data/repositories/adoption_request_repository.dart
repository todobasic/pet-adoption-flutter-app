import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';

class AdoptionRequestRepository {
  final FirebaseFirestore _firestore;

  AdoptionRequestRepository(this._firestore);

  Future<void> submitRequest(String postId, String requesterId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final postSnapshot = await _firestore.collection('pet_posts').doc(postId).get();

    if (!postSnapshot.exists) {      
      return;
    }

    final postData = postSnapshot.data();
    final postOwnerId = postSnapshot.data()?['userId'];
    final petName = postData?['name'];

    final userSnapshot = await _firestore.collection('users').doc(requesterId).get();
    final requesterName = userSnapshot.data()?['name'];

    final request = AdoptionRequestModel(
      requestId: FirebaseFirestore.instance.collection('adoption_requests').doc().id,
      postId: postId,
      requesterId: requesterId,
      postOwnerId: postOwnerId,
      requesterName: requesterName ?? 'Unknown', 
    petName: petName ?? 'Unknown', 
      message: 'I am interested in adopting this pet.',
      requestDate: DateTime.now(),
      status: 'pending',
    );

    await _firestore.collection('adoption_requests').doc(request.requestId).set(request.toMap());
   
  }

  Future<void> createAdoptionRequest(AdoptionRequestModel request) async {
    final requestDoc = _firestore.collection('adoption_requests').doc(request.requestId);
    await requestDoc.set(request.toMap());
  }

  Stream<List<AdoptionRequestModel>> getAdoptionRequestsForPost(String postId) {
    return _firestore
    .collection('adoption_requests')
    .where('postId', isEqualTo: postId)
    .snapshots()
    .map((snapshot) => snapshot.docs
    .map((doc) => AdoptionRequestModel.fromMap(doc.data()))
    .toList());
  }

  Future<void> updateAdoptionRequestStatus(String requestId, String status) async {
    final requestDoc = _firestore.collection('adoption_requests').doc(requestId);
    await requestDoc.update({'status': status});
  }

  Future<List<AdoptionRequestModel>> getDecisionHistory(String userId) async {
    final snapshot = await _firestore
    .collection('adoption_requests')
    .where('postOwnerId', isEqualTo: userId)
    .where('status', whereIn: ['accepted', 'rejected'])
    .get();

    return snapshot.docs.map((doc) => AdoptionRequestModel.fromMap(doc.data())).toList();
  }

  Stream<int> getPendingRequestsCountForUser(String? userId) {
    return _firestore
    .collection('adoption_requests')
    .where('postOwnerId', isEqualTo: userId)
    .where('status', isEqualTo: 'pending')
    .snapshots()
    .map((snapshot) => snapshot.docs.length);
  }

}