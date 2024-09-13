import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';

final containerVisibleProvider = StateProvider<bool>((ref) => false);

final calculatedDistanceProvider = StateProvider<String?>((ref) => null);

final selectedPetProvider = StateProvider<PetPostModel?>((ref) => null);

final searchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

final newSearchQueryProvider = StateProvider.autoDispose<String>((ref) => ''); // Novo

final checkBoxProvider = StateProvider.autoDispose<bool>((ref) => true);

final indexBottomNavbarProvider = StateProvider<int>((ref) {
  return 0;
});
