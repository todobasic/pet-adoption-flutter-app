import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/data/providers/pet_post_repository_provider.dart';

final petPostsStreamProvider = StreamProvider<List<PetPostModel>>((ref) {
  final petRepository = ref.watch(petPostRepositoryProvider);
  return petRepository.getPetPosts();
});