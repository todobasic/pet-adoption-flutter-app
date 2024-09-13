import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/liked_post_notifier.dart';
import 'package:pet_adoption/data/providers/user_likes_provider.dart';
import 'package:pet_adoption/presentation/screens/pet_details_screen.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';

class PetPostCard extends ConsumerWidget {
  final PetPostModel petPost;
  final String userId;

  const PetPostCard({required this.petPost, required this.userId, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(likedPostsProvider(petPost.postId));

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (petPost.imageUrl.isNotEmpty)
            Image.network(
              petPost.imageUrl,
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  petPost.name,
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text('Breed: ${petPost.breed}'),
                Text('Weight: ${petPost.weight}'),
                Text('Age: ${petPost.age}'),
                if (petPost.isAdopted)
                  const Text(
                    'Already Adopted',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 8.0),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color: isLiked ? Colors.red : null,
                        ),
                        onPressed: () {
                          if (isLiked) {
                            ref
                              .read(likedPostsProvider(petPost.postId).notifier)
                              .unlikePost();
                          } else {
                            ref
                              .read(likedPostsProvider(petPost.postId).notifier)
                              .likePost();
                          }
                          ref.invalidate(userLikesProvider(userId)); 
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PetDetailsScreen(petPost: petPost),
                            ),
                          );
                        },
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
