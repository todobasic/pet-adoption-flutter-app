import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/providers/user_repository_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Future<void> completeUserProfile(
  WidgetRef ref,
  String name,
  String surname,
  String address,
  String phone,
  String favoritePetType,
  String favoriteBreed,
) async {
  final user = ref.read(authRepositoryProvider).currentUser;
  if (user != null) {
    await ref.read(userRepositoryProvider).completeUserProfile(
      user.uid,
      user.email,
      name,
      surname,
      address,
      phone,
      favoritePetType,
      favoriteBreed,
    );
  }
}
