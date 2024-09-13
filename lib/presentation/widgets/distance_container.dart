import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/presentation/providers/distance_container_provider.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';
import 'package:pet_adoption/presentation/screens/pet_details_screen.dart';

class DistanceContainer extends ConsumerWidget {
  const DistanceContainer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(distanceContainerProvider);
    final selectedPetPost = ref.watch(selectedPetProvider);

    if (!state.isVisible) return const SizedBox.shrink();

    return Positioned(
      top: 16.0,
      left: 16.0,
      right: 16.0,
      child: Container(
        height: 275,
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[400],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                state.petPost?.imageUrl ?? '',
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              state.petPost?.name ?? '',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.normal
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Distance:', 
              style: TextStyle(
                fontSize: 16, 
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('${state.calculatedDistance} meters'),
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [                
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PetDetailsScreen(petPost: selectedPetPost!),
                      ),
                    );
                  },
                  child: const Text('View Details'),
                ),
                ElevatedButton(
                  onPressed: () {
                    ref.read(distanceContainerProvider.notifier).hideContainer();
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
