import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/models/pet_post_model.dart';

class DistanceContainerState {
  final bool isVisible;
  final PetPostModel? petPost;
  final String calculatedDistance;

  DistanceContainerState({
    this.isVisible = false,
    this.petPost,
    this.calculatedDistance = '',
  });

  DistanceContainerState copyWith({
    bool? isVisible,
    PetPostModel? petPost,
    String? calculatedDistance,
  }) {
    return DistanceContainerState(
      isVisible: isVisible ?? this.isVisible,
      petPost: petPost ?? this.petPost,
      calculatedDistance: calculatedDistance ?? this.calculatedDistance,
    );
  }
}

class DistanceContainerNotifier extends StateNotifier<DistanceContainerState> {
  DistanceContainerNotifier() : super(DistanceContainerState());

  void showContainer(PetPostModel petPost, String distance) {
    state = state.copyWith(
      isVisible: true,
      petPost: petPost,
      calculatedDistance: distance,
    );
  }

  void hideContainer() {
    state = state.copyWith(isVisible: false);
  }
}

final distanceContainerProvider = StateNotifierProvider<DistanceContainerNotifier, DistanceContainerState>((ref) {
  return DistanceContainerNotifier();
});
