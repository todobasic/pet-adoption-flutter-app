import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/repositories/pet_post_repository.dart';
import 'package:pet_adoption/domain/providers/firebase_provider.dart';

final petPostRepositoryProvider = Provider<PetPostRepository>((ref){
  final firestore = ref.watch(firebaseFirestoreProvider);
  return PetPostRepository(firestore);
});