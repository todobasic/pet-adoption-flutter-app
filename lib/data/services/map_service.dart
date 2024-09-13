import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';

final mapServiceProvider = Provider((ref) => MapService(ref));

class MapService {  

  MapService(ProviderRef<Object?> ref);

  Future<Set<Marker>> createMarkers({
    required Location userLocation,
    required List<PetPostModel> petPosts,
    required void Function(PetPostModel, Location, Location) onMarkerTap,
  }) async {
    final markers = <Marker>{};

    markers.add(
      Marker(
        markerId: const MarkerId('userLocation'),
        position: LatLng(userLocation.latitude, userLocation.longitude),
        infoWindow: const InfoWindow(title: 'Your Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    );
    
    await Future.wait(
      petPosts.where((petPost) => petPost.petAddress.isNotEmpty).map((petPost) async {
        final petLocations = await locationFromAddress(petPost.petAddress);
        if (petLocations.isNotEmpty) {
          final petLocation = petLocations.first;
          markers.add(
            Marker(
              markerId: MarkerId(petPost.postId),
              position: LatLng(petLocation.latitude, petLocation.longitude),
              infoWindow: InfoWindow(title: petPost.name),
              icon: BitmapDescriptor.defaultMarker,
              onTap: () => onMarkerTap(petPost, userLocation, petLocation),
            ),
          );
        }
      }),
    );
    return markers;
  }  
}

