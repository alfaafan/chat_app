import 'package:firebase_auth/firebase_auth.dart';

abstract class UserRepositoryInterface {
  Future<User?> signInWithEmailAndPassword(String email, String password);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
}
