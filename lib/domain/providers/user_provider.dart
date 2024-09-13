import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/user_model.dart';
import 'package:pet_adoption/data/providers/user_repository_provider.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

final userProvider = FutureProvider<UserModel?>((ref) async {
  final loggedUser = ref.watch(authStateProvider).asData?.value;

  if (loggedUser==null) {
    return null;
  }

  final userRepository = ref.read(userRepositoryProvider);
  return userRepository.fetchCurrentUser();

});

final userModelProvider = StreamProvider.autoDispose<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);

  return authState.when(
    data: (user) {
      if (user != null) {
        final userRepository = ref.watch(userRepositoryProvider);
        return userRepository.userStream(user.uid);
      } else {
        return Stream.value(null);
      }
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});