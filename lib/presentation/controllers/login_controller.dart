import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pet_adoption/data/providers/user_repository_provider.dart';
import 'package:pet_adoption/presentation/controllers/login_state.dart';
import 'package:pet_adoption/domain/providers/auth_provider.dart';

class LoginController extends StateNotifier<LoginState> {
  LoginController(this.ref) : super(const LoginStateInitial());

  final Ref ref;

  void login(String email, String password) async {    
    state = const LoginStateLoading();
    try {
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(
            email,
            password,
          );
      state = const LoginStateSuccess();
    } catch (e) {
      state = LoginStateError(e.toString());
    }      
  }

  void register(String email, String password) async {
    state = const LoginStateLoading();
    try {
      final user = await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(
            email,
            password,
          );
      if (user != null) {
        await ref.read(userRepositoryProvider).createUserProfile(user.uid);
        state = const LoginStateSuccess();
      } else {
        throw Exception('User registration failed');
      }
    } catch (e) {
      state = LoginStateError(e.toString());      
    }
  }  
}

final loginControllerProvider =
    StateNotifierProvider<LoginController, LoginState>((ref) {
  return LoginController(ref);
});