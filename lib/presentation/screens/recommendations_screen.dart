import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/providers/user_likes_provider.dart';
import 'package:pet_adoption/domain/providers/recommendation_provider.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';
import 'package:pet_adoption/presentation/widgets/recommendation_list_item.dart';

class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userIdAsyncValue = ref.watch(authStateProvider);
    final likedPostsAsyncValue = ref.watch(userLikesProvider(userIdAsyncValue.value?.uid ?? ''));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommended for you'),
      ),
      drawer: const CustomDrawer(),
      body: likedPostsAsyncValue.when(
        data: (likedPostIds) {
          final recommendedPostsAsyncValue = ref.watch(recommendedPostsProvider(likedPostIds));
          return recommendedPostsAsyncValue.when(
            data: (recommendedPosts) {
              if (recommendedPosts.isEmpty) {
                return const Center(child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('No recommendations available for you.'),
                    Text('Try liking some posts.'),
                  ],
                ));
              }
              return ListView.builder(
                itemCount: recommendedPosts.length,
                itemBuilder: (context, index) {
                  final petPost = recommendedPosts[index];
                  return RecommendationListItem(petPost: petPost);
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
