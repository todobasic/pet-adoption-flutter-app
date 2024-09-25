
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

  Future<Map<String, dynamic>> getPetPostDetails(String petId) async {
    DocumentSnapshot petSnapshot = await FirebaseFirestore.instance.collection('pet_posts').doc(petId).get();
    
    if (!petSnapshot.exists) {
    print('Post $petId not found');  // Debugging
    return {};
    } if (petSnapshot.exists) {
      print('Post $petId found');
    }
    
    return petSnapshot.data() as Map<String, dynamic>;
  }

  Future<List<String>> getUserLikedPosts(String userId) async {
    // Reference to the liked_posts sub-collection
    CollectionReference likedPostsRef = FirebaseFirestore.instance
        .collection('user_likes')
        .doc(userId)
        .collection('liked_posts');

    // Fetch all documents from the liked_posts sub-collection
    QuerySnapshot likedPostsSnapshot = await likedPostsRef.get();

    // Extract the petPostIds from the documents
    List<String> likedPosts = likedPostsSnapshot.docs.map((doc) => doc.id).toList();

    if (likedPosts.isEmpty) {
      print('No liked posts for user $userId');
    } else {
      print('Likes found for user $userId: $likedPosts'); // Debugging
    }
    return likedPosts;
  }


  Future<List<String>> getSimilarUsers(String currentUserId, List<String> currentUserLikes) async {
    QuerySnapshot userSnapshots = await FirebaseFirestore.instance.collection('user_likes').get();
    List<String> similarUsers = [];

    for (var doc in userSnapshots.docs) {
      if (doc.id != currentUserId) {
        // Access the liked_posts sub-collection of the other users
        QuerySnapshot otherUserLikesSnapshot = await FirebaseFirestore.instance
            .collection('user_likes')
            .doc(doc.id)
            .collection('liked_posts')
            .get();

        List<String> otherUserLikes = otherUserLikesSnapshot.docs.map((doc) => doc.id).toList();
        
        print('Other user ${doc.id} likes: $otherUserLikes');
        print('Current user $currentUserId likes: $currentUserLikes');

        if (otherUserLikes.any((petId) => currentUserLikes.contains(petId))) {
          similarUsers.add(doc.id);
        }
      }
    }
    print('Similar users are: $similarUsers');
    return similarUsers;
  }


  Future<List<PetPostModel>> getCollabRecommendedPosts(List<String> similarUsers, List<String> currentUserLikes) async {
    Set<String> recommendedPostIds = {};

    for (String userId in similarUsers) {
      // Access the liked_posts sub-collection for each similar user
      QuerySnapshot userLikesSnapshot = await FirebaseFirestore.instance
          .collection('user_likes')
          .doc(userId)
          .collection('liked_posts')
          .get();

      List<String> likedPosts = userLikesSnapshot.docs.map((doc) => doc.id).toList();

      for (var postId in likedPosts) {
        if (!currentUserLikes.contains(postId)) {
          recommendedPostIds.add(postId);
        }
      }
    }

    // Fetch the PetPostModel instances for the recommended post IDs
    List<PetPostModel> recommendedPosts = [];
    for (String postId in recommendedPostIds) {
      DocumentSnapshot postSnapshot = await FirebaseFirestore.instance.collection('pet_posts').doc(postId).get();
      if (postSnapshot.exists) {
        final data = postSnapshot.data() as Map<String, dynamic>;
        recommendedPosts.add(PetPostModel(
          postId: postId,
          userId: data['userId'],
          isAdopted: data['isAdopted'],
          name: data['name'],
          age: data['age'],
          weight: data['weight'],
          breed: data['breed'],
          imageUrl: data['imageUrl'],
          type: data['type'],
          petAddress: data['petAddress'],
        ));
      }
    }

    return recommendedPosts;
  }

  Future<List<PetPostModel>> getCollaborativeRecommendations(String userId) async {
    final recommendationRepo = RecommendationRepository();

    // Fetch the list of pets the user liked
    List<String> likedPosts = await recommendationRepo.getUserLikedPosts(userId);
    print('Liked Posts: $likedPosts'); // Debugging
    // Find similar users
    List<String> similarUsers = await recommendationRepo.getSimilarUsers(userId, likedPosts);
    print('Similar Users: $similarUsers'); // Debugging
    // Get posts liked by those users
    List<PetPostModel> recommendedCollabPosts = await recommendationRepo.getCollabRecommendedPosts(similarUsers, likedPosts);
    print('Recommended Posts: $recommendedCollabPosts'); // Debugging

    return recommendedCollabPosts;
  }


}