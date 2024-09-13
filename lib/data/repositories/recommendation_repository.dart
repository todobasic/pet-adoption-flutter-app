
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';

class RecommendationRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<PetPostModel>> fetchRecommendedPosts(String userId, List<String> likedPostIds) async {
    final List<PetPostModel> recommendedPosts = [];
    const double similarityThreshold = 0.6;

    for(String likedPostId in likedPostIds) {
      final querySnapshot = await _firestore
        .collection('similarities')
        .where('postIdA', isEqualTo: likedPostId)
        .where('similarityScore', isGreaterThan: similarityThreshold)
        .orderBy('similarityScore', descending: true)
        .limit(10)
        .get();

      for (var doc in querySnapshot.docs) {
        final data = doc.data();
        final postIdB = data['postIdB'];

        if (!likedPostIds.contains(postIdB)) {
          final postSnapshot = await _firestore.collection('pet_posts').doc(postIdB).get();
          final postData = postSnapshot.data();

          recommendedPosts.add(PetPostModel(
            postId: postSnapshot.id,
            userId: postData!['userId'],
            isAdopted: postData['isAdopted'],
            name: postData['name'],
            age: postData['age'],
            weight: postData['weight'],
            breed: postData['breed'],
            imageUrl: postData['imageUrl'],
            type: postData['type'], 
            petAddress: postData['petAddress'],            
          ));
        }
      }
    }
    return recommendedPosts;
  }


}