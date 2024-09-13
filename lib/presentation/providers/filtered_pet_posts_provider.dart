import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/presentation/providers/check_box_filtered_provider.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';

final filteredPetPostsProvider = Provider.autoDispose<List<PetPostModel>>((ref) {
  final searchQuery = ref.watch(searchQueryProvider);
  final checkBoxList = ref.watch(checkBoxFilteredProvider);

  final newSearchQuery = ref.watch(newSearchQueryProvider); 

  if (searchQuery.isEmpty && newSearchQuery.isEmpty) {
    return checkBoxList;
  } else {
    final filteredByBreed = checkBoxList.where((petPost) {
      return searchQuery.isEmpty || petPost.breed.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    final filteredByAddress = filteredByBreed.where((petPost) {
      return newSearchQuery.isEmpty || petPost.petAddress.toLowerCase().contains(newSearchQuery.toLowerCase());
    }).toList();

    return filteredByAddress;
  }
});