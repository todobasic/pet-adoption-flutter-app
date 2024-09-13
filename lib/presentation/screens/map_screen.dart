import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';
import 'package:pet_adoption/data/services/map_service.dart';
import 'package:pet_adoption/domain/services/map_logic_service.dart';
import 'package:pet_adoption/presentation/providers/distance_container_provider.dart';
import 'package:pet_adoption/presentation/providers/markers_provider.dart';
import 'package:pet_adoption/presentation/providers/polyline_provider.dart';
import 'package:pet_adoption/presentation/providers/ui_state_providers.dart';
import 'package:pet_adoption/domain/providers/user_provider.dart';
import 'package:pet_adoption/presentation/screens/pet_details_screen.dart';
import 'package:pet_adoption/presentation/widgets/custom_drawer.dart';
import 'package:pet_adoption/presentation/widgets/distance_container.dart';

class MapScreen extends ConsumerStatefulWidget {
  final LatLng? initialPosition;

  const MapScreen({super.key, this.initialPosition});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  late GoogleMapController _mapController;
  final Set<Marker> _markers = {};
  final Set<Polyline> _polylines = {};
  LatLng? initialPosition;
  MapLogicService mapLogicService = MapLogicService();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(distanceContainerProvider.notifier).hideContainer();
      ref.read(selectedPetProvider.notifier).state = null;
      ref.read(polylineProvider.notifier).clearPolyline();  
    }); 
  }  

  Future<void> _loadMarkers() async {
    try {
      final mapService = ref.read(mapServiceProvider);
      final markersData = await ref.read(markersProvider.future);
      final userLocation = markersData['userLocation'] as Location?;
      final petPosts = markersData['petPosts'];
      List<PetPostModel> petPostsList = [];

      if (petPosts is List<PetPostModel>) {
        petPostsList = petPosts;
      } else if (petPosts != null) {
        throw TypeError();
      }
      if (userLocation == null || petPostsList.isEmpty) {
        return;   
      }

      print('KORISNIKOVA LOKACIJA  $userLocation'); 

    final markers = await mapService.createMarkers(
      userLocation: userLocation,
      petPosts: petPosts,
      onMarkerTap: (petPost, userLoc, petLoc) {
        ref.read(selectedPetProvider.notifier).state = petPost;
        _showPetDetailsModal(context, petPost, userLoc, petLoc);
      },
    );
    setState(() {
      _markers.clear();
      _markers.addAll(markers);
    });
    LatLng targetPosition = widget.initialPosition ??
        LatLng(userLocation.latitude, userLocation.longitude);
    _mapController.animateCamera(
      CameraUpdate.newLatLngZoom(targetPosition, 15.0),
    );
    } catch (e) {
      print('Error in _loadMarkers: $e');
    }    
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final userAsyncValue = ref.watch(userProvider);
        return userAsyncValue.when(
          data: (userModel) {          
            return Scaffold(
              appBar: AppBar(title: const Text("Map Screen")),
              drawer: const CustomDrawer(),
              body: Stack(
                children: [
                  GoogleMap(
                    onMapCreated: (controller) {
                      _mapController = controller;
                      _loadMarkers();
                    },
                    initialCameraPosition: CameraPosition(
                      target: widget.initialPosition ?? const LatLng(0, 0),
                      zoom: 12.0,
                    ),
                    markers: _markers,
                    polylines: _polylines,
                  ),
                  const DistanceContainer(),
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) => Center(child: Text('Error: $e')),
        );
      },
    );
  }

  void _showPetDetailsModal(BuildContext context, PetPostModel petPost, Location userLocation, Location petLocation) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          width: 500,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.network(petPost.imageUrl, height: 100, width: 100, fit: BoxFit.cover),
                ),
                const SizedBox(height: 8),
                Text(
                  petPost.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 20.0,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => PetDetailsScreen(petPost: petPost)),
                        );
                      },
                      child: const Text('View Details'),
                    ),
                    const SizedBox(width: 15.0),
                    ElevatedButton(
                      onPressed: () async {
                        await showRoute(context, userLocation, petLocation);
                        String distance = mapLogicService.calculateRoute(userLocation, petLocation);
                        ref.read(distanceContainerProvider.notifier).showContainer(petPost, distance);
                        if (context.mounted) Navigator.pop(context);
                      },
                      child: const Text('Get Route'),
                    ),
                    const SizedBox(width: 15.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> showRoute(BuildContext context, Location userLocation, Location petLocation) async {
    final routePoints = await ref.read(polylineProvider.notifier).getRoutePoints(
      LatLng(userLocation.latitude, userLocation.longitude),
      LatLng(petLocation.latitude, petLocation.longitude),
    );

    final polyline = Polyline(
      polylineId: const PolylineId("route"),
      points: routePoints,
      color: Colors.blue,
      width: 5,
    );

    setState(() {
      _polylines.add(polyline);
    });
  }
}
