import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pet_adoption/utils/constants.dart';

final polylineProvider = StateNotifierProvider<PolylineNotifier, Set<Polyline>>((ref) {
  return PolylineNotifier();
});

class PolylineNotifier extends StateNotifier<Set<Polyline>> {
  PolylineNotifier() : super({});

  final String googleApiKey = API_KEY;

  void addPolyline(Polyline polyline) {
    state = {...state, polyline};
  }

  void setPolyline(Set<Polyline> polyline) {
    state = polyline;
  }

  void clearPolyline() {
    state = {};
  }

  Future<List<LatLng>> getRoutePoints(LatLng origin, LatLng destination) async {
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
    googleApiKey: googleApiKey,
    request: PolylineRequest(
      origin: PointLatLng(origin.latitude, origin.longitude),
      destination: PointLatLng(destination.latitude, destination.longitude),
      mode: TravelMode.driving,
    ),
  );

    if (result.points.isNotEmpty) {
      return result.points.map((point) => LatLng(point.latitude, point.longitude)).toList();
    } else {
      return [];
    }
  }

}
