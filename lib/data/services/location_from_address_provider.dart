import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final locationFromAddressProvider = FutureProvider.family<LatLng?, String>((ref, address) async {
  try {
    final locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    }
  } catch (e) {
    print('Error fetching location: $e');
  }
  return null;
});