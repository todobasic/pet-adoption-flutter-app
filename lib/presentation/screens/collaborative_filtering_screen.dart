import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/data/repositories/recommendation_repository.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';
import 'package:pet_adoption/presentation/widgets/recommendation_list_item.dart';

class CollaborativeFilteringScreen extends ConsumerWidget {
  const CollaborativeFilteringScreen({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Collaborative Method'),
      ),
      drawer: const CustomDrawer(), 
      body: authState.when(
        data: (authUser) {
          final currentUserId = authUser!.uid;

          return FutureBuilder<List<PetPostModel>>(
            future: _getCollaborativeRecommendations(currentUserId), 
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }

              final recommendedPosts = snapshot.data ?? [];
              if (recommendedPosts.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('No recommendations available.'),
                      Text('Try liking some posts or check back later.'),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: recommendedPosts.length,
                itemBuilder: (context, index) {
                  final petPost = recommendedPosts[index];
                  return RecommendationListItem(petPost: petPost);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );

  }

  Future<List<PetPostModel>> _getCollaborativeRecommendations(String userId) async {
    final recommendationRepo = RecommendationRepository();

    // Fetch the list of pets the user liked
    List<String> likedPosts = await recommendationRepo.getUserLikedPosts(userId);
    print('Liked Posts: $likedPosts'); 
    // Find similar users
    List<String> similarUsers = await recommendationRepo.getSimilarUsers(userId, likedPosts);
    print('Similar Users: $similarUsers'); 
    // Get posts liked by those users
    List<PetPostModel> recommendedCollabPosts = await recommendationRepo.getCollabRecommendedPosts(similarUsers, likedPosts);
    print('Recommended Posts: $recommendedCollabPosts'); 

    return recommendedCollabPosts;
  }
}
