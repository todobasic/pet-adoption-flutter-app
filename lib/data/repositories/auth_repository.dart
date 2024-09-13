import 'package:firebase_auth/firebase_auth.dart';

class AuthRepository {
  const AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> get authStateChange => _auth.idTokenChanges();

  User? get currentUser => _auth.currentUser;

    Future<User?> signInWithEmailAndPassword(
        String email, String password) async {
      try {
        final result = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        return result.user;
      } on FirebaseAuthException catch (e) {
        print(e.code);
        if (e.code == 'invalid-email') {
          throw AuthException('Incorrect e-mail provided.');
        } else if (e.code == 'invalid-credential') {
          throw AuthException('User not found.');
        } else {
          throw AuthException('An error occured. Please try again later.');
        }
      }
    }

    Future<User?> createUserWithEmailAndPassword(String email, String password) async {
      try {
        final result = await _auth.createUserWithEmailAndPassword(
          email: email, 
          password: password,
        );
        return result.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          throw AuthException('The email is already in use.');
        } else if (e.code == 'weak-password') {
          throw AuthException('The password provided is too weak.');
        } else {
          throw AuthException('An error occurred. Please try again later.');
        }
      }
    }  

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}