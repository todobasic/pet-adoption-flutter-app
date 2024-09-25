import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/data/repositories/recommendation_repository.dart';

final collaborativeRecommendationsProvider =
    FutureProvider.family<List<PetPostModel>, String>((ref, userId) async {
  final recommendationRepo = RecommendationRepository();
  final recommendations = await recommendationRepo.getCollaborativeRecommendations(userId);
  return recommendations;
});
