import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';
import 'package:pet_adoption/data/providers/user_repository_provider.dart';
import 'package:pet_adoption/data/repositories/auth_repository.dart';
import 'package:pet_adoption/data/repositories/user_repository.dart';

class ProfileService {
  final UserRepository userRepository;
  final AuthRepository authRepository;

  ProfileService(this.userRepository, this.authRepository);

  Future<bool> checkProfileCompletion(String userId) async {
    return await userRepository.isProfileComplete(userId);
  }
}

final profileServiceProvider = Provider<ProfileService>((ref) {
  return ProfileService(
    ref.read(userRepositoryProvider), 
    ref.read(authRepositoryProvider),
  );
});
