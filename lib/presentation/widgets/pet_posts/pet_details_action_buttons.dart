import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/data/services/location_from_address_provider.dart';
import 'package:pet_adoption/data/services/submit_request_service.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';
import 'package:pet_adoption/presentation/screens/map_screen.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PetActionButtons extends ConsumerWidget {
  final PetPostModel petPost;
  final String currentUserId;
  final bool hasAlreadyRequested;
  final Location? petLocation;

  const PetActionButtons({
    super.key,
    required this.petPost,
    required this.currentUserId,
    required this.hasAlreadyRequested,
    this.petLocation,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedPetPostLocation = ref.watch(locationFromAddressProvider(petPost.petAddress));
    final isOwner = currentUserId == petPost.userId;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: petPost.isAdopted || hasAlreadyRequested || isOwner
                ? null
                : () {
                    submitAdoptionRequest(petPost);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Adoption request submitted.')),
                    );
                  },
            child: hasAlreadyRequested ? const Text('Already Requested') : const Text('Request Adoption'),
          ),
        ),
        const SizedBox(width: 20.0),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              ref.read(selectedPetProvider.notifier).state = petPost;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => selectedPetPostLocation.when(
                    data: (location) => MapScreen(
                      initialPosition: location ?? const LatLng(0, 0),
                    ),
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) => Center(child: Text('Error: $error')),
                  ),
                ),
              );
            },
            child: const Text('Show on Map'),
          ),
        ),
      ],
    );
  }  
}
