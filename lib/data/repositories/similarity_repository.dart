import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/domain/services/similarity_service.dart';

class SimilarityRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final SimilarityService _similarityService = SimilarityService();

    Future<void> computeAndStoreSimilarities(List<PetPostModel> petPosts) async {
    for (int i = 0; i < petPosts.length; i++) {
      for (int j = i + 1; j < petPosts.length; j++) {
        double similarityScore = _similarityService.computeSimilarity(petPosts[i], petPosts[j]);

        await _firestore.collection('similarities').doc('${petPosts[i].postId}_${petPosts[j].postId}').set({
          'postIdA': petPosts[i].postId,
          'postIdB': petPosts[j].postId,
          'similarityScore': similarityScore,
        });

        await _firestore.collection('similarities').doc('${petPosts[j].postId}_${petPosts[i].postId}').set({
          'postIdA': petPosts[j].postId,
          'postIdB': petPosts[i].postId,
          'similarityScore': similarityScore,
        });
      }
    }
  }    
}