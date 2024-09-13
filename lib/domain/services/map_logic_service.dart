import 'package:flutter_map_math/flutter_geo_math.dart';
import 'package:geocoding/geocoding.dart';

class MapLogicService {
  
  String calculateRoute(Location userLocation, Location petPostLocation) {
    double distance = FlutterMapMath().distanceBetween(
      userLocation.latitude,
      userLocation.longitude,
      petPostLocation.latitude,
      petPostLocation.longitude,
      "meters",
    );
    return distance.toStringAsFixed(0);
  }   

  Future<Location?> getLocationFromAddress(String address) async {
    final locations = await locationFromAddress(address);
    return locations.isNotEmpty ? locations.first : null;
  }
}
