import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/repositories/liked_posts_repository.dart';

class LikedPostsNotifier extends StateNotifier<bool> {
  final LikedPostsRepository _likesRepository;
  final String? userId;
  final String postId;

  LikedPostsNotifier(this.userId, this.postId, this._likesRepository) : super(false) {
    _checkIfLiked();
  }

  Future<void> _checkIfLiked() async {
    if (userId != null) {
      final isLiked = await _likesRepository.hasUserLikedPost(userId!, postId);
      state = isLiked;
    }
  }

  Future<void> likePost() async {
    if (userId != null) {          
      try {        
        print('Liking post: $postId'); 
        state = true;  
        print('State after like: $state'); 
        await _likesRepository.likePost(userId!, postId);        
      } catch (e) {
        state = false;
        print('Error liking post: $e'); 
      }      
    }
  }

  Future<void> unlikePost() async {
    if (userId != null) {  
      try {
        print('Unliking post: $postId'); 
        state = false;  
        print('State after unlike: $state'); 
        await _likesRepository.unlikePost(userId!, postId);          
      } catch (e) {
        state = true;
        print('Error unliking post: $e'); 
      }         
    }
  }
}

final likesRepositoryProvider = Provider<LikedPostsRepository>((ref) {
  return LikedPostsRepository();
});

final likedPostsProvider = StateNotifierProvider.family<LikedPostsNotifier, bool, String>((ref, postId) {
  final user = ref.watch(authStateProvider).value;
  final repository = ref.watch(likesRepositoryProvider);
  return LikedPostsNotifier(user?.uid, postId, repository);
});

