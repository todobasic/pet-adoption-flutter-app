import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/firebase_provider.dart';
import 'package:pet_adoption/data/repositories/user_repository.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final firestore = ref.watch(firebaseFirestoreProvider);
  return UserRepository(firestore);
});