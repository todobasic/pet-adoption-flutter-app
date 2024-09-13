import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

Future<LatLng?> fetchLocationFromAddress(String address) async {
  try {
    final locations = await locationFromAddress(address);
    if (locations.isNotEmpty) {
      return LatLng(locations.first.latitude, locations.first.longitude);
    }
  } catch (e) {
    print('Error fetching location: $e');
  }
  return null;
}

Future<LatLng?> getCoordinatesFromAddress(String address) async {
  try {
    // Attempt to get the list of locations from the address
    List<Location> locations = await locationFromAddress(address);

    // If locations are found, return the first one as a LatLng object
    if (locations.isNotEmpty) {
      final location = locations.first;
      return LatLng(location.latitude, location.longitude);
    } else {
      return null;
    }
  } catch (e) {
    // If there's an error (e.g., address not found), print the error and return null
    print('Error in getting coordinates from address: $e');
    return null;
  }
}
