import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/utils/location_service.dart';
import 'package:pet_adoption/domain/providers/user_provider.dart';
import 'package:pet_adoption/presentation/screens/create_post_screen.dart';
import 'package:pet_adoption/presentation/screens/map_screen.dart';

class ExpandableFloatingActionButton extends StatefulHookConsumerWidget {
  const ExpandableFloatingActionButton({super.key});

  @override
  ConsumerState<ExpandableFloatingActionButton> createState() => _ExpandableFloatingActionButtonState();
}

class _ExpandableFloatingActionButtonState extends ConsumerState<ExpandableFloatingActionButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );     
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Future<void> _openMap(BuildContext context) async {
    // Get the user's model from the userProvider
    final userModel = ref.read(userProvider).value;

    // Fetch user's coordinates if userModel is not null
    LatLng? userCoordinates;
    if (userModel != null) {
      userCoordinates = await getCoordinatesFromAddress(userModel.address);
    }

    // Navigate to MapScreen with initialPosition set to user's coordinates
    if(context.mounted) {
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => MapScreen(
          initialPosition: userCoordinates,
        ),
      ),
    );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Open Map Button with Label
              SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeOut,
                ),
                axisAlignment: 1.0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('Open map'),
                    onPressed: () async {
                      _animationController.reverse();
                      await _openMap(context);
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4.0,
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                ),
              ),
              // Create New Post Button with Label
              SizeTransition(
                sizeFactor: CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeOut,
                ),
                axisAlignment: 1.0,
                child: Container(
                  margin: const EdgeInsets.only(bottom: 8.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Create post'),
                    onPressed: () {
                      _animationController.reverse();
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const CreatePostScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 4.0,
                      backgroundColor: Colors.grey[200],
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    ),
                  ),
                ),
              ),
              // Main FloatingActionButton
              FloatingActionButton(
                onPressed: _toggleExpand,
                backgroundColor: Colors.grey[300],
                child: Icon(_isExpanded ? Icons.close : Icons.create_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
