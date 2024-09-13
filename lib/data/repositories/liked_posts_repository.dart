import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/data/repositories/similarity_repository.dart';

class LikedPostsRepository {
  final FirebaseFirestore _firestore;
  final SimilarityRepository _similarityRepository;

  LikedPostsRepository({FirebaseFirestore? firestore, SimilarityRepository? similarityRepository})
      : _firestore = firestore ?? FirebaseFirestore.instance,
      _similarityRepository = similarityRepository ?? SimilarityRepository();

  Future<void> likePost(String userId, String postId) async {
    final userLikesRef = _firestore
        .collection('user_likes')
        .doc(userId)
        .collection('liked_posts')
        .doc(postId);

    await userLikesRef.set({
      'likedAt': FieldValue.serverTimestamp(),
      'postId' : postId,
    });

    final petPostsSnapshot = await _firestore.collection('pet_posts').get();
    final petPosts = petPostsSnapshot.docs.map((doc) {
      final data = doc.data();
      return PetPostModel(
        postId: doc.id,
        userId: data['userId'],
        isAdopted: data['isAdopted'],
        name: data['name'],
        age: data['age'],
        weight: data['weight'],
        breed: data['breed'],
        imageUrl: data['imageUrl'],
        type: data['type'],
        petAddress: data['petAddress'],
      );
    }).toList();

    await _similarityRepository.computeAndStoreSimilarities(petPosts);
  }

  Future<void> unlikePost(String userId, String postId) async {
    final userLikesRef = _firestore
        .collection('user_likes')
        .doc(userId)
        .collection('liked_posts')
        .doc(postId);

    await userLikesRef.delete();

    final postRef = _firestore.collection('pet_posts').doc(postId);
    await postRef.update({
      'likeCount': FieldValue.increment(-1),
    });
  }

  Future<bool> hasUserLikedPost(String userId, String postId) async {
    final userLikesRef = _firestore
        .collection('user_likes')
        .doc(userId)
        .collection('liked_posts')
        .doc(postId);

    final doc = await userLikesRef.get();
    print('REZULTAT NOTIFIERA FUNKCIJE HASUSERLIKEDPOST: ${doc.exists}');
    return doc.exists;
  }
}
