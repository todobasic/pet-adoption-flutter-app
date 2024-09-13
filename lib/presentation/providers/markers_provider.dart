import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/providers/user_repository_provider.dart';
import 'package:pet_adoption/presentation/providers/pet_posts_provider.dart';

final markersProvider = FutureProvider.autoDispose<Map<String, dynamic>>((ref) async {
  final loggedUser = ref.watch(authRepositoryProvider).currentUser;

  if (loggedUser == null) {
    return <String, dynamic>{};
  }

  final user = await ref.watch(userRepositoryProvider).getUserProfile(loggedUser.uid);
  final petPosts = await ref.watch(petPostsStreamProvider.future);

  final data = <String, dynamic>{};

  print('ADRESA KORISNIKA: ${user!.address} ');

  if (user.address.isNotEmpty) {
    final userLocations = await locationFromAddress(user.address);
    if (userLocations.isNotEmpty) {
      final userLocation = userLocations.first;
      data['userLocation'] = userLocation;
    }
  }

  data['petPosts'] = petPosts;

  return data;
});