import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/repositories/recommendation_repository.dart';

final recommendedPostsProvider = FutureProvider.family<List<PetPostModel>, List<String>>((ref, likedPostIds) async {
  final recommendationRepository = RecommendationRepository();
  final userId = ref.watch(authStateProvider).value!.uid;
  final recommendations = await recommendationRepository.fetchRecommendedPosts(userId, likedPostIds);

  return recommendations;
});
