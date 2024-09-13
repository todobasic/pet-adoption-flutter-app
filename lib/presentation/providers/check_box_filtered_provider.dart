import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/presentation/providers/pet_posts_provider.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';

final checkBoxFilteredProvider = Provider.autoDispose<List<PetPostModel>>((ref) {
  final checkBox = ref.watch(checkBoxProvider);  
  final petPosts = ref.watch(petPostsStreamProvider).value ?? [];

  if (checkBox==true) {
    return petPosts;
  } else {
    return petPosts
      .where((petPost) => petPost.isAdopted==false).toList();
  }
});