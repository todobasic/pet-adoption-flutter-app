import 'package:flutter/material.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/providers/user_info_provider.dart';

class PetDetailsHeader extends ConsumerWidget {
  final PetPostModel petPost;
  final String currentUserId;

  const PetDetailsHeader({
    super.key,
    required this.petPost,
    required this.currentUserId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postOwnerInfo = ref.watch(userInfoProvider(petPost.userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Breed: ${petPost.breed}', style: const TextStyle(fontSize: 18)),
        Text('Weight: ${petPost.weight} kg', style: const TextStyle(fontSize: 18)),
        Text('Age: ${petPost.age} years', style: const TextStyle(fontSize: 18)),
        Text('Location: ${petPost.petAddress}', style: const TextStyle(fontSize: 18)),
        postOwnerInfo.when(
          data: (ownerData) {
            if (ownerData == null) return const SizedBox();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 40.0, 0),
                  child: Text('Posted by: ${ownerData['name']} ${ownerData['surname']}', style: const TextStyle(fontSize: 18), textAlign: TextAlign.left),
                ),
                Text("Owner's phone details: ${ownerData['phone']}", style: const TextStyle(fontSize: 18)),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Text('Error loading owner info: $error'),
        ),
      ],
    );
  }
}
