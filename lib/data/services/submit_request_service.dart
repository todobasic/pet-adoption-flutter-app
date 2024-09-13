import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pet_adoption/data/models/adoption_request_model.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';

Future<void> submitAdoptionRequest(PetPostModel petPost) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final petPostSnapshot = await FirebaseFirestore.instance
      .collection('pet_posts')
      .doc(petPost.postId)
      .get();

  if (!petPostSnapshot.exists) {
    return;
  }

  final petPostData = petPostSnapshot.data();
  final postOwnerId = petPostData?['userId'];
  final petName = petPostData?['name'];

  final userDoc = await FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .get();

  final requesterName = userDoc.data()?['name'];

  final request = AdoptionRequestModel(
    requestId: FirebaseFirestore.instance.collection('adoption_requests').doc().id,
    postId: petPost.postId,
    requesterId: user.uid,
    requesterName: requesterName ?? 'Unknown',
    petName: petName ?? 'Unknown',
    message: 'I am interested in adopting this pet.',
    requestDate: DateTime.now(),
    status: 'pending',
    postOwnerId: postOwnerId ?? 'Unknown',
  );

  await FirebaseFirestore.instance.collection('adoption_requests').doc(request.requestId).set(request.toMap());
}
