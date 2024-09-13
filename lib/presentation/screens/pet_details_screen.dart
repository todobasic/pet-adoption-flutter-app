import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';
import 'package:pet_adoption/data/providers/user_request_for_pet_post_provider.dart';
import 'package:pet_adoption/presentation/widgets/pet_posts/pet_details_action_buttons.dart';
import 'package:pet_adoption/presentation/widgets/pet_posts/pet_details_header.dart';

class PetDetailsScreen extends ConsumerWidget {
  final PetPostModel petPost;

  const PetDetailsScreen({super.key, required this.petPost});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserId = ref.watch(authRepositoryProvider).currentUser?.uid;
    final userRequestsStream = ref.watch(userRequestsForPetProvider(petPost.postId));    

    return Scaffold(
      appBar: AppBar(title: Text(petPost.name)),
      drawer: const CustomDrawer(),
      body: userRequestsStream.when(
        data: (requests) {
          bool hasAlreadyRequested = requests.any(
            (request) => request.requesterId == currentUserId && request.status != 'rejected'
          );
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PetDetailsHeader(
                  petPost: petPost,
                  currentUserId: currentUserId ?? '',
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.network(
                    petPost.imageUrl,
                    height: 200.0,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 20),
                PetActionButtons(
                  petPost: petPost,
                  currentUserId: currentUserId ?? '',
                  hasAlreadyRequested: hasAlreadyRequested,
                ),
                if (petPost.isAdopted) const Center(child: Text(
                  'This pet has already been adopted',
                  style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                )),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => const Center(child: Text('Error loading data')),
      ),
    );
  }
}
